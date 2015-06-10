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
import flixel.tweens.FlxTween;

import openfl.events.MouseEvent;
import flixel.input.touch.FlxTouch;

using flixel.util.FlxSpriteUtil;

class Logica extends BaseJuego
{
	// Se debe asignar el número de nivel acá antes de instanciar Logica
	//	para que así en create() sepa qué datos usar para mostrar el nivel
	public static var numeroNivel : Int;
	
	var nivel : Nivel;
	var enCurso : Bool;
	
	var momentoInicioEjercicio : Date;
	var momentoFinEjercicio : Date;
	
	var popupBienHecho : FlxSprite;
	var popupMalHecho : FlxSprite;
	var botonPopup : FlxButton;
	
	//donde vamos a mostrar lo que dibuja el usuario.
	var canvas : FlxSprite;
	var estiloLinea : LineStyle;
	var estiloDibujo : DrawStyle;
	var ultimaPosicion : FlxPoint;
	
	var puntosAcertados : Int = 0;	// Por cada punto dibujado dentro del trazo, se suma
	var puntosFallados : Int = 0;	// Por cada punto dibujado fuera del trazo, se resta
	
	var botonesDeNivel : Array<FlxButton> = new Array<FlxButton>();
	
	override public function create() {
		super.create();
		var alturaDelTrazo : Int = 120;
		var escala : Float = 1;

		if (Logica.numeroNivel > Reg.maxLvlTrazos) {
			// No dejamos iniciar el juego en un nivel más alto que el máximo alcanzado
			Logica.numeroNivel = Reg.maxLvlTrazos;
		}
	    agregarTitulo("SIGUE EL TRAZO");
		nivel = Nivel.nuevoNivel(Logica.numeroNivel);
		
		
		nivel.spriteTrazo.setGraphicSize(Std.int(escala * nivel.spriteTrazo.width));
		nivel.spriteTrazo.updateHitbox();
		nivel.spriteTrazo.setPosition((FlxG.width - nivel.spriteTrazo.width) / 2, alturaDelTrazo);
		nivel.areaInicio.setPosition(nivel.spriteTrazo.x + nivel.areaInicio.x * escala, nivel.spriteTrazo.y + nivel.areaInicio.y * escala);
		nivel.areaFin.setPosition(nivel.spriteTrazo.x + nivel.areaFin.x * escala, nivel.spriteTrazo.y + nivel.areaFin.y * escala);
		nivel.areaInicio.updateHitbox();
		nivel.areaFin.updateHitbox();
		
		add(nivel.areaInicio);
		add(nivel.areaFin);
		add(nivel.spriteTrazo);
		add(nivel.spriteFondo);
		
		canvas = new FlxSprite(0, 0);
		// Definimos al canvas como un cuadrado que ocupa toda la pantalla
		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(canvas);
		
		// <NOTE: Esto es un hack para que el trazo quede debajo de la interfaz
		members.remove(canvas);
		members.remove(nivel.areaInicio);
		members.remove(nivel.areaFin);
		members.remove(nivel.spriteTrazo);
		members.remove(nivel.spriteFondo);
		
		members.unshift(canvas);
		members.unshift(nivel.areaInicio);
		members.unshift(nivel.areaFin);
		members.unshift(nivel.spriteTrazo);
		members.unshift(nivel.spriteFondo);
		// END NOTE>
		
		// Cartel de bien hecho
		popupBienHecho = new FlxSprite(0, 0, AssetPaths.popup_ejercicio_bien__png);
		popupBienHecho.setPosition(FlxG.width / 2 - popupBienHecho.width, (FlxG.height - popupBienHecho.height) * 0.4);
		popupBienHecho.visible = false;
		add(popupBienHecho);
		
		// Cartel de mal hecho
		popupMalHecho = new FlxSprite(0, 0, AssetPaths.popup_ejercicio_mal__png);
		popupMalHecho.updateHitbox();
		popupMalHecho.setPosition(FlxG.width / 2 - popupMalHecho.width, (FlxG.height - popupMalHecho.height) * 0.4);
		popupMalHecho.visible = false;
		add(popupMalHecho);
		
		botonPopup = new FlxButton(0, 0, '', botonPopupOnClick);
		botonPopup.loadGraphic(AssetPaths.tilde__png);
		botonPopup.updateHitbox();
		botonPopup.setPosition(popupBienHecho.x + popupBienHecho.width - botonPopup.width / 2, popupBienHecho.y * 1.1);
		botonPopup.visible = false;
		add(botonPopup);
		
		// Le damos un fondo al menú desplegable
		menuDesplegable.add(new FlxSprite(0, 0, AssetPaths.fondo_menu_desplegable__png));
		
		// Creamos los botones (y los guardamos en un array)
		var xInicial = menuDesplegable.width * 0.15;
		var yInicial = menuDesplegable.height * 0.3;
		var altoBoton = 32;
		var anchoBoton = 165;
		for (columna in 1...4) {
			var xEspacio = (menuDesplegable.width - xInicial - anchoBoton * 3) / 3;
			var x = xInicial + (anchoBoton + xEspacio) * (columna - 1);
			var textoNivel = new FlxText(x, 15, 0, "Nivel " + Std.string(columna));
			textoNivel.size = 18;
			menuDesplegable.add(textoNivel);
			for (fila in 1...4) {
				var numeroDeNivel = ((columna - 1) * 3 + fila - 1);
				
				var yEspacio = (menuDesplegable.height - yInicial - altoBoton * 3) / 3;
				var y = yInicial + (altoBoton + yEspacio) * (fila - 1);
				var boton = new FlxButton(x, y, "Ejercicio " + Std.string(fila), function () {
					// Qué hace el click en el botón...
					Logica.numeroNivel = numeroDeNivel;
					FlxTween.tween(btnMenuContraer, { x: -btnMenuContraer.width }, 0.1);
					FlxTween.tween(menuDesplegable, { x: -menuDesplegable.width }, 0.1, {complete: function(tween : FlxTween)
						{
							FlxG.switchState(new Logica());
						}
					});
				});
				boton.label.setFormat(AssetPaths.carter__ttf, 17);
				boton.label.color = FlxColor.BLACK;
				boton.loadGraphic(AssetPaths.boton_ejercicio__png);
				botonesDeNivel.push(boton);
				menuDesplegable.add(boton);
				if (numeroDeNivel <= Reg.maxLvlTrazos) {
					var estrella = new FlxSprite(0, 0, AssetPaths.estrella_menu_ejercicios__png);
					menuDesplegable.add(estrella);
					estrella.setPosition(boton.x - estrella.width * 1.5, boton.y); // La movemos un poco a la izq del boton
				}
			}
		}
		
		// Ponemos un marcador junto al nivel actual en el menú
		botonesDeNivel[numeroNivel].text = botonesDeNivel[numeroNivel].text + " <<<";
		
		estiloLinea = { thickness: 10, color: FlxColor.BLACK, jointStyle:JointStyle.ROUND, pixelHinting: true };
		estiloDibujo = { smoothing: true };
		ultimaPosicion = FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y);
		
		enCurso = false;	// Indicamos que el usuario no está jugando (para que update() no cuente)
		btnMenuDesplegarOnClick();
	}
	
	private function finalizarJuego(exito : Bool) {
	// El parametro exito es para saber si se finalizó bien, o el usuario soltó el dedo de la pantalla
		enCurso = false;
		momentoFinEjercicio = Date.now();
		
		var puntaje : Float = 0;
		if (exito) {
			// Si no soltó el dedo, calculamos el puntaje. Sino queda en cero
			puntaje = (puntosAcertados / (puntosFallados + puntosAcertados) * 100);
			if (puntaje >= Reg.umbralTrazos) {
				// Sólo lo dejamos avanzar si tuvo más de cierto puntaje y estamos en el nivel más alto
				mostrarBienHecho();
				if (Logica.numeroNivel == Reg.maxLvlTrazos) {
					// Sólo si estamos en el lvl más alto avanzamos
					Reg.avanzarLvlTrazos();
				}
			}
			else {
				mostrarMalHecho();
			}
		}
		else {
			puntaje = 0;
			mostrarMalHecho();
		}
		
		trace("p_acierto " + puntosAcertados + " p_fallido " + puntosFallados + " porcentaje " + (puntosAcertados / (puntosFallados + puntosAcertados) * 100));
		var tiempoDeJuego = (momentoFinEjercicio.getTime() - momentoInicioEjercicio.getTime()) / 1000;
		ServicioPosta.instancia.postPlay(puntaje, Reg.idAppTrazos, Reg.idNivelesTrazos[Logica.numeroNivel], tiempoDeJuego);
	}
	
	function botonPopupOnClick() {
		FlxG.switchState(new Logica());
	}
	
	function mostrarBienHecho() {
		popupBienHecho.visible = true;
		botonPopup.loadGraphic(AssetPaths.tilde__png);
		botonPopup.updateHitbox();
		botonPopup.visible = true;
	}
	
	function mostrarMalHecho() {
		popupMalHecho.visible = true;
		botonPopup.loadGraphic(AssetPaths.cruz__png);
		botonPopup.updateHitbox();
		botonPopup.visible = true;
	}
	
	override public function update() {
		super.update();
		
		var popupVisible = (popupBienHecho.visible || popupMalHecho.visible);
		
		if (!enCurso && pixelPerfectPointCheck(FlxG.mouse.screenX, FlxG.mouse.screenY, nivel.areaInicio) && !popupVisible) {
			// Si el juego no arrancó, se pisó el area de inicio y no hay cartel de fin de juego visible
			trace("Juego iniciado");
			ultimaPosicion.x = FlxG.mouse.x;
			ultimaPosicion.y = FlxG.mouse.y;
			enCurso = true;	// Arrancamos
			momentoInicioEjercicio = Date.now();
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
					finalizarJuego(true);
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
					
					finalizarJuego(false); // Perdió por dejar de tocar la pantalla: exito=false
				}
			}
		}
	}
}
