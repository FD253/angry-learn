package ritmo;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
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
	public static var nivel : Array<Int>;
	public static var duracionSlot : Float = 0.5;	// Determina la duración de un slot de tiempo en el array de la secuencia
	
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var _nivel : Array<Int>;
	var _duracionSlot : Float;
	
	var _acumulador = 0;	// Se emplea para recorrer la secuencia del ejercicio (Para grabar y escuchar)
	var _secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var _botonEscuchar : FlxButton;
	var _botonJugar : FlxButton;
	var _marcadorRitmo : FlxSprite;
	var _marcadorRitmoTO : TweenOptions = { type: FlxTween.ONESHOT, ease: FlxEase.quartInOut };
	var _marcadorRitmoTween : FlxTween;
	
	
	// PUCLIC METHODS
	override public function create() {
		super.create();
		_nivel = nivel;	// Pasamos a la instancia el nivel que antes de instanciar se debe haber definido en la clase para que se ejecute
		_duracionSlot = duracionSlot; // Mismo caso que para el _nivel...
		
		var mitadAncho = FlxG.stage.stageWidth / 2;
		var alturaBotones = FlxG.stage.stageHeight * 0.75;
		
		_marcadorRitmo = new FlxSprite();
		_marcadorRitmo.makeGraphic(150, 150, FlxColor.WHITE);
		_marcadorRitmo.setPosition(mitadAncho - _marcadorRitmo.width / 2, 20);		
		
		_botonEscuchar = new FlxButton(mitadAncho + 10, alturaBotones, "Escuchar", _escuchar);
		add(_botonEscuchar);
		
		_botonJugar = new FlxButton(mitadAncho - 10, alturaBotones, "Jugar", _jugar);
		_botonJugar.x -= _botonJugar.width;
		add(_botonJugar);
		// El usuario no puede jugar de entrada. Tiene que haber escuchado la secuencia antes
		_botonJugar.active = false;		
	}
	
	
	// PRIVATE METHODS
	function _avanceReproduccion(Timer : FlxTimer) {
		add(_marcadorRitmo);
		
		if (Timer.loopsLeft == 0) {
			// Habilitar boton jugar
			_botonJugar.active = true;
			_botonEscuchar.active = true;
		}
		if (_nivel[_acumulador] == 1) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			FlxTween.color(_marcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, _marcadorRitmoTO);
		}
		_acumulador += 1;
	}
	
	function _avanceGrabacion(Timer : FlxTimer) {
		if (Timer.loopsLeft == 0) {
			trace("terminó");
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, _registrarPulsacion);
			trace(_nivel);
			trace(_secuenciaUsuario);
		}
		else {
			_acumulador += 1;
		}
	}
	
	function _registrarPulsacion(e : MouseEvent) {
		// Grabamos en un array
		_secuenciaUsuario[_acumulador] += 1;
		FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		_marcadorRitmoTween = FlxTween.color(_marcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, _marcadorRitmoTO);
		trace("click");
	}
	
	function _escuchar() {
		_botonJugar.active = false;
		_botonEscuchar.active = false;
		_acumulador = 0;
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		new FlxTimer(_duracionSlot, _avanceReproduccion, _nivel.length);
	}
	
	function _jugar() {
		_acumulador = 0;
		_secuenciaUsuario = [for (x in 0..._nivel.length) 0];
		// Escuchamos el click para "grabar" lo que hace el usuario
		// TODO: Agregar algo que le permita al usuario saber que va a comenzar la secuencia
		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, _registrarPulsacion);
		new FlxTimer(_duracionSlot, _avanceGrabacion, _nivel.length);
	}


	
	
	
	
}