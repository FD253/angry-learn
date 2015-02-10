package ;

import flixel.FlxG;
import flixel.util.FlxPoint;
import MenuCoordinacionVisomotriz;
import MenuRitmoLector;
import MenuTrazos;

/**
 * ...
 * @author Gabriel
 */
class MenuPrincipal extends MenuBase
{

	override public function create():Void 
	{
		super.create();
		agregarBoton("RITMO LECTOR", MenuRitmoLector);
		agregarBoton("COORDINACIÓN VISOMOTRIZ", MenuCoordinacionVisomotriz);
		agregarBoton("TRAZOS", MenuTrazos);
		ordenarBotones();
	}
	
}