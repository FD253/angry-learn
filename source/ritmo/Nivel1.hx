package ritmo;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;

/**
 * ...
 * 
 * Para entender la estructura de datos que maneja este ejercicio ver la documentación en ritmo.Niveles
 * 
 * @author Gabriel
 */
class Nivel1 extends FlxState
{
	var _acumulador = 0;
	// Creamos un array para grabar lo que hace el usuario
	var _secuenciaUsuario : Array<Int>;
	
	var _botonEscuchar : FlxButton;
	var _botonJugar : FlxButton;
	
	private function _avanceReproduccion(Timer : FlxTimer): Void
	{
		if (Timer.loopsLeft == 0) {
			// Habilitar boton jugar
			_botonJugar.active = true;
			_botonEscuchar.active = true;
		}
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
			trace("terminó");
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, _registrarPulsacion);
			trace(Niveles.nivel1);
			trace(_secuenciaUsuario);
		}
		else
		{
			_acumulador += 1;
		}
	}
	
	private function _registrarPulsacion(e : MouseEvent): Void
	{
		// Grabamos en un array
		_secuenciaUsuario[_acumulador] = 1;
		trace("click");
	}
	
	private function _escuchar(): Void
	{
		_botonJugar.active = false;
		_botonEscuchar.active = false;
		_acumulador = 0;
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		new FlxTimer(Niveles.duracionSlot, _avanceReproduccion, Niveles.nivel1.length);
	}
	
	private function _jugar(): Void
	{
		_acumulador = 0;
		_secuenciaUsuario = [for (x in 0...Niveles.nivel1.length) 0];
		// Escuchamos el click para "grabar" lo que hace el usuario
		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, _registrarPulsacion);
		new FlxTimer(Niveles.duracionSlot, _avanceGrabacion, Niveles.nivel1.length);
	}

	override public function create():Void 
	{
		super.create();
		_botonEscuchar = new FlxButton(10, 10, "Escuchar", _escuchar);
		add(_botonEscuchar);
		_botonJugar = new FlxButton(10, 40, "Jugar", _jugar);
		add(_botonJugar);
	}
	
	
	
	
}