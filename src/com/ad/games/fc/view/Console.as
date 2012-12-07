package com.ad.games.fc.view
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public final class Console extends Sprite
	{
		
		private static var _instance:Console;
		private static var _output:TextField;
		
		public function Console()
		{
			super();
			var style:TextFormat = new TextFormat("Arial", 30, 0);
			_output = new TextField();
			_output.setTextFormat(style);
			_output.defaultTextFormat = style;
			addChild(_output);
			_output.autoSize = TextFieldAutoSize.LEFT;
			_output.selectable = false;
		}
		
		public static function getInstance():Console
		{
			if (_instance == null) {
				_instance = new Console();
			}
			
			return _instance;
		}
		
		public static function attach(_parent:Sprite):void
		{
			_parent.addChild(getInstance());
		}
		
		public static function append(_text:String):void
		{
			getInstance();
			_output.appendText(_text);
		}

		public static function appendLine(_text:String):void
		{
			getInstance();
			_output.appendText("\n" + _text);
		}
		
		public static function clear():void
		{
			getInstance();
			_output.text = "";
		}
	}
}