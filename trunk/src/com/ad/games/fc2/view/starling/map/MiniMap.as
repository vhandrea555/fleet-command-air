package com.ad.games.fc2.view.starling.map
{
	import com.ad.games.fc2.config.GlobalConfig;
	import com.ad.games.fc2.view.starling.base.BaseView;
	import com.ad.games.fc2.view.starling.map.object.MapLayerObject;
	import com.ad.games.fc2.view.starling.map.object.ShipMapLayerObject;
	import com.ad.games.fc2.view.utils.DeviceProperties;
	import com.ad.games.fc2.view.utils.Rasterizer;
	
	import flash.display.Sprite;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	public final class MiniMap extends BaseView
	{
		private var _map:MapView;
		private var _frame:DisplayObject;
		private static const SCALE:Number = 0.05;
		private var _objects:Vector.<MapLayerObject>; 
		private var _objectShapes:Vector.<Sprite>;
		
		public function MiniMap(map:MapView)
		{
			super();
			_map = map;
			_objectShapes = new <Sprite> [];
		}
		
		protected override function draw():void
		{
			super.draw();
			
			var bg:Sprite = new Sprite();
			bg.graphics.lineStyle(1, 0x0);
			bg.graphics.drawRect(0, 0, _map.width*SCALE, _map.height*SCALE);
			bg.graphics.endFill();
			
			addChild(Rasterizer.fromSpriteToImage(bg, false, 0x3399FF));
			
			var frame:Sprite = new Sprite();
			frame.graphics.lineStyle(1, 0xFF0000);			
			frame.graphics.drawRect(0, 0, DeviceProperties.getScreenSize().width*SCALE, DeviceProperties.getScreenSize().height*SCALE);
			_frame = Rasterizer.fromSpriteToImage(frame, true);
			addChild(_frame);
			
			_objects = MapLayerObject.getMapLayerObjects();
			
			/*
			for (var i:uint=0; i<_objects.length; i++) {
				_objectShapes[i] = new Sprite();
				var color:uint = (_objects[i] is ShipMapLayerObject) ? ShipMapLayerObject(_objects[i]).getShip().getNation().getColor() : 0xFFFFFF;
				_objectShapes[i].graphics.beginFill(color);
				_objectShapes[i].graphics.drawRect(0, 0, GlobalConfig.MAP_CELL_SIZE*SCALE, GlobalConfig.MAP_CELL_SIZE*SCALE);
				_objectShapes[i].graphics.endFill();
				addChild(_objectShapes[i]);
			}
			*/
			
			scaleX = 0.2 * DeviceProperties.getScreenSize().width/width;
			scaleY = scaleX;
		}
		
		public override function update():void
		{
			super.update();
			
			var _scaleX:Number = 1/_map.scaleX;
			var _scaleY:Number = 1/_map.scaleY;
			
			_frame.x = -_map.x*SCALE*_scaleX;
			_frame.y = -_map.y*SCALE*_scaleY;
			_frame.scaleX = _scaleX;
			_frame.scaleY = _scaleY;

			_scaleX = SCALE;
			_scaleY = SCALE;
			
			/*
			for (var i:uint=0; i<_objects.length; i++) {
				_objectShapes[i].x = _objects[i].x*_scaleX;
				_objectShapes[i].y = _objects[i].y*_scaleY;
			}
			*/
		}
	}
}