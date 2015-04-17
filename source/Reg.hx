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
	
	public static var nivelKaraokeActual : Int;
	public static var ejercicioKaraokeActual : Int;
	
	public static var nivel : Int;
	public static var ejercicio : Int;
	
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
}