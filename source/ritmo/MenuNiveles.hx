package ritmo;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUICheckBox;
import haxe.macro.Type;
import flixel.FlxG;


/**
 * ...
 * @author Gabriel
 */
class MenuNiveles extends MenuBase
{
	var chkFeedbackVisual : FlxUICheckBox;
	
	function nivel1OnClick()	{
		Logica.nivelInicio = Nivel.niveles[0];
		FlxG.switchState(new Logica());
	}
	function nivel2OnClick()	{
		Logica.nivelInicio = Nivel.niveles[1];
		FlxG.switchState(new Logica());
	}
	function nivel3OnClick()	{
		Logica.nivelInicio = Nivel.niveles[2];
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