package api.shootingSystem 
{
	public class CBulletManager 
	{
		// Singleton.
		private static var mInst:CBulletManager = null;
		
		// List of bullets to be managed.
		private var mBullets:Vector.<CGenericBullet>; 
		
		public function CBulletManager() 
		{
			registerSingleton();
			mBullets = new Vector.<CGenericBullet>();
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
		
		public function update():void
		{
			//trace(mBullets.length);
			
			for (var i:int = mBullets.length - 1; i >= 0; i--)
			{
				mBullets[i].update();
			}
			
			for (var j:int = mBullets.length - 1; j >= 0; j--)
			{
				if (mBullets[j].isDead())
				{
					removeBulletIndex(j);
				}
			}
		}
		
		private function removeBulletIndex(aIndex:uint):void
		{
			if (aIndex < mBullets.length)
			{
				mBullets[aIndex].destroy();
				mBullets.splice(aIndex, 1);
			}
		}
		
		public function render():void
		{
			for (var i:int = mBullets.length - 1; i >= 0; i--)
			{
				mBullets[i].render();
			}
		}
		
		public function addBullet(aBullet:CGenericBullet):void
		{
			mBullets.push(aBullet);
		}
		
		public function destroy():void
		{
			if (mInst)
			{
				// TODO: Recorrer el array llamando a los destroy().
				// Eliminar el array.
				mInst = null;
			}
		}
	}
}

/*
package api.shootingSystem 
{
	import api.CHelper;
	import flash.display.DisplayObjectContainer;
	
	public class CBulletManager 
	{
		// Bullets layer.
		private var mDisplayObjectContainer:DisplayObjectContainer;
		
		public function CBulletManager(aDisplayObjectContainer:DisplayObjectContainer) 
		{
			mDisplayObjectContainer = aDisplayObjectContainer;
			
			
		}
		
		
		
		
		public function destroy():void
		{
			if (mInst)
			{
				mInst.onDestroy();
				mInst = null;
			}
		}
		
		// End Singleton
		
		//Destructor
		private function onDestroy():void
		{
			for (var i:int = mBullets.length - 1; i >= 0; i--)
			{
				mBullets[i].destroy();
				CHelper.removeDisplayObject(mBullets[i]);
			}
			mBullets.splice(0, mBullets.length);
			mBullets = null;
			mDisplayObjectContainer = null;
		}
		
		//update function
		public function update():void
		{
			for (var i:int = mBullets.length - 1; i >= 0; i--)
			{
				mBullets[i].update();
				
			}
			
			for (var j:int = mBullets.length - 1; j >= 0; j--)
			{
				if (mBullets[j].isDead())
				{
					removeBulletIndex(j);
				}
				//checkCollisionBullet( mBullets[i], i );
			}
		}
		
		//render function
		public function render():void
		{
			for (var i:int = mBullets.length - 1; i >= 0; i--)
			{
				mBullets[i].render();
			}
		}
		
		public function removeBulletIndex( aIndex:uint ):void
		{
			if ( aIndex < mBullets.length )
			{
				mBullets[aIndex].destroy();
				CHelper.removeDisplayObject(mBullets[aIndex]);
				mBullets.splice( aIndex, 1 );
			}
		}
		
		public function addBullet(aBullet:CGenericBullet):void
		{
			//checkCollisionBullet( aBullet, -1 );
			//if ( !aBullet.mustDie() )
			//{
				mBullets.push( aBullet );
				mDisplayObjectContainer.addChild(aBullet);
				//aBullet.setLayer( mDisplayObjectContainer );
			//}
		}
		
	}
}*/