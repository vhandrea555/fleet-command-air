package com.ad.games.fc2.view.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public final class Rasterizer
	{
		public static const HALIGN_LEFT:uint = 0;
		public static const HALIGN_CENTER:uint = 1;
		public static const HALIGN_RIGHT:uint = 2;
		public static const VALIGN_TOP:uint = 0;
		public static const VALIGN_MIDDLE:uint = 3;
		public static const VALIGN_BOTTOM:uint = 6;
		
		public static function fromSpriteToImage(sprite:Sprite, transparent:Boolean = true, fillColor:uint=4.294967295E9):Image {
			
			if (transparent) {
				fillColor = 0x00000000;
			}
			
			var bitmap:BitmapData = new BitmapData(sprite.width, sprite.height, transparent, fillColor);
			bitmap.draw(sprite);
			var texture:Texture = Texture.fromBitmapData(bitmap);
			return new Image(texture);
		}
		
		public static function rasterize(source:flash.display.DisplayObject, align:uint = 0, scale:Number = 1):flash.display.Sprite
		{
			var sprite:flash.display.Sprite = null;
			var bitmap:Bitmap = toBitmap(source, align, scale);
			if (bitmap) {
				sprite = new flash.display.Sprite();
				sprite.addChild(bitmap);
			}
			return sprite;
		}
		
		public static function toBitmap(source:flash.display.DisplayObject, align:uint = 0, scale:Number = 1):Bitmap
		{
			var x:Number = 0;
			var y:Number = 0;
			var bitmap:Bitmap = null;
			
			switch(align%3) {
				case HALIGN_LEFT:
					break;
				case HALIGN_CENTER:
					x = source.width/2;
					break;
				case HALIGN_RIGHT:
					x = source.width;
					break;				
			}
			
			switch(Math.floor(align/3)*3) {
				case VALIGN_TOP:
					break;
				case VALIGN_MIDDLE:
					y = source.height/2;
					break;
				case VALIGN_BOTTOM:
					x = source.height;
					break;				
			}
			
			source.scaleX = source.scaleX * scale;
			source.scaleY = source.scaleY * scale;
			
			var data:BitmapData = toBitmapData(source, align);
			
			if (data) {
				bitmap = new Bitmap(data);
				bitmap.smoothing = true;
				bitmap.x = -x;
				bitmap.y = -y;
				
				bitmap.scaleX = 1/scale;
				bitmap.scaleY = 1/scale;
			}
			
			source.scaleX = source.scaleX / scale;
			source.scaleY = source.scaleY /scale;
			
			return bitmap;
		}
		
		public static function toBitmapData(source:flash.display.DisplayObject, align:uint = 0):BitmapData
		{
			var x:Number = 0;
			var y:Number = 0;
			var sX:Number = source.x;
			var sY:Number = source.y;
			var data:BitmapData = null;
			
			switch(align%3) {
				case HALIGN_LEFT:
					break;
				case HALIGN_CENTER:
					x = source.width/2;
					break;
				case HALIGN_RIGHT:
					x = source.width;
					break;				
			}
			
			switch(Math.floor(align/3)*3) {
				case VALIGN_TOP:
					break;
				case VALIGN_MIDDLE:
					y = source.height/2;
					break;
				case VALIGN_BOTTOM:
					x = source.height;
					break;				
			}			
			
			source.x = x;
			source.y = y;
			
			try {
				data = new BitmapData(source.width, source.height, true, 0x00000000);				
				data.draw(source, source.transform.matrix, source.transform.colorTransform);
			} catch (e:Error) {
				data = null;
			}
			
			source.x = sX;
			source.y = sY;
			
			return data;
		}		
		
		public static function clone(source:flash.display.DisplayObject):flash.display.DisplayObject		
		{
			var result:flash.display.DisplayObject;
			
			if (source is flash.display.Sprite) {
				result = new flash.display.Sprite();
				var sourceBitmap1:Bitmap = Bitmap(flash.display.Sprite(source).getChildAt(0));
				var bitmap:Bitmap = new Bitmap(sourceBitmap1.bitmapData);
				bitmap.smoothing = sourceBitmap1.smoothing;
				bitmap.transform.matrix = sourceBitmap1.transform.matrix;
				flash.display.Sprite(result).addChild(bitmap);
				sourceBitmap1 = null;
			} else if (source is Bitmap) {
				var sourceBitmap2:Bitmap = Bitmap(source);
				result = new Bitmap(sourceBitmap2.bitmapData);
				Bitmap(result).smoothing = sourceBitmap2.smoothing;
				result.transform.matrix = sourceBitmap2.transform.matrix;
				sourceBitmap2 = null;
			}
			
			return result;
		}
	}
}