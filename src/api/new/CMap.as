package api
{
	import adobe.utils.CustomActions;
	import game.management.CGraphicsManager;
	import game.management.Generics.CGenericTile;
	import api.math.CMath;
	import api.math.CVector2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CMap
	{
		public var mTileSet:Vector.<CGenericTile> = new Vector.<CGenericTile>();
		private var mMapTiles:Array = new Array();
		public static var mMapHolder:CLayer = new CLayer();
		public static var mMapSize:int;
		public static var mTileSize:int;
		
		public function CMap(aMapLayer:CLayer)
		{
			mMapHolder = aMapLayer;
		}
		
		//this will clone a sprite, this is required because actionscript passes everything by reference and does not make copies of objects
		public function returnClonedDO(src:DisplayObject):DisplayObject
		{
				var myBitmapData:BitmapData = new BitmapData(src.width, src.height, false, 0);
				myBitmapData.draw(src);
				var myBitmap:Bitmap = new Bitmap(myBitmapData);
				return myBitmap;
		}
		
		public function init(tileSize:int, tileAmmounts:int):void
		{
			mTileSize = tileSize;
			mMapSize = tileAmmounts;
			CGenericTile.TileSize = tileSize;
			var tile:CGenericTile;
			//THERE ARE NO 2D ARRAYS IN ACTIONSCRIPT, SO WE HAVE TO PLACE AN ARRAY INSIDE AN ARRAY!!! :(
			var tilesOnX:Array = new Array();
			
			for (var x:int = 0; x < tileAmmounts; x++)
			{
				tilesOnX = new Array();
				for (var y:int = 0; y < tileAmmounts; y++)
				{
					var tileNumber:int = CMath.randInt(1, 5);
					
					//tile = new CGenericTile(new CAssets.Tile01 as Sprite,mMapHolder);
					
					//tile.render();
					tilesOnX.push(tile);
					tile.getSprite().mouseEnabled = false;
					tile.activate();
					CGraphicsManager.getInstance().getTiles().append(tile);
					
				}
				//once we finish with x , we switch back to Y
				switch (CGenericTile.mBhevaiour)
				{
					case CGenericTile.GROW_X: 
						CGenericTile.mBhevaiour = CGenericTile.GROW_Y;
						break;
					case CGenericTile.GROW_Y: 
						CGenericTile.mBhevaiour = CGenericTile.GROW_X;
						break;
				}
				mMapTiles[x] = tilesOnX;
			}
		}
		
		public function update():void
		{
			//update tiles if required
		}
		
		public function getCenterTile():CGenericTile
		{
			return (mMapTiles[mMapSize * 0.5][mMapSize * 0.5]) as CGenericTile;
		}
		
		public function getTile(x:int,y:int ):CGenericTile
		{
			if (x < 0 || y < 0 || x >= mMapSize || y >= mMapSize)
			{
				trace("Coordenadas fuera de rango: x=" + x + " y=" + y);
				return mMapTiles[0][0];
			}
			else
			{
				return (mMapTiles[y][x]);
			}
		}
		
		
		
		
		public function getSize():CVector2D
		{
			var vect:CVector2D = new CVector2D(mTileSize * mMapTiles.length, mTileSize * mMapTiles.length);
			return vect;
		}
	}

}