package ritmo;

import flixel.text.FlxText;
import flixel.FlxState;

/**
 * ...
 * @author ...
 */
class FinNivel extends FlxState
{
	public static var resultadoInicio : Float;
	
	// PRIVATE
	var resultado : Float;
	
	override public function create() {
		resultado = resultadoInicio;
		add(new FlxText(0, 0, 0, Std.string(resultado)));
	}
	
}