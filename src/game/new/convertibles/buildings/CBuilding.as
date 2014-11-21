package game.convertibles.buildings 
{
	import api.CGame;
	import api.CLayer;
	import api.enums.CShapes;
	import api.prefabs.CRect;
	import api.tileMap.CTile;
	import game.constants.CGameConstants;
	import game.convertibles.CGenericConvertible;
	import game.CVars;
	/**
	 * ...
	 * @author 
	 */
	public class CBuilding extends CGenericConvertible
	{
		private var mConstruct:CBuildingConstruct;
		private var mConvertedTile:CTile = null;
		
		public function CBuilding() 
		{
			setWidth(CGameConstants.TILE_WIDTH);
			setHeight(CGameConstants.TILE_HEIGHT);
			setShape(CShapes.SQUARE);
			var tRatio:Number = CVars.inst().getMinimap().getRatio();
			setMinimapToken(new CRect(getWidth() * tRatio + 1, getHeight() * tRatio + 1, 0x0080C0));
		}
		
		public function setConstruct(aConstruct:CBuildingConstruct):void
		{
			mConstruct = aConstruct;
		}
		public function getConstruct():CBuildingConstruct
		{
			return mConstruct;
		}
		
		public function setConvertedTile(aTile:CTile):void
		{
			if (aTile != CGame.inst().getMap().getEmptyTile())
			{
				mConvertedTile = aTile;
				mConvertedTile.getMC().alpha = 0;
			}
		}
		public function getConvertedTile():CTile
		{
			return mConvertedTile;
		}
		
		override public function applyConversion(aConvertRate:int):void 
		{
			mConstruct.convertBuilding(aConvertRate);
		}
		
		override public function setConverted(aConverted:Boolean):void 
		{
			super.setConverted(aConverted);
			getConstruct().setConverted(aConverted);
		}
		
		override public function update():void 
		{
			super.update();
			//trace(getConversion(), getMaxConversion());
			if (getConvertedTile() != null)
				getConvertedTile().getMC().alpha = getConversion() / getMaxConversion();
		}
	}

}