package Game.Objects 
{
	import Game.Ideas.Idea;
	import Globals.GameParams;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	
	public class Scroll extends FlxGroup
	{
		protected var m_iteration:Iteration;
		protected var m_state:String;
		private var m_timer:FlxTimer;
		private var m_speed:Number = 10;
		
		protected var m_scroll:FlxSprite;
		protected var m_iterText:FlxText;
		protected var m_ideas:Array;
		protected var nbIdea:int = 0;
		
		public function Scroll() 
		{
			//créer le bas du parchemin
			m_scroll = new FlxSprite(-260, 176);
			m_scroll.loadGraphic2(SpriteResources.ImgScroll, false, false, 322, 368);
			m_scroll.scrollFactor = new FlxPoint(0, 0);
			add(m_scroll);
			//créer les textes
			m_iterText = new FlxText( m_scroll.x+10, m_scroll.y+10, 300);
			m_iterText.setFormat("myFont", 32, 0x000000); //font-family, font-size, color, alignment
			m_iterText.scrollFactor = new FlxPoint(0, 0);
			add(m_iterText);
			//positions des idées
			m_ideas = new Array();
			createIdea( -90, 100);
			createIdea( 0, 100);
			createIdea( 90, 100);
			createIdea( -90, 180);
			createIdea( 0, 180);
			createIdea( 90, 180);
			
			//timer
			m_timer = new FlxTimer();
			
			m_state = "closed";
		}
		
		public function mouseOn():Boolean {
			if ( (FlxG.mouse.x > m_scroll.x) && (FlxG.mouse.x < m_scroll.x+m_scroll.width))
				if ( (FlxG.mouse.y > m_scroll.y) && (FlxG.mouse.y < m_scroll.y+m_scroll.height))
					return true;
			return false;
		}
		
		public function onClick():Boolean {
			if (!FlxG.mouse.justPressed())
				return false;
				
			if ( (FlxG.mouse.x > m_scroll.x + 270) && (FlxG.mouse.x < m_scroll.x + 317))
				if ( (FlxG.mouse.y > m_scroll.y + 154) && (FlxG.mouse.y < m_scroll.y + 210))
					return true;
			return false;		
		}
		public function createIdea(dX:Number, dY:Number ):void {
			var idea:FlxSprite = new FlxSprite(m_scroll.x+dX, m_scroll.y+ dY);
			idea.scale = new FlxPoint(0.6, 0.6);
			idea.scrollFactor = new FlxPoint();
			idea.visible = false;
			add(idea);
			m_ideas.push(idea);
		}
		
		override public function update():void {
			super.update();
			if(m_iteration )
			m_iterText.text = "Iteration : "+m_iteration.getIterations()+"\nNatalité : "+m_iteration.getDeathRatio()+"\nMortalité : "+m_iteration.getBirthRatio()+"\nIdees :";
			switch(m_state) {
				case "closed":
					wait();
					break;
				case "scrolling":
					scrolling();
					break;
				case "staying":
					staying();
					break;
				case "scrollingBack":
					scrollBack();
					break;
			}
		}
		
		private function scrollBack():void 
		{
			if (m_scroll.x > -260)
				//scroller tous les elements
				for (var i:int = 0; i < this.length; i++) 
				{
					this.members[i].x -= m_speed;
				}
			else {
				m_state = "closed";
			}
		}
		
		private function staying():void 
		{
			if (onClick()) {
				m_state = "scrollingBack";
				return;
			}
			
			if (m_timer.finished)
				if (mouseOn()) {
					m_timer.start(GameParams.map.scrollTime);
				}else{
					m_state = "scrollingBack";
				}
		}
		
		private function scrolling():void 
		{
			//si on peut encore scroller
			if (m_scroll.x <0) {
				//scroller tous les elements
				for (var i:int = 0; i < this.length; i++) 
				{
					this.members[i].x += m_speed;
				}
			}else {
				m_state = "staying";
			}
		}
		
		private function wait():void 
		{
			if (onClick() || FlxG.keys.TAB) {
				m_timer.start(GameParams.map.scrollTime);
				m_state = "scrolling";
			}
		}
		
		public function addIdea(idea:Idea):void {
			m_ideas[nbIdea].loadGraphic2(SpriteResources.ImgIdeas, true, false, 300, 300);
			m_ideas[nbIdea].addAnimation("pop", SpriteResources.arrayIdeas[idea.getName()], 0, false);
			m_ideas[nbIdea].play("pop");
			m_ideas[nbIdea].visible = true;
			nbIdea++;
		}
		
		public function removeIdeas():void {
			for (var i:int = 0; i < nbIdea; i++) 
			{
				m_ideas[i].visible = false;
			}
			nbIdea = 0;
		}
		public function setIteration(iter:Iteration):void {
			m_iteration = iter;
		}
		
	}

}