package Game.Objects
{
	import flash.geom.Point;
	import Globals.GameParams;
	import org.flixel.*;
	import org.flixel.system.input.Mouse;
	import Utils.MathUtils;
	/**
	 * ...
	 * @author ...
	 */
	public class Element extends FlxSprite
	{
		protected var m_pos: Number = 0; //position sur le cercle représentant la planète
		protected var m_direction:int = 0; //variable de mouvement; 0:stationnaire, 1:a droite; 2:a gauche
		protected var m_distance:Number = 0; //éloignement par rapport au centre de la planete
		
		public var m_speed:Number = 0.1; // vitesse de déplacement
		public var m_dead:Boolean = false; // mort du sprite
		
		public var m_planet:Planet; // référence vers la planete pour diverses raisons
		
		protected var m_state:String; // Etat de l'élément
		
		// Sound related stuff
		private var m_soundName:String;	// The name of the sound to play 
		private var m_soundZoomLevel:Number;
		
		// params : pos = angle par rapport au cerlcle de la planete 
		//			distance = distance par rapport au centre de la planete
		//			planet = ben... la reference vers la planete quoi
		public function Element(pos:Number, distance:Number , planet:Planet ) 
		{
			super(x, y);
			m_planet = planet ;
			m_distance = distance;
			m_pos = pos;
		}
		
		override public function update():void {
			if (!visible) return;
			super.update();
			
			scale = new FlxPoint(GameParams.map.zoom,GameParams.map.zoom);
		}
		
		override public function draw():void {
			if (!visible) return;
			super.draw();
		}
				
		//place un élément en calculant sa position par rapport a la planete
		public function place():void 
		{
			//conversion en radians de l'angle de position sur le cercle(planete)
			var angle:Number = (Math.PI / 180) * m_pos ;

			x = m_planet.center().x + Math.cos(angle) * (m_distance)* GameParams.map.zoom - this.width /2;
			y = m_planet.center().y - Math.sin(angle) * (m_distance)* GameParams.map.zoom - this.height/2;
		}
		
		//effectue une rotation pour placer le bas du sprite sur la surface de la planete
		public function rotateToPlanet() :void{
			this.angle = -m_pos + 90;
		}
		
		public function onClick():Boolean 
		{
			if ( FlxG.mouse.justPressed() )
			{
				//si click de la souris
				var mouseVar:Mouse = FlxG.mouse;
				var mouseX:int = FlxG.mouse.getWorldPosition(GameParams.camera).x;
				var mouseY:int = FlxG.mouse.getWorldPosition(GameParams.camera).y;
				
				//if ( pixelsOverlapPoint(new FlxPoint(mouseX, mouseY), 0xFF, GameParams.camera) )
				if ( Point.distance(new Point(mouseX, mouseY), new Point(x + width / 2, y + height / 2)) < Math.min(height,width)/4 )
				{
					return true;
				}
			}
			
			return false;
		}
		
		override public function destroy():void {
			super.destroy();
			m_planet = null;
			m_dead = true;
			this.kill();
		}
		
		public function setPos(pos:Number):void {
			m_pos = pos;
		}
		
		public function getPos():Number {
			return m_pos;
		}
		
		public function setDistance(distance:Number) :void{
			m_distance = distance;
		}
		
		public function getDistance():Number 
		{
			return m_distance;
		}
		
		public function setState(state:String):void {
			m_state = state;
		}
		
		public function getState():String {
			return m_state;
		}
		
		public function getPlanet():Planet {
			return m_planet;
		}
		
		public function animIsFinished():Boolean {
			return _curIndex == _curAnim.frames.length - 1 ;
		}
		
		public function setScale(value:FlxPoint):void {
			scale = value;
		}
	
	}

}