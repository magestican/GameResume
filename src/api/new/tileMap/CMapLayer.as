package api.tileMap 
{
	import adobe.utils.CustomActions;
	import api.CGame;
	import api.CLayer;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CMapLayer 
	{
		private var mName:String;
		private var mMap:Vector.<Vector.<int>> = new Vector.<Vector.<int>>;
		private var mTileMap:Vector.<Vector.<CTile>> = new Vector.<Vector.<CTile>>();
		private var mLayer:CLayer;
		
		public function CMapLayer(aName:String) 
		{
			mName = aName;
		}
		
		public function getName():String
		{
			return mName;
		}
		
		public function setMap(aMap:Vector.<Vector.<int>> ):void
		{
			mMap = aMap;
		}
		
		public function getMap():Vector.<Vector.<int>>
		{
			return mMap;
		}
		
		public function resetTileMap(aTileMap:Vector.<Vector.<int>>):void
		{
			if (aTileMap.length == mTileMap.length)
			{
				for (var i:int = 0; i < mTileMap.length; i++)
				{
					if (aTileMap[i].length == mTileMap[i].length)
					{
						for (var j:int = 0; j < mTileMap[i].length; j++)
						{
							if (mTileMap[i][j].isEmpty() && aTileMap[i][j] != 0)
							{
								var tTile:CTile = new CTile(mTileMap[i][j].getX(), mTileMap[i][j].getY(), mTileMap[i][j].getWidth(), mTileMap[i][j].getHeight(), mLayer);
								tTile.setTileIndex(aTileMap[i][j]);
								mTileMap[i][j] = tTile;
							}
							else if (!mTileMap[i][j].isEmpty() && aTileMap[i][j] == 0)
							{
								mTileMap[i][j].destroy();
								mTileMap[i][j] = CGame.inst().getMap().getEmptyTile()
							}
							else
								mTileMap[i][j].setTileIndex(aTileMap[i][j]);
						}
					}
					else
						throw RegExp('resetTileMap(): The tilemap inserted has different dimentions than the already stated');
				}
			}
			else
				throw RegExp('resetTileMap(): The tilemap inserted has different dimentions than the already stated');
		}
		public function setTileMap(aTileMap:Vector.<Vector.<CTile>> ):void
		{
			mTileMap = aTileMap;
		}
		public function getTileMap():Vector.<Vector.<CTile>> 
		{
			return mTileMap;
		}
		
		public function setLayer(aLayer:CLayer):void
		{
			mLayer = aLayer;
		}
		
		public function getLayer():CLayer
		{
			return mLayer;
		}
		
		public function getTile(x:uint, y:uint):CTile
		{
			if (x < 0 || y < 0 || x >= mTileMap[0].length || y >= mTileMap.length)
			{
				//trace("Coordenadas fuera de rango: x=" + x + " y=" + y);
				return CGame.inst().getMap().getEmptyTile();
			}
			else
			{
				return mTileMap[y][x];
			}
		}
		
		public function getTileIndex(x:uint, y:uint):uint
		{
			if (x < 0 || y < 0 || x >= mMap[0].length || y >= mMap.length)
			{
				return 0;
			}
			else
			{
				return mMap[y][x];
			}
		}
		
		public function update():void
		{
			for (var i:uint = 0; i < mTileMap.length; i++)
			{
				for (var j:uint = 0; j < mTileMap[i].length; j++)
				{
					mTileMap[i][j].update();
				}
			}
		}
		
		public function render():void
		{
			/*for (var i:uint = 0; i < mTileMap.length; i++)
			{
				for (var j:uint = 0; j < mTileMap[i].length; j++)
				{
					mTileMap[i][j].render();
				}
			}*/
		}
		
		public function destroy():void
		{
			for (var i:uint = mTileMap.length - 1; i >= 0; i--)
			{
				for (var j:uint = mTileMap[i].length - 1; j >= 0; j--)
				{
					mTileMap[i][j].destroy();
					mTileMap[i][j] = null;
				}
			}
			mName = null;
			mMap = null;
			mTileMap = null;
			mLayer = null;
		}
	}

}