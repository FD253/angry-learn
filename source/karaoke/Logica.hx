package karaoke;

import flixel.addons.ui.FlxUIPopup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import karaoke.Nivel.Item;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.ui.FlxUIButton;
import karaoke.MenuNiveles;
//import karaoke.PopUp;


class Logica extends FlxState
{
	// STATIC ATRIBUTES
	public static var nivelInicio : Nivel;
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	var posicionNivel : Int; //posicion en el array de niveles
	var timer : FlxTimer; //avanzador por silabas
	
	var textItem : FlxText;
	var formatoTween : FlxTextFormat;
	var contador : Int;
	
	override public function create() {
	
		super.create();
		nivel = nivelInicio;
		posicionNivel = 0; //deberia ser random
		var item : Item = nivel.items[posicionNivel];
		//textItem = new FlxText();
		textItem = new FlxText(80, 40, 480, null, 26);
		add(textItem);
		
				
		function mostrarPopUp() {
			var popup = new FlxUIPopup();
			var nombresBotones = new Array();
			nombresBotones.insert(0, "Totalmente mal");
			nombresBotones.insert(1, "Mal");
			nombresBotones.insert(2, "Apenas mal");
			
			popup.setPosition(0, 0);
			popup.quickSetup("Respuesta incorrecta", "Indicar que tan mal lo hizo", nombresBotones);
			popup.create();
			add(popup);
			
		}
				
		var btnIncorrecto = new FlxUIButton(560, 280 , "INCORRECTO", mostrarPopUp);
		add(btnIncorrecto); 
				
		function cambiarPorMayusculas() {
		textItem.systemFont = "Courrier New";
			textItem.text = textItem.text.toUpperCase();
		}
		
		function cambiarPorMinusculas() {
		textItem.systemFont = "Courrier New";
			textItem.text = textItem.text.toLowerCase();
		}
		
		var btnMayusculas = new FlxUIButton(0, 220 , "MAYUSCULAS", cambiarPorMayusculas);
		add(btnMayusculas); 
		
		var btnMinusculas = new FlxUIButton(0, 250 , "MINUSCULAS", cambiarPorMinusculas);
		add(btnMinusculas);		
		
		
		
		var btnCorrecto = new FlxUIButton(560, 220 , "CORRECTO", siguienteItem);
		add(btnCorrecto); 
		
		function cambiarPorCursiva() {
			textItem.systemFont = "Arial";
		}
		
		var btnCursiva = new FlxUIButton(0, 280 , "CURSIVA", cambiarPorCursiva);
		add(btnCursiva);
		
		//var btnItemAnterior = new FlxUIButton(200, 220 , "ANTERIOR");
		//add(btnItemAnterior);
		//
		//var btnItemSiguiente = new FlxUIButton(360, 220 , "SIGUIENTE");
		//add(btnItemSiguiente);
		//
		//var btnNivelAnterior = new FlxUIButton(200, 280 , "NIVEL ANTERIOR");
		//add(btnNivelAnterior);
		//
		//var btnNivelSiguiente = new FlxUIButton(360, 280 , "NIVEL SIGUIENTE");
		//add(btnNivelSiguiente);

		var btnAtras = new FlxUIButton(0, 330 , "ATRAS", irAtras);
		add(btnAtras);
		

		
		textItem.alignment = "center";
		textItem.text = quitarPuntosItem(item);
		textItem.systemFont = "Courrier New";

	}
	
	// PRIVATE METHODS
	
	function quitarPuntosItem(item:Item):String {
		var todo : String;
		todo = "";
		var partes = item.texto.split(".");
		for (i in 0...partes.length) {
			todo += partes[i];
		}
		return todo;
	}
	
	function obtenerPartesItem(item:Item):Array<String> {
		var partes = new Array();
		var subparte : String;
		//var bandera : Bool;
		//bandera = false; por default es false
		subparte = "";
		for ( i in 0...item.texto.length) {
			if (item.texto.substring(i, i + 1) != "." && item.texto.substring(i, i + 1) != " ") {
				subparte += item.texto.substring(i, i+1);
				var a : String;
				a = item.texto.substring(i, i+1);
				//bandera = true;
			}
			else {
				partes.insert(partes.length, subparte);
				//partes.add(subparte);
				subparte = "";
			}
		}
		return partes;
	}
	
	function repetirItem() {
	// si lo hizo mal, repetir el item
	}
	
	function asignarNivelDeMaldad() {
	//popup con botones. al presionar uno se sale el popup y llama a siguienteItem 
	}
	
	function irAtras()	{
		FlxG.switchState(new MenuNiveles());
	}

	function siguienteItem() {
		if (posicionNivel < (nivel.items.length - 1)) {
			posicionNivel += 1;
			var item : Item = nivel.items[posicionNivel];
			formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
			textItem.clearFormats();
			textItem.text = "";
			textItem.text = quitarPuntosItem(item);
			timer = new FlxTimer(0.5, resaltarSilabas, obtenerPartesItem(nivel.items[posicionNivel]).length);
		}
	}

	function resaltarSilabas(timer :FlxTimer) {
		contador = 0;
		var silabas = new Array();
		silabas = obtenerPartesItem(nivel.items[posicionNivel]);
		var silaba : String;
		silaba = silabas[timer.elapsedLoops-1];

		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		
		for (i in 0...silabas.length) {
			if (i +1 == timer.elapsedLoops) {
				if (textItem.text.charAt(contador + silabas[i].length) == " ") {
					textItem.addFormat(formatoTween, contador, contador + silabas[i].length);
				}
				else {
					textItem.addFormat(formatoTween, contador, contador + silabas[i].length);
				}
				break;
			}
			else {
				if (textItem.text.charAt(contador + silabas[i].length) == " "){
					contador += silabas[i].length+1;
				}
				else {
					contador += silabas[i].length;
				}
			}
		}

			
			//textItem.addFormat(formatoTween,
	}
}