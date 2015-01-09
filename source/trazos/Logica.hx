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
import openfl.events.TouchEvent;
import openfl.events.EventDispatcher;
import flixel.plugin.MouseEventManager;

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
	var canvas : FlxSprite;
	var estiloLinea : LineStyle;
	var estiloDibujo : DrawStyle;
	var ultimaPosicion : FlxPoint;
	
	var puntosAcertados : Int = 0;	// Por cada punto dibujado dentro del trazo, se suma
	var puntosFallados : Int = 0;	// Por cada punto dibujado fuera del trazo, se resta
	
	
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
		
		// Definimos al canvas como un cuadrado que ocupa toda la pantalla
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(canvas);
		
		estiloLinea = { thickness: 10, color: FlxColor.RED, jointStyle:JointStyle.ROUND, pixelHinting: true };
		estiloDibujo = { smoothing: true };
		ultimaPosicion = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
		
		enCurso = false;	// Indicamos que el usuario no está jugando (para que update() no cuente)
	}
	
	override public function update() {
		super.update();
		
		if (!enCurso && pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaInicio)) {
			// Si el juego no arrancó y se pisó el area de inicio
			trace("Juego iniciado");
			ultimaPosicion.x = FlxG.mouse.x;
			ultimaPosicion.y = FlxG.mouse.y;
			enCurso = true;	// Arrancamos
			FlxG.stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, stageOnMouseEnd);
		}
		
		if (enCurso) {
			
			// solo actuo en caso de que se haya movido, por un tema de puntaje
			if (FlxG.mouse.x != ultimaPosicion.x || FlxG.mouse.y != ultimaPosicion.y) {			
				
				// Si el juego está en curso el mouse NO puede dejar de tocar la línea hasta que llegue al areaFin
				if (!pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.spriteTrazo)) {
					// Si no toca el trazo pierde
					//trace("Juego perdido");
					//enCurso = false;
					puntosFallados++;
				} else 	if (pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaFin)) {
					// Si no toca el trazo, el juego termina (Porque antes debería tocarse el areaFin ya que se solapa)
					//trace("Juego ganado");
					enCurso = false;
					trace("p_acierto " + puntosAcertados + " p_fallido " + puntosFallados + " porcentaje " + (puntosAcertados / (puntosFallados + puntosAcertados) * 100));
				} else {
					puntosAcertados++;
				}
				
				canvas.drawLine(ultimaPosicion.x, ultimaPosicion.y, FlxG.mouse.x, FlxG.mouse.y, estiloLinea, estiloDibujo);
				ultimaPosicion.x = FlxG.mouse.x;
				ultimaPosicion.y = FlxG.mouse.y;
			}
		}
	}
	
	function stageOnMouseEnd(e : TouchEvent) {
		// Se dejó de tocar el canvas...
		enCurso = false;
		trace("Juego perdido");		
	}

}