package com.ad.games.fc2.view.starling.map
{
	import com.ad.games.fc2.Application;
	import com.ad.games.fc2.view.starling.base.BaseTouchView;
	import com.ad.games.fc2.view.starling.map.object.MapLayerObject;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class MapView extends BaseTouchView
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
		
		/*
		private static var _mouseX:Number = 0;
		private static var _mouseY:Number = 0;
		
		public static const MODE_DEFAULT:uint = 0;
		public static const MODE_DRAG:uint = 1;
		public static const MODE_SCALE:uint = 2;
		public static const MODE_TRANSFORMATION_PREPARE:uint = 3;
		public static const MODE_TRANSFORMATION_READY:uint = 4;
		
		private static var _mode:uint = MODE_DEFAULT;
		
		private static const SCALE_MIN:Number = 0.25;
		private static const SCALE_MAX:Number = 4;
		*/
		
		private static var _instance:MapView;
		
		public function MapView(cols:uint, rows:uint)
		{
			super();
			_rows = rows;
			_cols = cols;
			_layers = new <MapLayer>[];
			_cells = new <MapCell>[];
			
			_layersContainer =  new Sprite();
			_cursor = new MapCursor(this);
			_selectionContainer = new Sprite();
			
			for (var r:uint=0; r<_rows; r++) {
				for (var c:uint=0; c<_cols; c++) {
					var cell:MapCell = new MapCell(c, r, this);
					cell.x = c*MapCell.SIZE;
					cell.y = r*MapCell.SIZE;
					_cells.push(cell);
				}
			}
			
			_instance = this;
		}
		
		protected override function draw():void
		{
			super.draw();
			
			var _width:Number = _cols*MapCell.SIZE;
			var _height:Number = _rows*MapCell.SIZE;
			
			var bgCell:flash.display.Sprite = new flash.display.Sprite();
			bgCell.graphics.lineStyle(1, 0x3399FF);
			bgCell.graphics.beginFill(0x0066FF, 1);
			bgCell.graphics.moveTo(0, 0);
			bgCell.graphics.lineTo(MapCell.SIZE, 0);
			bgCell.graphics.lineTo(MapCell.SIZE, MapCell.SIZE);
			bgCell.graphics.lineTo(0, MapCell.SIZE);
			bgCell.graphics.lineTo(0, 0);
			
			var bitmap:BitmapData = new BitmapData(MapCell.SIZE, MapCell.SIZE);
			bitmap.draw(bgCell);
			var texture:Texture = Texture.fromBitmapData(bitmap);
			var quadBatch:QuadBatch = new QuadBatch();
			var image:Image = new Image(texture);
			
			//image.blendMode = BlendMode.NONE;
			
			for (var i:int=0; i<_cols; i++) {
				
				for (var j:int=0; j<_rows; j++) {
					image.x = i*MapCell.SIZE;
					image.y = j*MapCell.SIZE;
					quadBatch.addImage(image);	
				}
			}			
			
			quadBatch.blendMode = BlendMode.NONE;
			/*quadBatch.touchable = false;*/
			
			addChild(quadBatch);
			
			//addChild(_selectionContainer);
			//addChild(_layersContainer);
			//addChild(_cursor);
			
			//_cursor.setState(MapCursor.STATE_SELECT);
			//_cursor.update();

			//setInterval(checkMouseMove, GlobalConfig.UPDATE_TIMEOUT_NORMAL);
			
			/*
			if (DeviceProperties.isTouchInterface()) {
				Application.getInstance().stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, _onZoom);
			} else {
				Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
			}
			
			Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			Application.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			*/
			
			//trace(Multitouch.supportedGestures);
			//addEventListener(TouchEvent.TOUCH, onTouch);
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
		
		private function updateActiveCell():void
		{
			var cell:MapCell = _getActiveCell();
			
			if (cell != null) {
				activateCell(cell);
			}			
		}
		
		private function activateCell(cell:MapCell):void
		{
			if (cell != _activeCell) {
				_activeCell = cell;
				_cursor.placeTo(cell);
				dispatchEvent(new starling.events.Event(EVENT_ACTIVE_CELL));
			}
		}
		
		public function getActiveCell():MapCell
		{
			return _activeCell;
		}
		
		private function _getActiveCell():MapCell
		{
			return getCellAt(Application.getInstance().mouseX, Application.getInstance().mouseY);
		}
		
		public function getCellAt(_x:Number, _y:Number):MapCell {
			var col:Number = Math.round((_x - MapCell.SIZE/2)/MapCell.SIZE); 
			var row:Number = Math.round((_y - MapCell.SIZE/2)/MapCell.SIZE);
			
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
		
		private function _onMouseWheel(e:MouseEvent):void
		{
			/*
			if (isReadyForTransformation()) {
				_stopDrag();
				
				onBeforeTransformation();
				prepareForTransformation();
				
				scale(scaleX * (1 + e.delta / GlobalConfig.MOUSE_WHEEL_SPEED), Application.getInstance().mouseX, Application.getInstance().mouseY);
				
				onAfterTransformation();				
			}
			*/
		}
		
		private function _onZoom(e:TransformGestureEvent):void
		{
			/*
			if (isReadyForTransformation()) {
				switch(e.phase) {
					case GesturePhase.BEGIN:
						_stopDrag();
						onBeforeTransformation();
						prepareForTransformation();
						_mode = MODE_SCALE;
						break;
					case GesturePhase.END:
						onAfterTransformation();
						break;
					case GesturePhase.UPDATE:
						dispatchEvent(new starling.events.Event(EVENT_MAP_UPDATE));
						break;
				}
				
				if (_mode == MODE_SCALE) {
					var _scale:Number = (e.scaleX + e.scaleY)/2;
					scale(scaleX * _scale, Application.getInstance().mouseX, Application.getInstance().mouseY);
				}
			}
			*/
		}
		
		private function _onMouseDown(e:flash.events.Event):void
		{
			/*
			trace("!!!");
			if (isReadyForTransformation()) {
				onBeforeTransformation();
			}
			
			e.stopPropagation();
			e.stopImmediatePropagation();
			//e.preventDefault();
			*/
		}
		
		private function _onMouseUp(e:flash.events.Event):void
		{
			/*
			onAfterTransformation();
			e.stopPropagation();
			e.stopImmediatePropagation();
			//e.preventDefault();
			*/
		}
		
		private function onBeforeTransformation():void
		{
			/*
			if (_mode == MODE_DEFAULT) {
				updateActiveCell();
				_mode = MODE_TRANSFORMATION_PREPARE;
			}
			*/
		}
		
		private function prepareForTransformation():void
		{
			/*
			if (_mode == MODE_TRANSFORMATION_PREPARE) {
				//Console.appendLine("prepareForTransformation");
				var objects:Vector.<MapLayerObject> = MapLayerObject.getMapLayerObjects();
				for (var i:uint = 0; i<objects.length; i++) {
					objects[i].setMode(MapLayerObject.MODE_TRANSFORMATION);
				}
			}
			*/
		}		
		
		private function onAfterTransformation():void
		{
			/*
			if (_mode == MODE_DEFAULT || _mode == MODE_TRANSFORMATION_PREPARE) {
				_mode = MODE_DEFAULT;
				if (_activeCell != null) {
					updateActiveCell();
					dispatchEvent(new starling.events.Event(EVENT_MOUSE_UP));
				}
			} else if (_mode != MODE_DEFAULT) {
				_stopDrag();
				
				var objects:Vector.<MapLayerObject> = MapLayerObject.getMapLayerObjects();
				for (var i:uint = 0; i<objects.length; i++) {
					objects[i].setMode(MapLayerObject.MODE_NORMAL);
				}
				_mode = MODE_DEFAULT;
				dispatchEvent(new starling.events.Event(EVENT_MAP_UPDATE));
			}
			*/
		}
		
		private function checkMouseMove(e:TimerEvent = null):void
		{
			/*
			if (Application.getInstance().mouseX != _mouseX || Application.getInstance().mouseY != _mouseY) {
				_mouseX = Application.getInstance().mouseX;
				_mouseY = Application.getInstance().mouseY;
				
				_onMouseMove();
			}
			*/
		}
		
		private function _onMouseMove():void
		{
			/*
			if (_mode == MODE_TRANSFORMATION_PREPARE) {
				_startDrag();
			} else if (_mode == MODE_DEFAULT) {
				updateActiveCell();
			}
			*/
		}		
		
		private function scale(_scale:Number, centerX:Number, centerY:Number):void
		{
			/*
			_scale = (_scale < SCALE_MIN) ? SCALE_MIN : _scale;
			_scale = (_scale > SCALE_MAX) ? SCALE_MAX : _scale;
			
			_mode = MODE_SCALE;		
			
			var minScaleX:Number = DeviceProperties.getSreenWidth() / (width / scaleX);
			var minScaleY:Number = DeviceProperties.getSreenHeight() / (height / scaleX);
			
			_scale = (_scale < minScaleX) ? minScaleX : _scale;
			_scale = (_scale < minScaleY) ? minScaleY : _scale;
			
			var dScale:Number = _scale - scaleX;
			var newX:Number = x - (centerX)*dScale;
			var newY:Number = y - (centerY)*dScale;
			
			var minX:Number = DeviceProperties.getSreenWidth() - width;
			var maxX:Number = 0;
			var minY:Number = DeviceProperties.getSreenHeight() - height;
			var maxY:Number = 0;
			
			newX = (newX < minX) ? minX : newX;
			newX = (newX > maxX) ? maxX : newX;
			newY = (newY < minY) ? minY : newY;
			newY = (newY > maxY) ? maxY : newY;
			
			x = newX;
			y = newY;
			
			scaleX = _scale;
			scaleY = _scale;
			*/
		}		
		
		private function _startDrag():void
		{
			/*
			prepareForTransformation();
			_mode = MODE_DRAG;
			startDrag();
			*/
		}
		
		private function _stopDrag():void
		{
			/*
			if (_mode == MODE_DRAG) {				
				stopDrag();				
			}
			*/
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
		
		/*
		public function getMode():uint
		{
			return _mode;
		}
		*/
		
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