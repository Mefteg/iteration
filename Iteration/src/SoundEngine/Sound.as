package SoundEngine 
{
	import org.flixel.FlxSound;
	
	/**
	 * Class handling sound (Flixel as native platform)
	 * @author Alexandre Laurent
	 */
	public class Sound
	{
		private var m_sound:FlxSound // Internal sound instance
		
		/**
		 * Load the sound
		 * @param	sound
		 * @param	isLooping	true if the sound should loop when it's played
		 */
		/*
		public function Sound(sound:Class, isLooping:Boolean) 
		{
			m_sound = new FlxSound();
			m_sound.loadEmbedded(sound, isLooping);
		}
		*/
		
		/**
		 * Load the sound from file or URL
		 * @param	soundPath	the path to the file (or URL) to load
		 * @param	isLooping	true if the sound should loop when it's played
		 */
		public function Sound(soundPath:String, isLooping:Boolean) 
		{
			m_sound = new FlxSound();
			m_sound.loadStream(soundPath, isLooping);
		}
		
		/**
		 * Plays the sound
		 */
		public function play(volume:Number = 1):void
		{
			m_sound.play();
			m_sound.volume = volume;
		}
		
		/**
		 * Stops the sound
		 */
		public function stop():void
		{
			m_sound.stop();
		}
		
		/**
		 * Fades in (increase volume during time)
		 * @param	time the length of increase of the volume
		 */
		public function fadeIn(time:Number):void
		{
			m_sound.fadeIn(time);
		}
		
		/**
		 * Fades out (decrease volume during time)
		 * @param	time the length of decrease of the volume
		 */
		public function fadeOut(time:Number):void
		{
			m_sound.fadeOut(time);
		}
		
		/**
		 * Updates the sound (to apply the fading)
		 */
		public function update():void
		{
			m_sound.update();
		}
		
	}

}