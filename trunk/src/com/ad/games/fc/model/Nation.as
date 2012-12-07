package com.ad.games.fc.model
{
	import com.ad.games.fc.config.Config;
	
	public final class Nation
	{
		private var _name:String;
		private var _color:uint;
		private var _id:uint;
		
		public static const BRITISH:uint = 0;
		public static const GERMAN:uint = 1;
		public static const RUSSIAN:uint = 2;
		public static const JAPAN:uint = 3;
		public static const FRANCE:uint = 4;
		
		private static var _nations:Vector.<Nation> = new Vector.<Nation>;
		
		public function Nation(id:uint, name:String, color:uint)
		{
			_id = id;
			_name = name;
			_color = color;
		}
		
		public function getColor():uint
		{
			return _color;
		}
		
		public function getName():String
		{
			return _name;
		}
		
		public function getId():uint
		{
			return _id;
		}
		
		public static function getNations():Vector.<Nation> {
			if (_nations.length == 0) {
				_nations = ConfigLoader.loadNationsList(Config.NATIONS);
			}
			return _nations;
		}
		
		public static function getNation(i:uint):Nation
		{
			return getNations()[i];
		}		
	}
}