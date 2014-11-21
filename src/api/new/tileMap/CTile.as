package api.tileMap
{
	import api.CGame;
	import api.CGameObject;
	import api.CGenericGraphic;
	import api.CHelper;
	import api.CLayer;
	import api.enums.CShapes;
	import api.prefabs.CRect;
	import flash.display.DisplayObject;
	import api.enums.CTerrains;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.engine.DigitWidth;
	import flash.utils.Dictionary;
	import game.constants.CGameConstants;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class CTile extends CGenericGraphic
	{
		private var mTileIndex:uint;
		private var mEmpty:Boolean;
		private var mVisited:Boolean = false;
		private var mWalkable:Boolean;
		private var mPlatform:Boolean;
		private var mHazard:Boolean; 
		private var mDebug:Boolean;
		private var mDynamicProperties:Dictionary = new Dictionary();
		private var debugRect:CRect =  new CRect(CGameConstants.TILE_WIDTH, CGameConstants.TILE_HEIGHT, 0xA982F2);
		
		public function CTile(aX:int = 0, aY:int = 0, aWidth:int = 0, aHeight:int = 0, aLayer:CLayer = null, aEmpty:Boolean = false)
		{
			mWalkable = true;
			setShape(CShapes.SQUARE);
			setWidth(aWidth);
			setHeight(aHeight);
			
			mEmpty = aEmpty;
			if (!mEmpty)
			{
				if (aLayer == null)
				{
					setWidth(aWidth);
				}
				mTileIndex = 0;
				setLayer(aLayer);
				activate();
			}
			
			setWidth(aWidth);
			setHeight(aHeight);
			
			setPosXYZ(aX, aY);
			
			
		}
		
		// Setters
		public function setTileIndex(aIndex:int):void
		{
			mTileIndex = aIndex;

			if (getMC() != null)
			{
				CHelper.removeDisplayObject(getMC());
			}
			if (getSprite() != null)
			{
				CHelper.removeDisplayObject(getSprite());
				setSprite(null);
			}
			
			var tGraphic:DisplayObject = CGame.inst().getMap().getTileSet().getTileByID(aIndex);
			
			if (tGraphic is MovieClip)
			{
				setMC(tGraphic as MovieClip);
				if (getLayer() == null)
				{
					setMC(tGraphic as MovieClip);
				}
				getLayer().addChild(getMC());
				getMC().cacheAsBitmap = true;
				getMC().x = getX();
				getMC().y = getY();
			}
			else if (tGraphic is Sprite)
			{
				setSprite(tGraphic as Sprite);
				getLayer().addChild(getSprite());
				getSprite().x = getX();
				getSprite().y = getY();
			}
		}
		
		// Getters
		public function getTileIndex():uint
		{
			return mTileIndex;
		}
		
		public function isFloor():Boolean
		{
			return mDynamicProperties[CTerrains.WALKABLE] || mDynamicProperties[CTerrains.PLATFORM];
		}
		
		public function isHazard():Boolean
		{
			return mHazard;
		}
		
		public function isWalkable():Boolean
		{
			return getDynamicProperty('walkable');
		}
		
		public function isEmpty():Boolean
		{
			return mEmpty;
		}
		
		override public function activate():void 
		{
			setActive(true);
			if (!mEmpty)
			{
				if (getMC() != null)
				{
					getLayer().addChild(getMC());
				}
				else if (getSprite() != null)
				{
					getLayer().addChild(getSprite());
				}
			}
		}
		
		override public function deactivate():void 
		{
			setActive(false);
			if (!mEmpty)
			{
				if (getMC() != null)
				{
					CHelper.removeDisplayObject(getMC());
				}
				else if (getSprite() != null)
				{
					CHelper.removeDisplayObject(getSprite());
				}
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		override public function render():void
		{
			super.render();
			if (!mEmpty)
			{
				if (isActive())
				{
					if (getMC() != null)
					{
						getMC().x = getX();
						getMC().y = getY();
					}
					else if (getSprite() != null)
					{
						getSprite().x = getX();
						getSprite().y = getY();
					}
					if (mDebug)
					{
						debugRect.x = getX();
						debugRect.y = getY();
						getLayer().addChild(debugRect);
					}
					else
					{
						if (CGame.inst().getStage().contains(debugRect))
						{
						     getLayer().removeChild(debugRect);
						}
						
					}
					mDebug = false;
				}
			}
		}
		
		
		public function setDebug(aDebug:Boolean):void
		{
			mDebug = aDebug;
		}
		
		public function setVisited(aVisited:Boolean):void
		{
			mVisited = aVisited;
		}
		
		public function visited():Boolean
		{
			return mVisited;
		}
		
		public function setDynamicProperty(index:String, value:Boolean):void
		{
			mDynamicProperties[index] = value;
		}
		
		public function getDynamicProperty(index:String):Boolean
		{
			if (mDynamicProperties[index] != null)
				return mDynamicProperties[index];
		    else
			{
				trace("property '" + index + "' doesnt exist at getDynamicProperty | tileIndex: " + getTileIndex().toString());
				return false;
			}
		}
	}
}