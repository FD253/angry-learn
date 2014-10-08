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
	//public static var niveles = [	// Array<Nivel>
		//{
			//trazo:  AssetPaths.test_trace__png,
			//fondo:  null,
			//inicio: new FlxShapeCircle(185, 276, 15, { thickness: 1 }, { color: FlxColor.RED }),
			//fin:    new FlxShapeCircle(488, 65, 15, { thickness: 1 }, { color: FlxColor.RED })
		//},
	//];
	
	public var spriteTrazo : 	FlxSprite;	// La idea es que tengan el mismo tamaño que el escenario!
	public var spriteFondo : 	FlxSprite;

	public var areaInicio 	: FlxShapeCircle;
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