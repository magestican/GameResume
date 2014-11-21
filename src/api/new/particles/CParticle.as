package api.particles
{
	import api.CCamera;
	import game.management.CGraphicsManager;
	import game.management.Generics.CGenericGraphic;
	import api.prefabs.CCirclePref;
	import api.CGame;
	import api.CGameObject;
	import api.CLayer;
	import api.math.CMath;
	import api.math.CVector2D;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CParticle extends CGenericGraphic
	{
		public function CParticle(color:Number, initPosition:CVector2D, restrictionDegrees:Number, angle:Number, magnitude:Number, layer:CLayer)
		{
			mLayer = layer;
			sprt.graphics.beginFill(color,0.60);
			sprt.graphics.drawRect(0, 0, 4,4);
			//sprt.graphics.drawCircle(0, 0,3);
			sprt.graphics.endFill();
			setShape(SHAPE.CIRCLE);
			mCircle.mRadious = 4;
			
			//Create and positionate
			var pos:CVector2D = new CVector2D(initPosition.x, initPosition.y);
			var offset:CVector2D = new CVector2D();
			offset.setAngleMag(angle, magnitude);
			setAngle(angle);
			pos.sum(offset);
			setPos(pos);
			sprt.x = pos.x;
			sprt.y = pos.y;
			var vel:CVector2D = getVel();
			vel.setMag(2);
			vel.setAngle(getAngle() + CMath.randomNumberBetween( -restrictionDegrees, restrictionDegrees));
			setVel(vel);
			
			mCircle.mCenter = getPos();
			//management
			sprt.mouseEnabled = false;
			mLayer.addChild(sprt);
			CGraphicsManager.getInstance().mParticles.append(this);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function render():void
		{
			super.render();
			
			sprt.x = getX();
			sprt.y = getY();
			sprt.alpha -= 0.06;
			if (sprt.alpha < 0)
			{
				CGraphicsManager.getInstance().mParticles.remove();
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
	}

}