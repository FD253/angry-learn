package ;
import flixel.ui.FlxButton;
import flixel.FlxG;
import ServicioPosta;

class SeleccionUsuario extends BaseEstado
{
	var btnBlah : FlxButton;
	
	override public function create() 
	{
		super.create();

		btnBlah = new FlxButton(10, 10, "Blah", btnBlahOnClick);
		ServicioPosta.instancia.obtenerUsuarios();
		add(btnBlah);
	}
	
	function btnBlahOnClick()
	{
		FlxG.switchState(new MenuPrincipal());
	}
	
}