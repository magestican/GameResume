package api.prefabs 
{
	import api.math.CVector2D;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CLine extends Shape 
	{
		private var mWidth:Number;
		private var mColor:int;
		
		public function CLine(aWidth:Number, aColor:int) 
		{
			mWidth = aWidth;
			mColor = aColor;
		}
		
		public function clear():void
		{
			graphics.clear();
		}
		
		public function drawLine(aBegin:CVector2D, aEnd:CVector2D):void
		{
			graphics.clear();
			graphics.lineStyle(mWidth, mColor, 2);
			graphics.moveTo(aBegin.x, aBegin.y);
			graphics.lineTo(aEnd.x, aEnd.y);
		}
	}

}