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
	public class CHouse extends CBuilding 
	{
		private const MAX_CONVERSION:int = 10;
		private const CURE_RATE:int = 1;
		
		public function CHouse(aLayer:CLayer) 
		{
			//setMC(new CRect(getWidth(), getHeight(), 0x000000));
			setMaxConversion(MAX_CONVERSION);
			setCureRate(CURE_RATE);
			setLayer(aLayer);
			activate();
		}
		
		override public function setConversion(aConversion:int):void 
		{
			super.setConversion(aConversion);
		}
		
		override public function update():void 
		{
			//getMC().changeColor(CMath.RGB(getConversion() / getMaxConversion() * 255, 0, 0));
			super.update();
		}
		
		override public function render():void 
		{
			//if (isActive())
			//{
				//getMC().x = getX();
				//getMC().y = getY();
				//getMC().alpha = 0.5;
			//}
		}
	}

}