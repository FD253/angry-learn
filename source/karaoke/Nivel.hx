package karaoke;
import haxe.macro.Expr.Var;
import karaoke.Nivel.Setting;

/**
 * Esta clase define un nivel para el ejercicio Karaoke
 * Un nivel se considera una lista de "items" a ser resueltos por el usuario
 * 		La idea es que para un nivel estos items sean Vocales, Sílabas, Palabras completas, etc, para cada dificultad respectivamente.
 * @author Gabriel
 */
class Nivel
{
	public static var mayuscula = new Setting(true, false, false);
	public static var minuscula = new Setting(false, true,false);
	public static var cursiva = new Setting(false, false, true);
	public static var mayusculaMinuscula = new Setting(true, true, false);
	public static var mayusculaMinusculaCursiva = new Setting(true, true, true);
	
	public static var nivel1 = new Nivel([
		new Item("A E I O U . A.A E.E I.I O.O . A.E I.U E.I E.A ",mayuscula),
		new Item("S M A S . M O L R . R M E P ", mayusculaMinuscula),
		new Item("M A N O . S A P O . P I N O ", mayusculaMinuscula),
	]);
	
	public static var nivel2 = new Nivel([
		new Item("Ma Me Mi Mo Mu . Pa Pe Pi Po Pu . Sa Se Si So Su ",mayusculaMinusculaCursiva),
		new Item("Ta To Tu Ti Te . Ni Ne Na Un No . Lo Le Lu La Li ", mayusculaMinusculaCursiva),
		new Item("Ma Si Pe Ru Tu . Ni So Ta Re Lu . Pa Ru Ti Mo ", mayusculaMinusculaCursiva),
	]);
	
	public static var nivel3 = new Nivel([
		new Item("O.so . Pa.to . Ca.sa ",mayusculaMinusculaCursiva),
		new Item("Au.to . Da.do . Pa.la . Ne.ne ",mayusculaMinusculaCursiva),
		new Item("La ta.za . La ma.no . El de.do . El sa.po ",mayusculaMinusculaCursiva),
	]);
	
	public static var nivel4 = new Nivel([
		new Item("La ca.mi.sa . La pe.lo.ta . El he.la.do . La ma.ce.ta ", mayusculaMinusculaCursiva),
		new Item("El pa.to na.da . La pa.lo.ma vue.la . Los a.mi.gos rí.en . El puen.te al.to ", mayusculaMinusculaCursiva),
		new Item("El ne.ne es.tá con.ten.to . El ca.ra.me.lo es dul.ce . Jue.go con mis a.mi.gos . Los pá.ja.ros vue.lan en gru.po ",mayusculaMinusculaCursiva),
	]);
	
	public var items : Array<Item>;

	public function new(Items : Array<Item>){
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
	 *  - Espacio Punto Espacio separa subitem
	*/
	public var texto : String;
	
	public var opciones: Setting;
	
	public function new(Texto : String,  Opciones: Setting) {
		texto = Texto;
		opciones = Opciones;
	}
}

class Setting 
{
	public var Mayuscula : Bool;
	public var Minuscula : Bool;
	public var Cursiva : Bool;
	
	public function new(mayuscula:Bool, minuscula:Bool, cursiva:Bool) {
		Mayuscula = mayuscula;
		Minuscula = minuscula;
		Cursiva = cursiva;
	}
}