package api
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CAnimation
	{
		//ANIMATION MANAGEMENT
		public static const FAST_ANIMATION:uint = 0;
		public static const NORMAL_ANIMATION:uint = 1;
		public static const SLOW_ANIMATION:uint = 2;
		public static const VERY_SLOW_ANIMATION:uint = 3;
		
		
		private var mFirstFrame:uint = 0;
		private var mLastFrame:uint = 0;
		private var mLoopAnimation:Boolean = false;
		public var mAnimationInitialized:Boolean = false;
		private var mAnimationSpeed:uint = 0;
		
		private var mFinished:Boolean = false;
		
		public function CAnimation()
		{
		
		}
		
		public  function manageAnimation(mc:MovieClip, mTimeState:Number):void
		{
			if (mFinished)
			{
				mc.gotoAndStop(mLastFrame);
				mAnimationInitialized = false;
				return;
			}
			if (mLoopAnimation)
			{
				if (mc.currentFrame == mLastFrame)
				{
					mc.gotoAndStop(mFirstFrame);
				}
				else
				{
					if (mAnimationSpeed == NORMAL_ANIMATION)
					{
						mc.gotoAndStop(mc.currentFrame + 1);
					}
					else if (mAnimationSpeed == SLOW_ANIMATION)
					{
						//wait four frames to update
						if ((mTimeState % 4) == 0)
						{
							mc.gotoAndStop(mc.currentFrame + 1);
						}
					}
					else if (mAnimationSpeed == VERY_SLOW_ANIMATION)
					{
						//wait four frames to update
						if ((mTimeState % 8) == 0)
						{
							mc.gotoAndStop(mc.currentFrame + 1);
						}
					}
				}
			}
			else
			{
				if (mc.currentFrame < mLastFrame)
				{
					if (mAnimationSpeed == NORMAL_ANIMATION)
					{
						mc.gotoAndStop(mc.currentFrame + 1);
					}
					else if (mAnimationSpeed == SLOW_ANIMATION)
					{
						//wait four frames to update
						if ((mTimeState % 4) == 0)
						{
							mc.gotoAndStop(mc.currentFrame + 1);
						}
					}
					else if (mAnimationSpeed == VERY_SLOW_ANIMATION)
					{
						//wait four frames to update
						if ((mTimeState % 8) == 0)
						{
							mc.gotoAndStop(mc.currentFrame + 1);
						}
					}
				}
				else if (mLastFrame == mc.currentFrame)
				{
					mc.gotoAndStop(mLastFrame);
					mFinished = true;
				}
			}
		}
		
		
		public function finished():Boolean
		{
			return mFinished;
		}
		
		public function initializeAnimation(aFrom:uint, aTo:uint, aLoopAnimation:Boolean, aAnimationSpeed:uint):void
		{
			mFirstFrame = aFrom;
			mLastFrame = aTo;
			mLoopAnimation = aLoopAnimation;
			mAnimationInitialized = true;
			mAnimationSpeed = aAnimationSpeed;
			mFinished = false;
		}
	
	}

}