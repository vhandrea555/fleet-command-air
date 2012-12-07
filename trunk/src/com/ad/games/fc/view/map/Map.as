package com.ad.games.fc.view.map
{
	import com.ad.games.fc.Application;
	import com.ad.games.fc.view.base.BaseView;
	import com.ad.games.fc.view.map.object.MapLayerObject;
	import com.ad.games.fc.view.utils.Rasterizer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	
	public final class Map extends BaseView
	{
		public static const EVENT_ACTIVE_CELL:String = "onActiveCell";
		public static const EVENT_MOUSE_UP:String = "onMapMouseUp";
		public static const EVENT_MOUSE_DOWN:String = "onMapMouseDown";
		public static const EVENT_MAP_UPDATE:String = "onMapUpdate";
		private static const MOUSE_WHEEL_SPEED:Number = 30; 
		
		private static var _layers:Vector.<MapLayer>;
		private static var _layersContainer:Sprite;
		private static var _selectionContainer:Sprite;
		private static var _rows:uint = 0;
		private static var _cols:uint = 0;
		private static var _cursor:MapCursor;
		
		private static var _cells:Vector.<MapCell>;
		private static var _activeCell:MapCell;
		
		private static var _mouseX:Number = 0;
		private static var _mouseY:Number = 0;
		
		public static const MODE_DEFAULT:uint = 0;
		public static const MODE_DRAG:uint = 1;
		public static const MODE_SCALE:uint = 2;
		public static const MODE_TRANSFORMATION_PREPARE:uint = 3;
		public static const MODE_TRANSFORMATION_READY:uint = 4;
		
		private static var _mode:uint = MODE_DEFAULT;
		
		private static const SCALE_MIN:Number = 0.25;
		private static const SCALE_MAX:Number = 4;
		
		private static var _instance:Map;
		
		public function Map(cols:uint, rows:uint)
		{
			super();
			_rows = rows;
			_cols = cols;
			_layers = new <MapLayer>[];
			_cells = new <MapCell>[];
			
			_layersContainer =  new Sprite();
			_cursor = new MapCursor(this);
			_selectionContainer = new Sprite();
			
			for (var r:uint=0; r<_rows; r++) {
				for (var c:uint=0; c<_cols; c++) {
					var cell:MapCell = new MapCell(c, r, this);
					cell.x = c*MapCell.SIZE;
					cell.y = r*MapCell.SIZE;
					_cells.push(cell);
				}
			}
			
			_instance = this;
		}
		
		protected override function draw():void
		{
			super.draw();
			
			var _width:Number = _cols*MapCell.SIZE;
			var _height:Number = _rows*MapCell.SIZE;
								
			var _bg:Sprite = new Sprite();
			_bg.graphics.lineStyle(0.5, 0x3399FF);
			
			for (var i:uint = 0; i<_rows; i++) {
				_bg.graphics.moveTo(0, i*MapCell.SIZE);
				_bg.graphics.lineTo(_width, i*MapCell.SIZE);
			}
			for (var j:uint = 0; j<_cols; j++) {
				_bg.graphics.moveTo(j*MapCell.SIZE, 0);
				_bg.graphics.lineTo(j*MapCell.SIZE, _height);
			}
			
			_bg.opaqueBackground = 0x0066FF;
			
			var _bgBMP:DisplayObject = Rasterizer.toBitmap(_bg, 0);
			//BaseView.cache(_bgBMP);
			_bg = null;
			addChild(_bgBMP);
			
			//BaseView.cache(_bg);
			//addChild(_bg);
			
			addChild(_selectionContainer);
			addChild(_layersContainer);
			addChild(_cursor);

			width = _width; 
			height = _height;
			
			_cursor.setState(MapCursor.STATE_SELECT);
			_cursor.update();
			
//			_timer = new Timer(Application.UPDATE_TIMEOUT_NORMAL, 0);			
//			_timer.addEventListener(TimerEvent.TIMER, checkMouseMove);
//			_timer.start();
			setInterval(checkMouseMove, Application.UPDATE_TIMEOUT_NORMAL);
						
			if (Application.isTouchInterface()) {
				stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, _onZoom);
			} else {
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			}
						
			stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		public function addLayer():uint
		{
			var mapLayer:MapLayer = new MapLayer();
			return (_layers.push(mapLayer) - 1);
		}
		
		public function placeObject(object:MapLayerObject, cell:MapCell):void
		{
			object.placeTo(cell);
		}
		
		public function getLayer(z:uint):MapLayer
		{
			return _layers[z];
		}
		
		public function getCursor():MapCursor
		{
			return _cursor;
		}
		
		public function getCell(col:uint, row:uint):MapCell
		{
			var i:uint = row*_cols + col;
			return (i < _cells.length) ? _cells[i] : null;
		}
		
		public function getRows():uint
		{
			return _rows;
		}
		
		public function getCols():uint
		{
			return _cols;
		}
		
		private function getSelectedObjects():Vector.<MapLayerObject>
		{
			var objects:Vector.<MapLayerObject> = new <MapLayerObject>[];
			var object:MapLayerObject = null;
			
			for (var i:uint = 0; i<_layers.length; i++) {
				object = _layers[i].getSelectedObject();
				if (object != null) {
					objects.push(object);
				}
			}
			
			return objects;
		}
		
		public function getObjectsAtCell(cell:MapCell):Vector.<MapLayerObject>
		{
			var objects:Vector.<MapLayerObject> = new <MapLayerObject>[];
			var object:MapLayerObject = null;
			
			for (var i:uint = 0; i<_layers.length; i++) {
				object = _layers[i].getObjectAtCell(cell)
				if (object != null) {
					objects.push(object);
				}
			}
			
			return objects;
		}
		
		private function updateActiveCell():void
		{
			var cell:MapCell = _getActiveCell();
			
			if (cell != null) {
				activateCell(cell);
			}			
		}
		
		private function activateCell(cell:MapCell):void
		{
			if (cell != _activeCell) {
				_activeCell = cell;
				_cursor.placeTo(cell);
				dispatchEvent(new Event(EVENT_ACTIVE_CELL));
			}
		}
		
		public function getActiveCell():MapCell
		{
			return _activeCell;
		}
		
		private function _getActiveCell():MapCell
		{
			return getCellAt(mouseX, mouseY);
		}
		
		public function getCellAt(_x:Number, _y:Number):MapCell {
			var col:Number = Math.round((_x - MapCell.SIZE/2)/MapCell.SIZE); 
			var row:Number = Math.round((_y - MapCell.SIZE/2)/MapCell.SIZE);
			
			return getCell(col, row);
		}
		
		public override function update():void
		{
			super.update();
			
			for (var i:uint = 0; i<_layers.length; i++) {
				_layers[i].update();
			}
		}
		
		/*
		 * Map zooming/scaling logics
		 */
		
		private function _onMouseWheel(e:MouseEvent):void
		{
			if (isReadyForTransformation()) {
				_stopDrag();
				
				onBeforeTransformation();
				prepareForTransformation();
				
				scale(scaleX * (1 + e.delta / MOUSE_WHEEL_SPEED), mouseX, mouseY);
				
				onAfterTransformation();				
			}
		}
		
		private function _onZoom(e:TransformGestureEvent):void
		{
			if (isReadyForTransformation()) {
				switch(e.phase) {
					case GesturePhase.BEGIN:
						_stopDrag();
						onBeforeTransformation();
						prepareForTransformation();
						_mode = MODE_SCALE;
						break;
					case GesturePhase.END:
						onAfterTransformation();
						break;
					case GesturePhase.UPDATE:
						dispatchEvent(new Event(EVENT_MAP_UPDATE));
						break;
				}
				
				if (_mode == MODE_SCALE) {
					var _scale:Number = (e.scaleX + e.scaleY)/2;
					scale(scaleX * _scale, mouseX, mouseY);
				}
			}
		}
		
		private function _onMouseDown(e:Event):void
		{
			if (isReadyForTransformation()) {
				onBeforeTransformation();
			}
			
			e.stopPropagation();
			e.stopImmediatePropagation();
			e.preventDefault();
		}
		
		private function _onMouseUp(e:Event):void
		{
			onAfterTransformation();
			e.stopPropagation();
			e.stopImmediatePropagation();
			e.preventDefault();
		}

		private function onBeforeTransformation():void
		{
			if (_mode == MODE_DEFAULT) {
				updateActiveCell();
				_mode = MODE_TRANSFORMATION_PREPARE;
			}
		}

		private function prepareForTransformation():void
		{
			if (_mode == MODE_TRANSFORMATION_PREPARE) {
				//Console.appendLine("prepareForTransformation");
				var objects:Vector.<MapLayerObject> = MapLayerObject.getMapLayerObjects();
				for (var i:uint = 0; i<objects.length; i++) {
					objects[i].setMode(MapLayerObject.MODE_TRANSFORMATION);
				}
			}
		}		
		
		private function onAfterTransformation():void
		{
			if (_mode == MODE_DEFAULT || _mode == MODE_TRANSFORMATION_PREPARE) {
				_mode = MODE_DEFAULT;
				if (_activeCell != null) {
					updateActiveCell();
					dispatchEvent(new Event(EVENT_MOUSE_UP));
				}
			} else if (_mode != MODE_DEFAULT) {
				_stopDrag();
				
				var objects:Vector.<MapLayerObject> = MapLayerObject.getMapLayerObjects();
				for (var i:uint = 0; i<objects.length; i++) {
					objects[i].setMode(MapLayerObject.MODE_NORMAL);
				}
				_mode = MODE_DEFAULT;
				dispatchEvent(new Event(EVENT_MAP_UPDATE));
			}			
		}
		
		private function checkMouseMove(e:TimerEvent = null):void
		{
			if (mouseX != _mouseX || mouseY != _mouseY) {
				_mouseX = mouseX;
				_mouseY = mouseY;
				
				_onMouseMove();
			}
		}
		
		private function _onMouseMove():void
		{
			if (_mode == MODE_TRANSFORMATION_PREPARE) {
				_startDrag();
			} else if (_mode == MODE_DEFAULT) {
				updateActiveCell();
			}
		}		
		
		private function scale(_scale:Number, centerX:Number, centerY:Number):void
		{
			_scale = (_scale < SCALE_MIN) ? SCALE_MIN : _scale;
			_scale = (_scale > SCALE_MAX) ? SCALE_MAX : _scale;
			
			_mode = MODE_SCALE;		
		
			var minScaleX:Number = Application.getSreenWidth() / (width / scaleX);
			var minScaleY:Number = Application.getSreenHeight() / (height / scaleX);
			
			_scale = (_scale < minScaleX) ? minScaleX : _scale;
			_scale = (_scale < minScaleY) ? minScaleY : _scale;
			
			var dScale:Number = _scale - scaleX;
			var newX:Number = x - (centerX)*dScale;
			var newY:Number = y - (centerY)*dScale;
						
			var minX:Number = Application.getSreenWidth() - width;
			var maxX:Number = 0;
			var minY:Number = Application.getSreenHeight() - height;
			var maxY:Number = 0;
			
			newX = (newX < minX) ? minX : newX;
			newX = (newX > maxX) ? maxX : newX;
			newY = (newY < minY) ? minY : newY;
			newY = (newY > maxY) ? maxY : newY;
			
			x = newX;
			y = newY;
			
			scaleX = _scale;
			scaleY = _scale;				
		}		
		
		private function _startDrag():void
		{
			prepareForTransformation();
			_mode = MODE_DRAG;
			startDrag(false, new Rectangle(Application.getSreenWidth() - width, Application.getSreenHeight() - height, width - stage.stageWidth, height - stage.stageHeight));
		}
		
		private function _stopDrag():void
		{
			if (_mode == MODE_DRAG) {				
				stopDrag();				
			}
		}
		
		private function isReadyForTransformation():Boolean
		{
			return (
						(
							getSelectedObjects().length == 0 && Application.isTouchInterface()
						)
						||
						!Application.isTouchInterface()
					)
					&&
					(
						_activeCell == null
						||
						(_activeCell && (getObjectsAtCell(_activeCell).length == 0))
					);
		}
		
		public function getSelectionContainer():Sprite
		{
			return _selectionContainer;
		}
		
		public function getMode():uint
		{
			return _mode;
		}
		
		public static function getInstance():Map
		{
			return _instance;
		}
		
		public function getLayersContainer():Sprite
		{
			return _layersContainer;
		}
	}
}