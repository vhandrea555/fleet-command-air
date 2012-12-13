package com.ad.games.fc2.view.starling.base
{
	public class BaseScreen extends BaseView
	{
		public function BaseScreen()
		{
			super();
		}
		
		protected override function draw():void {
			super.draw();
			width = parent.width;
			height = parent.height;			
		}
	}
}