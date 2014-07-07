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
		agregarBoton("RITMO LECTOR", MenuRitmoLector);
		agregarBoton("COORDINACIÓN VISOMOTRIZ", MenuCoordinacionVisomotriz);
		ordenarBotones();
	}
	
}