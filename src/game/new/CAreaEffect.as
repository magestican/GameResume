package game 
{
	import api.CGenericGraphic;
	import api.CHelper;
	import api.CLayer;
	import api.enums.CShapes;
	import api.prefabs.CCirclePref;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CAreaEffect extends CGenericGraphic 
	{
		private var mMC:CCirclePref;
		
		public function CAreaEffect(aRadious:int) 
		{
			setShape(CShapes.CIRCLE);
			setRadious(aRadious);
			setLayer(CLayer.getLayerByName('areas'));
			
			mMC = new CCirclePref(0x0000FF, getRadious());
			mMC.alpha = 0.5;
			activate();
		}
		
		override public function activate():void 
		{
			setActive(true);
			if (!getLayer().contains(mMC))
				getLayer().addChild(mMC);
		}
		
		override public function deactivate():void 
		{
			setActive(false);
			if (getLayer().contains(mMC))
				CHelper.removeDisplayObject(mMC);
		}
		
		override public function render():void 
		{
			mMC.x = getX();
			mMC.y = getY();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			CHelper.removeDisplayObject(mMC);
			mMC = null;
		}
	}

}