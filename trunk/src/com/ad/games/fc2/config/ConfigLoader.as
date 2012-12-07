package com.ad.games.fc2.config
{
	import com.ad.games.fc2.view.starling.map.MapView;
	
	public final class ConfigLoader
	{
		public static function loadMap(mapData:Object):MapView
		{			
			var map:MapView = new MapView(mapData.cols, mapData.rows);
			return map;
		}
	}
}