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
		protected var m_posPlanet:FlxPoint;
		
		public var m_camera:FlxCamera;
		
		public function Camera(startPos:FlxPoint, X:Number = 0, Y:Number = 0, Width:Number = 0, Height:Number = 0, UpdateWorld:Boolean = false) 
		{
			m_camera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
			//m_camera.setBounds( 0, 0, 1280, 720 );
			FlxG.addCamera(m_camera);
			FlxG.cameras.shift();

			m_initPos = new FlxPoint(startPos.x, startPos.y);
			m_posCam.x = m_initPos.x;
			m_posCam.y = m_initPos.y;
			
			GameParams.camera = m_camera;
		}
		
		public function update():void
		{
			trace("posPlanet: " + m_posPlanet.x + ", " + m_posPlanet.y);
			trace("initPos: " + m_initPos.x + ", " + m_initPos.y);

			cameraMovement();
			cameraZoom();
			replaceCameraIfNecessary();
			
			// Place la camera à sa place
			m_camera.focusOn(m_posCam);
		}
		
		protected function cameraMovement():void {
			var tmp:Number;
			
			// On replace la camera
			tmp = m_posCam.x - m_speedCam - (FlxG.width * (1 - GameParams.worldZoom - GameParams.worldZoomMin));
			//si je ne depasse pas la frontiere gauche
			if ( tmp > m_initPos.x - FlxG.width*0.5 ) 
			{
				if (FlxG.mouse.screenX * FlxG.camera.zoom < 30 || FlxG.keys.LEFT) {
					m_posCam.x -= m_speedCam;
				}
			}
			//sinon
			else {
				m_posCam.x += (m_posPlanet.x - FlxG.width * 0.5) - tmp;
			}
			
			tmp = m_posCam.x + m_speedCam + (FlxG.width * (1 - GameParams.worldZoom - GameParams.worldZoomMin));
			//si je ne depasse pas la frontiere droite
			if (  tmp < m_posPlanet.x + FlxG.width*0.5 ) 
			{
				if (FlxG.mouse.screenX * FlxG.camera.zoom > FlxG.width - 30 || FlxG.keys.RIGHT) {
					m_posCam.x += m_speedCam;
				}
			}
			else {
				m_posCam.x -= tmp - (m_posPlanet.x + FlxG.width * 0.5);
			}
			
			tmp = m_posCam.y - m_speedCam - (FlxG.height * (1 - GameParams.worldZoom - GameParams.worldZoomMin));
			//si je ne depasse pas la frontiere gauche
			if (  tmp > m_posPlanet.y - FlxG.height*0.5 ) 
			{
				if (FlxG.mouse.screenY * FlxG.camera.zoom < 30 || FlxG.keys.UP) {
					m_posCam.y -= m_speedCam;
				}
			}
			//sinon
			else {
				m_posCam.y += (m_posPlanet.y - FlxG.height*0.5) - tmp;
			}
			
			//si je ne depasse pas la frontiere inferieure
			if ( m_posCam.y + m_speedCam + (FlxG.height * (1 - GameParams.worldZoom - GameParams.worldZoomMin)) < m_initPos.y + FlxG.height*0.5 ) 
			{
				if (FlxG.mouse.screenY * FlxG.camera.zoom > FlxG.height - 30 || FlxG.keys.DOWN) {
					m_posCam.y += m_speedCam;
				}
			}
			else {
				m_posCam.y -= m_posCam.y + m_speedCam + (FlxG.height * (1 - GameParams.worldZoom - GameParams.worldZoomMin)) - (m_initPos.y + FlxG.height*0.5);
			}
		}
		
		// Gere le zoom de la camera
		protected function cameraZoom():void {
			if ( FlxG.keys.Z && GameParams.worldZoom < GameParams.worldZoomMax ) 
			{
				GameParams.worldZoom += m_zoomCam;
			}
			if ( FlxG.keys.S && GameParams.worldZoom > GameParams.worldZoomMin ) 
			{
				GameParams.worldZoom -= m_zoomCam;
			}
		}
		
		// Replace la camera a sa position d'origine si c'est necesaire
		protected function replaceCameraIfNecessary():void {
			// On replace la camera au centre de la planete
			if ( FlxG.keys.SPACE ) 
			{
				//GameParams.worldZoom = GameParams.worldZoomMin;
				//m_posCam = m_initPos;
				//m_posCam = m_posPlanet;
			}
		}
		
		public function setPosPlanet(pos:FlxPoint) {
			m_posPlanet = pos;
		}
	}
}