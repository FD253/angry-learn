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
import sys.db.Types.STimeStamp;

import flixel.addons.ui.FlxUIRadioGroup;
import karaoke.Nivel;

class Logica extends BaseJuego {
	// STATIC ATRIBUTES
	public static var nivelInicio : Nivel;
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	var posicionNivel : Int;
	var timer : FlxTimer;
	var item : Item;
	
	var timeInicio : Date;
	var timeFin : Date;
	
	var textItem : FlxText;
	var color : FlxTextFormat;
	
	var btnCorrecto : FlxUIButton;
	var btnIncorrecto : FlxUIButton;
	var btnComenzar: FlxUIButton;
	
	var btnMayuscula : FlxUIButton;
	var btnMinuscula : FlxUIButton;
	var btnCursiva : FlxUIButton;
	
	override public function create() {
		super.create();
		nivel = nivelInicio;
		posicionNivel = 0;
		var item : Item = nivel.items[posicionNivel];
		
		textItem = new FlxText(155, 192, 458, null, 22);
		add(textItem);
		
		textItem.text = quitarPuntosItem(item);
		textItem.color = 15000804; // gris 
		textItem.font = "assets/fonts/arialbd.ttf";
		
		var xInicial : Int = 162;
		var y: Int = 310;
				
		var mitad: Float = FlxG.width / 2;
		
		btnMinuscula = new FlxUIButton(0, y, null, cambiarPorMinusculas);	
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnMinuscula.x = mitad - btnMinuscula.width / 2;
		add(btnMinuscula);
		btnMinuscula.visible = false;
		
		btnMayuscula = new FlxUIButton(0, y, null, cambiarPorMayusculas);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnMayuscula.x = btnMinuscula.x - btnMayuscula.width - 16;
		add(btnMayuscula);
		btnMayuscula.visible = false;
		
		btnCursiva = new FlxUIButton(btnMinuscula.x, y, null, cambiarPorCursivas);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
		btnCursiva.x = btnMinuscula.x + btnMayuscula.width + 16;
		add(btnCursiva);
		btnCursiva.visible = false;
		
		mostrarOpciones();
		
		btnIncorrecto = new FlxUIButton(500, 82 , null, itemIncorrecto);
		btnIncorrecto.loadGraphic(AssetPaths.incorrecto__png);
		btnIncorrecto.visible = false;
		add(btnIncorrecto); 
		
		btnComenzar = new FlxUIButton(85, 95 , null, comenzar);
		btnComenzar.loadGraphic(AssetPaths.comenzar__png);
		add(btnComenzar);
		
		btnCorrecto = new FlxUIButton(550, 82 , null, itemCorrecto);
		btnCorrecto.loadGraphic(AssetPaths.correcto__png);
		btnCorrecto.visible = false;
		add(btnCorrecto);
		
		var btnAtras = new FlxUIButton(0, 330 , "ATRAS", irAtras);
		add(btnAtras);
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
	
	function mostrarOpciones() {
		var opciones: Setting;
		opciones = nivel.items[posicionNivel].opciones;
		
		if (opciones.Mayuscula == true) {
			btnMayuscula.visible = true;
			
			if (opciones.Minuscula == true) {
				btnMinuscula.visible = true;	
			
				if (opciones.Cursiva == true) {
					btnCursiva.visible = true;
				}
			}			
		}
	}
	
	function cambiarPorMayusculas() {
		textItem.font = "assets/fonts/arialbd.ttf";
		textItem.text = textItem.text.toUpperCase();
		textItem.size = 22;
		btnMayuscula.loadGraphic(AssetPaths.mayusculaPresionada__png);
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
	}
	
	function cambiarPorMinusculas() {
		textItem.font = "assets/fonts/arialbd.ttf";
		textItem.text = textItem.text.toLowerCase();
		textItem.size = 22;
		btnMinuscula.loadGraphic(AssetPaths.minusculaPresionada__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
	}
	
	function cambiarPorCursivas() {
		textItem.font = "assets/fonts/cursiva.ttf";
		var item : Item = nivel.items[posicionNivel];
		textItem.text = textItem.text = quitarPuntosItem(item);
		textItem.size = 30;
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursivaPresionada__png);
	}
	
	function reproducirItem() {
		textItem.clearFormats();
		var item : Item = nivel.items[posicionNivel];
		color = new FlxTextFormat(FlxColor.AZURE);
		textItem.text = quitarPuntosItem(item);
		btnComenzar.visible = true;
		mostrarOpciones();
	}
	
	function irAtras()	{	
		FlxG.switchState(new MenuNiveles());
	}

	function comenzar() {
		
		timeInicio = Date.now();
		
		btnComenzar.visible = false;	
		if (posicionNivel < (nivel.items.length)) {
			timer = new FlxTimer(0.1, resaltarSilabas, obtenerPartesItem(nivel.items[posicionNivel]).length);
		}
	}
	
	function calcularTiempoEmpleado() {
		timeFin = Date.now();
		trace(timeFin.getTime() - timeInicio.getTime());
	}
	
	function itemCorrecto() {
		calcularTiempoEmpleado();		
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
		calcularTiempoEmpleado();
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