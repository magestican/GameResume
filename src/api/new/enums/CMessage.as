package api.enums {
	/**
	 * ...
	 * @author Magestican
	 */
	public class CMessage 
	{
		public static const NONE:int = -1;
		public static const ENEMY_DIED:int = 0;
		public static const ENEMY_KILLED:int = 1;
		public static const COLLIDED_WITH_ENEMY:int = 2;
		public static const COLLECTED_RESOURCE:int = 3;
		public static const ABSORBED:int = 4;
		public static const IN_RANGE_OF_ABSORBPTION:int = 5;
		public static const COLLIDED_WITH_BULLET:int = 6;
		public static const COLLIDED_WITH_PLAYER:int = 7;
		public static const COLLECTED_POWERUP:int = 8;
		public static const COLLIDED_WITH_BUILDING:int = 9;
		
		public function CMessage() 
		{
			
		}
		
	}

}