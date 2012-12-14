package com.ad.games.fc2.view.starling.base
{
	import com.ad.games.fc2.Application;
	import com.ad.games.fc2.config.GlobalConfig;
	import com.ad.games.fc2.view.utils.Console;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BaseTouchView extends BaseView
	{
		private var maxScale:Number = 4;
		private var minScale:Number = 0.25;
		
		private var enableDrag:Boolean = true;
		private var enableRotation:Boolean = false;
		private var boundingBox:Rectangle;
		private var _cursorX:Number = 0;
		private var _cursorY:Number = 0;
		
		public function BaseTouchView()
		{
			super();
		}
		
		protected override function draw():void {
			addEventListener(TouchEvent.TOUCH, onTouch);			
			Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		protected function onMouseWheel(e:MouseEvent):void {
			scale(scaleX * (1 + e.delta / GlobalConfig.MOUSE_WHEEL_SPEED), _cursorX, _cursorY);
		}
		
		protected function getCursorPoint():Point {
			return new Point(_cursorX, _cursorY);
		}
		
		public function scale(_scale:Number, centerX:Number, centerY:Number):void
		{
			_scale = (_scale < minScale) ? minScale : _scale;
			_scale = (_scale > maxScale) ? maxScale : _scale;
			
			var minScaleX:Number = boundingBox.width / (width / scaleX);
			var minScaleY:Number = boundingBox.height / (height / scaleX);
			
			_scale = (_scale < minScaleX) ? minScaleX : _scale;
			_scale = (_scale < minScaleY) ? minScaleY : _scale;
			
			var dScale:Number = _scale - scaleX;
			var newX:Number = x - (centerX)*dScale;
			var newY:Number = y - (centerY)*dScale;
			
			var minX:Number = boundingBox.width - width;
			var maxX:Number = 0;
			var minY:Number = boundingBox.height - height;
			var maxY:Number = 0;
			
			newX = (newX < minX) ? minX : newX;
			newX = (newX > maxX) ? maxX : newX;
			newY = (newY < minY) ? minY : newY;
			newY = (newY > maxY) ? maxY : newY;
			
			x = newX;
			y = newY;
			
			scaleX = _scale;
			scaleY = _scale;
		}		
		
		private function processSingleTouchMove(touch:Touch):void {
			// one finger touching -> move
			var delta:Point = touch.getMovement(parent);
			
			var _x:Number = x + delta.x;
			var _y:Number = y + delta.y;
			
			if (_x >= boundingBox.x) {
				x = boundingBox.x;
			} else if (_x <= (boundingBox.width - width)) {
				x = boundingBox.width - width;
			} else {
				x = _x;
			}
			
			if (_y >= boundingBox.y) {
				y = boundingBox.y;
			} else if (_y <= (boundingBox.height - height)) {
				y = boundingBox.height - height;
			} else {
				y = _y;
			}			
		}
		
		private function processDoubleTouchMove(touches:Vector.<Touch>):void {
			// two fingers touching -> rotate and scale
			var touchA:Touch = touches[0];
			var touchB:Touch = touches[1];
			
			var currentPosA:Point  = touchA.getLocation(parent);
			var previousPosA:Point = touchA.getPreviousLocation(parent);
			var currentPosB:Point  = touchB.getLocation(parent);
			var previousPosB:Point = touchB.getPreviousLocation(parent);
			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
			// update pivot point based on previous center
			var previousLocalA:Point  = touchA.getPreviousLocation(this);
			var previousLocalB:Point  = touchB.getPreviousLocation(this);
			
			var _pivotX:Number = (previousLocalA.x + previousLocalB.x) * 0.5;
			var _pivotY:Number = (previousLocalA.y + previousLocalB.y) * 0.5;												
			
			// scale
			var _scale:Number = scaleX * (currentVector.length / previousVector.length);
			
			scale(_scale, _pivotX, _pivotY);
		}
		
		protected function onSingleTouchStart(touch:Touch):Boolean {
			return false;
		}
		
		protected function onSingleTouchEnd(touch:Touch):Boolean {
			return false;
		}
		
		protected function onSingleTouchOver(touch:Touch):Boolean {
			return false;
		}
		
		protected function onSingleTouchMove(touch:Touch):Boolean {
			return false;
		}		
		
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			//TODO: performance on iOS
			//TODO: custom zoom (without pivot modification)
			//TODO: zoom boundaries
			
			if (touches.length == 1) {
				if (!onSingleTouchMove(touches[0])) {
					processSingleTouchMove(touches[0]);
				}
				//Console.append(scaleX + "," + x + "," + width/scaleX + "," + _x + "," + y + "," + height/scaleX + "," + _y + "," + boundingBox.toString());
			} else if (touches.length == 2) {
				processDoubleTouchMove(touches);
			}
			
			touches = event.getTouches(this, TouchPhase.BEGAN);
			
			if (touches.length == 1) {
				onSingleTouchStart(touches[0]);
			}
			
			touches = event.getTouches(this, TouchPhase.ENDED);
			
			if (touches.length == 1) {
				onSingleTouchEnd(touches[0]);
			}
			
			touches = event.getTouches(this, TouchPhase.HOVER);
			
			if (touches.length == 1) {
				var p:Point = touches[0].getLocation(this);
				_cursorX = p.x;
				_cursorY = p.y;
				
				onSingleTouchOver(touches[0]);
			}
			
			/*
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if (touch && touch.tapCount == 2) {
				//parent.addChild(this); // bring self to front
			}
			*/
			
			// enable this code to see when you're hovering over the object
			// touch = event.getTouch(this, TouchPhase.HOVER);            
			// alpha = touch ? 0.8 : 1.0;
		}
		
		public override function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			Application.getInstance().stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			super.dispose();
		}
		
		public function setEnableDrag(_enableDrag:Boolean):void {
			enableDrag = _enableDrag;
		}
		
		public function setEnableRotation(_enableRotation:Boolean):void {
			enableRotation = _enableRotation;
		}
		
		public function setMaxScale(_maxScale:Number):void {
			maxScale = _maxScale;
		}
		
		public function setMinScale(_minScale:Number):void {
			minScale = _minScale;
		}
		
		public function setBoundingBox(rectangle:Rectangle):void {
			boundingBox = rectangle;
		}
	}
}