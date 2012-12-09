package com.ad.games.fc2
{
	import com.ad.games.fc2.model.ApplicationContext;
	import com.ad.games.fc2.view.starling.screen.ScreenContainer;
	import com.ad.games.fc2.view.utils.Console;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="960", height="640", stageFocusRect="false", wmode="direct")]
	public class Application extends Sprite
	{
		private static var _instance:Application;
		private static var _context:ApplicationContext = new ApplicationContext();
		
		private var _canvas:Starling;
		private var _screenContainer:ScreenContainer;
		
		public function Application()
		{
			super();
			_instance = this;
			loaderInfo.addEventListener(Event.INIT, init);			
		}
		
		public static function getInstance():Application
		{
			return _instance;
		}
		
		private function init(e:Event = null):void
		{
			try {
				//stage.setOrientation(StageOrientation.UPSIDE_DOWN);
			} catch(e:Error) {
				
			}
			stage.frameRate = 1000 / GlobalConfig.UPDATE_TIMEOUT_NORMAL;
			stage.quality = GlobalConfig.QUALITY_NORMAL;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			this.draw();
		}
		
		private function draw():void
		{
			_context.setNation(GlobalConfig.NATIONS[GlobalConfig.DEFAULT_NATION_ID]);
			
			_canvas = new Starling(ScreenContainer, stage);
			_canvas.showStats = true;
			_canvas.start();
			
			/*
			_mapView = new MapView(this);
			addChild(_mapView);
			
			_controlsView = new ControlsView(this);
			_controlsView.x = getSreenWidth();
			addChild(_controlsView);
			
			_controlsView.update();			
			_mapView.update();
			*/
			
			Console.attach(this);
		}
	}
}