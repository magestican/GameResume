package game.hud
{
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.CHelper;
	import api.CLayer;
	import api.enums.CShapes;
	import api.math.CMath;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.CVars;
	import game.management.CGraphicsManager;
	
	public class CMinionsCounter extends CGenericGraphic
	{
		private var mFollowingMinions:int;
		private var mTotalMinions:int;
		
		private var txtCounter:TextField;
		
		public function CMinionsCounter(hud:Sprite)
		{
			setShape(CShapes.SQUARE);
			setLayer(CLayer.getLayerByName('HUD'));
			
			var minionCounter:MovieClip = hud.getChildByName("minion_counter") as MovieClip;
			txtCounter = minionCounter.getChildByName("counter") as TextField;
			
			setMC(minionCounter);
			activate();
		}
		
		override public function update():void
		{
			mFollowingMinions = CVars.inst().getFollowersAmount();
			mTotalMinions = CGraphicsManager.getInstance().getMinions().getConvertedLength();
		}
		
		override public function render():void
		{
			txtCounter.text = CMath.addZeros(mFollowingMinions, 3);
			txtCounter.appendText("/" + CMath.addZeros(mTotalMinions, 3));
		}
		
		override public function destroy():void
		{
			super.destroy();
			CHelper.removeDisplayObject(getSprite());
			setSprite(null);
		}
	}

}