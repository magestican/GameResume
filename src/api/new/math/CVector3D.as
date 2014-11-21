package api.math 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CVector3D 
	{
		private const EPSILON:Number = 0.000001;
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var mAngle:int = 0;
		
		public function CVector3D(aX:Number=0, aY:Number=0, aZ:Number=0) 
		{
			x = aX;
			y = aY;
			z = aZ;
		}
		
		public function copy():CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = x;
			vect.y = y;
			vect.z = z;
			return vect;
		}
		
		public function setX(aX:Number):void
		{
			x = aX;
		}
		public function setY(aY:Number):void
		{
			y = aY;
		}
		public function setZ(aZ:Number):void
		{
			z = aZ;
		}
		public function setXYZ(aX:Number, aY:Number, aZ:Number=0):void
		{
			x = aX;
			y = aY;
			z = aZ;
		}
		
		public function norm():Number
		{
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		public function normalize():void
		{
			if (norm() != 0)
				mult(1 / norm());
		}
		
		public function add(aVect:CVector3D):CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = x + aVect.x;
			vect.y = y + aVect.y;
			vect.z = z + aVect.z;
			return vect;
		}
		public function addVec(aVect:CVector3D):void
		{
			x += aVect.x;
			y += aVect.y;
			z += aVect.z;
		}
		
		public function substract(aVect:CVector3D):CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = x - aVect.x;
			vect.y = y - aVect.y;
			vect.z = z - aVect.z;
			return vect;
		}
		public function substractVect(aVect:CVector3D):void
		{
			x -= aVect.x;
			y -= aVect.y;
			z -= aVect.z;
		}
		
		public function timesScalar(aNum:Number):CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = x * aNum;
			vect.y = y * aNum;
			vect.z = z * aNum;
			return vect;
		}
		public function mult(aNum:Number):void
		{
			x *= aNum;
			y *= aNum;
			z *= aNum;
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
				mult(aLength);
			}
		}
		
		public function plusScalar(aNum:Number):CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = x + aNum;
			vect.y = y + aNum;
			vect.z = z + aNum;
			return vect;
		}
		public function sum(aNum:Number):void
		{
			x += aNum;
			y += aNum;
			z += aNum;
		}
		
		
		public function scalarProduct(aVect:CVector3D):Number
		{
			return x * aVect.x + y * aVect.y + z * aVect.z;
		}
		
		public function vectorProduct(aVect:CVector3D):CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = y * aVect.z - z * aVect.y;
			vect.y = z * aVect.x - x * aVect.z;
			vect.z = x * aVect.y - y * aVect.x;
			return vect;
		}
		
		public function getAngle(aVect:CVector3D):Number
		{
			if (mAngle != 0)
			{
				return mAngle;
			}
			else
			{
				return Math.acos(scalarProduct(aVect) / (norm() * aVect.norm()));
			}
			
		}
		
		public function rotate(mAngle:Number):CVector3D
		{
			var vect:CVector3D = new CVector3D();
			vect.x = x * Math.cos(mAngle) - y * Math.sin(mAngle);
			vect.y = x * Math.sin(mAngle) + y * Math.cos(mAngle);
			return vect;
		}
		
		public function rotateVect(mAngle:Number):void
		{
			x = x * Math.cos(mAngle) - y * Math.sin(mAngle);
			y = x * Math.sin(mAngle) + y * Math.cos(mAngle);
		}
		
		public function setMag(aMag:Number):void
		{
			mult(aMag / norm());
		}
		
		public function setAngle(aAngle:Number):void
		{
			var m:Number = mag();
			x = Math.cos(CMath.deg2rad(aAngle)) * m;
			y = Math.sin(CMath.deg2rad(aAngle)) * m;
			mAngle = aAngle;

		}
		
		public function getNormalAngle():Number
		{
			return Math.atan2(y, x);
		}
	}
}