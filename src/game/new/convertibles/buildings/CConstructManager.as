package game.convertibles.buildings 
{
	import api.manager.CManager;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CConstructManager extends CManager 
	{
		// Singleton.
		private static var mInst:CConstructManager = null;
		
		public function CConstructManager() 
		{
			registerSingleton();
		}	
		
		public static function inst():CConstructManager
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
				throw new Error("Cannot create another instance of Singleton CEnemyManager.");
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			if (mInst != null)
			{
				mInst = null
			}
		}
	}

}