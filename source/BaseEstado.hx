package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import openfl.events.Event;

class BaseEstado extends FlxState
{
	// Este estado define cosas comunes a todos los FlxState que se usan:
	//	- Pantallas de menúes
	//	- Pantallas de juegos
	var encabezado : FlxSprite;
	var nombreUsuario : FlxText;
	
	var cuadroUsuario : FlxButton;

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
		
		encabezado = new FlxSprite(0, 0, AssetPaths.encabezado__png);
		encabezado.setGraphicSize(FlxG.width, 0);
		encabezado.updateHitbox();
		add(encabezado);
		
		cuadroUsuario = new FlxButton(FlxG.width * 0.07, FlxG.height * 0.02);
		cuadroUsuario.loadGraphic(AssetPaths.cuadro_usuario__png);
		add(cuadroUsuario);
		nombreUsuario = new FlxText(cuadroUsuario.x + cuadroUsuario.width * 0.1,
								 cuadroUsuario.y, 0, Reg.nombreUsuarioActual, Std.int(Reg.botonMenuTextSize * 0.75));
		nombreUsuario.font = AssetPaths.carter__ttf;
		nombreUsuario.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 2, 1);
		nombreUsuario.y = cuadroUsuario.y + (cuadroUsuario.height - nombreUsuario.height) / 3; //- (txtUsuario.size * 0.3);
		add(nombreUsuario);
	}
}