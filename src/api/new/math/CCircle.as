package api.math
{
	
	/**
	 * ...
	 * @author Magestican
	 */
	public class CCircle
	{
		public var mRadious:int;
		public var mCenter:CVector3D;
		
		public function CCircle(aRadious:int = 0, aCenter:CVector3D = null)
		{
			if (aCenter == null)
			{
				mCenter = new CVector3D()
			}
			else
			{
				mCenter = aCenter;
			}
			mRadious = aRadious;
		}
	
	}

}