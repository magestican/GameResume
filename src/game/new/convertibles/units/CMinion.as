package game.convertibles.units
{
	import api.ai.behaviour.CWanderBehaviour;
	import api.CAnim;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import game.assets.CAssets;
	import game.CAura;
	import game.constants.CGameConstants;
	import game.convertibles.buildings.CBuilding;
	import api.CGame;
	import api.CGameObject;
	import api.CLayer;
	import api.enums.CMessage;
	import api.enums.CShapes;
	import api.math.CMath;
	import api.math.CVector2D;
	import api.math.CVector3D;
	import api.prefabs.CRect;
	import game.convertibles.CGenericConvertible;
	import game.CStats;
	import game.CVars;
	import game.management.CGraphicsManager;
	import game.states.CTestChamber;
	
	
	
	public class CMinion extends CGenericUnit
	{
		private const WIDTH:uint = 56;
		private const HEIGHT:uint = 40;
		private const SPEED:uint = 5;
		
		private const REG_X:int = -28;
		private const REG_Y:int = -40;
		
		// ANIM FRAMES
		private const ANIM_DELAY:uint = CGameConstants.FPS *0.1;
		private const IDLE_FRAMES:Array = [1, 4];
		private const WALKING_FRAMES:Array = [5, 11];
		private const CONVERTING_FRAMES:Array = [12, 16];
		
		public function CMinion(aLayer:CLayer)
		{
			setRegistryPointXY(REG_X, REG_Y);
			setLayer(aLayer);
			
			setConvertedMC(new CAssets.Minion1);
			
			setNormalMC(new CAssets.Peasant1);
			
			setMaxConversion(CStats.getMinionStats().MAX_CONVERSION);
			setCureRate(1);
			setWidth(WIDTH);
			setHeight(HEIGHT);
			setConvertRate(CStats.getMinionStats().CONVERT_RATE);
			setWalkingSpeed(SPEED);
			
			setAura(new CAura(new CAssets.AuraToMinion as MovieClip));
			getAura().setAnim(1, 24, CGameConstants.FPS * 0.04);

			setRange(CStats.getMinionStats().RANGE);
			setCloseRange(CStats.getMinionStats().CLOSE_RANGE);
			setSpeed(SPEED);
			
			activate();
			
			setBehaviour(new CWanderBehaviour(this));
			setAgressive(false);
			
			//CVars.inst().getMinimap().addSimpleObject(this, 0xFF00000);
			var tRatio:Number = CVars.inst().getMinimap().getRatio();
			setMinimapToken(new CRect(getWidth() * tRatio, getHeight() * tRatio, 0xFF0000));
			
			setAnim(IDLE_FRAMES, WALKING_FRAMES, CONVERTING_FRAMES, ANIM_DELAY);
		}
		
		override public function getCenter():CVector3D 
		{
			return new CVector3D(getX(), getY() - getHeight() * 0.5);
		}
		
		override public function update():void 
		{
			// Animation state machine
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