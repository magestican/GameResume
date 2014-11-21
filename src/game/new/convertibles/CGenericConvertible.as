package game.convertibles
{
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.CHelper;
	import api.enums.CShapes;
	import api.prefabs.CRect;
	import game.constants.CGameConstants;
	import game.convertibles.units.CMinion;
	import game.convertibles.units.CPeasant;
	import game.CVars;
	import game.management.CGraphicsManager;
	
	public class CGenericConvertible extends CGenericGraphic
	{
		private const CONVERTED_COLOR:int = 0xFF0000;
		private const NOT_CONVERTED_COLOR:int = 0x0080C0;
		
		private var mConversion:int;
		private var mMaxConversion:int;
		private var mConverted:Boolean;
		private var mCureRate:int;
		private var mConvertRate:int;
		private var mRange:int;
		private var mTime:int;
		
		private var mConvertTime:int = 0;
		private var mBeingConverted:Boolean = false;
		private var mMinimapToken:CRect;
		
		public function CGenericConvertible()
		{
			mConversion = 0;
			mConverted = false;
			mTime = 0;
		}
		
		// Getters/Setters
		public function setMinimapToken(aRect:CRect):void
		{
			mMinimapToken = aRect;
			CVars.inst().getMinimap().addObject(this, mMinimapToken);
		}
		public function getMinimapToken():CRect
		{
			return mMinimapToken;
		}
		
		public function isBeingConverted():Boolean
		{
			return mBeingConverted;
		}
		
		public function isConverted():Boolean
		{
			return mConverted;
		}
		
		public function setConverted(aConverted:Boolean):void
		{
			mConverted = aConverted;
			if (mConverted)
			{
				if (getMinimapToken() != null)
					getMinimapToken().changeColor(CONVERTED_COLOR);
			}
			else
			{
				if (getMinimapToken() != null)
					getMinimapToken().changeColor(NOT_CONVERTED_COLOR);
			}
		}
		
		public function getConversion():int
		{
			return mConversion;
		}
		
		public function setConversion(aConversion:int):void
		{
			mConversion = aConversion;
		}
		
		public function setConvertRate(aConvertRate:int):void
		{
			mConvertRate = aConvertRate;
		}
		
		public function getConvertRate():int
		{
			return mConvertRate;
		}
		
		public function setCureRate(aCureRate:int):void
		{
			mCureRate = aCureRate;
		}
		
		public function getCureRate():int
		{
			return mCureRate;
		}
		
		public function setMaxConversion(aMaxConversion:int):void
		{
			mMaxConversion = aMaxConversion;
		}
		
		public function getMaxConversion():int
		{
			return mMaxConversion;
		}
		
		public function applyConversion(aConvertRate:int):void
		{
			mBeingConverted = true;
			if (isConverted())
				setConversion(getConversion() - aConvertRate);
			else
				setConversion(getConversion() + aConvertRate);
		}
		
		public function convert(aConvertible:CGenericConvertible):void
		{
			if (mConvertTime >= CGameConstants.CONVERSION_INTERVAL)
			{
				aConvertible.applyConversion(getConvertRate());
				mConvertTime = 0;
			}
			else
				mConvertTime++;
		}
		
		public function updateConversion():void
		{
			if (mConverted && mTime > CGameConstants.FPS * 0.5)
			{
				mConversion += mCureRate;
				mTime = 0;
			}
			else if (!mConverted && mTime > CGameConstants.FPS * 0.5)
			{
				mConversion -= mCureRate;
				mTime = 0;
			}
			
			if (mConversion >= mMaxConversion)
			{
				
				mConversion = mMaxConversion;
				if (!mConverted)
				{
					setConverted(true);
				}
			}
			else if (mConversion <= 0)
			{
				mConversion = 0;
				if (mConverted)
					setConverted(false);
			}
			mTime++;
		}
		
		override public function update():void
		{
			super.update();
			updateConversion();
			mBeingConverted = false;
		}
		
		override public function setState(aNumber:Number):void
		{
			super.setState(aNumber);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			CHelper.removeDisplayObject(mMinimapToken);
			mMinimapToken = null;
		}
	}

}