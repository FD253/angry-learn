angry-learn
===========

Estándar:
---------
	
- Para los tipos de datos de los identificadores (Y cualquier otro lugar que lelve el ":") que quede así:
	... var identificador: TipoDato;
	... function identificador(param1: TipoDato, param2: TipoDato)
	

Variables, parametros de función: 		notacionCamello
Clases: 								NotacionPascal
	
	

Para las declaraciones de estructuras (for, if, function, class, etc) usar SIEMPRE llaves que abren y cierran DEBAJO de la declaración.
Lo de poner las llaves siempre es para evitar olvidarse de agregarlas si en lugar de tener que ejecutar una línea luego tenemos que agregar otra(s).
Y lo de ponerlas debajo de la instrucción que abre un bloque es para ver fácilmente dónde empieza y termina un bloque. (Aunque no se si conviene por el espacio que ocupa)

	Bien:
		if (condicion)
		{
			unaLinea
		}
		else
		{
			otraLinea
		}
	
	MAL:
		if (condicion)
			unaLinea
		else
			otraLinea
			
		if (condicion) {
			unaLinea
		}
		else {
			otraLinea
		}
	

Ser explícitos SIEMPRE al momento de llamar un método de clase... O sea, si tenemos:
	
	class Cosa
	{
		private function _unMetodoPrivado(): Void
		{
			...
		}
		
		public function unMetodoPublico(): Void
		{
			// Usar SIEMPRE así:
			this._unMetodoPrivado();
			
			Y NO así:
			_unMetodoPrivado();
		}
	}