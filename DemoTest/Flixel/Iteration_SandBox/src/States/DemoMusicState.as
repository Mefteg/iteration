package States 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class DemoMusicState extends FlxState 
	{
		
	
		[Embed(source = "../../bin/sfx/music1.mp3")] private var backgroundMusic:Class
		[Embed(source = "../../bin/sfx/music2.mp3")] private var foregroundMusic:Class
		
		private var m_backgroundMusic:FlxSound = new FlxSound();
		private var m_foregroundMusic:FlxSound = new FlxSound();
		
		public function DemoMusicState()
		{			
			m_backgroundMusic.loadEmbedded(backgroundMusic,true);
			m_foregroundMusic.loadEmbedded(foregroundMusic,true);
		}
		
		override public function create():void 
		{
			m_backgroundMusic.play(true);
		}
		
		override public function update():void 
		{
			super.update();
			
			if ( FlxG.keys.justReleased("SPACE") )
			{
				m_foregroundMusic.volume = 0.5;
				m_foregroundMusic.play(true);
			}
			
			if ( FlxG.keys.justReleased("A") )
			{
				if ( m_foregroundMusic.volume < 1.0 )
				{
					m_foregroundMusic.volume += 0.05;
				}
			}
			
			if ( FlxG.keys.justReleased("B") )
			{
				if ( m_foregroundMusic.volume > 0.0 )
				{
					m_foregroundMusic.volume -= 0.05;
				}
			}
			
			if ( FlxG.keys.justReleased("C") )
			{
				m_foregroundMusic.fadeOut(5, true);
			}
			
			if ( FlxG.keys.justReleased("D") )
			{
				m_foregroundMusic.fadeIn(5);
			}
			
			m_backgroundMusic.update();
			m_foregroundMusic.update();
		}
	}

}