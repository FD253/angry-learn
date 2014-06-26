package ;

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
class MenuEnlace extends MenuState
{
	private var _cuadricula: Bool;
	private var _listaBotones: List<FlxButton>;
	
	private function _agregarBoton(texto: String, estadoDestino: FlxState)
	{
		var _botonNuevo : FlxButton;
		
		if (this._cuadricula) {
			
		}
		else {
			// Lo queremos en vertical
			_botonNuevo = new BotonEnlace(0, 0, texto, estadoDestino);
			_listaBotones.add(_botonNuevo);
		}
	}

	public function new() 
	{
		super();
	}
	
}