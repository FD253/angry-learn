package ;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;

class BaseJuego extends BaseEstado
{
	
	override public function create() {
		super.create();
		
		// Botón para ir atrás (Al menú de juego)
		var botonAtras = new FlxButton(7, 7, botonAtrasOnClick);
		botonAtras.loadGraphic(AssetPaths.boton_atras__png);
		add(botonAtras);
	}
	
	function botonAtrasOnClick() {
		FlxG.switchState(new MenuPrincipal());
	}
	
}