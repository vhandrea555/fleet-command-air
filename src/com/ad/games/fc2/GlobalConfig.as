package com.ad.games.fc2
{
	import com.ad.games.fc2.model.Nation;
	
	import flash.display.StageQuality;

	public class GlobalConfig
	{
		public static const UPDATE_TIMEOUT_NORMAL:uint = 20;
		public static const UPDATE_TIMEOUT_LOW:uint = 40;
		public static const QUALITY_NORMAL:String = StageQuality.HIGH;
		public static const DEFAULT_ANTIALIASING:uint = 1;
		public static const SHOW_RENDERER_STATS:Boolean = true;
		public static const SHOW_CONSOLE:Boolean = true;
		
		//TODO: move to config
		
		public static const NATIONS:Array = new Array(new Nation(0, "German", 0xF00000), new Nation(0, "Russian", 0xF00000));
		public static const DEFAULT_NATION_ID:int = 0;
		
		//Map related		
		public static const MOUSE_WHEEL_SPEED:uint = 30;
		public static const MAP_CURSOR_BORDER:uint = 2;
		public static const MAP_CELL_SIZE:uint = 50;
	}
}