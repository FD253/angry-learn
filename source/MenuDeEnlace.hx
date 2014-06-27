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
	private var _cuadricula: Bool;	// Mostrar los botones en forma de cuadrícula (Matriz) y no uno debajo de otro solamente
	private var _botonesDeMenu: List<BotonMenu> = new List<BotonMenu>();
	
	override public function new(cuadricula: Bool = false)	// Sobreescribimos el constructor para poder decir de entrada si este menú es de tipo cuadricula o no
	{
		super();
		this._cuadricula = cuadricula;
	}
	
	private function _agregarBoton(texto: String, estadoDestino: FlxState): Void
	{
		var botonNuevo: BotonMenu = new BotonMenu(texto, estadoDestino);
		this._botonesDeMenu.add(botonNuevo); // Lo agregamos a la lista interna para después cuando estén todos poder ordenarlos
		//this.add(botonNuevo);	// No lo agregamos ahora poruqe puede mostrarse en la esquina 0,0 y moverse cuando se ejecuta this._ordenarBotones()
	}
	
	private function _ordenarBotones(): Void
	{
		var alturaBotones: Float = Lambda.fold( // Parecido a map() de Python
			this._botonesDeMenu,
			function(a, b)
			{
				return (a.height + b);
			},
			0
		);
		var espacioIntermedio: Float = (FlxG.game.height - alturaBotones) / (this._botonesDeMenu.length + 1);
		
		if (this._cuadricula)
		{
			// TODO: Algoritmo para que aparezcan en forma de cuadrícula
		}
		else
		{
			Lambda.mapi(	// Esto es lo más parecido a un <for index, elemento in ennumerate(lista):> de Python, sólo que empleando map()
				this._botonesDeMenu,
				function(index, boton)
				{
					boton.y = (index + 1) * espacioIntermedio; //- boton.height;
					boton.screenCenter(true, false);
					this.add(boton);	// Esto es un efecto secundario y no debería estar en un map... Pero bueh
				}
			);
		}
	}

	override public function create(): Void
	{		
		this._agregarBoton("Probando1", new MenuGenerico());
		this._agregarBoton("Probando2", new MenuGenerico());
		this._agregarBoton("Probando3", new MenuGenerico());
		
		this._ordenarBotones();
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
	
}