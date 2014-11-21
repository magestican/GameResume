package api.manager.itemManager 
{
	import api.manager.CManager;
	import api.CGameObject;
	
	public class CItemManager extends CManager
	{
		// Singleton.
		private static var mInst:CItemManager = null;

		public function CItemManager() 
		{
			registerSingleton();
		}	
		
		public static function inst():CItemManager
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