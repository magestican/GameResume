package api.input {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	public class CKeyPoll
	{
		// TODO: Missing key codes (shift, tab, etc.)...
		static public const ESCAPE:uint = Keyboard.ESCAPE;		
		static public const ENTER:uint = Keyboard.ENTER;
		static public const SPACE:uint = Keyboard.SPACE;
		static public const CONTROL:uint = Keyboard.CONTROL;
		static public const UP:uint = Keyboard.UP;
		static public const DOWN:uint = Keyboard.DOWN;
		static public const LEFT:uint = Keyboard.LEFT;
		static public const RIGHT:uint = Keyboard.RIGHT;
		// Extras
		static public const SHIFT:uint = 256;
		static public const ALT:uint = 257;
				
		static public const KEY_0:uint = 48;
		static public const KEY_1:uint = 49;
		static public const KEY_2:uint = 50;
		static public const KEY_3:uint = 51;
		static public const KEY_4:uint = 52;
		static public const KEY_5:uint = 53;
		static public const KEY_6:uint = 54;
		static public const KEY_7:uint = 55;
		static public const KEY_8:uint = 56;
		static public const KEY_9:uint = 57;
		
		static public const KEY_A:uint = 65;
		static public const KEY_B:uint = 66;
		static public const KEY_C:uint = 67;
		static public const KEY_D:uint = 68;
		static public const KEY_E:uint = 69;
		static public const KEY_F:uint = 70;
		static public const KEY_G:uint = 71;
		static public const KEY_H:uint = 72;
		static public const KEY_I:uint = 73;
		static public const KEY_J:uint = 74;
		static public const KEY_K:uint = 75;
		static public const KEY_L:uint = 76;
		static public const KEY_M:uint = 77;
		static public const KEY_N:uint = 78;
		static public const KEY_O:uint = 79;
		static public const KEY_P:uint = 80;
		static public const KEY_Q:uint = 81;
		static public const KEY_R:uint = 82;
		static public const KEY_S:uint = 83;
		static public const KEY_T:uint = 84;
		static public const KEY_U:uint = 85;
		static public const KEY_V:uint = 86;
		static public const KEY_W:uint = 87;
		static public const KEY_X:uint = 88;
		static public const KEY_Y:uint = 89;
		static public const KEY_Z:uint = 90;
		
		static private var mInitialized:Boolean = false;
		
		static private const KEY_COUNT:int = 258;
		
		static private var mStage:Stage;
		
		static private var mList:Array;
		static private var mPrevList:Array;
		
		public function CKeyPoll()
		{
			throw new Error("Error in api.CKeyPoll(). You're not supposed to instantiate this class."); 
		}		

		static public function init(aStage:Stage):void
		{
			if (mInitialized)
			{
				return;
			}
			
			mInitialized = true;
			mStage = aStage;			
			
			mList = new Array();
			mPrevList = new Array();
			
			for (var i:int = 0; i < KEY_COUNT; i++)
			{
				mList.push(false);
				mPrevList.push(false);
			}
			
			mStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
			mStage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
			mStage.addEventListener(Event.DEACTIVATE, clearKeys, false, 0, true);
		}
		
		static private function keyDownHandler(event:KeyboardEvent):void
		{
			var keyCode:uint = event.keyCode;
			if (keyCode < KEY_COUNT)
			{
				mList[keyCode] = true;
			}
			mList[SHIFT] = event.shiftKey;
			mList[ALT] = event.altKey;
		}
		
		static private function keyUpHandler(event:KeyboardEvent):void
		{
			var keyCode:uint = event.keyCode;
			if (keyCode < KEY_COUNT)
			{
				mList[keyCode] = false;
			}
			mList[SHIFT] = event.shiftKey;
			mList[ALT] = event.altKey;
		}
		
		static private function clearKeys(event:Event):void
		{
			for (var keyCode:uint = 0; keyCode < KEY_COUNT; keyCode++)
			{
				mList[keyCode] = mPrevList[keyCode] = false;
			}
		}
		
		static public function anyKeyPressed():Boolean
		{
			for (var keyCode:uint = 0; keyCode < KEY_COUNT; keyCode++)
			{
				if (mList[keyCode] == true)
					return true;
			}
			return false;
		}
		
		static public function update():void
		{
			for (var keyCode:uint = 0; keyCode < KEY_COUNT; keyCode++)
			{
				mPrevList[keyCode] = mList[keyCode];
			}
		}
		
		static public function pressed(aKeyCode:uint):Boolean
		{
			if (aKeyCode < KEY_COUNT)
			{
				return mList[aKeyCode];
			}
			return false;
		}
		
		static public function firstPress(aKeyCode:uint):Boolean
		{
			return !mPrevList[aKeyCode] && mList[aKeyCode];
		}
		
		static public function release(aKeyCode:uint):Boolean
		{
			return mPrevList[aKeyCode] && !mList[aKeyCode];
		}
		
		static public function regainFocus():void
		{
			mStage.focus = null;
		}

		static public function destroy():void
		{
			if (mInitialized)
			{
				mStage.removeEventListener(Event.DEACTIVATE, clearKeys);
				mStage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				mStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				mPrevList.splice(0);
				mPrevList = null;
				mList.splice(0);
				mList = null;
				mInitialized = false;
			}
		}
	}
}