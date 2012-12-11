package com.ad.games.fc2.view.starling.screen
{
	import com.ad.games.fc2.view.starling.base.BaseScreen;
	import com.ad.games.fc2.view.utils.Console;
	
	import starling.events.Event;
	
	public class ScreenContainer extends BaseScreen
	{
		private var _currentScreen:BaseScreen;
		
		public function ScreenContainer()
		{
			super();
			Console.appendLine("ScreenContainer");
			addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		protected override function draw():void {
			super.draw();
			
			Console.appendLine("ScreenContainer1");
			
			_currentScreen = new MapScreen();			
			addChild(_currentScreen);
			_currentScreen.update();
			
			Console.appendLine("ScreenContainer2");
		}
	}
}