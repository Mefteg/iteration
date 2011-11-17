package Game.Ideas 
{
	import Game.Objects.Blobby;
	import Game.Objects.Element;
	import Game.Objects.Planet;
	import Globals.GameParams;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import Utils.MathUtils;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class Idea extends Element
	{
		private var m_spriteIdea:FlxSprite;//sprite pour l'image dans la bulle
		
		private var m_blobby:Blobby; //reference vers le blobby possédant l'idée
		private var m_name:String; //nom de l'idée, aussi utilisé pour charger l'image
		private var m_effectDeath:Number;//effet sur la mortalité
		private var m_effectBirth:Number;//Effet sur la natalité
				
		private var timer:FlxTimer = new FlxTimer(); // timer pour la solidification de l'idée
		private var timerAnim:FlxTimer = new FlxTimer();//timer pour simuler une animation de la bulle d'idée en discussion
		private var indexAnim:int = 0;
		
		public function Idea(pos:Number, distance:Number, name:String, planet:Planet ) 
		{
			super(pos, distance, planet);
			setDistance(m_planet.radius() + 150);
			m_name = name;
			m_effectBirth = GameParams.map.m_ideaEffect[m_name][1]/100;
			m_effectDeath = GameParams.map.m_ideaEffect[m_name][0] / 100;
			timerAnim.finished = true;
			//charger la bulle
			loadGraphic2(SpriteResources.ImgIdeaBubble, true, false, 300, 300);
			addAnimation("popping", MathUtils.getArrayofNumbers(0, 14), 10, false);
			addAnimation("discussed", [15], 0, false);
			//charger l'imge de l'idée
			m_spriteIdea = new FlxSprite();
			m_spriteIdea.loadGraphic2(SpriteResources.ImgIdeas, true, false, 300, 300);
			m_spriteIdea.addAnimation("pop", SpriteResources.arrayIdeas[m_name], 0, false);
			setState("waiting");
		}
		
		public function setBlobby(blobby:Blobby):void {
			m_blobby = blobby;
		}
			
		public function getDeathEffect():Number {
			return m_effectDeath;
		}
		
		public function getBirthEffect():Number {
			return m_effectBirth;
		}
		
		public function getName():String {
			return m_name;
		}
		
		public function animate():void {
			if (timerAnim.finished) {
				m_distance += SpriteResources.animateIdea[indexAnim];
				indexAnim++;
				timerAnim.start(0.1);
				if (indexAnim >= SpriteResources.animateIdea.length)
					indexAnim = 0;
			}
		}
		
		public function followBlobby() : void {
			if (!m_blobby) return;
			//déplacer l'idée par rapport au blobby
			m_pos = m_blobby.getPos()+5;
			
			//rotater l'idée
			rotateToPlanet();
			//placer l'idée sur la planete
			place();
			//update l'image
			m_spriteIdea.x = x;
			m_spriteIdea.y = y;
			m_spriteIdea.angle = angle;
			m_spriteIdea.scale = scale;
		}
		
		public function pop():void {
			if (finished)
				setState("popped");
		}
		
		override public function setState(state:String):void {
			m_state = state;
			if (state == "killed")
				m_blobby = null;
			play(m_state);
		}
		
		override public function draw():void {
			super.draw();
			if (m_state == "popped" || m_state == "discussed")
				m_spriteIdea.draw();
		}
		override public function update():void {
			super.update();
			followBlobby();
			switch(m_state) {
				case "waiting":
					break;
				case "popping":
					pop();
					break;
				case "popped":
					followBlobby();
					m_spriteIdea.play("pop");
					break;
				case "discussed":
					animate();
					break;
			}
		}
		
		
	}

}