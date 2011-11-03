package Utils 
{
	/**
	 * ...
	 * @author LittleWhite
	 */
	public class Debug 
	{
		/**
		 * If the expression is false, the program will stop and display a message about the error
		 * true, nothing happens
		 * @param	expression the expression to check
		 * @param	msg message to print as error message
		 */
		CONFIG::debug
		public static function assert(expression:Boolean, msg:String = ""):void
		{
			CONFIG::debug
			{
				if (!expression)
				{
					var stackTrace:String = "";
					try
					{
						throw new Error(msg);
					}
					catch (e:Error)
					{
						stackTrace = e.getStackTrace();

						// remove heading and first function in stack
						// since it's Assert
						var index:int  = stackTrace.indexOf("at",0);
						var index2:int = stackTrace.indexOf("\n", index);
						trace("[ASSERT] " + msg );
						trace(stackTrace.slice(index2 + 1));
					}
				}
			}
		}
		
	}

}