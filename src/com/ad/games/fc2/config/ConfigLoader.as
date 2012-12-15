package com.ad.games.fc2.config
{
	import com.ad.games.fc2.Application;
	import com.ad.games.fc2.model.Nation;
	import com.ad.games.fc2.model.ship.Ship;
	import com.ad.games.fc2.model.ship.equipment.Barbette;
	import com.ad.games.fc2.model.ship.equipment.BridgeStructure;
	import com.ad.games.fc2.model.ship.equipment.Equipment;
	import com.ad.games.fc2.model.ship.equipment.Gun;
	import com.ad.games.fc2.model.ship.equipment.Hull;
	import com.ad.games.fc2.model.ship.equipment.Structure;
	import com.ad.games.fc2.model.ship.equipment.Tube;
	import com.ad.games.fc2.model.ship.equipment.Turret;
	import com.ad.games.fc2.resources.Resources;
	import com.ad.games.fc2.view.starling.map.MapLayer;
	import com.ad.games.fc2.view.starling.map.MapView;
	import com.ad.games.fc2.view.starling.map.object.MapLayerObject;
	import com.ad.games.fc2.view.starling.map.object.ShipMapLayerObject;
	import com.ad.games.fc2.view.starling.map.object.shape.MapEquipmentShape;
	import com.ad.games.fc2.view.utils.Rasterizer;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public final class ConfigLoader
	{
		private static const PACKAGE_EQUIP:String = "com.ad.games.fc2.model.ship.equipment.";
		private static const PACKAGE_MAP_OBJECT_SHAPE:String = "com.ad.games.fc2.view.starling.map.object.shape.";
		
		public static function loadMap(mapData:Object):MapView
		{			
			var map:MapView = new MapView(mapData.cols, mapData.rows);
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
			var ship:Ship = new Ship(name, type, shipData._class, GlobalConfig.NATIONS[shipData.nation]);
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
			var shapeResource:starling.display.DisplayObject;
			var shape:MapEquipmentShape;
			
			for (var i:uint = 0; i<data.equipment.length; i++) {
				equipmentData = data.equipment[i];
				EquipmentClass = Class(getDefinitionByName(PACKAGE_EQUIP + equipmentData._class));
				equipment = Equipment(new EquipmentClass(parent, ship));
				
				if (equipmentData.minAngle) {
					Turret(equipment).setMinAngle(equipmentData.minAngle);
				}
				if (equipmentData.maxAngle) {
					Turret(equipment).setMaxAngle(equipmentData.maxAngle);
				}
				
				if (equipmentData.mapShape != null) {
					shapeResource = getStarlingShapeResource(equipmentData.mapShape.shapeResource, equipmentData.mapShape.bitmap, equipmentData.mapShape.align);
					ShapeClass = Class(getDefinitionByName(PACKAGE_MAP_OBJECT_SHAPE + equipmentData.mapShape._class));
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
		
		private static function getStarlingShapeResource(_class:String, isBitmap:Boolean, align:int):starling.display.DisplayObject {
			var r:flash.display.DisplayObject = getShapeResource(_class, isBitmap, align);
			var sprite:starling.display.Sprite = new starling.display.Sprite();
			var bitmap:BitmapData = Rasterizer.toBitmapData(r, align);
			if (bitmap != null) {
				var texture:Texture = Texture.fromBitmapData(bitmap);
				var image:Image = new Image(texture);
				sprite.addChild(image);
			}			
			return sprite;
		}
		
		private static function getShapeResource(_class:String, isBitmap:Boolean, align:int):flash.display.DisplayObject
		{
			var shape:flash.display.DisplayObject;
			
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
				var bmp:flash.display.Sprite = Rasterizer.rasterize(shape, 4, 2);
				if (bmp) {
					shape = bmp;
				}
			}
			
			return shape;
		}
		
		
		public static function initiate():void
		{
			var _e:Equipment;
			_e = new Hull(null, null);
			_e = new Structure(null, null);
			_e = new Barbette(null, null);
			_e = new Turret(null, null);
			_e = new Tube(null, null);
			_e = new Gun(null, null);
			_e = new BridgeStructure(null, null);
		}		
	}
}