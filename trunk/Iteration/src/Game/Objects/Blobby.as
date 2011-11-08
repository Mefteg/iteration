package Game.Objects
{
	import flash.geom.Point;
	import Game.Ideas.Idea;
	import Game.NewSprite;
	import Globals.GameParams;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	import Utils.MathUtils;
	
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Blobby extends Element
	{		
		//SPRITES
		protected var m_spriteCurrent:NewSprite;
		protected var m_spriteWalk:NewSprite;
		protected var m_spriteIdle:NewSprite;
		protected var m_spriteDiscuss:NewSprite;
		
		//timer pour le mouvement
		protected var m_timerMove:FlxTimer;
		//idée
		protected var m_idea:Idea;
		//timer pour la discussion
		protected var m_timerDiscuss:FlxTimer;
		protected var m_discussTime:Number = 5;
		
		protected var m_blobTarget:Blobby;
		
		public function Blobby(pos:Number, distance:Number , planet:Planet) 
		{
			super(pos, distance, planet);
			scale = new FlxPoint(GameParams.worldZoom, GameParams.worldZoom);
			//tailles du blobby
			this.width = 300; this.height = 300;
			//instancier le timer de discussion
			m_timerDiscuss = new FlxTimer();
			m_speed = 0.2;
			//instancier le timer de mouvement
			m_timerMove = new FlxTimer();
			m_timerMove.start(1);
			//Diminuer les ressources
			m_planet.removeResources(100);
			m_distance += 43;
						
			//initialisation de l'animation
			m_state = "walk";
			
			place();			
		}
		
		public function setAnimations(walk:NewSprite, idle:NewSprite, disc:NewSprite) : void {
			m_spriteWalk = walk;
			m_spriteIdle = idle;
			m_spriteDiscuss = disc;
			m_spriteCurrent = m_spriteWalk;
		}
		override public function update():void 
		{
			//mettre a jour le sprite courant
			m_spriteCurrent.update();
			
			switch( m_state ) {
				case("walk"):
					walk();
					break;
				case("search"):
					search();
					break;
				case("discuss"):
					discuss();
					break;
				case("validate"):
					validate();
					break;
				case("idle"):
					idle();
					break;
				case("die"):
					die();
					return;
					break;
				case("duplicate"):
					break;
				case("eat"):
					eat();
					break;
				default:
					break;
			}
			
			// placer le blobby
			place();
			//rotation pour mettre le bas du sprite sur la surface de la planete
			rotateToPlanet();
			//afficher
			super.update();
		}
		
		protected function walk() :void{
			changeDirection();
		}
		
		protected function idle():void {
			changeDirection();
		}
		protected function eat() :void{
			changeDirection();
		}
				
		protected function discuss() :void {
			if (m_timerDiscuss.finished) {
				setState("validate");
				m_blobTarget.setState("validate");
			}
		}
		
		private function validate():void {
			if (animIsFinished()) {
				if(m_blobTarget){
					//remettre les états des deux blobs
					setState("idle");
					m_blobTarget.setState("idle");
					//l'idée est diffusée
					m_idea.setState("spread");
					//vider la variable d'idée
					m_idea = null;
					//changer le sprite
					color = 0x0080FF;
					m_blobTarget.color = 0x0080FF;
				}
			}
		}
		
		public function search():void {
			if ( collideWithBlobby(m_blobTarget) ) {
				//changer les états des deux blobby en "discussion"
				m_blobTarget.setState("discuss");
				this.setState("discuss");
				//démarrer le timer de discussion
				m_timerDiscuss.start(m_discussTime);
			}
			//si le blobby cible est mort, en chercher un autre
			if (m_blobTarget.getState() =="die")
				searchNearestBlobby();
			
			/*
			var v1:Point = new Point(x - m_planet.center().x, y - m_planet.center().y);
			var v2:Point = new Point(m_blobTarget.x - m_planet.center().x, m_blobTarget.y - m_planet.center().y);
			var det:Number = MathUtils.det(v1, v2);
			if (det > 0) {
				m_pos -= m_speed;
			}else {
				m_pos += m_speed;
			}
			*/
			if ( ((this.m_pos + 180) % 360) - ((m_blobTarget.m_pos + 180) % 360) < 0 )
			{
				m_pos += m_speed;
			}
			else 
			{
				m_pos -= m_speed;
			}
			m_idea.update();
		}
		
		public function die():void {
			this.destroy();
		}
		
		public function changeDirection():void 
		{
			//si le timer est toujours en cours
			if (! m_timerMove.finished) {
				//bouger le sprite
				switch(m_direction) {
					case 0: break;
					case 1: m_pos += m_speed; break;
					case 2: m_pos -= m_speed; break;
					default:break;
				}
				//s'arrêter là
				return;
			}
			//sinon on réinitialise le compteur avec une direction aléatoire
			var rand:Number = Math.random();
			
			if (rand < .5) {
				m_direction = 0;
				setState("idle");
			}else if (rand < .75) {
				m_direction = 1;
				setState("walk");
			}else {
				m_direction = 2;
				setState("walk");
			}
			
			m_timerMove.start(FlxU.srand(rand)*4 +0.5); //définir un temps aléatoire de déplacement de l'objet
		}
		
		override public function destroy():void 
		{
			m_blobTarget = null;
			//si il possédait une idée, la killer
			if (m_idea)
				m_idea.setState("killed");
			//ajouter des ressources a la planete
			m_planet.addResources(80);
			super.destroy();
		}
		
		public function setIdea(idea:Idea):void 
		{
			//l'idée referene ce blobby
			idea.setBlobby(this);
			//nouvelle idée
			m_idea = idea;
			//Placer l'idée au dessus du blobby
			m_idea.setDistance(this.m_distance + this.height);
			m_idea.setPos(this.m_pos);
			//chercher le blobby le plus près
			searchNearestBlobby();
			setState("search");
		}
		
		public function searchNearestBlobby():void 
		{
			var blobbies:Array = m_planet.getBlobbies(); //tous les blobbies
			var size:int = blobbies.length; //nombre de blobbies
			
			var nearest:Blobby; //blobby le plus proche
			var distMin:Number = 1000; //distance du blobby le plus proche
			var b:Blobby;
			var dist:Number;
			//parcourir tous les blobbies
			for (var i:int = 0; i < size ; i++) 
			{
				//pour ce blobby
				b = blobbies[i];
				
				//si c'est le même on passe au suivant
				if (b == this)
					continue;
					
				dist = Math.abs(((this.m_pos+180)%360) - ((b.m_pos+180)%360));
				if ( dist < distMin )
				{
					distMin = dist;
					//changer le blob le plus près
					nearest = b;
					
					/* Useless code since it is done in search 
					if ( ((this.m_pos + 180) % 360) - ((b.m_pos + 180) % 360) < 0 )
					{
						m_direction = 2;
					}
					else
					{
						m_direction = 1;
					}
					*/
				}		
			}
			
			m_blobTarget = nearest;
			m_blobTarget.color = 0xFF0080;
			this.color = 0x0618F9;
		}
		
		public function isInvincible() : Boolean{
			return (m_state == "search") || (m_state == "validate") || (m_state == "discuss");
		}
		
		public function collideWithBlobby(blobby:Blobby):Boolean {
			if (!blobby) return false;
			var posRad:Number = MathUtils.degToRan(m_pos);
			var posMin:Number = MathUtils.degToRan(blobby.getPos()-10);
			var posMax:Number = MathUtils.degToRan(blobby.getPos()+10);
			
			return ( posRad > posMin && posRad < posMax );
		}
		
		override public function draw():void 
		{
			//mettre a jour les propriétés du sprite courant
			m_spriteCurrent.x = x;
			m_spriteCurrent.y = y;
			m_spriteCurrent.angle = angle;
			m_spriteCurrent.scale = scale;
			m_spriteCurrent.color = color;
			//le dessiner
			m_spriteCurrent.draw();
		}
		
		override public function animIsFinished():Boolean 
		{
			return ( m_spriteCurrent.getCurIndex() == m_spriteCurrent.getCurAnim().frames.length - 1) ;
		}
		
		override public function setState(state:String):void {
			m_state = state;
			switch( state ) {
				case("walk"):
					m_spriteCurrent = m_spriteWalk;
					break;
				case("search"):
					m_spriteCurrent = m_spriteWalk;
					break;
				case("discuss"):
					m_spriteCurrent = m_spriteDiscuss;
					break;
				case("validate"):
					break;
				case("idle"):
					m_spriteCurrent = m_spriteIdle;
					break;
				case("die"):
					return;
					break;
				case("duplicate"):
					break;
				case("eat"):
					break;
				default:
					break;
			}
			m_spriteCurrent.play(m_state);
		}
	}

}