package 
{
	import Game.States.PlayState;
	import Globals.GameParams;
	import org.flixel.*;
	[SWF(width="1280", height="720", backgroundColor="#000000")]
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
			super(GameParams.width,GameParams.height,PlayState,1);
		}
		
	}
	
}