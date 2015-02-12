package trazos;
import flixel.FlxG;
import flixel.ui.FlxButton;

class MenuNiveles extends BaseMenu
{
	function nivel1OnClick() {
		Logica.numeroNivel = 0;	// Le decimos al juego qué nivel tiene que usar
		FlxG.switchState(new Logica());
	}
	function nivel2OnClick() {
		Logica.numeroNivel = 1;
		FlxG.switchState(new Logica());
	}
	function nivel3OnClick() {
		Logica.numeroNivel = 2;
		FlxG.switchState(new Logica());
	}
	
	override public function create():Void 
	{
		super.create();
		
		botonesDeMenu.add(new FlxButton(0, 0, "1", nivel1OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "2", nivel2OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "3", nivel3OnClick));
		agregarBoton("VOLVER", MenuTrazos);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
}