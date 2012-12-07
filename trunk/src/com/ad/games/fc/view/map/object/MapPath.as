package com.ad.games.fc.view.map.object
{
	import com.ad.games.fc.utils.path.Path;
	import com.ad.games.fc.utils.path.PathPoint;
	import com.ad.games.fc.view.base.BaseView;
	import com.ad.games.fc.view.map.Map;
	import com.ad.games.fc.view.map.MapCell;
	
	import flash.display.Graphics;
	
	public final class MapPath extends BaseView
	{
		private var _pathes:Vector.<Path>;
		private var _object:MapLayerMovingObject;
		private var _maxLength:Number;
		private var _length:Number;
		private var _cells:Vector.<MapCell>;
		
		public function MapPath(object:MapLayerMovingObject)
		{
			super();
			_pathes = new <Path>[];
			_cells = new <MapCell>[];
			_object = object;
			clear();			
		}
		
		protected override function draw():void
		{
			super.draw();
		}
		
		public override function update():void
		{
			super.update();
			
			graphics.clear();
			
			for (var i:int = 0; i<_pathes.length; i++) {
				drawPath(graphics, Path(_pathes[i]));
			}
		}
		
		public function updatePathes():void
		{
			var point:PathPoint = new PathPoint(0, 0, _object.getMapShape().rotation);
			var path:Path;
			_length = 0;
			for (var i:uint = 0; i<_pathes.length; i++) {
				path = _pathes[i]; 
				path.setStart(point);
				path.setMaxLength(_maxLength - _length);
				path.update();
				point = path.getLastPoint();
			}
		}
		
		public function addPoint(point:PathPoint):void
		{
			var path:Path = new Path(_object.getMaxSpeed(), _object.getMaxAngleSpeed(), _object.getAcceleration());
			
			if (_pathes.length == 0) {
				path.setStart(new PathPoint(0, 0, _object.getMapShape().rotation));				
			} else {
				var p:Path = Path(_pathes[_pathes.length - 1]);
				path.setStart(p.getLastPoint());
			}
			
			path.setEnd(point);
			path.setMaxLength(_maxLength - _length);
			_pathes.push(path);
			
			path.update();
			
			_length += path.getLength();
			
			var cell:MapCell = Map.getInstance().getCellAt(point.x + _object.x, point.y + _object.y);
			_cells.push(cell);
			cell.select(true);
		}
				
		public function removePoint(point:PathPoint):void
		{
			var index:int = getPointIndex(point);
			if (index > -1) {
				for (var i:uint = index; i<_pathes.length; i++) {
					_length -= _pathes[i].getLength();
				}
				_pathes.length = index;
				for (var j:uint = index; j<_cells.length; j++) {
					_cells[j].select(false);
				}				
			}
		}
		
		public function hasPoint(point:PathPoint):Boolean
		{
			return getPointIndex(point) > -1;			
		}
		
		public function getPointIndex(point:PathPoint):int
		{
			var index:int = -1;
			for (var i:uint = 0; i<_pathes.length; i++) {
				if (point.equals(_pathes[i].getEnd())) {
					index = i;
					break;
				}				
			}
			return index;
		}
		
		public function clear():void
		{
			_pathes.length = 0;
			for (var i:uint = 0; i<_cells.length; i++) {
				_cells[i].select(false);
			}
			_cells.length = 0;
			_length = 0;
			update();
		}
		
		public static function drawPath(graphics:Graphics, path:Path, dX:Number = 0, dY:Number = 0):void
		{
			for (var i:uint=0; i<path.getPointsCount(); i++) {
				var point:PathPoint = path.getPointAt(i);
				graphics.lineStyle(1, 0xFF0000);					
				graphics.lineTo(point.x + dX, point.y + dY);			
			}
		}
		
		public function getLastPoint():PathPoint
		{
			return (_pathes.length > 0) ? PathPoint(_pathes[_pathes.length - 1].getLastPoint()) : new PathPoint(0, 0, _object.getMapShape().rotation);
		}
		
		public function setMaxLength(maxLength:Number):void
		{
			_maxLength = maxLength;
		}
		
		public function getLength():Number
		{
			return _length;
		}
		
		public function getMaxLength():Number
		{
			return _maxLength;
		}
		
		public function getFullPath():Path
		{
			var path:Path = new Path(_object.getMaxSpeed(), _object.getMaxAngleSpeed(), _object.getAcceleration());
			for (var i:uint = 0; i<_pathes.length; i++) {
				path.setPoints(path.getPoints().concat(_pathes[i].getPoints()));
			}
			return path;						
		}
		
		public function getPathes():Vector.<Path>
		{
			return _pathes;
		}
		
		public function getPath(index:uint):Path
		{
			return Path(_pathes[index]);
		}
		
		public function getCells():Vector.<MapCell>
		{
			return _cells;
		}
	}
}