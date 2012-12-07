package com.ad.games.fc.model
{

	public class ApplicationContext
	{
		private var _nation:Nation;
		
		public function ApplicationContext()
		{}
		
		public function setNation(nation:Nation):void {
			_nation = nation;
		}
		
		public function getNation():Nation {
			return _nation;
		}
		
	}
}