package com.ad.games.fc2.view.starling.map.object.shape
{
	public final class MapTubeShape extends MapEquipmentShape
	{
		public function MapTubeShape(shape:DisplayObject = null, parent:Equipment = null)
		{
			super(shape, parent);
		}
		
		public override function cache(scale:Number=1):void
		{
			//disable caching for tubes
		}		
	}
}