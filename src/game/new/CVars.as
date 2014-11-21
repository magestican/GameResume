package game 
{
	import api.CMinimap;
	import game.hud.CHud;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CVars 
	{
		private static var mInst:CVars;
		
		private var mPlayer:CPlayer;
		private var mMinionsInfluenceMap:CConvertInfluenceMap;
		private var mEnemiesInfluenceMap:CConvertInfluenceMap;
		private var mHud:CHud;
		private var mMinimap:CMinimap;
		
		public function CVars() 
		{
			registerSingleton();
		}
		
		private function registerSingleton():void
		{
			if (mInst == null)
				mInst = this;
			else
				RegExp("You can't create a new instance of CVars");
		}
		
		public static function inst():CVars
		{
			return mInst;
		}
		
		// Getters & Setters
		public function setPlayer(aPlayer:CPlayer):void
		{
			mPlayer = aPlayer;
		}
		public function getPlayer():CPlayer
		{
			return mPlayer;
		}
		
		public function setMinionsInfluenceMap(aInfluenceMap:CConvertInfluenceMap):void
		{
			mMinionsInfluenceMap = aInfluenceMap;
		}
		public function getMinionsInfluenceMap():CConvertInfluenceMap
		{
			return mMinionsInfluenceMap;
		}
		
		public function setEnemiesInfluenceMap(aInfluenceMap:CConvertInfluenceMap):void
		{
			mEnemiesInfluenceMap = aInfluenceMap;
		}
		public function getEnemiesInfluenceMap():CConvertInfluenceMap
		{
			return mEnemiesInfluenceMap;
		}
		
		public function getFollowersAmount():int
		{
			return mPlayer.getFollowersLength();
		}
		
		public function setMinimap(aMinimap:CMinimap):void
		{
			mMinimap = aMinimap;
		}
		public function getMinimap():CMinimap
		{
			return mMinimap;
		}
		
		public function setHud(aHud:CHud):void
		{
			mHud = aHud;
		}
		public function getHud():CHud
		{
			return mHud;
		}
	}

}