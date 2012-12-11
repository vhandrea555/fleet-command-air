package com.ad.games.fc2
{
	import com.ad.games.fc2.model.ApplicationContext;
	import com.ad.games.fc2.view.starling.screen.ScreenContainer;
	import com.ad.games.fc2.view.utils.Console;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	
	[SWF(width="960", height="640", wmode="direct", backgroundAlpha=0)]
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
			//stage.quality = GlobalConfig.QUALITY_NORMAL;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.autoOrients = false;
			stage.color = 0x00FFFFFF;
			stage.stageWidth = 100;
			stage.stageHeight = 100;
			//setStyle("backgroundAlpha", 0);
			
			this.draw();
		}
		
		private function draw():void
		{
			_context.setNation(GlobalConfig.NATIONS[GlobalConfig.DEFAULT_NATION_ID]);
			
			Console.attach(this);
			Console.appendLine("START");
			
			Starling.multitouchEnabled = true;
			
			_canvas = new Starling(ScreenContainer, stage);
			_canvas.showStats = true;
			
			_canvas.antiAliasing = 1;
			_canvas.simulateMultitouch  = false;
			_canvas.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void
			{
				// Starling is ready! We remove the startup image and start the game.
				_canvas.start();
				Console.appendLine("started");
			});			
			
			/*
			if (NativeApplication) {
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,
					function (e:Event):void { _canvas.start(); });
				
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,
					function (e:Event):void { _canvas.stop(); });		
			}
			*/
			Console.appendLine("END");
		}
	}
}