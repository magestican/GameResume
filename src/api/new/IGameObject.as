package api 
{
	/**
	 * ...
	 * @author Magestican
	 */
	public interface IGameObject 
	{
		
		 function update():void;
		  function setState(aState:Number):void;
		function render():void;
		function destroy():void;
		
	}

}