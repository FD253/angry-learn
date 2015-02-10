package karaoke;

import flixel.FlxG;
import flixel.ui.FlxButton;


/**
 * ...
 * @author
 */
class MenuNiveles extends MenuBase
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
	static function nivel4OnClick()	{
		Logica.nivelInicio = Nivel.nivel4;
		FlxG.switchState(new Logica());
	}
	override public function create():Void 
	{
		super.create();
		
		botonesDeMenu.add(new FlxButton(0, 0, "VOCALES", nivel1OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "SILABAS", nivel2OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "PALABRAS", nivel3OnClick));
		botonesDeMenu.add(new FlxButton(0, 0, "FRASES", nivel4OnClick));		
		agregarBoton("VOLVER", MenuRitmoLector);
		agregarBoton("Reiniciar");
		ordenarBotones();
	}
}