package karaoke;

/**
 * Esta clase define un nivel para el ejercicio Karaoke
 * Un nivel se considera una lista de "items" a ser resueltos por el usuario
 * 		La idea es que para un nivel estos items sean Vocales, Sílabas, Palabras completas, etc, para cada dificultad respectivamente.
 * @author Gabriel
 */
class Nivel
{

	public static var nivel1 = new Nivel([
		new Item("A.A E.E I.I O.O U.U"),
		new Item("A.E U.I E.A I.A U.A"),
		new Item("UA"),
	]);
	public static var nivel2 = new Nivel([
		new Item("MA ME MI MO "),
	]);
	public static var nivel3 = new Nivel([
		new Item("O.JO"),
		new Item("PA.TO"),
		new Item("CA.RA"),
	]);
	public static var nivel4 = new Nivel([
		new Item("LA CASA"),
		new Item("EL PERRO"),
		new Item("EL CARAMELO ES DULCE"),
	]);
	
	
	public var items : Array<Item>;

	public function new(Items : Array<Item>) {
		items = Items;
	}
}

/*
 * Esta estructura sirve para definir los elementos que componen un item de ejercicio de un nivel
 * 		Según el modo de juego pueden emplearse algunos elementos del mismo
 * 		Por ejemplo: Para los ejercicios de pronunciación sólo se usa el <texto>, pero para los
 * 			ejercicios en que debe elegirse una imagen según lo que sale en el texto se usan
 * 			también referencias a Assets
 */
class Item
{
	/* 
	 * Las reglas  manera de escribir el texto es:
	 * 	- Espacios ( ) separan palabras
	 *  - Puntos (.) separan sílabas
	*/
	public var texto : String;
	
	public function new(Texto : String) {
		texto = Texto.toUpperCase();
	}
}
