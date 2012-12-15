package com.ad.games.fc
{
	import com.ad.games.fc.model.ApplicationContext;
	import com.ad.games.fc.model.Nation;
	import com.ad.games.fc.view.Console;
	import com.ad.games.fc.view.ControlsView;
	import com.ad.games.fc.view.MapView;
	import com.ad.games.fc.view.map.object.MapLayerMovingObject;
	import com.ad.games.fc.view.utils.FPSCounter;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.system.TouchscreenType;
	import flash.utils.Timer;

	[SWF(width="960", height="640", stageFocusRect="false", wmode="opaque")]
	
	public final class Application extends Sprite
	{
		private static var _mapView:MapView;
		private static var _controlsView:ControlsView;
		
		public static const UPDATE_TIMEOUT_NORMAL:uint = 20;
		public static const UPDATE_TIMEOUT_LOW:uint = 20;
		public static const QUALITY_NORMAL:String = StageQuality.HIGH;
		
		private static var _instance:Application;
		private static var _context:ApplicationContext = new ApplicationContext();
		
		public function Application()
		{
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
			stage.frameRate = 1000 / UPDATE_TIMEOUT_NORMAL;
			stage.quality = QUALITY_NORMAL;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			this.draw();
		}
		
		private function draw():void
		{
			_context.setNation(Nation.getNation(Nation.GERMAN));
			
			_mapView = new MapView(this);
			addChild(_mapView);
			
			_controlsView = new ControlsView(this);
			_controlsView.x = getSreenWidth();
			addChild(_controlsView);
			
			_controlsView.update();			
			_mapView.update();
			
			Console.attach(this);
//			Console.appendLine("Free memory: " + System.freeMemory.toString());
//			Console.appendLine("Total memory: " + System.totalMemory.toString());
//			Console.appendLine("cpuArchitecture: " + Capabilities.cpuArchitecture);
//			Console.appendLine("os: " + Capabilities.os);
//			Console.appendLine("playerType: " + Capabilities.playerType);
//			Console.appendLine("DPI: " + Capabilities.screenDPI);
			//stage.stageWidth = Capabilities.screenResolutionX;
			//stage.stageHeight = Capabilities.screenResolutionY;
			//stage.width = Capabilities.screenResolutionX;
			//stage.height = Capabilities.screenResolutionY;
			//Console.appendLine("Stage: " + stage.stageWidth + " x " + stage.stageHeight);
			//Console.appendLine("Screen: " + Capabilities.screenResolutionX + " x " + Capabilities.screenResolutionY);
			//Console.appendLine("Screen: " + getSreenWidth() + " x " + getSreenHeight());
			
//			Console.appendLine("Touchscreen: " + Capabilities.touchscreenType);
			var timer:Timer = new Timer(3000, 0);
			timer.addEventListener(TimerEvent.TIMER, displayStat);
			//timer.start();
			//displayStat();
			addChild(new FPSCounter());
		}
		
		private function displayStat(e:TimerEvent = null):void
		{
			Console.clear();
			Console.appendLine("Free memory: " + Number( System.freeMemory / 1024 / 1024 ).toFixed( 2 ) + "Mb");
			Console.appendLine("Total memory: " + Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + "Mb");
			Console.appendLine("Private memory: " + Number( System.privateMemory / 1024 / 1024 ).toFixed( 2 ) + "Mb");
		}
		
		public static function getContext():ApplicationContext
		{
			return _context;
		}
		
		public function getControlsView():ControlsView
		{
			return _controlsView;
		}
		
		public static function isTouchInterface():Boolean
		{
			return Capabilities.touchscreenType == TouchscreenType.FINGER;
		}
		
		public function setUpdateTimeout(delay:Number):void
		{
			stage.frameRate = 1000 / delay;
			MapLayerMovingObject.setUpdateTimeout(delay);
		}
		
		private static var screenWidth:int;
		private static var screenHeight:int;
		
		public static function getSreenWidth():int
		{
			if (!screenWidth) {
				screenWidth = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
				screenWidth = Math.min(Application.getInstance().stage.stageWidth, screenWidth);
			}
			return screenWidth;
		}
		
		public static function getSreenHeight():int
		{
			if (!screenHeight) {
				screenHeight = Math.min(Capabilities.screenResolutionY, Capabilities.screenResolutionX);
				screenHeight = Math.min(Application.getInstance().stage.stageHeight, screenHeight);
			}
			return screenHeight;
		}
	}
}