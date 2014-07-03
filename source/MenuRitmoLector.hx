package ;

import flixel.FlxState;


/**
 * ...
 * @author Gabriel
 */
class MenuRitmoLector extends MenuDeEnlace
{
	override public function create():Void 
	{
		super.create();
		_agregarBoton("SEGUIR EL RITMO", ritmo.MenuNiveles);
		_agregarBoton("KARAOKE", karaoke.MenuNiveles);
		//_agregarBoton("TETRIS CON PALABRAS", new tetris.MenuNiveles());
		_agregarBoton("VOLVER");
		_ordenarBotones();
	}
}