package ;

import flash.events.Event;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

using BotonMenu;

/**
 * ...
 * @author 
 */
class MenuDeEnlace extends FlxState
{
	private var _botonesDeMenu: List<FlxButton> = new List<FlxButton>();
	
	/*
	 * Devuelve además el botón que acaba de crear por si se lo quiere modificar 
	 */
	private static function _volver():Void
	{
		FlxG.switchState(new MenuPrincipal());
		//FlxG.switchState(Reg.MenuPrincipal);
	}
	private function _agregarBoton(texto: String, ?estadoDestino: Class<FlxState>): FlxButton
	{
		if (estadoDestino != null)
		{
			var botonNuevo: BotonMenu = new BotonMenu(texto, estadoDestino);
			_botonesDeMenu.add(botonNuevo); // Lo agregamos a la lista interna para después cuando estén todos poder ordenarlos
			//this.add(botonNuevo);	// No lo agregamos ahora porque puede mostrarse en la esquina 0,0 y moverse cuando se ejecuta this._ordenarBotones()
			return botonNuevo;
		}
		else
		{
			var botonNuevo = new FlxButton(0, 0, texto, _volver);
			_botonesDeMenu.add(botonNuevo);
			return botonNuevo;
		}
	}
	
	/*
	 * Ordena los botones que fueron asignados al estado como botones de menú y los aagrega al estado en sí para que estén disponibles
	 */
	private function _ordenarBotones(): Void
	{
		var alturaBotones: Float = Lambda.fold( // Parecido a map() de Python
			_botonesDeMenu,
			function(a, b)
			{
				return (a.height + b);
			},
			0
		);
		var espacioIntermedio: Float = (FlxG.game.height - alturaBotones) / (_botonesDeMenu.length + 1);
		
		Lambda.mapi(	// Esto es lo más parecido a un <for index, elemento in ennumerate(lista):> de Python, sólo que empleando map()
			_botonesDeMenu,
			function(index, boton)
			{
				boton.y = (index + 1) * espacioIntermedio; //- boton.height;
				boton.screenCenter(true, false);
				this.add(boton);	// Esto es un efecto secundario y no debería estar en un map... Pero bueh
			}
		);
	}	
}