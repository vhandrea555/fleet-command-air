package com.ad.games.fc.view.map
{
	import com.ad.games.fc.view.base.BaseView;
	
	public final class MapCursor extends BaseView
	{
		private static var _map:Map;
		
		public static const STATE_SELECT:uint = 0xFFFF00;
		public static const STATE_ORDER:uint = 0x00FF00;
		public static const STATE_RESTRICTED:uint = 0x0;
		public static const STATE_TARGET:uint = 0xFF0000;
		
		private var _state:uint; 
		
		public function MapCursor(map:Map)
		{			
			super();
			_map = map;			
		}
		
		protected override function draw():void
		{
			super.draw();
			setState(_state);
			cacheAsBitmap = true;
		}
		
		public function setState(state:uint):void
		{
			if (_state != state) {	
				_state = state;
				
				graphics.clear();
				graphics.lineStyle(2, _state);
				graphics.drawCircle(MapCell.SIZE/2, MapCell.SIZE/2, MapCell.SIZE/2);				
			}
		}
		
		public function getState():uint
		{
			return _state;
		}
		
		public function placeTo(cell:MapCell):void
		{
			this.update();
			
			if (cell.x != x || cell.y != y) {
				x = cell.x;
				y = cell.y;
			}
		}
	}
}