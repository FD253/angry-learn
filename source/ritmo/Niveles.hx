package ritmo;

/**
 * ...
 * @author ...
 */
class Niveles
{

	public function new() 
	{
		
	}
	public static var duracionSlot : Float = 0.5;	// Determina la duración de un slot de tiempo en el array de la secuencia
	
	// La secuencia para cada nivel está dada por un array de números.
	// Cada número representa un slot o intervalo de tiempo que tiene una duración definida en duracionSlot
	// Un 0 indica que en ese slot hay silencio
	// Un número distinto de 0 (Por convención usamos el 1) indica que se debe reproducir un sonido en ese momento
	public static var nivel1 : Array<Int> = [0,0,0,0,1,0,0,0,1,1,1,1,1,0,1];
}