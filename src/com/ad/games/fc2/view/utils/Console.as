package com.ad.games.fc2.view.utils
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public final class Console extends Sprite
	{
		
		private static var _instance:Console;
		private static var _output:TextField;
		private static var enableDisplay:Boolean;
		
		public function Console(_enableDisplay:Boolean = true)
		{
			super();
			enableDisplay = _enableDisplay;
			var style:TextFormat = new TextFormat("Arial", 12, 0);
			_output = new TextField();
			_output.setTextFormat(style);
			_output.defaultTextFormat = style;
			_output.width = 480;
			_output.wordWrap = true;
			
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
		
		public static function attach(_parent:Sprite):Console
		{
			_parent.addChild(getInstance());
			return getInstance();
		}
		
		public static function append(_text:String, object:Object = null):void
		{
			getInstance();
			
			_text = ((object != null) ? getDefinitionByName(getQualifiedClassName(object)) : "") + " " + _text;
			
			if (enableDisplay) {
				_output.text =  _text + "\n" + _output.text;
			}
			
			trace(_text);
		}
		
		public static function clear():void
		{
			getInstance();
			_output.text = "";
		}
	}
}