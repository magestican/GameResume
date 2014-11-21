package api 
{
	import api.input.CMouse;
	import api.prefabs.CRect;
	import api.tileMap.CTileMap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CMinimap extends CGameObject 
	{
		private var mMapBackground:CRect;
		private var mCameraOutline:CRect;
		
		private var mRatio:Number = 1;
		
		private var mCamera:CCamera;
		private var mMap:CTileMap;
		private var mLayer:CLayer;
		
		private var mObjects:Vector.<CGameObject>;
		private var mReferences:Vector.<Sprite>;
		
		private var mHandled:Boolean = false;
		
		public function CMinimap(aWidth:int, aLayer:CLayer) 
		{
			mObjects = new Vector.<CGameObject>;
			mReferences = new Vector.<Sprite>;
			
			mCamera = CGame.inst().getCamera();
			mMap = CGame.inst().getMap();
			
			mRatio = aWidth / mMap.getWorldWidth();
			
			setWidth(aWidth);
			setHeight(mMap.getWorldHeight() * mRatio);
			
			mMapBackground = new CRect(getWidth(), getHeight(), 0x797979);
			mCameraOutline = new CRect(mCamera.getWidth() * mRatio, mCamera.getHeight() * mRatio, 0x62FF89);
			mLayer = aLayer;
			mLayer.addChild(mMapBackground);
			mLayer.addChild(mCameraOutline);
		}
		
		public function addObject(aObject:CGameObject, aReference:Sprite):void
		{
			mObjects.push(aObject);
			mReferences.push(aReference);
			mLayer.addChild(aReference);
		}
		
		public function addSimpleObject(aObject:CGameObject, aColor:int):void
		{
			mObjects.push(aObject);
			var tRect:CRect = new CRect(aObject.getWidth() * mRatio, aObject.getHeight() * mRatio, aColor);
			mLayer.addChild(tRect);
			mReferences.push(tRect);
		}
		
		public function removeObject(aObject:CGameObject):void
		{
			var i:int = 0;
			var tFound:Boolean = false;
			while (i < mObjects.length && !tFound)
			{
				if (mObjects[i] == aObject)
				{
					CHelper.removeDisplayObject(mReferences[i]);
					mObjects.splice(i, 1);
					mReferences.splice(i, 1);
					tFound = true;
				}
				i++;
			}
		}
		
		public function removeObjectByID(aID:int):void
		{
			CHelper.removeDisplayObject(mReferences[aID]);
			mObjects.splice(aID, 1);
			mReferences.splice(aID, 1);
		}
		
		//Getters & Setters
		public function getRatio():Number
		{
			return mRatio;
		}
		
		public function mouseOver():Boolean
		{
			return CMouse.getMouseX() >= getX() && CMouse.getMouseX() < getX() + getWidth() && CMouse.getMouseY() >= getY() && CMouse.getMouseY() < getY() + getHeight();
		}
		
		override public function update():void 
		{
			super.update();
			if (CMouse.pressed())
			{
				if (mouseOver())
				{
					mHandled = true;
					mCamera.setXY(Math.floor((CMouse.getMouseX() - getX()) / mRatio - mCamera.getWidth() * 0.5), Math.floor((CMouse.getMouseY() - getY()) / mRatio - mCamera.getHeight() * 0.5));
					mCamera.setStateX(CCamera.HANDLED);
					mCamera.setStateY(CCamera.HANDLED);
				}
			}
			//if (CMouse.release() && mHandled)
			//{
				//mHandled = false;
				//mCamera.setStateX(CCamera.KEEPING_UP);
				//mCamera.setStateY(CCamera.KEEPING_UP);
			//}
		}
		
		override public function render():void 
		{
			mCameraOutline.x = getX() + mCamera.getX() * mRatio;
			mCameraOutline.y = getY() + mCamera.getY() * mRatio;
			mMapBackground.x = getX();
			mMapBackground.y = getY();
			for (var i:int = mObjects.length - 1; i >= 0; i--)
			{
				if (mObjects[i].isDead() || mObjects[i] == null)
				{
					removeObjectByID(i);
				}
				else
				{
					mReferences[i].x = getX() + mObjects[i].getX() * mRatio;
					mReferences[i].y = getY() + mObjects[i].getY() * mRatio;
				}
			}
		}
	}

}