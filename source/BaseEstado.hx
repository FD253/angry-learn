package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class BaseEstado extends FlxState
{
	// Este estado define cosas comunes a todos los FlxState que se usan:
	//	- Pantallas de menúes
	//	- Pantallas de juegos

	override public function create() {
		super.create();
		
		var fondo = new FlxSprite(0, 0, AssetPaths.fondo__png);
		fondo.setGraphicSize(FlxG.width, FlxG.height);	// No nos importa el aspect ratio para esta imagen
		fondo.updateHitbox();
		add(fondo);
		
		var fondo_piso = new FlxSprite(0, 0, AssetPaths.fondo_piso__png);
		// Ajustamos el ancho al de la pantalla
		fondo_piso.setGraphicSize(FlxG.width, 0);
		fondo_piso.updateHitbox();
		// Colocamos el piso abajo de todo
		fondo_piso.y = FlxG.height - fondo_piso.height;
		add(fondo_piso);
		
		var encabezado = new FlxSprite(0, 0, AssetPaths.encabezado__png);
		encabezado.setGraphicSize(FlxG.width, 0);
		encabezado.updateHitbox();
		add(encabezado);
	}
	
}