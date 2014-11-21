package api.manager 
{
	import api.CGameObject;
	public class CManager 
	{
		// List of Objects to be managed.
		private var mArray:Vector.<CGameObject>; 
		
		public function CManager() 
		{
			mArray = new Vector.<CGameObject>();
		}	
		
		public function getNumArray():uint
		{
			return mArray.length;
		}
		
		public function update():void
		{
			for (var i:int = mArray.length - 1; i >= 0; i--)
			{
				mArray[i].update();
			}
			
			for (var j:int = mArray.length - 1; j >= 0; j--)
			{
				if (mArray[j].isDead())
				{
					removeObjectIndex(j);
				}
			}
		}
		
		public function flushObjects():void
		{
			for (var j:int = mArray.length - 1; j >= 0; j--)
			{
				removeObjectIndex(j);
			}
		}
		
		private function removeObjectIndex(aIndex:uint):void
		{
			if (aIndex < mArray.length)
			{
				mArray[aIndex].destroy();
				mArray.splice(aIndex, 1);
			}
		}
		
		public function render():void
		{
			for (var i:int = mArray.length - 1; i >= 0; i--)
			{
				mArray[i].render();
			}
		}
		
		public function addObject(aObject:CGameObject):void
		{
			mArray.push(aObject);
		}
		
		public function destroy():void
		{
			for (var i:int = mArray.length - 1; i >= 0; i--)
			{
				mArray[i].destroy();
			}
			mArray = null;
		}
	}
}