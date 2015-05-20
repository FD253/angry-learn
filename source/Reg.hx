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
	public static var puntosKaraoke:Int = 0;
	public static var puntosRitmo:Int = 0;
	
	
	// API
	public static var usuarioActual : String;
	public static var idsUsuario : Array<Int> = [3, 4];
	
	
	public static var deviceId : String = 'TESTDEVICE';
	public static var deviceAppVersion : String = 'TEST VERSION';

	public static var idAppRitmo : String = '/api/v1/app/1/';
	public static var idAppKaraoke : String = '/api/v1/app/2/';
	public static var idAppTrazos : String = '/api/v1/app/3/';
	
	public static var idRitmoLvl1 : String = '/api/v1/level/1/';
	
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
}