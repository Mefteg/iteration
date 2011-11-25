package Game.Objects
{
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.utils.describeType;
	import Game.Ideas.Idea;
	import Globals.GameParams;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	import org.flixel.system.input.Mouse;
	import Resources.SoundResources;
	import Utils.MathUtils;
	
	import Resources.SpriteResources;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Blobby extends Element
	{				
		//image pour le blobby qui court a gauche
		protected var m_blobbyLeft:FlxSprite;
		//timer pour le mouvement
		protected var m_timerMove:FlxTimer;
		//idée
		protected var m_idea:Idea;
		protected var m_scholar:Boolean = false; // si le blobby a déjà eu une idée
		//timer pour la discussion
		protected var m_timerDiscuss:FlxTimer;
		protected var m_discussTime:Number = GameParams.map.m_blobbyDiscussTime;
		//timer pour la panique
		protected var m_timerPanic:FlxTimer;
		protected var m_panicTime:Number = GameParams.map.m_blobbyPanicTime;
		
		protected var m_blobTarget:Blobby;
		protected var m_blobbyBirth:Blobby;
		public var m_target:Element = null;
		public var m_targetTree:Tree = null;
		public var m_targetFruit:Fruit = null;
		
		protected var left:Boolean;
		private var m_previousState:String=null;
		
		public function Blobby(pos:Number, distance:Number, planet:Planet) 
		{
			super(pos, distance, planet);
			scale = new FlxPoint(GameParams.map.zoom,GameParams.map.zoom);
			//instancier le timer de discussion
			m_timerDiscuss = new FlxTimer();
			m_speed = 0.2;
			//instancier le timer de mouvement
			m_timerMove = new FlxTimer();
			m_timerMove.start(1);
			m_timerPanic = new FlxTimer();
			if(m_distance !=0)
				m_distance += 43;
			//vitesse
			m_speed = GameParams.map.m_blobbySpeed;
						
			//initialisation de l'animation
			m_state = "idle";
			generateAnimations();
			
			place();		
			color = 0x1df1ab;
			flip(false);
		}
		
		//génère les animations qui doivent etre propres au blobby
		public function generateAnimations():void {	
			loadGraphic2(SpriteResources.ImgBlobby, true, false, 300, 300);
			addAnimation("arise", [77], 0, true);
			addAnimation("birth",MathUtils.getArrayofNumbers(77,64), 6, false);
			addAnimation("idle", [0, 1, 2, 3, 4, 5], 0.2 + FlxG.random() * 2, true);
			addAnimation("walk", MathUtils.getArrayofNumbers(6,13), 6 + FlxG.random() * 2, true);
			addAnimation("pick", MathUtils.getArrayofNumbers(6,13), 6 + FlxG.random() * 2, true);
			addAnimation("search", MathUtils.getArrayofNumbers(6,13), 6 + FlxG.random() * 3, true);
			addAnimation("validate", MathUtils.getArrayofNumbers(24, 33), 10 + FlxG.random() * 2, false);
			addAnimation("duplicate", MathUtils.getArrayofNumbers(36, 44), 8 , false)
			addAnimation("discuss", MathUtils.getArrayofNumbers(15, 21) , 5 + FlxG.random() * 2, true);
			addAnimation("eat", MathUtils.getArrayofNumbers(45,51) , 8, false);
			addAnimation("swallow",[51,50,49,48,47,46,45] , 8, false);
			addAnimation("die", [77] , 2 +FlxG.random() * 2, false);
			addAnimation("comeBack", MathUtils.getArrayofNumbers(64,77) , 5 +FlxG.random() * 2, false);
			addAnimation("dig", [77] , 0, false);
			addAnimation("goPanic", MathUtils.getArrayofNumbers(54, 58), 15, false);
			addAnimation("panic", MathUtils.getArrayofNumbers(59, 62), 15, true);
			//poru quand il est inversé
			m_blobbyLeft = new FlxSprite();
			m_blobbyLeft.loadGraphic2(SpriteResources.ImgBlobbyRunLeft, true, false, 300, 300);
			m_blobbyLeft.addAnimation("panic", [3, 8, 7, 6], 15, true);
			m_blobbyLeft.addAnimation("goPanic", [2, 1, 0, 5, 4], 15, false);
			m_blobbyLeft.visible = true;
		}
		
		override public function draw():void {
			if (!visible) return;
			if (left) {
				m_blobbyLeft.x = x; m_blobbyLeft.y = y;
				m_blobbyLeft.angle = angle;
				m_blobbyLeft.scale = scale;
				m_blobbyLeft.color = color;
				m_blobbyLeft.draw();
			}else {
				super.draw();
			}
			
		}
		
		override public function update():void 
		{
			if (!visible) return;
			if(left){ m_blobbyLeft.postUpdate();}
			super.update();
			// placer le blobby
			place();
			//rotation pour mettre le bas du sprite sur la surface de la planete
			rotateToPlanet();
			switch( m_state ) {
				case ("arise"):
					arise();
					break;
				case ("birth"):
					birth();
					break;
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
					break;
				case("comeBack"):
					comeBack();
					break;
				case "dig":
					dig();
					break;
				case("duplicate"):
					duplicate();
					break;
				case("eat"):
					eat();
					break;
				case("swallow"):
					swallow();
					break;
				case("pick"):
					pick();
					break;
				case("goPanic"):
					goPanic();
					break;
				case("panic"):
					panic();
					break;
				default:
					break;
			}
			
		}
		protected function arise():void {
			if (m_distance < m_planet.radius()+43)
				m_distance+=2;
			else
				setState("birth");
		}
		
		protected function comeBack():void {
			flip(false);
			//si il possédait une idée, la killer
			if (m_idea)
			{
				m_idea.setState("killed");
				m_idea = null;
			}
			if (finished) 
			{				
				if ( onClick() || m_planet.isDead() )
				{
					setState("dig");
				}
			}
		}
		
		protected function dig():void {
			if (m_distance >this.height*0.5) {
				m_distance-=2;
			}else {
				setState("die");
			}
		}
		protected function birth():void {
			if (finished) {
				setState("idle");
			}
		}
		protected function walk() :void{
			changeDirection();
		}
		
		protected function idle():void {
			changeDirection();
		}
		
		protected function eat() :void {
			// si l'animation est terminée
			if ( finished ) {
				// si le fruit a été détruit
				if ( !m_targetFruit.alive ) {
					setState("swallow");
					m_targetFruit.setState("eaten");
					m_targetTree = null;
					m_targetFruit = null;
				}
			}
		}
		
		protected function swallow() :void{
			if ( finished ) {
				setState("duplicate");
				m_target = null;
			}
		}
		
		protected function duplicate():void 
		{
			//si l'anim de mitose est finie
			if (finished) 
			{
				if (m_blobbyBirth == null) {
					//même chose pour ce blobby
					setState("idle");
					return;
				}
				//placer le nouveau blobby
				m_blobbyBirth.setPos(getPos() - 5.5);
				m_blobbyBirth.color = color;
				setPos(getPos() + 5);
				m_blobbyBirth.visible = true;
				m_blobbyBirth.play(m_blobbyBirth.getState());
				//si le blobby n'a pas été choisi pour une quelconque action
				if ( !m_blobbyBirth.isBusy())
					//le passer en idle
					m_blobbyBirth.setState("idle");
				//ajouter le blobby a la liste
				m_planet.addBlobby(m_blobbyBirth);
				//supprimer sa référence
				m_blobbyBirth = null;
			}
		}
				
		protected function discuss() :void {
			if (m_timerDiscuss.finished && m_blobTarget) {
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
					//changer le sprite
					color = SpriteResources.arrayIdeasColor[m_idea.getName()];
					m_blobTarget.color = SpriteResources.arrayIdeasColor[m_idea.getName()];
					//et supprimer sa référence
					m_blobTarget = null;
					//vider la variable d'idée
					m_idea = null;
					//le blobby est maintenant un érudit
					m_scholar = true;
				}
			}
		}
		
		public function goPanic():void {
			//vérifier quelle anim est jouée puis lancer le timer de panique
			if (left && m_blobbyLeft.finished) {
				m_timerPanic.start(m_panicTime);
				setState("panic");
			}else if (finished) {
				m_timerPanic.start(m_panicTime);
				setState("panic");
			}
			
		}
		
		public function panic():void {
			if (m_timerPanic.finished) {
				flip(false);
				if (m_previousState) {
					setState(m_previousState);
					m_previousState = null;
				}else{
					setState("idle");
				}
				return;
			}
			//bouger le sprite
			switch(m_direction) 
			{
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
		}
		
		public function die():void {
			if (finished) {
				if (m_idea) {
					m_idea.setState("killed");
				}
				visible = false;
				m_planet.removeBlobby(this);
				destroy();
			}
		}
		
		public function search():void {
			//trace("search",m_blobTarget.isDying());
			//si le blobby cible est mort , en chercher un autre
			if (!m_blobTarget )
				searchNearestBlobby();
			if (m_blobTarget.isDying())
				searchNearestBlobby();
				
			if ( collideWithBlobby(m_blobTarget) ) {
				//trace("collision", m_pos, m_blobTarget.getPos(), m_blobTarget.isBusy());
				//si le blobby est occupé on attend
				if (m_blobTarget.isBusy()) 
					return;
				//démarrer le timer de discussion
				m_timerDiscuss.start(m_discussTime);
				//changer les états des deux blobby en "discussion"
				m_blobTarget.setState("discuss");
				this.setState("discuss");
				//sigifier a l'idée qu'elle est discutée
				m_idea.setState("discussed");
			}
			
			var dist:Number = this.m_pos - m_blobTarget.m_pos;
			if ( this.m_pos > 270 && m_blobTarget.m_pos < 180 )
			{
				var angle1:Number = this.m_pos + 180 % 360;
				if ( angle1 < m_blobTarget.m_pos )
				{
					m_pos -= m_speed*1.2;
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
				}
				else
				{
					m_pos += m_speed*1.2;
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
					m_pos -= m_speed*1.2;
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
				}
				else
				{
					m_pos += m_speed*1.2;
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
					m_pos -= m_speed*1.2;
					if ( m_pos > 360 ) // modulo of the angle
					{
						m_pos -= 360;
					}
				}
				else
				{
					m_pos += m_speed*1.2;
					if ( m_pos < 00 ) // modulo of the angle
					{
						m_pos += 360;
					}
				}
			}
						
			m_idea.update();
		}
		
		public function goTo(target:Element):void {
			var dist:Number = this.m_pos - target.getPos();
			if ( this.m_pos > 270 && target.getPos() < 180 )
			{
				var angle1:Number = this.m_pos + 180 % 360;
				if ( angle1 < target.getPos() )
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
			else if ( target.getPos() > 270 && this.m_pos < 180 )
			{
				var angle2:Number = target.getPos() + 180 % 360;
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
		}
		
		public function pick():void {
			// s'il n'y a aucun arbre disponible
			if ( m_planet.getTrees().length > 0 ) {
				// si je dois chercher un arbre et pas un fruit
				if ( m_targetTree != null && m_targetFruit == null ) {
					// si je suis arrivé à l'arbre
					if ( collideWithElement(m_targetTree) ) {
						m_targetFruit = searchNearestElement(m_targetTree.getFruits()) as Fruit;
					}
					// sinon
					else {
						// je cherche l'arbre le plus proche
						m_targetTree = searchNearestTree();
						// si un arbre a été trouvé
						if ( m_targetTree != null ) { 
							// et je m'y rends
							goTo(m_targetTree);
						}
					}
				}
				// sinon
				else {
					// si je n'ai pas de fruit à trouver
					if ( m_targetFruit == null ) {
						//je recupere l'arbre le plus proche
						m_targetTree = searchNearestTree();
					}
					// sinon
					else {
						// si je suis arrivé sous le fruit
						if ( isOnElement(m_targetFruit) ) {
							m_targetFruit.setState("fall");
							setState("eat");
						}
						// sinon
						else 
						{
							// je cherche le fruit le plus proche
							m_targetTree = searchNearestTree();
							//s'il existe encore un arbre 
							if(m_targetTree !=null){
								m_targetFruit = searchNearestElement(m_targetTree.getFruits()) as Fruit;
								//s'il existe encore un fruit
								if ( m_targetFruit != null ) {
									// et je m'y rends
									goTo(m_targetFruit);
								}
							}//sinon j'attends et j'ai tres faim
							else {
								setState("idle");
							}
						}
					}
				}
			}
			// sinon
			else {
				// je repasse en état "idle"
				setState("idle");
			}
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
			
			m_timerMove.start(rand*4 +0.5); //définir un temps aléatoire de déplacement de l'objet
		}
		
		override public function destroy():void 
		{
			m_blobTarget = null;
			m_blobbyLeft.destroy();
			m_blobbyLeft = null;
			//ajouter des ressources a la planete
			m_planet.addResources(GameParams.map.m_blobbyRecycledResources);
			super.destroy();
		}
		
		public function setIdea(idea:Idea):void 
		{
			//l'idée referene ce blobby
			idea.setBlobby(this);
			//nouvelle idée
			m_idea = idea;
			m_idea.setState("popping");
			//Placer l'idée au dessus du blobby
			m_idea.setPos(this.m_pos);
			//chercher le blobby le plus près
			searchNearestBlobby();
			setState("search");
			
			GameParams.soundBank.get(SoundResources.ideaSound).play();
		}
		
		public function setBlobbyBirth(blobby:Blobby):void {
			m_blobbyBirth = blobby;
			setState("pick"); 
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
				if (b == this || b.isDying() )
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
		}
		
		// Cherche l'arbre ayant des fruits le plus près
		public function searchNearestTree():Tree 
		{
			var trees:Array = m_planet.getTrees(); //tous les trees
			var size:int = trees.length; //nombre de trees
			
			var t:Tree = null;
			var nearest:Tree = t; //blobby le plus proche
			var distMin:Number = 1000; //distance du tree le plus proche
			var dist:Number;
			//parcourir tous les trees
			for (var i:int = 0; i < size ; i++) 
			{
				//pour ce tree
				t = trees[i];
				
				// s'il est instancié
				if ( t != null ) {
					// et qu'il possede des fruits
					if ( t.isFeeding() ) {
						dist = MathUtils.calculateDistance(this.m_pos, t.getPos());
						if ( dist < distMin )
						{
							distMin = dist;
							//changer le blob le plus près
							nearest = t;
						}
					}
				}
			}
			
			return nearest;
		}
		
		// Retourne l'element "alive" le plus proche
		public function searchNearestElement(elements:Array):Element 
		{
			var size:int = elements.length; //nombre d'elements
			
			var e:Element = null;
			var nearest:Element = e; //element le plus proche
			var distMin:Number = 1000; //distance de l'element le plus proche
			var dist:Number;
			//parcourir tous les elements
			for (var i:int = 0; i < size ; i++) 
			{
				//pour cet element
				e = elements[i];
				
				// s'il est instancié
				if ( e != null ) {
					// s'il est "alive"
					if ( e.alive ) {
						dist = MathUtils.calculateDistance(this.m_pos, e.getPos());
						if ( dist < distMin )
						{
							distMin = dist;
							//changer l'element le plus près
							nearest = e;
						}
					}
				}
			}
			
			return nearest;
		}
		
		public function isInvincible() : Boolean{
			return (m_state == "search") || (m_state == "validate") || (m_state == "discuss") || (m_state == "duplicate") ;
		}
		
		public function isNotSoBusy():Boolean {
			return ((m_state != "walk") && (m_state != "idle") &&(m_state != "pick")&&(m_state != "search")) || !visible ; 
		}
		
		public function isBusy():Boolean {
			return ((m_state != "walk") && (m_state != "idle")) || !visible ; 
		}
		
		public function isBorn():Boolean {
			return ( (m_state != "birth") && (m_state != "arise") );
		}
		
		public function isDying():Boolean {
			return ( (m_state == "dig") || (m_state == "comeBack") || (m_state == "die"));
		}
		
		public function isScholar():Boolean {
			return m_scholar;
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
		
		public function collideWithElement(target:Element):Boolean 
		{
			if (!target) return false;
			
			if ( Math.abs(((this.m_pos + 180) % 360) - ((target.getPos() + 180) % 360)) < 7 )
			{
				return true;
			}
			return false;
		}
		
		public function isOnElement(target:Element):Boolean 
		{
			if ( (getPos() % 360) - (target.getPos() % 360) < 1 && (getPos() % 360) - (target.getPos() % 360) > 0 ) {
				return true;
			}
			return false;
		}

			
				
		override public function setState(state:String):void {
			if (state == "goPanic" && ( m_state == "pick" || m_state == "search"))
				m_previousState = m_state;
				
			m_state = state;
			if (left)
				m_blobbyLeft.play(m_state);
			else
				play(m_state);
		}

		
		public function setDirection(dir:int):void {
			m_direction = dir;
		}
		
		public function flip(f:Boolean):void {
			left = f;
		}

		
		override public function onClick():Boolean 
		{
			if ( FlxG.mouse.justPressed() )
			{
				//si click de la souris
				var mouseX:int = FlxG.mouse.getWorldPosition(GameParams.camera).x;
				var mouseY:int = FlxG.mouse.getWorldPosition(GameParams.camera).y;

				var clicAngle:Number = 0;
				clicAngle = ( -180 / Math.PI) * Math.atan((mouseY - m_planet.center().y) / (mouseX - m_planet.center().x));
				
				//trace("Mouse 2: " + mouseX + ";" + mouseY);
				//trace ("Earth center: " + m_planet.center().x + ";" + m_planet.center().y);
				//trace("Angle: " + clicAngle);
				
				if ( mouseX < m_planet.center().x )
				{
					clicAngle += 180;
				}
				else
				{
					if ( mouseY > m_planet.center().y )
					{
						clicAngle += 360;
					}
				}
				
				//trace("Clic Angle: " + clicAngle);

				if ( Math.abs(MathUtils.clampAngle(m_pos) - clicAngle) < 2 && Math.abs(Point.distance(new Point(mouseX, mouseY), m_planet.center()) - (m_planet.radius()-95) * GameParams.map.zoom) < 5 )
				{
					return true;
				}
			}
			
			return false;
		}

	}

}