package api 
{
	import api.CAnim;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CButton 
	{
		private var mButton:MovieClip;
		private var mAnim:CAnim;
		private var mDelay:uint;
		
		private var mHold:Boolean = false;
		private var mActive:Boolean = false;
		private var mHover:Boolean = false;
		
		// Mouse
		private var mouseOver:Boolean = false;
		private var mouseClick:Boolean = false;
		private var mouseOut:Boolean = false;
		
		// HOLD
		private var mHoldFirst:uint;
		private var mHoldLast:uint;
		private var mHoldLoop:Boolean;
		
		// HOVER
		private var mHoverFirst:uint;
		private var mHoverLast:uint;
		private var mHoverLoop:Boolean;
		
		// ACTIVE
		private var mActiveFirst:uint;
		private var mActiveLast:uint;
		private var mActiveLoop:Boolean;
		
		public function CButton(aButton:MovieClip) 
		{
			mAnim = new CAnim();
			mAnim.init(1, 1, 0);
			mButton = aButton;
			
			mButton.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			mButton.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
			mButton.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
		}
		
		public function setActive():void
		{
			mAnim.init(mActiveFirst, mActiveLast, mDelay, mActiveLoop);
			mActive = true;
			mHover = false;
			mHold = false;
		}
		
		public function setHover():void
		{
			mAnim.init(mHoverFirst, mHoverLast, mDelay, mHoverLoop);
			mActive = false;
			mHover = true;
			mHold = false;
		}
		
		public function setHold():void
		{
			mAnim.init(mHoldFirst, mHoldLast, mDelay, mHoldLoop);
			mActive = false;
			mHover = false;
			mHold = true;
		}
		
		public function setDelay(aDelay:uint):void
		{
			mDelay = aDelay;
		}
		
		public function setHoldAnim(aFirst:uint, aLast:uint, aLoop:Boolean = true):void
		{
			mHoldFirst = aFirst;
			mHoldLast = aLast;
			mHoldLoop = aLoop;
		}
		
		public function setHoverAnim(aFirst:uint, aLast:uint, aLoop:Boolean = true):void
		{
			mHoverFirst = aFirst;
			mHoverLast = aLast;
			mHoverLoop = aLoop;
		}
		
		public function setActiveAnim(aFirst:uint, aLast:uint, aLoop:Boolean = true):void
		{
			mActiveFirst = aFirst;
			mActiveLast = aLast;
			mActiveLoop = aLoop;
		}
		
		private function onClick(aEvent:MouseEvent):void
		{
			mouseClick = true;
		}
		
		private function onOver(aEvent:MouseEvent):void
		{
			mouseOver = true;
		}
		
		private function onOut(aEvent:MouseEvent):void
		{
			mouseOut = false;
			//if (!isActive())
				//setHold();
		}
		
		public function unClick():void
		{
			mouseClick = false;
		}
		
		public function unOver():void
		{
			mouseOver = false;
		}
		
		public function unOut():void
		{
			mouseOut = false;
		}

		
		// Getters
		public function isClick():Boolean
		{
			return mouseClick;
		}
		
		public function isOver():Boolean
		{
			return mouseOver;
		}
		
		public function isOut():Boolean
		{
			return mouseOut;
		}
		
		public function isActive():Boolean
		{
			return mActive;
		}
		
		public function isHover():Boolean
		{
			return mHover;
		}
		
		public function isHold():Boolean
		{
			return mHold;
		}
		
		public function animIsOver():Boolean
		{
			return mAnim.isEnded();
		}
		
		public function isPressed():Boolean
		{
			return isActive() && animIsOver();
		}
		
		public function update():void
		{
			mAnim.update();
		}
		
		public function render():void
		{
			mButton.gotoAndStop(mAnim.getCurrentFrame());
		}
		
		public function destroy():void
		{
			mButton.removeEventListener(MouseEvent.CLICK, onClick);
			mButton.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			mButton.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
	}

}