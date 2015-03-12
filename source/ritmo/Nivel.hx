package ritmo;
import flixel.addons.editors.ogmo.FlxOgmoLoader;


class Secuencia
{
	public var pulsos : Array<Int>;
	public var intervalo : Float;	// Determina la duración (En segundos) de un slot de tiempo entre cada pulso de la secuencia
		// Tener en cuenta que por el método que usamos para calcular el error, el tiempo asignado a cada slot influye mucho
		// Un tiempo muy corto hace que sea muy sensible a errores y un tiempo muy largo hace que el un mal ritmo se compute bien
	
	public function new(pulsosInicio : Array<Int>, intervaloInicio : Float) {
		pulsos = pulsosInicio;
		intervalo = intervaloInicio;
	}
}

class Ejercicio
{
	public var secuencias : Array<Secuencia>;
	
	public function new(secuenciasInicio : Array<Secuencia>) {
		secuencias = secuenciasInicio;
	}
}

class Nivel
{
	static var intervalo = 0.4;
	public static var niveles = [	// Array<Nivel>
		new Nivel([	// Nivel 1
			new Ejercicio([new Secuencia([1, 0, 1, 0, 1], 				intervalo),
						   new Secuencia([1, 1, 0, 1], 					intervalo),
						   new Secuencia([1, 0, 1, 1], 					intervalo)]),
			new Ejercicio([new Secuencia([1, 0, 1, 0, 1, 0, 1], 			intervalo),
						   new Secuencia([1, 1, 0, 1, 1], 				intervalo),
						   new Secuencia([1, 0, 1, 1, 1], 				intervalo)]),
		    new Ejercicio([new Secuencia([1, 1, 0, 1, 0, 1], 			intervalo),
						   new Secuencia([1, 1, 1, 0, 1], 				intervalo),
						   new Secuencia([1, 0, 1, 0, 1, 1], 			intervalo)])
		]),
		new Nivel([ // Nivel 2
			new Ejercicio([new Secuencia([1, 0, 1, 0, 1, 0, 1, 0, 1, 0], 		intervalo),
						   new Secuencia([1, 0, 1, 1, 0, 1, 1], 					intervalo),
						   new Secuencia([1, 1, 0, 1, 0, 1, 1], 					intervalo)]),
			new Ejercicio([new Secuencia([1, 1, 0, 1, 1, 0, 1], 					intervalo),
						   new Secuencia([1, 1, 1, 0, 1, 1], 					intervalo),
						   new Secuencia([1, 0, 1, 1, 1, 0, 1], 					intervalo)]),
		    new Ejercicio([new Secuencia([1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1], 		intervalo),
						   new Secuencia([1, 1, 0, 1, 1, 0, 1, 1], 				intervalo),
						   new Secuencia([1, 1, 1, 0, 1, 1, 1], 					intervalo)])
		]),
	];
	
	public var ejercicios : Array<Ejercicio>;
	
	public function new(ejerciciosInicio : Array<Ejercicio>) {
		ejercicios = ejerciciosInicio;
	}
}
