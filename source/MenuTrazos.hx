package ;

import flixel.FlxState;
import trazos.Logica;

/**
 * ...
 * @author ...
 */
class MenuTrazos extends MenuDeEnlace
{

	override public function create():Void 
	{
		super.create();
		agregarBoton("TEST", Logica);
		
		agregarBoton("VOLVER");
		ordenarBotones();
	}
}