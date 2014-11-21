package api
{
	import adobe.utils.CustomActions;
	import api.ai.behaviour.CGenericBehaviour;
	import api.ai.behaviour.CMazeMovementBehaviour;
	import api.enums.CMessage;
	import api.enums.CShapes;
	import api.enums.CVel;
	import api.enums.CVelAccel;
	import api.extensions.CVectorExt;
	import api.math.CCircle;
	import api.enums.CDirection;
	import api.math.CMath;
	import api.math.CSpeed;
	import api.math.CVector2D;
	import api.math.CVector3D;
	import com.google.analytics.debug.Label;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class CGameObject implements IGameObject
	{
		// CONSTANTS
		public static const NONE:uint = 0; // Ignora los bordes
		public static const WRAP:uint = 1; // Se va por un lado y sale por el contrari
		public static const BOUNCE:uint = 2; // Rebota
		public static const STOP:uint = 3; // Queda parado.
		public static const DIE:uint = 4; // Se destruye el objeto.
		
		private var mPos:CVector3D = new CVector3D();
		private var mVel:CVector3D = new CVector3D();
		private var mAccel:CVector3D = new CVector3D();
		private var mAnimation:CAnimation = new CAnimation();
		private var mSound:CSoundAndMusic = new CSoundAndMusic();
		private var mMusic:CSoundAndMusic = new CSoundAndMusic();
		private var mOldPos:CVector3D = new CVector3D();
		private var mOldVel:CVector3D = new CVector3D();
		
		private var mBehaviours:Vector.<CGenericBehaviour> = new Vector.<CGenericBehaviour>;
		
		private var mInitPosition:CVector2D = new CVector2D();
		private var mAngle:Number = 0;
		private var mCircle:CCircle;
		private var mRectangle:Rectangle;
		private var mActive:Boolean = false;
		private var mName:String = "";
		private var mGuid:Number = 0;
		
		private var mMax:CVector2D = new CVector2D(CMath.INFINITY, CMath.INFINITY);
		private var mMin:CVector2D = new CVector2D(-CMath.INFINITY, -CMath.INFINITY);
		private var mSpeed:int = 0;
		
		private var mShape:Number = -1;
		//private var CShapes:CShapes = new CShapes();
		private var mState:uint = 0;
		private var mTimeState:uint = 0;
		
		private var mMessage:Number = CMessage.NONE;
		private var mBoundAction:uint = 0;
		
		private var mHeight:uint;
		private var mWidth:uint;
		private var mRadious:uint;
		
		private var mDead:Boolean = false;
		private var mRedirect:Boolean = false;
		
		private var mc:MovieClip = null;
		private var mSprite:Sprite = null;
		private var bmp:Bitmap = null;
		private var mLayer:CLayer;
		private var mFlipped:Boolean = false;
		private var mFlipOffset:int = 0;
		
		private var mFriction:Number = 1.0;
		private var mMaxSpeed:Number = 9999;
		private var mRegistryPoint:CVector2D = new CVector2D(0, 0);
		private var mOffset:CVector2D = new CVector2D(0, 0);
		
		public function CGameObject()
		{
			mBoundAction = NONE;
		}
		
		public function play():void
		{
		}
		
		public function setMC(aMC:MovieClip):void
		{
			if (aMC != null)
			{
				if (mc != null)
				{
					CHelper.removeDisplayObject(mc);
				}
				mc = aMC;
				if (mc != null)
					mc.mouseEnabled = false;
			}
		}
		
		public function getMC():MovieClip
		{
			return mc;
		}
		
		public function getX():Number
		{
			return mPos.x;
		}
		
		public function getY():Number
		{
			return mPos.y;
		}
		
		public function getPos():CVector3D
		{
			return mPos;
		}
		
		public function getVelX():Number
		{
			return mVel.x;
		}
		
		public function getVelY():Number
		{
			return mVel.y;
		}
		
		public function getVel():CVector3D
		{
			return mVel;
		}
		
		public function getAccelX():Number
		{
			return mAccel.x;
		}
		
		public function getAccelY():Number
		{
			return mAccel.y;
		}
		
		public function getAccel():CVector3D
		{
			return mAccel;
		}
		
		public function getLocalCoordinates():Point
		{
			if (mc != null)
			{
				return mc.localToGlobal(new flash.geom.Point(mc.x, mc.y));
			}
			else if (mSprite != null)
			{
				return mSprite.localToGlobal(new flash.geom.Point(mSprite.x, mSprite.y));
			}
			return null;
		}
		
		public function setFlipped(aFlipped:Boolean):void
		{
			mFlipped = aFlipped;
		}
		
		public function isFlipped():Boolean
		{
			return mFlipped;
		}
		
		public function setActive(aActive:Boolean):void
		{
			mActive = aActive;
		}
		
		public function isActive():Boolean
		{
			return mActive;
		}
		
		public function setLayer(aLayer:CLayer):void
		{
			mLayer = aLayer;
		}
		
		public function getLayer():CLayer
		{
			return mLayer;
		}
		
		public function setBmp(aBmp:Bitmap):void
		{
			bmp = aBmp;
		}
		
		public function getBmp():Bitmap
		{
			return bmp;
		}
		
		public function setCircle(aCircle:CCircle):void
		{
			mCircle = aCircle;
		}
		
		public function getCircle():CCircle
		{
			mCircle.mCenter.x = getX();
			mCircle.mCenter.y = getY();
			return mCircle;
		}
		
		public function setRectangle(aRectangle:Rectangle):void
		{
			mRectangle = aRectangle;
		}
		
		public function getRectangle():Rectangle
		{
			mRectangle.x = getX();
			mRectangle.y = getY();
			return mRectangle;
		}
		
		public function setTimeState(aTimeState:int):void
		{
			mTimeState = aTimeState;
		}
		
		public function getTimeState():int
		{
			return mTimeState;
		}
		
		public function setX(aX:Number):void
		{
			mPos.x = aX;
		
			//if (mShape == CShapes.CIRCLE)
			//{
			//mCircle.mCenter.x = aX;
			//}
			//else if (mShape == CShapes.SQUARE)
			//{
			//mRectangle.x = aX; // (aX + (mRectangle.width * 0.5));
			//}
		
		}
		
		public function setY(aY:Number):void
		{
			mPos.y = aY;
			
			if (mShape == CShapes.CIRCLE)
			{
				mCircle.mCenter.y = aY;
			}
			else if (mShape == CShapes.SQUARE)
			{
				mRectangle.y = aY; // (aY + (mRectangle.height * 0.5));
			}
		}
		
		public function setXY(aX:Number, aY:Number):void
		{
			mPos.x = aX;
			mPos.y = aY;
		
			//if (mShape == CShapes.CIRCLE)
			//{
			//mCircle.mCenter.y = aY;
			//mCircle.mCenter.x = aX;
			//}
			//else if (mShape == CShapes.SQUARE)
			//{
			//mRectangle.y = aY; // (aY + (mRectangle.height * 0.5));
			//mRectangle.x = aX; // (aX + (mRectangle.width * 0.5));
			//}
		}
		
		public function setPos(pos:CVector3D):void
		{
			mPos.x = pos.x;
			mPos.y = pos.y;
			mPos.z = pos.z;
		
			//if (mShape == CShapes.CIRCLE)
			//{
			//mCircle.mCenter.y = mPos.y;
			//mCircle.mCenter.x = mPos.x;
			//mCircle.mCenter.z = mPos.z;
			//}
			//else if (mShape == CShapes.SQUARE)
			//{
			//mRectangle.y = mPos.y; //(mPos.y + (mRectangle.height * 0.5));
			//mRectangle.x = mPos.x; //(mPos.x + (mRectangle.width * 0.5));
			//}
		}
		
		public function setPosXYZ(aX:Number = 0, aY:Number = 0, aZ:Number = 0):void
		{
			mPos.x = aX;
			mPos.y = aY;
			mPos.z = aZ;
			//if (mShape == CShapes.CIRCLE)
			//{
			//mCircle.mCenter.y = mPos.y;
			//mCircle.mCenter.x = mPos.x;
			//mCircle.mCenter.z = mPos.z;
			//}
			//else if (mShape == CShapes.SQUARE)
			//{
			//mRectangle.y = mPos.y; //(mPos.y + (mRectangle.height * 0.5));
			//mRectangle.x = mPos.x; //(mPos.x + (mRectangle.width * 0.5));
			//}
		}
		
		public function setInitPos(pos:CVector2D):void
		{
			mInitPosition.x = pos.x;
			mInitPosition.y = pos.y;
		}
		
		public function setShape(aShape:Number):void
		{
			mShape = aShape;
			if (aShape == CShapes.SQUARE)
			{
				mRectangle = new Rectangle();
			}
			else if (aShape == CShapes.CIRCLE)
			{
				mCircle = new CCircle();
			}
		}
		
		public function getShape():Number
		{
			return mShape;
		}
		
		public function setVelX(aVelX:Number):void
		{
			mVel.x = aVelX;
		}
		
		public function setVelY(aVelY:Number):void
		{
			mVel.y = aVelY;
		}
		
		public function setVelXYZ(aVelX:Number, aVelY:Number, aVelZ:Number = 0):void
		{
			mVel.x = aVelX;
			mVel.y = aVelY;
			mVel.z = aVelZ;
		}
		
		public function setVel(aVel:CVector3D):void
		{
			mVel.x = aVel.x;
			mVel.y = aVel.y;
			mVel.z = aVel.z;
		}
		
		//opposite side and adjacent side is the distance we must travel
		public function setSpeed(aSpeed:int):void
		{
			mSpeed = aSpeed;
		}
		
		public function getSpeed():int
		{
			return mSpeed;
		}
		
		public function setAccelX(aAccelX:Number):void
		{
			mAccel.x = aAccelX;
		}
		
		public function setAccelY(aAccelY:Number):void
		{
			mAccel.y = aAccelY;
		}
		
		public function setAccelXYZ(aAccelX:Number, aAccelY:Number, aAccelZ:Number = 0):void
		{
			mAccel.x = aAccelX;
			mAccel.y = aAccelY;
			mAccel.y = aAccelY;
		}
		
		public function setAccel(aAccel:CVector3D):void
		{
			mAccel = aAccel;
		}
		
		public function setOldData():void
		{
			mOldPos.x = mPos.x;
			mOldPos.y = mPos.y;
			mOldPos.z = mPos.z;
			mOldVel.x = mVel.x;
			mOldVel.y = mVel.y;
			mOldVel.z = mVel.z;
		}
		
		public function update():void
		{
			//add acceleration to velocity, multiplicate by friction, check if fixage is needed
			mVel.addVec(mAccel);
			mVel.mult(mFriction);
			mVel.truncate(mMaxSpeed);
			mPos.addVec(mVel);
			
			// Floor all positions to avoid render problems
			mPos.x = Math.floor(mPos.x);
			mPos.y = Math.floor(mPos.y);
			mPos.z = Math.floor(mPos.z);
			
			var touchesLeft:Boolean = getX() < mMin.x;
			var touchesRight:Boolean = getX() > mMax.x;
			var touchesUp:Boolean = getY() < mMin.y;
			var touchesDown:Boolean = getY() > mMax.y;
			
			if (mBoundAction == BOUNCE)
			{
				if (getX() + mRegistryPoint.x + mWidth > mMax.x)
				{
					setX(mMax.x - mWidth - mRegistryPoint.x);
					setVelX(getVelX() * -1);
				}
				
				if (getX() + mRegistryPoint.x < mMin.x)
				{
					setX(mMin.x - mRegistryPoint.x);
					setVelX(getVelX() * -1);
				}
				
				if (getY() + mRegistryPoint.y + mHeight > mMax.y)
				{
					setY(mMax.y - mRegistryPoint.y - mHeight);
					setVelY(getVelY() * -1);
				}
				if (getY() + mRegistryPoint.y < mMin.y)
				{
					setY(mMin.y - mRegistryPoint.y);
					setVelY(getVelY() * -1);
				}
			}
			if (mBoundAction == WRAP)
			{
				if (getX() + mRegistryPoint.x > mMax.x)
				{
					setX(mMin.x - mRegistryPoint.x - mWidth);
				}
				
				if (getX() + mRegistryPoint.x + mWidth < mMin.x)
				{
					setX(mMax.x - mRegistryPoint.x);
				}
				
				if (getY() + mRegistryPoint.y > mMax.y)
				{
					setY(mMin.y - mRegistryPoint.y - mHeight);
				}
				
				if (getY() + mRegistryPoint.y + mHeight < mMin.y)
				{
					setY(mMax.y - mRegistryPoint.y);
				}
			}
			if (mBoundAction == STOP || mBoundAction == DIE)
			{
				if (getX() + mRegistryPoint.x + mWidth > mMax.x)
				{
					setX(mMax.x - mRegistryPoint.x - mWidth);
					setVelX(0);
					setAccelX(0);
				}
				
				if (getX() + mRegistryPoint.x < mMin.x)
				{
					setX(mMin.x - mRegistryPoint.x);
					setVelX(0);
					setAccelX(0);
				}
				
				if (getY() + mRegistryPoint.y + mHeight > mMax.y)
				{
					setY(mMax.y - mRegistryPoint.y - mHeight);
					setVelY(0);
					setAccelY(0);
				}
				
				if (getY() + mRegistryPoint.y < mMin.y)
				{
					setY(mMin.y - mRegistryPoint.y);
					setVelY(0);
					setAccelY(0);
				}
			}
			mTimeState++;
			setOldData();
		}
		
		public function stopMove():void
		{
			setVelX(0);
			setVelY(0);
			setAccelX(0);
			setAccelY(0);
		}
		
		public function setBoundAction(aBoundAction:uint):void
		{
			mBoundAction = aBoundAction;
		}
		
		public function setBounds(aMinX:Number, aMinY:Number, aMaxX:Number, aMaxY:Number):void
		{
			mMin.x = aMinX;
			mMax.x = aMaxX;
			mMin.y = aMinY;
			mMax.y = aMaxY;
		}
		
		public function getMaxBounds():CVector2D
		{
			return mMax;
		}
		
		public function getMinBoounds():CVector2D
		{
			return mMin;
		}
		
		public function setState(aState:Number):void
		{
			mState = aState;
			mTimeState = 0;
		}
		
		public function getState():int
		{
			return mState;
		}
		
		public function manageStates():void
		{
		
		}
		
		public function sendMessage(aMessage:Number):void
		{
			mMessage = aMessage;
		}
		
		public function render():void
		{
		
		}
		
		public function destroy():void
		{
		
		}
		
		public function setDead(aDead:Boolean):void
		{
			mDead = aDead;
		}
		
		public function isDead():Boolean
		{
			return mDead;
		}
		
		public function kill():void
		{
			mDead = true;
		}
		
		public function redirect():void
		{
			mRedirect = true;
		}
		
		public function getHeight():uint
		{
			return mHeight;
		}
		
		public function setHeight(aHeight:uint):void
		{
			mHeight = aHeight;
			if (mRectangle != null)
			{
				mRectangle.height = aHeight;
			}
		}
		
		public function getWidth():uint
		{
			return mWidth;
		}
		
		public function setWidth(aWidth:uint):void
		{
			mWidth = aWidth;
			if (mRectangle != null)
			{
				mRectangle.width = aWidth;
			}
		}
		
		public function getRadious():uint
		{
			return mRadious;
		}
		
		public function setRadious(aRadious:uint):void
		{
			mRadious = aRadious;
			if (mCircle != null)
			{
				mCircle.mRadious = aRadious;
			}
		}
		
		public function setAngle(degrees:Number):void
		{
			mAngle = CMath.clampDeg(degrees);
		}
		
		public function getAngle():Number
		{
			return mAngle;
		}
		
		public function setSprite(aSprite:Sprite):void
		{
			mSprite = aSprite;
			if (mSprite != null)
				mSprite.mouseEnabled = false;
		}
		
		public function getSprite():Sprite
		{
			return mSprite;
		}
		
		public function lookAt(ax:Number, ay:Number):void
		{
			var dx:Number = ax - getX();
			var dy:Number = ay - getY();
			setAngle(CMath.rad2deg(Math.atan2(dy, dx)));
		}
		
		public function lookAtGetAngle(ax:Number, ay:Number):Number
		{
			var dx:Number = ax - getX();
			var dy:Number = ay - getY();
			return CMath.rad2deg(Math.atan2(dy, dx));
		}
		
		public function setName(aName:String):void
		{
			mName = aName;
		}
		
		public function getName():String
		{
			return mName;
		}
		
		public function setRegistryPointXY(x:int, y:int):void
		{
			mRegistryPoint.x = x;
			mRegistryPoint.y = y;
		}
		public function setRegistryPoint(vec:CVector2D):void
		{
			mRegistryPoint = vec;
		}
		public function getRegistryPoint():CVector2D
		{
			return mRegistryPoint;
		}
		
		public function setOffsetXY(x:int, y:int):void
		{
			mOffset.x = x;
			mOffset.y = y;
		}
		public function setOffset(vec:CVector2D):void
		{
			mOffset = vec;
		}
		public function getOffset():CVector2D
		{
			return mOffset;
		}
		
		public function setGuid(aGuid:Number):void
		{
			mGuid = aGuid;
		}
		
		public function getGuid():Number
		{
			return mGuid;
		}
		
		public function distanceTo(aGameObject:CGameObject):Number
		{
			var tThisPos:CVector3D;
			var tObjectPos:CVector3D;
			if (mShape == CShapes.CIRCLE)
			{
				tThisPos = new CVector3D(getX(), getY());
			}
			else if (mShape == CShapes.SQUARE)
			{
				tThisPos = new CVector3D(getX() + getWidth() * 0.5, getY() + getWidth() * 0.5);
			}
			
			if (aGameObject.mShape == CShapes.CIRCLE)
			{
				tObjectPos = new CVector3D(aGameObject.getX(), aGameObject.getY());
			}
			else if (aGameObject.mShape == CShapes.SQUARE)
			{
				tObjectPos = new CVector3D(aGameObject.getX() + aGameObject.getWidth() * 0.5, aGameObject.getY() + aGameObject.getWidth() * 0.5);
			}
			
			//return tThisPos.substract(tObjectPos).norm();
			return Math.sqrt((tThisPos.x - tObjectPos.x) * (tThisPos.x - tObjectPos.x) + (tThisPos.y - tObjectPos.y) * (tThisPos.y - tObjectPos.y));
		}
		
		public function getCenter():CVector3D
		{
			if (mShape == CShapes.CIRCLE)
				return new CVector3D(getX(), getY());
			else if (mShape == CShapes.SQUARE)
				return new CVector3D(getX() + getRegistryPoint().x + getWidth() * 0.5, getY() + getRegistryPoint().y + getHeight() * 0.5);
			return null;
		}
		
		public function convertToBitmap():Boolean
		{
			var bmd1:BitmapData;
			if (bmp != null)
			{
				return true;
			}
			else if (mc != null)
			{
				bmd1 = new BitmapData(mc.height, mc.width, false, 0x000000);
				bmd1.draw(mc);
				bmp = new Bitmap(bmd1);
				bmp.x = mc.x;
				bmp.y = mc.y;
			}
			else if (mSprite != null)
			{
				bmd1 = new BitmapData(mSprite.height, mSprite.width, false, 0x000000);
				bmd1.draw(mSprite);
				bmp = new Bitmap(bmd1);
				bmp.x = mSprite.x;
				bmp.y = mSprite.y;
			}
			
			return false;
		}
		
		public function addBehaviour(aBehaviour:CGenericBehaviour):void
		{
			mBehaviours.push(aBehaviour);
		}
		
		public function getBehaviours():Vector.<CGenericBehaviour>
		{
			return mBehaviours;
		}
		
		public function getMusic():CSoundAndMusic
		{
			return mMusic;
		}
		
		public function getSound():CSoundAndMusic
		{
			return mSound;
		}
		
		public function setMusic(aMusic:CSoundAndMusic): void
		{
		     mMusic = aMusic;
		}
		
		public function setSound(aSound:CSoundAndMusic):void
		{
			 mSound = aSound;
		}
	
	}
}