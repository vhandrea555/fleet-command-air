package com.ad.games.fc2.view.starling.map.object
{


	public class MapLayerMovingObject extends MapLayerObject
	{
		public static const EVENT_ONMOVE:String = "onMove";
		public static const EVENT_ONSELECT:String = "onSelect";
		public static const MODE_ANIMATION:uint = 2;
		public static const MOVE_DELAY:uint = 2000;
		
		protected var _acceleration:Number = 0;
		protected var _maxSpeed:Number = 0;
		protected var _speed:Number = 0;
		protected var _maxAngleSpeed:Number = 0;
		protected var _showPath:Boolean = false;
		protected var _movePath:Path;
		protected var _displayPath:Path;		
		protected var _pathIndex:uint = 0;		
		protected var _path:MapPath;
		protected var _startX:Number = 0;
		protected var _startY:Number = 0;
		
		protected static var _timer:Timer;
		protected static var _movingCount:uint = 0; 
				
		public static const STATE_DEFAULT:uint = 0;
		public static const STATE_MOVING:uint = 1;
		
		protected var _state:uint = STATE_DEFAULT;
		
		protected static var _mapLayerMovingObjects:Vector.<MapLayerMovingObject> = new Vector.<MapLayerMovingObject>;
		
		public function MapLayerMovingObject(layer:MapLayer)
		{
			super(layer);
			_movePath = new Path(getMaxSpeed(), getMaxAngleSpeed(), getAcceleration());			
			_displayPath = new Path(getMaxSpeed(), getMaxAngleSpeed(), getAcceleration());
			_movePath.setMaxLength(2*_maxSpeed*MapCell.SIZE);			
			_path = new MapPath(this);
			_path.setMaxLength(2*_maxSpeed*MapCell.SIZE);			
			_timer = new Timer(Application.UPDATE_TIMEOUT_LOW, 0);
			_mapLayerMovingObjects.push(this);
		}
		
		protected override function draw():void
		{
			super.draw();
			addChild(_path);
			_path.x = MapCell.SIZE/2;
			_path.y = MapCell.SIZE/2;
		}
		
		public override function select(select:Boolean = true):void
		{
			super.select(select);
			
			if (_selected) {
				_layer.addEventListener(Map.EVENT_MOUSE_UP, onCellMouseUp);
				Map.getInstance().addEventListener(Map.EVENT_ACTIVE_CELL, onActiveCell);
				Map.getInstance().getCursor().setState(MapCursor.STATE_ORDER);
			} else {
				_layer.removeEventListener(Map.EVENT_MOUSE_UP, onCellMouseUp);
				Map.getInstance().removeEventListener(Map.EVENT_ACTIVE_CELL, onActiveCell);
				Map.getInstance().getCursor().setState(MapCursor.STATE_SELECT);
			}
		}
		
		/* Events handling */
		
		protected function onCellMouseUp(e:Event):void
		{
			if (_selected) {
				var cell:MapCell = Map.getInstance().getActiveCell();
				if (cell != _cell) {
					if (Map.getInstance().getCursor().getState() != MapCursor.STATE_RESTRICTED) {
						var point:PathPoint = cell.getPathPoint().substract(getPathPoint());
						if (cell.isSelected() && !_path.getLastPoint().equals(point)) {
							_path.removePoint(point);
							_path.update();
						} else if (cell.isSelected()) {
							//move();
						} else {
							pathToCell(cell);
						}
					} else if (Map.getInstance().getCursor().getState() == MapCursor.STATE_RESTRICTED) {
						_layer.deSelectObject();
					}
				}
			}
		}
		
		protected function onActiveCell(e:Event):void
		{
			if (_selected) {
				var cell:MapCell = Map.getInstance().getActiveCell();
				var dX:Number = cell.x - _path.getLastPoint().add(getPathPoint()).x;
				var dY:Number = cell.y - _path.getLastPoint().add(getPathPoint()).y;
				var radius:Number = Geometry.getRadius(-dX, -dY);
				
				if ((radius > (_path.getMaxLength() - _path.getLength()))) {						
					_showPath = false;
				} else {
					if (_layer.getActiveObject() == null && !_timer.running) {
						_showPath = true;
					} else {
						_showPath = false;
					}					
				}
				
				update();
			}
		}
		
		/* Path related */
		
		public override function update():void
		{
			super.update();
			
			if (_selected) {
				if (Map.getInstance().getMode() == Map.MODE_DEFAULT) {					
					var cell:MapCell = Map.getInstance().getActiveCell();
					if (cell.isSelected() && _path.hasPoint(cell.getPathPoint().substract(getPathPoint()))) {
						Map.getInstance().getCursor().setState(MapCursor.STATE_ORDER);					
					} else if (_showPath && _cell != cell && _state != STATE_MOVING) {
						_displayPath.setStart(_path.getLastPoint());
						_displayPath.setEnd(
							cell.getPathPoint().substract(getPathPoint())
						);
						_displayPath.getEnd().speed = 0;
						_displayPath.setMaxLength(_path.getMaxLength() - _path.getLength());
						_displayPath.update();
						
						if (_displayPath.getPointsCount() != 0 && _displayPath.getLength() <= ((_path.getMaxLength() - _path.getLength()))) {
							graphics.clear();
							graphics.moveTo(_displayPath.getStart().x + MapCell.SIZE/2, _displayPath.getStart().y + MapCell.SIZE/2);
							MapPath.drawPath(graphics, _displayPath, MapCell.SIZE/2, MapCell.SIZE/2);
							if (Map.getInstance().getCursor().getState() != MapCursor.STATE_ORDER) {
								Map.getInstance().getCursor().setState(MapCursor.STATE_ORDER);
							}
						} else if (Map.getInstance().getCursor().getState() != MapCursor.STATE_RESTRICTED) {
							graphics.clear();
							Map.getInstance().getCursor().setState(MapCursor.STATE_RESTRICTED);
						}
					} else if (Map.getInstance().getCursor().getState() != MapCursor.STATE_RESTRICTED) {
						graphics.clear();
						Map.getInstance().getCursor().setState(MapCursor.STATE_RESTRICTED);
					}
				}
			}
		}
		
		public function pathToCell(cell:MapCell):void
		{
			var point:PathPoint = cell.getPathPoint().substract(getPathPoint());
			var index:int = _path.getPointIndex(point);
			point.speed = _maxSpeed;
			
			if (index == -1) {
				_path.addPoint(point);
			}
			
			_path.update();			
		}
		
		/* Move related */
		
		protected function move():void
		{
			if (_state == STATE_DEFAULT) {
				_cell.select(false);
				
				_pathIndex = 0;
				
				if (_path.getLength() > 0) {
					var _cells:Vector.<MapCell> = _path.getCells();
					for (var i:uint = 0; i<_cells.length; i++) {
						_cells[i].select(false);
					}
					
					_startX = x;
					_startY = y;
					
					var path:Path = _path.getPath(_path.getPathes().length-1);
					path.getEnd().speed = 0;
					_path.updatePathes();
					_movePath = _path.getFullPath();
					_movePath.setEnd(path.getEnd());
					_path.visible = false;
					_state = STATE_MOVING;
					_movingCount++;
				} else {
					onArrival();
				}
			}
		}
		
		public function getPathLength():uint
		{
			return _path.getLength();
		}
		
		protected function propagate():void
		{
			if (_state == STATE_MOVING) {
				if (_pathIndex < _movePath.getPointsCount()) {
					var point:PathPoint = _movePath.getPointAt(_pathIndex);
					
					x = point.x + _startX;
					y = point.y + _startY;
					
					_shape.rotation = point.rotation;
					_speed = point.speed;

					_pathIndex++;
					
					onPropagate(point);
				} else if (_pathIndex == _movePath.getPointsCount()) {
					arrived();
				}
			}
		}
		
		protected function arrived():void
		{
			if (_state != STATE_DEFAULT) {
				_state = STATE_DEFAULT;
				
				/*
				var p:PathPoint = _movePath.getEnd().add(_cell.getPathPoint());
				
				x = Math.round(p.x);
				y = Math.round(p.y);
				*/
				
				//_cell = _path.getCells()[_path.getCells().length - 1];
				_cell = Map.getInstance().getCellAt(x + MapCell.SIZE/2, y + MapCell.SIZE/2);
				
				_path.clear();
				_path.update();
				_path.visible = true;
				
				_movingCount--;
				_pathIndex = 0;
				_movePath.getPoints().length = 0;
				_speed = 0;
				onArrival();
			}
		}
		
		protected function onPropagate(point:PathPoint):void
		{
			//On propagate event handler
		}
		
		protected function onArrival():void
		{
			//On arrival event handler
		}		
		
		public function getAcceleration():Number
		{
			return _acceleration;
		}
		
		public function getMaxSpeed():Number
		{
			return _maxSpeed;
		}

		public function getMaxAngleSpeed():Number
		{
			return _maxAngleSpeed;
		}
		
		public function getPathPoint():PathPoint
		{
			//var point:PathPoint = _cell.getPathPoint();
			var point:PathPoint = new PathPoint(x, y);
			point.rotation = _shape.rotation;
			return point;
		}
		
		public override function setMode(mode:uint):void
		{
			if (_mode != mode) {
				switch(mode) {
					case MODE_NORMAL:
						update();
						break;
					case MODE_TRANSFORMATION:
						graphics.clear();
						break;
				}
			}
			super.setMode(mode);
		}
				
		public function getState():uint
		{
			return _state;
		}
		
		public function getSpeed():Number
		{
			return _speed;
		}
		
		/* Static routine */
		
		public static function move():void
		{
			for (var i:uint = 0; i<_mapLayerMovingObjects.length; i++) {
				if (_mapLayerMovingObjects[i].getPathLength() > 0) {
					_mapLayerMovingObjects[i].move();
				}
			}
			
			if (!_timer.running) {
				setTimeout(function():void {
					_timer.addEventListener(TimerEvent.TIMER, _propagate);
					_timer.start();
				}, MOVE_DELAY);
			}
		}
		
		protected static function _propagate(e:TimerEvent):void
		{
			if (_movingCount == 0) {
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _propagate);
				for (var j:uint = 0; j < _mapLayerMovingObjects.length; j++) {
					_mapLayerMovingObjects[j].setMode(MODE_NORMAL);
				}
			} else {
				for (var i:uint = 0; i < _mapLayerMovingObjects.length; i++) {
					_mapLayerMovingObjects[i].propagate();
				}
			}
		}
		
		public static function getMovingCount():uint
		{
			return _movingCount;
		}
		
		public static function setUpdateTimeout(delay:Number):void
		{
			_timer.delay = delay;
		}
		
		public static function getMapLayerMovingObjects():Vector.<MapLayerMovingObject>
		{
			return _mapLayerMovingObjects;
		}
	}
}