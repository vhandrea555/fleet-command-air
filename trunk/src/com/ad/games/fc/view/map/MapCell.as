package com.ad.games.fc.view.map
{
	import com.ad.games.fc.utils.path.PathPoint;
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public final class MapCell extends Point
	{
		public static const SIZE:uint = 50;
		
		private var _row:uint = 0;
		private var _col:uint = 0;
		private var _shape:Sprite;
		private var _selected:Boolean = false;
		
		public function MapCell(col:uint, row:uint, map:Map)
		{
			this._row = row;
			this._col = col;
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
					_shape.graphics.lineStyle(4, MapCursor.STATE_ORDER);
					_shape.graphics.drawCircle(MapCell.SIZE/2, MapCell.SIZE/2, MapCell.SIZE/2);
					Map.getInstance().getSelectionContainer().addChild(_shape);
				} else {
					_shape.graphics.clear();
					_shape.visible = false;
					Map.getInstance().getSelectionContainer().removeChild(_shape);					
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