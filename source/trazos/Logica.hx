package trazos;


import flash.display.JointStyle;
import flixel.util.FlxPoint;
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

using flixel.util.FlxSpriteUtil;


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
	
	//donde vamos a mostrar lo que dibuja el usuario.
	var canvas:FlxSprite;
	var line_style:LineStyle;
	var draw_style:DrawStyle;
	var ult_pos:FlxPoint;
	
	var p_acierto:Int = 0;
	var p_fallido:Int = 0;
	
	
	override public function create() {
		super.create();
		//nivel = Logica.nivelInicio;	// Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		
		// TODO: Para tener los niveles codificados usar un TypeDef e ir instanciándolos acá.
		//	Es la solución que se me ocurre y aún falta probar
		nivel = new Nivel(
			AssetPaths.test_trace__png,
			null,
			new FlxShapeCircle(185, 276, 10, { thickness: null, color: FlxColor.TRANSPARENT }, { color: FlxColor.RED }),
			new FlxShapeCircle(488, 65, 10, { thickness: null, color: FlxColor.TRANSPARENT }, { color: FlxColor.RED })
		);
		
		add(nivel.spriteTrazo);
		add(nivel.spriteFondo);
		add(nivel.areaFin);
		add(nivel.areaInicio);
		
		canvas = new FlxSprite();
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(canvas);
		line_style = { thickness: 10, color: FlxColor.RED, jointStyle:JointStyle.ROUND, pixelHinting: true };
		draw_style = { smoothing: true };
		ult_pos = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
		
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
			ult_pos.x = FlxG.mouse.x;
			ult_pos.y = FlxG.mouse.y;
			enCurso = true;	// Arrancamos
		}
		
		if (enCurso) {
			
			// solo actuo en caso de que se haya movido, por un tema de puntaje
			if (FlxG.mouse.x != ult_pos.x || FlxG.mouse.y != ult_pos.y) {			
				
				// Si el juego está en curso el mouse NO puede dejar de tocar la línea hasta que llegue al areaFin
				if (!pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.spriteTrazo)) {
					// Si no toca el trazo pierde
					//trace("Juego perdido");
					//enCurso = false;
					p_fallido++;
				} else 	if (pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaFin)) {
					// Si no toca el trazo, el juego termina (Porque antes debería tocarse el areaFin ya que se solapa)
					//trace("Juego ganado");
					enCurso = false;
					trace("p_acierto " + p_acierto + " p_fallido " + p_fallido + " porcentaje " + (p_acierto / (p_fallido + p_acierto) * 100));
				} else {
					p_acierto++;
				}
				
				canvas.drawLine(ult_pos.x, ult_pos.y, FlxG.mouse.x, FlxG.mouse.y, line_style, draw_style);
				ult_pos.x = FlxG.mouse.x;
				ult_pos.y = FlxG.mouse.y;
			}
		}
	}
	
	function areaInicioOnMouseOver(e : MouseEvent) {
		// Se pasó el mouse sobre el area de inicio, por lo que...
		enCurso = true;
	}

}