package api
{
	import adobe.utils.CustomActions;
	import api.CCamera;
	import api.CGame;
	import api.CGameObject;
	import api.CHelper;
	import api.CLayer;
	import api.CMap;
	import api.enums.CDirection;
	import api.enums.CGraphicState;
	import api.enums.CShapes;
	import api.enums.CTerrains;
	import api.math.CCircle;
	import api.math.CMath;
	import api.math.CVector2D;
	import api.math.CVector3D;
	import api.tileMap.CTile;
	import flash.display.GraphicsTrianglePath;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import game.constants.CGameConstants;
	import game.management.Generics.CGenericPlayer;
	
	public class CGenericGraphic extends CGameObject
	{
		public var mOneTime:Boolean = true;
		public var mFirstTimeActive:Boolean = false;
		
		public var tilesTop:Vector.<CTile> = new Vector.<CTile>();
		public var tilesBottom:Vector.<CTile> = new Vector.<CTile>();
		public var tilesLeft:Vector.<CTile> = new Vector.<CTile>();
		public var tilesRight:Vector.<CTile> = new Vector.<CTile>();
		
		public var mAbsorptionPercentage:Number = 0;
		private var mOldX:int;
		private var mOldY:int;
		private var mOldVelY:Number;
		
		// Variables de checkPoints().
		private var downY:int; // Fila de abajo del jugador (en tiles).
		private var upY:int;
		private var leftX:int;
		private var rightX:int;
		private var floorY:int;
		private var tileTopLeft:CTile;
		private var tileTopRight:CTile;
		private var tileDownLeft:CTile;
		private var tileDownRight:CTile;
		
		//This will ignore collisions in the current floor
		private var mIgnoreRowFloor:int = -1;
		
		//setOldXYPosition(); 
		
		private var mReachedDestination:Boolean = false;
		
		private var mOffsetRange:int = 5;
		private var mDirection:CVector3D;
		private var mGraphicState:int = CGraphicState.NONE;
		private var mHorizontalPoints:Vector.<CVector3D> = new Vector.<CVector3D>();
		private var mVerticalPoints:Vector.<CVector3D> = new Vector.<CVector3D>();
		
		private function setOldXYPosition():void
		{
			mOldX = getX();
			mOldY = getY();
			mOldVelY = getVelY();
		}
		
		public function CGenericGraphic()
		{
			
		}
		
		public function enemyWasKilled():void
		{
			
		}
		
		public function inRange(aUser:CGenericPlayer, aRange:int, whatDistance:Object):Boolean
		{
			//create two circles and calculate if they are between range
			
			var playerRadious:int = 0;
			//pick what to use for range
			if (aUser.getShape() == CShapes.SQUARE)
			{
				if (aUser.getWidth() > aUser.getHeight())
				{
					playerRadious = aUser.getWidth();
				}
				else
				{
					playerRadious = aUser.getHeight();
				}
			}
			else
			{
				playerRadious = aUser.getRadious();
			}
			var userCircle:CCircle = new CCircle(playerRadious, new CVector3D(aUser.getX(), aUser.getY()));
			var graphicCircle:CCircle = new CCircle(aRange, new CVector3D(getX(), getY()));
			
			//PASS BY REF THE DISTANCE
			if (whatDistance != null)
			{
				whatDistance.length = CMath.distanceBetweenPoints3D(userCircle.mCenter, graphicCircle.mCenter);
			}
			
			var bb:Boolean = CMath.circleCircleCollision(userCircle, graphicCircle);
			userCircle = null;
			graphicCircle = null;
			
			return bb;
		}
		
		public function checkIfOutOfCamera():void
		{
			var cam:CCamera = CGame.inst().getCamera();
			var x:Number = getX();
			var y:Number = getY();
			
			if (getShape() == CShapes.CIRCLE)
			{
				if (x + getRadious() < cam.getX() - cam.getActiveOffset() || x - getRadious() > cam.getRightX() + cam.getActiveOffset() || y + getRadious() < cam.getY() - cam.getActiveOffset() || y - getRadious() > cam.getBottomY() + cam.getActiveOffset())
				{
					if (isActive())
						deactivate();
				}
				else
				{
					if (!isActive())
						activate();
				}
			}
			else if (getShape() == CShapes.SQUARE)
			{
				if (x + getWidth() < cam.getX() - cam.getActiveOffset() || x > cam.getRightX() + cam.getActiveOffset() || y + getHeight() < cam.getY() - cam.getActiveOffset() || y > cam.getBottomY() + cam.getActiveOffset())
				{
					if (isActive())
						deactivate();
				}
				else
				{
					if (!isActive())
						activate();
				}
			}
		}
		
		public function activate():void
		{
			setActive(true);
			if (getLayer() != null)
			{
				if (getMC() != null)
				{
					if (!getLayer().contains(getMC()))
					{
						//getMC().visible = true;
						getLayer().addChild(getMC());
					}
				}
				else if (getSprite() != null)
				{
					
					if (!getLayer().contains(getSprite()))
					{
						//sprt.visible = true;
						getLayer().addChild(getSprite());
					}
				}
				else if (getBmp() != null)
				{
					if (!getLayer().contains(getBmp()))
					{
						//sprt.visible = true;
						getLayer().addChild(getBmp());
					}
				}
			}
		}
		
		public function deactivate():void
		{
			setActive(false);
			
			if (getLayer() != null)
			{
				if (getMC() != null)
				{
					if (getLayer().contains(getMC()))
					{
						//getMC().visible = false;
						getLayer().removeChild(getMC());
					}
				}
				else if (getSprite() != null)
				{
					if (getLayer().contains(getSprite()))
					{
						//sprt.visible = false;
						getLayer().removeChild(getSprite());
					}
				}
				else if (getBmp() != null)
				{
					if (getLayer().contains(getBmp()))
					{
						//sprt.visible = true;
						getLayer().removeChild(getBmp());
					}
				}
			}
		}
		
		public function rotate(semiAngle:Number = 1):void
		{
			if (getMC() != null)
			{
				CMath.rotateAroundCenter(getMC(), super.getAngle() * semiAngle);
			}
			else if (getSprite() != null)
			{
				CMath.rotateAroundCenter(getSprite(), super.getAngle() * semiAngle);
			}
		}
		
		override public function update():void
		{
			if (getShape() == CShapes.NONE)
			{
				throw RegExp("You must set a shape for every graphic! Otherwhise it cannot collide.");
			}
			
			checkIfOutOfCamera();
			if (mGraphicState == CGraphicState.MOVINGTOWARDSPOINT)
			{
				if (CMath.circleCircleCollision(new CCircle(mOffsetRange, getPos()), new CCircle(mOffsetRange, mDirection)))
				{
					setGraphicState(CGraphicState.NONE);
					getVel().setXYZ(0, 0, 0);
				}
			}
			super.update();		
		}
		
		override public function render():void
		{
			super.render();
			if (getShape() == CShapes.NONE)
			{
				throw RegExp("You must set a shape for every graphic! Otherwhise it cannot collide");
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			if (getLayer() != null)
			{
				if (getMC() != null)
				{
					if (getLayer().contains(getMC()))
					{
						//sprt.visible = false;
						getLayer().removeChild(getMC());
					}
				}
				else if (getSprite() != null)
				{
					if (getLayer().contains(getSprite()))
					{
						//sprt.visible = false;
						getLayer().removeChild(getSprite());
					}
				}
			}
		}
		
		override public function setState(aNumber:Number):void
		{
			super.setState(aNumber);
		}
		
		// Calculate the coordinates of the points of this object in the map
		public function checkPoints(aX:int, aY:int):void
		{
			// Calcular las coordenadas de los puntos del jugador en el mapa.
			leftX = Math.floor((aX + getRegistryPoint().x) / CGame.inst().getMap().getTileWidth());
			rightX = Math.floor((aX + getRegistryPoint().x + getWidth() - 1) / CGame.inst().getMap().getTileWidth());
			upY = Math.floor((aY + getRegistryPoint().y) / CGame.inst().getMap().getTileHeight());
			downY = Math.floor((aY + getRegistryPoint().y + getHeight() - 1) / CGame.inst().getMap().getTileHeight());
			tileTopLeft = CGame.inst().getMap().getTile(leftX, upY);
			tileTopRight = CGame.inst().getMap().getTile(rightX, upY);
			tileDownLeft = CGame.inst().getMap().getTile(leftX, downY);
			tileDownRight = CGame.inst().getMap().getTile(rightX, downY);

			//var tileHeight:int = CGame.inst().getMap().getTileHeight();
			//var tileWidth:int = CGame.inst().getMap().getTileHeight();
			//
			//var horizontalPoints:int = getWidth() / tileWidth;
			//var verticalPoints:int = getHeight() / tileHeight;
			//
			//if (horizontalPoints >= 1 || verticalPoints >= 1)
			//{
				//if (getShape() == CShapes.SQUARE)
				//{
					//if (horizontalPoints == 1)
					//{
						//var asdsad:int = getHeight() / tileHeight;
					//}
					//if (verticalPoints > 1)
					//{
						//tilesBottom = getTiles(addHorizontalPoints(aX, aY + tileHeight * (verticalPoints - 1), horizontalPoints));
						//mHorizontalPoints = new Vector.<CVector3D>();
					//}
					//else
					//{
						//tilesBottom = getTiles(addHorizontalPoints(aX, aY, horizontalPoints));
						//mHorizontalPoints = new Vector.<CVector3D>();
					//}
					//if (horizontalPoints > 1)
					//{
						//tilesRight = getTiles(addVerticalPoints(aX + tileWidth * (horizontalPoints - 1), aY, verticalPoints));
						//mVerticalPoints = new Vector.<CVector3D>();
					//}
					//else
					//{
						//tilesRight = getTiles(addVerticalPoints(aX, aY, verticalPoints));
						//mVerticalPoints = new Vector.<CVector3D>();
					//}
					//
					//tilesTop = getTiles(addHorizontalPoints(aX, aY, horizontalPoints));
					//mHorizontalPoints = new Vector.<CVector3D>();
					//tilesLeft = getTiles(addVerticalPoints(aX, aY, verticalPoints));
					//mVerticalPoints = new Vector.<CVector3D>();
				//}
			//}
			//else
			//{
				//tilesBottom = getTiles(addHorizontalPoints(aX, aY + aY, horizontalPoints));
				//mHorizontalPoints = new Vector.<CVector3D>();
				//tilesTop = getTiles(addHorizontalPoints(aX, aY, horizontalPoints));
				//mHorizontalPoints = new Vector.<CVector3D>();
				//tilesRight = getTiles(addVerticalPoints(aX + aX, aY, verticalPoints));
				//mVerticalPoints = new Vector.<CVector3D>();
				//tilesLeft = getTiles(addVerticalPoints(aX, aY, verticalPoints));
				//mVerticalPoints = new Vector.<CVector3D>();
			//}
		}
		
		public function addHorizontalPoints(aX:int, aY:int, aHowManyPoints:int):Vector.<CVector3D>
		{
			if (aHowManyPoints > 0)
			{
				mHorizontalPoints.push(new CVector3D(aX, aY));
				addHorizontalPoints(aX + CGame.inst().getMap().getTileWidth(), aY, aHowManyPoints - 1);
			}
			return mHorizontalPoints;
		}
		
		public function addVerticalPoints(aX:int, aY:int, aHowManyPoints:int):Vector.<CVector3D>
		{
			if (aHowManyPoints > 0)
			{
				mVerticalPoints.push(new CVector3D(aX, aY));
				addVerticalPoints(aX, aY + CGame.inst().getMap().getTileHeight(), aHowManyPoints - 1);
			}
			return mVerticalPoints;
		}
		
		public function getTiles(aPoints:Vector.<CVector3D>):Vector.<CTile>
		{
			var tiles:Vector.<CTile> = new Vector.<CTile>();
			for (var i:int = 0; i < aPoints.length; i++)
			{
				var tile:CTile = CGame.inst().getMap().getTile((int)(aPoints[i].x / CGame.inst().getMap().getTileWidth()), (int)(aPoints[i].y / CGame.inst().getMap().getTileHeight()));
				tile.setDebug(true);
				tiles.push(tile);
			}
			return tiles;
		}

		public function isWallLeft(aX:int, aY:int):Boolean
		{
			checkPoints(aX, aY);
			return (!tileTopLeft.isWalkable() || !tileDownLeft.isWalkable());
		}
		
		public function isWallRight(aX:int, aY:int):Boolean
		{
			checkPoints(aX, aY);
			return (!tileTopRight.isWalkable() || !tileDownRight.isWalkable());
		}
		
		public function isWallBelow(aX:int, aY:int):Boolean
		{
			checkPoints(aX, aY);
			return (!tileDownLeft.isWalkable() || !tileDownRight.isWalkable ());
		}
		
		public function isWallAbove(aX:int, aY:int):Boolean
		{
			checkPoints(aX, aY);
			return (!tileTopLeft.isWalkable() || !tileTopRight.isWalkable());
		}

		
		//public function isWallLeft(aX:int, aY:int):Boolean
		//{
			//
			//checkPoints(aX + getOffset().x - getSpeed(), aY + getOffset().y);
			//if (inspectTiles(tilesLeft))
			//{
				//return true;
			//}
			//else
			//{
				//return false;
			//}
		//}
		//private var hardcodedOFFSET:int = 20;
		//
		//public function isWallRight(aX:int, aY:int):Boolean
		//{
			//checkPoints(aX + getOffset().x + getSpeed() + hardcodedOFFSET, aY + getOffset().y);
			//if (inspectTiles(tilesRight))
			//{
				//return true;
			//}
			//else
			//{
				//return false;
			//}
		//}
		//
		//public function isWallBelow(aX:int, aY:int):Boolean
		//{
			//checkPoints(aX + getOffset().x, aY + getOffset().y + getSpeed());
			//if (inspectTiles(tilesBottom))
			//{
				//return true;
			//}
			//else
			//{
				//return false;
			//}
		//}
		//
		//public function isWallAbove(aX:int, aY:int):Boolean
		//{
			//checkPoints(aX + getOffset().x, aY + getOffset().y - getSpeed());
			//if (inspectTiles(tilesTop))
			//{
				//return true;
			//}
			//else
			//{
				//return false;
			//}
		//}
		//
		public function inspectTiles(aTiles:Vector.<CTile>):Boolean
		{
			for (var i:int = 0; aTiles.length > i; i++)
			{
				//if false, iterate till the end
				if (!aTiles[i].getDynamicProperty(CTerrains.WALKABLE))
				{
					return true;
				}
			}
			return false;
		}
		
		//Move to the requested tile, you can pass the current tile the user is in, if the method detects its the same, it doesnt move you
		public function goToTile(aDirection:int, previousTile:CTile):CTile
		{
			
			var position:CVector3D;
			var tile:CTile;
			if (aDirection == CDirection.DOWN)
			{
				tile = getTileDown();
			}
			else if (aDirection == CDirection.UP)
			{
				tile = getTileUp();
			}
			else if (aDirection == CDirection.LEFT)
			{
				tile = getTileLeft();
			}
			else if (aDirection == CDirection.RIGHT)
			{
				tile = getTileRight();
			}
			
			//this is to check if the next tile is the current tile we are on
			if (previousTile != null && tile != null && getCurrentTile().getPos().x == tile.getPos().x && getCurrentTile().getPos().y == tile.getPos().y)
			{
				return previousTile;
			}
			//move to the next tile
			else
			{
				goToAndStop(tile.getCenter());
				return tile;
			}
		}
		
		public function goToAndStop(aWhereToGo:CVector3D):void
		{
			mReachedDestination = false;
			setGraphicState(CGraphicState.MOVINGTOWARDSPOINT);
			mDirection = aWhereToGo;
			
			lookAt(aWhereToGo.x, aWhereToGo.y);
			setVel(new CVector3D(1, 1, 0));
			getVel().setAngle(getAngle());
		}
		
		public function getTileDown():CTile
		{
			var height:int = CGame.inst().getMap().getTileHeight();
			var width:int = CGame.inst().getMap().getTileWidth();
			return CGame.inst().getMap().getTile((getPos().x / width), (getPos().y / height) + 1);
		}
		
		public function getTileLeft():CTile
		{
			var height:int = CGame.inst().getMap().getTileHeight();
			var width:int = CGame.inst().getMap().getTileWidth();
			return CGame.inst().getMap().getTile((getPos().x / width) - 1, (getPos().y / height));
		}
		
		public function getTileRight():CTile
		{
			var height:int = CGame.inst().getMap().getTileHeight();
			var width:int = CGame.inst().getMap().getTileWidth();
			return CGame.inst().getMap().getTile((getPos().x / width) + 1, (getPos().y / height));
		}
		
		public function getTileUp():CTile
		{
			var height:int = CGame.inst().getMap().getTileHeight();
			var width:int = CGame.inst().getMap().getTileWidth();
			return CGame.inst().getMap().getTile((getPos().x / width), (getPos().y / height) - 1);
		}
		
		public function getCurrentTile():CTile
		{
			var height:int = CGame.inst().getMap().getTileHeight();
			var width:int = CGame.inst().getMap().getTileWidth();
			return CGame.inst().getMap().getTile((getPos().x / width), (getPos().y / height));
		}
		
		public function getFutureTile(aDirection:int):CTile
		{
			var height:int = CGame.inst().getMap().getTileHeight();
			var width:int = CGame.inst().getMap().getTileWidth();
			if (aDirection == CDirection.DOWN)
			{
				return CGame.inst().getMap().getTile((getPos().x / width) - 2, (getPos().y / height));
			}
			else if (aDirection == CDirection.LEFT)
			{
				return CGame.inst().getMap().getTile((getPos().x / width), (getPos().y / height) - 2);
			}
			else if (aDirection == CDirection.RIGHT)
			{
				return CGame.inst().getMap().getTile((getPos().x / width), (getPos().y / height) + 2);
			}
			else if (aDirection == CDirection.UP)
			{
				return CGame.inst().getMap().getTile((getPos().x / width) + 2, (getPos().y / height));
			}
			
			return null;
		}
		
		public function setGraphicState(aGraphicState:int):void
		{
			if (aGraphicState == CGraphicState.MOVINGTOWARDSPOINT)
			{
				
			}
		}
		
		public function getGraphicState():int
		{
			return mGraphicState;
		}
	
	}
}