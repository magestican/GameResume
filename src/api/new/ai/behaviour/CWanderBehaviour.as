package api.ai.behaviour 
{
	import api.CGame;
	import api.CGameObject;
	import api.math.CMath;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CWanderBehaviour extends CGenericBehaviour 
	{
		private var mObject:CGameObject;
		private var mTime:int = 0;
		
		public function CWanderBehaviour(aGameObject:CGameObject) 
		{
			mObject = aGameObject;
			setTarget(CMath.wander(mObject.getCenter(), 180));
			if (getTarget().x < 0)
				setTargetX(0);
			else if (getTarget().x >= CGame.inst().getMap().getWorldWidth())
				setTargetX(CGame.inst().getMap().getWorldWidth() - 1);
			if (getTarget().y < 0)
				setTargetY(0);
			else if (getTarget().y >= CGame.inst().getMap().getWorldHeight())
				setTargetY(CGame.inst().getMap().getWorldHeight() - 1);
		}
		
		override public function update():void 
		{
			if (mTime > 10)
			{
				mTime = 0;
				setTarget(CMath.wander(getTarget(), 50));
			}
			mTime++;
		}
	}

}