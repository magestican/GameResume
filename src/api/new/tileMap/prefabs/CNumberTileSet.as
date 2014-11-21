package api.tileMap.prefabs 
{
	import api.math.CMath;
	import api.prefabs.CRect;
	import api.tileMap.CTileSet;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CNumberTileSet extends CTileSet 
	{
		
		public function CNumberTileSet() 
		{
		}
		
		override public function getTileByID(aID:int):DisplayObject 
		{
			var tRect:CRect = new CRect(32, 32, CMath.RGB(aID, aID, aID));
			tRect.alpha = 0.5;
			var tText:TextField = new TextField();
			var tContainer:Sprite;
			
			tText.text = aID.toString();
			tText.textColor = 0xFF0000;
			tText.x = 7;
			tText.y = 10;
			
			tContainer = new Sprite();
			tContainer.addChild(tRect);
			tContainer.addChild(tText);
			return tContainer;
		}
	}

}