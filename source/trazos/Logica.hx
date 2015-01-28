package trazos;

import flixel.FlxG;
import Reg;
import trazos.Nivel.ParamNivel;

import flash.display.JointStyle;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import flixel.util.FlxCollision.pixelPerfectPointCheck;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxColor;

import openfl.events.MouseEvent;
import flixel.input.touch.FlxTouch;

using flixel.util.FlxSpriteUtil;

class Logica extends FlxState
{
	// Se debe asignar el número de nivel acá antes de instanciar Logica
	//	para que así en create() sepa qué datos usar para mostrar el nivel
	public static var numeroNivel : Int;
	
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

		nivel = Nivel.nuevoNivel(Logica.numeroNivel);

		
		add(nivel.spriteTrazo);
		add(nivel.spriteFondo);
		add(nivel.areaFin);
		add(nivel.areaInicio);
		
		add(new FlxButton(10, 10, "Menu", function () { FlxG.switchState(new MenuTrazos() ); } ));
		
		canvas = new FlxSprite();
		
		// Definimos al canvas como un cuadrado que ocupa toda la pantalla
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(canvas);
		
		estiloLinea = { thickness: 10, color: FlxColor.RED, jointStyle:JointStyle.ROUND, pixelHinting: true };
		estiloDibujo = { smoothing: true };
		ultimaPosicion = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
		
		enCurso = false;	// Indicamos que el usuario no está jugando (para que update() no cuente)
	}
	
	private function finalizarJuego()
	{
		enCurso = false;
		trace("p_acierto " + puntosAcertados + " p_fallido " + puntosFallados + " porcentaje " + (puntosAcertados / (puntosFallados + puntosAcertados) * 100));
	}
	
	override public function update() {
		super.update();
		
		if (!enCurso && pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaInicio)) {
			// Si el juego no arrancó y se pisó el area de inicio
			trace("Juego iniciado");
			ultimaPosicion.x = FlxG.mouse.x;
			ultimaPosicion.y = FlxG.mouse.y;
			enCurso = true;	// Arrancamos
			puntosAcertados = 0;
			puntosFallados = 0;
		}
		
		if (enCurso) {
			
			// solo actuo en caso de que se haya movido, por un tema de puntaje
			if (FlxG.mouse.x != ultimaPosicion.x || FlxG.mouse.y != ultimaPosicion.y) {			
				
				// Si el juego está en curso el mouse NO puede dejar de tocar la línea hasta que llegue al areaFin
				if (!pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.spriteTrazo)) {
					// Si no toca el trazo se penaliza
					puntosFallados++;
				} else if (pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaFin)) {
					// Si toca el areaFin se finaliza
					finalizarJuego();
				} else {
					puntosAcertados++;
				}
				
				canvas.drawLine(ultimaPosicion.x, ultimaPosicion.y, FlxG.mouse.x, FlxG.mouse.y, estiloLinea, estiloDibujo);
				ultimaPosicion.x = FlxG.mouse.x;
				ultimaPosicion.y = FlxG.mouse.y;
			}
			
			for (touch in FlxG.touches.list) {
				if (touch.justReleased) {
					// Si deja de tocar la pantalla pierde
					trace('juego perdido');
					
					// Damos estos valores mínimos para que el porcentaje no sea div por cero
					puntosAcertados = 0;
					puntosFallados = 1;
					
					finalizarJuego();
				}
			}
		}
	}
}