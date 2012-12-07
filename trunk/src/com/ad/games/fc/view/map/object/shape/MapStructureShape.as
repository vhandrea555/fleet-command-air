package com.ad.games.fc.view.map.object.shape
{
	import com.ad.games.fc.model.ship.equipment.Equipment;
	import com.ad.games.fc.view.base.BaseView;
	
	import flash.display.DisplayObject;

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