package Game.Ideas 
{
	import Game.Objects.Blobby;
	import Game.Objects.Element;
	import Game.Objects.Planet;
	import org.flixel.FlxTimer;
	import Utils.MathUtils;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class Idea extends Element
	{
		
		private var m_blobby:Blobby; //reference vers le blobby possédant l'idée
		private var m_name:String; //nom de l'idée, aussi utilisé pour charger l'image
		private var m_effectDeath:Number;//effet sur la mortalité
		private var m_effectBirth:Number;//Effet sur la natalité
				
		private var timer:FlxTimer = new FlxTimer(); // timer pour la solidification de l'idée
		
		public function Idea(pos:Number, distance:Number, name:String, effectDeath:int, effectBirth:int, planet:Planet ) 
		{
			super(pos, distance, planet);
			setDistance(m_planet.radius() + 200);
			m_name = name;
			m_effectBirth = effectBirth/100;
			m_effectDeath = effectDeath / 100;
			loadGraphic2(SpriteResources.ImgIdeaBubble, true, false, 300, 300);
			addAnimation("popping", MathUtils.getArrayofNumbers(0, 14), 10, false);
			addAnimation("discussed", MathUtils.getArrayofNumbers(0, 14), 10, false);
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
		
		public function followBlobby() : void{
			//déplacer l'idée par rapport au blobby
			m_pos = m_blobby.getPos()+5;
			
			//rotater l'idée
			rotateToPlanet();
			//placer l'idée sur la planete
			place();
		}
		
		public function pop():void {
			if (finished)
				setState("popped");
		}
		
		override public function setState(state:String):void {
			m_state = state;
			play(m_state);
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
					break;
				case "discussed":
					break;
			}
		}
		
		
	}

}