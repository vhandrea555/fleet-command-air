package com.ad.games.fc.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public final class Geometry
	{
		public function Geometry()
		{
		}
		
		public static function getRange(o1:DisplayObject, o2:DisplayObject):Number {
			return Geometry.getRadius((o2.x - o1.x), (o2.y - o1.y));
		}
		
		public static function fromRadsToDegrees(rads:Number):Number
		{
			return rads*(180/Math.PI);
		}

		public static function fromDegreesToRads(degrees:Number):Number
		{
			return degrees/(180/Math.PI);
		}		
		
		public static function getRadius(width:Number, height:Number):Number
		{
			return Math.sqrt(Math.pow((width),2) + Math.pow((height),2));
		}
		
		public static function translate(point:Point, angle:Number):Point {
			var result:Point = new Point();
			angle = fromDegreesToRads(angle);
			
			result.x = point.x * Math.cos(angle) - point.y * Math.sin(angle);
			result.y = point.x * Math.sin(angle) + point.y * Math.cos(angle);
			
			return result;
		}
		
		public static function getSign(value:Number):int
		{
			return (value != 0) ? (Math.abs(value)/value) : 1;
		}
		
		public static function normalizeAngle(angle:Number):Number
		{
			angle = angle%360;
			angle = (angle < -180) ? (360 + angle) : angle;
			angle = (angle > 180) ? (angle - 360) : angle;
			return angle;
		}
		
		public static function limitAngle(angle:Number, minAngle:Number, maxAngle:Number):Number
		{
			if (maxAngle > minAngle) {
				angle = (angle > maxAngle) ? maxAngle : angle;
				angle = (angle < minAngle) ? minAngle : angle;
			} else {
				if (angle < 0) {
					angle = (angle > maxAngle) ? maxAngle : angle;						
				} else {
					angle = (angle < minAngle) ? minAngle : angle;
				}
			}
			return angle;
		}
	}
}