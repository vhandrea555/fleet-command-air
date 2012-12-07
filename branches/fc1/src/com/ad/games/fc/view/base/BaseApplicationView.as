package com.ad.games.fc.view.base
{
	import com.ad.games.fc.Application;

	public class BaseApplicationView extends BaseView
	{
		protected var _app:Application; 
		
		public function BaseApplicationView(app:Application)
		{
			super();
			_app = app;
		}
	}
}