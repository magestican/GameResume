package api.ai.behaviour
{
	import api.CGame;
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.CLayer;
	import api.enums.CDirection;
	import api.enums.CGraphicState;
	import api.math.CMath;
	import api.math.CVector2D;
	import api.math.CVector3D;
	import api.prefabs.CLine;
	import api.tileMap.CTile;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author magestican
	 */
	public class CMazeMovementBehaviour extends CGenericBehaviour
	{
		private var currentCell:CTile;
		private var previousCell:CTile;
		
		private var cantGoDown:Boolean = false;
		private var cantGoUp:Boolean = false;
		private var cantGoLeft:Boolean = false;
		private var cantGoRight:Boolean = false;
		
		private var line:CLine;
		private var mGameObject:CGameObject;
		private var mMap:Vector.<Vector.<CTile>> = new Vector.<Vector.<CTile>>();
		
		private var index:Number = 0;
		
		private var mDrawPath:Boolean = false;
		
		private const TILE_SPEED:int = 1;
		
		private var mLayer:CLayer;
		private var mTile:CTile = null;
		private var mOnReverse:Boolean = false;
		
		//the property to check to create a map
		private var mPropertyToCheck:String = "";
		
		public function CMazeMovementBehaviour(aMap:Vector.<Vector.<CTile>>, aGameObject:CGameObject, aDrawPath:Boolean = false, mDebugLayer:CLayer = null, aTerrainName:String = "")
		{
			mGameObject = aGameObject;
			mPropertyToCheck = aTerrainName;
			mDrawPath = aDrawPath;
			if (aMap == null || aMap.length == 0)
				throw RegExp("THE MAP IS INVALID");
			mMap = aMap;
			//this is inversed on purpose!
			mWalkingPath = new Vector.<int>;
			if (mDebugLayer != null)
			{
				mLayer = mDebugLayer;
			}
			else
			{
				mDrawPath = false;
			}
			calculatePath();
		
		}
		
		public function calculatePath():void
		{
			while (!cantGoDown || !cantGoUp || !cantGoLeft || !cantGoRight)
			{
				goSomewhere(CMath.randInt(0, 3));
			}
		}
		
		private var lastWalkingPath:int = 0;
		private var mtimes:int = 0;
		
		private function goSomewhere(whereToGo:int):void
		{
			//the ammount of times we havent moved anywhere
			if (mWalkingPath.length == lastWalkingPath && lastWalkingPath != 0)
			{
				if (mtimes > 50)
				{
					cantGoDown = true;
					cantGoUp = true;
					cantGoLeft = true;
					cantGoRight = true;
					return;
				}
				else
				{
					mtimes++;
				}
			}
			// in case the character is stuck, fix like this :
			else
			{
				if (mtimes > 100)
				{
					cantGoDown = true;
					cantGoUp = true;
					cantGoLeft = true;
					cantGoRight = true;
					return;
				}
				mtimes++;
			
			}
				
			if (whereToGo == CDirection.DOWN && !cantGoDown)
			{
				if (!goDown(mGameObject.getPos()))
				{
					//take a random direction
					goSomewhere(CMath.randInt(0, 3));
				}
			}
			else if (whereToGo == CDirection.LEFT && !cantGoLeft)
			{
				if (!goLeft(mGameObject.getPos()))
				{
					goSomewhere(CMath.randInt(0, 3));
				}
			}
			else if (whereToGo == CDirection.RIGHT && !cantGoRight)
			{
				
				if (!goRight(mGameObject.getPos()))
				{
					goSomewhere(CMath.randInt(0, 3));
				}
			}
			else if (whereToGo == CDirection.UP && !cantGoUp)
			{
				if (!goUp(mGameObject.getPos()))
				{
					goSomewhere(CMath.randInt(0, 3));
				}
			}
		
		}
		
		private function goDown(currentPosition:CVector3D):Boolean
		{
			//dont go outside the array
			if (mGameObject.getPos().x < mMap[0].length - TILE_SPEED)
			{
				var futureCell:CTile = mMap[currentPosition.x + TILE_SPEED][currentPosition.y];
				if (!futureCell.visited() && futureCell.getDynamicProperty(mPropertyToCheck))
				{
					currentCell = futureCell;
					mMap[currentPosition.x + TILE_SPEED][currentPosition.y].setVisited(true);
					mGameObject.getPos().x = currentPosition.x + TILE_SPEED;
					previousCell = mMap[currentPosition.x][currentPosition.y];
					if (mDrawPath)
						drawPath(previousCell, currentCell);
					//GOING DOWN MEANST GOING LEFT IN AN ARRAY
					mWalkingPath.push(CDirection.DOWN);
					lastWalkingPath++;
					cantGoDown = false;
					
					return true;
				}
				else
				{
					cantGoDown = true;
					return false;
				}
			}
			
			else
			{
				return false;
			}
		}
		
		private function goUp(currentPosition:CVector3D):Boolean
		{
			//dont go outside the array
			if (currentPosition.x > TILE_SPEED)
			{
				var futureCell:CTile = mMap[currentPosition.x - TILE_SPEED][currentPosition.y];
				if (!futureCell.visited() && futureCell.getDynamicProperty(mPropertyToCheck))
				{
					currentCell = futureCell;
					mMap[currentPosition.x - TILE_SPEED][currentPosition.y].setVisited(true);
					mGameObject.getPos().x = currentPosition.x - TILE_SPEED;
					previousCell = mMap[currentPosition.x][currentPosition.y];
					if (mDrawPath)
						drawPath(previousCell, currentCell);
					//GOING UP MEANS GOING LEFT IN AN ARRAY
					mWalkingPath.push(CDirection.UP);
					lastWalkingPath++;
					cantGoUp = false;
					return true;
				}
				else
				{
					cantGoUp = true;
					return false;
				}
			}
			
			else
			{
				return false;
			}
		}
		
		private function goLeft(currentPosition:CVector3D):Boolean
		{
			//dont go outside the array
			if (currentPosition.y > TILE_SPEED)
			{
				var futureCell:CTile = mMap[currentPosition.x][currentPosition.y - TILE_SPEED];
				if (!futureCell.visited() && futureCell.getDynamicProperty(mPropertyToCheck))
				{
					currentCell = futureCell;
					mMap[currentPosition.x][currentPosition.y - TILE_SPEED].setVisited(true);
					mGameObject.getPos().y = currentPosition.y - TILE_SPEED;
					previousCell = mMap[currentPosition.x][currentPosition.y];
					if (mDrawPath)
						drawPath(previousCell, currentCell);
					//GOING LEFT MEANS GOING UP IN AN ARRAY
					mWalkingPath.push(CDirection.LEFT);
					lastWalkingPath++;
					cantGoLeft = false;
					return true;
				}
				else
				{
					cantGoLeft = true;
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		private function goRight(currentPosition:CVector3D):Boolean
		{
			//dont go outside the array
			if (currentPosition.y < mMap.length - TILE_SPEED)
			{
				var futureCell:CTile = mMap[currentPosition.x][currentPosition.y + TILE_SPEED];
				if (!futureCell.visited() && futureCell.getDynamicProperty(mPropertyToCheck))
				{
					previousCell = mMap[currentPosition.x][currentPosition.y];
					currentCell = futureCell;
					mMap[currentPosition.x][currentPosition.y + TILE_SPEED].setVisited(true);
					mGameObject.getPos().y = currentPosition.y + TILE_SPEED;
					mGameObject.getPos().y = currentPosition.y + TILE_SPEED;
					
					if (mDrawPath)
						drawPath(previousCell, currentCell);
					mWalkingPath.push(CDirection.RIGHT);
					lastWalkingPath++;
					cantGoRight = false;
					return true;
				}
				else
				{
					cantGoRight = true;
					return false;
				}
			}
			
			else
			{
				return false;
			}
		}
		
		override public function update():void
		{
		
		}
		
		override public function render(aGraphic:CGenericGraphic):void
		{
			if (aGraphic != null)
			{
				if (aGraphic.getGraphicState() == CGraphicState.NONE)
				{
					//check we are within bonds
					if (mWalkingPath.length > 0 && mWalkingPathIndex <= mWalkingPath.length - 1)
					{
						var direction:int = mWalkingPath[mWalkingPathIndex];
						var currentTile:CTile = mTile;
						
						if (!mOnReverse)
						{
							currentTile = aGraphic.goToTile(direction, mTile);
							mWalkingPathIndex++;
						}
						else if (mOnReverse)
						{
							
							aGraphic.goToTile(CDirection.invertDirection(direction), mTile);
							if (mWalkingPathIndex >= 0)
							{
								if (mWalkingPathIndex == 0)
								{
									mOnReverse = false;
								}
								else
								{
									mWalkingPathIndex--;
								}
							}
						}
						mTile = currentTile;
					}
					if (mWalkingPathIndex == mWalkingPath.length)
					{
						mWalkingPathIndex--;
						mOnReverse = true;
					}
				}
			}
		}
		
		public function drawPath(aPreviousCell:CTile, aCurrentCell:CTile):void
		{
			line = new CLine(20, 0xFF0000);
			line.drawLine(new CVector2D(aPreviousCell.getX(), aPreviousCell.getY() - 20), new CVector2D(aCurrentCell.getX(), aCurrentCell.getY()));
			mLayer.addChild(line);
		}
		
		public function generateEmptyMap():void
		{
			var x:Number = 100;
			var y:Number = 100;
			//fill cells
			for (var i:int = 0; i < x; i++)
			{
				
				mMap[i] = new Vector.<CTile>();
				
				for (var r:int = 0; r < y; r++)
				{
					mMap[i][r] = new CTile();
					mMap[i][r].setX(i * 10);
					mMap[i][r].setY(r * 10);
				}
			}
		}
		
		public function getPath():Vector.<int>
		{
			return mWalkingPath;
		}
	
	}

}

