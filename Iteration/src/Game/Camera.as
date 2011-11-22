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
		protected var m_speedCam:int = GameParams.map.zoomSpeed;
		protected var m_speedUpCam:int = GameParams.map.zoomSpeedUp;
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
			cameraMovement();
			cameraZoom();
			replaceCameraIfNecessary();
			
			// Place la camera à sa place
			m_camera.focusOn(m_posCam);
		}
		
		protected function cameraMovement():void {
			var tmp:Number;
			var speedWithZoom:Number = m_speedCam * (1 - (GameParams.map.zoomMin - GameParams.map.zoom) * m_speedUpCam);
			
			// On replace la camera
			tmp = m_posCam.x - speedWithZoom - (FlxG.width * (1 - GameParams.map.zoom - GameParams.map.zoomMin));
			//si je ne depasse pas la frontiere gauche
			if ( tmp > m_initPos.x - FlxG.width*0.5 ) 
			{
				if (FlxG.mouse.screenX * FlxG.camera.zoom < 30 || FlxG.keys.LEFT) {
					m_posCam.x -= speedWithZoom;
				}
			}
			//sinon
			else {
				m_posCam.x += (m_posPlanet.x - FlxG.width * 0.5) - tmp - speedWithZoom;
			}
			
			tmp = m_posCam.x + speedWithZoom + (FlxG.width * (1 - GameParams.map.zoom - GameParams.map.zoomMin));
			//si je ne depasse pas la frontiere droite
			if (  tmp < m_posPlanet.x + FlxG.width*0.5 ) 
			{
				if (FlxG.mouse.screenX * FlxG.camera.zoom > FlxG.width - 30 || FlxG.keys.RIGHT) {
					m_posCam.x += speedWithZoom;
				}
			}
			else {
				m_posCam.x -= tmp - (m_posPlanet.x + FlxG.width * 0.5);
			}
			
			tmp = m_posCam.y - speedWithZoom - (FlxG.height * (1 - GameParams.map.zoom - GameParams.map.zoomMin));
			//si je ne depasse pas la frontiere gauche
			if (  tmp > m_posPlanet.y - FlxG.height*0.5 ) 
			{
				if (FlxG.mouse.screenY * FlxG.camera.zoom < 30 || FlxG.keys.UP) 
				{
					m_posCam.y -= speedWithZoom;
				}
			}
			//sinon
			else {
				m_posCam.y += (m_posPlanet.y - FlxG.height*0.5) - tmp - speedWithZoom;
			}
			
			tmp = m_posCam.y + speedWithZoom + (FlxG.height * (1 - GameParams.map.zoom - GameParams.map.zoomMin));
			//si je ne depasse pas la frontiere inferieure
			if ( tmp < m_initPos.y + FlxG.height*0.5 ) 

			{
				if (FlxG.mouse.screenY * FlxG.camera.zoom > FlxG.height - 30 || FlxG.keys.DOWN) {
					m_posCam.y += speedWithZoom;
				}
			}
			else {
				m_posCam.y -= tmp - (m_initPos.y + FlxG.height*0.5);
			}
		}
		
		// Gere le zoom de la camera
		protected function cameraZoom():void {
			if ( (FlxG.keys.Z || FlxG.mouse.wheel > 0) && GameParams.map.zoom < GameParams.map.zoomMax ) 
			{
				if ( FlxG.mouse.wheel > 0 ) {
					GameParams.map.zoom += 4 * m_zoomCam;
				}
				else {
					GameParams.map.zoom += m_zoomCam;
				}
			}
			if ( (FlxG.keys.S || FlxG.mouse.wheel < 0) && GameParams.map.zoom > GameParams.map.zoomMin ) 
			{
				if ( FlxG.mouse.wheel < 0 ) {
					GameParams.map.zoom -= 4 * m_zoomCam;
				}
				else {
					GameParams.map.zoom -= m_zoomCam;
				}
			}
		}
		
		// Replace la camera a sa position d'origine si c'est necesaire
		protected function replaceCameraIfNecessary():void {
			// On replace la camera au centre de la planete
			if ( FlxG.keys.SPACE ) 
			{
				//GameParams.map.zoom = GameParams.map.zoomMin;
				//m_posCam = m_initPos;
				//m_posCam = m_posPlanet;
			}
		}
		
		public function setPosPlanet(pos:FlxPoint):void {
			m_posPlanet = pos;
		}
		
		public function getPosition():FlxPoint
		{
			return m_posCam;
		}
		
	}
}