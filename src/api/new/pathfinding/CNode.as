package api.pathfinding 
{
	import api.CGame;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CNode 
	{
		public var x:int;
		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		private var mWalkable:Boolean;
		private var mParent:CNode;
		
		public function CNode(aX:int, aY:int) 
		{
			x = aX;
			y = aY;
		}
		
		public function isWalkable():Boolean
		{
			return mWalkable;
		}
		public function setWalkable(aWalkable:Boolean):void
		{
			mWalkable = aWalkable;
		}
		
		public function setParent(aNode:CNode):void
		{
			mParent = aNode;
		}
		public function getParent():CNode
		{
			return mParent;
		}
		
		public static function compare(x1:CNode, x2:CNode):Number
		{
			if (x1.f > x2.f)
				return 1;
			else if (x1.f < x2.f)
				return -1;
			else
				return 0;
		}
		
	}

}