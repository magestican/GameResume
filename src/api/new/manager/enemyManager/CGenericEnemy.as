package api.manager.enemyManager 
{
	import api.CGameObject;
	
	public class CGenericEnemy extends CGameObject 
	{
		public function CGenericEnemy() 
		{
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function render():void
		{
			super.render();
		}
		
		override public function destroy():void
		{
			super.destroy();
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