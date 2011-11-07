package Game 
{
	import org.flixel.FlxCamera;
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
		protected var m_speedCam:int = 4;
		protected var m_zoomCam:Number = 0.05;
		public var m_camera:FlxCamera;
		
		public function Camera(startPos:FlxPoint, X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0, UpdateWorld:Boolean = false) 
		{
			var zoom:Number = 0.3;
			//m_camera = new FlxCamera(0, 0, 640 / 2, 480, 1);
			//FlxG.addCamera(m_camera);
			m_camera = new FlxCamera(0, 0, FlxG.width + FlxG.width / zoom, FlxG.height + FlxG.height / zoom, zoom);
			m_camera.setBounds( -5000, -5000, 10000, 10000 );
			FlxG.addCamera(m_camera);
			FlxG.cameras.shift();
			trace(FlxG.cameras.length);
			//FlxG.camera.setBounds(X, Y, Width, Height, UpdateWorld);
			//FlxG.camera.setBounds( -5000, -5000, 10000, 10000, true);
			//FlxG.camera.zoom = 1;
			//FlxG.camera.width = 640;
			//FlxG.camera.height = 480;

			m_initPos = new FlxPoint(startPos.x, startPos.y);
			m_posCam.x = m_initPos.x;
			m_posCam.y = m_initPos.y;
		}
		
		public function update():void
		{
			// On replace la camera
			if ( FlxG.mouse.screenX * FlxG.camera.zoom < 30 || FlxG.keys.LEFT ) 
			{
				m_posCam.x -= m_speedCam;
			}
			if ( FlxG.mouse.screenX * FlxG.camera.zoom > FlxG.width - 30 || FlxG.keys.RIGHT ) 
			{
				m_posCam.x += m_speedCam;
			}
			if ( FlxG.mouse.screenY * FlxG.camera.zoom < 30 || FlxG.keys.UP ) 
			{
				m_posCam.y -= m_speedCam;
			}
			if ( FlxG.mouse.screenY * FlxG.camera.zoom > FlxG.height - 30 || FlxG.keys.DOWN ) 
			{
				m_posCam.y += m_speedCam;
			}
			m_camera.focusOn(m_posCam);
			// On gere le zoom
			if ( FlxG.keys.Z && m_camera.zoom < 1 ) 
			{
				m_camera.zoom += m_zoomCam;
			}
			if ( FlxG.keys.S && m_camera.zoom > 0.2 ) 
			{
				m_camera.zoom -= m_zoomCam;
			}
			// On replace la camera au centre de la planete
			if ( FlxG.keys.SPACE ) 
			{
				//FlxG.camera.zoom = 1;
				m_posCam = m_initPos;
			}
		}
	}
}