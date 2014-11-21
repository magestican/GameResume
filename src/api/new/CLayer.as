package api 
{
	import adobe.utils.CustomActions;
	import api.CGame;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Magestican
	 */
	
	public class CLayer extends MovieClip
	{
		public static var masterLayer:Sprite = new Sprite();
		public static var layers:Vector.<MovieClip> = new Vector.<MovieClip>();
		private static var lastIndex:int = 0;
		public var mIndex:int = 0;
		public var mName:String = ""; 
		private static var initialized:Boolean = false;
		
		public function CLayer() 
		{
		
		}
		
		public static function init():void
		{
			masterLayer.mouseEnabled = false;
			CGame.inst().getContainer().addChild(masterLayer);
			initialized = true;
		}
		
		public static function addLayer(name:String = "noName", noMaster:Boolean=false):CLayer
		{
			if (!initialized)
			{
				init();
			}
			
			var layer:CLayer = new CLayer();
			
			layers.push(layer);
			layer.mName = name;
			layer.mIndex = lastIndex;
			
			if (!noMaster)
				masterLayer.addChild(layer);
			else
				CGame.inst().getContainer().addChild(layer)
			layer.mouseEnabled = false;
			lastIndex++;
			return layer;
		}
		
		public static function refreshLayers():void
		{
			CGame.inst().getContainer().removeChild(masterLayer);
			CGame.inst().getContainer().addChild(masterLayer);
		}
		
		public function removeLayer():void
		{
			CGame.inst().getContainer().removeChild(masterLayer);
			masterLayer.removeChild(layers[this.mIndex]);
			CGame.inst().getContainer().addChild(masterLayer);
		}
		
		public static function getLayerByName(name:String):CLayer
		{
			for each(var lay:CLayer in CLayer.layers)
			{
				if (lay.mName == name)
				{
					return lay;
				}
			}
			//throw RegExp("Layer does not exist");
			return null;
		}
		
	}

}