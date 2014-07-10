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
		agregarBoton("VOLVER", MenuRitmoLector);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
}