package trazos;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.FlxG;

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
	static var estiloRellenoArea = { color: FlxColor.GREEN };
	
	public static var niveles = [	// Array<ParamNivel>
		{	// Nivel 1
			trazo:  AssetPaths.n1e1__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 3,
						y: 4,
						radio: 19,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 3,
						y: 420,
						radio: 19,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 2
			trazo:  AssetPaths.n1e2__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 3,
						y: 230,
						radio: 19,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 428,
						y: 230,
						radio: 19,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 3
			trazo:  AssetPaths.n1e3__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 4,
						y: 384,
						radio: 19,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 388,
						y: 384,
						radio: 19,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 4
			trazo:  AssetPaths.n2e1__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 209,
						y: 7,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 202,
						y: 241,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 5
			trazo:  AssetPaths.n2e2__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 5,
						y: 65,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 521,
						y: 58,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 6
			trazo:  AssetPaths.n2e3__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 6,
						y: 7,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 410,
						y: 7,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 7
			trazo:  AssetPaths.n3e1__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 7,
						y: 192,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 380,
						y: 382,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 8
			trazo:  AssetPaths.n3e2__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 5,
						y: 207,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 629,
						y: 341,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
		},
		{	// Nivel 9
			trazo:  AssetPaths.n3e3__png,
			fondo:  null, // Sin fondo
			inicio: {
						x: 6,
						y: 35,
						radio: 10,
						borde: Nivel.estiloBordeArea,
						relleno: Nivel.estiloRellenoArea
					},
			fin: 	{
						x: 677,
						y: 289,
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
