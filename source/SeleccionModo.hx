package ;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import KeyboardTextField;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import openfl.events.Event;
import haxe.Json;
import flash.events.Event;
import openfl.events.FocusEvent;
import openfl.text.TextFormat;

class SeleccionModo extends BaseEstado
{
	var recordarme : Bool = false;
	var fondo : FlxSprite;
	var btnModoLibre : FlxButton;
	var btnModoRegistrado : FlxButton;
	var userTextInput : KeyboardTextField;
	var pwdTextInput : KeyboardTextField;
	var grupoRecordarme : FlxSpriteGroup;
	var tildeRecordarme : FlxSprite;
	var grupo : FlxSpriteGroup;
	var focusIn : Bool;
	var format : FlxTextFormat;
	var userTextLabel : FlxText;
	var pwdTextLabel : FlxText;
	
	override public function create() 
	{
		super.create();
		
		var btnReiniciar = new FlxButton(encabezado.height * 0.4, // 40% del alto de la barra naranja superior
											   FlxG.width * 0.015,	// 1.5% del ancho del juego
											   function() {
												   Reg.reiniciarMaximos();
												   FlxG.resetGame();
												   });
		btnReiniciar.loadGraphic(AssetPaths.boton_reiniciar__png);
		btnReiniciar.setGraphicSize(Std.int(btnReiniciar.height * 0.7));
		btnReiniciar.updateHitbox();
		add(btnReiniciar);
		
		grupo = new FlxSpriteGroup();
		
		fondo = new FlxSprite(0, 0, AssetPaths.fondo_panel__png);
		grupo.add(fondo);
		
		cuadroUsuario.visible = false;
		nombreUsuario.visible = false;
		var textSize = 30;
		btnModoLibre = new FlxButton(10, 10, null, btnModoLibreOnClick);
		btnModoLibre.loadGraphic(AssetPaths.modo__png);
		btnModoLibre.x = (fondo.width / 2) - (btnModoLibre.width / 2);
		btnModoLibre.y = fondo.height * 0.21;
		var txtModoLibre = new FlxText(btnModoLibre.x ,
									 btnModoLibre.y, 0, "MODO LIBRE" , textSize);
		txtModoLibre.font = AssetPaths.carter__ttf;
		txtModoLibre.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoLibre.autoSize = false;
		txtModoLibre.alignment = "center";
		txtModoLibre.fieldWidth = btnModoLibre.width;
		txtModoLibre.y = btnModoLibre.y + (btnModoLibre.height / 2) - (txtModoLibre.height / 2);
		
		//txtModoLibre.y = btnModoLibre.y + (btnModoLibre.height / 2) - (txtModoLibre.height / 2) - (txtModoLibre.size * 0.3);
		
		
		grupo.add(btnModoLibre);
		grupo.add(txtModoLibre);

		btnModoRegistrado = new FlxButton(10, 40, null, btnModoRegistradoOnClick);
		btnModoRegistrado.loadGraphic(AssetPaths.modo__png);
		btnModoRegistrado.x = (fondo.width / 2) - (btnModoRegistrado.width / 2);
		btnModoRegistrado.y = fondo.height * 0.23 + 305;
		var txtModoRegistrado = new FlxText(btnModoRegistrado.x, btnModoRegistrado.y,0, "ENTRAR" , textSize);
		txtModoRegistrado.font = AssetPaths.carter__ttf;
		txtModoRegistrado.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoRegistrado.y = btnModoRegistrado.y + (btnModoRegistrado.height / 2) - (txtModoRegistrado.height / 2) - (txtModoRegistrado.size * 0.3);
		txtModoRegistrado.wordWrap = false;
		txtModoRegistrado.autoSize = false;
		txtModoRegistrado.fieldWidth = btnModoRegistrado.width;
		txtModoRegistrado.alignment = "center";
		
		
		
		grupoRecordarme = new FlxSpriteGroup();
		
		tildeRecordarme = new FlxButton(0, 0, "", btnTildeOnClick);
		tildeRecordarme.loadGraphic(AssetPaths.tilde_vacio__png);
		
		var txtRecordarme = new FlxText(0, 0, 0, "RECORDARME" , Std.int(textSize * 0.8));
		txtRecordarme.font = AssetPaths.carter__ttf;
		txtRecordarme.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		txtRecordarme.autoSize = false;
		txtRecordarme.alignment = "left";
		txtRecordarme.fieldWidth = btnModoLibre.width - tildeRecordarme.width;
		txtRecordarme.y = tildeRecordarme.y + (tildeRecordarme.height / 2) - (txtRecordarme.height / 2);
		
		grupoRecordarme.add(tildeRecordarme);
		grupoRecordarme.add(txtRecordarme);
		txtRecordarme.x = tildeRecordarme.width + 10;
		
		grupoRecordarme.setPosition(btnModoRegistrado.x, btnModoRegistrado.y - grupoRecordarme.height - 10);
		
		
		grupo.add(grupoRecordarme);
		grupo.add(btnModoRegistrado);
		grupo.add(txtModoRegistrado);
		
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2 - grupo.height / 2);
		
		add(grupo);
		
		userTextInput = KeyboardTextField.getKeyboardField();
		userTextInput.width = 300;
		userTextInput.width = userTextInput.width * (FlxG.stage.stageWidth / FlxG.width);
		//userTextInput.x = (FlxG.stage.stageWidth - userTextInput.width) / 2;
		var porcentajeEnPantalla = 0.35;
		userTextInput.x = (grupo.x + grupo.width * porcentajeEnPantalla) / FlxG.width * FlxG.stage.stageWidth;
		userTextInput.height = userTextInput.height * (FlxG.stage.stageHeight / FlxG.height);
		userTextInput.y = (FlxG.stage.stageHeight - userTextInput.height) * 0.5;
		userTextInput.defaultTextFormat = new TextFormat("Carter One", 24 * FlxG.stage.stageHeight / FlxG.height);

		
		trace("UsuarioXY ", userTextInput.x, " ", userTextInput.y);
		//userTextLabel = new FlxText(445 , 373, 0, "USUARIO", 31);
		userTextLabel = new FlxText(grupo.x + grupo.width * 0.05, 373, 0, "USUARIO", 31);

		
		userTextLabel.font = AssetPaths.carter__ttf;
		format = new FlxTextFormat(FlxColor.WHITE, true);
		userTextLabel.addFormat(format);
		userTextLabel.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		add(userTextLabel);
		
		pwdTextInput = KeyboardTextField.getKeyboardField();
		pwdTextInput.x = userTextInput.x;
		pwdTextInput.width = 300;
		pwdTextInput.width = pwdTextInput.width * (FlxG.stage.stageWidth / FlxG.width);
		pwdTextInput.height = pwdTextInput.height * (FlxG.stage.stageHeight / FlxG.height);
		pwdTextInput.y = userTextInput.y + userTextInput.height + 10;
		pwdTextInput.displayAsPassword = true;
		pwdTextInput.defaultTextFormat = new TextFormat("Carter One", 24 * FlxG.stage.stageHeight / FlxG.height);
		
		
		pwdTextLabel = new FlxText(userTextLabel.x, (userTextLabel.y + userTextLabel.height + 10), 0, "CLAVE", 31);
		pwdTextLabel.font = AssetPaths.carter__ttf;
		format = new FlxTextFormat(FlxColor.WHITE, true);
		pwdTextLabel.addFormat(format);
		pwdTextLabel.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		add(pwdTextLabel);		
		
		#if android
		userTextInput.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
		pwdTextInput.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
		
		userTextInput.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
		pwdTextInput.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
		#end
			
		FlxG.addChildBelowMouse(userTextInput);
		FlxG.addChildBelowMouse(pwdTextInput);
		
		
		
		// Si había credenciales guardadas, las usamos
		if (Reg.credencialesGuardadas()) {
			recordarme = true;
			tildeRecordarme.loadGraphic(AssetPaths.tilde__png);
			Reg.usuarioActual = FlxG.save.data.usuarioActual;
			Reg.nombreUsuarioActual = FlxG.save.data.nombreUsuarioActual;
			Reg.usernameActual = FlxG.save.data.usernameActual;
			Reg.apiKey = FlxG.save.data.apiKey;
			userTextInput.text = Reg.usernameActual;
			pwdTextInput.text = "asdfghjj";	// Random para que aparezcan asteriscos... No se va a usar total
		}
	}
	
	function btnTildeOnClick() {
		if (recordarme) {
			// No quiere que lo recuerden más... Olvidar todo
			recordarme = false;
			tildeRecordarme.loadGraphic(AssetPaths.tilde_vacio__png);
			userTextInput.text = "";
			pwdTextInput.text = "";
			
			Reg.usuarioActual = null;
			Reg.nombreUsuarioActual = null;
			Reg.usernameActual = null;
			Reg.apiKey = null;
			
			FlxG.save.erase();
		}
		else {
			// Quiere que lo recuerden
			recordarme = true;
			tildeRecordarme.loadGraphic(AssetPaths.tilde__png);
		}
	}
	
	function handleFocusIn(event:FocusEvent) {
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2.7 - grupo.height / 2);
		userTextInput.y = (FlxG.stage.stageHeight - userTextInput.height) * 0.375;
		pwdTextInput.y = userTextInput.y + userTextInput.height + 10;
		trace("UserXY2 ", userTextInput.x, " ", userTextInput.y);
		trace("PassY2 ", pwdTextInput.y);
		userTextLabel.y = 275;
		pwdTextLabel.y = userTextLabel.y + userTextLabel.height + 5;
		focusIn = true;
	}
	
	function handleFocusOut(event:FocusEvent) {
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2 - grupo.height / 2);
		userTextInput.y = (FlxG.stage.stageHeight - userTextInput.height) * 0.5;
		pwdTextInput.y = userTextInput.y + userTextInput.height + 10;
		userTextLabel.y = 373;
		pwdTextLabel.y = userTextLabel.y + userTextLabel.height;
		focusIn = false;
		
	}
	
	override public function destroy() {
		super.destroy();
		FlxG.removeChild(userTextInput);
		FlxG.removeChild(pwdTextInput);
	}
	
	function btnModoLibreOnClick()
	{
		if (focusIn == false) {
			Reg.setearModoLibre();
			Reg.modoDeJuego = Reg.LIBRE;
			FlxG.switchState(new MenuPrincipal());
		}
	}
	
	public function setearPuntaje(e: Event) {
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
	
	function manejadorLogueo(e : Event) {
		
		var data = Json.parse(e.target.data);
		trace(data);
		if (data.success == true) {
			Reg.apiKey = data.api_key;
			Reg.modoDeJuego = Reg.REGISTRADO;
			Reg.usuarioActual = ServicioPosta.obtenerUriUsuario(data.user_id);
			Reg.nombreUsuarioActual = userTextInput.text;
			Reg.usernameActual = userTextInput.text;
			
			ServicioPosta.instancia.obtenerPuntajes(Reg.usuarioActual, setearPuntaje);
			ServicioPosta.instancia.obtenerMaximosNiveles(Reg.usuarioActual, setearMaximosNiveles);
			
			if (recordarme) {
				FlxG.save.data.usuarioActual = Reg.usuarioActual;
				FlxG.save.data.nombreUsuarioActual = Reg.nombreUsuarioActual;
				FlxG.save.data.usernameActual = Reg.usernameActual;
				FlxG.save.data.apiKey = Reg.apiKey;
				
				FlxG.save.flush();
			}
			
			FlxG.switchState(new MenuPrincipal());
			trace(Reg.usuarioActual);

		} else {
			var error = new MensajeError();
			add(error);
			error.textoError.text = "USUARIO O CLAVE INCORRECTOS";
			userTextInput.visible = false;
			pwdTextInput.visible = false;
			userTextLabel.visible = false;
			pwdTextLabel.visible = false;
			grupo.visible = false;
			error.visible = true;
		}
	}
	
	function btnModoRegistradoOnClick()
	{
		if (focusIn == false) {
			grupo.active = false;

			if (Reg.credencialesGuardadas() == false) {
				// Si no se recordaba al usuario loguear con lo que hay en los campos de texto
				ServicioPosta.instancia.loguearUsuario(userTextInput.text, pwdTextInput.text, manejadorLogueo);	
			} 
			else {
				trace('usando credenciales almacenadas');				
				ServicioPosta.instancia.obtenerPuntajes(Reg.usuarioActual, setearPuntaje);
				ServicioPosta.instancia.obtenerMaximosNiveles(Reg.usuarioActual, setearMaximosNiveles);
				
				FlxG.switchState(new MenuPrincipal());
			}

		}
	}
}