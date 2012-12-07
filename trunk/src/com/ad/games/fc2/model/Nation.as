package com.ad.games.fc2.model
{
	public final class Nation
	{
		private var _name:String;
		private var _color:uint;
		private var _id:uint;
		
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
	}
}