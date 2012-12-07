package com.ad.games.fc2.view.starling.map.object.shape
{
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