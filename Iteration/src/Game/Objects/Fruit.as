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
			loadGraphic2(SpriteResources.ImgBlobby, true, false, 300, 300);
			place();
		}
		
		override public function update():void {
			super.update();
			place();
		}
	}

}