package com.ad.games.fc2.view.starling.map
{
	import com.ad.games.fc2.GlobalConfig;
	import com.ad.games.fc2.view.starling.base.BaseTouchView;
	import com.ad.games.fc2.view.starling.map.object.MapLayerObject;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.textures.Texture;
	
	public final class MapView extends BaseTouchView
	{
		public static const EVENT_ACTIVE_CELL:String = "onActiveCell";
		public static const EVENT_MOUSE_UP:String = "onMapMouseUp";
		public static const EVENT_MOUSE_DOWN:String = "onMapMouseDown";
		public static const EVENT_MAP_UPDATE:String = "onMapUpdate";
		
		private static var _layers:Vector.<MapLayer>;
		private static var _layersContainer:Sprite;
		private static var _selectionContainer:Sprite;
		private static var _rows:uint = 0;
		private static var _cols:uint = 0;
		private static var _cursor:MapCursor;
		
		private static var _cells:Vector.<MapCell>;
		private static var _activeCell:MapCell;
		private static var _instance:MapView;
		
		public function MapView(cols:uint, rows:uint)
		{
			super();
			_rows = rows;
			_cols = cols;
			_layers = new <MapLayer>[];
			_cells = new <MapCell>[];
			
			_layersContainer =  new Sprite();
			_cursor = new MapCursor();
			_selectionContainer = new Sprite();
			
			for (var r:uint=0; r<_rows; r++) {
				for (var c:uint=0; c<_cols; c++) {
					var cell:MapCell = new MapCell(c, r, this);
					cell.x = c*GlobalConfig.MAP_CELL_SIZE;
					cell.y = r*GlobalConfig.MAP_CELL_SIZE;
					_cells.push(cell);
				}
			}
			
			_instance = this;
		}
				
		private function drawBackground(factor:uint = 10):DisplayObject {
			var _width:Number = factor*GlobalConfig.MAP_CELL_SIZE;
			var _height:Number = factor*GlobalConfig.MAP_CELL_SIZE;
			
			var bgCell:flash.display.Sprite = new flash.display.Sprite();
			bgCell.opaqueBackground = 0x0066FF;
			bgCell.graphics.lineStyle(1, 0x3399FF);
			
			for (var i:uint = 0; i<factor; i++) {
				bgCell.graphics.moveTo(0, i*GlobalConfig.MAP_CELL_SIZE);
				bgCell.graphics.lineTo(_width, i*GlobalConfig.MAP_CELL_SIZE);
			}
			for (var j:uint = 0; j<factor; j++) {
				bgCell.graphics.moveTo(j*GlobalConfig.MAP_CELL_SIZE, 0);
				bgCell.graphics.lineTo(j*GlobalConfig.MAP_CELL_SIZE, _height);
			}
			
			var bitmap:BitmapData = new BitmapData(_width, _height);
			bitmap.draw(bgCell);			
			var texture:Texture = Texture.fromBitmapData(bitmap);
			var image:Image = new Image(texture);
			image.blendMode = BlendMode.NONE;
			
			var quadBatch:QuadBatch = new QuadBatch();
			quadBatch.blendMode = BlendMode.NONE;
			
			var cols:int = Math.ceil(_cols/factor);
			var rows:int = Math.ceil(_rows/factor);
			for (var _i:int=0; _i<cols; _i++) {
				for (var _j:int=0; _j<rows; _j++) {
					image.x = _i*_width;
					image.y = _j*_height;
					quadBatch.addImage(image);	
				}
			}
			
			return quadBatch;
		}		
		
		protected override function draw():void
		{
			super.draw();
			

			addChild(drawBackground());
			addChild(_selectionContainer);
			addChild(_layersContainer);
			addChild(_cursor);
			
			_cursor.update();
			_cursor.setState(MapCursor.STATE_SELECT);			
			
			/*
			if (DeviceProperties.isTouchInterface()) {
				Application.getInstance().stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, _onZoom);
			} else {
				Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			}
			
			Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			*/
		}
		
		public function addLayer():uint
		{
			var mapLayer:MapLayer = new MapLayer();
			return (_layers.push(mapLayer) - 1);
		}
		
		public function placeObject(object:MapLayerObject, cell:MapCell):void
		{
			object.placeTo(cell);
		}
		
		public function getLayer(z:uint):MapLayer
		{
			return _layers[z];
		}
		
		public function getCursor():MapCursor
		{
			return _cursor;
		}
		
		public function getCell(col:uint, row:uint):MapCell
		{
			var i:uint = row*_cols + col;
			return (i < _cells.length) ? _cells[i] : null;
		}
		
		public function getRows():uint
		{
			return _rows;
		}
		
		public function getCols():uint
		{
			return _cols;
		}
		
		private function getSelectedObjects():Vector.<MapLayerObject>
		{
			var objects:Vector.<MapLayerObject> = new <MapLayerObject>[];
			var object:MapLayerObject = null;
			
			for (var i:uint = 0; i<_layers.length; i++) {
				object = _layers[i].getSelectedObject();
				if (object != null) {
					objects.push(object);
				}
			}
			
			return objects;
		}
		
		public function getObjectsAtCell(cell:MapCell):Vector.<MapLayerObject>
		{
			var objects:Vector.<MapLayerObject> = new <MapLayerObject>[];
			var object:MapLayerObject = null;
			
			for (var i:uint = 0; i<_layers.length; i++) {
				object = _layers[i].getObjectAtCell(cell)
				if (object != null) {
					objects.push(object);
				}
			}
			
			return objects;
		}
		
		private function activateCell(cell:MapCell = null):void
		{
			if (cell == null) {				
				cell = getCellAt(getCursorPoint());
			}
			
			if (cell != null && cell != _activeCell) {
				_activeCell = cell;
				_cursor.placeTo(cell);
				dispatchEvent(new Event(EVENT_ACTIVE_CELL));
			}
		}
		
		public function getActiveCell():MapCell
		{
			return _activeCell;
		}
		
		public function getCellAt(p:Point):MapCell {
			var col:Number = Math.round((p.x - GlobalConfig.MAP_CELL_SIZE/2)/GlobalConfig.MAP_CELL_SIZE); 
			var row:Number = Math.round((p.y - GlobalConfig.MAP_CELL_SIZE/2)/GlobalConfig.MAP_CELL_SIZE);
			
			return getCell(col, row);
		}
		
		public override function update():void
		{
			super.update();
			
			for (var i:uint = 0; i<_layers.length; i++) {
				_layers[i].update();
			}
		}
		
		/*
		* Map zooming/scaling logics
		*/
		
		
		/*
		 * Touches processing
		 */

		protected override function onSingleTouchStart(touch:Touch):Boolean {
			return false;
		}
		
		protected override function onSingleTouchEnd(touch:Touch):Boolean {
			return false;
		}
		
		protected override function onSingleTouchOver(touch:Touch):Boolean {
			activateCell();
			return true;
		}
		
		protected override function onSingleTouchMove(touch:Touch):Boolean {			
			return false;
		}		
		
		private function isReadyForTransformation():Boolean
		{
			/*
			return (
				(
					getSelectedObjects().length == 0 && DeviceProperties.isTouchInterface()
				)
				||
				!DeviceProperties.isTouchInterface()
			)
			&&
				(
					_activeCell == null
					||
					(_activeCell && (getObjectsAtCell(_activeCell).length == 0))
				);
			*/
			return true;
		}
		
		public function getSelectionContainer():Sprite
		{
			return _selectionContainer;
		}
		
		public static function getInstance():MapView
		{
			return _instance;
		}
		
		public function getLayersContainer():Sprite
		{
			return _layersContainer;
		}		
	}
}