package game.management 
{
	import api.CGame;
	import api.CGameObject;
	import api.enums.CShapes;
	import api.input.CMouse;
	import api.math.CCircle;
	import api.math.CMath;
	import game.convertibles.CGenericConvertible;
	import game.convertibles.units.CGenericUnit;
	
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CConvertibleManager 
	{
		private var mConvertibles:Vector.<CGenericConvertible>
		
		private var mConvertedLength:int;
		
		public function CConvertibleManager() 
		{
			mConvertibles = new Vector.<CGenericConvertible>;
		}
		
		public function flush():void
		{
			for (var i:int = mConvertibles.length - 1; i >= 0; i--)
			{
				mConvertibles[i].destroy();
				mConvertibles.splice(i, 1);
			}
		}
		
		public function countConverted():void
		{
			var tLength:int = 0;
			for (var i:int = 0; i < mConvertibles.length; i++)
			{
				if (mConvertibles[i].isConverted())
					tLength++;
			}
			mConvertedLength = tLength;
		}
		
		public function getConvertedLength():int
		{
			return mConvertedLength;
		}
		
		public function getLength():int
		{
			return mConvertibles.length;
		}
		
		public function getConvertible(aIndex:int):CGenericConvertible
		{
			return mConvertibles[aIndex];
		}
		
		public function getClosest(aGameObject:CGenericConvertible):CGenericConvertible 
		{
			var tDistance:Number = CMath.INFINITY;
			var tClosest:CGenericConvertible = null;
			var tConverted:Boolean = !aGameObject.isConverted();
			
			for (var j:int = 0; j < mConvertibles.length; j++)
			{
				var tNewDist:Number = mConvertibles[j].distanceTo(aGameObject);
				if (tNewDist < tDistance && ((!tConverted && !mConvertibles[j].isConverted()) || (tConverted && mConvertibles[j].isConverted())))
				{
					tDistance = tNewDist;
					tClosest = mConvertibles[j];
				}
			}
			return tClosest;
		}
		
		public function collides(collisionObject:CGameObject):CGenericConvertible
		{
			var i:int = 0;
			var tEnd:Boolean = false;
			var tCollidedObject:CGenericConvertible = null;
			while (i < mConvertibles.length && !tEnd)
			{
				if (!mConvertibles[i].isConverted())
				{
					if (collisionObject.getShape() == CShapes.CIRCLE && mConvertibles[i].getShape() == CShapes.CIRCLE)
					{
						// TODO: Corregir colisiones
						if (CMath.circleCircleCollision(mConvertibles[i].getCircle(), collisionObject.getCircle()))
						{
							tCollidedObject = mConvertibles[i];
							tEnd = true;
						}
					}
					else if (collisionObject.getShape() == CShapes.SQUARE && mConvertibles[i].getShape() == CShapes.CIRCLE)
					{
						if (CMath.rectCircCollision(mConvertibles[i].getCircle(), collisionObject.getRectangle()))
						{
							tCollidedObject = mConvertibles[i];
							tEnd = true;
						}
					}
					else if (collisionObject.getShape() == CShapes.CIRCLE && mConvertibles[i].getShape() == CShapes.SQUARE)
					{
						if (CMath.rectCircCollision(collisionObject.getCircle(), mConvertibles[i].getRectangle()))
						{
							tCollidedObject = mConvertibles[i];
							tEnd = true;
						}
					}
					else if (collisionObject.getShape() == CShapes.SQUARE && mConvertibles[i].getShape() == CShapes.SQUARE)
					{
						if (CMath.rectRectCollision(mConvertibles[i].getRectangle(), collisionObject.getRectangle()))
						{
							tCollidedObject = mConvertibles[i];
							tEnd = true;
						}
					}
				}
				i++;
			}
			return tCollidedObject;
		}
		
		//public function callArea(aCircle:CCircle):void
		//{
			//var tUnit:CGenericUnit;
			//for (var i:int = 0; i < mConvertibles.length; i++)
			//{
				//if (CMath.rectCircCollision(aCircle, mConvertibles[i].getRectangle()) && mConvertibles[i].isConverted() && mConvertibles[i].getState() != CGenericUnit.FOLLOW_PLAYER)
				//{
					//tUnit = mConvertibles[i] as CGenericUnit;
					//tUnit.followPlayer();
				//}
			//}
		//}
		
		public function callArea(aCircle:CCircle, aConverted:Boolean=true):Vector.<CGenericConvertible>
		{
			var tUnit:CGenericUnit;
			var tList:Vector.<CGenericConvertible> = new Vector.<CGenericConvertible>;
			for (var i:int = 0; i < mConvertibles.length; i++)
			{
				if (CMath.rectCircCollision(aCircle, mConvertibles[i].getRectangle()) && mConvertibles[i].isConverted() == aConverted)
				{
					tList.push(mConvertibles[i]);
				}
			}
			return tList;
		}
		
		public function mouseOver():CGenericConvertible
		{
			var tConvertible:CGenericConvertible = null;
			var i:int = 0;
			var tFound:Boolean = false;
			var tMouseX:int = CMouse.getMouseX() + CGame.inst().getCamera().getX();
			var tMouseY:int = CMouse.getMouseY() + CGame.inst().getCamera().getY();
			
			while (i < mConvertibles.length && !tFound)
			{
				if (tMouseX > mConvertibles[i].getX() + mConvertibles[i].getRegistryPoint().x && tMouseX < mConvertibles[i].getX() + mConvertibles[i].getRegistryPoint().x + mConvertibles[i].getWidth())
				{
					if (tMouseY > mConvertibles[i].getY() + mConvertibles[i].getRegistryPoint().y && tMouseY < mConvertibles[i].getY() + mConvertibles[i].getRegistryPoint().y + mConvertibles[i].getHeight())
					{
						tFound = true;
						tConvertible = mConvertibles[i];
					}
				}
				i++;
			}
			return tConvertible;
		}
		
		public function removeByIndex(aIndex:int):void
		{
			if (aIndex >= 0 && aIndex < mConvertibles.length)
			{
				mConvertibles[aIndex].destroy();
				mConvertibles.slice(aIndex, 1);
			}
		}
		
		public function append(aConvertible:CGenericConvertible):void
		{
			mConvertibles.push(aConvertible);
			if (aConvertible.isConverted())
			{
				mConvertedLength++;
			}
		}
		
		public function update():void
		{
			for (var i:int = 0; i < mConvertibles.length; i++)
			{
				mConvertibles[i].update();
			}
		}
		
		public function render():void
		{
			for (var i:int = 0; i < mConvertibles.length; i++)
			{
				mConvertibles[i].render();
			}
		}
	}

}