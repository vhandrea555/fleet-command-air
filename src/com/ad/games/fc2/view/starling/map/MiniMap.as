package com.ad.games.fc.view.map
{
	import com.ad.games.fc.Application;
	import com.ad.games.fc.view.base.BaseView;
	import com.ad.games.fc.view.map.object.MapLayerObject;
	import com.ad.games.fc.view.map.object.ShipMapLayerObject;
	
	import flash.display.Sprite;
	
	public final class MiniMap extends BaseView
	{
		private static var _map:Map;
		private static var _frame:Sprite;
		private static const SCALE:Number = 0.05;
		private static var _objects:Vector.<MapLayerObject>; 
		private static var _objectShapes:Vector.<Sprite>;
		
		public function MiniMap(map:Map)
		{
			super();
			_map = map;
			_objectShapes = new <Sprite> [];
		}
		
		protected override function draw():void
		{
			super.draw();
			
			graphics.lineStyle(0.5, 0x0);
			graphics.beginFill(0x3399FF);
			graphics.drawRect(0, 0, _map.width*SCALE, _map.height*SCALE);
			graphics.endFill();
			
			_frame = new Sprite();
			_frame.graphics.lineStyle(0.5, 0xFF0000);			
			_frame.graphics.drawRect(0, 0, Application.getSreenWidth()*SCALE, Application.getSreenHeight()*SCALE);
			addChild(_frame);
			
			_objects = MapLayerObject.getMapLayerObjects();
			
			for (var i:uint=0; i<_objects.length; i++) {
				_objectShapes[i] = new Sprite();
				var color:uint = (_objects[i] is ShipMapLayerObject) ? ShipMapLayerObject(_objects[i]).getShip().getNation().getColor() : 0xFFFFFF;
				_objectShapes[i].graphics.beginFill(color);
				_objectShapes[i].graphics.drawRect(0, 0, MapCell.SIZE*SCALE, MapCell.SIZE*SCALE);
				_objectShapes[i].graphics.endFill();
				addChild(_objectShapes[i]);
			}
			
			scaleX = 0.2 * Application.getSreenWidth()/width;
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
			
			for (var i:uint=0; i<_objects.length; i++) {
				_objectShapes[i].x = _objects[i].x*_scaleX;
				_objectShapes[i].y = _objects[i].y*_scaleY;
			}
		}
	}
}