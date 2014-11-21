package game.convertibles.buildings 
{
	import api.CGame;
	import api.CLayer;
	import api.enums.CShapes;
	import api.math.CMath;
	import api.prefabs.CRect;
	import game.constants.CGameConstants;
	/**
	 * ...
	 * @author 
	 */
	public class CChurch extends CBuilding 
	{
		
		public function CChurch(aLayer:CLayer) 
		{
			//setMC(new CRect(getWidth(), getHeight(), 0xEC2813));
			setMaxConversion(500);
			setCureRate(5);
			setLayer(aLayer);
			activate();
		}
		
		override public function setConversion(aConversion:int):void 
		{
			super.setConversion(aConversion);
		}
		
		override public function update():void 
		{
			//getMC().changeColor(CMath.RGB(getConversion(), 0, 0));
			super.update();
		}
		
		override public function render():void 
		{
			//getMC().x = getX();
			//getMC().y = getY();
		}
	}

}