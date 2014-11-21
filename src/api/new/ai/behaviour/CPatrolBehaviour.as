package api.ai.behaviour 
{
	import api.CGame;
	import api.CGameObject;
	import api.math.CMath;
	import api.math.CVector3D;
	
	public class CPatrolBehaviour extends CGenericBehaviour 
	{
		private const CHANGE_CHANCE:int = 10;
		private const DIRS:Vector.<int> = new Vector.<int>();
		
		private var mRange:int = 3;
		
		private var mGameObject:CGameObject;
		private var mMap:Vector.<Vector.<int>>;
		private var mTileID:int;
		private var mPrevDir:int = 0;
		private var mCurPosX:int = -1;
		private var mCurPosY:int = -1;
		private var mLastPosX:int;
		private var mLastPosY:int;
		private var mTurning:Boolean;
		
		public function CPatrolBehaviour(aMap:Vector.<Vector.<int>>, aGameObject:CGameObject, aTileID:int) 
		{
			DIRS.push(1, 2, -1, 0);
			mGameObject = aGameObject;
			mMap = aMap;
			mTileID = aTileID;
			goSomeWhere(CMath.randInt(0, 3));
		}
		
		public function setRange(aRange:int):void
		{
			mRange = aRange;
		}
		
		private function getXPos():int
		{
			return Math.floor((mGameObject.getX() + mGameObject.getRegistryPoint().x + mGameObject.getWidth() * 0.5) / CGame.inst().getMap().getTileWidth());
		}
		private function getYPos():int
		{
			return Math.floor((mGameObject.getY() + mGameObject.getRegistryPoint().y + mGameObject.getHeight() * 0.5) / CGame.inst().getMap().getTileHeight());
		}
		
		private function getHPos(aX:int):int
		{
			return Math.floor(aX / CGame.inst().getMap().getTileWidth());
		}
		private function getVPos(aY:int):int
		{
			return Math.floor(aY / CGame.inst().getMap().getTileHeight());
		}
		
		private function canGo(aDir:int):Boolean
		{
			var tCanGo:Boolean = true;
			var i:int;
			
			if (aDir == 0)
			{
				for (i = 0; i < mRange; i++)
				{
					if (!isPath(getXPos(), getYPos() - i))
						tCanGo = false;
				}
			}
			else if (aDir == 1)
			{
				for (i = 0; i < mRange; i++)
				{
					if (!isPath(getXPos() + i, getYPos()))
						tCanGo = false;
				}
			}
			else if (aDir == 2)
			{
				for (i = 0; i < mRange; i++)
				{
					if (!isPath(getXPos(), getYPos() + i))
						tCanGo = false;
				}
			}
			else if (aDir == 3)
			{
				for (i = 0; i < mRange; i++)
				{
					if (!isPath(getXPos() - i, getYPos()))
						tCanGo = false;
				}
			}
			return tCanGo;
		}
		
		private function isPath(x:int, y:int):Boolean
		{
			if (x < 0 || y < 0 || x >= mMap[0].length || y >= mMap.length)
				return false;
			else
				return mMap[y][x] == mTileID;
		}
		
		private function goSomeWhere(aDir:int):void
		{
			var tNewPos:CVector3D = new CVector3D(getXPos(), getYPos());
			var tTimes:int = 0;
			var tFound:Boolean = false;
			if (aDir == 0 || aDir == 2)
			{
				if (canGo(1) && CMath.randInt(1, CHANGE_CHANCE) == 1)
				{
					tNewPos = new CVector3D(getXPos() + 3, getYPos());
					tFound = true;
					aDir = 1;
					mTurning = true;
				}
				else if (canGo(3) && CMath.randInt(1, CHANGE_CHANCE) == 1)
				{
					tNewPos = new CVector3D(getXPos() - 3, getYPos());
					tFound = true;
					aDir = 3;
					mTurning = true;
				}
			}
			else if (aDir == 1 || aDir == 3)
			{
				if (canGo(2) && CMath.randInt(1, CHANGE_CHANCE) == 1)
				{
					tNewPos = new CVector3D(getXPos(), getYPos() + 3);
					tFound = true;
					aDir = 2;
					mTurning = true;
				}
				else if (canGo(0) && CMath.randInt(1, CHANGE_CHANCE) == 1)
				{
					tNewPos = new CVector3D(getXPos(), getYPos() - 3);
					tFound = true;
					aDir = 0;
					mTurning = true;
				}
			}
			
			while (!tFound && tTimes < 4)
			{
				if (aDir == 0)
				{
					if (canGo(0))
					{
						tNewPos = new CVector3D(getXPos(), getYPos() - 1);
						tFound = true;
					}
				}
				else if (aDir == 1)
				{
					if (canGo(1))
					{
						tNewPos = new CVector3D(getXPos() + 1, getYPos());
						tFound = true;
					}
				}
				else if (aDir == 2)
				{
					if (canGo(2))
					{
						tNewPos = new CVector3D(getXPos(), getYPos() + 1);
						tFound = true;
					}
				}
				else if (aDir == 3)
				{
					if (canGo(3))
					{
						tNewPos = new CVector3D(getXPos() - 1, getYPos());
						tFound = true;
					}
				}
				if (!tFound)
				{
					aDir = (aDir + DIRS[tTimes]) % 4;
					tTimes++;
				}
			}
			
			if (!tFound)
			{
				// Go back to last position in path
				tNewPos.x = mLastPosX;
				tNewPos.y = mLastPosY;
			}
			else
			{
				mLastPosX = getXPos();
				mLastPosY = getYPos();
			}
			mCurPosX = getXPos();
			mCurPosY = getYPos();
			
			mPrevDir = aDir;
			tNewPos.x = (tNewPos.x + 0.5) * CGame.inst().getMap().getTileWidth();
			tNewPos.y = (tNewPos.y + 0.5) * CGame.inst().getMap().getTileHeight();
			setTarget(tNewPos);
		}
		
		override public function update():void 
		{
			// Only update if it moved to a different tile.
			if (mCurPosX != getXPos() || mCurPosY != getYPos())
			{
				if (!mTurning || (getHPos(getTarget().x) == getXPos() && getVPos(getTarget().y) == getYPos()))
				{
					mTurning = false;
					goSomeWhere(mPrevDir);
				}
			}
		}
	}

}