package api.debug 
{
	import flash.text.TextField;
	/**
	 * ...
	 * @author ...
	 */
	public class CDebugData extends CGameObject 
	{
		private var mObject:CGameObject;
		private var mDataX:TextField;
		private var mDataY:TextField;
		
		public function CDebugData(aObject:CGameObject) 
		{
			mObject = aObject;
			
            mDataX = new TextField();
			mDataX.width = 300;
            CGame.inst().getContainer().addChild(mDataX);
			
            mDataY = new TextField();
			mDataY.width = 300;
            CGame.inst().getContainer().addChild(mDataY);
			
			setXYZ(0, 0);
		}
		
		override public function update():void 
		{
			mDataX.text = 'X: ' + mObject.getX().toString() + ' velX: ' + mObject.getVelX().toString() + ' accelX: ' + mObject.getAccelX().toString();
			mDataY.text = 'Y: ' + mObject.getY().toString() + ' velY: ' + mObject.getVelY().toString() + ' accelY: ' + mObject.getAccelY().toString();
		}
		
		override public function render():void 
		{
			mDataX.x = getX();
			mDataX.y = getY();
			mDataY.x = getX();
			mDataY.y = getY() + 20;
		}
	}

}