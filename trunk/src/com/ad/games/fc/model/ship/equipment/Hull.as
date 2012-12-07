package com.ad.games.fc.model.ship.equipment
{
	import com.ad.games.fc.model.ship.Ship;

	public final class Hull extends Equipment
	{
		public function Hull(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
	}
}