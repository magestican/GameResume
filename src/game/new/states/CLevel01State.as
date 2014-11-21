package game.states 
{
	import adobe.utils.CustomActions;
	import api.ai.CInfluenceMap;
	import api.CCamera;
	import api.CGame;
	import api.CGameState;
	import api.CHelper;
	import api.CLayer;
	import api.CSoundAndMusic;
	import api.debug.CDebugTarget;
	import api.enums.CTerrains;
	import api.math.CCircle;
	import api.math.CMath;
	import api.math.CVector3D;
	import api.prefabs.CCirclePref;
	import api.prefabs.CRect;
	import api.tileMap.CTile;
	import api.tileMap.CTileMap;
	import api.tileMap.CTileSet;
	import api.tileMap.prefabs.CNumberTileSet;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import game.assets.CAssets;
	import game.assets.CAudioAssets;
	import game.assets.CMaps;
	import game.CConvertInfluenceMap;
	import game.constants.CGameConstants;
	import game.constants.CMapConstants;
	import game.convertibles.buildings.CBuildingConstruct;
	import game.convertibles.buildings.CBuildingsMap;
	import game.convertibles.buildings.CChurch;
	import game.convertibles.buildings.CConstructManager;
	import game.convertibles.buildings.CHouse;
	import game.convertibles.units.CMinion;
	import game.convertibles.units.CPriest;
	import game.CPlayer;
	import game.CVars;
	import game.hud.CHud;
	import game.management.CGraphicsManager;
	
	
	
	public class CLevel01State extends CGameState
	{
		// STATES
		public static const START:uint = 0;
		public static const PLAY:uint = 1;
		public static const PAUSE:uint = 2;
		public static const WIN:uint = 3;
		public static const LOSE:uint = 4;
		
		private var mMap:CTileMap;
		private var mCamera:CCamera;
		private var mPlayer:CPlayer;
		private var mHud:CHud;
		
		private var mPaths:Vector.<Vector.<int>>;
		private var mMinionsInfluence:CConvertInfluenceMap;
		private var mEnemiesInfluence:CConvertInfluenceMap;
		
		//DEBUG
		private var mDebugMap:CTileMap;
		
		public function CLevel01State() 
		{
			
		}
		
		override public function init():void 
		{
			new CConstructManager();
			
			// Map
			mMap = new CTileMap();
			CGame.inst().setMap(mMap);
			var tTileSet:CTileSet = new CTileSet();
			tTileSet.setTileSetMC(CAssets.TILES);
			mMap.setTileSet(tTileSet);
			
			var mTerrains:Vector.<String> = new Vector.<String>();
			mTerrains.push(CTerrains.WALKABLE);
			mTerrains.push(CTerrains.ENEMY_PATH);
			mTerrains.push(CTerrains.PLATFORM);
			
			mMap.loadTileMap(new XML(new CMaps.MAP1), mTerrains);
			
			//Layers
			mMap.loadMap(CMapConstants.FLOOR);
			mMap.loadMap(CMapConstants.BUILD1);
			mMap.loadMap(CMapConstants.BUILD2);
			mMap.loadMap(CMapConstants.ACCENTS);
			CLayer.addLayer('areas');
			CLayer.addLayer('objects');
			CLayer.addLayer('auras');
			mMap.loadMap(CMapConstants.ABOVE);
			mMap.loadMap(CMapConstants.CONVERTED);
			
			//mMap.loadMap(CMapConstants.PATHS);
			//mMap.loadMap(CMapConstants.OBJECTS);
			
			
			//Influence maps
			var tFloorMap:Vector.<Vector.<CTile>> = mMap.getLayerByName(CMapConstants.FLOOR).getTileMap();
			var tWalkableMap:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < tFloorMap.length; i++)
			{
				var tRow:Vector.<int> = new Vector.<int>();
				for (var j:int = 0; j < tFloorMap[i].length; j++)
				{
					if (tFloorMap[i][j].isWalkable())
						tRow.push(0);
					else
						tRow.push(-1);
				}
				tWalkableMap.push(tRow);
			}
			
			//mMinionsInfluence = new CConvertInfluenceMap(true);
			//mMinionsInfluence.setStaticMap(tWalkableMap);
			//mEnemiesInfluence = new CConvertInfluenceMap(true);
			//mEnemiesInfluence.setStaticMap(tWalkableMap);
			
			CVars.inst().setEnemiesInfluenceMap(mEnemiesInfluence);
			CVars.inst().setMinionsInfluenceMap(mMinionsInfluence);
			
			mPaths = mMap.getLoader().getMapLayer(CMapConstants.PATHS);
			
			mCamera = new CCamera(CGameConstants.STAGE_WIDTH, CGameConstants.STAGE_HEIGHT, mMap.getWorldWidth(), mMap.getWorldHeight());
			CGame.inst().setCamera(mCamera);
			
			//mCamera.setWidth(CGameConstants.STAGE_WIDTH);
			//mCamera.setHeight(CGameConstants.STAGE_HEIGHT);
			
			mPlayer = new CPlayer(CLayer.getLayerByName("objects"));
			mPlayer.setPosXYZ(50, 50);
			
			CVars.inst().setPlayer(mPlayer);
			mCamera.follow(mPlayer);
			
			mHud = new CHud();
			CVars.inst().getMinimap().addSimpleObject(mPlayer, 0xFF0000);
			
			if (CGameConstants.DEBUG)
			{
				//mDebugMap = new CTileMap();
				//mDebugMap.setTileSet(new CNumberTileSet());
				//mDebugMap.setTileWidth(mMap.getTileWidth());
				//mDebugMap.setTileHeight(mMap.getTileHeight());
				//mDebugMap.setMapWidth(mMap.getMapWidth());
				//mDebugMap.setMapHeight(mMap.getMapHeight());
				//mDebugMap.convertRawMapToTileMap('enemies', tWalkableMap);
			}
			
			
			getMusic().playSound(CAudioAssets.PlutusTheme,true,0.3);
			
			
			
			reset();
			
			render();
			//scale for better map vision
		}
		
		public function reset():void
		{
			var i:int;
			
			CConstructManager.inst().flushObjects();
			mPlayer.reset();
			
			var tObjectsLayer:CLayer = CLayer.getLayerByName('objects');
			
			CGraphicsManager.getInstance().flushConvertibles();
			
			var tHouse:CHouse;
			var tChurch:CChurch;
			var tMinion:CMinion;
			var tPriest:CPriest;
			var tObjectsMap:Vector.<Vector.<int>> = mMap.getLoader().getMapLayer(CMapConstants.OBJECTS);
			for (i = 0; i < tObjectsMap.length; i++)
			{
				for (var j:int = 0; j < tObjectsMap[i].length; j++)
				{
					if (tObjectsMap[i][j] == CMapConstants.PLAYER_START)
					{
						mPlayer.setX((j + 0.5) * CGameConstants.TILE_WIDTH - mPlayer.getWidth() * 0.5);
						mPlayer.setY((i + 0.5) * CGameConstants.TILE_HEIGHT - mPlayer.getHeight() * 0.5);
					}
					else if (tObjectsMap[i][j] == CMapConstants.PRIEST)
					{
						tPriest = new CPriest(tObjectsLayer);
						tPriest.setXY((j + 0.5) * CGameConstants.TILE_WIDTH - 20 * 0.5, (i + 0.5) * CGameConstants.TILE_HEIGHT - 30 * 0.5);
						CGraphicsManager.getInstance().addMinion(tPriest);
					}
				}
			}
			
			// Load all houses and churches
			new CBuildingsMap(tObjectsMap);
			
			// Minions
			for (i = 0; i < 0; i++)
			{
				tMinion = new CMinion(tObjectsLayer);
				tMinion.setPosXYZ(CMath.randInt(50, 300 - tMinion.getWidth()), CMath.randInt(50, 300 - tMinion.getHeight()));
				CGraphicsManager.getInstance().addMinion(tMinion);
			}
			
			setState(START);
		}
		
		public function getPaths():Vector.<Vector.<int>>
		{
			return mPaths;
		}
		
		public function winCondition():Boolean
		{
			CGraphicsManager.getInstance().getBuildings().countConverted();
			return CGraphicsManager.getInstance().getBuildings().getConvertedLength() == CGraphicsManager.getInstance().getBuildings().getLength();
		}
		public function loseCondition():Boolean
		{
			return mPlayer.isDead();
		}
		
		override public function setState(aState:Number):void 
		{
			super.setState(aState);
		}
		
		override public function update():void 
		{
			if (getState() == START)
			{
				//Run start sequence
				setState(PLAY);
			}
			else if (getState() == PLAY)
			{
				if (winCondition())
				{
					setState(WIN);
					return;
				}
				if (loseCondition())
				{
					setState(LOSE);
					return;
				}
				//mMap.update();
				CGame.inst().setGameTime( CGame.inst().getGameTime() + 1);
				mPlayer.update();
				mHud.update();
				CConstructManager.inst().update();
				//mEnemiesInfluence.update();
				//mMinionsInfluence.update();
				CGraphicsManager.getInstance().update();
				mCamera.update();
			}
			else if (getState() == PAUSE)
			{
				
			}
			else if (getState() == WIN)
			{
				trace('You won!');
				reset();
				return;
			}
			else if (getState() == LOSE)
			{
				trace('You lost');
				reset();
				return;
			}
		}
		
		override public function render():void 
		{
			mCamera.render();
			mPlayer.render();
			//mMap.render();
			mHud.render();
			CGraphicsManager.getInstance().render();
			CConstructManager.inst().render();
			CHelper.sortChildrenByY(CLayer.getLayerByName('objects'));
		}
		
		override public function destroy():void 
		{
			mCamera.destroy();
			mPlayer.destroy();
			mMap.destroy();
			mHud.destroy();
			CGraphicsManager.getInstance().destroy();
			CConstructManager.inst().destroy();
			super.destroy();
		}
	}

}


