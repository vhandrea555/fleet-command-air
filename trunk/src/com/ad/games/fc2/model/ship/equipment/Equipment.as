package com.ad.games.fc2.model.ship.equipment
{
	import com.ad.games.fc2.model.BaseModel;
	import com.ad.games.fc2.model.ship.Ship;
	import com.ad.games.fc2.view.starling.map.object.shape.MapEquipmentShape;

	public class Equipment extends BaseModel
	{
		protected var _type:String;
		protected var _name:String;
		protected var _mapShape:MapEquipmentShape;
		protected var _equipment:Vector.<Equipment>;
		protected var _damage:Number = 0; //from 0 to 1.0
		protected var _parentEquipment:Equipment;
		protected var _ship:Ship;
		
		public function Equipment(parentEquipment:Equipment, ship:Ship)
		{
			super();
			_equipment = new <Equipment>[];
			if (parentEquipment != null) {
				_parentEquipment = parentEquipment;
				_parentEquipment.addEquipment(this);
			}
			_ship = ship;
		}
		
		public function addEquipment(equipment:Equipment):uint
		{
			return this._equipment.push(equipment);
		}
		
		public function getEquipmentByIndex(i:uint):Equipment
		{
			return this._equipment[i];
		}
		
		public function getEquipment():Vector.<Equipment>
		{
			return _equipment;
		}
		
		public function getMapShape():MapEquipmentShape
		{
			return _mapShape;
		}
		
		public function setMapShape(mapShape:MapEquipmentShape):void
		{
			_mapShape = mapShape;
		}
		
		public function addDamage(damage:Number):void
		{
			this._damage += damage;
		}
		
		public function getDamage():Number
		{
			return this._damage;
		}
		
		public function getShip():Ship
		{
			return _ship;
		}
		
		public function setName(name:String):void
		{
			_name = name;
		}
		
		public function getName():String
		{
			return _name;
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