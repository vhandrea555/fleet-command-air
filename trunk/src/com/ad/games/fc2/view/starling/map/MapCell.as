package com.ad.games.fc2.view.starling.map
{
	import com.ad.games.fc2.utils.path.PathPoint;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;

	public final class MapCell extends Point
	{
		public static const SIZE:uint = 50;
		
		private var _row:uint = 0;
		private var _col:uint = 0;
		private var _shape:Sprite;
		private var _selected:Boolean = false;
		private var _map:MapView;
		
		public function MapCell(col:uint, row:uint, map:MapView)
		{
			this._row = row;
			this._col = col;
			this._map = map;
		}
		
		public function select(select:Boolean = true):void
		{
			if (_selected != select) {
				if (select) {
					if (_shape == null) {
						_shape = new Sprite();
					}
					_shape.x = x;
					_shape.y = y;
					//_shape.graphics.lineStyle(4, MapCursor.STATE_ORDER);
					//_shape.graphics.drawCircle(MapCell.SIZE/2, MapCell.SIZE/2, MapCell.SIZE/2);
					//_map.getSelectionContainer().addChild(_shape);
				} else {
					//_shape.graphics.clear();
					_shape.visible = false;
					_map.removeChild(_shape);					
					_shape = null;
				}
				_selected = select;
			}
		}
		
		public function getPathPoint():PathPoint
		{
			return new PathPoint(x, y);
		}
		
		public function getShape():Sprite
		{
			return _shape;
		}
		
		public function isSelected():Boolean
		{
			return _selected;
		}
		
		public function getRow():uint
		{
			return _row;
		}

		public function getCol():uint
		{
			return _col;
		}
		
		public override function toString():String
		{
			return ("row " + _row + " col " + _col + " / " + x + "x" + y);
		}
	}
}