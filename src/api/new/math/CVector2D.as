package api.math 
{
	/**
	 * ...
	 * @author Magestican
	 */
	public class CVector2D 
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		
		private static const EPSILON:Number = 0.000001;
		// TODO: Implementar.
		private var mAngle:Number = EPSILON;
		//private var mMag:Number; 
		
		public function CVector2D(aX:Number = 0, aY:Number = 0) 
		{
			x = aX;
			y = aY;
		}
		//magnitude
		public var mMg:Number = 0;
		
		
		
		
		public function negative():void
		{
			if (x > 0)
			{
				x *= -1;
			}
			if (y > 0)
			{
				y *= -1;
			}
		}
		
		public function positive():void
		{
			if (x < 0)
			{
				x *= -1;
			}
			if (y < 0)
			{
				y *= -1;
			}
		}
		
		
		
		
		
		public function negativeX():void
		{
			if (x > 0)
			{
				x *= -1;
			}
		}
		
		public function positiveX():void
		{
			if (x < 0)
			{
				x *= -1;
			}
		}
		
		public function setXY(aX:Number, aY:Number):void
		{
			x = aX;
			y = aY;
		}
		
		public function sum(aVec:CVector2D):void
		{
			x += aVec.x;
			y += aVec.y;
		}
		
		public function subs(aVec:CVector2D):void
		{
			x -= aVec.x;
			y -= aVec.y;
		}
		
		
		
		public function sumInNewVect(aHowMuch:Number):CVector2D
		{
			return new CVector2D( this.x + aHowMuch, this.y + aHowMuch);
		}
		
		public function mul(aScale:Number):void
		{
			x *= aScale;
			y *= aScale;
		}
		
		public function mag():Number
		{
			return Math.sqrt(x*x + y*y);
		}
		
		public function truncate(aLength:Number):void
		{
			if (mag() > aLength)
			{
				normalize();
				mul(aLength);
			}
		}
		
		public function normalize():void
		{
			var m:Number = mag();
			
			// Check division by zero.
			if (m > EPSILON)
			{
				x = x / m;
				y = y / m;
			}
		}
		
		// Retorna el ángulo en radianes.
		public function getAngle():Number
		{
			if (mAngle != EPSILON)
			 {
				 return mAngle;
			 }
			 else 
			 {
				 mAngle = Math.atan2(y, x);
				 return mAngle;
			 }
		}
		// Recibe el angulo en grados.
		// Changing the angle changes the x and y but retains the same magnitude.
		public function setAngle(aAngle:Number):void
		{
			var m:Number = mag();
			x = Math.cos(CMath.deg2rad(aAngle)) * m;
			y = Math.sin(CMath.deg2rad(aAngle)) * m;
			mAngle = aAngle;
		}
		
		public function setMag(aMag:Number):void
		{
			var angle:Number = getAngle();
			x = aMag * Math.cos(angle);
			y = aMag * Math.sin(angle);
			mMg = aMag;
		}
		
		public function setAngleMag(aAngle:Number, aMag:Number):void
		{
			setMag(aMag);
			setAngle(aAngle);
		}
	}

}