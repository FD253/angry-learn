package;

import flixel.util.FlxSave;

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
	
	public static var nivel : Int;
	public static var ejercicio : Int;
	
	public static var puntosTrazos:Int = 0;
	public static var puntosRitmo:Int = 0;
	public static var puntosKaraoke:Int = 0;
	
	//=========================
	public static var REGISTRADO = "registrado";
	public static var LIBRE = "libre";
	
	public static var modoDeJuego : String;
	
	
	// API
	public static var usuarioActual : String;
	public static var idsUsuario : Array<Int> = [3, 4];
	
	
	public static var deviceId : String = 'TESTDEVICE';
	public static var deviceAppVersion : String = 'TEST VERSION';

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
	
	public static var maxLvlRitmo : Int = 0;
	public static var maxLvlTrazos : Int = 0;
	
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
}