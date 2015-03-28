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
import karaoke.Nivel.Ejercicio;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.ui.FlxUIButton;
import sys.db.Types.STimeStamp;
import flixel.addons.ui.FlxUIRadioGroup;
import karaoke.Nivel;
import haxe.Utf8;


class Logica extends BaseJuego {
	// STATIC ATRIBUTES
	public static var nivelInicio : Nivel;
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	var posicionNivel : Int;
	var timer : FlxTimer;
	var item : Ejercicio;
	
	var timeInicio : Date;
	var timeFin : Date;
	
	var textItem : FlxText;
	var color : FlxTextFormat;
	
	var btnCorrecto : FlxUIButton;
	var btnCorrectoParcial : FlxUIButton;
	var btnIncorrecto : FlxUIButton;
	var btnComenzar: FlxUIButton;
	
	var btnMayuscula : FlxUIButton;
	var btnMinuscula : FlxUIButton;
	var btnCursiva : FlxUIButton;
	var posicionForAUsar: Int;
	var posicionForGuardada:Int;
	
	var silabas = new Array();
	var posicionDentroItemGuardada :Int;
	//var silaba : String;
	var posicionDentroEjercicio: Int;
	var offset :Int; //compensa lo ya pintado
	

	
	
	override public function create() {
		super.create();
		definirMenuDesplegable();
		nivel = nivelInicio;
		posicionNivel = 0;
		var item : Ejercicio = nivel.ejercicios[posicionNivel];
		
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
		
		btnIncorrecto = new FlxUIButton(500, 82 , null, ejercicioIncorrecto);
		btnIncorrecto.loadGraphic(AssetPaths.incorrecto__png);
		add(btnIncorrecto); 
		ocultarBtnIncorrecto();
		
		btnComenzar = new FlxUIButton(85, 95 , null, comenzar);
		btnComenzar.loadGraphic(AssetPaths.comenzar__png);
		add(btnComenzar);
		ocultarBtnComenzar();
		
		btnCorrecto = new FlxUIButton(550, 82 , null, ejercicioCorrecto);
		btnCorrecto.loadGraphic(AssetPaths.correcto__png);
		ocultarBtnCorrecto();
		add(btnCorrecto);
		
		btnCorrectoParcial = new FlxUIButton(550, 10 , null, subEjercicioCorrecto);
		btnCorrectoParcial.loadGraphic(AssetPaths.correcto__png);
		//btnCorrectoParcial.visible = false;
		add(btnCorrectoParcial);
		ocultarBtnCorrectoParcial();
		
		var btnAtras = new FlxUIButton(0, 330 , "ATRAS", irAtras);
		add(btnAtras);
		silabas = obtenerPartesItem(nivel.ejercicios[posicionNivel]);
		//silaba = silabas[timer.elapsedLoops - 1];
		posicionDentroItemGuardada = 0;
		posicionForAUsar = 0;
		posicionForGuardada = 0;
		posicionDentroEjercicio = 0;
	}
	
	// PRIVATE METHODS
	function definirMenuDesplegable() {
		menuDesplegable.add(new FlxSprite(0, 0, AssetPaths.fondo_menu_desplegable_karaoke__png));
		
	}
	
	//function quitarGuionesItem(item:Item):List<String> {
		//var todo : List<String>;
		//var partes = item.texto.split("-");
		//for (i in 0...partes.length) {
			//todo.add(partes[i]);
		//}
		//return todo;
	//}
	
	function quitarPuntosItem(item:Ejercicio):String {
		var sinPuntos : String;
		sinPuntos = "";
		//function quitarPuntosYGuionesItem(item:Item):String {
		for (j in 0...item.texto.length) {			
			var partes = item.texto[j].split(".");
			for (i in 0...partes.length) {
				sinPuntos += partes[i];
			}
			//return sinPuntos;
			//partes = sinPuntos.split("-");
			//var sinPuntosNiGuiones : String;
			//for (i in 0...partes.length) {
				//sinPuntosNiGuiones += partes[i];
			//}
			//return sinPuntosNiGuiones;
		}
		return sinPuntos;
	}
	
	function obtenerPartesItem(item:Ejercicio):Array<Array<String>> {
		var ret = new Array();
		var partes = new Array();	
		var subparte : String;
		subparte = "";
		
		var texto : String;
		
		
		//#if flash
		for (j in 0...item.texto.length) {
			var partes = new Array();	
			for ( i in 0...item.texto[j].length) {
				if (item.texto[j].substring(i, i + 1) != "." && item.texto[j].substring(i, i + 1) != " ") {
					subparte += item.texto[j].substring(i, i+1);
					//var a : String;
					//a = item.texto.substring(i, i+1);
				}
				else {
					partes.insert(partes.length, subparte);
					subparte = "";
				}
			}
			ret.push(partes);
		}
		return ret;
		//return partes;
		//#end
		
		//#if android
		//
		//texto = Utf8.decode(item.texto);
		//
		//for ( i in 0...texto.length) {
			//if (texto.substring(i, i + 1) != "." && texto.substring(i, i + 1) != " " && texto.substring(i, i + 1) != "-") {
				//subparte += texto.substring(i, i+1);
				////var a : String;
				////a = texto.substring(i, i+1);
			//}
			//else {
				//partes.insert(partes.length, subparte);
				//subparte = "";
			//}
		//}
		//return ret;
		//#end
		//
		//return ret;
	}
	
	function mostrarOpciones() {
		var opciones: Setting;
		opciones = nivel.ejercicios[posicionNivel].opciones;
		
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
	function mostrarBtnComenzar() {
		btnComenzar.visible = true;
	}
	function ocultarBtnComenzar() {
		btnComenzar.visible = false;
	}
	function cambiarPorMayusculas() {
		textItem.font = "assets/fonts/arialbd.ttf";
		textItem.text = textItem.text.toUpperCase();
		textItem.size = 22;
		btnMayuscula.loadGraphic(AssetPaths.mayusculaPresionada__png);
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
		mostrarBtnComenzar();
	}
	
	function cambiarPorMinusculas() {
		textItem.font = "assets/fonts/arialbd.ttf";
		textItem.text = textItem.text.toLowerCase();
		textItem.size = 22;
		btnMinuscula.loadGraphic(AssetPaths.minusculaPresionada__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
		mostrarBtnComenzar();
	}
	
	function cambiarPorCursivas() {
		textItem.font = "assets/fonts/cursiva.ttf";
		var item : Ejercicio = nivel.ejercicios[posicionNivel];
		textItem.text = quitarPuntosItem(item);
		textItem.size = 30;
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursivaPresionada__png);
		mostrarBtnComenzar();
	}
	
	function reproducirItem() {
		textItem.clearFormats();
		var item : Ejercicio = nivel.ejercicios[posicionNivel];
		color = new FlxTextFormat(FlxColor.AZURE);
		textItem.text = quitarPuntosItem(item);
		mostrarOpciones();
	}
	
	function irAtras()	{	
		FlxG.switchState(new MenuPrincipal());
	}

	function comenzar() {
		
		timeInicio = Date.now();
		
		ocultarBtnComenzar();
		ocultarBtnsCalific();
		
		if (posicionNivel < (nivel.ejercicios.length)) {
			textItem.visible = true;
			timer = new FlxTimer(0.4, resaltarSilabas, obtenerPartesItem(nivel.ejercicios[posicionNivel])[posicionDentroEjercicio].length);
		}
	}
	
	function calcularTiempoEmpleado() {
		timeFin = Date.now();
		trace(timeFin.getTime() - timeInicio.getTime());
	}
	
	
	function subEjercicioCorrecto() {
		avanzarMismoEjercicio();
		mostrarBtnComenzar();
		ocultarBtnsCalific();
	}
	
	function ejercicioCorrecto() { //POSIBLEMENTE NO SE USE YA QUE ES MAS FACIL CAMBIAR DE ESTADO QUE ACOMODAR TODAS LAS VARIABLES
		calcularTiempoEmpleado();		
		ocultarBtnsCalific();
		posicionDentroItemGuardada = 0;  //reiniciar posicion dentro item guardada (xq se cambia por un nuevo item)
		reiniciarPosicionDentroEjercicio();
		if (posicionNivel < (nivel.ejercicios.length - 1)) {
			posicionNivel += 1;
			
			//SWITCHSTATE AL SIGUIENTE EJERCICIO DEL NIVEL
		}
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
	}

	function mostrarBtnIncorrecto() {
		btnIncorrecto.visible = true;
	}
	function ocultarBtnIncorrecto() {
		btnIncorrecto.visible = false;
	}
	
	function mostrarBtnCorrectoParcial() {
		btnCorrectoParcial.visible = true;
	}
	function ocultarBtnCorrectoParcial() {
		btnCorrectoParcial.visible = false;
	}
	
	function mostrarBtnCorrecto() {
		btnCorrecto.visible = true;
	}
	function ocultarBtnCorrecto() {
		btnCorrecto.visible = false;
	}
	
	function ocultarBtnsCalific() {
		btnCorrecto.visible = false;
		btnCorrectoParcial.visible = false;
		btnIncorrecto.visible = false;
	}
	
	function reinciarOffset() {
		offset = 0;
	}
	
	function ejercicioIncorrecto() {
		calcularTiempoEmpleado();
		reiniciarPosicionDentroEjercicio();
		ocultarBtnsCalific();
		reproducirItem();
		mostrarBtnComenzar();
		reinciarOffset();
	}

	function guardarPosDentroItem(pos:Int) {
		posicionDentroItemGuardada = pos;
	}
	function avanzarMismoEjercicio() {
		if (posicionDentroEjercicio < nivel.ejercicios[posicionNivel].texto.length - 1) {
			posicionDentroEjercicio += 1;
		}
		else {
			btnCorrectoParcial.visible = false;
		}
		offset = posicionDentroItemGuardada + 3; //la posicion es donde está frenado. tiene un espacio y despues recien la siguiente letra
												//bullshit! ////WARNING\\\ ---NUMERO MAGICO--- INVESTIGAR!!
	}
	
	function reiniciarPosicionDentroEjercicio() {
		posicionDentroEjercicio = 0;
	}
	
	function resaltarSilabas(timer :FlxTimer) {
		var posicionDentroSubItem :Int = 0;
		//var posicionDentroItem :Int = posicionDentroItemGuardada;
		var silabas = new Array();
		var silaba : String;
		silabas = obtenerPartesItem(nivel.ejercicios[posicionNivel]);

		silaba = silabas[posicionDentroEjercicio][timer.elapsedLoops - 1];
		color = new FlxTextFormat(FlxColor.AZURE);
		
		
		//while (silabas.length != 0 || silabas[0].charAt(0) == "-") {
		//}
		
		//trace(posicionDentroItemGuardada);
		//posicionDentroItem = posicionDentroItemGuardada;
		for (i in 0...silabas[posicionDentroEjercicio].length) {
			if (i+1 == timer.elapsedLoops) {
				textItem.addFormat(color, posicionDentroSubItem + offset , posicionDentroSubItem + offset + silabas[posicionDentroEjercicio][i].length);
				guardarPosDentroItem(posicionDentroSubItem+offset);
			}
			else {
				if (textItem.text.charAt(posicionDentroSubItem + offset + silabas[posicionDentroEjercicio][i].length) == " "){
					posicionDentroSubItem += silabas[posicionDentroEjercicio][i].length + 1; 
					//guardarPosDentroItem(posicionDentroItem);
				}
				//else if (textItem.text.charAt(posicionDentroItem + silabas[0][i].length) == "-") {
					//posicionDentroItem += silabas[0][i].length+1; 
					////timer.active = false;
					////mostrarBtnCorrectoParcial();
					////mostrarBtnIncorrecto();
					////posicionForGuardada = i+1;
					////break;
					////guardarPosDentroItem(posicionDentroItem);
				//}
				else {
					posicionDentroSubItem += silabas[posicionDentroEjercicio][i].length;
					//guardarPosDentroItem(posicionDentroItem);/// REPETIDO
				}
			}
		}		
		//trace(posicionDentroItemGuardada);
		if (timer.loopsLeft == 0) {
			var item : Ejercicio = nivel.ejercicios[posicionNivel];
			var texto : String;
			texto = quitarPuntosItem(item);
			
			if (posicionDentroItemGuardada+2 == texto.length) {
				//mostrarBtnCorrecto();
				trace("fin del ejercicio");
			}
			else {
				mostrarBtnCorrectoParcial();
			}
			mostrarBtnIncorrecto();
		}
	}	
}