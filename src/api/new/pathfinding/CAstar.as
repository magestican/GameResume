package api.pathfinding 
{
	import api.CGame;
	import api.tileMap.CMapLayer;
	import api.tileMap.CTileMap;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CAstar 
	{
		private var mStraightCost:Number = 1;
		private var mDiagCost:Number = Math.sqrt(2);
		
		private var mOpen:Vector.<CNode>;
		private var mClosed:Vector.<CNode>;
		private var mEndNode:CNode;
		private var mStartNode:CNode;
		private var mPath:Vector.<CNode>;
		private var mGrid:CGrid;
		
		public function CAstar() 
		{
			
		}
		
		public function findPath(aGrid:CGrid, aStart:CNode, aEnd:CNode):Boolean
		{
			mOpen = new Vector.<CNode>();
			mClosed = new Vector.<CNode>();
			
			mGrid = aGrid;
			mStartNode = aStart;
			mEndNode = aEnd;
			
			mStartNode.g = 0;
			mStartNode.h = heuristic(mStartNode);
			mStartNode.f = mStartNode.g + mStartNode.h;
			
			mOpen.push(mStartNode);
			mPath = new Vector.<CNode>();
			//Debug
			//CDebugManager.inst().flushObjects();
			return search();
		}
		
		private function search():Boolean
		{
			var tCurNode:CNode = mOpen[0];
			while (tCurNode != mEndNode)
			{
				if (mOpen.length == 0)
					return false;
				mOpen.sort(CNode.compare);
				tCurNode = mOpen[0];
				
				var tStartX:int = Math.max(0, tCurNode.x - 1);
				var tEndX:int = Math.min(mGrid.getWidth() - 1, tCurNode.x + 1);
				var tStartY:int = Math.max(0, tCurNode.y - 1);
				var tEndY:int = Math.min(mGrid.getHeight() - 1, tCurNode.y + 1);
				
				for (var i:int = tStartX; i <= tEndX; i++)
				{
					for (var j:int = tStartY; j <= tEndY; j++)
					{
						var tNextNode:CNode = mGrid.getNode(i, j);
						if (tNextNode != tCurNode &&
							tNextNode.isWalkable() &&
							mGrid.getNode(tCurNode.x, tNextNode.y).isWalkable() &&
							mGrid.getNode(tNextNode.x, tCurNode.y).isWalkable())
						{
							var tCost:Number = mStraightCost;
							if (!((tNextNode.x == tCurNode.x) || (tNextNode.y == tCurNode.y)))
								tCost = mDiagCost;
								
							var g:Number = tCurNode.g + tCost;
							var h:Number = heuristic(tNextNode);
							var f:Number = g + h;
							if (isOpen(tNextNode) || isClosed(tNextNode))
							{
								if (tNextNode.f > f)
								{
									tNextNode.g = g;
									tNextNode.h = h;
									tNextNode.f = f;
									tNextNode.setParent(tCurNode);
								}
							}
							else
							{
								tNextNode.g = g;
								tNextNode.h = h;
								tNextNode.f = f;
								tNextNode.setParent(tCurNode);
								mOpen.push(tNextNode);
								// Debug
								//var tTarget:CDebugTarget = new CDebugTarget(0x808080, CLayerManager.inst().getLayerByName('debug'));
								//tTarget.setXYZ((tNextNode.x + 0.5) * CGame.inst().getMap().getTileWidth(), (tNextNode.y + 0.5) * CGame.inst().getMap().getTileHeight());
								//CDebugManager.inst().addObject(tTarget);
							}
						}
					}
				}
				mClosed.push(tCurNode);
				mOpen.splice(0, 1);
			}
			mPath = formPath(tCurNode, mPath);
			mPath.reverse();
			return true;
		}
		
		private function isOpen(aNode:CNode):Boolean
		{
			return mOpen.indexOf(aNode) != -1;
		}
		
		private function isClosed(aNode:CNode):Boolean
		{
			return mClosed.indexOf(aNode) != -1;
		}
		
		private function formPath(aNode:CNode, aPath:Vector.<CNode>):Vector.<CNode>
		{
			aPath.push(aNode);
			if (aNode == mStartNode)
				return aPath;
			else
				return formPath(aNode.getParent(), aPath);
		}
		
		
		private function heuristic(aNode:CNode):Number
		{
			return Math.sqrt((mEndNode.x - aNode.x) * (mEndNode.x - aNode.x) + (mEndNode.y - aNode.y) * (mEndNode.y - aNode.y));
		}
		
		public function getPath():Vector.<CNode>
		{
			return mPath;
		}
	}

}