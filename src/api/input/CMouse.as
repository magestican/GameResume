package api.input {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	public class CMouse
	{
		static private var mInitialized:Boolean = false;
		static private var mStage:Stage;
		static private var mPressed:Boolean;
		static private var mPressedLeastThanOneFrame:Boolean;
		static private var mPrevPressed:Boolean;
		
		static public var mMousePointerMC:Sprite;
		
		public function CMouse()
		{
			throw new Error("Error in api.CMouse(). You're not supposed to instantiate this class."); 
		}
		
		static public function init(aStage:Stage):void
		{
			if (mInitialized)
			{
				return;
			}
			mInitialized = true;
			mStage = aStage;
			mPressed = false;
			mPressedLeastThanOneFrame = false;
			mPrevPressed = false;
						
			mStage.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);			
			mStage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			mStage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		static private function mouseDownHandler(event:MouseEvent):void
		{
			mPressed = true;
			mPressedLeastThanOneFrame = true;
		}
		
		static private function mouseUpHandler(event:MouseEvent):void
		{
			mPressed = false;
		}
		
		static private function deactivateHandler(event:Event):void
		{
			mPressed = mPressedLeastThanOneFrame = mPrevPressed = false;
		}
		
		static public function destroy():void
		{
			if (mInitialized)
			{
				mStage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				mStage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				mStage.removeEventListener(Event.DEACTIVATE, deactivateHandler);		
				
				mStage = null;
				mInitialized = false;
				/*if (mMousePointerMC != null)
				{
					CHelper.removeDisplayObject(mMousePointerMC);
				}*/
			}
		}
		
		static public function update():void
		{			
			mPrevPressed = pressed();
			mPressedLeastThanOneFrame = false;
			
			if (mMousePointerMC != null)
			{
				mMousePointerMC.x = getMouseX();
				mMousePointerMC.y = getMouseY();
			}
		}
			
		/*static public function setMousePointer(aContainer:DisplayObjectContainer):void
		{
			try 
			{ 
				mMousePointerMC = CAssets.MOUSE_POINTER as Sprite;
			} 
			catch (err:Error) 
			{ 
				trace("Error: " + err);
			} 
			
			if (mMousePointerMC == null)
			{
				trace("error loading mouse pointer");
			}
			else
			{
				aContainer.addChild(mMousePointerMC);
			}
		}*/
		
		static public function getMouseX():Number
		{
			return mStage.mouseX;
		}
		
		static public function getMouseY():Number
		{
			return mStage.mouseY;
		}
		
		/*static public function getMousePos():CVector
		{
			return new CVector(mStage.mouseX, mStage.mouseY);
		}*/
		
		static public function pressed():Boolean
		{
			return mPressed || mPressedLeastThanOneFrame;
		}
		
		static public function firstPress():Boolean
		{
			return pressed() && !mPrevPressed;
		}
		
		static public function release():Boolean
		{
			return !pressed() && mPrevPressed;
		}
		
		static public function hide():void
		{
			flash.ui.Mouse.hide();
		}
		
		static public function show():void
		{
			flash.ui.Mouse.show();
		}
	}
}