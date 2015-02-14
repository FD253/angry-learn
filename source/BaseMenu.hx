package ;

import flash.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

using BotonMenu;

class BaseMenu extends BaseEstado
{
	var botonesDeMenu: List<FlxButton> = new List<FlxButton>();
	
	static function _volver() {
		FlxG.switchState(new MenuPrincipal());
	}
	
	function agregarBoton(texto: String, ?estadoDestino: Class<FlxState>): FlxButton {
		
		if (estadoDestino != null) {
			var botonNuevo: BotonMenu = new BotonMenu(texto, estadoDestino);
			botonesDeMenu.add(botonNuevo); // Lo agregamos a la lista interna para después cuando estén todos poder ordenarlos
			//this.add(botonNuevo);	// No lo agregamos ahora porque puede mostrarse en la esquina 0,0 y moverse cuando se ejecuta this._ordenarBotones()
			botonNuevo.loadGraphic(AssetPaths.boton_azul__png, true, 190, 49);
			return botonNuevo;
		}
		else {
			var botonNuevo = new FlxButton(0, 0, texto, _volver);
			botonesDeMenu.add(botonNuevo);
			return botonNuevo;
		}
	}
	
	/*
	 * Ordena los botones que fueron asignados al estado como botones de menú y los aagrega al estado en sí para que estén disponibles
	 */
	function ordenarBotones() {
		var suma_alturas_botones:Float = 0;
		for (i in botonesDeMenu) {
			suma_alturas_botones += i.height;
		}
		trace("suma_altura_botones " + suma_alturas_botones);
		var espacioIntermedio: Float = (FlxG.height - suma_alturas_botones) / (botonesDeMenu.length + 1);
		trace("espacioIntermedio " + espacioIntermedio);
		trace("FlxG.height " + FlxG.height);
		trace("FlxG.game.height " + FlxG.game.height);
		
		trace("botonesDeMenu.length " + botonesDeMenu.length );
		var y_acum = espacioIntermedio;
		for (j in botonesDeMenu) {
			j.y = y_acum; 
			trace("boton y " + j.y);
			j.screenCenter(true, false);
			add(j);
			y_acum += j.height + espacioIntermedio;
		}
	}	
}