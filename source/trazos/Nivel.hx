package trazos;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.LineStyle;

typedef ParamArea = {  // Son los parámetros que definen el área de inicio o fin de un nivel de trazos
	var x 		: Float;
	var y 		: Float;
	var radio 	: Float;
	var borde 	: LineStyle;
	var relleno : LineStyle;
}

typedef ParamNivel = {  // Parámetros que definen el nivel en sí
	var trazo  : String;
	var fondo  : String;
	var inicio : ParamArea;
	var fin    : ParamArea;
};

class Nivel
{
	static var estiloBordeArea = { thickness: null, color: FlxColor.TRANSPARENT };
	static var estiloRellenoArea = { color: FlxColor.MEDIUM_BLUE };
	
	public static var niveles = [	// Array<ParamNivel>
		{	// Nivel 1
			trazo:  AssetPaths.test_trace__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 185,
						y: 276,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 488,
						y: 65,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 2
			trazo:  AssetPaths.test_trace2__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 100,
						y: 300,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 72,
						y: 77,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 3
			trazo:  AssetPaths.test_trace3__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 35,
						y: 165,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 255,
						y: 155,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
	];
	
	public var spriteTrazo : 	FlxSprite;	// La idea es que tengan el mismo tamaño que el escenario!
	public var spriteFondo : 	FlxSprite;

	public var areaInicio 	: FlxShapeCircle;	// Las areas DEBEN entrar COMPLETAMENTE dentro del trazo!
	public var areaFin		: FlxShapeCircle;
	
	public function new(trazo : FlxSprite, fondo : FlxSprite, inicio : FlxShapeCircle, fin : FlxShapeCircle) {
		spriteTrazo = trazo;
		spriteFondo = fondo;
		areaInicio = inicio;
		areaFin = fin;
	}
	
	public static function nuevoNivel(numero: Int) : Nivel {
		var parametros = niveles[numero];
		var fondo = new FlxSprite(0, 0, parametros.fondo);
		var trazo = new FlxSprite(0, 0, parametros.trazo);
		var inicio = new FlxShapeCircle(parametros.inicio.x, parametros.inicio.y, parametros.inicio.radio, parametros.inicio.borde, parametros.inicio.relleno);
		var fin = new FlxShapeCircle(parametros.fin.x, parametros.fin.y, parametros.fin.radio, parametros.fin.borde, parametros.fin.relleno);
		
		return new Nivel(trazo, fondo, inicio, fin);
	}
}
