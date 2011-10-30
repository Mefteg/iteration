package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author ...
	 */
	public class Blobby extends Element
	{
		[Embed(source = "../bin/img/alien.png")] private var ImgAlien:Class;
		
		protected var m_timerMove:int = 0; //variable timer pour les déplacements
		protected var m_limitMove:int = 0; //temps limite pour le mouvement
		
		public function Blobby(pos:Number, distance:Number , planet:Planet) 
		{
			super(pos, distance, planet);
			loadGraphic(ImgAlien, true);
			place();
		}
		
		override public function update():void {
			// gérer aléatoirement les déplacements
			changeDirection();
			// placer le blobby
			place(); 
			//afficher
			super.update();
			
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
		
	}

}