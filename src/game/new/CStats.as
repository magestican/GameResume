package game
{
	import game.constants.CGameConstants;
	
	public class CStats
	{
		private static var mMinion:CStats;
		private static var mPriest:CStats;
		private static var mPeasant:CStats;
		private static var mPlayer:CStats;
		
		public var MAX_CONVERSION:int = 0;
		public var CURE_RATE:int = 0;
		public var IDLE_TIME:int = 0;
		public var CLOSE_RANGE:uint = 0;
		public var RANGE:uint = 0;
		public var CONVERT_RATE:uint = 0;
		public var OUTER_RING:uint = 0;
		public var INNER_RING:uint = 0;
		public var MAX_LIFE:uint = 0;
		public var VIEW_DISTANCE:uint = 0;
		
		public function CStats(aRange:uint, aConvertRate:uint, aMaxConversion:uint, aCureRate:uint= 0, aIdleTime:uint= 0, aCloseRange:uint= 0, aOuterRing:uint= 0, aInnerRing:uint= 0, aMaxLife:uint = 0, aViewDistance:uint = 0)
		{
			RANGE = aRange;
			CONVERT_RATE = aConvertRate;
			MAX_CONVERSION = aMaxConversion;
			CURE_RATE = aCureRate;
			IDLE_TIME = CGameConstants.FPS * aIdleTime;
			CLOSE_RANGE = aCloseRange;
			OUTER_RING = aOuterRing;
			INNER_RING = aInnerRing;
			MAX_LIFE = aMaxLife;
			VIEW_DISTANCE = aViewDistance;
		}
		
		
		//aRange, aConvertRate, aMaxConversion, aCureRate , aIdleTime , aCloseRange , aOuterRing , aInnerRing, aMaxLife, aViewDistance
		public static function getMinionStats():CStats
		{
			if (mMinion != null)
				return mMinion;
			else
				return mMinion = new CStats(200, 40, 50, 0, 0, 50, 200, 100);
		}
		//aRange, aConvertRate, aMaxConversion, aCureRate , aIdleTime , aCloseRange , aOuterRing , aInnerRing, aMaxLife, aViewDistance
		public static function getPriestStats():CStats
		{
			if (mPriest != null)
				return mPriest;
			else
				return mPriest = new CStats(300, 50, 1000, 20, 3, 100, 200, 100);
		}
		//aRange, aConvertRate, aMaxConversion, aCureRate , aIdleTime , aCloseRange , aOuterRing , aInnerRing, aMaxLife, aViewDistance
		public static function getPeasantStats():CStats
		{
			if (mPeasant != null)
				return mPeasant;
			else
				return mPeasant = new CStats(200, 40, 50);
		}
		//aRange, aConvertRate, aMaxConversion, aCureRate , aIdleTime , aCloseRange , aOuterRing , aInnerRing, aMaxLife, aViewDistance
		public static function getPlayerStats():CStats
		{
			if (mPlayer != null)
				return mPlayer;
			else
				return mPlayer = new CStats(0,50,0,20,0,50,0,0,100,100)
		}
	}

}