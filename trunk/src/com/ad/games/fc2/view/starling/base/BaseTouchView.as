package com.ad.games.fc2.view.starling.base
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BaseTouchView extends BaseView
	{
		private var maxScale:Number = 1;
		private var enableDrag:Boolean = false;
		private var boundingBox:Rectangle;
		
		public function BaseTouchView()
		{
		}
		
		public function setMaxScale(_maxScale:Number):void {
			maxScale = _maxScale;
		}
		
		public function setBoundingBox(rectangle:Rectangle):void {
			boundingBox = rectangle;
		}
		
		protected override function draw():void {
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			if (touches.length == 1)
			{
				// one finger touching -> move
				var delta:Point = touches[0].getMovement(parent);
				
				var _x:Number = x + delta.x;
				var _y:Number = y + delta.y;
				
				if (_x >= boundingBox.x) {
					x = boundingBox.x;
				} else if (_x <= (boundingBox.width - width)) {
					x = boundingBox.width - width;
				} else {
					x = _x;
				}
				
				if (_y > boundingBox.y) {
					y = boundingBox.y;
				} else if (_y < (boundingBox.height - height)) {
					y = boundingBox.height - height;
				} else {
					y = _y;
				}
			}            
			else if (touches.length == 2)
			{
				// two fingers touching -> rotate and scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				var currentPosA:Point  = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point  = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number = currentAngle - previousAngle;
				
				// update pivot point based on previous center
				var previousLocalA:Point  = touchA.getPreviousLocation(this);
				var previousLocalB:Point  = touchB.getPreviousLocation(this);
				pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
				pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
				
				// update location based on the current center
				x = (currentPosA.x + currentPosB.x) * 0.5;
				y = (currentPosA.y + currentPosB.y) * 0.5;
				
				//trace(pivotX, pivotY, x, y);
				
				// rotate
				//rotation += deltaAngle;
				
				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				scaleX *= sizeDiff;
				scaleY *= sizeDiff;
			}
			
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch && touch.tapCount == 2)
				parent.addChild(this); // bring self to front
			
			// enable this code to see when you're hovering over the object
			// touch = event.getTouch(this, TouchPhase.HOVER);            
			// alpha = touch ? 0.8 : 1.0;
		}
		
		public override function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			super.dispose();
		}
	}
}