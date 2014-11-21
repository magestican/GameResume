package game.states
{
	import api.CGameState;
	import api.CLayer;
	import api.math.CMath;
	import game.convertibles.buildings.CHouse;
	import api.math.CVector3D;
	import game.CPlayer;
	import game.management.CGraphicsManager;
	
	public class CTestChamber extends CGameState
	{
		public function CTestChamber()
		{
		
		}
		
		override public function init():void
		{
			var ipPosition:CVector3D = new CVector3D(7, 7);
			var ipInfluence:int = 5;
			var ipMagnitude:int = 30;
			var npcPosition:CVector3D = new CVector3D(8, 7);
			var tileSize:int = 20;
			
			var lambda:Number = CMath.clampRad(ipPosition.getAngle(npcPosition));
			
			var trueTileDistance:Number = tileSize / Math.cos(lambda);
			
			var influence:Number = ipMagnitude / (Math.round(CMath.distanceBetweenPoints3D(ipPosition, npcPosition) / trueTileDistance));
		}
		
		override public function update():void
		{
		}
		
		override public function render():void
		{
		}
	}

}