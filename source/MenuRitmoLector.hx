package ;

import flixel.FlxState;
import ritmo.MenuNiveles;

/**
 * ...
 * @author Gabriel
 */
class MenuRitmoLector extends MenuDeEnlace
{
	override public function create():Void 
	{
		super.create();
		_agregarBoton("Ritmo", new MenuNiveles());
		_ordenarBotones();
	}
}