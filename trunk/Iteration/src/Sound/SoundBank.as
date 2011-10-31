package Sound 
{
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class SoundBank 
	{
		private var m_soundsBank:Array = new Array();
		
		public function SoundBank() 
		{

		}
		
		public function add(sound:Sound):void
		{
			m_soundsBank.push(sound);
		}
		
		public function update():void
		{
			for ( uint i = 0 ; i < m_soundsBank.length ; i++ )
			{
				(m_soundsBank[i] as Sound.Sound).update();
			}
		}
		
	}

}