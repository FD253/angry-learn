package ;
import flixel.ui.FlxButton;
import flixel.FlxG;
import ServicioPosta;
import flash.events.Event;
import haxe.Json;


class SeleccionUsuario extends BaseEstado
{
	var btnBlah : FlxButton;
	
	override public function create() 
	{
		super.create();

		btnBlah = new FlxButton(10, 10, "Blah", btnBlahOnClick);
		ServicioPosta.instancia.obtenerUsuarios(this);
		add(btnBlah);
	}
	
	public function mostrarUsuarios(e : Event) {
		var listaUsuarios = Json.parse(e.target.data);
		trace(listaUsuarios.objects[0].id);
		var altura = 50;
		for (usuario in listaUsuarios.objects) {
			if (Reg.idsUsuario.indexOf(usuario.id) != -1 ) {
				// Nos fijamos que los usuarios que tenemos hardcodeados estén en el backend
				var botonUsuario = new FlxButton(15, altura, usuario.username, function() {
					Reg.usuarioActual = usuario.resource_uri;
				});
				add(botonUsuario);
				altura += 30;
			}
		}
	}

	function btnBlahOnClick()
	{
		FlxG.switchState(new MenuPrincipal());
	}
	
}