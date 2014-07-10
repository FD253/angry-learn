package karaoke;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.ui.FlxUIButton;

class Logica extends FlxState
{
	// STATIC ATRIBUTES
	public static var nivelInicio : Nivel;
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	

	
	// PRIVATE METHODS

	
	// CLASS OVERRIDES
	override public function create() {

		var btnCorrecto = new FlxUIButton(560, 220 , "CORRECTO");
		add(btnCorrecto); 
		
		var btnIncorrecto = new FlxUIButton(560, 280 , "INCORRECTO");
		add(btnIncorrecto); 
		
		var btnMayusculas = new FlxUIButton(0, 220 , "MAYUSCULAS");
		add(btnMayusculas); 
		
		var btnMinusculas = new FlxUIButton(0, 250 , "MINUSCULAS");
		add(btnMinusculas); 
		
		var btnCursiva = new FlxUIButton(0, 280 , "CURSIVA");
		add(btnCursiva);
		
		var btnItemAnterior = new FlxUIButton(200, 220 , "ANTERIOR");
		add(btnItemAnterior);
		
		var btnItemSiguiente = new FlxUIButton(360, 220 , "SIGUIENTE");
		add(btnItemSiguiente);
		
		var btnNivelAnterior = new FlxUIButton(200, 280 , "NIVEL ANTERIOR");
		add(btnNivelAnterior);
		
		var btnNivelSiguiente = new FlxUIButton(360, 280 , "NIVEL SIGUIENTE");
		add(btnNivelSiguiente);
		
		var textItem = new FlxText(80, 80, 480, null, 16);
		add(textItem);
		textItem.alignment = "center";
		//textItem.systemFont = "Arial";
		
		
	}
	
}
