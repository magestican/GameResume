package game.hud 
{
	import api.CGenericGraphic;
	import api.CHelper;
	import api.CLayer;
	import api.enums.CShapes;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class CSkillbar  extends CGenericGraphic
	{
		private var mFollowingMinions:int;
		private var mTotalMinions:int;
		private var btnSkill_1:SimpleButton; 
		private var btnSkill_2:SimpleButton;
		private var btnSkill_3:SimpleButton;
		public function CSkillbar(hud:Sprite) 
		{
			setShape(CShapes.SQUARE);
			setLayer(CLayer.getLayerByName('HUD'));
			var skillbar:MovieClip = hud.getChildByName("skillbar") as MovieClip;
			btnSkill_1 = hud.getChildByName("skill_1") as SimpleButton;
			btnSkill_2 = hud.getChildByName("skill_2") as SimpleButton;
			btnSkill_3 = hud.getChildByName("skill_3") as SimpleButton;
			setMC(skillbar);
			activate();
		}
		
			
		
		
		
		
		override public function update():void
		{
		
		}
		
		override public function render():void
		{
		}
		
		override public function destroy():void
		{
			super.destroy();
			CHelper.removeDisplayObject(getSprite());
			setSprite(null);
		}
		
	}

}