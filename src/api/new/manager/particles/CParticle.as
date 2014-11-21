package api.manager.particles 
{
	import api.CGame;
	import api.CGameObject;
	import api.CHelper;
	import api.CLayer;
	import api.math.CMath;
	import api.prefabs.CRect;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CParticle extends CGameObject 
	{
		//States
		private const NORMAL:uint = 0;
		private const DYING:uint = 1;
		
		private var mState:int;
		private var mTimeState:int = 0;
		
		private const GRAVITY:uint = 1;
		private var mMC:CRect;
		private var mTimeToLive:int;
		private var mAlpha:Number = 1;
		
		public function CParticle(aColor:int, aLayer:CLayer, aMinTime:int, aMaxTime:int) 
		{
			mMC = new CRect(4, 4, aColor);
			mMC.mouseEnabled = false;
			aLayer.addChild(mMC);
			mTimeToLive = CMath.randInt(aMinTime, aMaxTime);
			setVelX(CMath.randInt(5, 10));
			getVel().setAngle(CMath.deg2rad(CMath.randInt(0, 359)));
			setVelZ(CMath.randInt(0, 10));
			setAccelZ( -GRAVITY);
			setBounds( -CMath.INFINITY, -CMath.INFINITY, CMath.INFINITY, CMath.INFINITY, 0, CMath.INFINITY);
			setBoundAction(CGameObject.STOP);
			setState(DYING);
		}
		
		private function setState(aState:int):void
		{
			mTimeState = 0;
			mState = aState;
		}
		
		override public function update():void 
		{
			super.update();
			if (mState == NORMAL)
			{
				if (mTimeState > mTimeToLive)
				{
					setState(DYING);
					return;
				}
			}
			else if (mState == DYING)
			{
				mAlpha -= 1 / mTimeToLive;
				if (mAlpha <= 0)
					setDead(true);
			}
			mTimeState++;
		}
		
		override public function render():void 
		{
			mMC.x = getX() - CGame.inst().getCamera().getX();
			mMC.y = getY() - getZ() - CGame.inst().getCamera().getY();
			mMC.alpha = mAlpha;
		}
		
		override public function destroy():void 
		{
			CHelper.removeDisplayObject(mMC);
			mMC = null;
		}
	}

}