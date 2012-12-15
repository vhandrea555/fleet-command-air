package com.ad.games.fc.view
{
	import com.ad.games.fc.Application;
	import com.ad.games.fc.config.MapConfig;
	import com.ad.games.fc.model.ConfigLoader;
	import com.ad.games.fc.model.Nation;
	import com.ad.games.fc.view.base.BaseApplicationView;
	import com.ad.games.fc.view.map.Map;
	import com.ad.games.fc.view.map.MapCell;
	import com.ad.games.fc.view.map.MiniMap;
	import com.ad.games.fc.view.map.object.MapLayerMovingObject;
	import com.ad.games.fc.view.map.object.ShipMapLayerObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public final class MapView extends BaseApplicationView
	{
		private static var _map:Map;
		private static var _miniMap:MiniMap;
		private static var _testTimer:Timer;
		private static var _nationIndication:TextField;
				
		public function MapView(_app:Application)
		{
			super(_app);
			_testTimer = new Timer(1000, 0);
			_testTimer.addEventListener(TimerEvent.TIMER, captureFps);
		}
		
		protected override function draw():void {
			super.draw();
			
			_map = ConfigLoader.loadMap(MapConfig.MAP_DEFAULT);
			addChild(_map);
			_map.update();
			
			_app.getControlsView().getGoButton().addEventListener(MouseEvent.MOUSE_DOWN, onGoButtonClick);
			_app.getControlsView().getTestButton().addEventListener(MouseEvent.MOUSE_DOWN, onTestButtonClick);
			_app.getControlsView().getChangeNationButton().addEventListener(MouseEvent.MOUSE_DOWN, onChangeNationButtonClick);
						
			_miniMap = new MiniMap(_map);
			addChild(_miniMap);
			_miniMap.update();
			_miniMap.y = 0;
			_map.addEventListener(Map.EVENT_MAP_UPDATE, onMapUpdate);
			
			var style:TextFormat = new TextFormat("Arial", Application.getSreenWidth()*0.02, 0);
			_nationIndication = new TextField();
			_nationIndication.setTextFormat(style);
			_nationIndication.defaultTextFormat = style;
			_nationIndication.autoSize = TextFieldAutoSize.NONE;
			
			addChild(_nationIndication);
			_nationIndication.y = Application.getSreenHeight() - _nationIndication.height;
			_nationIndication.cacheAsBitmap = true;
			
			setNation(Application.getContext().getNation());
		}

		
		private function move():void
		{
			Application.getInstance().setUpdateTimeout(Application.UPDATE_TIMEOUT_LOW);
			var _this:MapView = this;
			
			setTimeout( function():void {
				_testStartTime = (new Date()).time;
				_frames = 0;
				_fpsCounter = 0;
				_this.addEventListener(Event.ENTER_FRAME, _this.count);				
				_testTimer.start();
			}, MapLayerMovingObject.MOVE_DELAY);
			
			MapLayerMovingObject.move();
		}
		
		/* Tests related */
		
		private function test():void
		{
			var objects:Vector.<MapLayerMovingObject> = MapLayerMovingObject.getMapLayerMovingObjects();
			var ship:ShipMapLayerObject;
			
			for (var i:uint; i<objects.length; i++) {
				if (objects[i] is ShipMapLayerObject) {
					if (ship !=null) {
						ShipMapLayerObject(objects[i]).getShip().setTarget(ship.getShip());
					}
					ship = ShipMapLayerObject(objects[i]);
					var cell:MapCell = ship.getCell();
					ship.pathToCell(_map.getCell(cell.getCol()+3, cell.getRow()+1));
				}
			}
						
			move();
		}
		
		private static var _frames:uint = 0;
		private static var _maxFps:Number = Number.MIN_VALUE;
		private static var _minFps:Number = Number.MAX_VALUE;
		private static var _testStarted:Boolean = false;
		private static var _testStartTime:Number = 0;
		private static var _maxShapes:uint = 0;
		private static var _shapesSum:uint = 0;
		
		private function count(e:Event):void
		{
			if (_maxShapes < ShipMapLayerObject.getDecalsCount()) {
				_maxShapes = ShipMapLayerObject.getDecalsCount();
			}
			_shapesSum += ShipMapLayerObject.getDecalsCount(); 
			
			//trace(ShipMapLayerObject.getDecalsCount() + " max " +_maxShapes + " sum " + _shapesSum);

			_frames++;
			_fpsCounter++;
			
			if (!_testStarted && MapLayerMovingObject.getMovingCount() > 0) {
				_testStarted = true;
			}
			
			if (_testStarted && MapLayerMovingObject.getMovingCount() == 0) {
				finishTest();
			}
		}
		
		private static var _fpsCounter:uint = 0;
		
		private function captureFps(e:TimerEvent):void
		{
			if (_maxFps < _fpsCounter) {
				_maxFps = _fpsCounter;
			}
			if (_minFps > _fpsCounter && _fpsCounter > 0) {
				_minFps = _fpsCounter;
			}
			_fpsCounter = 0;
		}
		
		private function finishTest():void
		{
			_testTimer.stop();
			removeEventListener(Event.ENTER_FRAME, count);

			Console.clear();
			Console.appendLine("FPS: " + Math.round(_minFps) + " / " + Math.round(Number(_frames)/(((new Date()).time - _testStartTime)/1000)) + " / " + Math.round(_maxFps));
			
			_frames = 0;
			_testStarted = false;
			_testStartTime = 0;
			_maxShapes = 0;
			_shapesSum = 0;
			_fpsCounter = 0;
			_maxFps = Number.MIN_VALUE;
			_minFps = Number.MAX_VALUE;
			_miniMap.update();
			
			Application.getInstance().setUpdateTimeout(Application.UPDATE_TIMEOUT_NORMAL);
		}
		
		private function switchNation():void {
			var i:uint = Application.getContext().getNation().getId();
			i++;
			i = (i >= Nation.getNations().length) ? 0 : i; 			
			setNation(Nation.getNation(i));
		}
		
		private function setNation(nation:Nation):void {
			Application.getContext().setNation(nation);
			//trace(nation);
			_nationIndication.text = nation.getName();
			_nationIndication.textColor = nation.getColor();
		}		
		
		private function onMapUpdate(e:Event):void
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			e.preventDefault();
			_miniMap.update();
		}
		
		private function onGoButtonClick(e:MouseEvent):void
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			e.preventDefault();
			move();
		}
		
		private function onTestButtonClick(e:MouseEvent):void
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			e.preventDefault();			
			test();
		}
		
		private function onChangeNationButtonClick(e:MouseEvent):void
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			e.preventDefault();
			switchNation();
		}
	}
}