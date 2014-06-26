package ;

import flash.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

using BotonEnlace;

/**
 * ...
 * @author 
 */
class MenuEnlace extends MenuState
{
	private var _cuadricula: Bool = false;	// Mostrar los botones en forma de cuadrícula (Matriz) y no uno debajo de otro solamente
	private var _listaBotones: List<BotonEnlace>;
		
	private function _agregarBoton(texto: String, estadoDestino: FlxState): Void
	{
		_listaBotones.add(new BotonEnlace(texto, estadoDestino));
	}

	override public function create(): Void
	{
		add(new BotonEnlace("popo", new MenuGenerico()));
		
		// TODO: Si descomento la siguiente línea no funciona. Arreglar debug primero!
		/*this._agregarBoton("Probando", nuevoEstado);
		
		for (boton in this._listaBotones) {
			boton.y = 20;
			boton.screenCenter(true, false);
			add(boton);
		}*/
		super.create();
	}
	
}