package com.ad.games.fc2.model.ship.equipment
{
	import com.ad.games.fc2.model.ship.Ship;

	public final class Hull extends Equipment
	{
		public function Hull(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
	}
}