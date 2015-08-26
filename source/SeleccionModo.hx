package ;
import flixel.addons.ui.FlxInputText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import KeyboardTextField;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import openfl.events.Event;
import haxe.Json;
import flash.events.Event;
import openfl.events.FocusEvent;

class SeleccionModo extends BaseEstado
{
	var fondo : FlxSprite;
	var btnModoLibre : FlxButton;
	var btnModoRegistrado : FlxButton;
	var u : KeyboardTextField;
	var p : KeyboardTextField;
	var grupo : FlxSpriteGroup;
	var focusIn : Bool;
	var format : FlxTextFormat;
	var user : FlxText;
	var password : FlxText;
	
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
		btnModoLibre.y = fondo.height * 0.23;
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
		btnModoRegistrado.y = fondo.height * 0.23 + 300;
		var txtModoRegistrado = new FlxText(btnModoRegistrado.x + btnModoRegistrado.width * 0.25,
									 btnModoRegistrado.y, 0, "USUARIO REGISTRADO" , textSize);
		txtModoRegistrado.font = AssetPaths.carter__ttf;
		txtModoRegistrado.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtModoRegistrado.y = btnModoRegistrado.y + (btnModoRegistrado.height / 2) - (txtModoRegistrado.height / 2) - (txtModoRegistrado.size * 0.3);
		
		grupo.add(btnModoRegistrado);
		grupo.add(txtModoRegistrado);
		
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2 - grupo.height / 2);
		
		add(grupo);
		
		u = KeyboardTextField.getKeyboardField();
		u.x = (FlxG.stage.stageWidth - u.width) / 2;
		u.y = (FlxG.stage.stageHeight - u.height) * 0.5;
		u.width = 300;
		
		user = new FlxText(u.x - 100, u.y+35, 0, "USUARIO", 32);
		user.font = AssetPaths.carter__ttf;
		format = new FlxTextFormat(FlxColor.WHITE, true);
		user.addFormat(format);
		user.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		add(user);
		
		p = KeyboardTextField.getKeyboardField();
		p.x = u.x;
		p.y = u.y + u.height + 10;
		p.displayAsPassword = true;
		p.width = 300;
		
		password= new FlxText(u.x - 100, p.y+35, 0, "CLAVE", 33);
		password.font = AssetPaths.carter__ttf;
		format = new FlxTextFormat(FlxColor.WHITE, true);
		password.addFormat(format);
		password.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		add(password);		
		
		#if android
		u.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
		p.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
		
		u.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
		p.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
		#end
			
		FlxG.addChildBelowMouse(u);
		FlxG.addChildBelowMouse(p);
	}
	
	function handleFocusIn(event:FocusEvent) {
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2.7 - grupo.height / 2);
		u.y = (FlxG.stage.stageHeight - u.height) * 0.375;
		p.y = u.y + u.height + 10;
		user.y = u.y + 35;
		password.y = p.y + 35;
		focusIn = true;
	}
	
	function handleFocusOut(event:FocusEvent) {
		grupo.setPosition(FlxG.width / 2 - grupo.width / 2, FlxG.height / 2 - grupo.height / 2);
		u.y = (FlxG.stage.stageHeight - u.height) * 0.5;
		p.y = u.y + u.height + 10;
		user.y = u.y + 35;
		password.y = p.y + 35;
		focusIn = false;
		
	}
	
	override public function destroy() {
		super.destroy();
		FlxG.removeChild(u);
		FlxG.removeChild(p);
	}
	
	function btnModoLibreOnClick()
	{
		if (focusIn == false) {
			Reg.setearModoLibre();
			Reg.modoDeJuego = Reg.LIBRE;
			FlxG.switchState(new MenuPrincipal());
		}
	}
	
	function manejadorLogueo(e : Event) {
		
		var data = Json.parse(e.target.data);
		trace(data);
		if (data.success == true) {
			Reg.apiKey = data.api_key;
			Reg.modoDeJuego = Reg.REGISTRADO;
			FlxG.switchState(new SeleccionUsuario());
		} else {
			var error = new MensajeError();
			add(error);
			error.textoError.text = "USUARIO O CLAVE INCORRECTOS";
			u.visible = false;
			p.visible = false;
			grupo.visible = false;
			error.visible = true;
		}
	}
	
	function btnModoRegistradoOnClick()
	{
		if (focusIn == false) {
			ServicioPosta.instancia.loguearUsuario(u.text, p.text, manejadorLogueo);	
		}
	}
}