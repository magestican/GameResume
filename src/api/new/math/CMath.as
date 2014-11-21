package api.math 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Fernando
	 */
	public class CMath 
	{
		public static const INFINITY:Number = Number.MAX_VALUE;
		
		public function CMath() 
		{
			
		}
		
		public static function norm(aX:Number, aY:Number):Number
		{
			return Math.sqrt(aX * aX + aY * aY);
		}

		public static function dist(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			return norm(x2 - x1, y2 - y1);
		}
		
		public static function rectRectCollision(aRect1:Rectangle, aRect2:Rectangle):Boolean
		{
			if ((((aRect1.x + aRect1.width) > aRect2.x) && (aRect1.x < (aRect2.x + aRect2.width))) && (((aRect1.y + aRect1.height) > aRect2.y) && (aRect1.y < (aRect2.y + aRect2.height))))
				return true;
			else
				return false;
		}
		
		public static function circleRectCollision(aX1:Number, aY1:Number, aW1:Number, aH1:Number, aX2:Number, aY2:Number, aR2:Number):Boolean
		{
			if (aX2 >= aX1 && aX2 <= aX1 + aW1)
			{
				return aY2 + aR2 >= aY1 && aY2 - aR2 <= aY1 + aH1;
			}
			else if (aY2 >= aY1 && aY2 <= aY1 + aH1)
			{
				return aX2 + aR2 >= aX1 && aX2 - aR2 <= aX1 + aW1;
			}
			else if (aX2 < aX1 && aY2 < aY1)
			{
				return dist(aX1, aY1, aX2, aY2) <= aR2;
			}
			else if (aX2 > aX1 + aW1 && aY2 < aY1)
			{
				return dist(aX1 + aW1, aY1, aX2, aY2) <= aR2;
			}
			else if (aX2 < aX1 && aY2 > aY1 + aH1)
			{
				return dist(aX1, aY1 + aH1, aX2, aY2) <= aR2;
			}
			else if ( aX2 > aX1 + aW1 && aX2 > aY1 + aH1)
			{
				return dist(aX1 + aW1, aY1 + aH1, aX2, aY2) <= aR2;
			}
			return false;
		}
		
		public static function randInt(aLow:int, aHigh:int):int
		{
			return Math.floor(Math.random() * (1 + aHigh - aLow)) + aLow;
		}
		
		public static function isEven(aNum:int):Boolean
		{	
			return (aNum % 2 == 0);
		}
		
				
		public static function addZeros(aNum:Number, aLength:uint):String
		{
			var numString:String = aNum.toString();
			var numZeros:Number = aLength - numString.length;
			var result:String = "";
			for (var i:int = 0; i < numZeros; i ++)
			{
				result += "0";
			}
			return result + numString;
		}
		
		public static function deg2rad(aDeg:Number):Number
		{
			return aDeg * Math.PI / 180;
		}
		
		public static function rad2deg(aRad:Number):Number
		{
			return aRad * 180 / Math.PI;
		}
		
		public static function getSign(aNum:Number):Number
		{
			return aNum / Math.abs(aNum);
		}
		public static function clampDeg(aDeg:Number):Number
		{
			aDeg = aDeg % 360;
			if (aDeg < 0.)
				aDeg += 360;
			return aDeg;
		}
		
		public static function clampRad(aRad:Number):Number
		{
			aRad = aRad % (2 * Math.PI);
			if (aRad < 0.)
				aRad += 2 * Math.PI;
			return aRad;
		}
		
		
		public static function addToAngle(angle:Number, addition:Number, untilEnd:Boolean):Vector.<Number>
		{
			if (360 % addition != 0)
			{
				throw RegExp("360 degrees must be divisible by the addition factor having a module of 0")
			}
			var angles:Vector.<Number> = new Vector.<Number>();
			if (!untilEnd)
			{
				angles.push(clampDeg(angle + addition));
			}
			else
			{
				var lastAngle:Number = -1;
				while (lastAngle != angle)
				{
					if (lastAngle != -1)
					{
						lastAngle = clampDeg(lastAngle + addition);
					}
					else
					{
						lastAngle = clampDeg(angle + addition);
					}
					angles.push(lastAngle);
				}
			}
			return angles;
		}
		
		public static function percentage(current:Number, maximum:Number):Number
		{
			return (current * 100 / maximum);
		}
		
		
			public static function distanceBetweenPoints(pointA:CVector2D, pointB:CVector2D):Number
		{
			var deltaX:Number = pointA.x - pointB.x;
			var deltaY:Number = pointA.y - pointB.y;
			return Math.sqrt(deltaX * deltaX + deltaY * deltaY)
		}
		
		
		public static function distanceBetweenPoints3D(pointA:CVector3D, pointB:CVector3D):Number
		{
			return Math.sqrt((pointB.x - pointA.x) * (pointB.x - pointA.x) + (pointB.y - pointA.y) * (pointB.y - pointA.y) + (pointB.z - pointA.z) * (pointB.z - pointA.z));
		}
		
		public static function rotateAngle(aDeg:Number):Number
		{
			aDeg += 180;
			return CMath.clampDeg(aDeg);
		}
		
		public static function circleCircleCollision(aCircle1:CCircle, aCircle2:CCircle):Boolean
		{
			
			var radius:Number = aCircle1.mRadious + aCircle2.mRadious;
			var deltaX:Number = aCircle1.mCenter.x - aCircle2.mCenter.x;
			var deltaY:Number = aCircle1.mCenter.y - aCircle2.mCenter.y;
			return deltaX * deltaX + deltaY * deltaY <= radius * radius;
		
		}
		
		public static function rectCircCollision(circle:CCircle, rectangle:Rectangle):Boolean
		{
			var rectangleCenter:Point = new Point((rectangle.x + rectangle.width * 0.5), (rectangle.y + rectangle.height * 0.5));
			
			var w:Number = rectangle.width * 0.5;
			var h:Number = rectangle.height * 0.5;
			
			var dx:Number = Math.abs(circle.mCenter.x - rectangleCenter.x);
			var dy:Number = Math.abs(circle.mCenter.y - rectangleCenter.y);
			
			if (dx > (circle.mRadious + w) || dy > (circle.mRadious + h))
			{
				return false;
			}
			
			var circleDistance:Point = new Point(Math.abs(circle.mCenter.x - rectangle.x - w), Math.abs(circle.mCenter.y - rectangle.y - h));
			
			if (circleDistance.x <= (w))
			{
				return true;
			}
			
			if (circleDistance.y <= (h))
			{
				return true;
			}
			
			var cornerDistanceSq:Number = Math.pow(circleDistance.x - w, 2) + Math.pow(circleDistance.y - h, 2);
			
			return (cornerDistanceSq <= (Math.pow(circle.mRadious, 2)));
		}
		
		
		public static function rotateAroundCenter(mc:DisplayObject, angleDegrees:Number):void
		{
			var matrix:Matrix = mc.transform.matrix;
			
			var rect:Rectangle = mc.getBounds(mc.parent);
			
			matrix.translate(-(rect.left + (rect.width / 2)), -(rect.top + (rect.height / 2)));
			
			matrix.rotate((angleDegrees / 180) * Math.PI);
			
			matrix.translate(rect.left + (rect.width / 2), rect.top + (rect.height / 2));
			
			mc.transform.matrix = matrix;
		}
		
		public static function RGB(aR:int, aG:int, aB:int):int
		{
			return aR << 16 | aG << 8 | aB;
		}
		
		public static function wander(aPos:CVector3D, aRadius:int):CVector3D
		{
			var tAngle:int = randInt(0, 359);
			var tVector:CVector3D = new CVector3D(aRadius);
			tVector.rotateVect(tAngle);
			tVector.addVec(aPos);
			return tVector;
		}
	}
}









