package Game.Objects
{
	import flash.geom.Point;
	import Game.Ideas.Idea;
	import Game.NewSprite;
	import org.flixel.FlxG;
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
		
		//timer pour le mouvement
		protected var m_timerMove:FlxTimer;
		//idée
		protected var m_idea:Idea;
		//timer pour la discussion
		protected var m_timerDiscuss:FlxTimer;
		protected var m_discussTime:Number = 2;
		
		protected var m_blobTarget:Blobby;
		
		public function Blobby(pos:Number, distance:Number , planet:Planet) 
		{
			super(pos, distance, planet);
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
			m_distance += 70;
						
			//initialisation de l'animation
			m_state = "walk";
			
			place();			
		}
		
		public function setAnimations(walk:NewSprite,idle:NewSprite) : void{
			m_spriteWalk = walk;
			m_spriteIdle = idle;
			m_spriteCurrent = m_spriteWalk;
		}
		override public function update():void {
			//mettre a jour le sprite courant
			m_spriteCurrent.update();
			
			switch( m_state ) {
				case("walk"):
					walk();
					m_spriteCurrent = m_spriteWalk;
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
					m_spriteCurrent = m_spriteIdle;
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
				
		protected function discuss() :void{
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
			if (this.overlaps(m_blobTarget)) {
				//changer les états des deux blobby en "discussion"
				m_blobTarget.setState("discuss");
				this.setState("discuss");
				//démarrer le timer de discussion
				m_timerDiscuss.start(m_discussTime);
			}
			
			searchNearestBlobby();
			var v1:Point = new Point(x - m_planet.center().x, y - m_planet.center().y);
			var v2:Point = new Point(m_blobTarget.x - m_planet.center().x, m_blobTarget.y - m_planet.center().y);
			var det:Number = MathUtils.det(v1, v2);
			if (det > 0) {
				m_pos -= m_speed;
			}else {
				m_pos += m_speed;
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
		
		override public function destroy():void {
			m_blobTarget = null;
			//si il possédait une idée, la killer
			if (m_idea)
				m_idea.setState("killed");
			//ajouter des ressources a la planete
			m_planet.addResources(80);
			super.destroy();
		}
		
		public function setIdea(idea:Idea):void {
			//l'idée referene ce blobby
			idea.setBlobby(this);
			//nouvelle idée
			m_idea = idea;
			//Placer l'idée au dessus du blobby
			m_idea.setDistance(this.m_distance + this.height);
			m_idea.setPos(this.m_pos);
			//chercher le blobby le plus près
			searchNearestBlobby();
			this.setState("search");
		}
		
		public function searchNearestBlobby():void {
			var blobbies:Array = m_planet.getBlobbies(); //tous les blobbies
			var size:int = blobbies.length; //nombre de blobbies
			var nearest:Blobby; //blobby le plus proche
			var distMin:Number = 1000; //distance du blobby le plus proche
			var b:Blobby; var dist:Number;
			//parcourir tous les blobbies
			for (var i:int = 0; i < size ; i++) 
			{
				//pour ce blobby
				b = blobbies[i];
				//si c'est le même on passe au suivant
				if (b == this)
					continue;
				//calculer la distance entre les deux positions 
				dist = Math.sqrt( Math.pow((this.x - b.x), 2) + Math.pow( (this.y - b.y), 2) ) ;
				//si la distance est la plus petite
				if (dist < distMin) {
					//changer la distance minimum
					distMin = dist;
					//changer le blob le plus près
					nearest = b;
				}				
			}
			
			m_blobTarget =  b;
			m_blobTarget.scale.y = 2;
		}
		
		public function isInvincible() : Boolean{
			return (m_state == "search") || (m_state == "validate") || (m_state == "discuss");
		}
		
		override public function draw():void {
			m_spriteCurrent.play(m_state);
			//mettre a jour les propriétés du sprite courant
			m_spriteCurrent.x = x;
			m_spriteCurrent.y = y;
			m_spriteCurrent.angle = angle;
			m_spriteCurrent.scale = scale;
			//le dessiner
			m_spriteCurrent.draw();
		}
		
		override public function animIsFinished():Boolean {
			return ( m_spriteCurrent.getCurIndex() == m_spriteCurrent.getCurAnim().frames.length - 1) ;
		}
	}

}