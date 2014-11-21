package api.manager.enemyManager 
{
	import api.manager.CManager;
	import api.CGameObject;
	import api.CMath;
	import api.shootingSystem.CGenericBullet;
	public class CEnemyManager extends CManager
	{
		// Singleton.
		private static var mInst:CEnemyManager = null;
		
		public function CEnemyManager() 
		{
			registerSingleton();
		}	
		
		public static function inst():CEnemyManager
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
		
		override public function update():void
		{
			super.update();
		}
		
		override public function render():void
		{
			super.render();
		}
		
		override public function destroy():void
		{
			super.destroy();
			if (mInst)
			{
				mInst = null;
			}

		}
	}
}