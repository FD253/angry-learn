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
import openfl.events.MouseEvent;



/**
 * ...
 * @author ...
 */
class Logica extends FlxState
{
	// Se debe asignar el nivel acá antes de instanciar Logica
	//	para que así tome de acá el nivel que tiene que ejecutar
	//public static var nivelInicio : Nivel;
	
	var nivel : Nivel;
	var enCurso : Bool;
	
	override public function create() {
		super.create();
		//nivel = Logica.nivelInicio;	// Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		
		// TODO: Para tener los niveles codificados usar un TypeDef e ir instanciándolos acá.
		//	Es la solución que se me ocurre y aún falta probar
		nivel = new Nivel(
			AssetPaths.test_trace__png,
			null,
			new FlxShapeCircle(185, 276, 10, { thickness: null, color: FlxColor.TRANSPARENT }, { color: FlxColor.WHITE }),
			new FlxShapeCircle(488, 65, 10, { thickness: null, color: FlxColor.TRANSPARENT }, { color: FlxColor.WHITE })
		);
		
		add(nivel.spriteTrazo);
		add(nivel.spriteFondo);
		add(nivel.areaFin);
		add(nivel.areaInicio);
		
		enCurso = false;	// Indicamos que el usuario no está jugando (para que update() no cuente)
		
		//var lvl = new Nivel(
			//AssetPaths.test_trace__png,
			//null,
			//new FlxShapeCircle(185, 276, 15, { thickness: 1 }, { color: FlxColor.RED }),
			//new FlxShapeCircle(488, 65, 15, { thickness: 1 }, { color: FlxColor.RED })
		//);
		//nivel = lvl;
		//add(lvl.spriteTrazo);
		//add(lvl.areaInicio);
		//add(lvl.areaFin);
		//add(new FlxShapeCircle(185, 276, 7.5, { thickness: 1 }, { color: FlxColor.RED } ));

	}
	
	override public function update() {
		super.update();
		if (!enCurso && pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaInicio)) {
			// Si el juego no arrancó y se pisó el area de inicio
			trace("Juego iniciado");
			enCurso = true;	// Arrancamos
		}
		
		if (enCurso) {
			// Si el juego está en curso el mouse NO puede dejar de tocar la línea hasta que llegue al areaFin
			if (!pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.spriteTrazo)) {
				// Si no toca el trazo pierde
				trace("Juego perdido");
				enCurso = false;
			}
			if (pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaFin)) {
				// Si no toca el trazo, el juego termina (Porque antes debería tocarse el areaFin ya que se solapa)
				trace("Juego ganado");
				enCurso = false;
			}
		}
	}
	
	function areaInicioOnMouseOver(e : MouseEvent) {
		// Se pasó el mouse sobre el area de inicio, por lo que...
		enCurso = true;
	}

}