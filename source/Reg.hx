package;
import flixel.FlxG;
import flixel.util.FlxSave;
import trazos.Nivel;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */

class Reg
{	
	public static var debug = false;
	
	public static var nivelRitmoActual : Int;
	public static var ejercicioRitmoActual : Int;
	
	public static var nivelKaraokeActual : Int;
	public static var ejercicioKaraokeActual : Int;
	
	public static var nivel : Int;
	public static var ejercicio : Int;
	
	public static var puntosTrazos:Int = 0;
	public static var puntosRitmo:Int = 0;
	public static var puntosKaraoke:Int = 0;
	
	//=========================
	public static var REGISTRADO = "registrado";
	public static var LIBRE = "libre";
	
	public static var modoDeJuego : String;
	public static var apiKey : String;
	
	
	// API
	public static var usuarioActual : String;	// Resource uri
	public static var nombreUsuarioActual : String = '';
	public static var usernameActual : String = '';  // El que se usa para el login
	
	
	
	public static var deviceId : String = 'TABLET SAMSUNG';
	public static var deviceAppVersion : String = 'BETA';

	public static var idAppRitmo : String = '/api/v1/app/1/';
	public static var idAppKaraoke : String = '/api/v1/app/2/';
	public static var idAppTrazos : String = '/api/v1/app/3/';
	
	public static var idNivelesRitmo : Array<String> = [
		'/api/v1/level/1/',
		'/api/v1/level/2/',
		'/api/v1/level/3/',
		'/api/v1/level/10/',
		'/api/v1/level/11/',
		'/api/v1/level/12/',
		'/api/v1/level/13/',
		'/api/v1/level/14/',
		'/api/v1/level/15/'
	];
	
	public static var idNivelesKaraoke : Array<String> = [
		'/api/v1/level/4/',
		'/api/v1/level/5/',
		'/api/v1/level/6/',
		'/api/v1/level/16/',
		'/api/v1/level/17/',
		'/api/v1/level/18/',
		'/api/v1/level/19/',
		'/api/v1/level/20/',
		'/api/v1/level/21/',
		'/api/v1/level/22/',
		'/api/v1/level/23/',
		'/api/v1/level/24/'
	];
	
	public static var idNivelesTrazos : Array<String> = [
		'/api/v1/level/7/', 	// 1
		'/api/v1/level/8/',		// 2
		'/api/v1/level/9/',		// 3
		'/api/v1/level/25/',	// 4
		'/api/v1/level/26/',	// 5
		'/api/v1/level/27/',	// 6
		'/api/v1/level/28/',	// 7
		'/api/v1/level/29/',	// 8
		'/api/v1/level/30/'		// 9
	];
	
	public static function avanzarMaxLvlTrazos() {
		if (maxLvlTrazos < (Nivel.niveles.length - 1)) {
			maxLvlTrazos += 1;
		}
	}
	
	public static var maxLvlRitmo : Int = 0;
	public static var maxLvlKaraoke : Int = 0;
	public static var maxLvlTrazos : Int = 0;
	
	public static var umbralTrazos : Float = 95;
	public static var umbralRitmo : Float = 85;
	
	
	public static var EJERCICIOS_POR_NIVEL = 3;
	
	public static function credencialesGuardadas() : Bool {
		// Indica si se están recordando las credenciales de un usuario (O sea, si tenemos alguna guardada)
		return (FlxG.save.data.usuarioActual != null && 
				FlxG.save.data.nombreUsuarioActual != null &&
				FlxG.save.data.usernameActual != null &&
				FlxG.save.data.apiKey != null);
	}
	
	public static function numeroDeNivelSegunArrayDeEjercicios(indiceEjercicio : Int) : Int {
		// indiceEjercicio es un número que arranca en 0, como los índices de los arrays
		// Utilidad para obtener el número de nivel al que pertenece un ejercicio... Esto suponiendo
		// que se tiene un gran array con todos los ejercicios (Como en el juego de Trazos)
		// Y que hay tantos ejercicios por nivel como indica la variable EJERCICIOS_POR_NIVEL
		
		var resultado = indiceEjercicio / EJERCICIOS_POR_NIVEL;
		
		// Devolvemos el número de nivel real... Arrancando en 1
		return Std.int(resultado) + 1;
	}
	
	public static function numeroDeEjercicioSegunArrayDeEjercicios(indiceEjercicio : Int) : Int {
		// indiceEjercicio es un número que arranca en 0, como los índices de los arrays
		// Utilidad para obtener el número de EJERCICIO dentro del nivel en que se está...
		// Esto suponiendo que se tiene un gran array con todos los ejercicios (Como en el juego de Trazos)
		// Y que hay tantos ejercicios por nivel como indica la variable EJERCICIOS_POR_NIVEL
		
		var nivel = numeroDeNivelSegunArrayDeEjercicios(indiceEjercicio);
		
		var numeroEjercicio = indiceEjercicio + 1 - (nivel - 1) * EJERCICIOS_POR_NIVEL;	// The magic formula
		return numeroEjercicio;
	}
	
	
	public static var botonMenuTextSize : Int = 30;	// Tamaño de texto a usar para los botones del menu principal
	
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	public static function obtenerIdResource(recurso:String) :String {
		var cosas = recurso.split('/');
		cosas.pop(); // Descartamos el "nada" de MIERDA que Haxe toma como que hay al final
		return cosas.pop();
	}
	
	public static function reiniciarMaximos() {
		nivelRitmoActual = 0;
		ejercicioRitmoActual = 0;
		nivelKaraokeActual = 0;
		ejercicioKaraokeActual = 0;
	
		puntosTrazos = 0;
		puntosRitmo = 0;
		puntosKaraoke = 0;
		
		maxLvlRitmo = 0;
		maxLvlKaraoke = 0;
		maxLvlTrazos = 0;
	}
	
	public static function setearModoLibre() {
		usuarioActual = "";
		nombreUsuarioActual = "MODO LIBRE";
		
		maxLvlRitmo = 8;
		maxLvlKaraoke = 11;
		maxLvlTrazos = 8;
	}
}
