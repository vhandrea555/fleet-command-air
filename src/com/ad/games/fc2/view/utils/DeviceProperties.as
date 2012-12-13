package com.ad.games.fc2.view.utils
{
	import com.ad.games.fc2.Application;
	
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;

	public final class DeviceProperties
	{
		public static function isTouchInterface():Boolean
		{
			return Capabilities.touchscreenType != TouchscreenType.NONE;
		}
		
		public static function getScreenSize():Rectangle
		{
			var width:Number = (Application.getInstance().stage.stageWidth > Application.getInstance().stage.fullScreenWidth) ? Application.getInstance().stage.fullScreenWidth : Application.getInstance().stage.stageWidth;
			var height:Number = (Application.getInstance().stage.stageHeight > Application.getInstance().stage.fullScreenHeight) ? Application.getInstance().stage.fullScreenHeight : Application.getInstance().stage.stageHeight;
			
			return new Rectangle(0 , 0, width, height);
		}
	}
}