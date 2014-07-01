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
		_agregarBoton("Ritmo lector", new MenuRitmoLector());
		var botLargo = _agregarBoton("Coordinación visomotriz", new MenuCoordinacionVisomotriz());
		_ordenarBotones();		
	}
	
}