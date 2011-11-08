package Game 
{
	import Game.States.PlayState;
	import Globals.GameParams;
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
		protected var m_zoomCam:Number = 0.01;
		
		public var m_camera:FlxCamera;
		
		public function Camera(startPos:FlxPoint, X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0, UpdateWorld:Boolean = false) 
		{
			m_camera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
			m_camera.setBounds( -5000, -5000, 10000, 10000 );
			FlxG.addCamera(m_camera);
			FlxG.cameras.shift();

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
			if ( FlxG.keys.Z && GameParams.worldZoom < GameParams.worldZoomMax ) 
			{
				GameParams.worldZoom += m_zoomCam;
			}
			if ( FlxG.keys.S && GameParams.worldZoom > GameParams.worldZoomMin ) 
			{
				GameParams.worldZoom -= m_zoomCam;
			}
			// On replace la camera au centre de la planete
			if ( FlxG.keys.SPACE ) 
			{
				GameParams.worldZoom = GameParams.worldZoomMin;
				m_posCam = m_initPos;
			}
		}
	}
}