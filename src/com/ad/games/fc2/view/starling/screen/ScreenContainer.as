package com.ad.games.fc2.view.starling.screen
{
	import com.ad.games.fc2.view.starling.base.BaseScreen;
	import com.ad.games.fc2.view.utils.Console;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	public class ScreenContainer extends BaseScreen
	{
		private var _currentScreen:BaseScreen;
		
		public function ScreenContainer()
		{
			super();
			Console.append("init", this);
			addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		protected override function draw():void {
			super.draw();
			
			Console.append("draw start", this);
			
			Console.append(Starling.context.driverInfo, this);
			
			_currentScreen = new MapScreen();
			addChild(_currentScreen);
			_currentScreen.update();
			
			Console.append("draw end", this);
		}
	}
}