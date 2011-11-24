package Game.States 
{
	import Game.Buttons.BackButton;
	import Game.Buttons.LeftArrowButton;
	import Game.Buttons.RightArrowButton;
	import Globals.GameParams;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import Resources.SpriteResources;
	/**
	 * ...
	 * @author Moi
	 */
	public class TutoState extends FlxState
	{
		protected var m_background:FlxSprite;
		protected var m_slides:Array;
		
		protected var m_backbutton:BackButton;
		protected var m_leftarrowbutton:LeftArrowButton;
		protected var m_rightarrowbutton:RightArrowButton;
		
		public function TutoState() 
		{
			
		}
		
		override public function create():void {
			FlxG.mouse.show();
			FlxG.mouse.load(SpriteResources.ImgMouseCursor);
			
			// Je remets le slide courant à 0
			GameParams.currentTutoSlide = 0;
			
			// J'ajoute les slides
			m_slides = new Array();
			// slide 1
			m_slides.push(new FlxSprite());
			m_slides[m_slides.length - 1].loadGraphic2(SpriteResources.ImgTuto, false, false, 1280, 720, true);
			// slide 2
			m_slides.push(new FlxSprite());
			m_slides[m_slides.length - 1].loadGraphic2(SpriteResources.ImgMenuBackground, false, false, 1280, 720, true);
			
			for (var i:int = 0; i < m_slides.length; i++) {
				add(m_slides[i]);
			}
			
			// J'ajoute le bouton de retour
			m_backbutton = new BackButton(((1280 / 7) * 6.3 ), ((720 / 6) * 5 ), null, function() { FlxG.switchState(new MenuState()); } );
			add(m_backbutton);
			
			// J'ajoute la fleche gauche
			m_leftarrowbutton = new LeftArrowButton(0, (720 / 2) - (73 / 2), null, function() { GameParams.currentTutoSlide--; });
			add(m_leftarrowbutton);
			
			// J'ajoute la fleche droite
			m_rightarrowbutton = new RightArrowButton((1280 - 57), (720 / 2) - (73 / 2), null, function() { GameParams.currentTutoSlide++; } );
			add(m_rightarrowbutton);
		}
		
		override public function update():void {
			super.update();
			//si le slide courant sort du nombre de slides
			if ( GameParams.currentTutoSlide > (m_slides.length - 1) ) {
				GameParams.currentTutoSlide = 0;
			}
			else {
				if ( GameParams.currentTutoSlide < 0 ) {
					GameParams.currentTutoSlide = m_slides.length - 1;
				}
			}
			
			// pour chaque slide
			for (var i:int = 0; i < m_slides.length; i++) {
				// s'il s'agit du slide courant
				if ( i == GameParams.currentTutoSlide ) {
					// je l'affiche
					m_slides[i].visible = true;
				}
				else {
					// et je cache les autres
					m_slides[i].visible = false;
				}
			}
		}
		
	}

}