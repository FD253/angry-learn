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
		_agregarBoton("1", Nivel1);
		_agregarBoton("VOLVER", MenuRitmoLector);
		_agregarBoton("Reiniciar");
		_ordenarBotones();
	}
}