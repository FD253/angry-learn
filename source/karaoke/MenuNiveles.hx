package karaoke;

/**
 * ...
 * @author
 */
class MenuNiveles extends MenuDeEnlace
{
	function nivel1OnClick() {
		Logica.nivelInicio = Nivel.nivel1;
		FlxG.switchState(new Logica());
	}
	
	override public function create():Void 
	{
		super.create();
		
		botonesDeMenu.add(new FlxButton(0, 0, "1", nivel1OnClick));
		
		agregarBoton("VOLVER", MenuRitmoLector);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
}