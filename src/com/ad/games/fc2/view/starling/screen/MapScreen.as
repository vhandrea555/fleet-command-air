package com.ad.games.fc2.view.starling.screen
{
	import com.ad.games.fc2.config.ConfigLoader;
	import com.ad.games.fc2.config.MapConfig;
	import com.ad.games.fc2.view.starling.base.BaseScreen;
	import com.ad.games.fc2.view.starling.map.MapView;
	import com.ad.games.fc2.view.utils.DeviceProperties;
	
	public class MapScreen extends BaseScreen
	{
		private var _map:MapView;
		
		public function MapScreen()
		{
			super();
		}
		
		protected override function draw():void {
			super.draw();
			
			_map = ConfigLoader.loadMap(MapConfig.MAP_DEFAULT);
			addChild(_map);
			_map.setBoundingBox(DeviceProperties.getScreenSize());
			_map.update();			
		}
	}
}