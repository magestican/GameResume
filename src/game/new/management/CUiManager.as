package game.management {
	import api.extensions.CVectorExt;
	import game.management.Generics.CGenericUiItem;
	import flash.display.GraphicsPathWinding;
	
	/**
	 * ...
	 * @author
	 */
	public class CUiManager
	{
		private static var mMagazine:Vector.<CGenericUiItem>;
		private static var mRainDrop:Vector.<CGenericUiItem>;
		private static var mBackgroundTiles:Vector.<CGenericUiItem>;
		private static var mHud:CGenericUiItem;
		
		private static var mScoreLabel:CGenericUiItem;
		private static var mUiManager:CUiManager;
		private static var mScore:uint = 0;
		public var mStop:Boolean = false;
		
		public function CUiManager()
		{
			registerSingletonInstance();
			mMagazine = new Vector.<CGenericUiItem>();
			mRainDrop = new Vector.<CGenericUiItem>();
			mBackgroundTiles = new Vector.<CGenericUiItem>();
			mHud = new CGenericUiItem();
		}
		
		
		public function registerSingletonInstance():void
		{
			if (mMagazine != null)
			{
				throw RegExp("You are not allowed to create another instnace of this object");
			}
		}
		
		public static function getInstance():CUiManager
		{
			if (mUiManager == null)
			{
				mUiManager = new CUiManager();
				return mUiManager;
			}
			else
			{
				return mUiManager;
			}
		}
		
		public function update():void
		{
			//update magazine
			for (var i:int = 0; mMagazine.length > i; i++)
			{
				mMagazine[i].update();
			}
			//update rain
			for (i = 0; mRainDrop.length > i; i++)
			{
				mRainDrop[i].update();
			}
			//update tiles
			for (i = 0; mBackgroundTiles.length > i; i++)
			{
				mBackgroundTiles[i].update();
			}
		
		}
		
		public function render():void
		{
			if (!mStop)
			{
				for (var i:int = 0; mRainDrop.length > i; i++)
				{
					mRainDrop[i].render();
				}
			}
			for (i = 0; mMagazine.length > i; i++)
			{
				mMagazine[i].render();
			}
			for (i = 0; mBackgroundTiles.length > i; i++)
			{
				mBackgroundTiles[i].render();
			}
		
		}
		
		//**************************************REMOVES**********************************//
		
		public function removeBulletFromMagazine():void
		{
			if (mMagazine.length > 0)
			{
				mMagazine[mMagazine.length - 1].destroy();
				mMagazine.splice(mMagazine.length - 1, 1);
			}
			else
			{
				throw RegExp("There are no more bullets in the magazine");
			}
		}
		
		//**************************************ADDS**********************************//
		
		public function addBulletToMagazine(aBullet:CGenericUiItem):void
		{
			mMagazine.push(aBullet);
		}
		
		public function addBackgroundTile(aTile:CGenericUiItem):void
		{
			mBackgroundTiles.push(aTile);
		}
		
		public function addRainDrop(aRainDrop:CGenericUiItem):void
		{
			mRainDrop.push(aRainDrop);
		}
		public function setHud(aHud:CGenericUiItem):void
		{
			mHud = aHud;
		}
		
		public function getHud():CGenericUiItem
		{
			return mHud;
		}
		
		public function magazineHasBullets():Boolean
		{
			if (mMagazine.length > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function setScoreLabel(aScoreLevel:CGenericUiItem):void
		{
			mScoreLabel = aScoreLevel;
		}
		
		public function getMagazineBullets():int
		{
			return mMagazine.length;
		}
		
		public function enemyWasKilled():Boolean
		{
			mScoreLabel.enemyWasKilled();
			return true;
		}
		
		public function destroy():void
		{
			//we gotta do something here
		}
	
	}

}