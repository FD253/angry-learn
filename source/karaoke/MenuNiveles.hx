package karaoke;

/**
 * ...
 * @author
 */
class MenuNiveles extends MenuDeEnlace
{
	override public function create():Void 
	{
		super.create();
		agregarBoton("1", Nivel1);
		agregarBoton("2", Nivel2);
		agregarBoton("2", Nivel3);
		agregarBoton("VOLVER", MenuRitmoLector);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
}