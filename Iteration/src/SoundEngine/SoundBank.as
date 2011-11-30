package SoundEngine 
{
	import flash.utils.Dictionary;
	import org.flixel.FlxSound;
	import Resources.SoundResources;
	import Utils.Debug;
	/**
	 * Banks for sound
	 * @author Alexandre Laurent
	 */
	public class SoundBank 
	{
		private var m_soundsBank:Dictionary = new Dictionary();
		private var m_updateBank:Array = new Array();
		
		/**
		 * Add a new sound in the bank
		 * @param	sound
		 * @param	soundID the identifier is unique
		 */
		public function add(sound:Sound,soundID:String):void
		{
			Debug.assert(sound);
			m_soundsBank[soundID] = sound;
			m_updateBank.push(sound);
		}
		
		/**
		 * Loads and adds a new sound in the bank
		 * The filename is used as key
		 * @param	soundPath the file to load (can be an URL)
		 * @param	loop true if the song should loop
		 */
		public function load(soundPath:String,loop:Boolean):void
		{
			m_soundsBank[soundPath] = new Sound(soundPath,loop);
			m_updateBank.push(m_soundsBank[soundPath]);
		}
		
		/**
		 * Gets back a sound present in the bank, identified by soundID (asserts if not found)
		 * @param	soundID the name (key) identifiying the sound
		 * @return	the sound
		 */
		public function get(soundID:String):Sound
		{
			if ( soundID == SoundResources.rainSound )
			{
				var rainSound:FlxSound = new FlxSound();
				rainSound.loadStream(soundID, false, true);
				rainSound.play();
				return m_soundsBank[soundID];
			}
			Debug.assert(m_soundsBank[soundID]);
			return m_soundsBank[soundID];
		}
		
		/**
		 * Updates the sounds registered in the bank
		 */
		public function update():void
		{
			var i:uint = 0;
			for ( i = 0 ; i < m_updateBank.length ; i++ )
			{
				(m_updateBank[i] as Sound).update();
			}
		}
		
	}

}