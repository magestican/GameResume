package game.constants 
{
	/**
	 * ...
	 * @author 
	 */
	public class CGameConstants 
	{
		
		public var scale:int = 0.5;
		public static const DEBUG:Boolean = true;
		public static const FPS:int = 30;
		public static const STAGE_WIDTH:uint = 960;
		public static const STAGE_HEIGHT:uint = 540;
		public static const TILE_WIDTH:uint = 64;
		public static const TILE_HEIGHT:uint = 64;
		public static const CONVERSION_INTERVAL:int = CGameConstants.FPS * 0.3;
		
		// Positions of HUD
		// Minions Counter
		public static const MINIONS_COUNTER_X:int = 10;
		public static const MINIONS_COUNTER_Y:int = STAGE_HEIGHT - 100;
		
		public function CGameConstants() 
		{
			
		}
		
	}

}