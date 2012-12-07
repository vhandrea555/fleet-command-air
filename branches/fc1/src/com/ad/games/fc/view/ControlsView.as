package com.ad.games.fc.view
{
	import com.ad.games.fc.Application;
	import com.ad.games.fc.view.base.BaseApplicationView;
	import com.ad.games.fc.view.map.MapCell;
	
	import flash.display.Sprite;
	
	public final class ControlsView extends BaseApplicationView
	{
		private static var _goButton:Sprite;
		private static var _testButton:Sprite;
		private static var _nationButtons:Vector.<Sprite>;
		private static var _changeNation:Sprite;
				
		public static const EVENT_BUTTON_GO_CLICK:String = "onGoButtonClick";
		
		public function ControlsView(_app:Application)
		{
			super(_app);
			_nationButtons = new <Sprite>[];
		}
		
		protected override function draw():void
		{
			
			_changeNation = new Sprite();
			_changeNation.y = 0;
			_changeNation.graphics.lineStyle(5, 0x0);
			_changeNation.graphics.beginFill(0x0000FF);
			_changeNation.graphics.drawCircle(MapCell.SIZE/2, MapCell.SIZE/2, MapCell.SIZE/2);
			_changeNation.graphics.endFill();
			_changeNation.useHandCursor = true;
			addChild(_changeNation);			
			
			_goButton = new Sprite();
			_goButton.y = 0;
			_goButton.graphics.lineStyle(5, 0x0);
			_goButton.graphics.beginFill(0x00FF00);
			_goButton.graphics.drawCircle(MapCell.SIZE/2, MapCell.SIZE/2, MapCell.SIZE/2);
			_goButton.graphics.endFill();
			_goButton.useHandCursor = true;
			addChild(_goButton);
			
			_testButton = new Sprite();
			_testButton.y = 0;
			_testButton.graphics.lineStyle(5, 0x0);
			_testButton.graphics.beginFill(0xFF0000);
			_testButton.graphics.drawCircle(MapCell.SIZE/2, MapCell.SIZE/2, MapCell.SIZE/2);
			_testButton.graphics.endFill();
			_testButton.useHandCursor = true;
			addChild(_testButton);
			
			scaleX = 0.1 * Application.getSreenWidth()/width;
			scaleY = scaleX;
		}
		
		public override function update():void
		{
			super.update();
			_goButton.x = -_goButton.width;
			_testButton.x = _goButton.x - _testButton.width;
			_changeNation.x = _testButton.x - _changeNation.width;
		}
				
		public function getGoButton():Sprite
		{
			return _goButton;
		}
		
		public function getTestButton():Sprite
		{
			return _testButton;
		}
		
		public function getChangeNationButton():Sprite
		{
			return _changeNation;
		}		
	}
}