package ;

import flixel.FlxState;

/**
 * ...
 * @author Gabriel
 */
class MenuCoordinacionVisomotriz extends MenuBase
{
	override public function create():Void 
	{
		super.create();
		agregarBoton("VOLVER");
		ordenarBotones();
	}	
}