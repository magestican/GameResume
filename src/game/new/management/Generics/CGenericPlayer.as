package game.management.Generics {
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.enums.CMessage;
	/**
	 * ...
	 * @author Magestican
	 */
	public class CGenericPlayer extends CGenericGraphic
	{
		public var mRrespawn:CGameObject = new CGameObject();
		public function CGenericPlayer() 
		{
			setDead(false);
		}
		
		
		override public function destroy():void 
		{
			super.destroy();
		}
		override public function render():void
		{
			super.render();
		}
		override public function update():void
		{
			super.update();
		}
		
		override public function sendMessage(aMessage:Number):void 
		{
			super.sendMessage(aMessage);
		}
		
		
		public function  moveToRespawn():void
		{
			if (mRrespawn.getCircle() != null)
			{
		        setPos(mRrespawn.getCircle().mCenter);
			}
			else if (mRrespawn.getRectangle() != null)
			{
				setX(mRrespawn.getX()  + (mRrespawn.getWidth()  * 0.5))
				setY(mRrespawn.getY()  + (mRrespawn.getHeight()  * 0.5))
			}
			else 
			{
				throw RegExp("You havent set the shape of the respawn!");
			}
		}
		
		
		
		
		override public function manageStates():void
		{
			super.manageStates();
		}
		
	}

}