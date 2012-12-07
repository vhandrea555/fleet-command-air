package com.ad.games.fc2.view.starling.base
{
	import starling.display.Sprite;
	
	public class BaseView extends Sprite
	{
		public function BaseView()
		{
			super();
		}
		
		private var isDrawn:Boolean = false;
		
		protected function draw():void {
			
		}
		
		public function update():void {
			if (!isDrawn) {
				isDrawn = true;
				draw();				
			}
		}		
	}
}