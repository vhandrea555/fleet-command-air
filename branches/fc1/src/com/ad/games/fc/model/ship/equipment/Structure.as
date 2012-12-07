package com.ad.games.fc.model.ship.equipment
{
	import com.ad.games.fc.model.ship.Ship;

	public class Structure extends Equipment
	{
		public function Structure(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
	}
}