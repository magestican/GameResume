package api 
{
	import game.management.Generics.CGenericPlayer;
	import game.management.Generics.CGenericUiItem;
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	
	public class CGameState extends CGameObject
	{
		public var mMenuMC:Sprite;
        public var mLayers:CLayer;
		
		private var mPlayer:CGenericPlayer;
		//public var mMaxScore:Number;
		//public var mMap:CMap;
		//public var mHud:CGenericUiItem;
		
		public function CGameState()
		{	
			 mLayers = new CLayer();
			 mMenuMC = new Sprite();
		}
		
		public function init():void
		{
		}
		
		public override function update():void
		{
		}
		
		public override function render():void
		{
		}

		public override function destroy():void
		{
		}
		
		public function placeRespawn():void
		{
			if (mPlayer == null)
			{
			    throw RegExp("You must create a player first!");
			}
		}
		
		
		public function manageWin():void
		{
			
		}
		
		public function getPlayer():CGenericPlayer
		{
			return mPlayer;
		}
		public function setPlayer(aPlayer:CGenericPlayer):void
		{
			mPlayer = aPlayer;
		}
		
	}
}