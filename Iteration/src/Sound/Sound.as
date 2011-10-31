package Sound 
{
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class Sound
	{
		private var m_sound:FlxSound
		
		public function Sound(sound:Class, isLooping:Boolean) 
		{
			m_sound = new FlxSound();
			m_sound.loadEmbedded(sound, isLooping);
		}
		
		public function play():void
		{
			m_sound.play();
		}
		
		public function stop():void
		{
			m_sound.stop();
		}
		
		public function fadeIn(time:Number):void
		{
			m_sound.fadeIn(time);
		}
		
		public function fadeOut():void
		{
			m_sound.fadeOut(time);
		}
		
		public function update():void
		{
			m_sound.update();
		}
		
	}

}