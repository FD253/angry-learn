package ;

import flash.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class BotonEnlace extends FlxButton
{
	private var _estadoDestino: FlxState;
	
	private function cambiarEstado()
	{
		//TODO
	}
	
	public function new(X:Float = 0, Y:Float = 0, ?Text:String, ?estadoDestino: FlxState); 
	{
		super(X:Float = 0, Y:Float = 0, ?Text:String);
	}
	
}