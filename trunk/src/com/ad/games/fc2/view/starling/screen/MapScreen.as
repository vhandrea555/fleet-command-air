package com.ad.games.fc2.view.starling.screen
{
	import com.ad.games.fc2.config.ConfigLoader;
	import com.ad.games.fc2.config.MapConfig;
	import com.ad.games.fc2.view.starling.base.BaseScreen;
	import com.ad.games.fc2.view.starling.map.MapView;
	import com.ad.games.fc2.view.starling.map.MiniMap;
	import com.ad.games.fc2.view.utils.DeviceProperties;
	
	import starling.events.Event;
	
	public final class MapScreen extends BaseScreen
	{
		private var _map:MapView;
		private var _miniMap:MiniMap;
		
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
			
			_miniMap = new MiniMap(_map);
			addChild(_miniMap);
			_miniMap.update();
			_miniMap.y = 0;
			_miniMap.x = DeviceProperties.getScreenSize().width - _miniMap.width;
			
			_map.addEventListener(MapView.EVENT_MAP_UPDATE, onMapUpdate);
		}
		
		private function onMapUpdate(e:Event):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			_miniMap.update();
		}		
	}
}