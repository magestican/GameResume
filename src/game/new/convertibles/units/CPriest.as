package game.convertibles.units 
{
	import api.ai.behaviour.CMazeMovementBehaviour;
	import api.ai.behaviour.CPatrolBehaviour;
	import api.CGame;
	import api.CLayer;
	import api.enums.CMapLayers;
	import api.enums.CShapes;
	import api.enums.CTerrains;
	import api.math.CMath;
	import api.math.CVector3D;
	import api.prefabs.CRect;
	import api.tileMap.CTileMap;
	import api.tileMap.CTileSet;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import game.assets.CAssets;
	import game.assets.CMaps;
	import game.CAura;
	import game.constants.CGameConstants;
	import game.constants.CMapConstants;
	import game.convertibles.CGenericConvertible;
	import game.CStats;
	import game.CVars;
	import game.management.CGraphicsManager;
	import game.states.CLevel01State;

	public class CPriest extends CGenericUnit 
	{
		private const WIDTH:uint = 80;
		private const HEIGHT:uint = 60;
		private const SPEED:uint = 4;
		private const RANDOM_SPEED:uint = 3;

		private const REG_X:int = -40;
		private const REG_Y:int = -60;
		
		private var MAX_CONVERSION:int = 1000;
		private var CURE_RATE:int = 20;
		private var IDLE_TIME:int = CGameConstants.FPS * 3;
		private var CLOSE_RANGE:uint = 100;
		private var RANGE:uint = 300;
		private var CONVERT_RATE:uint = 50;
		private var OUTER_RING:uint = 200;
		private var INNER_RING:uint = 100;
		
		// ANIM FRAMES
		private const ANIM_DELAY:uint = CGameConstants.FPS *0.1;
		private const IDLE_FRAMES:Array = [1, 8];
		private const WALKING_FRAMES:Array = [9, 20];
		private const CONVERTING_FRAMES:Array = [21, 23];

		private var mWalkingPathName:String = "";
		
		public function CPriest(aLayer:CLayer)
		{
			setLayer(aLayer);
			setMC(new CAssets.EnemyPriest1 as MovieClip);
			activate();
			
			setAgressive(false); // Don't attack for debug
			
			setMaxConversion(MAX_CONVERSION);
			setCureRate(CURE_RATE);
			setRegistryPointXY(REG_X, REG_Y);
			setWidth(WIDTH);
			setHeight(HEIGHT);
			setConvertRate(CONVERT_RATE);
			setIdleTime(IDLE_TIME);
			setConverted(false);
			
			setRange(RANGE);
			setCloseRange(CLOSE_RANGE);
			setWalkingSpeed(SPEED);
			
			setAura(new CAura(new CAssets.AuraToHuman as MovieClip));
			getAura().setAnim(1, 24, CGameConstants.FPS * 0.04);
			
		    setSpeed(SPEED);
			setOffsetXY(CGameConstants.TILE_WIDTH, CGameConstants.TILE_HEIGHT  * 2);
			setBehaviour(new CPatrolBehaviour((CGame.inst().getState() as CLevel01State).getPaths(), this, CMapConstants.ENEMY_PATH));

			setAnim(IDLE_FRAMES, WALKING_FRAMES, CONVERTING_FRAMES, ANIM_DELAY);
			setState(IDLE);
			activate();
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function render():void 
		{
			super.render();
			getMC().gotoAndStop(getAnim().getCurrentFrame());
			if (isActive())
			{
				if (!isFlipped())
				{
					getMC().scaleX = 1;
				}
				else
				{
					getMC().scaleX = -1;
				}
				getMC().x = getX();
				getMC().y = getY();
			}
		}
	}

}