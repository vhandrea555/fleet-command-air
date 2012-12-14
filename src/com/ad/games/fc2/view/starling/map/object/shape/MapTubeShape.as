package com.ad.games.fc2.view.starling.map.object.shape
{
	import com.ad.games.fc2.model.ship.equipment.Equipment;
	
	import starling.display.DisplayObject;

	public final class MapTubeShape extends MapEquipmentShape
	{
		public function MapTubeShape(shape:DisplayObject = null, parent:Equipment = null)
		{
			super(shape, parent);
		}
		
		/*
		public override function cache(scale:Number=1):void
		{
			//disable caching for tubes
		}
		*/
	}
}