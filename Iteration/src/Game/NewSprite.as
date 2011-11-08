package Game 
{
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxAnim;
	import org.flixel.*;
	/**
	 * ...
	 * @author Moi
	 */
	public class NewSprite extends FlxSprite
	{
		
		public function NewSprite() 
		{
			super();
		}
		
		public function getCurIndex():int {
			return _curIndex;
		}
		
		public function getCurAnim():FlxAnim {
			return _curAnim;
		}
		
		public function animIsFinished():Boolean {
			return _curIndex == _curAnim.frames.length - 1 ;
		}
		
		override public function update():void {
			super.postUpdate();
			super.update();
			super.postUpdate();
		}
		
		override public function destroy():void {
			super.destroy();
			kill();
		}
	}

}