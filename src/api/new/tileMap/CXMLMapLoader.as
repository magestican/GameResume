package  api.tileMap
{
	import api.CLayer;
	import api.extensions.CVector2dExt;
	import api.extensions.CVectorExt;
	import api.math.CVector2D;
	import api.tileMap.CTile;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class CXMLMapLoader 
	{
		// Types of attributes
		public static const BOOLEAN:uint = 0;
		public static const INT:uint = 1;
		public static const STRING:uint = 2;
		
		private var mXMLMap:XML;
		private var mMapWidth:int;
		private var mMapHeight:int;
		private var mTileWidth:int;
		private var mTileHeight:int;
		private var mTilesetWidth:int;
		private var mTilesetHeight:int;
		
		public function CXMLMapLoader(aXML:XML) 
		{
			mXMLMap = aXML;
			mMapWidth = mXMLMap.@width;
			mMapHeight = mXMLMap.@height;
			mTileWidth = mXMLMap.@tilewidth;
			mTileHeight= mXMLMap.@tileheight;
			mTilesetWidth = int(mXMLMap.tileset[0].image[0].@width) / mTileWidth;
			mTilesetHeight = int(mXMLMap.tileset[0].image[0].@height) / mTileHeight;
		}
		
		public function getMapWidth():int
		{
			return mMapWidth;
		}
		
		public function getMapHeight():int
		{
			return mMapHeight;
		}
		
		public function getTileWidth():int
		{
			return mTileWidth;
		}
		
		public function getTileHeight():int
		{
			return mTileHeight;
		}
		
		public function getMapLayer(aLayerName:String):Vector.<Vector.<int>>
		{
			var tileCoounter:uint = 0;
			var tMap:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			var tLayerNum:int = 0;
			var tTileLayer:XMLList = new XMLList();
			var tTiles:XML;
			var tFound:Boolean = false;
			var k:int = 0;
			
			for each (var o:XML in mXMLMap.layer)
			{
				if (o.@name == aLayerName)
				{
					tTiles = o;
					tFound = true;
				}
			}

			if (tFound)
			{
				for (var i:uint = 0; i < mMapHeight; i++) 
				{
					var tRow:Vector.<int> = new Vector.<int> ();
					for (var j:uint = 0; j < mMapWidth; j++)
					{
						tRow.push(int(tTiles.data[0].tile[tileCoounter].@gid));
						tileCoounter++;
					}
					tMap[i] = tRow;
				}
			}
			else
				throw RegExp('A layer with that name was not found');
			return tMap;
		}
		
		public function getTilesFromTerrain(aTerrain:String):Array
		{
			var o:XML;
			var tiles:Array = new Array();
			for (var i:uint = 0; i < mTilesetHeight * mTilesetWidth; i++)
			{
				tiles.push(false);
			}
			var tIndex:int = 0;
			var tFound:Boolean = false;
			if (mXMLMap.tileset[0].terraintypes != null)
			{
				//check if terrain exists
				for each (o in mXMLMap.tileset[0].terraintypes[0].terrain)
				{
					if (o.@name == aTerrain)
					{
						tFound = true;
						break;
					}
					else
						tIndex++;
				}
				//if the terrain exists
				if (tFound)
				{
					for each (o in mXMLMap.tileset[0].tile)
					{
						//iterate over every tile and set property as true
						if (int(o.@terrain.charAt(0)) == tIndex)
							tiles[int(o.@id)] = true;
					}
				}
			}
			return tiles;
		}
		
		
		public function getAttribute(aAttribute:String, aType:int=BOOLEAN):Array
		{
			var tAttr:Array = new Array();
			var i:uint;
			var o:XML;
			var p:XML;
			// Fill with defaults
			if (aType == BOOLEAN)
			{
				for (i = 0; i < mTilesetHeight * mTilesetWidth; i++)
				{
					tAttr.push(false);
				}
				
				for each (o in mXMLMap.tileset[0].tile)
				{
					if (o.properties != undefined)
					{
						for each (p in o.properties[0].property)
						{
							if (p.@name == aAttribute && p.@value == '1')
							{
								tAttr[int(o.@id)] = true;
							}
						}
					}
				}
			}
			else if (aType == STRING)
			{
				for (i = 0; i < mTilesetHeight * mTilesetWidth; i++)
				{
					tAttr.push('');
				}
				
				for each (o in mXMLMap.tileset[0].tile)
				{
					for each (p in o.properties[0].property)
					{
						if (p.@name == aAttribute)
						{
							tAttr[int(o.@id)] = p.@value;
						}
					}
				}
			}
			else if (aType == INT)
			{
				for (i = 0; i < mTilesetHeight * mTilesetWidth; i++)
				{
					tAttr.push(0);
				}
				
				for each (o in mXMLMap.tileset[0].tile)
				{
					for each (p in o.properties[0].property)
					{
						if (p.@name == aAttribute)
						{
							tAttr[int(o.@id)] = int(p.@value);
						}
					}
				}
			}
			return tAttr;
		}
		
		public function getObjectLayer(aLayer:String):XML
		{
			for each (var obj:XML in mXMLMap.objectgroup)
			{
				if (obj.@name == aLayer)
				{
					return obj;
				}
			}
			return null;
		}
		
		public function getObjects(aLayer:String, aType:String):Array
		{
			var tArray:Array = new Array();
			var tLayer:XML = getObjectLayer(aLayer);
			
			for each (var obj:XML in tLayer.children)
			{
				if (obj.@type == aType)
				{
					var tVect:CVector2D = new CVector2D();
					tVect.setXY(obj.@x, obj.@y);
					tArray.push(tVect);
				}
			}
			return tArray;
		}
		
		public function getFullObject(aLayer:String, aObject:String):Array
		{
			var j:int = -1;
			var tArray:Array = new Array();
			var tLayer:XML; //Capa de objetos en formato xml
			
			tLayer = getObjectLayer(aLayer);
			
			if (tLayer != null)
			{
				for each (var child:XML in tLayer.children)
				{
					var tRow:Array = new Array();
					if (child.@type == aObject)
					{
						var tVect:CVector2D = new CVector2D();
						var tSize:CVector2D = new CVector2D();
						tVect.setXY(child.@x, child.@y);
						tSize.setXY(child.@width, child.@height);
						tRow.push(tVect);
						tRow.push(tSize);
						tArray.push(tRow);
					}
				}
				return tArray;
			}
			else
				return null;
		}
		
		public function loadMapLayer(aLayer:CLayer,aXmlLayerName:String):CVector2dExt
		{
			var tileCoounter:uint = 0;
			var mMap:CVector2dExt = new CVector2dExt(mMapWidth, mMapHeight);
			var tLayerNum:int = 0;
			var aTileLayer:XML = new XML();
			var aTileTemplates:CVectorExt = new CVectorExt;
			
			aTileLayer = getLayer(aXmlLayerName);
			
			
			for each (var tile:XML in mXMLMap.tileset.tile)
			{
				var tileTemplate:CTile = new CTile();
				tileTemplate.setName(tile.properties[0].@name);
				tileTemplate.setGuid(tile.properties[0].@id)
				aTileTemplates.append(tileTemplate);
			}
			
			var mTiles:XML = aTileLayer.data[0];
			
			for (var x:uint = 0; x < mMapHeight; x++) 
			{
				var fila:Array = new Array();
				for (var y:uint = 0; y < mMapWidth; y++)
				{
					var template:CTile = aTileTemplates.getByGuid(mTiles.tile[tileCoounter].@gid - 1) as CTile;
					mMap.append(x, y, new CTile(x * mTileWidth, y * mTilesetHeight, mTileWidth, mTileHeight, aLayer, false));
					tileCoounter++;
				}
			}
			return mMap;
		}
		
		
		public function getLayer(aLayerName:String):XML
		{
			for each (var layer:XML in mXMLMap.layer)
			{
				if (layer.@name == aLayerName)
				{
					return layer;
				}
			}
			throw RegExp ("The layer was not found with the name " + aLayerName);
		}
		
		public function destroy():void
		{
			mXMLMap = null;
		}
	}

}
















