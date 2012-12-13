package com.ad.games.fc2
{
	import com.ad.games.fc2.model.ApplicationContext;
	import com.ad.games.fc2.view.starling.screen.ScreenContainer;
	import com.ad.games.fc2.view.utils.Console;
	import com.ad.games.fc2.view.utils.DeviceProperties;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	
	[SWF(width="960", height="640", wmode="direct")]
	public final class Application extends Sprite
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
						
			stage.addEventListener(Event.RESIZE, handleResize);
			handleResize();
			
			draw();
		}
		
		private function handleResize() :void {

			Console.append("stage " + stage.stageWidth + " x " + stage.stageHeight, this);
			Console.append("stage screen " + stage.fullScreenWidth + " x " +  stage.fullScreenHeight, this);
			Console.append("device screen " + Capabilities.screenResolutionX + " x " +  Capabilities.screenResolutionY + " dpi=" + Capabilities.screenDPI, this);
		}
		
		// call handleResize to initialize the first time
				
		
		private function draw():void
		{
			if (GlobalConfig.SHOW_CONSOLE) {
				Console.attach(this).y = 25;
			}
			Console.append("draw start", this);
			
			_context.setNation(GlobalConfig.NATIONS[GlobalConfig.DEFAULT_NATION_ID]);
						
			Starling.multitouchEnabled = true;
			
			Console.append("stage " + stage.stageWidth + " x " + stage.stageHeight, this);
			
			var viewPort:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);			
			_canvas = new Starling(ScreenContainer, stage, viewPort, null, Context3DRenderMode.AUTO, "baseline");
			_canvas.showStats = GlobalConfig.SHOW_RENDERER_STATS;
			_canvas.antiAliasing = GlobalConfig.DEFAULT_ANTIALIASING;
			
			_canvas.simulateMultitouch  = !DeviceProperties.isTouchInterface();
			_canvas.start();
			
			Console.append("draw end", this);
		}
	}
}