package com.ad.games.fc.view.map.object.shape
{
	import com.ad.games.fc.view.base.BaseView;
	
	import flash.display.DisplayObject;
	
	public class MapShape extends BaseView
	{
		protected var _shape:DisplayObject;
		
		public function MapShape(shape:DisplayObject)
		{
			super();
			_shape = shape;			
		}
		
		public function setDx(dX:Number):void
		{
			this.x = dX;
		}
		
		public function setDy(dY:Number):void
		{
			this.y = dY;
		}
		
		protected override function draw():void
		{
			super.draw();
			
			if (_shape != null) {
				addChild(_shape);
			}
		}
		
		public function getShape():DisplayObject
		{			
			return _shape;
		}
		
		public function cache(scale:Number = 1):void
		{
			BaseView.cache(_shape, scale);
		}
	}
}