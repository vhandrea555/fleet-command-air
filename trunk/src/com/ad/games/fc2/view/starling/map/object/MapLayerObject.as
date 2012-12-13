package com.ad.games.fc2.view.starling.map.object
{
	import com.ad.games.fc2.view.starling.base.BaseView;
	import com.ad.games.fc2.view.starling.map.MapCell;
	import com.ad.games.fc2.view.starling.map.MapLayer;
	import com.ad.games.fc2.view.starling.map.object.shape.MapShape;
	
	import starling.display.Sprite;

	public class MapLayerObject extends BaseView
	{
		protected var _selected:Boolean  = false;
		protected var _selectable:Boolean = true;

		protected static const COLOR_SELECTED:uint = 0x00FF00;
		protected static const COLOR_NONE:int = -1;
		protected var _color:int = COLOR_NONE;
		
		public static const MODE_NORMAL:uint = 0;
		public static const MODE_TRANSFORMATION:uint = 1;
		
		protected static var _mapLayerObjects:Vector.<MapLayerObject> = new Vector.<MapLayerObject>;
		
		protected var _selection:Sprite;
		protected var _id:uint;
		
		public function MapLayerObject(layer:MapLayer)
		{
			super();
			_layer = layer;
			layer.addObject(this);
			_id = _mapLayerObjects.push(this) - 1;
		}
		
		protected var _shape:MapShape;
		protected var _layer:MapLayer;
		protected var _cell:MapCell;
		protected var _mode:uint;
		
		public function placeTo(cell:MapCell):void
		{
			_cell = cell;
			x = _cell.x;
			y = _cell.y;
		}
		
		public function getCell():MapCell
		{
			return _cell;
		}
		
		public function getLayer():MapLayer
		{
			return _layer;
		}
		
		public function getMapShape():MapShape
		{
			return _shape;
		}		
		
		protected override function draw():void
		{
			super.draw();
			
			_selection = new Sprite();
			addChild(_selection);
		}
		
/*		public override function update():void
		{
			super.update();
		}
*/		
		public function select(select:Boolean = true):void
		{
			if (_selected != select) {
				_selected = select;
				setColor((_selected) ? COLOR_SELECTED : COLOR_NONE);
			}
		}
		
		public function setColor(color:int):void
		{
			if (_color != color) {
				_color = color;
				//_selection.graphics.clear();				
				if (_color > -1) {
					//_selection.graphics.lineStyle(4, _color);
					//_selection.graphics.drawCircle(GlobalConfig.MAP_CELL_SIZE/2, GlobalConfig.MAP_CELL_SIZE/2, GlobalConfig.MAP_CELL_SIZE/2);				
				}
			}
		}
				
		public function isSelectable():Boolean
		{
			return _selectable;
		}
		
		public function setMode(mode:uint):void
		{
			_mode = mode;
		}
		
		public static function getMapLayerObjects():Vector.<MapLayerObject>
		{
			return _mapLayerObjects;
		}		
	}
}