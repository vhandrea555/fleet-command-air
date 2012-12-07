package com.ad.games.fc.view.map
{
	import com.ad.games.fc.view.map.object.MapLayerObject;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public final class MapLayer extends EventDispatcher
	{	
		private var _objects:Vector.<MapLayerObject>;
		private var _selectedObject:MapLayerObject;
				
		public function MapLayer()
		{
			Map.getInstance().addEventListener(Map.EVENT_MOUSE_UP, onCellMouseUp);
			_objects = new <MapLayerObject>[];
		}
		
		private function onCellMouseUp(e:Event):void
		{
			var cell:MapCell = Map.getInstance().getActiveCell();
			var object:MapLayerObject = getObjectAtCell(cell);
			if (object != null) {
				(getSelectedObject() != object) ? selectObject(object) : deSelectObject();
			}
			dispatchEvent(new Event(Map.EVENT_MOUSE_UP));
		}
		
		public function selectObject(object:MapLayerObject):void
		{
			if (object != _selectedObject) {
				if (object.isSelectable()) {
					if (_selectedObject != null) {
						_selectedObject.select(false);
					}
					_selectedObject = object;
					_selectedObject.select();
				}
			}
		}
		
		public function deSelectObject():void
		{
			if (_selectedObject != null) {					
				_selectedObject.select(false);
				_selectedObject = null;
			}
		}
		
		public function getSelectedObject():MapLayerObject
		{
			return _selectedObject;
		}
		
		public function getActiveObject():MapLayerObject
		{
			return getObjectAtCell(Map.getInstance().getActiveCell());
		}
		
		public function getObjectAtCell(cell:MapCell):MapLayerObject
		{
			var object:MapLayerObject = null;
			for (var i:uint=0; i<_objects.length; i++) {
				if (_objects[i].getCell() == cell) {
					object = _objects[i];
					break;
				}
			}
			
			return object;
		}
		
		public function update():void
		{
			for (var j:uint = 0; j<_objects.length; j++) {
				_objects[j].update();
			}
		}
		
		public function addObject(object:MapLayerObject):int
		{
			Map.getInstance().getLayersContainer().addChild(object);
			return (_objects.push(object)-1);			
		}
		
		public function getObject(i:uint):MapLayerObject
		{
			return _objects[i];
		}

		public function getObjects():Vector.<MapLayerObject>
		{
			return _objects;
		}
	}
}