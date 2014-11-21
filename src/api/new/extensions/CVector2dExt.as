package api.extensions
{
	import adobe.utils.CustomActions;
	import api.CGame;
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.enums.CMessage;
	import api.enums.CShapes;
	import game.convertibles.CGenericConvertible;
	import game.management.CTimeToLive;
	import game.management.Generics.CGenericPlayer;
	import api.math.CMath;
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CVector2dExt extends CGameObject
	{
		private var mTimeToLive:CTimeToLive = null;
		private var mTime:Number = 0;
		public var arr:Array = new Array();
		public var RemoveOnceOutOfRange:Boolean = false;
		private var inRange:Boolean = false;
		
		public function CVector2dExt(maxX:int, maxY:int, aRemoveOnceOutOfRange:Boolean = false,  aTTT:CTimeToLive = null):void
		{
			RemoveOnceOutOfRange = aRemoveOnceOutOfRange;
			mTimeToLive = aTTT;
			setX(maxX);
			setY(maxY);
		}
		
		override public function update():void
		{
			super.update();
			mTime++;
			for (var i:int = 0; arr.length > i; i++)
			{
				if (arr[i].isActive())
				{
					if (arr[i].isDead())
					{
						arr[i].destroy();
					}
					else
					{
						arr[i].update();
					}
				}
			}
		}
		
		override public function render():void
		{
			super.render();
			for (var i:int = 0; arr.length > i; i++)
			{
				if (arr[i].isActive())
				{
					arr[i].render();
				}
				if (mTimeToLive != null)
				{
					if (mTimeToLive.mTime == mTime)
					{
						arr[i].destroy();
					}
				}
			}
		}
		
		//check automatically for collisions, objects must have setted their  shape, run update for all of the arr childs
		public function updateWithCollision(collisionObject:CGameObject, aMessageForFirstObject:Number, aMessageForSecondObject:Number):void
		{
			var x:int;
			var y:int;
			for (x = 0; x <= 3; x++)
			{
				for (y = 0; y <= 4; y++)
				{
					arr[x][y];
					
				}
			}
			
			if (collisionObject is CVectorExt)
			{
				var converted:CVectorExt = collisionObject as CVectorExt;
				
				for (var i:Number = 0; i < arr.length; i++)
				{
					if (arr[i].isActive())
					{
						var subCount:Number = 0;
						while (subCount < converted.arr.length)
						{
							//update this current object given its active
							arr[i].update();
							if (converted.arr[subCount].isActive())
							{
								if (converted.arr[subCount].getShape() == CShapes.CIRCLE && this.getShape() == CShapes.CIRCLE)
								{
									if (CMath.circleCircleCollision(arr[i].getCircle(), converted.arr[subCount].getCircle()))
									{
										converted.arr[subCount].sendMessage(aMessageForSecondObject);
										arr[i].sendMessage(aMessageForFirstObject);
									}
								}
								else if (converted.arr[subCount].getShape() == CShapes.SQUARE && this.getShape() == CShapes.CIRCLE)
								{
									if (CMath.rectCircCollision(arr[i].getCircle(), converted.arr[subCount].getRectangle()))
									{
										converted.arr[i].sendMessage(aMessageForSecondObject);
										arr[i].sendMessage(aMessageForFirstObject);
									}
								}
								else if (converted.arr[subCount].getShape() == CShapes.SQUARE && this.getShape() == CShapes.SQUARE)
								{
									if (CMath.rectRectCollision(converted.arr[subCount].getRectangle(), arr[i].getRectangle()))
									{
										converted.arr[i].sendMessage(aMessageForSecondObject);
										arr[i].sendMessage(aMessageForFirstObject);
									}
								}
							}
							subCount++;
						}
					}
				}
			}
			else
			{
				for (x = 0; x < arr.length; x++)
				{
					for (y = 0; y < arr[x].length; y++)
					{
						if (arr[x][y].isActive() && collisionObject.isActive())
						{
							//update this current object given its active 
							arr[x][y].update();
							
							if (collisionObject.getShape() == CShapes.CIRCLE && this.getShape() == CShapes.CIRCLE)
							{
								if (CMath.circleCircleCollision(arr[x][y].getCircle(), collisionObject.getCircle()))
								{
									collisionObject.sendMessage(aMessageForSecondObject);
									arr[x][y].sendMessage(aMessageForFirstObject);
								}
							}
							else if (collisionObject.getShape() == CShapes.SQUARE && this.getShape() == CShapes.CIRCLE)
							{
								if (CMath.rectCircCollision(arr[x][y].getCircle(), collisionObject.getRectangle()))
								{
									collisionObject.sendMessage(aMessageForSecondObject);
									arr[x][y].sendMessage(aMessageForFirstObject);
								}
							}
							else if (collisionObject.getShape() == CShapes.SQUARE && this.getShape() == CShapes.CIRCLE)
							{
								if (CMath.rectCircCollision(arr[x][y].getCircle(), collisionObject.getRectangle()))
								{
									collisionObject.sendMessage(aMessageForSecondObject);
									arr[x][y].sendMessage(aMessageForFirstObject);
								}
							}
							
						}
					}
					
				}
			}
		}
		
		public function checkIfRenderNeedBe(aUser:CGenericPlayer, aRangeRendering:Number):void
		{
			for (var i:int = 0; i < arr.length; i++)
			{
				inRange = arr[i].inRange(aUser, aRangeRendering, null);
				if (inRange)
				{
					if (!arr[i].isActive())
					{
						arr[i].activate();
						arr[i].redirect();
					}
				}
				else
				{
					if (arr[i].isActive())
					{
						arr[i].deactivate();
						
						if (RemoveOnceOutOfRange)
						{
							remove();
						}
					}
				}
			}
		}
		
		public function collides(collisionObject:CGameObject):CGenericGraphic
		{
			var i:int = 0;
			var tEnd:Boolean = false;
			var tCollidedObject:CGenericGraphic = null
			while (i < arr.length && !tEnd)
			{
				if (collisionObject.getShape() == CShapes.CIRCLE && this.getShape() == CShapes.CIRCLE)
				{
					// TODO: Corregir colisiones
					if (CMath.circleCircleCollision(arr[i].getCircle(), collisionObject.getCircle()))
					{
						tCollidedObject = arr[i];
						tEnd = true;
					}
				}
				else if (collisionObject.getShape() == CShapes.SQUARE && this.getShape() == CShapes.CIRCLE)
				{
					if (CMath.rectCircCollision(arr[i].getCircle(), collisionObject.getRectangle()))
					{
						tCollidedObject = arr[i];
						tEnd = true;
					}
				}
				else if (collisionObject.getShape() == CShapes.SQUARE && this.getShape() == CShapes.SQUARE)
				{
					if (CMath.rectRectCollision(arr[i].getRectangle(), collisionObject.getRectangle()))
					{
						tCollidedObject = arr[i];
						tEnd = true;
					}
				}
				i++;
			}
			return tCollidedObject;
		}
		
		public function getClosest(aGameObject:CGameObject):CGenericGraphic
		{
			var tDistance:Number = CMath.INFINITY;
			var closest:CGenericGraphic = null;
			var isConvertible:Boolean = false;
			for (var j:int = arr.length - 1; j >= 0; j--)
			{
				var tNewDist:Number = CMath.dist(arr[j].getX(), arr[j].getY(), aGameObject.getX(), aGameObject.getY());
				if (arr[j] is CGenericConvertible)
				{
					isConvertible = true;
				}
				if (!isConvertible)
				{
					if (tNewDist < tDistance)
					{
						tDistance = tNewDist;
						closest = arr[j];
					}
				}
				else
				{
					if (tNewDist < tDistance && !CGenericConvertible(arr[j]).isConverted())
					{
						tDistance = tNewDist;
						closest = arr[j];
					}
				}
				
			}
			return closest;
		}
		
		public function remove(objectToRemove:CGenericGraphic = null):void
		{
			if (objectToRemove != null)
			{
				var index:uint = arr.indexOf(objectToRemove);
				arr.splice(index, 1)[0].destroy();
			}
			else
			{
				if (arr.length > 0)
				{
					//logic dictates that the object  added is the first to go off the array as it is the first to leave the screen
					arr.shift().destroy();
				}
				else
				{
					throw RegExp("There is nothing to remove");
				}
			}
		}
		
		public function append(x:int, y:int, aGraphic:CGenericGraphic):void
		{
			arr[x][y] = aGraphic;
			setShape(aGraphic.getShape());
		}
		
		public function setTTT(aTimeToLive:CTimeToLive):void
		{
			mTimeToLive = aTimeToLive;
		}
		
		public function getTTT():CTimeToLive
		{
			return mTimeToLive;
		}
		
		public function getByName(aName:String):CGenericGraphic
		{
			for (var j:int = arr.length - 1; j >= 0; j--)
			{
				if (arr[j].getName() == aName)
				{
					return arr[j];
				}
			}
			throw RegExp("There are no objects with that name in the collection");
			
			return new Object();
		}
		
		public function getByGuid(aGuid:Number):CGenericGraphic
		{
			for (var j:int = arr.length - 1; j >= 0; j--)
			{
				if (arr[j].getGuid() == aGuid)
				{
					return arr[j];
				}
			}
			throw RegExp("There are no objects with that name in the collection");
			
			return new Object();
		}
	}

}