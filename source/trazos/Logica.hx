package trazos;

import Reg;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxCollision.pixelPerfectPointCheck;

/**
 * ...
 * @author ...
 */
class Logica extends FlxState
{
	// Se debe asignar el nivel acá antes de instanciar Logica
	//	para que así tome de acá el nivel que tiene que ejecutar
	public static var nivelInicio : Nivel;
	
	var nivel : Nivel;
	
	override public function create() {
		super.create();
		nivel = Logica.nivelInicio;	// Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		add(nivel.spriteTrazo);
		//add(nivel.spriteFondo);
		add(nivel.areaFin);
		add(nivel.areaInicio);
	}
	
	override public function update() {
		super.update();
		if (pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaInicio)) {
			trace("colision");
		}
		else {
			trace("no colision");
		}
	}
}