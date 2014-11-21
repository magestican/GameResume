package api.tileMap
{
	import adobe.utils.CustomActions;
	import api.CLayer;
	import api.enums.CMapLayersEnum;
	import api.enums.CTerrains;
	import api.math.CVector2D;
	import api.tileMap.CXMLMapLoader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import mx.core.FlexMovieClip;
	
	public class CTileMap
	{
		
		private var mEmptyTile:CTile;
		
		private var mTileMap:CXMLMapLoader;
		
		private var mMapWidth:int;
		private var mMapHeight:int;
		private var mTileWidth:int;
		private var mTileHeight:int;
		
		private var mLayers:Vector.<CMapLayer>;
		private var mMainLayer:int = 0;
		private var mTileSet:CTileSet;
		
		private var mAtributes:Dictionary = new Dictionary();
		
		public function CTileMap()
		{
			mEmptyTile = new CTile(0, 0, 0, 0, null, true);
			mLayers = new Vector.<CMapLayer>();
		}
		
		public function getEmptyTile():CTile
		{
			return mEmptyTile;
		}
		
		public function loadTileMap(aMap:XML, aAtributes:Vector.<String>):void
		{
			mTileMap = new CXMLMapLoader(aMap);
			mTileWidth = mTileMap.getTileWidth();
			mTileHeight = mTileMap.getTileHeight();
			mMapWidth = mTileMap.getMapWidth();
			mMapHeight = mTileMap.getMapHeight();
			
			for (var i:uint; i < aAtributes.length; i++)
			{
				mAtributes[aAtributes[i]] = mTileMap.getAttribute(aAtributes[i]);
				mEmptyTile.setDynamicProperty(aAtributes[i], false);
			}
			mEmptyTile.setDynamicProperty(CTerrains.WALKABLE, true);
		}
		
		public function loadMap(aLayerName:String):void
		{
			var tMapLayer:CMapLayer = new CMapLayer(aLayerName);
			var tTilePositions:Vector.<Vector.<int>> = mTileMap.getMapLayer(aLayerName);
			var tMap:Vector.<Vector.<CTile>> = new Vector.<Vector.<CTile>>();
			var tLayer:CLayer = CLayer.addLayer(aLayerName);
			
			tMapLayer.setMap(tTilePositions);
			tMapLayer.setLayer(tLayer);
			
			for (var i:uint = 0; i < tTilePositions.length; i++)
			{
				var tRow:Vector.<CTile> = new Vector.<CTile>();
				for (var j:uint = 0; j < tTilePositions[i].length; j++)
				{
					if (tTilePositions[i][j] != 0)
					{
						var tTile:CTile = new CTile(mTileWidth * j, mTileHeight * i, mTileWidth, mTileHeight, tLayer);
						tTile.setTileIndex(tTilePositions[i][j]);
						for (var k:String in mAtributes)
						{
							var tTerrains:Array = mAtributes[k];
							var tTerrainName:String = k;
							tTile.setDynamicProperty(tTerrainName, tTerrains[tTilePositions[i][j] - 1]);
						}
						tRow.push(tTile);
					}
					else
						tRow.push(mEmptyTile);
				}
				tMap[i] = tRow;
			}
			
			tMapLayer.setTileMap(tMap);
			mLayers.push(tMapLayer);
		}
		
		
		public function convertRawMapToTileMap(aName:String, aArray:Vector.<Vector.<int>>):void
		{
			var tMapLayer:CMapLayer = new CMapLayer(aName);
			var tMap:Vector.<Vector.<CTile>> = new Vector.<Vector.<CTile>>();
			var tLayer:CLayer = CLayer.addLayer(aName);
			tMapLayer.setMap(aArray);
			tMapLayer.setLayer(tLayer);
			
			for (var i:uint = 0; i < aArray.length; i++)
			{
				var tRow:Vector.<CTile> = new Vector.<CTile>();
				for (var j:uint = 0; j < aArray[i].length; j++)
				{
					if (aArray[i][j] != 0)
					{
						var tTile:CTile = new CTile(mTileWidth * j, mTileHeight * i, mTileWidth, mTileHeight, tLayer);
						tTile.setTileIndex(aArray[i][j]);
						//tTile.setDynamicProperty(CTerrains.WALKABLE, mAtributes[CTerrains.WALKABLE][aArray[i][j] - 1]);
						//tTile.setDynamicProperty(CTerrains.PLATFORM, mAtributes[CTerrains.PLATFORM][aArray[i][j] - 1]);
						//tTile.setDynamicProperty(CTerrains.ENEMY_PATH, mAtributes[CTerrains.ENEMY_PATH][aArray[i][j] - 1]);
						tRow.push(tTile);
					}
					else
						tRow.push(mEmptyTile);
				}
				tMap.push(tRow);
			}
			tMapLayer.setTileMap(tMap);
			mLayers.push(tMapLayer);
		}
		
		public function getLayerByName(aName:String):CMapLayer
		{
			var i:int = 0;
			while (i < mLayers.length)
			{
				if (mLayers[i].getName() == aName)
					return mLayers[i];
				i++;
			}
			return null;
		}
		
		public function setMainLayer(aLayerName:String):void
		{
			var i:int = 0;
			while (i < mLayers.length)
			{
				if (mLayers[i].getName() == aLayerName)
				{
					mMainLayer = i;
					return;
				}
				i++;
			}
		}
		
		public function getTile(x:uint, y:uint):CTile
		{
			return mLayers[mMainLayer].getTile(x, y);
		}
		
		public function flushMaps():void
		{
			for (var k:uint = 0; k < mLayers.length; k++)
			{
				if (mLayers[k])
				{
					mLayers[k] = null;
				}
			}
		}
		
		public function setTileSet(aTileSet:CTileSet):void
		{
			mTileSet = aTileSet;
		}
		public function getTileSet():CTileSet
		{
			return mTileSet;
		}
		
		public function getLoader():CXMLMapLoader
		{
			return mTileMap;
		}
		
		public function setMapWidth(aMapWidth:int):void
		{
			mMapWidth = aMapWidth;
		}
		public function getMapWidth():int
		{
			return mMapWidth;
		}
		
		public function setMapHeight(aMapHeight:int):void
		{
			mMapHeight = aMapHeight;
		}
		public function getMapHeight():int
		{
			return mMapHeight;
		}
		
		public function setTileWidth(aTileWidth:int):void
		{
			mTileWidth = aTileWidth;
		}
		public function getTileWidth():int
		{
			return mTileWidth;
		}
		
		public function setTileHeight(aTileHeight:int):void
		{
			mTileHeight = aTileHeight;
		}
		public function getTileHeight():int
		{
			return mTileHeight;
		}
		
		public function getWorldWidth():int
		{
			return mMapWidth * mTileWidth;
		}
		
		public function getWorldHeight():int
		{
			return mMapHeight * mTileHeight;
		}
		
		public function update():void
		{
			for (var k:uint = 0; k < mLayers.length; k++)
			{
				mLayers[k].update();
			}
		}
		
		public function render():void
		{
			for (var k:uint = 0; k < mLayers.length; k++)
			{
				mLayers[k].render();
			}
		}
		
		public function destroy():void
		{
			for (var k:uint = 0; k < mLayers.length; k++)
			{
				mLayers[k].destroy();
				mLayers[k] = null;
			}
			mLayers = null;
			
			mEmptyTile.destroy();
			mEmptyTile = null;
			mTileMap.destroy();
			mTileMap = null;
		}	
	}
}