package game.convertibles.buildings 
{
	import api.CGame;
	import api.CLayer;
	import api.tileMap.CMapLayer;
	import game.constants.CGameConstants;
	import game.constants.CMapConstants;
	import game.management.CGraphicsManager;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CBuildingsMap 
	{
		private var mMap:Vector.<Vector.<CBuilding>>;
		private var mIdMap:Vector.<Vector.<int>>;
		
		public function CBuildingsMap(aMap:Vector.<Vector.<int>>) 
		{
			mMap = new Vector.<Vector.<CBuilding>>;
			setBuildings(aMap);
		}
		
		public function setBuildings(aMap:Vector.<Vector.<int>>):void
		{
			mIdMap = aMap;
			var tObjectsLayer:CLayer = CLayer.getLayerByName('objects');
			var tHouse:CHouse;
			var tChurch:CChurch;
			var tConvertedMap:CMapLayer = CGame.inst().getMap().getLayerByName(CMapConstants.CONVERTED);
			for (var i:int = 0; i < aMap.length; i++)
			{
				var tRow:Vector.<CBuilding> = new Vector.<CBuilding>;
				for (var j:int = 0; j < aMap[i].length; j++)
				{
					if (mIdMap[i][j] == CMapConstants.HOUSE || mIdMap[i][j] == CMapConstants.HOUSE_DOOR)
					{
						tHouse = new CHouse(tObjectsLayer);
						tHouse.setX((j + 0.5) * CGameConstants.TILE_WIDTH - tHouse.getWidth() * 0.5);
						tHouse.setY((i + 0.5) * CGameConstants.TILE_HEIGHT - tHouse.getHeight() * 0.5);
						tHouse.setConvertedTile(tConvertedMap.getTile(j, i));
						CGraphicsManager.getInstance().addBuilding(tHouse);
						tRow.push(tHouse);
					}
					else if (mIdMap[i][j] == CMapConstants.CHURCH)
					{
						tChurch = new CChurch(tObjectsLayer);
						tChurch.setX((j + 0.5) * CGameConstants.TILE_WIDTH - tChurch.getWidth() * 0.5);
						tChurch.setY((i + 0.5) * CGameConstants.TILE_HEIGHT - tChurch.getHeight() * 0.5);
						tChurch.setConvertedTile(tConvertedMap.getTile(j, i));
						CGraphicsManager.getInstance().addBuilding(tChurch);
						tRow.push(tChurch);
					}
					else
						tRow.push(null);
				}
				mMap.push(tRow);
			}
			
			for (i = 0; i < mMap.length; i++)
			{
				for (j = 0; j < mMap[i].length; j++)
				{
					setHouse(j, i, CMapConstants.HOUSE, CMapConstants.HOUSE_DOOR);
					setHouse(j, i, CMapConstants.CHURCH);
				}
			}
			
		}
		
		public function addBuilding(aX:int, aY:int, aBuilding:CBuilding):void
		{
			mMap[aY][aX] = aBuilding;
		}
		
		private function setHouse(aPosX:int, aPosY:int, aID:int, aDoorID:int=-1):void
		{
			var tBuilding:CBuilding = mMap[aPosY][aPosX];
			var tAdj:Vector.<Vector.<int>>;
			tAdj = new Vector.<Vector.<int>>;
			if (tBuilding != null && (mIdMap[aPosY][aPosX] == aID || mIdMap[aPosY][aPosX] == aDoorID))
			{
				if (tBuilding.getConstruct() == null)
				{
					var tVect:Vector.<int>;
					
					if (aPosY > 0)
					{
						tVect = new Vector.<int>;
						tVect.push(aPosY - 1);
						tVect.push(aPosX);
						tAdj.push(tVect);
					}
					
					if (aPosX < mMap[aPosY].length - 1)
					{
						tVect = new Vector.<int>;
						tVect.push(aPosY);
						tVect.push(aPosX + 1);
						tAdj.push(tVect);
					}
					
					if (aPosY < mMap.length - 1)
					{
						tVect = new Vector.<int>;
						tVect.push(aPosY + 1);
						tVect.push(aPosX);
						tAdj.push(tVect);
					}
					
					if (aPosX > 0)
					{
						tVect = new Vector.<int>;
						tVect.push(aPosY);
						tVect.push(aPosX - 1);
						tAdj.push(tVect);
					}
					
					var i:int = 0;
					//var tConstruct:CBuildingConstruct;
					for (i = 0; i < tAdj.length; i++)
					{
						if (mMap[tAdj[i][0]][tAdj[i][1]] != null)
						{
							if (mMap[tAdj[i][0]][tAdj[i][1]].getConstruct() != null)
								tBuilding.setConstruct(mMap[tAdj[i][0]][tAdj[i][1]].getConstruct());
						}
					}
					if (tBuilding.getConstruct() == null)
						tBuilding.setConstruct(new CBuildingConstruct(mIdMap[aPosY][aPosX] == CMapConstants.CHURCH));
					tBuilding.getConstruct().addBuilding(tBuilding);
					if (mIdMap[aPosY][aPosX] == aDoorID)
						tBuilding.getConstruct().setDoor(tBuilding);
					
					for (i = 0; i < tAdj.length; i++)
					{
						setHouse(tAdj[i][1], tAdj[i][0], aID);
					}					
				}
			}
		}
	}

}