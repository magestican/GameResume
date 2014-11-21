package game.convertibles.buildings 
{
	import api.CLayer;
	import api.enums.CShapes;
	import api.math.CMath;
	import game.convertibles.CGenericConvertible;
	import game.convertibles.units.CMinion;
	import game.management.CGraphicsManager;
	/**
	 * ...
	 * @author freakRHO
	 */
	public class CBuildingConstruct extends CGenericConvertible
	{
		private const MINION_RATIO:Number = 0.09;
		private var mBuildings:Vector.<CBuilding>;
		private var mReleased:Boolean;
		private var mDoor:CBuilding;
		private var mChurch:Boolean;
		
		public function CBuildingConstruct(aChurch:Boolean=false) 
		{
			mChurch = aChurch;
			mReleased = false;
			setShape(CShapes.SQUARE);
			mBuildings = new Vector.<CBuilding>;
			CConstructManager.inst().addObject(this);
			setMaxConversion(0);
		}
		
		public function addBuilding(aBuilding:CBuilding):void
		{
			var tFound:Boolean = false;
			var i:int = 0;
			while(i < mBuildings.length && !tFound)
			{
				if (aBuilding == mBuildings[i])
					tFound = true;
				i++
			}
			if (!tFound)
			{
				mBuildings.push(aBuilding);
				setMaxConversion(getMaxConversion() + aBuilding.getMaxConversion());
				setConversion(getConversion() + aBuilding.getConversion());
				setCureRate(getCureRate() + aBuilding.getCureRate());
			}
		}
		
		public function setDoor(aDoor:CBuilding):void
		{
			mDoor = aDoor;
		}
		public function getDoor():CBuilding
		{
			return mDoor;
		}
		
		public function releaseMinions():void
		{
			if (!mChurch)
			{
				mReleased = true;
				var tMinion:CMinion;
				var tObjectsLayer:CLayer = CLayer.getLayerByName('objects');
				
				for (var i:int = 0; i < mBuildings.length * MINION_RATIO; i ++)
				{
					tMinion = new CMinion(tObjectsLayer);
					tMinion.setPosXYZ(CMath.randInt(mDoor.getX() - mDoor.getWidth(), mDoor.getX() + 2 * mDoor.getWidth()), CMath.randInt(mDoor.getY() + mDoor.getHeight() + tMinion.getHeight(), mDoor.getY() + 2 * mDoor.getHeight() + tMinion.getHeight()));
					tMinion.setConversion(tMinion.getMaxConversion());
					tMinion.setConverted(true);
					CGraphicsManager.getInstance().addMinion(tMinion);
				}
			}
		}
		
		public function convertBuilding(aConversionRate:int):void
		{
			if (isConverted())
				setConversion(getConversion() - aConversionRate);
			else
				setConversion(getConversion() + aConversionRate);

			for (var i:int = 0; i < mBuildings.length; i++)
			{
				if (mBuildings[i].isConverted())
					mBuildings[i].setConversion(Math.ceil(mBuildings[i].getConversion() - aConversionRate / mBuildings.length));
				else
					mBuildings[i].setConversion(Math.ceil(mBuildings[i].getConversion() + aConversionRate / mBuildings.length));
			}
		}
		
		override public function setConverted(aConverted:Boolean):void 
		{
			super.setConverted(aConverted);
			if (aConverted && !mReleased)
				releaseMinions();
			for (var i:int = 0; i < mBuildings.length; i++)
			{
				mBuildings[i].setConversion(mBuildings[i].getMaxConversion());
			}
		}
	}

}