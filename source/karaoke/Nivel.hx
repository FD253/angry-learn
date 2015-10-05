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
	
	public static var niveles = [
		new Nivel([
			new Ejercicio(["A E I O U ", " A.A E.E I.I O.O ", " A.E I.U E.I E.A "],mayuscula),
			new Ejercicio(["S M A S ", " M O L R ", " R M E P "], mayusculaMinuscula),
			new Ejercicio(["M A N O ", " S A P O ", " P I N O "], mayusculaMinuscula),  //separar en " LETRA " en lugar de "LETRA " <-INVESTIGAR XQ?
		]),
		new Nivel([
			new Ejercicio(["Ma Me Mi Mo Mu ", "Pa Pe Pi Po Pu ", "Sa Se Si So Su "],mayusculaMinusculaCursiva),
			new Ejercicio(["Ta To Tu Ti Te ", "Ni Ne Na Nu No ", "Lo Le Lu La Li "], mayusculaMinusculaCursiva),
			new Ejercicio(["Ma Si Pe Ru Tu ", "Ni So Ta Re Lu ", "Pa Ru Ti Mo "], mayusculaMinusculaCursiva),
		]),
		new Nivel([
			new Ejercicio(["O.so ", "Pa.to ", "Ca.sa "],mayusculaMinusculaCursiva),
			new Ejercicio(["Au.to ", "Da.do ", "Pa.la ", "Ne.ne "],mayusculaMinusculaCursiva),
			new Ejercicio(["La ta.za ", "La ma.no ", "El de.do ", "El sa.po "],mayusculaMinusculaCursiva),
		]),
		new Nivel([
			new Ejercicio(["La ca.mi.sa ", "La pe.lo.ta ", "El he.la.do ", "La ma.ce.ta "], mayusculaMinusculaCursiva),
            #if flash
			new Ejercicio(["El pa.to na.da ", "La pa.lo.ma vue.la ", "Los a.mi.gos rí.en ", "El puen.te al.to "], mayusculaMinusculaCursiva),
			new Ejercicio(["El ne.ne es.tá con.ten.to ", "El ca.ra.me.lo es dul.ce ", "Jue.go con mis a.mi.gos ", "   ", " Los pá.ja.ros vue.lan en gru.po "],mayusculaMinusculaCursiva),
            #end
            #if (android || linux)
			new Ejercicio(["El pa.to na.da ", "La pa.lo.ma vue.la ", "Los a.mi.gos ri.en ", "El puen.te al.to "], mayusculaMinusculaCursiva),
			new Ejercicio(["El ne.ne es.ta con.ten.to ", "El ca.ra.me.lo es dul.ce ", "Jue.go con mis a.mi.gos ", "   ", " Los pa.ja.ros vue.lan en gru.po "],mayusculaMinusculaCursiva),
            #end
		]),
	];
	
	public var ejercicios : Array<Ejercicio>;

	public function new(Ejercicios : Array<Ejercicio>){
		ejercicios = Ejercicios;
	}
}

/*
 * Esta estructura sirve para definir los elementos que componen un item de ejercicio de un nivel
 * 		Según el modo de juego pueden emplearse algunos elementos del mismo
 * 		Por ejemplo: Para los ejercicios de pronunciación sólo se usa el <texto>, pero para los
 * 			ejercicios en que debe elegirse una imagen según lo que sale en el texto se usan
 * 			también referencias a Assets
 */

class Ejercicio
{
	/* 
	 * Las reglas  manera de escribir el texto es:
	 * 	- Espacios ( ) separan palabras
	 *  - Puntos (.) separan sílabas
	 *  - Espacio Punto Espacio separa subitem
	*/
	public var texto : Array<String>;
	
	public var tipoLetra: Setting;
	
	public function new(Texto : Array<String>,  Opciones: Setting) {
		texto = Texto;
		tipoLetra = Opciones;
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
