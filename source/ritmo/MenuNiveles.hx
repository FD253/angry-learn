package ritmo;
import flixel.ui.FlxButton;
import haxe.macro.Type;
import flixel.FlxG;


/**
 * ...
 * @author Gabriel
 */
class MenuNiveles extends MenuDeEnlace
{
	static function _nivel1()
	{
		Ejercicio.nivelInicio = Niveles.nivel1;
		FlxG.switchState(new Ejercicio());
	}
	
	override public function create():Void 
	{
		super.create();
		
		botonesDeMenu.add(new FlxButton(0, 0, "1", _nivel1));
		agregarBoton("VOLVER", MenuRitmoLector);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
	
}