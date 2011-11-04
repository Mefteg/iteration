package Game 
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class Camera 
	{
		private var m_initPos:FlxPoint;
		protected var m_posCam:FlxPoint = new FlxPoint(0, 0);
		protected var m_speedCam:int = 2;
		protected var m_zoomCam:Number = 0.05;
		
		public function Camera(startPos:FlxPoint, X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0, UpdateWorld:Boolean = false) 
		{
			// FlxG.camera.setBounds(X, Y, Width, Height, UpdateWorld);
			m_initPos = new FlxPoint(startPos.x, startPos.y);
			m_posCam.x = startPos.x;
			m_posCam.y = startPos.y;
		}
		
		public function update():void
		{
			// On replace la camÃ©ra
			if ( FlxG.mouse.screenX * FlxG.camera.zoom < 30 ) 
			{
				m_posCam.x -= m_speedCam;
			}
			if ( FlxG.mouse.screenX * FlxG.camera.zoom > FlxG.width - 30 ) 
			{
				m_posCam.x += m_speedCam;
			}
			if ( FlxG.mouse.screenY * FlxG.camera.zoom < 30 ) 
			{
				m_posCam.y -= m_speedCam;
			}
			if ( FlxG.mouse.screenY * FlxG.camera.zoom > FlxG.height - 30 ) 
			{
				m_posCam.y += m_speedCam;
			}
			FlxG.camera.focusOn(m_posCam);
			// On gÃ¨re le zoom
			if ( FlxG.keys.Z && FlxG.camera.zoom < 3 ) 
			{
				FlxG.camera.zoom += m_zoomCam;				
			}
			if ( FlxG.keys.S && FlxG.camera.zoom > 1 ) 
			{
				FlxG.camera.zoom -= m_zoomCam;
			}
			// On replace la camÃ©ra au centre de la planete
			if ( FlxG.keys.SPACE ) 
			{
				FlxG.camera.zoom = 1;
				m_posCam = m_initPos;
			}
		}
	}
}