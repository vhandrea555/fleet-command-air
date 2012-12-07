package com.ad.games.fc.model.ship.equipment
{
	import com.ad.games.fc.model.ship.Ship;

	public final class Turret extends Equipment
	{
		protected var _minAngle:Number = 0;
		protected var _maxAngle:Number = 0;
		protected var _target:Ship;
		protected var _angleSpeed:Number = 10;
		
		public function Turret(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
		
		public function setTarget(target:Ship):void
		{
			_target = target;
		}
		
		public function getTarget():Ship
		{
			return _target;
		}
		
		public function setMaxAngle(angle:Number):void
		{
			_maxAngle = angle;
		}
		
		public function setMinAngle(angle:Number):void
		{
			_minAngle = angle;
		}
		
		public function getMaxAngle():Number
		{
			return _maxAngle;
		}
		
		public function getMinAngle():Number
		{
			return _minAngle;
		}
		
		public function getAngleSpeed():Number
		{
			return _angleSpeed;
		}
	}
}