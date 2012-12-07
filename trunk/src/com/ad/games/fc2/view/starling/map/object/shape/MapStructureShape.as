package com.ad.games.fc.view.starling.map.object.shape
{
	public final class MapStructureShape extends MapEquipmentShape
	{
		public function MapStructureShape(shape:DisplayObject = null, parent:Equipment = null)
		{
			super(shape, parent);
		}
		
		public override function cache(scale:Number=1):void
		{
			BaseView.cache(this, scale);
		}
	}
}