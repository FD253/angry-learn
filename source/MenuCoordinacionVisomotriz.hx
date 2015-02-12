package ;

import flixel.FlxState;

/**
 * ...
 * @author Gabriel
 */
class MenuCoordinacionVisomotriz extends BaseMenu
{
	override public function create():Void 
	{
		super.create();
		agregarBoton("VOLVER");
		ordenarBotones();
	}	
}