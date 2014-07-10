import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Ejercicio extends FlxState
{
	// STATIC ATRIBUTES
	// Esta variable debe ser seteada con el nivel que uno quiere que se ejecute...
	//   Por supesto que antes de instanciar el ejercicio, porque es lo que usa el método create() para definir el nivel del ejercicio
	public static var nivelInicio : Array<Int>;
	public static var duracionSlotInicio : Float = 0.5;	// Determina la duración de un slot de tiempo en el array de la secuencia
	
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var nivel : Array<Int>;
		
	var textoRetardo : FlxText;
	var marcadorRitmo : FlxSprite;
	var marcadorRitmoTO : TweenOptions = { type: FlxTween.ONESHOT, ease: FlxEase.quartInOut };
	var marcadorRitmoTween : FlxTween;
	
	override public function create() {
		super.create();
		nivel = nivelInicio;	// Pasamos a la instancia el nivel que antes de instanciar se debe haber definido en la clase para que se ejecute
		
	}
	
	
	// PRIVATE METHODS
	
	
	function registrarPulsacion(e : MouseEvent) {

	}
	
	function escuchar() {

	}
		
	function jugar() {

	}


	
	
	
	
}import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


/**
 * 
 * Para entender la estructura de datos que maneja este ejercicio ver la documentación en ritmo.Niveles
 * 
 * @author Gabriel
 */
class Ejercicio extends FlxState
{
	// STATIC ATRIBUTES
	// Esta variable debe ser seteada con el nivel que uno quiere que se ejecute...
	//   Por supesto que antes de instanciar el ejercicio, porque es lo que usa el método create() para definir el nivel del ejercicio
	public static var nivelInicio : Array<Int>;
	public static var duracionSlotInicio : Float = 0.5;	// Determina la duración de un slot de tiempo en el array de la secuencia
	
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var nivel : Array<Int>;
	var duracionSlot : Float;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia del ejercicio (Para grabar y escuchar)
	var secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var botonEscuchar : FlxButton;
	var botonJugar : FlxButton;
	var textoRetardo : FlxText;
	var marcadorRitmo : FlxSprite;
	var marcadorRitmoTO : TweenOptions = { type: FlxTween.ONESHOT, ease: FlxEase.quartInOut };
	var marcadorRitmoTween : FlxTween;
	
	
	// PUCLIC METHODS
	override public function create() {
		super.create();
		nivel = nivelInicio;	// Pasamos a la instancia el nivel que antes de instanciar se debe haber definido en la clase para que se ejecute
		duracionSlot = duracionSlotInicio; // Mismo caso que para el nivel...
		
		var mitadAncho = FlxG.stage.stageWidth / 2;
		var alturaBotones = FlxG.stage.stageHeight * 0.75;
		
		marcadorRitmo = new FlxSprite();
		marcadorRitmo.makeGraphic(150, 150, FlxColor.WHITE);
		marcadorRitmo.setPosition(mitadAncho - marcadorRitmo.width / 2, 20);		
		
		botonEscuchar = new FlxButton(mitadAncho + 10, alturaBotones, "Escuchar", escuchar);
		add(botonEscuchar);
		
		botonJugar = new FlxButton(mitadAncho - 10, alturaBotones, "Jugar", jugar);
		botonJugar.x -= botonJugar.width;
		add(botonJugar);
		
		textoRetardo = new FlxText();
		textoRetardo.wordWrap = false;
		textoRetardo.autoSize = false;
		textoRetardo.fieldWidth = 300;
		textoRetardo.size = 30;
		textoRetardo.setPosition(mitadAncho - textoRetardo.fieldWidth / 2, alturaBotones - 50);
		textoRetardo.alignment = "center";
		add(textoRetardo);
		
		// El usuario no puede jugar de entrada. Tiene que haber escuchado la secuencia antes
		botonJugar.active = false;
	}
	
	
	// PRIVATE METHODS
	function avanceReproduccion(timer : FlxTimer) {
		add(marcadorRitmo);
		
		if (timer.loopsLeft == 0) {
			// Habilitar boton jugar
			botonJugar.active = true;
			botonEscuchar.active = true;
		}
		if (nivel[acumulador] == 1) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			FlxTween.color(marcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, marcadorRitmoTO);
		}
		acumulador += 1;
	}
	
	function avanceGrabacion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace("terminó");
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, registrarPulsacion);
			trace(nivel);
			trace(secuenciaUsuario);
			
			// TODO: Contabilizar el acierto
			for (i in 0...nivel.length) {
				
			}
			
			botonJugar.active = true;
			botonEscuchar.active = true;
			textoRetardo.text = "";
		}
		else {
			acumulador += 1;
		}
	}
	
	function registrarPulsacion(e : MouseEvent) {
		// Grabamos en un array
		secuenciaUsuario[acumulador] += 1;
		FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		marcadorRitmoTween = FlxTween.color(marcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, marcadorRitmoTO);
		trace("click");
	}
	
	function escuchar() {
		botonJugar.active = false;
		botonEscuchar.active = false;
		acumulador = 0;
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		new FlxTimer(duracionSlot, avanceReproduccion, nivel.length);
	}
	
	function inicioRetardado(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace('inicio de juego');
			textoRetardo.text += " Go! ";
			// Escuchamos el click para "grabar" lo que hace el usuario
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, registrarPulsacion);
			new FlxTimer(duracionSlot, avanceGrabacion, nivel.length);
		}
		else {
			textoRetardo.text += " . ";
		}
	}
	
	function jugar() {
		botonJugar.active = false;
		botonEscuchar.active = false;
		acumulador = 0;
		secuenciaUsuario = [for (x in 0...nivel.length) 0];
		
		trace('inicio de retardo');
		new FlxTimer(
			1,	// Delay en segundos
			inicioRetardado,	// Handler
			4	// Loops
		);
	}


	
	
	
	
}