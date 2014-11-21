package api 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CMusic 
	{
		private var mSound:Sound;
		private var mChannel:SoundChannel;
		private var mPosition:Number = 0;
		private var mLoopFrom:Number;
		
		public function CMusic(aSound:Sound, aLoopFrom:Number=0) 
		{
			mSound = aSound;
			mLoopFrom = aLoopFrom;
			mChannel = new SoundChannel();
		}
		
		public function play(aPosition:Number=0):void
		{
			mChannel = mSound.play(aPosition, 1);
			mChannel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void {play(mLoopFrom)});
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