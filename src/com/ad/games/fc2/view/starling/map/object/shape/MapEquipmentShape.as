package com.ad.games.fc2.view.starling.map.object.shape
{
	import com.ad.games.fc2.model.ship.Ship;
	import com.ad.games.fc2.model.ship.equipment.Equipment;
	
	import starling.display.DisplayObject;

	public class MapEquipmentShape extends MapShape
	{
		protected var _parent:Equipment;
				
		public function MapEquipmentShape(shape:DisplayObject, parent:Equipment)
		{
			super(shape);
			_parent = parent
		}
		
		public function getShip():Ship
		{
			var ship:Ship = null;
			if (this is Ship) {
				ship = Ship(this);
			} else {
				ship = Ship(_parent.getEquipment());
			}
			return ship;
		}
		
		public static function initiate():void
		{
			var _e:MapEquipmentShape;
			_e = new MapShipHullShape(null, null);
			_e = new MapGunShape(null, null);
			_e = new MapStructureShape(null, null);
			_e = new MapTubeShape(null, null);
			_e = new MapTurretShape(null, null);
		}
	}
}