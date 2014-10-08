package trazos;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxPoint;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Nivel
{
	public var spriteTrazo : 	FlxSprite;
	public var spriteFondo : 	FlxSprite;

	public var areaInicio 	: FlxShapeCircle;
	public var areaFin		: FlxShapeCircle;
	
	public function new(trazo : String,
						fondo : String,
						inicio : FlxShapeCircle,
						fin : FlxShapeCircle) {
		
		spriteTrazo = new FlxSprite(0, 0, trazo);
		spriteFondo = new FlxSprite(0, 0, fondo);
		areaInicio = inicio;
		areaFin = fin;
	}
	
	
	
}