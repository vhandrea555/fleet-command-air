package com.ad.games.fc2.view.starling.screen
{
	import com.ad.games.fc2.view.starling.base.BaseScreen;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class ScreenContainer extends BaseScreen
	{
		
		private var _currentScreen:BaseScreen;
		
		public function ScreenContainer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		protected override function draw():void {
			super.draw();
			_currentScreen = new MapScreen();			
			addChild(_currentScreen);
			_currentScreen.update();
		}
	}
}