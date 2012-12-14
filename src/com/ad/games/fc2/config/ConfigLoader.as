package com.ad.games.fc2.config
{
	import com.ad.games.fc2.model.ship.Ship;
	import com.ad.games.fc2.view.starling.map.MapLayer;
	import com.ad.games.fc2.view.starling.map.MapView;
	import com.ad.games.fc2.view.starling.map.object.MapLayerObject;
	import com.ad.games.fc2.view.starling.map.object.ShipMapLayerObject;
	
	public final class ConfigLoader
	{
		public static function loadMap(mapData:Object):MapView
		{			
			var map:MapView = new MapView(mapData.cols, mapData.rows);
			
			var object:MapLayerObject;
			var objectData:Object;
			var layer:MapLayer;
			var ship:Ship;
			var t:ShipMapLayerObject;
			/*
			for (var l:uint = 0; l<mapData.layers.length; l++) {
				layer = map.getLayer(map.addLayer());
				
				for (var o:uint = 0; o<mapData.layers[l].objects.length; o++) {
					objectData = mapData.layers[l].objects[o];
					object = null;
					switch(objectData._class) {
						case "ShipMapLayerObject":
							ship = loadShip(objectData.ship.type, objectData.ship.name);
							object = new ShipMapLayerObject(layer, ship);
							break;
					}
					map.placeObject(object, map.getCell(objectData.col, objectData.row));
				}
			}			
			*/
			return map;
		}
	}
}