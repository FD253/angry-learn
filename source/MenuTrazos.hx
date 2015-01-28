package ;

import flixel.FlxState;
import trazos.Logica;
import trazos.MenuNiveles;

/**
 * ...
 * @author ...
 */
class MenuTrazos extends MenuDeEnlace
{

	override public function create():Void 
	{
		super.create();
		agregarBoton("TEST", MenuNiveles);
		
		agregarBoton("VOLVER");
		ordenarBotones();
	}
}