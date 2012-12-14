package com.ad.games.fc2.model.ship.equipment
{
	import com.ad.games.fc2.model.ship.Ship;

	public final class HullSection extends Equipment
	{
		public function HullSection(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
	}
}