package ;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import ServicioPosta;
import flash.events.Event;
import haxe.Json;
import flixel.util.FlxColor;
import StringTools;



class SeleccionUsuario extends BaseEstado
{
	var btnBlah : FlxButton;
	
	override public function create() 
	{
		super.create();

		ServicioPosta.instancia.obtenerUsuarios(this);
	}
	
	public function setearPuntaje(e: Event) {
		//var data = StringTools.replace(e.target.data, '[', '{');
		//data = StringTools.replace(data, ']', '}');
		var listaPuntajes = Json.parse(e.target.data);
		
		trace(listaPuntajes[0]);
		for (puntaje in listaPuntajes) {
			var app = '/api/v1/app/' + Std.string(puntaje.app) + '/';
			switch (app) 
			{
				case Reg.idAppKaraoke: Reg.puntosKaraoke = Std.int(puntaje.points);
				case Reg.idAppTrazos: Reg.puntosTrazos = Std.int(puntaje.points);
				case Reg.idAppRitmo: Reg.puntosRitmo = Std.int(puntaje.points);
			}
		}
	}
	
	public function setearMaximosNiveles(e: Event) {
		var listaMaximosNiveles = Json.parse(e.target.data);
		trace(listaMaximosNiveles[0]);
		for (maxNivel in listaMaximosNiveles) {
			var app = '/api/v1/app/' + Std.string(maxNivel.app) + '/';
			switch (app) 
			{
				case Reg.idAppKaraoke :Reg.maxLvlKaraoke = Std.int(maxNivel.higger_level - 1);
				case Reg.idAppRitmo: Reg.maxLvlRitmo = Std.int(maxNivel.higger_level-1);
				case Reg.idAppTrazos: Reg.maxLvlTrazos = Std.int(maxNivel.higger_level - 1);
			}
		}
	}
	
	public function mostrarUsuarios(e : Event) {
		var listaUsuarios = Json.parse(e.target.data);
		trace(listaUsuarios.objects[0].id);
		var altura = 0;
		var textSize = 30;
		for (usuario in listaUsuarios.objects) {
			if (Reg.idsUsuario.indexOf(usuario.id) != -1 ) {
				// Nos fijamos que los usuarios que tenemos hardcodeados estén en el backend
				var btnUsuario = new FlxButton(0, 0, null, function() {
					Reg.usuarioActual = usuario.resource_uri;
					ServicioPosta.instancia.obtenerPuntajes(Reg.usuarioActual, setearPuntaje);
					ServicioPosta.instancia.obtenerMaximosNiveles(Reg.usuarioActual, setearMaximosNiveles);
					
					FlxG.switchState(new MenuPrincipal());
					trace(Reg.usuarioActual);
				});
				btnUsuario.loadGraphic(AssetPaths.selector_normal__png);
				
				btnUsuario.x = (FlxG.width / 2) - (btnUsuario.width / 2);
				btnUsuario.y = FlxG.height * 0.23 + altura;
				var txtUsuario = new FlxText(btnUsuario.x + btnUsuario.width * 0.25,
									 btnUsuario.y, 0, usuario.username, textSize);
				txtUsuario.font = AssetPaths.carter__ttf;
				txtUsuario.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
				txtUsuario.y = btnUsuario.y + (btnUsuario.height / 2) - (txtUsuario.height / 2) - (txtUsuario.size * 0.3);

				add(btnUsuario);
				add(txtUsuario);
				altura += 100;
			}
		}
	}
	
}