package api.ai
{
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CInfluenceMap 
	{
		private var mMap:Vector.<Vector.<int>>;
		private var mStaticMap:Vector.<Vector.<int>>;
		private var mWidth:int = 0;
		private var mHeight:int = 0;
		
		public function CInfluenceMap(aWidth:int, aHeight:int) 
		{
			mWidth = aWidth;
			mHeight = aHeight;
			
			mMap = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < mHeight; i++)
			{
				var tRow:Vector.<int> = new Vector.<int>();
				for (var j:int = 0; j < mWidth; j++)
				{
					tRow.push(0);
				}
				mMap.push(tRow);
			}
		}
		
		public function setStaticMap(aStaticMap:Vector.<Vector.<int>>):void
		{
			mStaticMap = aStaticMap;
			mMap = mStaticMap;
		}
		
		public function getMap():Vector.<Vector.<int>>
		{
			return mMap;
		}
		public function setMap(aMap:Vector.<Vector.<int>>):void
		{
			mMap = aMap;
		}
		
		public function getValue(aX:int, aY:int):int
		{
			if (aX < 0 || aY < 0 || aX >= mWidth || aY >= mHeight)
				return -9999;
			else
				return mMap[aY][aX];
		}
		
		public function addValue(aCol:int, aRow:int, aValue:int):void
		{
			if (aRow >= 0 && aRow < mHeight && aCol >= 0 && aCol < mWidth)
			{
				mMap[aRow][aCol] = aValue;
				
				const tStartX:int = Math.max(0, aCol - Math.sqrt(aValue - 0.5));
				const tEndX:int = Math.min(mMap[0].length, aCol + Math.sqrt(aValue - 0.5));
				const tStartY:int = Math.max(0, aRow - Math.sqrt(aValue - 0.5));
				const tEndY:int = Math.min(mMap.length, aRow + Math.sqrt(aValue - 0.5));
				
				for (var i:int = tStartY; i < tEndY; i++)
				{
					for (var j:int = tStartX; j < tEndX; j++)
					{
						var d:Number = (i - aRow) * (i - aRow) + (j - aCol) * (j - aCol);
						var tNewValue:int;
						if (d > 0)
							tNewValue = Math.floor(aValue / (d + 0.5));
						else
							tNewValue = aValue;
						if (mMap[i][j] < tNewValue && mStaticMap[i][j] == 0)
							mMap[i][j] = tNewValue;
					}
				}
			}
		}
		
		public function addStatic(aCol:int, aRow:int, aValue:int):void
		{
			mMap[aRow][aCol] = aValue;
		}
		
		public function update():void
		{
			
		}
	}

}