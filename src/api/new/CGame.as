package api 
{
	import api.input.CKeyPoll;
	import api.input.CMouse;
	import api.tileMap.CTileMap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class CGame
	{
		//DIFFICULTY
		public const EASY:uint = 0;
		public const MEDIUM:uint = 1;
		public const HARD:uint = 2;
		private var mGameTime:uint = 0;
		static private var mInstance:CGame;
		
		private var mStage:Stage;
		private var mState:CGameState;
		private static var DIFFICULTY:uint;
		
		private var mFPS:int;
		private var mCamera:CCamera;
		private var mContainer:DisplayObjectContainer;
		private var mMap:CTileMap;
		
		
		// FPS Counter.
		private var mFPStxt:TextField = new TextField();
		private var count:int;
		
		public function CGame(aDisplayObjectContainer:DisplayObjectContainer)
		{
			if (mInstance != null)
			{
				throw new Error("Error in api.CGame(). You are not allowed to instantiate it more than once.");
			}
			
			mInstance = this;
			mContainer = aDisplayObjectContainer;

			init();
		}
		
		public function init() : void
		{
			mStage = mContainer.stage;
			
			CKeyPoll.init(mStage);
			CMouse.init(mStage);
			
			//CMouse.setMousePointer(mContainer);
			
			mContainer.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			
			// FPS Counter.
			/*
			mStage.addChild(mFPStxt);*/
			mStage.addEventListener(Event.ENTER_FRAME, loop);
			var timer:Timer = new Timer(1000, 0);
			/*
			timer.addEventListener (TimerEvent.TIMER, showFPS);*/
			count = 0;
			timer.start();
		}
		
		static public function inst():CGame
		{
			return mInstance;
		}

		private function loop(e:Event):void
		{
			count++;
			/*time=getTimer();
			fps=1000 / (time - prevtime);
			showfps.text="FPS " + fps;
			prevtime=getTimer();*/
		}

		private function showFPS(te:TimerEvent):void
		{
			 mFPStxt.text = "" + count;
			 count = -1;
		}
		
		public function update():void 
		{
			mState.update();
			
			CKeyPoll.update();			
			CMouse.update();
		}
		
		
		
		private function enterFrameHandler(event:Event):void
		{
			//try
			//{
				update();
				render();
			//}
			//catch (e:Error)
			//{
				//throw RegExp(e.getStackTrace());
				//trace(e.getStackTrace());
			//} 
		}
		
		public function render():void 
		{
			mState.render();
		}
		
		public function destroy():void 
		{
			mContainer.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

			mState.destroy();
			mState = null;
			
			CKeyPoll.destroy();
			CMouse.destroy();

			mInstance = null;
		}
		
		
		public function setState(aState:CGameState):void
		{
			if (mState != null) 
			{
				mState.destroy();
				mState = null;
				//CHelper.removeAllChildrenDisplayObject(mContainer);
			}
			
			CKeyPoll.regainFocus();
			mState = aState;
			mState.init();
		}
		
		
		
		
		public function getState():CGameState
		{
			return mState;
		}
		
		public function getStage():Stage
		{
			return mStage;
		}
		
		public function getStageWidth():int
		{
			return mStage.stageWidth;
		}
		
		public function getStageHeight():int
		{
			return mStage.stageHeight;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return mContainer;
		}
		
		public function setDifficulty(pDifficulty:uint):void
		{
			DIFFICULTY = pDifficulty;
		}
		
		public  function getDifficulty():int
		{
			return DIFFICULTY;
		}
		
		
		public  function setCamera(aCamera:CCamera):void
		{
			mCamera = aCamera;
		}
		
		public  function getCamera():CCamera
		{
			return mCamera;
		}
		
		public function setMap(aMap:CTileMap):void
		{
			mMap = aMap;
		}
		
		public function getMap():CTileMap
		{
			return mMap;
		}
		
		public function setFPS(aFPS:int):void
		{
			mFPS = aFPS;
		}
		
		public function getFPS():int
		{
			return mFPS;
		}
		
		public function setGameTime(aGameTime:int):void
		{
			mGameTime = aGameTime;;
		}
		public function getGameTime():int
		{
			return mGameTime;
		}
	}
}
