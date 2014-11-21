package api.tileMap
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CTileSet
	{
		// Constants
		private const MOVIECLIP:uint = 0;
		
		private var mType:int;
		private var mTiles:Class;
		
		public function CTileSet()
		{
		
		}
		
		public function setTileSetMC(aTileSet:Class):void
		{
			mTiles = aTileSet;
			mType = MOVIECLIP;
		}
		
		public function getTileByID(aID:int):DisplayObject
		{
			if (mType == MOVIECLIP)
			{
				var tContainer:MovieClip;
				tContainer = new mTiles as MovieClip;
				tContainer.gotoAndStop(aID);
				
				return tContainer;
			}
			else
				return null;
		}
	}

}