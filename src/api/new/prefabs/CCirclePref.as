package api.prefabs 
{
	import flash.display.MovieClip;
	
	public class CCirclePref extends MovieClip 
	{
		public function CCirclePref(aColor:int, aRadius:int) 
		{
			graphics.beginFill(aColor);
			graphics.drawCircle(0, 0, aRadius);
			graphics.endFill();
		}
	}
}