package Game.Objects 
{
	import Resources.SpriteResources;
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
			loadGraphic2(SpriteResources.ImgFruit, true, false, 35, 34);
			rotateToPlanet();
			place();
		}
		
		override public function update():void {
			super.update();
			place();
			switch(m_state) {
				case("growup"):
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