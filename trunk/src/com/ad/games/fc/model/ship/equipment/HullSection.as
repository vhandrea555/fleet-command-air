package com.ad.games.fc.model.ship.equipment
{
	import com.ad.games.fc.model.ship.Ship;

	public final class HullSection extends Equipment
	{
		public function HullSection(parentEquipment:Equipment, ship:Ship)
		{
			super(parentEquipment, ship);
		}
	}
}