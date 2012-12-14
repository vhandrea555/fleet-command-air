package com.ad.games.fc2.view.starling.map.object.shape
{
	import com.ad.games.fc2.model.ship.equipment.Equipment;
	import com.ad.games.fc2.view.starling.base.BaseView;
	import com.ad.games.fc2.view.starling.map.object.shape.MapEquipmentShape;
	
	import starling.display.DisplayObject;

	public final class MapStructureShape extends MapEquipmentShape
	{
		public function MapStructureShape(shape:DisplayObject = null, parent:Equipment = null)
		{
			super(shape, parent);
		}
		
		/*
		public override function cache(scale:Number=1):void
		{
			BaseView.cache(this, scale);
		}
		*/
	}
}