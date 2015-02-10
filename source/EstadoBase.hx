package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class EstadoBase extends FlxState
{
	// Este estado define cosas comunes a todos los FlxState que se usan:
	//	- Pantallas de menúes
	//	- Pantallas de juegos

	override public function create() {
		super.create();
		
		var fondo = new FlxSprite(0, 0, AssetPaths.fondo__png);
		fondo.setSize(FlxG.width, FlxG.height);	// No nos importa el aspect ratio para esta imagen
		
		var fondo_piso = new FlxSprite(0, 0, AssetPaths.fondo_piso__png);
		fondo_piso.setSize(FlxG.width, FlxG.height);
		// Ajustamos el ancho al de la pantalla
		fondo_piso.setGraphicSize(FlxG.width, 0);
		fondo_piso.updateHitbox();
		// Colocamos el piso abajo de todo
		fondo_piso.y = FlxG.height - fondo_piso.height;
		
		add(fondo);
		add(fondo_piso);
	}
	
}