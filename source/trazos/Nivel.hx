package trazos;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxPoint;
import flixel.FlxSprite;
import flixel.util.FlxColor;


/**
 * ...
 * @author ...
 */
class Nivel
{
	//static var estiloLinea = ( Reg.debug )? { thickness: 1 } : { thickness: null, color: FlxColor.TRANSPARENT };
	static var estiloFondo = ( Reg.debug )? { color: FlxColor.RED } : { color: FlxColor.WHITE };
	public static var niveles = [	// Array<Nivel>
		{	// Nivel 1
			trazo:  AssetPaths.test_trace__png,
			fondo:  null,
			inicio: new FlxShapeCircle(185, 276, 12, { thickness: 1 }, estiloFondo),
			fin:    new FlxShapeCircle(488, 65, 12, { thickness: 1 }, estiloFondo),
		},
		//{	// Nivel 2
			//trazo:  AssetPaths.test_trace__png,
			//fondo:  null,
			//inicio: new FlxShapeCircle(185, 276, 15, estiloLinea, estiloFondo),
			//fin:    new FlxShapeCircle(488, 65, 15, estiloLinea, estiloFondo),
		//},
		//{	// Nivel 3
			//trazo:  AssetPaths.test_trace__png,
			//fondo:  null,
			//inicio: new FlxShapeCircle(185, 276, 15, estiloLinea, estiloFondo),
			//fin:    new FlxShapeCircle(488, 65, 15, estiloLinea, estiloFondo),
		//},
	];
	
	public var spriteTrazo : 	FlxSprite;	// La idea es que tengan el mismo tamaño que el escenario!
	public var spriteFondo : 	FlxSprite;

	public var areaInicio 	: FlxShapeCircle;	// Las areas DEBEN entrar COMPLETAMENTE dentro del trazo!
	public var areaFin		: FlxShapeCircle;
	
	public function new(trazo : String,
						fondo : String,
						inicio : FlxShapeCircle,
						fin : FlxShapeCircle) {
		
		spriteTrazo = new FlxSprite(0, 0, "assets/images/test_trace.png");
		spriteFondo = new FlxSprite(0, 0, fondo);
		areaInicio = inicio;
		areaFin = fin;
	}
	
	
	
}