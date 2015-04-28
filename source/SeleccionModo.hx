package ;
import flixel.FlxG;
import flixel.ui.FlxButton;

class SeleccionModo extends BaseEstado
{
	var btnModoLibre : FlxButton;
	var btnModoRegistrado : FlxButton;
	override public function create() 
	{
		super.create();
		
		btnModoLibre = new FlxButton(10, 10, "Modo libre", btnModoLibreOnClick);
		btnModoRegistrado = new FlxButton(10, 40, "Modo registrado", btnModoRegistradoOnClick);
		
		add(btnModoLibre);
		add(btnModoRegistrado);
	}
	
	function btnModoLibreOnClick()
	{
		FlxG.switchState(new MenuPrincipal());
	}
	
	function btnModoRegistradoOnClick()
	{
		FlxG.switchState(new SeleccionUsuario());
	}
}