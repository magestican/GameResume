package api.ai.behaviour 
{
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.extensions.CVector2dExt;
	import api.math.CVector3D;
	import api.tileMap.CTile;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author magestican
	 */
	public class CGenericBehaviour 
	{
		internal var mWalkingPath:Vector.<int> = new Vector.<int> ();
		internal var mWalkingPathIndex:int = 0;
		private var mTarget:CVector3D;
		
		public function CGenericBehaviour() 
		{
			
		}
		
		public function setTarget(aTarget:CVector3D):void
		{
			mTarget = aTarget;
		}
		public function getTarget():CVector3D
		{
			return mTarget;
		}
		
		public function setTargetX(aX:int):void
		{
			mTarget.x = aX;
		}
		public function setTargetY(aY:int):void
		{
			mTarget.y = aY;
		}
		
		public function update():void 
		{
		}
		
		public function render(graphic:CGenericGraphic):void 
		{
		}
		
		 public function destroy():void 
		{
		}
	}

}