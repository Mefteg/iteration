package Game.Objects 
{
	import Globals.GameParams;
	import org.flixel.FlxG;
	import Resources.SpriteResources;
	import Utils.MathUtils;
	/**
	 * ...
	 * @author Tom
	 */
	public class Fruit extends Element 
	{
		protected var m_givenResources:Boolean;
		
		public function Fruit(pos:Number, distance:Number, planet:Planet) 
		{
			super(pos, distance, planet);
			m_speed = 4.5;
			setState("growup");
			loadGraphic2(SpriteResources.ImgFruit, true, false, 40, 40);
			addAnimation("growup", MathUtils.getArrayofNumbers(0, 9), 10, false);
			play(m_state);
			rotateToPlanet();
			place();
		}
		
		override public function update():void {
			super.update();
			place();
			switch(m_state) {
				case("growup"):
					if ( finished ) {
						setState("idle");
					}
					break;
				case("idle"):
					break;
				case("fall"):
					fall();
					break;
				case("eaten"):
					eaten();
					break;
				case("die"):
					die();
					break;
				default:
					break;
			}
		}
		
		protected function fall():void {
			m_distance -= m_speed;
			if ( m_distance < m_planet.radius() + 75 ) {
				setState("eaten");
				m_planet.removeResources(GameParams.map.m_treeFruitResources);
				m_givenResources = true;
			}
		}
		
		protected function eaten():void {
			alive = false;
			visible = false;
		}
		
		protected function die():void {
			if ( !m_givenResources ) {
				m_planet.removeResources(GameParams.map.m_treeFruitResources);
				m_givenResources = true;
			}
			super.destroy();
		}
	}

}