package Game 
{
	import Game.Objects.Blobby;
	/**
	 * ...
	 * @author Moi
	 */
	public class Record 
	{
		private var m_blobbiesIdeas:Object;
		
		public function Record() 
		{
			
		}
		
		public function init():void {
			m_blobbiesIdeas = {
								religion:-1,
								paix:-1,
								medecine:-1,
								guerre:-1,
								fanatisme:-1,
								maladie:-1
								};
		}
		
		public function addBlobby(blobby:Blobby):void {
			var ind:String = blobby.getScholar();
			//si le blobby n'est pas un érudit
			if (!blobby.getScholar()) return;
			//trace("add",ind);
			if (m_blobbiesIdeas[ind] == -1)
				m_blobbiesIdeas[ind] = 1;
			else
				m_blobbiesIdeas[ind] ++;
			//trace("added", ind,m_blobbiesIdeas[ind]);
		}
		
		public function removeBlobby(blobby:Blobby):void {
			var ind:String = blobby.getScholar();
			if (!ind) return;
			m_blobbiesIdeas[ind]--;
			//trace("remove", ind , m_blobbiesIdeas[ind]);			
		}
				
		//cherche une idée qui n'est plus représentée par les blobbies et retourne son nom
		public function checkDeprecatedIdea():Array {
			var tab:Array = new Array();
			for (var i:String in m_blobbiesIdeas) {
				//si on a plus de blobby pour l'idée
				if (m_blobbiesIdeas[i] == 0) {
					//on réinitialise cette idée
					m_blobbiesIdeas[i] = -1;
					//on retourne le nom de l'idée à refaire popper
					tab.push(i);
				}
			}
			return tab;
		}
	}

}