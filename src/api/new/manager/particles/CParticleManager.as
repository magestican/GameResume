package api.manager.particles 
{
	import api.CLayer;
	import api.manager.CManager;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CParticleManager extends CManager 
	{
		private var mMinTime:int;
		private var mMaxTime:int;
		private var mLayer:CLayer;
		// Singleton.
		private static var mInst:CParticleManager = null;
		
		public function CParticleManager() 
		{
			registerSingleton();
		}
		
		public static function inst():CParticleManager
		{
			return mInst;
		}
		
		private function registerSingleton():void
		{
			if (mInst == null)
			{
				mInst = this;
			}
			else
			{
				throw new Error("Cannot create another instance of Singleton CItemManager.");
			}
		}
		
		public function setLifeTimes(aMinTime:int, aMaxTime:int):void
		{
			mMinTime = aMinTime;
			mMaxTime = aMaxTime;
		}
		
		public function setLayer(aLayer:CLayer):void
		{
			mLayer = aLayer;
		}
		
		public function addParticle(aX:int, aY:int, aColor:int):void
		{
			var tParticle:CParticle = new CParticle(aColor, mLayer, mMinTime, mMaxTime);
			tParticle.setXYZ(aX, aY);
			addObject(tParticle);
		}
		
		public function addParticles(aX:int, aY:int, aColor:int, aAmount:int):void
		{
			for (var i:int = 0; i < aAmount; i++)
			{
				addParticle(aX, aY, aColor);
			}
		}
	}
}