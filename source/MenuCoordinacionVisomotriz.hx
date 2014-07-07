package ;

import flixel.FlxState;

/**
 * ...
 * @author Gabriel
 */
class MenuCoordinacionVisomotriz extends MenuDeEnlace
{
	override public function create():Void 
	{
		super.create();
		agregarBoton("VOLVER");
		ordenarBotones();
	}	
}