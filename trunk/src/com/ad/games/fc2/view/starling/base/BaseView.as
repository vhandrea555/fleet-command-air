package com.ad.games.fc2.view.starling.base
{
	import com.ad.games.fc2.Application;
	
	import flash.events.MouseEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
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
		
		
		private var mouseStartX:int = 0;
		private var mouseStartY:int = 0;
		
		public function startDrag():void {
			mouseStartX = Application.getInstance().mouseX;
			mouseStartY = Application.getInstance().mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void {
			x = mouseStartX - e.localX;
			y = mouseStartY - e.localY;
		}
		
		public function stopDrag():void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
	}
}