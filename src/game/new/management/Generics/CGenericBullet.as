package game.management.Generics {
	/**
	 * ...
	 * @author
	 */
	import api.CGameObject
	
	public class CGenericBullet extends CGameObject
	{
		
		public function CGenericBullet()
		{
			mDead = false;
			mRedirect = false;
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		override public function render():void
		{
			super.render();
		}
		override public function update():void
		{
			super.update();
		}
	}

}