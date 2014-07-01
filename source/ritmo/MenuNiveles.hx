package ritmo;

/**
 * ...
 * @author Gabriel
 */
class MenuNiveles extends MenuDeEnlace
{
	override public function create():Void 
	{
		super.create();
		_agregarBoton("1", new Nivel1());
		_ordenarBotones();
	}
}