package ;

import flash.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class BotonEnlace extends FlxButton
{
	private var _estadoDestino: FlxState;	// Referencia al estado al que el botón va a llevar
	
	private function _cambiarEstado(): Void
	{
		FlxG.switchState(this._estadoDestino);
	}
	
	override public function new(texto: String, estadoDestino: FlxState)
	{
		// Cuando creamos el botón, definimos a qué estado va a apuntar en el mismo botón
		this._estadoDestino = estadoDestino;
		super(0, 0, texto, _cambiarEstado);
	}
	
}