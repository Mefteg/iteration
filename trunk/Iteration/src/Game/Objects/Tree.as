package Game.Objects
{
	import flash.display.MovieClip;
	import org.flixel.*;
	import flash.geom.Point;
	import Utils.MathUtils;
	import Globals.GameParams;
	
	import Resources.SpriteResources;
	
	/**
	 * Tree implementation
	 * @author Alexandre Laurent
	 */
	public class Tree extends Element
	{				
		private var m_otherTrees:Array;
		
		private var m_treeGrow:FlxSprite = null;
		private var m_treeDie:FlxSprite= null;
		private var m_roots:FlxSprite= null;
		private var m_fruits:Array;
		private var m_nbFruitMax:int;
		
		private var m_yellowingTimer:FlxTimer;

		private var m_gap:int = -9;
		
		private var m_model:int = 0;
		
		/**
		 * @param	origin	The point where the root starts
		 * @param	planet where the tree will grow
		 */
		public function Tree(origin:Point,planet:Planet, trees:Array) 
		{
			m_yellowingTimer = new FlxTimer();
			
			super(0, planet.radius(), planet);
			m_nbFruitMax = GameParams.map.m_treeNbFruitMax;
			if ( m_nbFruitMax > 6 ) {
				m_nbFruitMax = 6;
			}
			
			m_otherTrees = trees;
			
			// Loop to position randomly a tree enough distant to others
			var size:int = trees.length;
			if ( size > 0 )
			{
				var randomPos:Number = FlxG.random() * 360;
				
				var t:Tree; // nearest tree (the closer one)
				var distMin:Number = 1000; // distance of the nearest tree
				var dist:Number = 0;
				
				var nbIteration:uint = 0;
				
				while ( dist < 25 && nbIteration < 25)
				{
					randomPos = FlxG.random() * 360;
					distMin = 1000;
					
					for (var i:int = 0; i < size ; i++) 
					{
						//pour ce blobby
						t = trees[i];
						if ( t == null )
							continue;
							
						dist = MathUtils.calculateDistance(randomPos, t.m_pos);
						if ( dist < distMin )
						{
							distMin = dist;
						}		
					}
					
					dist = distMin;
					nbIteration++;
				}
				
				if ( nbIteration >= 25 )
				{
					return;
				}
				
				this.m_pos = randomPos;
				m_distance += 175;
				
				m_treeGrow = new FlxSprite();
				m_treeDie = new FlxSprite();
				if ( FlxG.random() < 0.5 )
				{
					m_treeGrow.loadGraphic2(SpriteResources.ImgTreeGrow, true, false, 405, 376);
					m_treeDie.loadGraphic2(SpriteResources.ImgTreeDie, true, false, 405, 376);
					m_model = 0;
				}
				else
				{
					m_treeGrow.loadGraphic2(SpriteResources.ImgTreeGrow2, true, false, 405, 379);
					m_treeDie.loadGraphic2(SpriteResources.ImgTreeDie2, true, false, 405, 379);
					m_model = 1;
				}
				m_treeGrow.addAnimation("grow", MathUtils.getArrayofNumbers(0, 62), 20, false);
				m_treeGrow.scale.x = 1.;
				m_treeGrow.scale.y = 1.;
				
				
				m_treeDie.addAnimation("goYellow", MathUtils.getArrayofNumbers(0, 11), 0, false);
				m_treeDie.addAnimation("die", MathUtils.getArrayofNumbers(12, 77), 10, false);
				m_treeDie.scale.x = 1.;
				m_treeDie.scale.y = 1.;
				
				m_roots = new FlxSprite();
				m_roots.loadGraphic2(SpriteResources.ImgTreeRoots, true, false, 202, 716);
				m_roots.addAnimation("grow", MathUtils.getArrayofNumbers(0, 44), 10, false);
				m_roots.addAnimation("ungrow", MathUtils.getArrayofNumbers(0, 44).reverse(), 10, false);
				m_roots.scale.x = 1.0;
				m_roots.scale.y = 1.0;
				
				m_roots.play("grow");
			}
			
			// m_roots = new TreeRoot(origin, 255, 255, 255, 0, 255, 0, planet.radius()-2);
			m_state = "rootsGrow";
		}
				
		override public function draw():void 
		{
			// Possible since we can be stucked when placing a tree
			if ( m_roots == null || m_treeGrow == null || m_treeDie == null )
				return;
			
			switch(m_state) 
			{
				case("rootsGrow"):
					m_roots.draw();
					break;
				case("treeGrow"):
					m_roots.draw();
					m_treeGrow.draw();
					break;
				case("feed"):
					m_roots.draw();
					m_treeDie.draw();
					break;
				case "revive":
					m_roots.draw();
					m_treeDie.draw();
					break;
				case("die"):
					m_roots.draw();
					m_treeDie.draw();
					break;
				case("dieGrow"):
					m_roots.draw();
					m_treeGrow.draw();
					break;
				case("ungrowRoot"):
					m_roots.draw();
					break;
				default:
					break;
			}
		}
		
		override public function update():void
		{
			// Possible since we can be stucked when placing a tree
			if ( m_roots == null || m_treeGrow == null || m_treeDie == null )
				return;
			
			super.update();
			
			var angleRoot:Number = (Math.PI / 180) * m_pos ;
			var angleTree:Number = (Math.PI / 180) * (m_pos+m_gap) ;

			m_roots.x = m_planet.center().x + Math.cos(angleRoot) * (m_planet.radius()/2)* GameParams.map.zoom - m_roots.width /2;
			m_roots.y = m_planet.center().y - Math.sin(angleRoot) * (m_planet.radius()/2)* GameParams.map.zoom - m_roots.height/2;
			m_treeGrow.x = m_planet.center().x + Math.cos(angleTree) * (m_distance)* GameParams.map.zoom - m_treeGrow.width /2;
			m_treeGrow.y = m_planet.center().y - Math.sin(angleTree) * (m_distance) * GameParams.map.zoom - m_treeGrow.height / 2;
			m_treeDie.x = m_planet.center().x + Math.cos(angleTree) * (m_distance)* GameParams.map.zoom - m_treeDie.width /2;
			m_treeDie.y = m_planet.center().y - Math.sin(angleTree) * (m_distance)* GameParams.map.zoom - m_treeDie.height/2;
		
			m_roots.angle = -m_pos + 90;
			m_treeGrow.angle = -(m_pos+m_gap) + 90;
			m_treeDie.angle = -(m_pos+m_gap) + 90;
			
			m_roots.scale.x = 1.0 * GameParams.map.zoom;
			m_roots.scale.y = 1.0  * GameParams.map.zoom;
			m_treeGrow.scale.x = 1. * GameParams.map.zoom;
			m_treeGrow.scale.y = 1. * GameParams.map.zoom;
			m_treeDie.scale.x = 1. * GameParams.map.zoom;
			m_treeDie.scale.y = 1. * GameParams.map.zoom;
			
			
			switch(m_state) 
			{
				case("rootsGrow"):
					m_roots.postUpdate();
					if ( m_roots.finished )
					{
						setState("treeGrow");
						m_treeGrow.play("grow");
					}
					break;
				case("treeGrow"):
					m_treeGrow.postUpdate();
					if ( m_treeGrow.finished )
					{
						// on cree les fruits
						createFruits();
						setState("feed");
						m_treeDie.play("goYellow");
						m_yellowingTimer.start(GameParams.map.m_treeLifetime / 12.0);
					}
					break;
				case("feed"):
					if ( m_yellowingTimer.finished )
					{
						m_treeDie.frame = m_treeDie.frame+1;
						m_treeDie.postUpdate();
						m_yellowingTimer.start(GameParams.map.m_treeLifetime / 12.0);
					}
					

					var cpt:int = 0;

					// s'il n'y a plus de fruits, l'arbre meurt
					for (var i:int = 0; i < m_fruits.length; i++) 
					{
						if ( !m_fruits[i].alive ) {
							cpt++;
						}
					}
					
					if ( cpt == m_fruits.length ) 
					{
						/*
						m_treeDie.addAnimation("completeDie", MathUtils.getArrayofNumbers(m_treeDie.frame, 77), 10, false);
						m_treeDie.play("completeDie");
						m_state = "die";
						*/
					}
					
					if ( m_treeDie.frame == 11 )
					{
						clearFruits();
						m_treeDie.play("die");
						m_state = "die";
					}
					break;
				case "revive":
					m_treeDie.postUpdate();
					if ( m_treeDie.finished )
					{
						m_treeDie.play("goYellow");
						m_yellowingTimer.start(GameParams.map.m_treeLifetime / 12.0);
						m_state = "feed";
					}
					break;
				case("die"):
					m_treeDie.postUpdate();
					if (m_treeDie.finished )
					{
						m_state = "ungrowRoot";
						m_roots.play("ungrow");
					}
					break;
				case "dieGrow":
					m_treeGrow.postUpdate();
					if (m_treeGrow.finished )
					{
						m_state = "ungrowRoot";
						m_roots.play("ungrow");
					}
					break;
				case "ungrowRoot":
					m_roots.postUpdate();
					if ( m_roots.finished )
					{
						die();
					}
					return;
					break;
				default:
					break;
			}
			
		}
		
		public function clearFruits():void
		{
			if (!m_fruits || m_fruits.length==0) return;
			// je detruis les fruits
			for (var i:int = 0; i < m_fruits.length; i++) {
				m_fruits[i].setState("die");
			}
		}
		
		override public function destroy():void
		{			
			clearFruits();
			super.destroy();
		}
		
		private function createFruits():void {
			m_fruits = new Array();
			var availables:Array = new Array();
			var positions:Array = new Array();
			var distances:Array = new Array();
			
			if( m_model == 0 ) {
				positions.push(m_pos + 8 + m_gap + (Math.random() * 4) - 2); distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos + 4 + m_gap + (Math.random() * 4) - 2); distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos - 1 + m_gap + (Math.random() * 4) - 2); 	distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos - 8 + m_gap + (Math.random() * 4) - 2); distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos + 2 + m_gap + (Math.random() * 4) - 2); distances.push(m_distance + 135); 	availables.push(1);
				positions.push(m_pos - 3 + m_gap + (Math.random() * 4) - 2); distances.push(m_distance + 130); 	availables.push(1);
			}
			if( m_model == 1 ) {
				positions.push(m_pos + 8 + m_gap + (Math.random() * 2) - 1); distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos + 3 + m_gap + (Math.random() * 2) - 1); distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos - 4 + m_gap + (Math.random() * 2) - 1); 	distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos - 6 + m_gap + (Math.random() * 2) - 1); distances.push(m_distance + 50); 	availables.push(1);
				positions.push(m_pos + 6 + m_gap + (Math.random() * 2) - 1); distances.push(m_distance + 135); 	availables.push(1);
				positions.push(m_pos + 2 + m_gap + (Math.random() * 2) - 1); distances.push(m_distance + 130); 	availables.push(1);
			}
			
			// pour chaque fruit a placer
			for (var j:int = 0; j < m_nbFruitMax; j++) {
				// pour ne pas afficher deux fois le meme fruit
				var f:int = Math.random() * positions.length;
				while ( availables[f] == 0 ) {
					f = Math.random() * positions.length;
				}
				// j'ajoute le fruit
				m_fruits.push(new Fruit(positions[f], distances[f], getPlanet()));
				// ce fruit n'est plus dispo du coup
				availables[f] = 0;
				// j'affiche le fruit
				GameParams.playstate.getDepthBuffer().addFruit(m_fruits[m_fruits.length-1]);
			}
		}
		
		override public function setState(state:String):void 
		{			
			if ( state == "die" && m_treeDie != null )
			{
				// on detruit tous les fruits ( s'il en reste )
				if ( m_fruits != null )
				{
					for ( var i:int = 0; i < m_fruits.length; i++ ) {
						m_fruits[i].setState("die");
					}
				}
				
				if ( m_state == "feed" || m_state == "die" )
				{
					m_treeDie.addAnimation("completeDie", MathUtils.getArrayofNumbers(m_treeDie.frame, 77), 20, false);
					m_treeDie.play("completeDie");
					m_state = state; 
				}
				else if ( m_state == "treeGrow" )
				{
					m_treeGrow.addAnimation("completeDie", MathUtils.getArrayofNumbers(m_treeGrow.frame, 0), 20, false);
					m_treeGrow.play("completeDie");
					m_state = "dieGrow";
				}
				else if ( m_state == "rootsGrow" )
				{
					m_roots.addAnimation("completeDie", MathUtils.getArrayofNumbers(m_roots.frame, 0), 20, false);
					m_roots.play("completeDie");
					m_state = "ungrowRoot";
				}
			}
			else
			{
				m_state = state; 
				play(m_state);
			}
		}
		
		public function die():void
		{
			// on detruit tous les fruits ( s'il en reste )
			if ( m_fruits != null )
			{
				for ( var i:int = 0; i < m_fruits.length; i++ ) {
					m_fruits[i].setState("die");
				}
			}
			
			if (m_treeDie != null && m_roots.finished) 
			{
				if ( !m_planet.isDead() && !m_planet.isDying() )
				{
					reinit();
				}
				else
				{
					this.visible = false;
				}
			}
		}
		
		public function isFeeding():Boolean {
			return ( m_state == "feed" && m_fruits.length > 0 );
		}
		
		override public function getPos():Number {
			return (m_pos + m_gap );
		}
		
		public function isVisible():Boolean
		{
			return this.visible;
		}
		
		public function isGrowing():Boolean
		{
			return (this.m_state == "treeGrow" || 
					this.m_state == "rootsGrow");
		}
		
		public function isDead():Boolean
		{
			return (this.m_state == "die") || (this.m_state == "ungrowRoot");
		}
		
		public function getFruits():Array {
			return m_fruits;
		}
		
		public function raining():void
		{
			m_state = "revive";
			m_treeDie.addAnimation("revive", MathUtils.getArrayofNumbers(0, m_treeDie.frame).reverse(), 20, false);	
			m_treeDie.play("revive");
			
			var cpt:int = 0;

			// s'il n'y a plus de fruits, l'arbre meurt
			for (var i:int = 0; i < m_fruits.length; i++) 
			{
				if ( !m_fruits[i].alive ) {
					cpt++;
				}
			}
			
			if ( cpt == m_fruits.length )
			{
				for (var i:int = 0; i < m_fruits.length; i++) {
					m_fruits[i].destroy();
				}
				createFruits();
			}
		}
		
		public function reinit():void
		{
			var size:int = m_otherTrees.length;
			if ( size > 0 )
			{
				var randomPos:Number = FlxG.random() * 360;
				
				var t:Tree; // nearest tree (the closer one)
				var distMin:Number = 1000; // distance of the nearest tree
				var dist:Number = 0;
				
				var nbIteration:uint = 0;
				
				while ( dist < 25 && nbIteration < 25)
				{
					randomPos = FlxG.random() * 360;
					distMin = 1000;
					
					for (var i:int = 0; i < size ; i++) 
					{
						//pour ce blobby
						t = m_otherTrees[i];
						if ( t == null )
							continue;
							
						dist = MathUtils.calculateDistance(randomPos, t.m_pos);
						if ( dist < distMin )
						{
							distMin = dist;
						}		
					}
					
					dist = distMin;
					nbIteration++;
				}
				
				if ( nbIteration >= 25 )
				{
					return;
				}
				
				this.m_pos = randomPos;
				m_roots.play("grow");
			}
			
			m_state = "rootsGrow";
			this.visible = true;
		}
	}

}