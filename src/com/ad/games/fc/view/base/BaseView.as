package com.ad.games.fc.view.base
{
	import com.ad.games.fc.view.Console;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	public class BaseView extends Sprite
	{
		private var isDrawn:Boolean = false;
		
		public function BaseView()
		{
			super();
		}
		
		protected function draw():void {
		}
		
		public function update():void {
			if (!isDrawn) {
				isDrawn = true;
				draw();				
			}
		}
		
		public static function cache(view:DisplayObject, scale:Number = 2):void
		{
			var _prevScaleX:Number = view.scaleX;
			var _prevScaleY:Number = view.scaleY;
			try {
				view.scaleX = _prevScaleX * scale;
				view.scaleY = _prevScaleY * scale;				
				view.cacheAsBitmapMatrix = view.transform.matrix;
				view.cacheAsBitmap = true;
			} catch(e:Error) {
				//Console.clear();
				//Console.appendLine((new Date()).toString());
			}
			view.scaleX = _prevScaleX;
			view.scaleY = _prevScaleY;
		}
		
		public static function unCache(view:DisplayObject):void
		{
			view.cacheAsBitmap = false;
		}
	}
}