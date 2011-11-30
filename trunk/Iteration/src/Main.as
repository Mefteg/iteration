package 
{
	import flash.events.Event;
	import Game.States.*;
	import Globals.GameParams;
	import org.flixel.*;
	import org.flixel.plugin.TimerManager;
	[SWF(width="1280", height="720", backgroundColor="#000000")]
	/**
	 * ...
	 * @author Tom
	 */
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{			
			super(GameParams.width, GameParams.height, LoadState, 1);
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
		}
		
		override protected function create(FlashEvent:Event):void
        {
            super.create(FlashEvent);
            stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
        }
		
	}
	
}