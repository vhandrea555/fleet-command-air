package com.ad.games.fc2.model.ship.equipment
{
	import com.ad.games.fc2.model.ship.Ship;

	public final class Gun extends Equipment
	{
		public function Gun(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
	}
}