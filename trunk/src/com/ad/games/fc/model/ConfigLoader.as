package com.ad.games.fc.model
{
	import com.ad.games.fc.Resources;
	import com.ad.games.fc.config.ShipConfig;
	import com.ad.games.fc.model.ship.Ship;
	import com.ad.games.fc.model.ship.equipment.Equipment;
	import com.ad.games.fc.model.ship.equipment.Turret;
	import com.ad.games.fc.view.map.Map;
	import com.ad.games.fc.view.map.MapLayer;
	import com.ad.games.fc.view.map.object.MapLayerObject;
	import com.ad.games.fc.view.map.object.ShipMapLayerObject;
	import com.ad.games.fc.view.map.object.shape.MapEquipmentShape;
	import com.ad.games.fc.view.utils.Rasterizer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	public final class ConfigLoader
	{
		public static function loadMap(mapData:Object):Map
		{			
			var map:Map = new Map(mapData.cols, mapData.rows);
			var object:MapLayerObject;
			var objectData:Object;
			var layer:MapLayer;
			var ship:Ship;
			
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
			
			return map;
		}
		
		public static function loadShip(type:String, name:String):Ship
		{			
			var shipData:Object = ShipConfig.SHIPS[type];
			var ship:Ship = new Ship(name, type, shipData._class, Nation.getNation(shipData.nation));
			ship.setMaxSpeed(shipData.maxSpeed);
			ship.setMaxAngleSpeed(shipData.maxAngleSpeed);
			ship.setAcceleration(shipData.acceleration);
			loadEquipment(shipData, ship, ship);
			
			return ship;
		}
		
		private static function loadEquipment(data:Object, parent:Equipment, ship:Ship):void
		{
			var equipment:Equipment;
			var EquipmentClass:Class;
			var equipmentData:Object;
			var ShapeClass:Class;
			var shapeResource:DisplayObject;
			var shape:MapEquipmentShape;
						
			for (var i:uint = 0; i<data.equipment.length; i++) {
				equipmentData = data.equipment[i];
				EquipmentClass = Class(getDefinitionByName("com.ad.games.fc.model.ship.equipment." + equipmentData._class));
				equipment = Equipment(new EquipmentClass(parent, ship));
				
				if (equipmentData.minAngle) {
					Turret(equipment).setMinAngle(equipmentData.minAngle);
				}
				if (equipmentData.maxAngle) {
					Turret(equipment).setMaxAngle(equipmentData.maxAngle);
				}
				
				if (equipmentData.mapShape != null) {
					shapeResource = getShapeResource(equipmentData.mapShape.shapeResource, equipmentData.mapShape.bitmap, equipmentData.mapShape.align);
					ShapeClass = Class(getDefinitionByName("com.ad.games.fc.view.map.object.shape." + equipmentData.mapShape._class));
					//trace("Loading " + equipmentData.mapShape._class);
					shape = new ShapeClass(shapeResource, equipment);
					equipment.setMapShape(shape);
					
					if (equipmentData.mapShape.scaleX != null) {
						shape.scaleX = equipmentData.mapShape.scaleX;						
					}
					if (equipmentData.mapShape.scaleY != null) {
						shape.scaleY = equipmentData.mapShape.scaleY;
					}
					if (equipmentData.mapShape.dX != null) {
						shape.setDx(equipmentData.mapShape.dX);
					}
					if (equipmentData.mapShape.dY != null) {
						shape.setDy(equipmentData.mapShape.dY);
					}
					if (equipmentData.mapShape.rotation != null) {
						shape.rotation = -equipmentData.mapShape.rotation;
					}
				}
				
				if (equipmentData.equipment != null) {
					loadEquipment(equipmentData, equipment, ship);
				}
			}
		}
		
		public static function loadNationsList(data:Object):Vector.<Nation>
		{
			var list:Vector.<Nation> = new Vector.<Nation>;
			for (var i:uint=0; i<data.list.length; i++) {
				list.push(new Nation(i, data.list[i].name, parseInt(data.list[i].color, 16)));
			}
						
			return list;
		}
		
		private static function getShapeResource(_class:String, isBitmap:Boolean, align:int):DisplayObject
		{
			var shape:DisplayObject;
			
			switch(_class) {
				/*
				 * Borodino class
				 */
				case "BorodinoClassHullMapShape":
					shape = new Resources.BorodinoClassHullMapShape();
					break;
				case "BorodinoClassTurret12MapShape":
					shape = new Resources.BorodinoClassTurret12MapShape();
					break;
				case "BorodinoClassTurret6MapShape":
					shape = new Resources.BorodinoClassTurret6MapShape();
					break;
				case "BorodinoClassTubeMapShape":
					shape = new Resources.BorodinoClassTubeMapShape();
					break;
				case "BorodinoClassStructureMapShape":
					shape = new Resources.BorodinoClassStructureMapShape();
					break;
				case "BorodinoClassFrontBridgeMapShape":
					shape = new Resources.BorodinoClassFrontBridgeMapShape();
					break;
				case "BorodinoClassRearBridgeMapShape":
					shape = new Resources.BorodinoClassRearBridgeMapShape();
					break;
				case "BorodinoClassGun12MapShape":
					shape = new Resources.BorodinoClassGun12MapShape();
					break;
				case "BorodinoClassGun6MapShape":
					shape = new Resources.BorodinoClassGun6MapShape();
					break;
				/*
				 * Scharnhorst class
				 */
				case "ScharnhorstClassHullMapShape":
					shape = new Resources.ScharnhorstClassHullMapShape();
					break;
				case "ScharnhorstClassTurret8MapShape":
					shape = new Resources.ScharnhorstClassTurret8MapShape();
					break;
				case "ScharnhorstClassCasemate8MapShape":
					shape = new Resources.ScharnhorstClassCasemate8MapShape();
					break;
				case "ScharnhorstClassTubeMapShape":
					shape = new Resources.ScharnhorstClassTubeMapShape();
					break;
				case "ScharnhorstClassFrontTubeMapShape":
					shape = new Resources.ScharnhorstClassFrontTubeMapShape();
					break;
				case "ScharnhorstClassDeckMapShape":
					shape = new Resources.ScharnhorstClassDeckMapShape();
					break;
				case "ScharnhorstClassBatteryDeckMapShape":
					shape = new Resources.ScharnhorstClassBatteryDeckMapShape();
					break;
				case "ScharnhorstClassFrontBridgeMapShape":
					shape = new Resources.ScharnhorstClassFrontBridgeMapShape();
					break;
				case "ScharnhorstClassGun8MapShape":
					shape = new Resources.ScharnhorstClassGun8MapShape();
					break;
				
				case "ShipTowerMapShape":
					shape = new Resources.ShipTowerMapShape();
					break;				
			}
			
			//isBitmap = true;
			
			if (isBitmap) {
				var bmp:Sprite = Rasterizer.rasterize(shape, 4, 2);
				if (bmp) {
					shape = bmp;
				}
			}
			
			return shape;
		}
	}
}