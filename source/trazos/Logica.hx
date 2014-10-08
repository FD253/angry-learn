package trazos;

import flixel.util.FlxSpriteUtil;
import Reg;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxCollision.pixelPerfectPointCheck;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxColor;



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
		//nivel = Logica.nivelInicio;	// Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		//add(nivel.spriteTrazo);
		////add(nivel.spriteFondo);
		//add(nivel.areaFin);
		//add(nivel.areaInicio);
		
		var lvl = new Nivel(
			AssetPaths.test_trace__png,
			null,
			new FlxShapeCircle(185, 276, 15, { thickness: 1 }, { color: FlxColor.RED }),
			new FlxShapeCircle(488, 65, 15, { thickness: 1 }, { color: FlxColor.RED })
		);
		nivel = lvl;
		add(lvl.spriteTrazo);
		add(lvl.areaInicio);
		add(lvl.areaFin);
		//add(new FlxShapeCircle(185, 276, 7.5, { thickness: 1 }, { color: FlxColor.RED } ));

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