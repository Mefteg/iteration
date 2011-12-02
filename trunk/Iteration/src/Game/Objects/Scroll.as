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
		protected var m_iterText1:FlxText;
		protected var m_iterText2:FlxText;
		protected var m_iterText3:FlxText;
		protected var m_ideas:Object;
		
		public function Scroll() 
		{
			//créer le bas du parchemin
			m_scroll = new FlxSprite(-267, 176);
			m_scroll.loadGraphic2(SpriteResources.ImgScroll, false, false, 322, 368);
			m_scroll.scrollFactor = new FlxPoint(0, 0);
			add(m_scroll);
			//créer les textes
			m_iterText1 = new FlxText( m_scroll.x+200, m_scroll.y+24, 300,"0");
			m_iterText1.setFormat("myFont", 36, 0x000000); //font-family, font-size, color, alignment
			m_iterText2 = new FlxText( m_scroll.x+200, m_scroll.y+81, 300,"0");
			m_iterText2.setFormat("myFont", 36, 0x000000); //font-family, font-size, color, alignment
			m_iterText3 = new FlxText( m_scroll.x+200, m_scroll.y+138, 300,"0");
			m_iterText3.setFormat("myFont", 36, 0x000000); //font-family, font-size, color, alignment
			
			m_iterText1.scrollFactor = new FlxPoint(0, 0);
			m_iterText2.scrollFactor = new FlxPoint(0, 0);
			m_iterText3.scrollFactor = new FlxPoint(0, 0);
			add(m_iterText1);
			add(m_iterText2);
			add(m_iterText3);
			//positions des idées
			m_ideas = new Array();
			initIdeas();
			
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
		
		public function initIdeas():void {
			m_ideas = {
			guerre : createIdea( -90, 150,"guerre"),
			religion: createIdea( 0, 150,"religion"),
			maladie : createIdea( 90, 150,"maladie"),
			paix : createIdea( -90, 200,"paix"),
			medecine : createIdea( 0, 200,"medecine"),
			fanatisme :createIdea( 90, 200,"fanatisme")
			};
		}
		
		public function onClick():Boolean {
			if (!FlxG.mouse.justPressed())
				return false;
				
			if ( (FlxG.mouse.x > m_scroll.x + 270) && (FlxG.mouse.x < m_scroll.x + 317))
				if ( (FlxG.mouse.y > m_scroll.y + 154) && (FlxG.mouse.y < m_scroll.y + 210))
					return true;
			return false;		
		}
		public function createIdea(dX:Number, dY:Number, ideaName:String ):FlxSprite {
			var idea:FlxSprite = new FlxSprite(m_scroll.x + dX, m_scroll.y + dY);
			idea.loadGraphic2(SpriteResources.ImgIdeas, true, false, 300, 300);
			idea.addAnimation("pop", SpriteResources.arrayIdeas[ideaName], 0, false);
			idea.scale = new FlxPoint(0.45, 0.45);
			idea.scrollFactor = new FlxPoint();
			idea.visible = false;
			add(idea);
			return idea;
		}
		
		override public function update():void {
			super.update();
			if(m_iteration ){
			m_iterText1.text = m_iteration.getIterations().toString();
			m_iterText2.text = m_iteration.getBirthPercent() + "%";
			m_iterText3.text = m_iteration.getDeathPercent() + "%";
			}
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
			if (m_scroll.x > -267)
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
			if (onClick() || FlxG.keys.TAB) {
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
			m_ideas[idea.getName()].play("pop");
			m_ideas[idea.getName()].visible = true;
		}
		
		public function removeIdeas():void {
			
			while (m_ideas.length > 0){
				remove(m_ideas.pop());
			}
			
			initIdeas();
		}
		
		public function removeIdea(name:String):void {
			m_ideas[name].visible = false;
		}
		public function setIteration(iter:Iteration):void {
			m_iteration = iter;
		}
		
	}

}