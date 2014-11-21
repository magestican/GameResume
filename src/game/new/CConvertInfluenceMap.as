package game 
{
	import api.ai.CInfluenceMap;
	import api.CGame;
	import game.constants.CGameConstants;
	import game.convertibles.CGenericConvertible;
	import game.management.CGraphicsManager;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CConvertInfluenceMap extends CInfluenceMap 
	{
		private var mAllies:Boolean; // true: Only use allies | false: Only use enemies
		
		public function CConvertInfluenceMap(aAllies:Boolean=true) 
		{
			super(CGame.inst().getMap().getMapWidth(), CGame.inst().getMap().getMapHeight());
			mAllies = aAllies;
		}
		
		override public function update():void
		{
			var tConvertible:CGenericConvertible;
			
			for (var i:int = 0; i < CGraphicsManager.getInstance().getMinions().getLength(); i++)
			{
				tConvertible =  CGraphicsManager.getInstance().getMinions().getConvertible(i);
				if (tConvertible.isConverted() == mAllies)
					addValue(Math.floor(tConvertible.getX() / CGameConstants.TILE_WIDTH), Math.floor(tConvertible.getY() / CGameConstants.TILE_HEIGHT), tConvertible.getMaxConversion());
			}
			for (i = 0; i < CGraphicsManager.getInstance().getBuildings().getLength(); i++)
			{
				tConvertible =  CGraphicsManager.getInstance().getBuildings().getConvertible(i);
				if (tConvertible.isConverted() == mAllies)
					addValue(Math.floor(tConvertible.getX() / CGameConstants.TILE_WIDTH), Math.floor(tConvertible.getY() / CGameConstants.TILE_HEIGHT), tConvertible.getMaxConversion());
			}
		}
	}

}