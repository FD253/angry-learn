package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import MenuCoordinacionVisomotriz;
import MenuRitmoLector;
import MenuTrazos;

class MenuPrincipal extends BaseMenu
{
	
	var panelNiveles : FlxSpriteGroup;
	var btnIniciarJuego : FlxButton;
	
	var gp : FlxButton;
	
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
		
		panelNiveles.setPosition((FlxG.width - panelNiveles.width) - 70, 65);
		add(panelNiveles);
		
		// Agregamos las imágenes de los botones al panel
		btnKaraoke = new FlxButton(30, 75, '', btnKaraokeOnClick);
		btnKaraoke.loadGraphic(AssetPaths.selector_karaoke_color__png);
		btnTrazos = new FlxButton(30, 0, '', btnTrazosOnClick);
		btnTrazos.loadGraphic(AssetPaths.selector_trazos_color__png);
		btnTrazos.y = btnKaraoke.y + btnKaraoke.height + 10;
		btnRitmo = new FlxButton(30, 0, '', btnRitmoOnClick);
		btnRitmo.loadGraphic(AssetPaths.selector_ritmo_color__png);
		btnRitmo.y = btnTrazos.y + btnTrazos.height + 10;
		
		panelNiveles.add(btnKaraoke);
		panelNiveles.add(btnTrazos);
		panelNiveles.add(btnRitmo);
		
		// Botón de inicio del juego seleccionado (arranca invisible)
		btnIniciarJuego = new FlxButton(175, 275, '', btnIniciarJuegoOnClick);
		btnIniciarJuego.loadGraphic(AssetPaths.boton_iniciar_juego__png);
		btnIniciarJuego.visible = false;
		panelNiveles.add(btnIniciarJuego);
		
		
		// Globo con el puntaje (arranca invisible)
		globoPuntaje = new FlxSpriteGroup(250, 0);	// Place it to the right
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
		globoPuntajeTexto.size = 14;
		globoPuntajeTexto.alignment = "center";
		globoPuntajeTexto.text = "0";
		globoPuntaje.add(globoPuntajeTexto);
		
		panelNiveles.add(globoPuntaje);

		
		// Sólo por ahora seguimos con los botones de prueba
		agregarBoton("RITMO LECTOR", MenuRitmoLector);
		agregarBoton("COORDINACIÓN VISOMOTRIZ", MenuCoordinacionVisomotriz);
		agregarBoton("TRAZOS", MenuTrazos);
		ordenarBotones();

	}
	
	function reiniciarBotones() {
		btnKaraoke.loadGraphic(AssetPaths.selector_karaoke_color__png);
		btnTrazos.loadGraphic(AssetPaths.selector_trazos_color__png);
		btnRitmo.loadGraphic(AssetPaths.selector_ritmo_color__png);
		globoPuntaje.visible = false;
		btnIniciarJuego.visible = false;
	}
	
	function btnKaraokeOnClick() {
		btnKaraoke.loadGraphic(AssetPaths.selector_karaoke_seleccionado__png);
		btnTrazos.loadGraphic(AssetPaths.selector_trazos_gris__png);
		btnRitmo.loadGraphic(AssetPaths.selector_ritmo_gris__png);
		globoPuntaje.y = btnKaraoke.y + 12;
		globoPuntajeTexto.text = "111111";
		globoPuntaje.visible = true;
		btnIniciarJuego.visible = true;
	}
	
	function btnTrazosOnClick() {
		btnKaraoke.loadGraphic(AssetPaths.selector_karaoke_gris__png);
		btnTrazos.loadGraphic(AssetPaths.selector_trazos_seleccionado__png);
		btnRitmo.loadGraphic(AssetPaths.selector_ritmo_gris__png);
		globoPuntaje.y = btnTrazos.y + 12;
		globoPuntajeTexto.text = "222222";
		globoPuntaje.visible = true;
		btnIniciarJuego.visible = true;
	}
	
	function btnRitmoOnClick() {
		btnKaraoke.loadGraphic(AssetPaths.selector_karaoke_gris__png);
		btnTrazos.loadGraphic(AssetPaths.selector_trazos_gris__png);
		btnRitmo.loadGraphic(AssetPaths.selector_ritmo_seleccionado__png);
		globoPuntaje.y = btnRitmo.y + 12;
		globoPuntajeTexto.text = "3333333";
		globoPuntaje.visible = true;
		btnIniciarJuego.visible = true;
	}
	
	function btnIniciarJuegoOnClick() {
		
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