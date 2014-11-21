package api
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author magestican
	 */
	public class CSoundAndMusic
	{
		
		private var mSound:Sound;
		private var mChannel:SoundChannel;
		private var mPosition:Number = 0;
		private var mLoopFrom:Number = 1;
		public var mIsPlaying:Boolean = false;
		public var mLoop:Boolean = false;
		public var mVolume:Number = 0;
		public function CSoundAndMusic(aSound:Sound = null, aLoop:Boolean = false, aLoopFrom:Number = 1)
		{
			mSound = aSound;
			mLoopFrom = aLoopFrom;
			mChannel = new SoundChannel();
			mLoop = aLoop;
		}
		
		public function playSound(aSound:Class, aLoop:Boolean, volume:Number = 1, timeLoop:Number = 1):void
		{
			mLoop = aLoop;
			mVolume = volume;
			var myExternalSound:Sound = new aSound as Sound;
			if (myExternalSound != null)
			{
				mSound = myExternalSound;
				if (mChannel != null)
				{
					mChannel.stop();
				}
				mChannel = myExternalSound.play(0, timeLoop, new SoundTransform(volume, 0));
				if (mChannel != null)
				{
					mChannel.addEventListener(Event.SOUND_COMPLETE, function():void
						{
							if (mChannel != null)
							{
								mIsPlaying = false
							}
							if (mLoop)
							{
								play(mLoopFrom)
							}
						});
					mIsPlaying = true;
				}
			}
			else
			{
				throw RegExp("SOUND PARAMETER COULD NOT BE CONVERTED TO SOUND!");
			}
		}
		
		public function play(aPosition:Number = 0):void
		{
			mChannel = mSound.play(aPosition, 1,new SoundTransform(mVolume, 0));
			if (mLoop)
			{
				mChannel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
					{
						play(mLoopFrom)
					});
			}
		}
		
		public function resume():void
		{
			play(mPosition);
		}
		
		public function pause():void
		{
			mPosition = mChannel.position;
			mChannel.stop();
		}
		
		public function stop():void
		{
			mPosition = 0;
			mChannel.stop();
		}
		
		public function destroy():void
		{
			mChannel.stop();
			mChannel = null;
			mSound = null;
		}
	
	}

}