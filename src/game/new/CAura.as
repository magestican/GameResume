package game 
{
	import api.CAnim;
	import api.CGenericGraphic;
	import api.CHelper;
	import api.CLayer;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CAura extends CGenericGraphic 
	{
		private var mAnim:CAnim;
		
		public function CAura(aMC:MovieClip) 
		{
			setLayer(CLayer.getLayerByName('auras'));
			setMC(aMC);
			mAnim = new CAnim();
		}
		
		public function setAnim(aStart:int, aEnd:int, aDelay:int):void
		{
			mAnim.init(aStart, aEnd, aDelay);
		}
		
		override public function update():void 
		{
			mAnim.update();
		}
		
		override public function render():void 
		{
			getMC().x = getX();
			getMC().y = getY();
			getMC().gotoAndStop(mAnim.getCurrentFrame());
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
	}

}