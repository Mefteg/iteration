package Game.Objects 
{
	import org.flixel.FlxG;
	import Resources.SpriteResources;
	import Utils.MathUtils;
	/**
	 * ...
	 * @author Tom
	 */
	public class Fruit extends Element 
	{
		public function Fruit(pos:Number, distance:Number, planet:Planet) 
		{
			super(pos, distance, planet);
			setState("growup");
			loadGraphic2(SpriteResources.ImgFruit, true, false, 30, 30);
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
					break;
				case("die"):
					die();
					break;
				default:
					break;
			}
		}
		
		protected function die():void {
			super.destroy();
		}
	}

}