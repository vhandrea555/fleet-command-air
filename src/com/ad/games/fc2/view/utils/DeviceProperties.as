package com.ad.games.fc2.view.utils
{
	import com.ad.games.fc2.Application;
	
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;

	public final class DeviceProperties
	{
		public static function isTouchInterface():Boolean
		{
			return Capabilities.touchscreenType == TouchscreenType.FINGER;
		}
		
		private static var screenWidth:int;
		private static var screenHeight:int;
		
		public static function getSreenWidth():int
		{
			if (!screenWidth) {
				screenWidth = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
				screenWidth = Math.min(Application.getInstance().stage.stageWidth, screenWidth);
			}
			return screenWidth;
		}
		
		public static function getSreenHeight():int
		{
			if (!screenHeight) {
				screenHeight = Math.min(Capabilities.screenResolutionY, Capabilities.screenResolutionX);
				screenHeight = Math.min(Application.getInstance().stage.stageHeight, screenHeight);
			}
			return screenHeight;
		}
	}
}