angry-learn
===========

Estándar:
---------


Se va a emplear el estilo de codificación definido por la misma comunidad de HaxeFlixel (Aunque con exepciones):
http://haxeflixel.com/documentation/code-style/
	

Modificaciones:
---------------


- Los identificadores de variables van todos en notaciónCamello. Sin excepción. Total, para saber si algo es público o privado tenemos IDEs, no?


- Las llaves para los bloques de código van SIEMPRE (por más que sea una sola línea), y de la siguiente manera:
	
	
		if (condicion) {
			unaLinea
		}
		else {
			otraLinea
		}

	
- Para los tipos de datos de los identificadores (Y cualquier otro lugar que lleve el ":") que quede así, siempre separado:
	... var identificador : TipoDato;
	... function identificador(param1: TipoDato, param2 : TipoDato)
	
	NUNCA explicitar que un método devuelve Void. Se asume que devuelve Void siempre.


Variables, parametros de función: 		notacionCamello
Clases: 								NotacionPascal
	

- En cuanto a los modificadores de acceso...
	A menos que un atributo de clase o método sea PÚBLICO no se pone el modificador de acceso ya que son todos por defecto "private"
	Aunque quedaría mejor emplear el "this" en una clase para referirse a sus atributos de instancia, no lo vamos a emplear
	(Pero hay que tener cuidado porque no podríamos diferenciar a simple vista un atributo "static" de clase, de uno de instancia!)
	
	
		class Cosa
		{
			public static cosaParaUsarEnCreate: Int;
			
			function unMetodoPrivado(): Void	// Es private por defecto
			{
				...
			}
			
			public function unMetodoPublico(): Void		// Explicitamos que es público
			{
				// Usar SIEMPRE así:
				unMetodoPrivado();
				
				Y NO así:
				this.unMetodoPrivado();
			}
		}