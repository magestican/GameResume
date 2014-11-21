package api.pathfinding 
{
	import api.tileMap.CTileMap;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CGrid 
	{
		private var mMap:CTileMap;
		private var mNodes:Vector.<Vector.<CNode>>;
		
		public function CGrid(aMap:CTileMap) 
		{
			mNodes = new Vector.<Vector.<CNode>>;
			mMap = aMap;
			for (var i:int = 0; i < mMap.getMapHeight(); i++)
			{
				var tRow:Vector.<CNode> = new Vector.<CNode>();
				for (var j:int = 0; j < mMap.getMapWidth(); j++)
				{
					var tNode:CNode = new CNode(j, i);
					tNode.setWalkable(mMap.getTile(j, i).isWalkable());
					tRow.push(tNode);
				}
				mNodes.push(tRow);
			}
		}
		
		public function getNode(aX:int, aY:int):CNode
		{
			if (aY < 0)
				aY = 0;
			else if (aY >= mNodes.length)
				aY = mNodes.length - 1;
			if (aX < 0)
				aX = 0;
			else if (aX >= mNodes[aY].length)
				aY = mNodes[aY].length - 1;
			return mNodes[aY][aX];
		}
		
		public function getWidth():int
		{
			return mMap.getMapWidth();
		}
		public function getHeight():int
		{
			return mMap.getMapHeight();
		}
		
	}

}