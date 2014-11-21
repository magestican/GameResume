package api.pathfinding 
{
	import api.CGame;
	import api.CGameObject;
	import api.math.CMath;
	import api.math.CVector3D;
	/**
	 * ...
	 * @author ...
	 */
	public class CPathFollowing 
	{
		private var mPathFinder:CAstar;
		private var mPath:Vector.<CNode>;
		private var mGrid:CGrid;
		private var mFollowPath:Boolean = false;
		private var mObject:CGameObject;
		private var mCurrentNode:int;
		private var mSpeed:Number;
		
		public function CPathFollowing(aGameObject:CGameObject)
		{
			mObject = aGameObject;
			mSpeed = 0;
			mPathFinder = new CAstar();
			mGrid = new CGrid(CGame.inst().getMap());
			mPath = new Vector.<CNode>();
		}
		
		public function setSpeed(aSpeed:Number):void
		{
			mSpeed = aSpeed;
		}
		
		public function findPath(aTarget:CVector3D):void
		{
			mGrid = new CGrid(CGame.inst().getMap());
			var tStart:CNode = mGrid.getNode(Math.floor(mObject.getX() / CGame.inst().getMap().getTileWidth()), Math.floor(mObject.getY() / CGame.inst().getMap().getTileHeight()));
			var tEnd:CNode = mGrid.getNode(Math.floor(aTarget.x / CGame.inst().getMap().getTileWidth()), Math.floor(aTarget.y / CGame.inst().getMap().getTileHeight()));
			mFollowPath = mPathFinder.findPath(mGrid, tStart, tEnd);
			mPath = mPathFinder.getPath();
			mCurrentNode = 0;
		}
		
		public function isFollowing():Boolean
		{
			return mFollowPath;
		}
		
		public function followPath():void
		{
			if (mFollowPath)
			{
				var tTarget:CVector3D = new CVector3D((mPath[mCurrentNode].x + 0.5) * CGame.inst().getMap().getTileWidth(), (mPath[mCurrentNode].y + 0.5) * CGame.inst().getMap().getTileHeight());
				mObject.setVel(tTarget.substract(mObject.getCenter()));
				mObject.getVel().normalize();
				mObject.getVel().mult(mSpeed);
				
				if (CMath.distanceBetweenPoints3D(mObject.getCenter(), tTarget) < CGame.inst().getMap().getTileWidth() * 0.25)
				{
					mCurrentNode++;
					if (mCurrentNode >= mPath.length)
					{
						mObject.stopMove();
						mFollowPath = false;
						mCurrentNode = 0;
					}
				}
			}
		}
		
	}

}