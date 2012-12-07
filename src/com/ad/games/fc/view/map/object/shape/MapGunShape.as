package com.ad.games.fc.view.map.object.shape
{
	import com.ad.games.fc.model.ship.equipment.Equipment;
	
	import flash.display.DisplayObject;

	public final class MapGunShape extends MapEquipmentShape
	{
		public function MapGunShape(shape:DisplayObject, parent:Equipment)
		{
			super(shape, parent);
		}
		
		public override function cache(scale:Number=1):void
		{
			//Disable caching for guns
		}
	}
}