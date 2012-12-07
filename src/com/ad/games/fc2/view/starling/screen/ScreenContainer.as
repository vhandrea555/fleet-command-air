package com.ad.games.fc2.view.starling.screen
{
	import com.ad.games.fc2.view.starling.base.BaseScreen;
	
	public class ScreenContainer extends BaseScreen
	{
		
		private var _currentScreen:BaseScreen;
		
		public function ScreenContainer()
		{
			super();
			this.update();
		}
		
		protected override function draw():void {
			super.draw();
			_currentScreen = new MapScreen();			
			addChild(_currentScreen);
			_currentScreen.update();
		}
	}
}