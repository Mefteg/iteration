package Game.Objects
{
	import Game.Ideas.Idea;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Blobby extends Element
	{		
		protected var m_timerMove:int = 0; //variable timer pour les déplacements
		protected var m_limitMove:int = 0; //temps limite pour le mouvement
		
		protected var m_idea:Idea;
		
		public function Blobby(pos:Number, distance:Number , planet:Planet) 
		{
			super(pos, distance, planet);
			//Diminuer les ressources
			m_planet.removeResources(100);
			//Créer l'image
			loadGraphic(SpriteResources.ImgAlien, true, false, 30, 30);
			//créer l'animation
			addAnimation("Default", [0, 1, 2,3,4,5,6,7], 6 + FlxG.random() * 4);	
			play("Default");
			place();
			m_state = "walk";
		}
		
		override public function update():void {
			switch( m_state ) {
				case("walk"):
					walk();
					break;
				case("eat"):
					eat();
					break;
				default:
					break;
			}
			
			// placer le blobby
			place();
			//afficher
			super.update();
		}
		
		protected function walk() {
			changeDirection();
		}
		
		protected function eat() {
			changeDirection();
		}
		
		public function changeDirection():void 
		{
			//si le timer est toujours en cours
			if (m_timerMove <= m_limitMove) {
				//bouger le sprite
				switch(m_direction) {
					case 0: break;
					case 1: m_pos += m_speed; break;
					case 2: m_pos -= m_speed; break;
					default:break;
				}
				//incrémenter le timer
				m_timerMove ++;
				//rotation pour mettre le bas du sprite sur la surface de la planete
				rotateToPlanet();
				//s'arrêter là
				return;
			}
			
			//sinon on réinitialise le compteur avec une direction aléatoire
			var rand:Number = Math.random();
			
			if (rand < .5) {
				m_direction = 0;
			}else if (rand < .75) {
				m_direction = 1;
			}else {
				m_direction = 2;
			}
			
			m_timerMove = 0;//réinitialiser le compteur
			m_limitMove = FlxU.srand(rand)*100 +32; //définir un temps aléatoire de déplacement de l'objet
		}
		
		override public function destroy():void {
			m_planet.addResources(80);
			super.destroy();
		}
		
		public function setIdea(idea:Idea):void {
			m_idea = idea;
			m_idea.setDistance(this.m_distance + this.height);
			m_idea.setPos(this.m_pos);
		}
		
	}

}