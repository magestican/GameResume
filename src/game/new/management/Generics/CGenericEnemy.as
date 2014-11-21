 package game.management.Generics {
	import api.CGameObject;
	/**
	 * ...
	 * @author Magestican
	 */
	public class CGenericEnemy extends CGameObject
	{
		
		public function CGenericEnemy() 
		{
			mDead = false;
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
		
		
		public function hit2():void
		{
		}
		
		public function hit():void
		{
			//trace("le pegan al enemigo");
			// TODO: Cambiar de estado a la bala para que haga algo.
			//setDead(true);
		}
		
		
	}

}