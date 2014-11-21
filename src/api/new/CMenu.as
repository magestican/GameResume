package api 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CMenu 
	{
		private var mButtons:Vector.<CButton>;
		private var mCurSelection:int;
		
		private var mUpKeys:Vector.<int>;
		private var mDownKeys:Vector.<int>;
				
		public function CMenu() 
		{
			mButtons = new Vector.<CButton>;
			mUpKeys = new Vector.<int>;
			mUpKeys.push(CKeyPoll.UP);
			mDownKeys = new Vector.<int>;
			mDownKeys.push(CKeyPoll.DOWN);
		}
		
		public function addButton(aButton:CButton):void
		{
			mButtons.push(aButton);
		}
		
		public function init():void
		{
			mButtons[0].setHover();
		}
		
		public function addUpKey(aKey:int):void
		{
			mUpKeys.push(aKey);
		}
		
		public function addDownKey(aKey:int):void
		{
			mDownKeys.push(aKey);
		}
		
		private function changeCurSelection(aNum:int):void
		{
			if (mCurSelection + aNum > mButtons.length - 1)
				mCurSelection = 0;
			else if (mCurSelection + aNum < 0)
				mCurSelection = mButtons.length - 1;
			else
				mCurSelection += aNum;
			for (var i:int = 0; i < mButtons.length; i++)
			{
				mButtons[i].setHold();
			}
			mButtons[mCurSelection].setHover();
		}
		
		public function setSelection(aNum:int):void
		{
			mCurSelection = aNum;
			for (var i:int = 0; i < mButtons.length; i++)
			{
				mButtons[i].setHold();
			}
			mButtons[mCurSelection].setHover();
		}
		
		public function update():void
		{
			var i:uint;
			for (i = 0; i < mUpKeys.length; i++)
			{
				if (CKeyPoll.firstPress(mUpKeys[i]))
					changeCurSelection(-1);
			}
			
			for (i = 0; i < mDownKeys.length; i++)
			{
				if (CKeyPoll.firstPress(mDownKeys[i]))
					changeCurSelection(1);
			}
			
			for (i = 0; i < mButtons.length; i++)
			{
				if (mButtons[i].isOver())
				{
					mButtons[i].unOver();
					setSelection(i);
				}
				if (mButtons[i].isClick())
				{
					mButtons[i].unClick();
					mButtons[i].setActive();
				}
			}
			
			if (CKeyPoll.firstPress(CKeyPoll.ENTER) || CKeyPoll.firstPress(CKeyPoll.SPACE))
				mButtons[mCurSelection].setActive();
			
			for (i = 0; i < mButtons.length; i++)
			{
				mButtons[i].update();
			}
		}
		
		public function render():void
		{
			for (var i:int = 0; i < mButtons.length; i++)
			{
				mButtons[i].render();
			}
		}
		
		public function destroy():void
		{
			for (var i:int = 0; i < mButtons.length; i++)
			{
				mButtons[i].destroy();
			}
		}
	}

}