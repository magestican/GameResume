package api
{
	import api.math.CMath;
	import api.math.CVector2D;
	import api.math.CVector3D;
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CCamera extends CGameObject
	{
		// Constants
		private const THRESHOLD_HIGH:uint = 64;
		private const THRESHOLD_LOW:uint = 6;
		private var mHorizontalOffset:int = 0;
		
		public static const FOLLOWING:uint = 0;
		public static const KEEPING_UP:uint = 1;
		public static const HANDLED:uint = 2;
		
		private var mSpeed:Number = 0.1;
		private var mStateX:int;
		private var mStateY:int;
		
		private var mActiveOffset:int = 0;
		
		private var mFollowee:CGameObject;
		
		private static var mInstance:CCamera;
		
		public static function getInstance(aStageWidth:int, aStageHeight:int, aMaxX:Number = 0, aMaxY:Number = 0):CCamera
		{
			if (mInstance == null)
			{
				mInstance = new CCamera(aStageWidth, aStageHeight, aMaxX, aMaxY);
				return mInstance;
			}
			else
			{
				return mInstance;
			}
		}
		
		public function CCamera(aStageWidth:int, aStageHeight:int, maxX:Number,maxY:Number)
		{
			if (mInstance != null)
			{
				throw RegExp("You are not allowed to created another instnace of this object");
			}
			setWidth(aStageWidth);
			setHeight(aStageHeight);
		    setBoundAction(STOP);
			setBounds(0, 0, maxX, maxY);
		}
		
		
		override public function update():void 
		{
			setTimeState(getTimeState() + 1);
			
			if (mStateX == FOLLOWING)
			{
				setX((mFollowee.getX()) - (getWidth() * 0.5));
			}
			else if (mStateX == KEEPING_UP)
			{
				if (Math.abs(getX() + getWidth() * 0.5 - mFollowee.getX()) < THRESHOLD_LOW || getX() <= 0)
				{
					setStateX(FOLLOWING);
					return;
				}
				var tmSpeedX:Number = (mFollowee.getX() - getX() - getWidth() * 0.5) * mSpeed;
				setVelX(tmSpeedX + CMath.getSign(tmSpeedX) * mSpeed);
			}
			
			if (mStateY == FOLLOWING)
			{
				setY((mFollowee.getY()) - (getHeight() * 0.5));
			}
			else if (mStateY == KEEPING_UP)
			{
				if (Math.abs(getY() + getHeight() * 0.5 - mFollowee.getY()) < THRESHOLD_LOW || getY() <= 0)
				{
					setStateY(FOLLOWING);
					return;
				}
				var tmSpeedY:Number = (mFollowee.getY() - getY() - getWidth() * 0.5) * mSpeed;
				setVelY(tmSpeedY + CMath.getSign(tmSpeedY) * mSpeed);
			}
			
			super.update();
			
			//if (getX() < 0)
			//{
				//setX( 0);
			//}
			//if (getY() < 0)
			//{
				//setY(0);
			//}
			//if (getX() > getMaxBounds().x - getWidth())
			//{
				//setX(getMaxBounds().x - getWidth());
			//}
			//if (getY() > getMaxBounds().y - getHeight())
			//{
				//setY( getMaxBounds().y - getHeight());
			//}
		}
		
		override public function render():void 
		{
			super.render();
			CLayer.masterLayer.x = - getX();
			CLayer.masterLayer.y = - getY();
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		
		public  function follow(aObject:CGameObject):void
		{
			mFollowee = aObject;
			setStateX(FOLLOWING);
			setStateY(FOLLOWING);
			setState(FOLLOWING);
		}
		
		public function setStateX(aState:int):void
		{
			mStateX = aState;
			
			if (mStateX == FOLLOWING)
			{
				setVelX(0);
			}
		}
		
		public function setStateY(aState:int):void
		{
			mStateY = aState;
			
			if (mStateY == FOLLOWING)
			{
				setVelY(0);
			}
		}
		
		//public function getCenter():CVector3D
		//{
			//var tVect:CVector3D = new CVector3D();
			//tVect = getPos();
			//tVect.x += getWidth() * 0.5 ;
			//tVect.y += getHeight() * 0.5 ;
			//return tVect;
		//}
		public function isLocked():Boolean
		{
			return mStateX == FOLLOWING && mStateY == FOLLOWING;
		}
		
		
		
		public function isLockedX():Boolean
		{
			return mStateX == FOLLOWING;
		}
		
		public function isLockedY():Boolean
		{
			return mStateY == FOLLOWING;
		}
		
		
		public function setHorizontalOffset(aHorizontalOffset:int):void
		{
			mHorizontalOffset = aHorizontalOffset;
		}
		
		public function getRightX():int
		{
			return getX() + getWidth();
		}
		public function getBottomY():int
		{
			return getY() + getHeight();
		}
		
		public function setActiveOffset(aOffset:int):void
		{
			mActiveOffset = aOffset;
		}
		public function getActiveOffset():int
		{
			return mActiveOffset;
		}
		
		public static function X():int
		{
			return mInstance.getX();
		}
		public static function Y():int
		{
			return mInstance.getY();
		}
		
		public function isHandled():Boolean
		{
			return mStateX == HANDLED || mStateY == HANDLED;
		}
		
		public function setCamSpeed(aSpeed:Number):void
		{
			mSpeed = aSpeed;
		}
	}

}