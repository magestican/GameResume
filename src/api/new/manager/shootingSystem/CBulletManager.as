package api.shootingSystem 
{
	import api.CGameObject;
	import api.manager.CManager;
	public class CBulletManager extends CManager
	{
		// Singleton.
		private static var mInst:CBulletManager = null;
		
		public function CBulletManager() 
		{
			registerSingleton();
		}	
		
		public static function inst():CBulletManager
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
				throw new Error("Cannot create another instance of Singleton CBulletManager.");
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