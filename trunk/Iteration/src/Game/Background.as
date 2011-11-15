package Game 
{
	import Game.Objects.Element;
	import Game.Objects.Planet;
	import Globals.GameParams;
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Tom
	 */
	public class Background
	{
		// protected var m_planet:Planet;
		
		private var m_backgroundSprite:FlxSprite;
		private var m_foregroundSprite:FlxSprite;
		
		private var m_camera:Camera;

		public function Background(camera:Camera) 
		{
			m_camera = camera;
			
			m_backgroundSprite = new FlxSprite(0, 0, null);
			m_backgroundSprite.loadGraphic2(SpriteResources.ImgBackground, false, false, 512, 512);
			m_foregroundSprite = new FlxSprite(0, 0, null);
			m_foregroundSprite.loadGraphic2(SpriteResources.ImgForeground, false, false, 1280, 720);
		}
		
		public function drawBackground():void 
		{
			for ( var i:int = -1; i < 6 ; i++ )
			{
				for ( var j:int = 0 ; j < 4 ; j++ )
				{
					m_backgroundSprite.x = 1000 + i * 512;
					m_backgroundSprite.y = j * 512;
					m_backgroundSprite.draw();
				}
			}
		}

		public function drawForeground():void 
		{
			m_foregroundSprite.x = m_camera.getPosition().x - GameParams.width / 2;
			m_foregroundSprite.y = m_camera.getPosition().y - GameParams.height / 2;
			m_foregroundSprite.draw();
		}
		
	}

}