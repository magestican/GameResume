package api
{
	import adobe.utils.CustomActions;
	import api.enums.CDirection;
	import api.math.CSpeed;
	import api.math.CVector2D;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class CHelper
	{
		public function CHelper()
		{
		}
		
		static public function removeDisplayObject(aDisplayObject:DisplayObject):void
		{
			if (aDisplayObject != null)
			{
				if (aDisplayObject.parent != null)
				{
					aDisplayObject.parent.removeChild(aDisplayObject);
				}
			}
		}
		
		static public function removeAllChildrenDisplayObject(aDisplayObjectContainer:DisplayObjectContainer):void
		{
			while (aDisplayObjectContainer.numChildren > 0)
			{
				if (aDisplayObjectContainer.getChildAt(0) is DisplayObjectContainer)
					CHelper.removeAllChildrenDisplayObject(aDisplayObjectContainer.getChildAt(0) as DisplayObjectContainer);
				trace("an object removed");
				aDisplayObjectContainer.removeChildAt(0);
			}
		}
		
		
		static public function pointToVector(aPoint:Point):CVector2D
		{
		    return new CVector2D(aPoint.x, aPoint.y);
		}
		
		public static function sortChildrenByY(aContainer:DisplayObjectContainer):void 
		{
			var i:int;
			var childList:Array = new Array();
			i = aContainer.numChildren;
			while (i--)
			{
				childList[i] = aContainer.getChildAt(i);
			}
			// TODO: Ordenar por gety() del game object (porque ya tiene sumada la z=altura).
			childList.sortOn("y", Array.NUMERIC);
			i = aContainer.numChildren;
			while (i--)
			{
				if (childList[i] != aContainer.getChildAt(i))
				{
					aContainer.setChildIndex(childList[i], i);
				}
			}
		}
		
		static public function MCtoSprites(mc:MovieClip):Vector.<Sprite>
		{
			var sprites:Vector.<Sprite> = new Vector.<Sprite>();
			
			var n:int = mc.totalFrames;
			for (var i:int = 1; i <= n; i++)
			{
				var s:Sprite = new Sprite();
				mc.gotoAndStop(i);
				
				var m:int = mc.numChildren;
				for (var j:int = 0; j < m; j++)
				{
					s.addChild(mc.getChildAt(0));
					sprites.push(s);
				}
			}
			return sprites;
		}
	
	}
}