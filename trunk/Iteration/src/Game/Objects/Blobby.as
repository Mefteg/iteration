package Game.Objects
{
	import flash.geom.Point;
	import Game.Ideas.Idea;
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
		//timer pour le mouvement
		protected var m_timerMove:FlxTimer;
		//idée
		protected var m_idea:Idea;
		//timer pour la discussion
		protected var m_timerDiscuss:FlxTimer;
		protected var m_discussTime:Number = 5;
		
		protected var m_blobTarget:Blobby;
		protected var m_blobbyBirth:Blobby;
		
		public function Blobby(pos:Number, distance:Number, planet:Planet) 
		{
			super(pos, distance, planet);
			scale = new FlxPoint(GameParams.worldZoom, GameParams.worldZoom);
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
			generateAnimations();
			
			place();			
		}
		
		//génère les animations qui doivent etre propres au blobby
		public function generateAnimations():void {	
			loadGraphic(SpriteResources.ImgBlobby, true, false, 300, 300);
			addAnimation("idle", [0, 1, 2, 3, 4, 5], 0.2+FlxG.random() * 2, true);
			addAnimation("walk", MathUtils.getArrayofNumbers(6,13), 2 + FlxG.random() * 2, true);
			addAnimation("validate", MathUtils.getArrayofNumbers(24, 32), 5 +FlxG.random() * 2, false);
			addAnimation("duplicate", MathUtils.getArrayofNumbers(33, 41), 4 , false)
			addAnimation("discuss", MathUtils.getArrayofNumbers(15, 21) , 5 +FlxG.random() * 2, true);
		}
		
		override public function update():void 
		{
			if (!visible) return;
			super.update();
			
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
					duplicate();
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
		
		protected function duplicate():void {
			//si l'anim de mitose est finie
			if (finished) {
				//placer le nouveau blobby
				m_blobbyBirth.setPos(getPos() - 5.5);
				setPos(getPos() + 4.5);
				m_blobbyBirth.color = 0xFFFF00;
				m_blobbyBirth.visible = true;
				m_blobbyBirth.setState("idle");
				m_blobbyBirth = null;
				//passer à l'état idle
				setState("idle");
			}
		}
				
		protected function discuss() :void {
			if (m_timerDiscuss.finished) {
				setState("validate");
				m_blobTarget.setState("validate");
			}
		}
		
		private function validate():void {
			if (finished) {
				if(m_blobTarget){
					//remettre les états des deux blobs
					setState("idle");
					m_blobTarget.setState("idle");
					//l'idée est diffusée
					m_idea.setState("spread");
					//vider la variable d'idée
					// m_idea = null;
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
				
			
			var dist:Number = this.m_pos - m_blobTarget.m_pos;
			if ( this.m_pos > 270 && m_blobTarget.m_pos < 180 )
			{
				var angle1:Number = this.m_pos + 180 % 360;
				if ( angle1 < m_blobTarget.m_pos )
				{
					m_pos -= m_speed;
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
				}
				else
				{
					m_pos += m_speed;
					if ( m_pos < 0 ) // modulo of the angle
					{
						m_pos += 360;
					}
				}
			}
			else if ( m_blobTarget.m_pos > 270 && this.m_pos < 180 )
			{
				var angle2:Number = m_blobTarget.m_pos + 180 % 360;
				if ( angle2 > this.m_pos )
				{
					m_pos -= m_speed;
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
				}
				else
				{
					m_pos += m_speed;
					if ( m_pos < 00 ) // modulo of the angle
					{
						m_pos += 360;
					}
				}
			}
			else
			{
				if ( dist > 0 )
				{
					m_pos -= m_speed;
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
				}
				else
				{
					m_pos += m_speed;
					if ( m_pos < 00 ) // modulo of the angle
					{
						m_pos += 360;
					}
				}
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
				switch(m_direction) 
				{
					case 0: break;
				case 1: 
					m_pos += m_speed; 
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
					break;
				case 2: 
					m_pos -= m_speed;
					if ( m_pos < 0 ) // modulo of the angle
					{
						m_pos += 360;
					}
					break;
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
		
		public function setBlobbyBirth(blobby:Blobby):void {
			m_blobbyBirth = blobby;
			setState("duplicate");
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
					
				dist = MathUtils.calculateDistance(this.m_pos, b.m_pos);
				if ( dist < distMin )
				{
					distMin = dist;
					//changer le blob le plus près
					nearest = b;
				}		
			}
			
			m_blobTarget = nearest;
			m_blobTarget.color = 0xFF0080;
			this.color = 0x0618F9;
		}
		
		public function isInvincible() : Boolean{
			return (m_state == "search") || (m_state == "validate") || (m_state == "discuss") || (m_state == "duplicate");
		}
		
		public function isBusy():Boolean {
			return (m_state != "walk") && (m_state != "idle") ; 
		}
		
		public function collideWithBlobby(blobby:Blobby):Boolean 
		{
			if (!blobby) return false;
			
			if ( Math.abs(((this.m_pos + 180) % 360) - ((blobby.m_pos + 180) % 360)) < 7 )
			{
				return true;
			}
			return false;
		}
		
		override public function draw():void 
		{
			if (!visible) return;
			super.draw();
		}
		
				
		override public function setState(state:String):void {
			m_state = state;
			play(m_state);
		}
	}

}