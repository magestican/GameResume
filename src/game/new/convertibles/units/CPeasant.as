package game.convertibles.units
{
	import api.ai.behaviour.CWanderBehaviour;
	import api.CGenericGraphic;
	import api.CLayer;
	import api.enums.CShapes;
	import api.math.CMath;
	import api.math.CVector2D;
	import api.math.CVector3D;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import game.assets.CAssets;
	import game.management.CGraphicsManager;
	
	public class CPeasant extends CGenericGraphic
	{
		
		public function CPeasant(aPos:CVector3D, aLayer:CLayer)
		{
			
			setPos(aPos);
			setLayer(aLayer);
			
			var tMC:MovieClip = new MovieClip();
			var tSp:Sprite = new CAssets.Peasant1 as Sprite;
			tMC.addChild(tSp);
			setMC(tMC);
			activate();
			
			setShape(CShapes.SQUARE);
			setHeight(40);
			setWidth(20);
			
			getMC().x = aPos.x;
			getMC().y = aPos.y;
			
			addBehaviour( new CWanderBehaviour(this));
		}
		
		override public function render():void 
		{
			
		}
		
		override public function update():void 
		{
			for (var i:int = 0; i < getBehaviours().length; i++ ) {
				getBehaviours()[0].update();
			}
		}
	
	}

}