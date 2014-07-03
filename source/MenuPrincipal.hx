package ;

import flixel.FlxG;
import flixel.util.FlxPoint;
import MenuCoordinacionVisomotriz;
import MenuRitmoLector;

/**
 * ...
 * @author Gabriel
 */
class MenuPrincipal extends MenuDeEnlace
{

	override public function create():Void 
	{
		super.create();
		_agregarBoton("RITMO LECTOR", MenuRitmoLector);
		_agregarBoton("COORDINACIÓN VISOMOTRIZ", MenuCoordinacionVisomotriz);
		_ordenarBotones();
	}
	
}