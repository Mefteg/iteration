package States 
{
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	import org.flixel.FlxState;
	import Utils.ResourceLoader;
	
	/**
	 * ...
	 * @author Alexandre Laurent
	 */
	public class DemoParticleState extends FlxState 
	{
		[Embed(source = "../../bin/gfx/particle.png")] private var particleSprite:Class
		
		private var m_emitter:FlxEmitter = null;
		
		public function DemoParticleState()
		{			
			m_emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 100);
			m_emitter.makeParticles(particleSprite, 100, 0, false, 0);			
		}
		
		override public function create():void 
		{
			add(m_emitter);
			m_emitter.start(false, 100, 0.05, 0);
		}
		
	}

}