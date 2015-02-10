package ritmo;

import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import flixel.text.FlxText;
import flixel.FlxState;

class FinNivel extends JuegoBase
{
	public static var resultadoInicio : Float;
	
	// PRIVATE
	var resultado : Float;
	
	override public function create() {
		resultado = resultadoInicio;
		add(new FlxText(0, 0, 0, Std.string(resultado)));
		
		if (Reg.level > 0) {	// No hay botón al nivel anterior
			add(new FlxUIButton(10, 10, "<-", btnAnteriorOnClick));
		}
		
		if (Reg.level != Nivel.niveles.length - 1) { // No hay botón al nivel anterior
			var btnSiguiente = new FlxUIButton(FlxG.stage.stageWidth - 10, 10, "->", btnSiguienteOnClick);
			btnSiguiente.x -= btnSiguiente.width;
			add(btnSiguiente);
		}
	}
	
	function btnAnteriorOnClick() {
		Logica.nivelInicio = Nivel.niveles[Reg.level - 1];
		FlxG.switchState(new Logica());
	}
	
	function btnSiguienteOnClick() {
		Logica.nivelInicio = Nivel.niveles[Reg.level + 1];
		FlxG.switchState(new Logica());
	}
	
}