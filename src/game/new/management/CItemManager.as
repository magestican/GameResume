package game.management {
	import api.CGameObject;
	public class CItemManager 
	{
		// Singleton.
		private static var mInst:CItemManager = null;
		
		// List of Items to be managed.
		private var mItems:Vector.<CGenericItem>; 
		
		public function CItemManager() 
		{
			registerSingleton();
			mItems = new Vector.<CGenericItem>();
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
		
		public function getNumItems():uint
		{
			return mItems.length;
		}
		
		public function update():void
		{
			for (var i:int = mItems.length - 1; i >= 0; i--)
			{
				mItems[i].update();
			}
			
			for (var j:int = mItems.length - 1; j >= 0; j--)
			{
				if (mItems[j].isDead())
				{
					removeItemIndex(j);
				}
			}
		}
		
		public function collides(aGameObject:CGameObject):CGenericItem
		{
			for (var i:int = mItems.length - 1; i >= 0; i--)
			{
				if (aGameObject.collides(mItems[i]))
					return mItems[i];
			}
			
			return null;
		}
		
		public function flushItems():void
		{
			for (var j:int = mItems.length - 1; j >= 0; j--)
			{
				removeItemIndex(j);
			}
		}
		
		private function removeItemIndex(aIndex:uint):void
		{
			if (aIndex < mItems.length)
			{
				mItems[aIndex].destroy();
				mItems.splice(aIndex, 1);
			}
		}
		
		public function render():void
		{
			for (var i:int = mItems.length - 1; i >= 0; i--)
			{
				mItems[i].render();
			}
		}
		
		public function addItem(aItem:CGenericItem):void
		{
			mItems.push(aItem);
		}
		
		public function destroy():void
		{
			if (mInst)
			{
				for (var i:int = mItems.length - 1; i >= 0; i--)
				{
					mItems[i].destroy();
				}
				mInst = null;
				mItems = null;
			}
		}
	}
}