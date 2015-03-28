package ritmo;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup;
import Reg;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;
import ritmo.Nivel.Ejercicio;
import flixel.util.FlxPoint;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


/**
 * Para entender la estructura de datos que maneja este ejercicio ver la documentación en ritmo.Niveles
 */
class Logica extends BaseJuego
{
	// STATIC ATRIBUTES	
	// El ejercicio consta de 3 secuencias. Siempre se arranca de la primer sencuencia. Guardamos la secuencia actual en secuenciaActual:
	var secuenciaActual : Int;	
	
	public static var feedbackVisualInicio : Bool = false;
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var ejercicio : Ejercicio;
	var feedbackVisual : Bool = false;	// mostrar o no la representacion de la secuencia
	
	var enCurso : Bool = false;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia de pulsos del ejercicio (Para grabar y escuchar)
	var secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var botonesInterfaz = new FlxTypedGroup<FlxButton>();
	var btnEscuchar : FlxButton;
	var btnJugar : FlxButton;
	var btnToques : FlxButton;
	
	var txtRepresentacionSecuencia : FlxText;	// Esto va a mostrar la secuencia de la forma "00 00 00" para que el usuario la vea
	var formatoTween : FlxTextFormat;
	
	var tmrPrincipal : FlxTimer;	// Esta referencia sirve para el timer tanto de juego como de escucha
	
	var txtRetardo : FlxText;
	var tweenOptionsRitmo : TweenOptions = { type: FlxTween.BACKWARD, ease: FlxEase.quartInOut };
	var tweenMarcadorRitmo : FlxTween;	
	
	// PUCLIC METHODS
	override public function create() {
		super.create();
		trace('creating state');
		ejercicio = Nivel.niveles[Reg.nivelRitmoActual].ejercicios[Reg.ejercicioRitmoActual];  // Buscamos el nivel que antes se debe haber definido en Reg
		secuenciaActual = 0; // Arrancamos en la primera secuencia de este ejercicio (Como es un array la primera es la 0)
		
		feedbackVisual = feedbackVisualInicio;
		
		definirRepresentacionSecuencia();
		agregarInterfaz();
		definirMenuDesplegable();
	}
	
	
	// PRIVATE METHODS
	function definirRepresentacionSecuencia() {
		// Esto define el texto que muestra cómo es la secuencia (Ej: 0 000 00 )
		
		var mitadAncho = FlxG.width / 2;
		
		txtRepresentacionSecuencia = new FlxText();
		txtRepresentacionSecuencia.wordWrap = false;
		txtRepresentacionSecuencia.size = 20;
		txtRepresentacionSecuencia.setPosition(20, FlxG.height * 0.4);
		inicializarRepresentacionSecuencia();
		
		//if (feedbackVisual) {	// Sólo mostrarlo si es requerido. Sino permanece oculto
			add(txtRepresentacionSecuencia);
		//}
	}
	
	function inicializarRepresentacionSecuencia() {
		txtRepresentacionSecuencia.clearFormats();
		txtRepresentacionSecuencia.text = ejercicio.secuencias[secuenciaActual].pulsos.toString();
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, ",", ""); 	// Quitamos las comas
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, "0", " ");	// Ponemos espacios en los silencios
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, "1", "0");	// Ponemos "círculos" en cada sonido
	}
	
	function definirMenuDesplegable() {
		menuDesplegable.add(new FlxSprite(0, 0, AssetPaths.fondo_menu_desplegable__png));
		
		var xInicial = 50;
		var yInicial = 30;
		for (nivel in Nivel.niveles) {
			var x = xInicial + 135 * Nivel.niveles.indexOf(nivel);
			for (ejercicio in nivel.ejercicios) {
				var y = yInicial + 20 * nivel.ejercicios.indexOf(ejercicio);
				var boton = new FlxButton(x, y, 'Ejercicio', function () { 
									//Inline, para no crear los handlers a mano
									trace('nivel: ' + Nivel.niveles.indexOf(nivel) + ', ejercicio: ' + nivel.ejercicios.indexOf(ejercicio));
									Reg.nivelRitmoActual = Nivel.niveles.indexOf(nivel);
									Reg.ejercicioRitmoActual = nivel.ejercicios.indexOf(ejercicio);
									FlxTween.tween(btnMenuContraer, { x: -btnMenuContraer.width }, 0.1);
									FlxTween.tween(menuDesplegable, { x: -menuDesplegable.width }, 0.1, {complete: function(tween : FlxTween)
										{
											FlxG.switchState(new Logica());
										}
									});
								}
				);
				boton.label.setFormat(AssetPaths.carter__ttf, 8);
				menuDesplegable.add(boton);
				
			}
		}
	}
	
	function agregarInterfaz() {
		var mitadAncho = FlxG.width / 2;
		var alturaBotonesSuperiores = 75;
		
		// Nombre del juego
		var nombreJuego = new FlxText(0, encabezado.height * 0.25);
		nombreJuego.size = 38; // HARDCODED
		nombreJuego.text = "RITMO LECTOR";
		nombreJuego.font = AssetPaths.carter__ttf;
		nombreJuego.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		nombreJuego.x = FlxG.width / 2 - nombreJuego.fieldWidth / 2;	// Centramos al medio, manteniendo la altura
		add(nombreJuego);
		
		
		// Los botones van a altura fija y de lado siempre con respecto a la mitdas del ancho del juego (O entre sí horizontalmente)
		
		// Botón jugar
		btnJugar = new FlxButton(0, 0, '', btnJugarOnClick);
		btnJugar.loadGraphic(AssetPaths.boton_jugar__png);
		btnJugar.setPosition(mitadAncho - btnJugar.width - 20, alturaBotonesSuperiores);
		botonesInterfaz.add(btnJugar);
		// El usuario no puede jugar de entrada. Tiene que haber escuchado la secuencia antes
		btnJugar.visible = false;
		
		// Botón escuchar
		btnEscuchar = new FlxButton(0, 0, '', btnEscucharOnClick);
		btnEscuchar.loadGraphic(AssetPaths.boton_escuchar__png);
		btnEscuchar.setPosition(btnJugar.x - btnEscuchar.width - 40, alturaBotonesSuperiores);
		botonesInterfaz.add(btnEscuchar);
		
		// Panel de niveles
		
		// Botón de toques
		btnToques = new FlxButton((FlxG.width / 2), (FlxG.height * 0.4), '', btnToquesOnClick);
		btnToques.loadGraphic(AssetPaths.boton__png, true, 297, 305); // HARDCODED
		btnToques.x = btnToques.x - btnToques.width / 2;
		btnToques.y = btnToques.y - btnToques.height / 2;
		add(btnToques);
		
		// Misc
		txtRetardo = new FlxText();
		txtRetardo.wordWrap = false;
		txtRetardo.autoSize = false;
		txtRetardo.fieldWidth = 300;
		txtRetardo.size = 30;
		txtRetardo.setPosition(mitadAncho - txtRetardo.fieldWidth / 2, alturaBotonesSuperiores + 10 + 25);
		txtRetardo.alignment = "center";
		add(txtRetardo);
		
		add(botonesInterfaz);
	}
	
	function avanceReproduccion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			botonesInterfaz.setAll("visible", true);
			txtRepresentacionSecuencia.clearFormats();
		}
		if (ejercicio.secuencias[secuenciaActual].pulsos[acumulador] == 1 && timer.loopsLeft > 0) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
		}
		acumulador += 1;
	}
	
	function avanceGrabacion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace("terminó");
			trace(ejercicio.secuencias[secuenciaActual].pulsos);
			trace(secuenciaUsuario);
			
			var errores = 0;
			// TODO: Contabilizar el acierto
			for (i in 0...ejercicio.secuencias[secuenciaActual].pulsos.length) {
				if (ejercicio.secuencias[secuenciaActual].pulsos[i] != secuenciaUsuario[i]) {
					errores += 1;
				}
			}
			var resultado = 100 - (errores / ejercicio.secuencias[secuenciaActual].pulsos.length) * 100; // Porcentaje de aciertos = 100 - porcentaje de erorres
			trace("resultado: ", resultado);
			
			btnJugar.visible = false;
			btnJugar.active = true;
			btnEscuchar.visible = true;
			txtRetardo.text = "";
			
			enCurso = false;
			
			// Avanzamos...
			if (secuenciaActual == ejercicio.secuencias.length - 1) {
				// Si terminó el ejercicio, avanzamos a otro
				trace('TODO! Se terminó el ejercicio');
				
				secuenciaActual = 0;
				if (Reg.ejercicioRitmoActual == 2) {
					Reg.ejercicioRitmoActual = 0;
					
					if (Reg.nivelRitmoActual == 2) {
						trace("TODO: No tenemos más niveles. Qué hacemos?");
						//TODO!
					}
					else {
						Reg.nivelRitmoActual += 1;
					}
				}
				else {
					Reg.ejercicioRitmoActual += 1;
				}
				// Cambiamos de estado porque el ejercicio es otro ahora
				FlxG.switchState(new Logica());
			}
			else {
				// Avanzamos a la siguiente secuencia de este ejercicio sin cambiar de estado
				secuenciaActual += 1;
			}
			inicializarRepresentacionSecuencia();
		}
		else {
			acumulador += 1;
		}
	}
	
	function inicioRetardado(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace('inicio de juego');
			txtRetardo.text += " A JUGAR! ";
			
			enCurso = true;
			new FlxTimer(ejercicio.secuencias[secuenciaActual].intervalo, avanceGrabacion, ejercicio.secuencias[secuenciaActual].pulsos.length);
		}
		else {
			txtRetardo.text += " . ";
		}
	}
	
	function btnToquesOnClick() {
		// Grabamos en un array
		if (enCurso) {
			if (secuenciaUsuario[acumulador] == 0) {	// No permitimos que el usuario registre más de una pulsación por intervalo
				secuenciaUsuario[acumulador] += 1;
				FlxG.sound.play(AssetPaths.ritmo_bell__wav);
				txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
				trace("click");
			}
		}
		else {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		}
	}
	
	function btnEscucharOnClick() {
		botonesInterfaz.setAll("visible", false);
		
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		tmrPrincipal = new FlxTimer(ejercicio.secuencias[secuenciaActual].intervalo, avanceReproduccion, ejercicio.secuencias[secuenciaActual].pulsos.length + 1); // Agregamos un loop extra para el resaltado del último golpe de la secuencia
	}
	
	function btnJugarOnClick() {
		btnJugar.active = false;
		btnEscuchar.visible = false;
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		secuenciaUsuario = [for (x in 0...ejercicio.secuencias[secuenciaActual].pulsos.length) 0];
		
		trace('inicio de retardo');
		tmrPrincipal = new FlxTimer(		// Esto es sólo para mostrar el texto 1 .. 2 .. 3 .. Go!
			0.2,	// Delay en segundos
			inicioRetardado,	// Handler
			4	// Loops
		);
	}	
	
}