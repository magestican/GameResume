package game.management {
	import adobe.utils.CustomActions;
	import api.CGame;
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.enums.CMessage;
	import api.enums.CVel;
	import api.extensions.CVectorExt;
	import api.tileMap.CTile;
	import game.convertibles.buildings.CBuilding;
	import game.convertibles.CGenericConvertible;
	import game.convertibles.units.CMinion;
	import game.management.Generics.CGenericPlayer;
	import api.math.CMath;
	
	
	public class CGraphicsManager
	{
		private var mMinions:CConvertibleManager = new CConvertibleManager();
		private var mBuildings:CConvertibleManager = new CConvertibleManager();
		private var mPeasant:CVectorExt = new CVectorExt();
		
		
		
		private var mTiles:CVectorExt = new CVectorExt();
		private var mStop:Boolean = false;
		private static var mInstance:CGraphicsManager;
		private var mActiveBlackHoles:Boolean = false;
		//private var mInRange:Boolean = false;
		
		public function CGraphicsManager()
		{
			registerSingletonInstance();
			mMinions = new CConvertibleManager();
			mBuildings = new CConvertibleManager();
			mPeasant = new CVectorExt();
		}
		
		public function registerSingletonInstance():void
		{
			if (mInstance != null)
			{
				throw RegExp("You are not allowed to created another instnace of this object");
			}
		}
		
		public static function getInstance():CGraphicsManager
		{
			if (mInstance == null)
			{
				mInstance = new CGraphicsManager();
				return mInstance;
			}
			else
			{
				return mInstance;
			}
		}
		
		public function flushConvertibles():void
		{
			mMinions.flush();
			mBuildings.flush();
		}
		
		public function getMinions():CConvertibleManager
		{
			return mMinions;
		}
		public function addMinion(aMinion:CGenericConvertible):void
		{
			mMinions.append(aMinion);
		}
		
		
		public function addPeasant(aPeasant:CGenericGraphic):void
		{
			mPeasant.append(aPeasant);
		}
		
		
		
		public function getBuildings():CConvertibleManager
		{
			return mBuildings;
		}
		public function addBuilding(aBuilding:CBuilding):void
		{
			mBuildings.append(aBuilding);
		}
		
		public function removeMinion(aMinion:CGenericConvertible):void
		{
			//mMinions.removeByIndex(aMinion);
		}
		
		
		
		
		public function getTiles():CVectorExt
		{
			return mTiles;
		}
		
		public function update():void
		{
			if (!mStop)
			{
				//THIS HAS TO BE MODIFIED FOR EVERY GAME YOU MAKE, SORRY
				
				mBuildings.update();
				mMinions.update();
				mPeasant.update();
				//mMinions.updateWithCollision(mBuildings,CMessage.COLLIDED_WITH_BUILDING,CMessage.NONE);
			}
		}
		
		public function render():void
		{
			if (!mStop)
			{
				mBuildings.render();
				mMinions.render();
				mPeasant.render();
			}
		}
		
		public function activateNearbyGraphics(aUser:CGenericPlayer, aRangeBlackHoles:int, aRangeRendering:int):void
		{
			//mMinions.checkIfRenderNeedBe(aUser, aRangeRendering);
			//
			//mBuildings.checkIfRenderNeedBe(aUser, aRangeRendering);
		}
		
		
		public function enemyWasKilled():Boolean
		{
			//mScoreLabel.enemyWasKilled();
			return true;
		}
		
		public function destroy():void
		{
			//we gotta do something here
		}
	
	}

}