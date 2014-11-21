package game.management {
	import adobe.utils.CustomActions;
	import api.CGameState;

	public class CGameStatesManager 
	{
		private var  mCurrentState:CGameState;
		private var mPreviousState:CGameState;
		
		public function CGameStatesManager() 
		{
			mCurrentState = new CGameState();
			mPreviousState = new CGameState();
		}
		
		public function changeState(newGameState:CGameState):void	
		{
			mPreviousState = mCurrentState;
			mCurrentState = newGameState;
			newGameState.init();
		}
		
		public function changeToPreviousState():void
		{
			mCurrentState = mPreviousState;
		}
		
		public function updateCurrentState():void
		{
			mCurrentState.update();
		}
		
		public function renderCurrentState():void
		{
			mCurrentState.render();
		}
	}

}