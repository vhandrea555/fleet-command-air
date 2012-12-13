package com.ad.games.fc2.view.starling.map.object
{

	public final class ShipMapLayerObject extends MapLayerMovingObject
	{
		protected var _ship:Ship;
		protected var _target:ShipMapLayerObject;
		protected static const COLOR_TARGETED:uint = 0xFF0000;		
		protected var _label:TextField;
		protected var _equipmentShapes:Vector.<MapEquipmentShape> = new Vector.<MapEquipmentShape>;
		protected var _tubeShapes:Vector.<MapTubeShape> = new Vector.<MapTubeShape>;
		private var _propagateCounter:uint = 0;
		private var _shapeCacheBitmap:Bitmap;
		private var _hullShape:MapEquipmentShape = null;
		private static var _ships:Vector.<ShipMapLayerObject> = new Vector.<ShipMapLayerObject>;
		
		private static const COLLISION_TURNS_AHEAD_FORECAST:uint = 10;
		private static const COLLISION_TURNS_AHEAD:uint = 5;
		
		/*
		 * Map animation related
		 */
		
		/*
		 * Common properties
		 */
		private static var _gFrontWaveBitmap:Bitmap = Rasterizer.toBitmap(new Resources.ShipFrontWaveMapShape(), Rasterizer.HALIGN_RIGHT + Rasterizer.VALIGN_MIDDLE);
		private static var _gSmokeBitmap:Bitmap;		
		private static var _gIsDecalsRendered:Boolean = false;
		private static var _gDecalsCount:uint = 0;
		private const LABEL_STYLE:TextFormat = new TextFormat("Arial", Application.getSreenWidth()*0.02, 0);
		
		/*
		 * Private properies
		 */
		private var _frontWaveShape:DisplayObject;
		private var _trace:Sprite;
		private var _traceMask:Sprite;
		private var _traceContainer:Sprite;
		private var _hullWidth:Number;
		private var _hullHeight:Number;
		private var _drawCommands:Vector.<int> = new Vector.<int>;
		private var _drawPoints:Vector.<Number> = new Vector.<Number>;
		private var _rect:Rectangle;
		private var _traceShapes:Vector.<BitmapData>;
		private var _x:Number;
		private var _y:Number;
		private var _p:Point;
		private var _point:PathPoint;
		private var _traceBitmap:Bitmap;

		
		public function ShipMapLayerObject(layer:MapLayer, ship:Ship)
		{
			_ship = ship;
			
			_maxSpeed = ship.getMaxSpeed();
			_maxAngleSpeed = ship.getMaxAngleSpeed();
			_acceleration = ship.getAcceleration();
			_ships.push(this);
			
			super(layer);
		}
				
		/*
		* Called once:
		*/
		
		protected override function draw():void
		{
			super.draw();
			
			gDrawDecals();
			
			_frontWaveShape = Rasterizer.clone(_gFrontWaveBitmap);
			_frontWaveShape.visible = false;			
			
			_shape = _ship.getMapShape();
			_shape.x = GlobalConfig.MAP_CELL_SIZE/2;
			_shape.y = GlobalConfig.MAP_CELL_SIZE/2;
			addChild(_shape);
			
			drawEquipmentShapes(_ship.getMapShape(), _ship.getEquipment());
			
			_label = new TextField();
			_label.setTextFormat(LABEL_STYLE);
			_label.defaultTextFormat = LABEL_STYLE;
			_label.textColor = _ship.getNation().getColor();
			_label.autoSize = TextFieldAutoSize.NONE;
						
			_label.x = GlobalConfig.MAP_CELL_SIZE/2;
			_label.y = -GlobalConfig.MAP_CELL_SIZE/4;
			//_label.autoSize = TextFieldAutoSize.LEFT;
			_label.selectable = false;			
			_label.text = _ship.getName();			
			addChild(_label);
			
			cacheEquipmentShapes();
			cacheShape();
			
			_shapeCacheBitmap.visible = true;
			_shape.visible = false;
		}
				
		private function drawEquipmentShapes(_parent:MapEquipmentShape, equipments:Vector.<Equipment>):void
		{
			for (var i:uint = 0; i<equipments.length; i++) {
				var equipment:Equipment = equipments[i];
				var shape:MapEquipmentShape = equipment.getMapShape();
				
				if (shape != null) {					
					_parent.addChild(shape);
					shape.update();
					_equipmentShapes.push(shape);
					drawEquipmentShapes(shape, equipment.getEquipment());
					
					if (shape is MapTubeShape) {
						_tubeShapes.push(shape);
					}
					
					if (shape is MapShipHullShape) {
						_hullShape = shape;
						_hullWidth = shape.getShape().width * shape.scaleX;
						_hullHeight = shape.getShape().height * shape.scaleX;
					}
				} else {
					drawEquipmentShapes(_parent, equipment.getEquipment());
				}
			}
		}		
		
		private function gDrawDecals():void
		{
			if (!_gIsDecalsRendered) {
				_gIsDecalsRendered = true;
				var _gSmokeSprite:Sprite = new Sprite();
				_gSmokeSprite.graphics.beginFill(0x000000);
				_gSmokeSprite.graphics.drawCircle(0, 0, 5);
				_gSmokeSprite.graphics.endFill();
				_gSmokeBitmap = Rasterizer.toBitmap(_gSmokeSprite, Rasterizer.HALIGN_CENTER + Rasterizer.VALIGN_MIDDLE);
			}
			
			_traceMask = new Sprite();
			_traceMask.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, 0xFFFFFF], [1,0], [0, 128]);
			_traceMask.graphics.drawRect(-GlobalConfig.MAP_CELL_SIZE, -GlobalConfig.MAP_CELL_SIZE*0.75, GlobalConfig.MAP_CELL_SIZE, GlobalConfig.MAP_CELL_SIZE*1.5);
			_traceMask.graphics.endFill();
			_traceMask.cacheAsBitmap = true;
			
			_trace = new Sprite();
			_trace.mask = _traceMask;
			_trace.visible = false;
			
			_traceContainer = new Sprite();
			_traceContainer.addChild(_traceMask);
			_traceContainer.addChild(_trace);
						
			_traceBitmap = new Bitmap();
			Map.getInstance().getSelectionContainer().addChild(_traceBitmap);
		}
		
		/*
		* Shape updates:
		*/		
		
		public override function update():void
		{
			var object:MapLayerObject = _layer.getSelectedObject();
			
			if (object != null && object is ShipMapLayerObject && object != this && ShipMapLayerObject(object).getShip().getTarget() == _ship) {
				setColor(COLOR_TARGETED);
			} else if (object != this) {
				setColor(COLOR_NONE);
			}
			
			super.update();
		}
				
		private function updateEquipmentShapes():void
		{
			for (var i:uint=0; i<_equipmentShapes.length; i++) {
				_equipmentShapes[i].update();
			}
		}
		
		private function cacheShape():void
		{
			if (_shapeCacheBitmap && _shapeCacheBitmap.visible)
				removeChild(_shapeCacheBitmap);
			_shapeCacheBitmap = Rasterizer.toBitmap(_shape, Rasterizer.HALIGN_CENTER + Rasterizer.VALIGN_MIDDLE, Map.getInstance().scaleX);
			addChild(_shapeCacheBitmap);
			_shapeCacheBitmap.x = _shapeCacheBitmap.x + GlobalConfig.MAP_CELL_SIZE/2;
			_shapeCacheBitmap.y = _shapeCacheBitmap.y + GlobalConfig.MAP_CELL_SIZE/2;
		}
		
		private function cacheEquipmentShapes():void
		{
			for (var i:uint=0; i<_equipmentShapes.length; i++) {
				_equipmentShapes[i].cache(Map.getInstance().scaleX);
			}			
		}		
		
		/*
		* Move & animation
		*/			
		
		private var _engineSound:Sound;
		
		protected override function move():void
		{
			_propagateCounter = 0;
			super.move();
			
			if (_movePath.getPointsCount() > 0) {
				setMode(MODE_ANIMATION);
				prepareForAnimation();
				SoundController.startEngine();
			} else {
				onArrival();
			}
		}
		
		private function prepareForAnimation():void
		{
			var _tDx:Number = 0;
			var _tDy:Number = 0;			
			var _minX:Number = Number.MAX_VALUE;
			var _minY:Number = Number.MAX_VALUE;
			var _mapScale:Number = Map.getInstance().scaleX;
			
			_traceContainer.scaleX = 1/_mapScale;
			_traceContainer.scaleY = 1/_mapScale;
			
			/*
			 * Getting trace boundaries
			 */
			for (var z:uint=0; z<_movePath.getPointsCount(); z++) {
				if (z%5 == 2) {
					_point = _movePath.getPointAt(z);
					_minX = (_minX > _point.x) ? _point.x : _minX;
					_minY = (_minY > _point.y) ? _point.y : _minY;
				}
			}
			
			/*
			 * Setting draw style for wide trace
			 */
			_trace.cacheAsBitmap = false;
			_trace.graphics.clear();
			_trace.graphics.lineStyle(_hullHeight, 0xFFFFFF, 0.75);
			
			/*
			 * Calculating trace canvas offset
			 */
			_tDx = _hullWidth/2 + _hullHeight - _minX;
			_tDy = _hullHeight - _minY;
			
			
			/*
			 * Setting draw pointer to start position
			 */
			_p = Geometry.translate(new Point(-_hullWidth/2, 0), _shape.rotation);
			_trace.graphics.moveTo(_p.x + _tDx, _p.y + _tDy);
			_drawCommands.length = 0;
			_drawPoints.length = 0;
			
			/*
			 * Generating draw points array
			 */
			for (var i:uint=0; i<_movePath.getPointsCount(); i++) {
				if (i%5 == 2) {
					_point = _movePath.getPointAt(i);
					_p = Geometry.translate(new Point(-_hullWidth/8, 0), _point.rotation);
					_x = _point.x + _p.x + _tDx;
					_y = _point.y + _p.y + _tDy;
					_drawCommands.push(GraphicsPathCommand.LINE_TO);
					_drawPoints.push(_x);
					_drawPoints.push(_y);
				}
			}
			
			/*
			 * Drawing first (wide) trace
			 */
			_trace.graphics.drawPath(_drawCommands, _drawPoints);
			
			/*
			 * Setting draw style for thick trace
			 */
			_trace.graphics.lineStyle(_hullHeight/2, 0xFFFFFF, 0.75);			
			_p = Geometry.translate(new Point(-_hullWidth/2, 0), _shape.rotation);
			_trace.graphics.moveTo(_p.x + _tDx, _p.y + _tDy);
			_drawCommands.length = 0;
			_drawPoints.length = 0;
			
			/*
			 * Generating draw points array
			 */
			for (var t:uint=0; t<_movePath.getPointsCount(); t++) {
				if (t%5 == 2) {
					_point = _movePath.getPointAt(t);
					_p = Geometry.translate(new Point(-_hullWidth/8, 0), _point.rotation);
					_x = _point.x + _p.x + _tDx;
					_y = _point.y + _p.y + _tDy;
					_drawCommands.push(GraphicsPathCommand.LINE_TO);
					_drawPoints.push(_x);
					_drawPoints.push(_y);
				}
			}
			/*
			 * Drawing second (thick) trace
			 */
			_trace.graphics.drawPath(_drawCommands, _drawPoints);			
			_trace.cacheAsBitmap = true;
			
			/*
			 * Initiating sprites array
			 */
			if (_traceShapes == null) {
				_traceShapes = new Vector.<BitmapData>;
			} else {
				_traceShapes.length = 0;
			}
			
			Map.getInstance().getSelectionContainer().addChild(_traceContainer);
			_traceContainer.x = (-Map.getInstance().x ) / _mapScale;
			_traceContainer.y = (-Map.getInstance().y ) / _mapScale;
			
			/*
			 * Filling sprites array
			 */
			for (var j:uint=0; j<_movePath.getPointsCount(); j++) {
				if (j%5 == 2) {
					_point = _movePath.getPointAt(j);
					_p = Geometry.translate(new Point(-_hullWidth/8, 0), _point.rotation);
					_traceMask.x = _point.x + _tDx + _p.x;
					_traceMask.y = _point.y + _tDy + _p.y;
					_traceMask.rotation = _point.rotation;
					_trace.alpha = 0.1 + (_point.speed / _maxSpeed) * 0.8; 
					_traceShapes.push(Rasterizer.toBitmapData(_trace));
				}
			}
			
			Map.getInstance().getSelectionContainer().removeChild(_traceContainer);
			
			_trace.graphics.clear();
			_traceShapes.reverse();
			
			_traceBitmap.x = x + GlobalConfig.MAP_CELL_SIZE/2 - _tDx;
			_traceBitmap.y = y + GlobalConfig.MAP_CELL_SIZE/2 - _tDy;
		}
		
		protected override function onPropagate(point:PathPoint):void
		{
			if (_state == STATE_MOVING) {
				if (_movePath.getPointsCount() > (_pathIndex + COLLISION_TURNS_AHEAD + 1) && isColliding()) {				
					var point2:PathPoint = _movePath.getPointAt(_pathIndex + COLLISION_TURNS_AHEAD);
					
					if (point2 != null) {
						_pathIndex = 1;
						_movePath.setMaxLength(_speed*COLLISION_TURNS_AHEAD_FORECAST);
						_movePath.setStart(point);
						
						var acceleration:Number = point.speed/COLLISION_TURNS_AHEAD;
						
						_movePath.setAcceleration(acceleration);
						point2.speed = 0;						
						_movePath.setEnd(point2);
						_movePath.update();
					}
				}
				
				var _temp:Number = 0;
				var _dSpeed:Number = 0;
				
				if (_propagateCounter%3 == 1) {
					_x = x + GlobalConfig.MAP_CELL_SIZE/2;
					_y = y + GlobalConfig.MAP_CELL_SIZE/2;
					
					_dSpeed = point.speed/5;
					_temp = Math.round(_gFrontWaveBitmap.width * (0.5 + _dSpeed/2));
					if (Math.round(_frontWaveShape.width) != _temp) {
						_frontWaveShape.width = _temp;
					}
					
					_dSpeed = point.speed/_maxSpeed;
					
					_temp = Math.round(_hullHeight * (2 - _dSpeed));
					if (Math.round(_frontWaveShape.height) != _temp) {
						_frontWaveShape.height = _temp;
					}
					
					_temp = _hullWidth/2 - _frontWaveShape.width + (point.speed * _dSpeed / 4);
					if (_frontWaveShape.x != _temp) {
						_frontWaveShape.x = _temp;
					}
					
					_temp = -_frontWaveShape.height/2;
					if (_frontWaveShape.y != _temp) {
						_frontWaveShape.y = _temp;
					}
					
					if (_frontWaveShape.alpha != _dSpeed) {
						_frontWaveShape.alpha = _dSpeed;
					}
				}
				
				if (_propagateCounter%5 == 2) {
					if (_traceBitmap.bitmapData != null) {
						_traceBitmap.bitmapData.dispose();
						_traceBitmap.bitmapData = null;
					}
					
					if (_state == STATE_MOVING) {
						_traceBitmap.bitmapData = _traceShapes.pop();
										
						if (!_frontWaveShape.visible) {
							_frontWaveShape.visible = true;
							_shape.addChildAt(_frontWaveShape, 0);
						}
					}
				}
				
				if (_propagateCounter%4 == 3) {
					_x = _startX + point.x + GlobalConfig.MAP_CELL_SIZE/2;
					_y = _startY + point.y + GlobalConfig.MAP_CELL_SIZE/2;
					
					var dSpeed:Number = point.speed/_maxSpeed;
					
					for (var i:uint=0; i<_tubeShapes.length; i++) {
						if (i%2 == 0) {
							generateSmoke(_tubeShapes[i], _x, _y, point, dSpeed);
						}
					}
				}
				
				if (_propagateCounter%5 == 4) {
					updateEquipmentShapes();
				}
				
				_propagateCounter++;
			}
		}
		
		private function generateSmoke(_equipmentShape:MapEquipmentShape, _x:Number, _y:Number, point:PathPoint, dSpeed:Number):void
		{
			_gDecalsCount++;
			
			var smoke:DisplayObject = Rasterizer.clone(_gSmokeBitmap);
			smoke.width = smoke.width * (0.75 + dSpeed/4);
			smoke.height = smoke.height * (1 - dSpeed/2);
			_p = Geometry.translate(new Point(_equipmentShape.x/2 - _equipmentShape.width/4 - smoke.width, _equipmentShape.y/2 - smoke.height/2), point.rotation);
			
			smoke.x = _x + _p.x;
			smoke.y = _y + _p.y;
			smoke.rotation = point.rotation;
			smoke.alpha = 0.15 + (dSpeed)/3;
			
			Map.getInstance().getLayersContainer().addChild(smoke);
			
			setTimeout(
				function():void {
					smoke.visible = false;
					Map.getInstance().getLayersContainer().removeChild(smoke);
					smoke = null;
					_gDecalsCount--;
				}
				, 250
			);		
		}
		
		protected override function onArrival():void
		{	
			if (_frontWaveShape.visible) {
				_frontWaveShape.visible = false;
				_shape.removeChild(_frontWaveShape);
			}
			
			if (_traceBitmap != null && _traceBitmap.bitmapData != null) {
				_traceBitmap.bitmapData.dispose();
				_traceBitmap.bitmapData = null;
			}
			
			SoundController.stopEngine();
		}

		private function isColliding():Boolean {
			var colliding:Boolean = false;
			var range:Number = 0;
			
			for (var i:uint = 0; i < _ships.length; i++) {
				var target:ShipMapLayerObject = _ships[i]; 
				if (this != target) {
					
					range = Geometry.getRange(this, target);
					
					if (range < GlobalConfig.MAP_CELL_SIZE*2) {
						// do not calculate for very distant ships
						
						var stepsAhead:uint = Math.min(COLLISION_TURNS_AHEAD_FORECAST, _movePath.getPointsCount() - _pathIndex - 2);
						var from:uint = _pathIndex - 1;
						var to:uint = from + stepsAhead;
						
						for (var j:uint=from; j < to;  j++) {
							if (_isColliding(_movePath.getPointAt(j), target)) {
								colliding = true;
								break;
							}
						}
					}
				}
			}
			
			return colliding;			
		}
		
		private function _isColliding(point:PathPoint, target:ShipMapLayerObject):Boolean
		{
			var colliding:Boolean = false;
			
			var p1:Point = Geometry.translate(new Point(-this.getHullWidth()/2, 0), point.rotation);
			p1 = p1.add(new Point(point.x + _startX, point.y + _startY));
			var p2:Point = Geometry.translate(new Point(this.getHullWidth()/2 + point.speed, 0), point.rotation);
			p2 = p2.add(new Point(point.x + _startX, point.y + _startY));
			
			var p3:Point = Geometry.translate(new Point(-target.getHullWidth()/2, 0), target.getMapShape().rotation);
			p3 = p3.add(new Point(target.x, target.y));
			var p4:Point = Geometry.translate(new Point(target.getHullWidth()/2 + target.getSpeed()*COLLISION_TURNS_AHEAD_FORECAST, 0), target.getMapShape().rotation);
			p4 = p4.add(new Point(target.x, target.y));
			
			var r1:Number = ((p3.x-p1.x)*(p2.y-p1.y)-(p3.y-p1.y)*(p2.x-p1.x))*((p4.x-p1.x)*(p2.y-p1.y)-(p4.y-p1.y)*(p2.x-p1.x));
			var r2:Number = ((p1.x-p3.x)*(p4.y-p3.y)-(p1.y-p3.y)*(p4.x-p3.x))*((p2.x-p3.x)*(p4.y-p3.y)-(p2.y-p3.y)*(p4.x-p3.x));
			
			//trace(p1 + " x " + p2 + " / " + p3 + " x " + p4 + " = " + r1 + " / " + r2);
			
			if ((r1<=0) && (r2<=0)) {
				//trace("!");
				colliding = true;
			}			
			
			return colliding;
		}

		
		protected override function onCellMouseUp(e:Event):void
		{
			var object:MapLayerObject = _layer.getActiveObject();
			if (_selected
				&&
				object != null
				&&
				object is ShipMapLayerObject
				&&
				ShipMapLayerObject(object).getShip().getNation() != _ship.getNation()
			) {				 
				setTarget(ShipMapLayerObject(object));
			} else {
				super.onCellMouseUp(e);
			}
		}
		
		protected function setTarget(target:ShipMapLayerObject):void
		{
			if (_target == target) {
				var object:ShipMapLayerObject = _target;
				_target = null;
				_ship.setTarget(null);
				object.update();
			} else {
				if (_target != null) {
					_ship.setTarget(null);
					_target.update();
				}
				_target = target;
				_ship.setTarget(_target.getShip());
				_target.update();
			}
		}
		
		protected override function onActiveCell(e:Event):void
		{
			super.onActiveCell(e);
			if (_selected
				&&
				_layer.getActiveObject() != null
				&&
				_layer.getActiveObject() is ShipMapLayerObject
				&&
				ShipMapLayerObject(_layer.getActiveObject()).getShip().getNation() != _ship.getNation()
			) {
				Map.getInstance().getCursor().setState(MapCursor.STATE_TARGET);
			}			
		}
		
		public override function select(select:Boolean = true):void
		{
			super.select(select);
			
			if (!_selected && _target != null) {
				setTimeout(_target.update, 100);
			} else if (_selected && _target != null) {
				_target.update();
			}
		}
		
		public override function isSelectable():Boolean
		{
			return super.isSelectable() && (_ship.getNation() == Application.getContext().getNation());
		}
		
		public function getShip():Ship
		{
			return _ship;
		}
		
		public override function setMode(mode:uint):void
		{
			if (_mode != mode) {
				switch(mode) {
					case MODE_NORMAL:
						if (_state != STATE_MOVING) {
							
							_label.visible = true;
							_label.scaleX = 1/Map.getInstance().scaleX;
							_label.scaleY = 1/Map.getInstance().scaleY;
													
							if (_mode == MODE_ANIMATION || Map.getInstance().getMode() == Map.MODE_SCALE) {
								if (_mode != MODE_ANIMATION) {
									cacheEquipmentShapes();
								}
								cacheShape();
							}
							
							if (_shape.visible) {
								//removeChild(_shape);
								_shape.visible = false;
							}
							
							if (!_shapeCacheBitmap.visible) {
								addChild(_shapeCacheBitmap);
								_shapeCacheBitmap.visible = true;
							}
							super.setMode(mode);
						}
						break;
					case MODE_TRANSFORMATION:						
						if (_state != STATE_MOVING) {
							_label.visible = false;
							if (_shape.visible) {
								//removeChild(_shape);
								_shape.visible = false;
							}
							
							if (!_shapeCacheBitmap.visible) {
								addChild(_shapeCacheBitmap);
								_shapeCacheBitmap.visible = true;
							}
							super.setMode(mode);
						}						
						break;
					case MODE_ANIMATION:
						_label.visible = false;
						
						if (!_shape.visible) {
							//addChild(_shape);
							_shape.visible = true;
						}
						
						if (_shapeCacheBitmap.visible) {
							removeChild(_shapeCacheBitmap);
							_shapeCacheBitmap.visible = false;
						}
						
						cacheEquipmentShapes();
						super.setMode(mode);
						break;
				}
			}
		}
		
		public function getHullShape():MapEquipmentShape
		{
			return _hullShape;
		}
		
		public function getHullWidth():Number
		{
			return _hullWidth
		}
		
		public function getHullHeight():Number
		{
			return _hullHeight;
		}
		
		/* Static routine */
		
		public static function getDecalsCount():uint
		{
			return _gDecalsCount;
		}
		
		public static function getShipMapLayerObjects():Vector.<ShipMapLayerObject>
		{
			return _ships;
		}
	}
}