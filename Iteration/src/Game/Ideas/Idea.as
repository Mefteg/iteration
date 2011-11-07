package Game.Ideas 
{
	import Game.Objects.Blobby;
	import Game.Objects.Element;
	import Game.Objects.Planet;
	import org.flixel.FlxTimer;
	
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class Idea extends Element
	{
		
		private var m_blobby:Blobby; //reference vers le blobby possédant l'idée
		
		private var m_effectDeath:Number;//effet sur la mortalité
		private var m_effectBirth:Number;//Effet sur la natalité
				
		private var timer:FlxTimer = new FlxTimer(); // timer pour la solidification de l'idée
		
		public function Idea(pos:Number, distance:Number,effectDeath:int, effectBirth:int, planet:Planet ) 
		{
			super(pos, distance, planet);
			m_effectBirth = effectBirth/100;
			m_effectDeath = effectDeath / 100;
			loadGraphic(SpriteResources.ImgIdeaWar, false, false, 174, 156);
		}
		
		public function setBlobby(blobby:Blobby):void {
			m_blobby = blobby;
		}
				
		override public function update():void {
			super.update();
			//déplacer l'idée par rapport au blobby
			m_pos = m_blobby.getPos();
			//rotater l'idée
			rotateToPlanet();
			//placer l'idée sur la planete
			place();
		}
		
	}

}