package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import openfl.events.Event;

class BaseEstado extends FlxState
{
	// Este estado define cosas comunes a todos los FlxState que se usan:
	//	- Pantallas de menúes
	//	- Pantallas de juegos

	override public function create() {
		super.create();
		
		this.set_bgColor(15000804);
		
		var fondoPiso = new FlxSprite(0, 0, AssetPaths.fondo_piso__png);
		// Ajustamos el ancho al de la pantalla
		fondoPiso.setGraphicSize(FlxG.width, 0);
		fondoPiso.updateHitbox();
		// Colocamos el piso abajo de todo
		fondoPiso.y = FlxG.height - fondoPiso.height;
		add(fondoPiso);
		
		var encabezado = new FlxSprite(0, 0, AssetPaths.encabezado__png);
		encabezado.setGraphicSize(FlxG.width, 0);
		encabezado.updateHitbox();
		add(encabezado);
	}
}