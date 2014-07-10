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
	static function nivel1OnClick()	{
		Logica.nivelInicio = Nivel.nivel1;
		FlxG.switchState(new Logica());
	}
	static function nivel2OnClick()	{
		Logica.nivelInicio = Nivel.nivel2;
		FlxG.switchState(new Logica());
	}
	static function nivel3OnClick()	{
		Logica.nivelInicio = Nivel.nivel3;
		FlxG.switchState(new Logica());
	}
	
	override public function create():Void 
	{
		super.create();
		
		botonesDeMenu.add(new FlxButton(0, 0, "1", nivel1OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "2", nivel2OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "3", nivel3OnClick));
		agregarBoton("VOLVER", MenuRitmoLector);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
	
}