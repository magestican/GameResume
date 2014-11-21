package api 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CGenericAsset 
	{
		
		public function CGenericAsset() 
		{
			
		}
		
		
		public function getAssetByName(aAssetName:String) : Class
		{
			var found:* = this[aAssetName];
			if (found != null)
			{
				return this[aAssetName];
			}
			throw RegExp("The specified asset was not found by its name, the name is : " + aAssetName);
		}
		
	}

}