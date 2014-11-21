package game.convertibles.units 
{
	import api.ai.behaviour.CGenericBehaviour;
	import api.CAnim;
	import api.CGame;
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.debug.CDebugTarget;
	import api.enums.CShapes;
	import api.extensions.CVector2dExt;
	import api.math.CCircle;
	import api.math.CMath;
	import api.math.CVector3D;
	import api.pathfinding.CPathFollowing;
	import api.prefabs.CRect;
	import flash.display.MovieClip;
	import game.CAura;
	import game.CConvertInfluenceMap;
	import game.constants.CGameConstants;
	import game.convertibles.CGenericConvertible;
	import game.CVars;
	import game.management.CConvertibleManager;
	import game.management.CGraphicsManager;
	
	
	public class CGenericUnit extends CGenericConvertible 
	{
		public static const PATH_UPDATE_TIME:uint = CGameConstants.FPS * 20;
		// States
		public static const IDLE:uint = 0;
		public static const FOLLOW_PLAYER:uint = 1;
		public static const FOLLOW_TARGET:uint = 2;
		public static const FOLLOW_CONVERTIBLE:uint = 3;
		public static const CONVERTING:uint = 4;
		public static const PATROLLING:uint = 5;
		
		// ANIM STATES
		private const ANIM_IDLE:uint = 0;
		private const ANIM_WALKING:uint = 1;
		private const ANIM_CONVERTING:uint = 2;
		
		// ANIM FRAMES
		private var mAnimDelay:int;
		private var mFramesIdle:Array;
		private var mFramesWalking:Array;
		private var mFramesConverting:Array;

		// Stats
		private var mWalkingSpeed:int = 1;
		private var mCloseRange:int = 0;
		private var mRange:int = 0;
		private var mIdleTime:int = 0;
		private var mAgressive:Boolean = true;

		private var mConvertible:CGenericConvertible = null;
		private var mTarget:CVector3D = new CVector3D();
		private var mBehaviour:CGenericBehaviour;
		
		private var mAura:CAura;
		
		private var mConvertedMC:MovieClip;
		private var mNormalMC:MovieClip;
		
		private var mPathFinder:CPathFollowing;
		
		private var mAnim:CAnim;
		private var mAnimState:int = 0;
		
		//DEBUG
		private var mDebugTarget:CDebugTarget;
		
		public function CGenericUnit() 
		{
			setShape(CShapes.SQUARE);
			if (CGameConstants.DEBUG)
				mDebugTarget = new CDebugTarget();
			setBoundAction(CGameObject.STOP);
			setBounds(0, 0, CGame.inst().getMap().getWorldWidth(), CGame.inst().getMap().getWorldHeight());
			
			mPathFinder = new CPathFollowing(this);
			mAnim = new CAnim();
		}
		
		// Getters & Setters
		public function setAnim(aIdleFrames:Array, aWalkingFrames:Array, aConvertingFrames:Array, aAnimDelay:int):void
		{
			mAnimDelay = aAnimDelay;
			mFramesIdle = aIdleFrames;
			mFramesWalking = aWalkingFrames;
			mFramesConverting = aConvertingFrames;
		}
		public function getAnim():CAnim
		{
			return mAnim;
		}
		
		public function setIdleTime(aIdleTime:int):void
		{
			mIdleTime = aIdleTime;
			setTimeState(CMath.randInt(0, mIdleTime));
		}
		
		public function setConvertedMC(aMC:MovieClip):void
		{
			mConvertedMC = aMC;
		}
		public function getConvertedMC():MovieClip
		{
			return mConvertedMC;
		}
		
		public function setNormalMC(aMC:MovieClip):void
		{
			mNormalMC = aMC;
		}
		public function getNormalMC():MovieClip
		{
			return mNormalMC;
		}
		
		public function setAura(aAura:CAura):void
		{
			mAura = aAura;
			mAura.setAnim(1, 2, 1);
		}
		public function getAura():CAura
		{
			return mAura;
		}
		
		public function setConvertible(aConvertible:CGenericConvertible):void
		{
			mConvertible = aConvertible;
		}
		public function getConvertible():CGenericConvertible
		{
			return mConvertible;
		}
		
		public function setBehaviour(aBehaviour:CGenericBehaviour):void
		{
			mBehaviour = aBehaviour;
		}
		public function getBehaviour():CGenericBehaviour
		{
			return mBehaviour;
		}
		
		public function setWalkingSpeed(aWalkingSpeed:int):void
		{
			mWalkingSpeed = aWalkingSpeed;
		}
		public function getWalkingSpeed():int
		{
			return mWalkingSpeed;
		}
		
		public function setRange(aRange:int):void
		{
			mRange = aRange;
		}
		public function getRange():int
		{
			return mRange;
		}
		
		public function setCloseRange(aCloseRange:int):void
		{
			mCloseRange = aCloseRange;
		}
		public function getCloseRange():int
		{
			return mCloseRange;
		}
		
		public function setAgressive(aAgressive:Boolean):void
		{
			mAgressive = aAgressive;
		}
		public function isAgressive():Boolean
		{
			return mAgressive;
		}
		
		override public function setConverted(aConverted:Boolean):void 
		{
			super.setConverted(aConverted);
			CGraphicsManager.getInstance().getMinions().countConverted();
			
			if (mAura != null)
				mAura.deactivate();
				
			if (aConverted)
			{
				setMC(getConvertedMC());
			}
			else
			{
				setMC(getNormalMC());
			}
			activate();
		}
		
		public function isFollowingPlayer():Boolean
		{
			return getState() == FOLLOW_PLAYER;
		}
		
		public function inArea(aGenericGraphic:CGenericGraphic):Boolean
		{
			return CMath.distanceBetweenPoints3D(getCenter(), aGenericGraphic.getCenter()) < getRange();
		}
		
		public function inCloseRange(aGenericGraphic:CGenericGraphic):Boolean
		{
			var tCircle:CCircle = new CCircle(getCloseRange(), getCenter());
			return CMath.rectCircCollision(tCircle, aGenericGraphic.getRectangle());
		}

		public function command(aTarget:CVector3D):void
		{
			mTarget = aTarget;
			setState(FOLLOW_TARGET);
		}
		
		public function followConvertible(aConvertible:CGenericConvertible):void
		{
			setConvertible(aConvertible);
			setState(FOLLOW_CONVERTIBLE);
		}
		
		public function followPlayer():void
		{
			setState(FOLLOW_PLAYER);
		}
		
		public function setTarget(aTarget:CVector3D):void
		{
			mTarget = aTarget;
		}
		public function getTarget():CVector3D
		{
			return mTarget;
		}

		public function goToConvertible():void
		{
			if (getTimeState() % PATH_UPDATE_TIME == 0)
			{
				mPathFinder.setSpeed(mWalkingSpeed);
				mPathFinder.findPath(mConvertible.getCenter());
			}
			mPathFinder.followPath();
		}
		
		public function goToTarget():void
		{
			if (getTimeState() % PATH_UPDATE_TIME == 0)
			{
				mPathFinder.setSpeed(mWalkingSpeed);
				mPathFinder.findPath(mTarget);
			}
			mPathFinder.followPath();
		}
		
		private function lookForConvertible():Boolean
		{
			var tConvertible:CGenericConvertible;
			// Minion
			tConvertible = CGraphicsManager.getInstance().getMinions().getClosest(this);
			if (tConvertible != null)
			{
				if (inArea(tConvertible))
				{
					setConvertible(tConvertible);
					return true;
				}
			}
			//Building
			tConvertible = CGraphicsManager.getInstance().getBuildings().getClosest(this);
			if (tConvertible != null)
			{
				if (inArea(tConvertible))
				{
					setConvertible(tConvertible);
					return true;
				}
			}
			return false;
		}
		
		private function isTouchingConvertible():Boolean
		{
			var tConvertible:CGenericConvertible;
			// Minion
			tConvertible = CGraphicsManager.getInstance().getMinions().getClosest(this);
			if (tConvertible != null)
			{
				if (inCloseRange(tConvertible))
				{
					setConvertible(tConvertible);
					return true;
				}
			}
			//Building
			tConvertible = CGraphicsManager.getInstance().getBuildings().getClosest(this);
			if (tConvertible != null)
			{
				if (inCloseRange(tConvertible))
				{
					setConvertible(tConvertible);
					return true;
				}
			}
			return false;
		}
		
		private function getDirection():void
		{
			var tPosX:int = Math.floor(getX() / CGame.inst().getMap().getTileWidth());
			var tPosY:int = Math.floor(getY() / CGame.inst().getMap().getTileHeight());
			var tInfluenceMap:CConvertInfluenceMap;
			if (isConverted())
				tInfluenceMap = CVars.inst().getEnemiesInfluenceMap();
			else
				tInfluenceMap = CVars.inst().getMinionsInfluenceMap();
				
			var tMax:int = tInfluenceMap.getValue(tPosX, tPosY);
			for (var i:int = -1; i <= 1; i++)
			{
				for (var j:int = -1; j <= 1; j++)
				{
					if (tInfluenceMap.getValue(tPosX + j, tPosY + i) > tMax)
					{
						tMax = tInfluenceMap.getValue(tPosX + j, tPosY + i);
						mTarget.x = (tPosX + j + 0.5) * CGame.inst().getMap().getTileWidth();
						mTarget.y = (tPosY + i + 0.5) * CGame.inst().getMap().getTileHeight();
					}
				}
			}
		}
		
		// Animation state machine
		private function setAnimState(aState:int):void
		{
			mAnimState = aState;
			if (mAnimState == ANIM_WALKING)
			{
				mAnim.init(mFramesWalking[0], mFramesWalking[1], mAnimDelay);
			}
			else if (mAnimState == ANIM_IDLE)
			{
				mAnim.init(mFramesIdle[0], mFramesIdle[1], mAnimDelay);
			}
			else if (mAnimState == ANIM_CONVERTING)
			{
				mAnim.init(mFramesConverting[0], mFramesConverting[1], mAnimDelay);
			}
		}
		
		override public function setState(aNumber:Number):void 
		{
			super.setState(aNumber);
			if (mAura != null)
				mAura.deactivate();
			switch (getState())
			{
				case IDLE:
					setAnimState(ANIM_IDLE);
					stopMove();
					break;
				case FOLLOW_CONVERTIBLE:
					setAnimState(ANIM_WALKING);
					break;
				case CONVERTING:
					setAnimState(ANIM_CONVERTING);
					var tPos:CVector3D = mConvertible.getCenter();
					mAura.setPos(tPos);
					mAura.activate();
					stopMove();
					break;
				case FOLLOW_PLAYER:
					setAnimState(ANIM_WALKING);
					if (isConverted())
						CVars.inst().getPlayer().addFollower(this);
					break;
				case FOLLOW_TARGET:
					break;
			}
		}
		
		override public function update():void 
		{
			var tConvertible:CGenericConvertible;
			if (getState() == IDLE)
			{
				if ((mAgressive || isConverted()) && isTouchingConvertible())
				{
					setState(CONVERTING);
					return;
				}
				
				if ((mAgressive || isConverted()) && lookForConvertible())
				{
					setState(FOLLOW_CONVERTIBLE);
					return;
				}
				
				if (isConverted() && CVars.inst().getPlayer().inArea(this))
				{
					setState(FOLLOW_PLAYER);
					return;
				}
				
				if (!isConverted())
				{
					if (mAgressive && inArea(CVars.inst().getPlayer()))
					{
						setState(FOLLOW_PLAYER);
					}
					if (getTimeState() > mIdleTime)
					{
						setState(PATROLLING);
						return;
					}
				}
			}
			else if (getState() == FOLLOW_PLAYER)
			{
				var tTarget:CVector3D;
				if (isConverted())
					tTarget = CMath.wander(CVars.inst().getPlayer().getCenter(), getCloseRange() * CVars.inst().getPlayer().getFollowersLength());
				else
					tTarget = CVars.inst().getPlayer().getCenter();
					
				if (getTimeState() % PATH_UPDATE_TIME == 0)
				{
					mPathFinder.setSpeed(getWalkingSpeed());
					mPathFinder.findPath(tTarget);
				}
				
				mPathFinder.followPath();
				if (!mPathFinder.isFollowing())
				{
					setVel(tTarget.substract(getCenter()));
					getVel().normalize();
					getVel().mult(getWalkingSpeed());
				}
				
				if (isConverted())
				{
					if (isBeingConverted())
					{
						if (lookForConvertible())
						{
							setState(FOLLOW_CONVERTIBLE);
							return;
						}
					}
				}
				else
				{
					if (inCloseRange(CVars.inst().getPlayer()))
					{
						stopMove();
						CVars.inst().getPlayer().setLife(CVars.inst().getPlayer().getLife() - getConvertRate());
					}
					if (!inArea(CVars.inst().getPlayer()))
					{
						setState(IDLE);
						return; 
					}
				}
			}
			else if (getState() == FOLLOW_TARGET)
			{
				goToTarget();
				
				if (isTouchingConvertible())
				{
					setState(CONVERTING);
					return;
				}
				
				if (CMath.distanceBetweenPoints3D(getCenter(), mTarget) < getCloseRange())
				{
					setState(IDLE);
					return;
				}
			}
			else if (getState() == FOLLOW_CONVERTIBLE)
			{
				goToConvertible();
				//getDirection();
				//goToTarget();
				
				if (isTouchingConvertible())
				{
					setState(CONVERTING);
					return;
				}
			
				if (getConvertible().isConverted() == isConverted())
				{
					setState(IDLE);
					return;
				}
			}
			else if (getState() == CONVERTING)
			{
				convert(getConvertible());
				if (getConvertible().isConverted() == isConverted())
				{
					mAura.deactivate();
					setState(IDLE);
					return;
				}
			}
			else if (getState() == PATROLLING)
			{
				if (mBehaviour != null)
				{
					mBehaviour.update();
					mTarget = mBehaviour.getTarget();
					setVel(mTarget.substract(getCenter()));
					getVel().normalize();
					getVel().mult(getWalkingSpeed());
				}
				
				if (mAgressive)
				{
					if (lookForConvertible())
					{
						setState(FOLLOW_CONVERTIBLE);
						return;
					}
					if (!isConverted() && inArea(CVars.inst().getPlayer()))
					{
						setState(FOLLOW_PLAYER);
					}
				}
				
				if (getTimeState() > mIdleTime)
				{
					setState(IDLE);
					return;
				}
			}
			
			if (getVelX() > 0)
				setFlipped(false);
			else if (getVelX() < 0)
				setFlipped(true);
			
			//X
			if (isWallRight(getX() + getVelX(), getY()))
			{
				setVelX(0);
				setX(Math.floor((getX() + getRegistryPoint().x + getWidth() - 1) / CGame.inst().getMap().getTileWidth() + 1) * CGame.inst().getMap().getTileWidth() - getWidth() - getRegistryPoint().x);
			}
			if (isWallLeft(getX() + getVelX(), getY()))
			{
				setX(Math.floor((getX() + getRegistryPoint().x) / CGame.inst().getMap().getTileWidth()) * CGame.inst().getMap().getTileWidth() - getRegistryPoint().x);
				setVelX(0);
			}
			//Y
			if (isWallBelow(getX() + getVelX(), getY() + getVelY()))
			{
				setY(Math.floor((getY() + getRegistryPoint().y + getHeight() - 1) / CGame.inst().getMap().getTileHeight() + 1) * CGame.inst().getMap().getTileHeight() - getHeight() - getRegistryPoint().y);
				setVelY(0);
			}
			if (isWallAbove(getX() + getVelX(), getY() + getVelY()))
			{
				setY(Math.floor((getY() + getRegistryPoint().y) / CGame.inst().getMap().getTileHeight()) * CGame.inst().getMap().getTileHeight() - getRegistryPoint().y);
				setVelY(0);
			}
			
			mAnim.update();
			if (mAnimState == ANIM_WALKING)
			{
				if (getVel().norm() == 0)
					setAnimState(ANIM_IDLE);
			}
			else if (mAnimState == ANIM_IDLE)
			{
				if (getVel().norm() > 0)
					setAnimState(ANIM_WALKING);
			}
			super.update();
			mAura.update();
			
			if (CGameConstants.DEBUG)
				mDebugTarget.setXY(mTarget.x, mTarget.y);
		}
		
		override public function render():void 
		{
			if (CGameConstants.DEBUG)
				mDebugTarget.render();
			mAura.render();
		}
		
		override public function destroy():void 
		{
			mAura.destroy();
			super.destroy();
		}
	}

}