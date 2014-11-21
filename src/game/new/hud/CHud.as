package game.hud 
{
	import api.CLayer;
	import api.CMinimap;
	import flash.display.Sprite;
	import game.assets.CAssets;
	import game.constants.CGameConstants;
	import game.CVars;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CHud 
	{
		// Constants
		private const MINIMAP_WIDTH:int = 250;
		private const MINIMAP_X:int = 700;
		private const MINIMAP_Y:int = 400;
		
		private var mMinionsCounter:CMinionsCounter;
		private var mMinimap:CMinimap;
		private var mSkillbar:CSkillbar;
		
		public function CHud() 
		{
			CLayer.addLayer('HUD', true);
			var hud:Sprite = new CAssets.HUD as Sprite;
			
			mMinionsCounter = new CMinionsCounter(hud);
			
			mMinimap = new CMinimap(MINIMAP_WIDTH, CLayer.getLayerByName('HUD'));
			mMinimap.setXY(MINIMAP_X, MINIMAP_Y);
			CVars.inst().setMinimap(mMinimap);
			
			mSkillbar = new CSkillbar(hud);
		}
		
		public function mouseOver():Boolean
		{
			return mMinimap.mouseOver();
		}
		
		public function update():void
		{
			mMinionsCounter.update();
			mMinimap.update();
		}
		
		public function render():void
		{
			mMinionsCounter.render();
			mMinimap.render();
		}
		
		public function destroy():void
		{
			mMinionsCounter.destroy();
		}
	}

}