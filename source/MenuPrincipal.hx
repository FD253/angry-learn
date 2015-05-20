package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import karaoke.Logica;
import openfl.system.Capabilities;
import ritmo.Nivel;
import flixel.util.FlxColor;
import openfl.system.System;

enum Juego {
	Ritmo;
	Karaoke;
	Trazos;
}

class MenuPrincipal extends BaseEstado
{
	var juegoSeleccionado : Juego;
	
	var panelNiveles : FlxSpriteGroup;
	var btnIniciarJuego : FlxButton;
	
	var globoPuntaje : FlxSpriteGroup;
	var globoPuntajeTexto : FlxText;
	
	var btnKaraoke : FlxButton;
	var btnTrazos : FlxButton;
	var btnRitmo : FlxButton;

	override public function create():Void 
	{
		super.create();
		
		panelNiveles = new FlxSpriteGroup(0, 0);
		panelNiveles.updateHitbox();
		
		var fondo = new FlxSprite(0, 0, AssetPaths.fondo_lista_juegos__png);
		panelNiveles.add(fondo);
		
		panelNiveles.setPosition(FlxG.width - panelNiveles.width - FlxG.width * 0.08, // Un cacho más a la izquierda del borde derecho
								 FlxG.height * 0.15);
		add(panelNiveles);
		
		var textSize = 30;
		var espacioEntreBotones = 15;
		
		btnKaraoke = new FlxButton(0, 0, '', btnKaraokeOnClick);
		btnKaraoke.loadGraphic(AssetPaths.selector_normal__png);
		btnKaraoke.x = (panelNiveles.width / 2) - (btnKaraoke.width / 2);
		btnKaraoke.y = panelNiveles.height * 0.23;
		var txtKaraoke = new FlxText(btnKaraoke.x + btnKaraoke.width * 0.25,
									 btnKaraoke.y,
									 0, 'KARAOKE', textSize);
		txtKaraoke.font = AssetPaths.carter__ttf;
		txtKaraoke.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtKaraoke.y = btnKaraoke.y + (btnKaraoke.height / 2) - (txtKaraoke.height / 2) - (txtKaraoke.size * 0.3);
		
		btnTrazos = new FlxButton(btnKaraoke.x, 0, '', btnTrazosOnClick);
		btnTrazos.loadGraphic(AssetPaths.selector_normal__png);
		btnTrazos.y = btnKaraoke.y + btnKaraoke.height + espacioEntreBotones;
		var txtTrazos = new FlxText(btnTrazos.x + btnTrazos.width * 0.25,
									 btnTrazos.y,
									 0, 'SIGUE EL TRAZO!', textSize);
		txtTrazos.font = AssetPaths.carter__ttf;
		txtTrazos.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtTrazos.y = btnTrazos.y + (btnTrazos.height / 2) - (txtTrazos.height / 2) - (txtTrazos.size * 0.3);
		
		btnRitmo = new FlxButton(btnKaraoke.x, 0, '', btnRitmoOnClick);
		btnRitmo.loadGraphic(AssetPaths.selector_normal__png);
		btnRitmo.y = btnTrazos.y + btnTrazos.height + espacioEntreBotones;
		var txtRitmo = new FlxText(btnRitmo.x + btnRitmo.width * 0.25,
									 btnRitmo.y,
									 0, 'RITMO LECTOR', textSize);
		txtRitmo.font = AssetPaths.carter__ttf;
		txtRitmo.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		txtRitmo.y = btnRitmo.y + (btnRitmo.height / 2) - (txtRitmo.height / 2) - (txtRitmo.size * 0.3);
		
		panelNiveles.add(btnKaraoke);
		panelNiveles.add(btnTrazos);
		panelNiveles.add(btnRitmo);
		panelNiveles.add(txtKaraoke);
		panelNiveles.add(txtTrazos);
		panelNiveles.add(txtRitmo);

		
		// Botón de inicio del juego seleccionado (arranca invisible)
		btnIniciarJuego = new FlxButton(0, 0, '', btnIniciarJuegoOnClick);
		btnIniciarJuego.loadGraphic(AssetPaths.boton_iniciar_juego__png);
		btnIniciarJuego.setPosition(panelNiveles.width - btnIniciarJuego.width - panelNiveles.width * 0.1, // Un poco a la izquierda y arriba de la esquina del panel
									panelNiveles.height - btnIniciarJuego.height - panelNiveles.height * 0.07);
		btnIniciarJuego.visible = false;
		panelNiveles.add(btnIniciarJuego);
		
		
		// Globo con el puntaje (arranca invisible)
		globoPuntaje = new FlxSpriteGroup(0, 0);
		globoPuntaje.visible = false;
		
		// Fondo verde
		var globoPuntajeFondo = new FlxSprite();
		globoPuntajeFondo.loadGraphic(AssetPaths.fondo_globo_puntaje__png);
		globoPuntaje.add(globoPuntajeFondo);
		
		// Texto
		globoPuntajeTexto = new FlxText(0, 2);
		globoPuntajeTexto.wordWrap = false;
		globoPuntajeTexto.autoSize = false;
		globoPuntajeTexto.fieldWidth = globoPuntajeFondo.width;
		globoPuntajeTexto.font = AssetPaths.carter__ttf;
		globoPuntajeTexto.size = textSize;
		globoPuntajeTexto.alignment = "center";
		globoPuntajeTexto.text = "0";
		globoPuntaje.add(globoPuntajeTexto);
		
		panelNiveles.add(globoPuntaje);
		globoPuntaje.x = btnKaraoke.x + btnKaraoke.width - globoPuntaje.width * 0.4;
	}
	
	function reiniciarBotones() {
		btnKaraoke.loadGraphic(AssetPaths.selector_normal__png);
		btnTrazos.loadGraphic(AssetPaths.selector_normal__png);
		btnRitmo.loadGraphic(AssetPaths.selector_normal__png);
		globoPuntaje.visible = false;
		btnIniciarJuego.visible = false;
		juegoSeleccionado = null;
	}
	
	function btnKaraokeOnClick() {
		btnKaraoke.loadGraphic(AssetPaths.selector_seleccionado__png);
		btnTrazos.loadGraphic(AssetPaths.selector_gris__png);
		btnRitmo.loadGraphic(AssetPaths.selector_gris__png);
		globoPuntaje.y = btnKaraoke.y + btnKaraoke.height / 2 - globoPuntaje.height / 2;
		globoPuntajeTexto.text = Std.string(Reg.puntosKaraoke);
		globoPuntaje.visible = true;
		btnIniciarJuego.visible = true;
		juegoSeleccionado = Juego.Karaoke;
	}
	
	function btnTrazosOnClick() {
		btnKaraoke.loadGraphic(AssetPaths.selector_gris__png);
		btnTrazos.loadGraphic(AssetPaths.selector_seleccionado__png);
		btnRitmo.loadGraphic(AssetPaths.selector_gris__png);
		globoPuntaje.y = btnTrazos.y + btnTrazos.height / 2 - globoPuntaje.height / 2;
		globoPuntajeTexto.text = Std.string(Reg.puntosTrazos);
		globoPuntaje.visible = true;
		btnIniciarJuego.visible = true;
		juegoSeleccionado = Juego.Trazos;
	}
	
	function btnRitmoOnClick() {
		btnKaraoke.loadGraphic(AssetPaths.selector_gris__png);
		btnTrazos.loadGraphic(AssetPaths.selector_gris__png);
		btnRitmo.loadGraphic(AssetPaths.selector_seleccionado__png);
		globoPuntaje.y = btnRitmo.y + btnRitmo.height / 2 - globoPuntaje.height / 2;
		globoPuntajeTexto.text = Std.string(Reg.puntosRitmo);
		globoPuntaje.visible = true;
		btnIniciarJuego.visible = true;
		juegoSeleccionado = Juego.Ritmo;
	}
	
	function btnIniciarJuegoOnClick() {
		if (juegoSeleccionado != null) {
			// Obtener la instancia del nivel del juego seleccionado y cambiarse a él
			switch (juegoSeleccionado) {
				case Juego.Ritmo:
					// Indicamos a ritmo qué nivel inicializar:
					Reg.nivelRitmoActual = 0;
					Reg.ejercicioRitmoActual = 0;
					FlxG.switchState(new ritmo.Logica());
				case Juego.Karaoke:
					karaoke.Logica.nivelInicio = karaoke.Nivel.nivel1;
					FlxG.switchState(new karaoke.Logica());
				case Juego.Trazos:
					trazos.Logica.numeroNivel = 0;
					FlxG.switchState(new trazos.Logica());
			}
		}
	}
	
		override public function update():Void 
	{
		super.update();
		
		#if mobile
		for (touch in FlxG.touches.list) {
			if (!panelNiveles.pixelsOverlapPoint(touch.getScreenPosition())) {
				// Si se toca fuera del panel selector, reiniciar las imágenes de los botones
				trace('toque fuera del panel');
				reiniciarBotones();
			}
		}
		#else
		if (FlxG.mouse.justReleased && !panelNiveles.pixelsOverlapPoint(FlxG.mouse.getScreenPosition())) {
			// Si no se fuera del panel selector, reiniciar las imágenes de los botones
			trace('click fuera del panel');
			reiniciarBotones();
		}
		#end
	}
	
}