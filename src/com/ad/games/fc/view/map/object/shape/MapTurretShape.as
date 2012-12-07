package com.ad.games.fc.view.map.object.shape
{
	import com.ad.games.fc.SoundController;
	import com.ad.games.fc.model.ship.Ship;
	import com.ad.games.fc.model.ship.equipment.Equipment;
	import com.ad.games.fc.model.ship.equipment.Turret;
	import com.ad.games.fc.utils.Geometry;
	import com.ad.games.fc.view.base.BaseView;
	import com.ad.games.fc.view.map.Map;
	import com.ad.games.fc.view.utils.Rasterizer;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	public final class MapTurretShape extends MapEquipmentShape
	{
		private var _p1:Point;
		private var _p2:Point;
		private var _target:Ship;
		private var _maxAngle:Number;
		private var _minAngle:Number;
		private var _angle:Number;
		private var _turret:Turret;
		private var _angleSpeed:Number;
		private var _dAngle:Number;
		private var _rotation:Number;
		private var _newAngle:Number;
		private var _fireDelay:uint;
		private var _fireDelayLimit:uint = 17;
		private var _fireDelayNumber:uint = 0;
		
		private static var _gIsDecalsRendered:Boolean;
		private static var _gSmokeBitmap:Bitmap;
		private static var _gFireBitmap:Bitmap;
		private static var _gShellsCount:uint = 0;
		
		public function MapTurretShape(shape:DisplayObject = null, parent:Equipment = null)
		{
			super(shape, parent);
			_turret = Turret(_parent);
			_angleSpeed = _turret.getAngleSpeed();
			_maxAngle = _turret.getMaxAngle();
			_minAngle = _turret.getMinAngle();
			
			gDrawDecals();
			
			_fireDelayNumber = Math.abs(Math.random()*_fireDelayLimit);
		}
		
		public override function update():void
		{
			super.update();
			
			_target = Turret(_parent).getTarget();
			
			if (_target != null) {
				_p1 = _parent.getMapShape().localToGlobal(new Point(0,0));
				_p2 = _target.getMapShape().localToGlobal(new Point(0,0));
				
				//trace(_p1 + " / " + _p2);
				
				_angle = Geometry.fromRadsToDegrees(Math.atan2(_p2.y-_p1.y,_p2.x-_p1.x));
				
				//trace(_angle + " / " + _parent.getShip().getMapShape().rotation);
				
				_angle = _angle - _parent.getShip().getMapShape().rotation;
				_angle = Geometry.normalizeAngle(_angle);
				
				var _limitedAngle:Number = Geometry.limitAngle(_angle, _minAngle, _maxAngle); 
				
				_dAngle = _limitedAngle - rotation;
				_dAngle = Geometry.normalizeAngle(_dAngle);
				
				_rotation = _limitedAngle;
				
				if (Math.abs(_dAngle) > _angleSpeed) {
					
					_rotation = rotation + _angleSpeed * Geometry.getSign(_dAngle);
					//_rotation = Geometry.normalizeAngle(_rotation);
					_rotation = Math.round(Geometry.limitAngle(_rotation, _minAngle, _maxAngle));
					
					_fireDelay++;
				} else if (Math.round(_rotation) != Math.round(_limitedAngle)) {
					_rotation = Math.round(_limitedAngle);
					
					_fireDelay++;
				} else {
					if (_limitedAngle == _angle && _fireDelay%(_fireDelayLimit + 1) == _fireDelayNumber) {
					//if (_limitedAngle == _angle && _fireDelay >= _fireDelayLimit) {
						/*
						for (var i:uint = 1; i<numChildren; i++) {
							fire(getChildAt(i));
						}
						*/
						
						fire();
					} else {
						_fireDelay++;
					}
				}
					
				
				//trace(_angle + " / " + _dAngle + " / " + _rotation);
				
				if (_rotation != rotation) rotation = _rotation;
				
				//trace(_angle);
				//rotation = _angle;
			}
		}
		
		public function fire():void
		{
			_gShellsCount++;
			//trace(_gShellsCount);
			var fire:DisplayObject = Rasterizer.clone(_gFireBitmap);
			var _dY:Number = getChildAt(1).y - getChildAt(numChildren-1).y;
			fire.height = fire.height + Math.abs(_dY);
			
			var barrel:DisplayObject = getChildAt(1);
			var p:Point = barrel.localToGlobal(new Point(barrel.width + fire.width/2, fire.height/2 - (barrel.y - Math.abs(_dY)/2)));
			
			fire.x = p.x / Map.getInstance().scaleX - Map.getInstance().x / Map.getInstance().scaleX;
			fire.y = p.y / Map.getInstance().scaleY - Map.getInstance().y / Map.getInstance().scaleY;
			//fire.rotation = rotation + _parent.getShip().getMapShape().rotation;
			
			Map.getInstance().getLayersContainer().addChild(fire);
			
			var _this:MapTurretShape = this;
			
			setTimeout(
				function():void {
					//fire.visible = false;
					//Map.getInstance().getLayersContainer().removeChild(fire);
					//fire = null;
					_this.showSmoke(fire);
				}
				, 75
			);
			
			_fireDelayNumber = Math.abs(Math.random()*_fireDelayLimit);
			_fireDelay = 0;
			
			SoundController.cannonFirePrimary();
		}
		
		private function showSmoke(fire:DisplayObject):void
		{
			Bitmap(fire).bitmapData = _gSmokeBitmap.bitmapData;
			
			setTimeout(
				function():void {
					fire.visible = false;
					Map.getInstance().getLayersContainer().removeChild(fire);
					fire = null;
				}
				, 150
			);			
		}

		private static function gDrawDecals():void
		{
			if (!_gIsDecalsRendered) {
				_gIsDecalsRendered = true;
				//_gFrontWaveBitmap = 
				
				var _gSmokeSprite:Sprite = new Sprite();
				_gSmokeSprite.graphics.beginFill(0x000000, 0.5);
				_gSmokeSprite.graphics.drawCircle(0, 0, 3);
				_gSmokeSprite.graphics.endFill();
				_gSmokeBitmap = Rasterizer.toBitmap(_gSmokeSprite, Rasterizer.HALIGN_CENTER + Rasterizer.VALIGN_MIDDLE);
				
				var _gFireSprite:Sprite = new Sprite();
				_gFireSprite.graphics.beginFill(0xFF0000, 0.75);
				_gFireSprite.graphics.drawCircle(0, 0, 2);
				_gFireSprite.graphics.endFill();
				_gFireBitmap = Rasterizer.toBitmap(_gFireSprite, Rasterizer.HALIGN_CENTER + Rasterizer.VALIGN_MIDDLE);
			}
		}		
		
		public override function cache(scale:Number=1):void
		{
			BaseView.cache(this, scale);
		}
	}
}