package Iteration 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Moi
	 */
	public class Utils 
	{		
		public static const DIR_RIGHT:int = 1;
		
		public function Utils() { }
		
		public function randRange(min:Number, max:Number):Number {
			return Math.floor(Math.random() * (max - min + 1)) + min;
		}
		
		public function getDirectionToElement(src:Element, dst:Element):Point {
			//diriger la blobby vers la planet
			var ax:Number = (dst.x - src.x);//variation en x
			var ay:Number = (dst.y - src.y);//variation en y
			var magn:Number = Math.sqrt( ax * ax + ay * ay );//longueur du vecteur blobby->planet
			//normaliser ce vecteur
			ax /=  magn ; 
			ay /=  magn ;
			return new Point(ax, ay);
		}
		
		public function getDirectionToPlanet(src:Element, dst:Planet):Point {
			//diriger la blobby vers la planet
			var ax:Number = (dst.x - src.x);//variation en x
			var ay:Number = (dst.y - src.y);//variation en y
			var magn:Number = Math.sqrt( ax * ax + ay * ay );//longueur du vecteur blobby->planet
			//normaliser ce vecteur
			ax /=  magn ; 
			ay /=  magn ;
			return new Point(ax, ay);
		}
		
	}

}