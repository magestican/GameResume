package api 
{
	public class CAnim 
	{
		private var mCurrentFrame:uint = 0;
		private var mFirstFrame:uint = 0;
		private var mLastFrame:uint = 0;
		private var mDelay:uint = 0;
		private var mMaxDelay:uint = 0;
		private var mEnded:Boolean;
		private var mLoop:Boolean;
		
		public function CAnim() 
		{
		}

		public function init(aFirstFrame:uint, aLastFrame:uint, aMaxDelay:uint, aLoop:Boolean = true):void
		{
			mFirstFrame = aFirstFrame;
			mLastFrame = aLastFrame;
			mMaxDelay = aMaxDelay;
			mDelay = 0;
			mCurrentFrame = aFirstFrame;
			mLoop = aLoop;
			mEnded = false;
		}
		
		public function update():void
		{
			mDelay++;
			if (mDelay >= mMaxDelay)
			{
				mDelay = 0;
				mCurrentFrame++;
				if (mCurrentFrame >= mLastFrame)
					mEnded = true;
				if (mCurrentFrame > mLastFrame)
				{
					if (mLoop)
						mCurrentFrame = mFirstFrame;
					else
						mCurrentFrame = mLastFrame;
				}
			}
		}
		
		public function isEnded():Boolean
		{
			return mEnded;
		}
		
		public function getCurrentFrame():uint
		{
			return mCurrentFrame;
		}
	}

}