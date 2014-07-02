package ritmo;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Gabriel
 */
class Nivel1 extends FlxState
{
	var _acumulador = 0;
	// Creamos un array para grabar lo que hace el usuario
	var _secuenciaUsuario : Array<Int> = [for (x in 0...Niveles.nivel1.length) 0];
	
	private function _avanceReproduccion(Timer : FlxTimer): Void
	{
		if (Niveles.nivel1[_acumulador] == 1)
		{
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		}
		_acumulador += 1;
	}
	
	private function _avanceGrabacion(Timer : FlxTimer): Void
	{
		if (Timer.loopsLeft == 0)
		{
			trace("Terminó");
			trace(_acumulador);
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, _queHacerCuandoHaceClick);
		}
		else
		{
			_acumulador += 1;
		}
	}
	
	private function _queHacerCuandoHaceClick(e : MouseEvent): Void
	{
		_secuenciaUsuario[_acumulador] = 1;
		trace("click");
	}
	
	private function _testJuego(): Void
	{
		_acumulador = 0;
		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, _queHacerCuandoHaceClick);
		new FlxTimer(Niveles.duracionSlot, _avanceGrabacion, Niveles.nivel1.length);
	}

	override public function create():Void 
	{
		super.create();
		// Creamos un timer para que reproduzca el sonido definido para el nivel
		_acumulador = 0;
		new FlxTimer(Niveles.duracionSlot, _avanceReproduccion, Niveles.nivel1.length);
		add(new FlxButton(10, 10, "Jugar", _testJuego));
	}
	
	
	
	
}