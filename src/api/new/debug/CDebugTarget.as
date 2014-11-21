package api.debug 
{
	import api.CGame;
	import api.CGameObject;
	import api.CLayer;
	import api.math.CCircle;
	import api.math.CVector3D;
	import api.prefabs.CCirclePref;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CDebugTarget extends CGameObject 
	{
		
		public function CDebugTarget() 
		{
			setMC(new CCirclePref(0xFF0000, 5));
			CGame.inst().getContainer().addChild(getMC());
		}
		
		override public function render():void 
		{
			getMC().x = getX() - CGame.inst().getCamera().getX();
			getMC().y = getY() - CGame.inst().getCamera().getY();
		}
	}

}