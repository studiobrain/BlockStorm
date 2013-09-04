package utils
{
	import starling.display.Sprite;
	
	public class Utility extends Sprite
	{
		public function Utility()
		{
			super();
		}
		
		public static function randNum(min:Number, max:Number):Number
		{
			return Math.floor((Math.random() * max) + min);
		}
	}
}