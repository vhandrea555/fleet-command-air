package com.ad.games.fc2.sound
{
	import com.ad.games.fc2.resources.Resources;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public final class SoundController
	{
		private static const CANNON_FIRE_SOUND_LIMIT:uint = 2;
		private static const CANNON_FIRE_SOUND_DELAY:uint = 250;
		
		private static var engineSound:Sound;
		private static var engineSoundChannel:SoundChannel;
		private static var engineSoundsCount:uint = 0;
		
		private static var cannonFirePrimarySound:Sound;
		private static var cannonFireSoundsCount:uint = 0;
		private static var lastCannonFireTime:Number = 0;
		public static var isSoundEnabled:Boolean = false;
		
		public static function startEngine():void {
			if (isSoundEnabled) {
				if (engineSound == null) {
					engineSound = Sound(new Resources.EngineSound());				
				}
				
				if (engineSoundsCount == 0) {				
					engineSoundChannel = engineSound.play(0, 1000);
					//engineSoundChannel.addEventListener(Event.SOUND_COMPLETE, loopEngine);
				}
				engineSoundsCount++;
			}
		}
		
		public static function stopEngine():void {			
			engineSoundsCount = (engineSoundsCount == 0) ? 0 : (engineSoundsCount-1);
			if (engineSoundsCount == 0 && engineSoundChannel != null) {
				engineSoundChannel.stop();
			}
		}
		
		public static function cannonFirePrimary():void {
			if (isSoundEnabled && ((new Date()).time - lastCannonFireTime) > CANNON_FIRE_SOUND_DELAY && cannonFireSoundsCount < CANNON_FIRE_SOUND_LIMIT) {
				lastCannonFireTime = (new Date()).time;
				var fire:SoundChannel = Sound(new Resources.CannonFirePrimary1Sound()).play();
				cannonFireSoundsCount++;
				fire.addEventListener(Event.SOUND_COMPLETE, firePrimaryComplete);
			}
		}
		
		private static function firePrimaryComplete(e:Event):void {
			cannonFireSoundsCount--;
		} 
	}
}