package com.ad.games.fc2.view.starling.map
{
	import com.ad.games.fc2.GlobalConfig;
	import com.ad.games.fc2.view.starling.base.BaseView;
	import com.ad.games.fc2.view.utils.Console;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.Texture;

	public final class MapCursor extends BaseView
	{
		public static const STATE_SELECT:uint = 0xFFFF00;
		public static const STATE_ORDER:uint = 0x00FF00;
		public static const STATE_RESTRICTED:uint = 0x0;
		public static const STATE_TARGET:uint = 0xFF0000;
		
		private var _state:uint;
		
		private var _statesShapes:Array;
		
		public function MapCursor()
		{			
			super();
		}
		
		protected override function draw():void
		{
			super.draw();
						
			_statesShapes = new Array();
			
			var sprite:Sprite = new Sprite();
			
			_statesShapes[STATE_SELECT] = getTexture(sprite, STATE_SELECT);
			_statesShapes[STATE_ORDER] = getTexture(sprite, STATE_ORDER);
			_statesShapes[STATE_RESTRICTED] = getTexture(sprite, STATE_RESTRICTED);
			_statesShapes[STATE_TARGET] = getTexture(sprite, STATE_TARGET);
			
			setState(_state);
		}
		
		private function getTexture(sprite:Sprite, state:uint):Image {
			sprite.graphics.clear();
			sprite.graphics.lineStyle(GlobalConfig.MAP_CURSOR_BORDER, state);
			sprite.graphics.drawCircle(GlobalConfig.MAP_CELL_SIZE/2-GlobalConfig.MAP_CURSOR_BORDER/2, GlobalConfig.MAP_CELL_SIZE/2-GlobalConfig.MAP_CURSOR_BORDER/2, GlobalConfig.MAP_CELL_SIZE/2-(GlobalConfig.MAP_CURSOR_BORDER));
			sprite.opaqueBackground = 0x0066FF;
			var bitmap:BitmapData = new BitmapData(GlobalConfig.MAP_CELL_SIZE-GlobalConfig.MAP_CURSOR_BORDER, GlobalConfig.MAP_CELL_SIZE-GlobalConfig.MAP_CURSOR_BORDER);
			bitmap.draw(sprite);			
			var texture:Texture = Texture.fromBitmapData(bitmap);
			var image:Image = new Image(texture);
			image.blendMode = BlendMode.NONE;
			image.pivotX = -GlobalConfig.MAP_CURSOR_BORDER;
			image.pivotY = -GlobalConfig.MAP_CURSOR_BORDER;
			return image;
		}
		
		public function setState(state:uint):void
		{
			if (_state != state) {
				if (numChildren > 0) {
					removeChild(_statesShapes[_state], false);
				}				
				_state = state;
				addChild(_statesShapes[_state]);
			}
		}
		
		public function getState():uint
		{
			return _state;
		}
		
		public function placeTo(cell:MapCell):void
		{
			update();
			
			if (cell.x != x || cell.y != y) {
				x = cell.x;
				y = cell.y;
			}
		}
	}
}