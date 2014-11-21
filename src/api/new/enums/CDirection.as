package api.enums {
	/**
	 * ...
	 * @author Magestican
	 */
	public class CDirection
	{
		public static const UP:uint = 0;
		public static const DOWN:uint = 1;
		public static const LEFT:uint = 2;
		public static const RIGHT:uint = 3;
		
		
		
		
		public function CDirection() 
		{
			
		}
		
		
		public static function invertDirection (aDirection:int) :int
		{
			if (aDirection == UP)
			{
				return DOWN;
			}
			else if (aDirection == DOWN)
			{
				return UP;
			}
			else if (aDirection == LEFT)
			{
				return RIGHT;
			}
			else if (aDirection == RIGHT)
			{
				return LEFT;
			}
			
			throw RegExp("invalid exception");
		}
	}

}