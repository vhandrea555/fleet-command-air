package com.ad.games.fc2.utils.path
{

	public final class PathPoint
	{
		public var rotation:Number = 0;
		public var speed:Number = 0;
		public var angleSpeed:Number = 0;
		public var x:Number;
		public var y:Number;
		
		public function PathPoint(x:Number = 0, y:Number = 0, rotation:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.rotation = rotation;			
		}
		
		public function substract(point:PathPoint):PathPoint
		{
			return new PathPoint((x - point.x), (y - point.y), (rotation - point.rotation));
		}
		
		public function add(point:PathPoint):PathPoint
		{
			return new PathPoint((x + point.x), (y + point.y), (rotation + point.rotation));
		}
		
		public function equals(point:PathPoint):Boolean
		{
			return (Math.round(x) == Math.round(point.x) && Math.round(y) == Math.round(point.y));
		}
		
		public function toString():String
		{
			return (x + " x " + y + " angle: " + rotation + " speed: " + speed);
		}
	}
}