package com.ad.games.fc2.model.ship
{
	import com.ad.games.fc2.model.Nation;
	import com.ad.games.fc2.model.ship.equipment.Equipment;
	import com.ad.games.fc2.model.ship.equipment.Turret;
	import com.ad.games.fc2.view.starling.map.object.shape.MapEquipmentShape;

	public final class Ship extends Equipment
	{
		protected var _class:String;
		protected var _nation:Nation;
		protected var _target:Ship;
		protected var _maxSpeed:Number;
		protected var _maxAngleSpeed:Number;
		protected var _acceleration:Number;
				
		public function Ship(name:String, type:String, _class:String, nation:Nation)
		{
			super(null, this);
			_name = name;
			_type = type;
			_class = _class;
			_nation = nation;
			_mapShape = new MapEquipmentShape(null, this);
		}
		
		public function getNation():Nation
		{
			return _nation;
		}
		
		public function setTarget(target:Ship):void
		{
			_target = target;
			updateTarget(getEquipment(), target);
		}
		
		private function updateTarget(equipments:Vector.<Equipment>, target:Ship):void
		{
			for (var i:uint = 0; i<equipments.length; i++) {
				var equipment:Equipment = equipments[i];
				
				if (equipment is Turret) {
					Turret(equipment).setTarget(target);
					//Turret(equipment).getMapShape().update();
				}
				
				updateTarget(equipment.getEquipment(), target);
			}			
		}
		
		public function getTarget():Ship
		{
			return _target;
		}
		
		public function setMaxSpeed(speed:Number):void
		{
			_maxSpeed = speed;
		}
		
		public function getMaxSpeed():Number
		{
			return _maxSpeed;			
		}
		
		public function setMaxAngleSpeed(maxAngleSpeed:Number):void
		{
			_maxAngleSpeed = maxAngleSpeed;
		}
		
		public function getMaxAngleSpeed():Number
		{
			return _maxAngleSpeed;			
		}
		
		public function setAcceleration(acceleration:Number):void
		{
			_acceleration = acceleration;
		}
		
		public function getAcceleration():Number
		{
			return _acceleration;			
		}
	}
}