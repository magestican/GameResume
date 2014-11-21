package game
{
	import api.ai.behaviour.CMazeMovementBehaviour;
	import api.CAnim;
	import api.CCamera;
	import api.CGame;
	import api.CGenericGraphic;
	import api.CLayer;
	import api.enums.CShapes;
	import api.input.CKeyPoll;
	import api.input.CMouse;
	import api.math.CCircle;
	import api.math.CMath;
	import api.math.CVector3D;
	import api.prefabs.CCirclePref;
	import com.junkbyte.console.Cc;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import game.assets.CAssets;
	import game.constants.CGameConstants;
	import game.convertibles.buildings.CBuilding;
	import game.convertibles.CGenericConvertible;
	import game.convertibles.units.CGenericUnit;
	import game.convertibles.units.CMinion;
	import game.management.CGraphicsManager;
	import api.prefabs.CRect;
	import game.management.Generics.CGenericPlayer;
	import game.states.CLevel01State;
	
	public class CPlayer extends CGenericPlayer
	{
		// STATES
		private const IDLE:uint = 0;
		private const WALKING:uint = 1;
		private const DYING:uint = 2;
		private const CONVERTING:uint = 3;
		
		// ANIM STATES
		private const ANIM_IDLE:uint = 0;
		private const ANIM_WALKING:uint = 1;
		private const ANIM_SENDING:uint = 2;
		private const ANIM_CONVERTING:uint = 3;
		private const ANIM_DYING:uint = 4;
		
		// ANIM FRAMES
		private const ANIM_DELAY:uint = CGameConstants.FPS *0.1;
		private const IDLE_FRAMES:Array = [1, 12];
		private const WALKING_FRAMES:Array = [13, 20];
		private const SENDING_FRAMES:Array = [21, 25];
		private const CONVERTING_FRAMES:Array = [26, 49];
		private const DYING_FRAMES:Array = [54, 74];
		
		private const WIDTH:uint = 46;
		private const HEIGHT:uint = 40;
		private const REGISTRY_X:int = -23;
		private const REGISTRY_Y:int = -40;
		private const WALKING_SPEED:uint = 7;
		
		private var mViewDistance:int = 0;
		private var mFollowers:Vector.<CGenericUnit>;
		private var mLife:int;
		private var mConvertTime:Vector.<int>;
		private var mConverting:Dictionary = new Dictionary();
		private var mConvertAura:CAreaEffect;
		private var mCallAura:CAreaEffect;
		
		private var mAnim:CAnim;
		private var mAnimState:int = 0;
		private var mPreviousAnim:int = 0;

		public function CPlayer(aLayer:CLayer)
		{
			setRegistryPointXY(REGISTRY_X, REGISTRY_Y);
			setWidth(WIDTH);
			setHeight(HEIGHT);
			
			setMC(new CAssets.PLAYER as MovieClip);
			getMC().mouseEnabled = false;
			setLayer(aLayer);
			setShape(CShapes.SQUARE);
			
			mAnim = new CAnim();
			
			setState(IDLE);
			setViewDistance(CStats.getPlayerStats().VIEW_DISTANCE);
			
			setBounds(0, 0, CGame.inst().getMap().getWorldWidth() - getWidth(), CGame.inst().getMap().getWorldHeight() - getHeight());
			setBoundAction(STOP);
			activate();
			setSpeed(WALKING_SPEED);
			
		}
		
		public function reset():void
		{
			mFollowers = new Vector.<CGenericUnit>;
			setLife(CStats.getPlayerStats().MAX_LIFE);
			setState(IDLE);
			setDead(false);
		}
		
		// Getters & Setters
		public function setViewDistance(aViewDistance:int):void
		{
			mViewDistance = aViewDistance;
		}
		
		public function getViewDistance():int
		{
			return mViewDistance;
		}
		
		public function setLife(aLife:int):void
		{
			mLife = aLife;
		}
		
		public function getLife():int
		{
			return mLife;
		}
		
		public function getFollowersLength():int
		{
			return mFollowers.length;
		}
		
		public function inArea(aGenericGraphic:CGenericGraphic):Boolean
		{
			var tCircle:CCircle = new CCircle(getViewDistance(), getCenter());
			return CMath.rectCircCollision(tCircle, aGenericGraphic.getRectangle());
		}
		
		// KEYS
		private function upPressed():Boolean
		{
			return CKeyPoll.pressed(CKeyPoll.KEY_W) || CKeyPoll.pressed(CKeyPoll.UP);
		}
		
		private function downPressed():Boolean
		{
			return CKeyPoll.pressed(CKeyPoll.KEY_S) || CKeyPoll.pressed(CKeyPoll.DOWN);
		}
		
		private function leftPressed():Boolean
		{
			return CKeyPoll.pressed(CKeyPoll.KEY_A) || CKeyPoll.pressed(CKeyPoll.LEFT);
		}
		
		private function rightPressed():Boolean
		{
			return CKeyPoll.pressed(CKeyPoll.KEY_D) || CKeyPoll.pressed(CKeyPoll.RIGHT);
		}
		
		private function convertPressed():Boolean
		{
			return CKeyPoll.pressed(CKeyPoll.SPACE) || CKeyPoll.pressed(CKeyPoll.ENTER);
		}
		
		private function callPressed():Boolean
		{
			return CKeyPoll.pressed(CKeyPoll.CONTROL) || CKeyPoll.pressed(CKeyPoll.SHIFT);
		}
		
		private function sendPressed():Boolean
		{
			return CMouse.firstPress() && !CVars.inst().getHud().mouseOver();
		}
		
		private function getSendTarget():CVector3D
		{
			return new CVector3D(CMouse.getMouseX() + CGame.inst().getCamera().getX(), CMouse.getMouseY() + CGame.inst().getCamera().getY())
		}
		
		public function addFollower(aFollower:CGenericConvertible):void
		{
			mFollowers.push(aFollower);
		}
		
		public function sendFollower(aTarget:CVector3D):void
		{
			if (mFollowers.length > 0)
			{
				setAnimState(ANIM_SENDING);
				mFollowers[0].command(aTarget);
				mFollowers.splice(0, 1);
			}
		}
		
		public function sendFollowerConvertible(aConvertible:CGenericConvertible):void
		{
			if (mFollowers.length > 0)
			{
				setAnimState(ANIM_SENDING);
				mFollowers[0].followConvertible(aConvertible);
				mFollowers.splice(0, 1);
			}
		}
		
		override public function getCenter():CVector3D
		{
			return new CVector3D(getX(), getY() - getHeight() * 0.5);
		}
		
		public function convert():void
		{
			for (var k:Object in mConverting) // Go through dictionary
			{
				if (mConverting[k] >= CGameConstants.CONVERSION_INTERVAL)
				{
					(k as CGenericConvertible).applyConversion(CStats.getPlayerStats().CONVERT_RATE); // Convert
					mConverting[k] = 0;
				}
				else
				{
					mConverting[k]++;
				}
			}
		}
		
		public function isNormalState():Boolean
		{
			return getState() != DYING;
		}
		
		// Animation state machine
		private function setAnimState(aState:int):void
		{
			if (mAnimState != aState)
				mPreviousAnim = mAnimState;
			mAnimState = aState;
			if (mAnimState == ANIM_WALKING)
			{
				mAnim.init(WALKING_FRAMES[0], WALKING_FRAMES[1], ANIM_DELAY);
			}
			else if (mAnimState == ANIM_IDLE)
			{
				mAnim.init(IDLE_FRAMES[0], IDLE_FRAMES[1], ANIM_DELAY);
			}
			else if (mAnimState == ANIM_SENDING)
			{
				mAnim.init(SENDING_FRAMES[0], SENDING_FRAMES[1], ANIM_DELAY);
			}
			else if (mAnimState == ANIM_CONVERTING)
			{
				mAnim.init(CONVERTING_FRAMES[0], CONVERTING_FRAMES[1], ANIM_DELAY);
			}
			else if (mAnimState == ANIM_DYING)
			{
				mAnim.init(DYING_FRAMES[0], DYING_FRAMES[1], ANIM_DELAY);
			}
		}
		
		override public function setState(aState:Number):void
		{
			super.setState(aState);
			if (getState() == IDLE)
			{
				setAnimState(ANIM_IDLE);
				stopMove();
			}
			else if (getState() == WALKING)
			{
				setAnimState(ANIM_WALKING);
			}
			else if (getState() == CONVERTING)
			{
				setAnimState(ANIM_CONVERTING);
				stopMove();
			}
			else if (getState() == DYING)
			{
				setAnimState(ANIM_DYING);
				stopMove();
			}
		}
		
		override public function update():void
		{
			//Temporal variables
			var tUnits:Vector.<CGenericConvertible>;
			var tArea:CCircle;
			
			// Global
			if (isNormalState())
			{
				if (callPressed())
				{
					if (CMouse.pressed())
					{
						if (mCallAura == null)
							mCallAura = new CAreaEffect(getViewDistance());
						var tPos:CVector3D = new CVector3D(CMouse.getMouseX() + CGame.inst().getCamera().getX(), CMouse.getMouseY() + CGame.inst().getCamera().getY());
						mCallAura.setPos(tPos);
						tArea = new CCircle(getViewDistance(), tPos);
						tUnits = CGraphicsManager.getInstance().getMinions().callArea(tArea);
						var tUnit:CGenericUnit;
						for (var i:int = 0; i < tUnits.length; i++)
						{
							tUnit = tUnits[i] as CGenericUnit;
							if (tUnit.getState() != CGenericUnit.FOLLOW_PLAYER)
								tUnit.followPlayer();
						}
					}
					else
					{
						if (mCallAura != null)
						{
							mCallAura.destroy();
							mCallAura = null;
						}
					}
				}
				else if (sendPressed())
				{
					var tMinion:CGenericUnit = CGraphicsManager.getInstance().getMinions().mouseOver() as CGenericUnit;
					if (tMinion != null)
					{
						if (tMinion.isConverted())
							tMinion.followPlayer();
						else
							sendFollowerConvertible(tMinion);
					}
					else
					{
						var tBuilding:CBuilding = CGraphicsManager.getInstance().getBuildings().mouseOver() as CBuilding;
						if (tBuilding != null)
							sendFollowerConvertible(tBuilding);
						else
							sendFollower(getSendTarget());
					}
				}
				else
				{
					if (mCallAura != null)
					{
						mCallAura.destroy();
						mCallAura = null;
					}
				}
				
			}
			
			// Animation state machine
			mAnim.update();
			if (mAnimState == ANIM_SENDING)
			{
				if (mAnim.isEnded())
				{
					setAnimState(mPreviousAnim);
				}
			}
			
			// State machine
			if (getState() == IDLE)
			{
				if (mLife <= 0)
				{
					setState(DYING);
					return;
				}
				if (convertPressed())
				{
					setState(CONVERTING);
				}
				if (upPressed() || downPressed() || leftPressed() || rightPressed())
				{
					setState(WALKING);
					
				}
				return;
			}
			else if (getState() == WALKING)
			{
				if (upPressed() || downPressed() || leftPressed() || rightPressed())
				{
					if (CGame.inst().getCamera().isHandled())
					{
						CGame.inst().getCamera().setStateX(CCamera.KEEPING_UP);
						CGame.inst().getCamera().setStateY(CCamera.KEEPING_UP);
					}
				}
				if (!upPressed() && !downPressed())
					setVelY(0);
				else if (upPressed())
				{
					if (isWallAbove(getX(), getY() - WALKING_SPEED))
					{
						setVelY(0);
						setY(Math.floor((getY() + getRegistryPoint().y) / CGame.inst().getMap().getTileHeight()) * CGame.inst().getMap().getTileHeight() - getRegistryPoint().y);
					}
					else
						setVelY(-WALKING_SPEED);
				}
				else if (downPressed())
				{
					if (isWallBelow(getX(), getY() + WALKING_SPEED))
					{
						setVelY(0);
						setY(Math.floor((getY() + getRegistryPoint().y + getHeight() - 1) / CGame.inst().getMap().getTileHeight() + 1) * CGame.inst().getMap().getTileHeight() - getHeight() - getRegistryPoint().y);
					}
					else
						setVelY(WALKING_SPEED);
				}
				
				if (!leftPressed() && !rightPressed())
					setVelX(0);
				else if (leftPressed())
				{
					setFlipped(true);
					if (isWallLeft(getX() - WALKING_SPEED, getY()))
					{
						setVelX(0);
						setX(Math.floor((getX() + getRegistryPoint().x) / CGame.inst().getMap().getTileWidth()) * CGame.inst().getMap().getTileWidth() - getRegistryPoint().x);
					}
					else
						setVelX(-WALKING_SPEED);
				}
				else if (rightPressed())
				{
					setFlipped(false);
					if (isWallRight(getX() + WALKING_SPEED, getY()))
					{
						setVelX(0);
						setX(Math.floor((getX() + getRegistryPoint().x + getWidth() - 1) / CGame.inst().getMap().getTileWidth() + 1) * CGame.inst().getMap().getTileWidth() - getWidth() - getRegistryPoint().x);
					}
					else
						setVelX(WALKING_SPEED);
				}
				
				if (mLife <= 0)
				{
					setState(DYING);
					return;
				}
				if (convertPressed())
				{
					setState(CONVERTING);
					return;
				}
				if (!upPressed() && !downPressed() && !leftPressed() && !rightPressed())
				{
					setState(IDLE);
					return;
				}
			}
			else if (getState() == CONVERTING)
			{
				//TODO: Run animation
				if (mLife <= 0)
				{
					setState(DYING);
					return;
				}
				
				if (mConvertAura == null)
				{
					mConvertAura = new CAreaEffect(CStats.getPlayerStats().CLOSE_RANGE);
					mConvertAura.setPos(getCenter());
				}
				tArea = new CCircle(CStats.getPlayerStats().CLOSE_RANGE, getCenter());
				// Get units and buildings in the area
				tUnits = CGraphicsManager.getInstance().getMinions().callArea(tArea, false);
				var tBuildings:Vector.<CGenericConvertible> = CGraphicsManager.getInstance().getBuildings().callArea(tArea, false);
				var tConv:CGenericConvertible;
				var tDict:Dictionary = new Dictionary();
				// Put them in a dict with the timer
				for each (tConv in tUnits)
				{
					if (mConverting[tConv] != null)
						tDict[tConv] = mConverting[tConv];
					else
						tDict[tConv] = 0;
				}
				for each (tConv in tBuildings)
				{
					if (mConverting[tConv] != null)
						tDict[tConv] = mConverting[tConv];
					else
						tDict[tConv] = 0;
				}
				// Set the converting dict as the dict created
				mConverting = tDict;
				convert(); // Run convert to all the convertibles in the dict
				
				if (!convertPressed())
				{
					if (mConvertAura != null)
					{
						mConvertAura.destroy();
						mConvertAura = null;
					}
					setState(IDLE);
					return;
				}
			}
			else if (getState() == DYING)
			{
				if (mAnim.isEnded())
				{
					setDead(true);
				}
			}
			
			super.update();
			
			// Cap life
			mLife += CStats.getPlayerStats().CURE_RATE;
			if (mLife > CStats.getPlayerStats().MAX_LIFE)
				mLife = CStats.getPlayerStats().MAX_LIFE;
			if (mLife < 0)
				mLife = 0;
			if (mConvertAura != null)
			{
				mConvertAura.update();
			}
			if (mCallAura != null)
			{
				mCallAura.update();
			}
		}
		
		override public function render():void
		{
			if (isActive())
			{
				if (!isFlipped())
					getMC().scaleX = 1;
				else
					getMC().scaleX = -1;
				getMC().x = getX();
				getMC().y = getY();
			}
			
			if (mConvertAura != null)
			{
				mConvertAura.render();
			}
			if (mCallAura != null)
			{
				mCallAura.render();
			}
			
			getMC().gotoAndStop(mAnim.getCurrentFrame());
		}
	}

}