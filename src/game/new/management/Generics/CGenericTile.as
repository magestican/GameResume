package game.management.Generics {
	import api.CGame;
	import api.CGameObject;
	import api.CLayer;
	import api.enums.CShapes;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CGenericTile extends CGenericGraphic
	{
		public static var TileSize:uint = 0;
		public static const GROW_X:uint = 0;
		public static const GROW_Y:uint = 1;
		public static var mBhevaiour:int = 0;
		public static var mLastX:uint = 0;
		public static var mLastY:uint = -TileSize;
		private static var firstTime:Boolean = true;
		
		private var mTileIndex:uint;
		private var mWalkable:Boolean;
		private var mPlatform:Boolean;
		
		public function CGenericTile(tileMc:Sprite = null, layer:CLayer = null)
		{
			if (tileMc == null || layer == null)
			{
				return;
			}
			setLayer(layer);
			
			setShape(CShapes.SQUARE);
			//super.mLayer = layer;
			
			//setSprite(new Sprite());
			setSprite(tileMc);
			
			if (mBhevaiour == GROW_X)
			{
				mLastX += TileSize;
			}
			else
			{
				mBhevaiour = GROW_X;
				mLastX = 0;
				mLastY += TileSize;
			}
			setX(mLastX);
			setY(mLastY);
			
			getSprite().y = getY();
			getSprite().x = getX();
			if (firstTime == true)
			{
				mLastX = 0;
				mLastY = -TileSize;
				setX(mLastX);
				setY(mLastY);
				getSprite().y = getY();
				getSprite().x = getX();
				firstTime = false;
			}
			
			setActive(false);
			//CGame.inst().getContainer().addChild(mc);
		
		}
		
		//TODO IMPLEMENT CODE FOR TILE BEHAVIOUR
		/*public function CTile(aX:uint, aY:uint, aTileIndex:uint, aDisplayObjectContainer:DisplayObjectContainer)
		   {
		   mX = aX;
		   mY = aY;
		   mTileIndex = aTileIndex;
		   mContainer = aDisplayObjectContainer;
		   mMC = new CAssets.TILE as MovieClip;
		   mContainer.addChild(mMC);
		   mMC.x = mX;
		   mMC.y = mY;
		   mMC.gotoAndStop(mTileIndex + 1);
		   mWalkable = true;
		   mPlatform = false;
		 }*/
		
		public function getTileIndex():uint
		{
			return mTileIndex;
		}
		
		public function setTileIndex(aTileIndex:uint):void
		{
			mTileIndex = aTileIndex;
			//mc.gotoAndStop(mTileIndex + 1);
		}
		
		public function setWalkable(aWalkable:Boolean):void
		{
			mWalkable = aWalkable;
		}
		
		public function isWalkable():Boolean
		{
			return mWalkable;
		}
		
		public function setPlatform(aPlatform:Boolean):void
		{
			mPlatform = aPlatform;
		}
		
		public function isPlatform():Boolean
		{
			return mPlatform;
		}
		
		public function isFloor():Boolean
		{
			return mPlatform || !mWalkable;
		}
		
		override public function update():void
		{
		/*if (super.mActive)
		   {
		   super.update();
		 }*/
		}
		
		override public function render():void
		{
			
		/*super.render();
		   if (super.mActive)
		   {
		   getSprite().y = getY();
		   getSprite().x = getX();
		 }*/
		}
	
	}

}