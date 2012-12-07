package com.ad.games.fc2.utils.path
{
	import com.ad.games.fc.utils.Geometry;

	public final class Path
	{
		private var _start:PathPoint;
		private var _end:PathPoint;
		private var _points:Vector.<PathPoint>;
		private var _length:Number = 0;
		private var _maxLength:Number = 0;
		private var _maxSpeed:Number = 0;
		private var _maxAngleSpeed:Number = 0;
		private var _acceleration:Number = 0;
		
		public function Path(maxSpeed:Number, maxAngleSpeed:Number, acceleration:Number)
		{
			_maxSpeed = maxSpeed;
			_maxAngleSpeed = maxAngleSpeed;
			_acceleration = acceleration;
			
			_points = new <PathPoint>[];
		}
		
		public function setStart(start:PathPoint):void
		{
			_start = start;
		}
		
		public function setEnd(end:PathPoint):void
		{
			_end = end;
		}
		
		public function setMaxLength(maxLength:Number):void
		{
			_maxLength = maxLength;
		}
		
		public function getMaxLength():Number
		{
			return _maxLength;
		}		
		
		public function update():void
		{
			_points.length = 0;
			var point:PathPoint = _start;
			_length = 0;
			
			//trace("start");
			
			for (var i:uint=0; ; i++) {
				if (_length > _maxLength) {					
					_points.length = 0;
					_length = 0;
					break
				}
				
				point = getNextPoint(point, _end);
				
				if (!point.equals(_end)) {
					_points.push(point);
				} else {
					break;
				}
			}
			
			//trace("end " + _maxSpeed + " " + _acceleration);
		}
		
		public function getPointAt(i:uint):PathPoint
		{
			return _points[i];
		}
		
		public function getPointsCount():uint
		{
			return _points.length;
		}
		
		private function getNextPoint(start:PathPoint, end:PathPoint):PathPoint
		{
			var dX:Number = end.x - start.x;
			var dY:Number = end.y - start.y;
			var radius:Number = Geometry.getRadius(dX, dY);
			var angle:Number = Geometry.fromRadsToDegrees(Math.atan2(dY, dX));
			var next:PathPoint = new PathPoint();
			
			//var limit:Number = _maxLength - _length;
			var limit:Number = radius;
			
/*			if ((start.speed > 0) && ((limit/start.speed) < (start.speed/_acceleration))) {
				next.speed = start.speed - _acceleration;
				if (next.speed < 0) {
					next.speed = 0;
				}
			} else */
			if ((start.speed > _end.speed) && ((limit/start.speed) < (start.speed/_acceleration))) {
				next.speed = start.speed - _acceleration;
				if (next.speed < _acceleration) {
					next.speed = _acceleration;
				}
			}  else if (((start.speed + _acceleration) < _maxSpeed)) {
				next.speed = start.speed + _acceleration;
			} else {
				next.speed = _maxSpeed;
			}
			
			//trace("start " + start.speed + " next " + next.speed );
			
			var angleSpeed:Number = _maxAngleSpeed * Math.abs(next.speed/_maxSpeed);
			
			angle = angle;
			
			var dAngle:Number = angle - start.rotation;
			dAngle = dAngle%360;
			dAngle = Geometry.normalizeAngle(dAngle);
			
			if ((angleSpeed) < _maxAngleSpeed) {
				next.angleSpeed = angleSpeed;
			} else {
				next.angleSpeed = _maxAngleSpeed;
			}
			
			if (Math.abs(next.angleSpeed) < Math.abs(dAngle)) {
				next.rotation = start.rotation + next.angleSpeed * Geometry.getSign(dAngle);				
			} else {
				next.rotation = angle;
			}
			
			angle = next.rotation;
			
			var vX:Number = next.speed * Math.cos(Geometry.fromDegreesToRads(angle));
			var vY:Number = next.speed * Math.sin(Geometry.fromDegreesToRads(angle));
			
			if (Math.abs(radius) > Math.abs(next.speed)) {
				next.x = start.x + vX;
				next.y = start.y + vY;
				_length += next.speed;
			} else {
				next.x = end.x;
				next.y = end.y;
			}
			
			return next;
		}
		
		public function getLength():Number
		{
			return _length;
		}
		
		public function getEnd():PathPoint
		{
			return _end;
		}
		
		public function getStart():PathPoint
		{
			return _start;
		}
		
		public function getLastPoint():PathPoint
		{
			return (_points.length > 0) ? PathPoint(_points[_points.length - 1]) : _start;
		}
		
		public function setPoints(points:Vector.<PathPoint>):void
		{
			_points = points;
		}
		
		public function getPoints():Vector.<PathPoint>
		{
			return _points;
		}
		
		public function setMaxSpeed(speed:Number):void
		{
			_maxSpeed = speed;
		}
		
		public function setMaxAngleSpeed(speed:Number):void
		{
			_maxAngleSpeed = speed;
		}

		public function setAcceleration(acceleration:Number):void
		{
			_acceleration = acceleration;
		}
	}
}