package SoundEngine 
{
	import flash.utils.Dictionary;
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
		 * Gets back a sound present in the bank, identified by soundID (asserts if not found)
		 * @param	soundID the name (key) identifiying the sound
		 * @return	the sound
		 */
		public function get(soundID:String):Sound
		{
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