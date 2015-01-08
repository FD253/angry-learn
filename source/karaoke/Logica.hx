package karaoke;

import flixel.addons.display.FlxNestedSprite;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.ui.FlxUIText;
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
import flixel.addons.ui.FlxUIRadioGroup;

class Logica extends FlxState
{
	// STATIC ATRIBUTES
	public static var nivelInicio : Nivel;
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	var posicionNivel : Int;
	var timer : FlxTimer;
	var item : Item;
	
	var textItem : FlxText;
	var color : FlxTextFormat; //pseudotween
	
	var btnCorrecto : FlxUIButton;
	var btnIncorrecto : FlxUIButton;
	var btnComenzar: FlxUIButton;
	
	var tipoDeLetra : FlxUIRadioGroup;
	
	override public function create() {
		
		tipoDeLetra = new FlxUIRadioGroup(20, 220, 
		["Mayúscula", "Minúscula", "Cursiva"],
		["Mayúscula", "Minúscula", "Cursiva"]);
		add(tipoDeLetra);
		
		tipoDeLetra.selectedId = "Mayúscula";
		
		super.create();
		nivel = nivelInicio;
		posicionNivel = 0; //deberia ser random
		var item : Item = nivel.items[posicionNivel];
		textItem = new FlxText(80, 40, 480, null, 26);
		add(textItem);
		textItem.text = quitarPuntosItem(item);
		textItem.color = 0; // poner el mismo color que el fondo así parece que va apareciendo cada silaba
		
		btnIncorrecto = new FlxUIButton(560, 280 , "INCORRECTO", itemIncorrecto);
		btnIncorrecto.visible = false;
		add(btnIncorrecto); 
		
		btnComenzar = new FlxUIButton(560, 220 , "COMENZAR", comenzar);
		add(btnComenzar);
		
		btnCorrecto = new FlxUIButton(560, 220 , "CORRECTO", itemCorrecto);
		btnCorrecto.visible = false;
		add(btnCorrecto);
		
		var btnAtras = new FlxUIButton(0, 330 , "ATRAS", irAtras);
		add(btnAtras);
		
		textItem.alignment = "center";
		textItem.systemFont = "Calibri";

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
		subparte = "";
		for ( i in 0...item.texto.length) {
			if (item.texto.substring(i, i + 1) != "." && item.texto.substring(i, i + 1) != " ") {
				subparte += item.texto.substring(i, i+1);
				var a : String;
				a = item.texto.substring(i, i+1);
			}
			else {
				partes.insert(partes.length, subparte);
				subparte = "";
			}
		}
		return partes;
	}
		function cambiarPorMayusculas() {
			textItem.font = "assets/fonts/calibri.ttf";
			textItem.text = textItem.text.toUpperCase();
		}
		
		function cambiarPorMinusculas() {
			textItem.font = "assets/fonts/calibri.ttf";
			textItem.text =	textItem.text.toLowerCase();
			textItem.text = textItem.text.charAt(0).toUpperCase() + textItem.text.substring(1,textItem.text.length);
		}
				
		function cambiarPorCursiva() {
			textItem.text =	textItem.text.toLowerCase();
			textItem.text = textItem.text.charAt(0).toUpperCase() + textItem.text.substring(1,textItem.text.length);
			textItem.font = "assets/fonts/LCALLIG.TTF";
		}
		
	function switchTipoDeLetra() {
		switch( tipoDeLetra.selectedId ) {			
			case "Mayúscula":
				cambiarPorMayusculas();
			case "Minúscula":
				cambiarPorMinusculas();
			case "Cursiva":
				cambiarPorCursiva();
		}
	}
	
	function reproducirItem() {
		textItem.clearFormats();
		var item : Item = nivel.items[posicionNivel];
		color = new FlxTextFormat(FlxColor.AZURE);
		textItem.systemFont = "Calibri";
		textItem.text = quitarPuntosItem(item);
		btnComenzar.visible = true;
	}
	
	function irAtras()	{	
		FlxG.switchState(new MenuNiveles());
	}

	function comenzar() {
		btnComenzar.visible = false;
		if (posicionNivel < (nivel.items.length)) {
			timer = new FlxTimer(0.1, resaltarSilabas, obtenerPartesItem(nivel.items[posicionNivel]).length);
			switchTipoDeLetra();
		}
	}
	
	function itemCorrecto() {
		ocultarBtnCorrectoIncorrecto();
		if (posicionNivel < (nivel.items.length - 1)) {
			posicionNivel += 1;
			reproducirItem();	
			//GUARDAR DATA
			//PREGUNTAR SI QUIERE REPETIR
		}
	}

	function ocultarBtnCorrectoIncorrecto() {
		btnCorrecto.visible = false;
		btnIncorrecto.visible = false;
	}
	
	function itemIncorrecto() {
		ocultarBtnCorrectoIncorrecto();
		reproducirItem();
	}
	
	function resaltarSilabas(timer :FlxTimer) {
		var posicionDentroItem = 0;
		var silabas = new Array();
		var silaba : String;
		silabas = obtenerPartesItem(nivel.items[posicionNivel]);
		silaba = silabas[timer.elapsedLoops - 1];
		color = new FlxTextFormat(FlxColor.AZURE);
		for (i in 0...silabas.length) {
			if (i+1 == timer.elapsedLoops) {
				textItem.addFormat(color, posicionDentroItem, posicionDentroItem + silabas[i].length);
			}
			else {
				if (textItem.text.charAt(posicionDentroItem + silabas[i].length) == " "){
					posicionDentroItem += silabas[i].length+1; 
				}
				else {
					posicionDentroItem += silabas[i].length;
				}
			}
		}		
		if (timer.loopsLeft == 0) {
			btnCorrecto.visible = true;
			btnIncorrecto.visible = true;
		}
	}
}