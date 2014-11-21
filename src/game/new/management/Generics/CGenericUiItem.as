package game.management.Generics {
	import adobe.utils.CustomActions;
	import api.CGame;
	import api.CGameObject;
	import api.math.CVector2D;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author
	 */
	public class CGenericUiItem extends CGameObject
	{
		private var numberList:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		public var mPlayerScore:Number = 0;
		public var mMaximumScore:Number = 0;
		public var numbers:MovieClip = new MovieClip();
		public var mScoreLabel:TextField;
		public var mScoreLabelMc:MovieClip;
		
		public function CGenericUiItem()
		{
		
		}
		
		public function enemyWasKilled():void
		{
		}
		
		public function loadNumberList(aNumbers:MovieClip, howMany:Number):void
		{
			for (var index:int = 1; index <= howMany; index++)
			{
				aNumbers.gotoAndStop(index);
				numberList.push(aNumbers.getChildAt(0) as MovieClip);
			}
		}
		
		public function getNumber(number:Number):MovieClip
		{
			var mov:MovieClip = numberList[number].duplicateMovieClip(new MovieClip(), number.toString());
			//number:Vector.<Sprite> = new Vector.<Sprite>();
			return mov;
		}
		
		public function generateTextfield(textSize:Number, pos:CVector2D, size:CVector2D, border:Boolean):TextField
		{
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = textSize;
			myFormat.color = 0xC2C2FC;
			var myText:TextField = new TextField();
			myText.defaultTextFormat = myFormat;
			myText.border = border;
			myText.wordWrap = true;
			myText.width = size.x;
			myText.height = size.y;
			myText.x = pos.x;
			myText.y = pos.y;
			
			return myText;
		}
		
		public function createTextField(textSize:Number, size:CVector2D, border:Boolean):void
		{
			if (mScoreLabel == null)
			{
				var pos:Point = getMC().localToGlobal(new flash.geom.Point(getMC().x, getMC().y));
				mScoreLabel = generateTextfield(textSize, new CVector2D(pos.x, pos.y), size, border);
			}
		}
		
		public function getPlayerScore():Number
		{
			return mPlayerScore;
		}
		
		public function setPlayerScore(aScore:Number):void
		{
			mPlayerScore = aScore;
			if (mScoreLabel != null)
			{
				mScoreLabel.text = mPlayerScore.toString();
			}
			else if (mScoreLabelMc != null)
			{
				mScoreLabelMc.text = mPlayerScore.toString();
			}
		}
	
	}

}