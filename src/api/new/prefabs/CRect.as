package api.prefabs
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class CRect extends MovieClip 
	{
		
		public function CRect(aWidth:int, aHeight:int, aColor:int=0x00FF40) 
		{
			graphics.beginFill(aColor);
			graphics.drawRect(0, 0, aWidth, aHeight);
			graphics.endFill();
		}
		
		public function changeColor(aColor:int):void
		{
			var myColorTransform:ColorTransform = new ColorTransform();
			myColorTransform.color = aColor;
			transform.colorTransform = myColorTransform;
		}
	}

}