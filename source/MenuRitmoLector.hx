package ;

import flixel.FlxState;


/**
 * ...
 * @author Gabriel
 */
class MenuRitmoLector extends MenuBase
{
	override public function create():Void 
	{
		super.create();
		agregarBoton("SEGUIR EL RITMO", ritmo.MenuNiveles);
		agregarBoton("KARAOKE", karaoke.MenuNiveles);
		//agregarBoton("TETRIS CON PALABRAS", new tetris.MenuNiveles());
		agregarBoton("VOLVER");
		ordenarBotones();
	}
}