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
	var posicionDentroEjercicio: Int;
	var offset :Int; // Compensa lo ya pintado
	
	var botonesDeNivel : Array<FlxButton>;
	
	var puntajeCorrecto : Float;

	override public function create() {
		super.create();
		puntajeCorrecto = 100.0;
		actualizarPuntajeTotal(Reg.puntosKaraoke);
		
        agregarTitulo("KARAOKE");
		setearNivelEjercicioDesdeMaxLevel();
		
		trace(Reg.ejercicioKaraokeActual, Reg.nivelKaraokeActual);
		definirMenuDesplegable();
		btnMenuDesplegarOnClick();
		
		var botonDeEjercicioActual = botonesDeNivel[((Reg.nivelKaraokeActual* 3) + Reg.ejercicioKaraokeActual)];
		botonDeEjercicioActual.text = botonDeEjercicioActual.text + " <<<";
		for (boton in botonesDeNivel) {
			// Si el boton pertenece a un nivel ya alcanzado, le ponemos una estrella
			if (botonesDeNivel.indexOf(boton) <= Reg.maxLvlKaraoke)  {
				var estrella = new FlxSprite(0, 0, AssetPaths.estrella_menu_ejercicios__png);
				menuDesplegable.add(estrella);
				estrella.setPosition(boton.x - estrella.width * 1.5, boton.y); // La movemos un poco a la izq del boton
			}
		}
		
		posicionNivel = 0;
		var item : Ejercicio = Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual];
		
		textItem = new FlxText(300, 300, 680, null, 22);
		add(textItem);
		
		textItem.text = quitarPuntosItem(item);
		textItem.color = 15000804; // Gris 
		textItem.font = "assets/fonts/arialbd.ttf";
		
		var xInicial : Int = 162;
		var y: Int = 500;
		var yCorrectoIncorrecto : Int = 180;
				
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
		
		mostrarBtnsTipoLetra();
		
		btnIncorrecto = new FlxUIButton(0, 0 , null, ejercicioIncorrecto);
		btnIncorrecto.loadGraphic(AssetPaths.incorrectoCruz__png);
		btnIncorrecto.setPosition(FlxG.width / 4 + btnIncorrecto.width, yCorrectoIncorrecto);
		add(btnIncorrecto); 
		ocultarBtnIncorrecto();
		
		btnComenzar = new FlxUIButton(0, 0, null, comenzar);
		btnComenzar.loadGraphic(AssetPaths.comenzar__png);
		btnComenzar.setPosition(mitad - btnComenzar.width / 2, yCorrectoIncorrecto);
		add(btnComenzar);
		ocultarBtnComenzar();
		
		btnCorrecto = new FlxUIButton(0, 0, null, ejercicioCorrecto);
		btnCorrecto.loadGraphic(AssetPaths.correctoTilde__png);
		btnCorrecto.setPosition(FlxG.width / 4 * 3 - btnCorrecto.width * 2, yCorrectoIncorrecto);
		ocultarBtnCorrecto();
		add(btnCorrecto);
		
		btnCorrectoParcial = new FlxUIButton(0, 0, null, subEjercicioCorrecto);
		btnCorrectoParcial.loadGraphic(AssetPaths.correctoTilde__png);
		btnCorrectoParcial.setPosition(FlxG.width / 4 * 3 - btnCorrecto.width * 2, yCorrectoIncorrecto);
		add(btnCorrectoParcial);
		ocultarBtnCorrectoParcial();
		
		silabas = obtenerPartesItem(Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual]);
		posicionDentroItemGuardada = 0;
		posicionForAUsar = 0;
		posicionForGuardada = 0;
		posicionDentroEjercicio = 0;
		
		actualizarProgreso(100 / 3 * Reg.ejercicioKaraokeActual);
	}
	
	// PRIVATE METHODS
	function setearNivelEjercicioDesdeMaxLevel(){
		if ((Reg.nivelKaraokeActual * 3 + Reg.ejercicioKaraokeActual) > Reg.maxLvlKaraoke) {
			// Si se quiere iniciar un estado mayor al que se tiene acceso, se arranca en ese último
			function Modulo(n : Int, d : Int) : Int {
				var r = n % d;
				if(r < 0) r+=d;
				return r;
			}
			var ejercicio = Modulo(Reg.maxLvlKaraoke , 3);
			var nivel = Std.int(Reg.maxLvlKaraoke / 3);
			trace (nivel, ejercicio);
			Reg.nivelKaraokeActual = nivel;
			Reg.ejercicioKaraokeActual = ejercicio;
		}
	}
	
	function setearNivelEjercicioDesdeActualMasUno() {
		Reg.ejercicioKaraokeActual += 1;
	}
	
	function definirMenuDesplegable() {
		menuDesplegable.add(new FlxSprite(0, 0, AssetPaths.fondo_menu_desplegable_karaoke__png));
		botonesDeNivel = new Array<FlxButton>();
		var xInicial = menuDesplegable.width * 0.15;
		var yInicial = menuDesplegable.height * 0.3;
		var altoBoton = 32;
		var anchoBoton = 165;
		for (nivel in Nivel.niveles) {
			var xEspacio = (menuDesplegable.width - xInicial - anchoBoton * Nivel.niveles.length) / Nivel.niveles.length;
			var x = xInicial + (anchoBoton + xEspacio) * Nivel.niveles.indexOf(nivel);
			var textoNivel = new FlxText(x, 6, 0, "Nivel " + (Nivel.niveles.indexOf(nivel) + 1), 20);
			textoNivel.font = AssetPaths.carter__ttf;
			menuDesplegable.add(textoNivel);
			for (ejercicio in nivel.ejercicios) {
				var yEspacio = (menuDesplegable.height - yInicial - altoBoton * nivel.ejercicios.length) / nivel.ejercicios.length;
				var y = yInicial + (altoBoton + yEspacio) * nivel.ejercicios.indexOf(ejercicio);
				var boton = new FlxButton(x, y, 'Ejercicio ' + (nivel.ejercicios.indexOf(ejercicio) + 1), function () { 
									// Inline, para no crear los handlers a mano
									trace('nivel: ' + Nivel.niveles.indexOf(nivel) + ', ejercicio: ' + Std.string(nivel.ejercicios.indexOf(ejercicio)));
									Reg.nivelKaraokeActual = Nivel.niveles.indexOf(nivel);
									Reg.ejercicioKaraokeActual = nivel.ejercicios.indexOf(ejercicio);
									FlxTween.tween(btnMenuContraer, { x: -btnMenuContraer.width }, 0.1);
									FlxTween.tween(menuDesplegable, { x: -menuDesplegable.width }, 0.1, {complete: function(tween : FlxTween)
										{
											FlxG.switchState(new Logica());
										}
									});
								}
				);
				boton.label.setFormat(AssetPaths.carter__ttf, 17);
				boton.label.color = FlxColor.BLACK;
				boton.loadGraphic(AssetPaths.boton_ejercicio__png);
				menuDesplegable.add(boton);
				botonesDeNivel.push(boton); // Lo ponemos en un array para luego marcarlo segun se completan los lvls
			}
		}
	}
	
	
	function quitarPuntosItem(item:Ejercicio):String {
		var sinPuntos : String;
		sinPuntos = "";
		for (j in 0...item.texto.length) {			
			var partes = item.texto[j].split(",");
			for (i in 0...partes.length) {
				sinPuntos += partes[i];
			}
		}
		return sinPuntos;
	}
	
	function obtenerPartesItem(item:Ejercicio):Array<Array<String>> {
		var ret = new Array();
		var partes = new Array();	
		var subparte : String;
		subparte = "";
		
		var texto : String;
		
		for (j in 0...item.texto.length) {
			var partes = new Array();	
			for ( i in 0...item.texto[j].length) {
				if (item.texto[j].substring(i, i + 1) != "," && item.texto[j].substring(i, i + 1) != " ") {
					subparte += item.texto[j].substring(i, i+1);
				}
				else {
					partes.insert(partes.length, subparte);
					subparte = "";
				}
			}
			ret.push(partes);
		}
		return ret;
	}
	
	function mostrarBtnsTipoLetra() {
		var opciones: Setting;
		opciones = Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual].tipoLetra;
		
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
	function reiniciarBtnsTipoLetra() {
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
	}
	function cambiarPorMayusculas() {
		textItem.font = "assets/fonts/arialbd.ttf";
		textItem.text = textItem.text.toUpperCase();
		textItem.size = 33;
		btnMayuscula.loadGraphic(AssetPaths.mayusculaPresionada__png);
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
		mostrarBtnComenzar();
	}
	
	function cambiarPorMinusculas() {
		textItem.font = "assets/fonts/arialbd.ttf";
		textItem.text = textItem.text.toLowerCase();
		textItem.size = 33;
		btnMinuscula.loadGraphic(AssetPaths.minusculaPresionada__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursiva__png);
		mostrarBtnComenzar();
	}
	
	function cambiarPorCursivas() {
		textItem.font = "assets/fonts/cursiva.ttf";
		var item : Ejercicio = Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual];
		textItem.text = quitarPuntosItem(item);
		textItem.size = 44;
		btnMinuscula.loadGraphic(AssetPaths.minuscula__png);
		btnMayuscula.loadGraphic(AssetPaths.mayuscula__png);
		btnCursiva.loadGraphic(AssetPaths.cursivaPresionada__png);
		mostrarBtnComenzar();
	}
	
	function reproducirItem() {
		textItem.clearFormats();
		var item : Ejercicio = Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual];
		color = new FlxTextFormat(FlxColor.AZURE);
		textItem.text = quitarPuntosItem(item);
		mostrarBtnsTipoLetra();
	}
	
	function ocultarPuntajeParcial() {
		cuadroPuntajeParcial.visible = false;
		textoPuntajeParcial.visible = false;
	}
	
	function comenzar() {
		
		timeInicio = Date.now();
		ocultarPuntajeParcial();
		ocultarBtnComenzar();
		ocultarBtnsCalific();
		ocultarBtnsTipoLetra();
		
		if (Reg.ejercicioKaraokeActual < Nivel.niveles[Reg.nivelKaraokeActual].ejercicios.length) {
			textItem.visible = true;
			timer = new FlxTimer(0.4, resaltarSilabas, obtenerPartesItem(Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual])[posicionDentroEjercicio].length);
		}
	}
	
	function calcularTiempoEmpleado() {
		timeFin = Date.now();
		return(timeFin.getTime() - timeInicio.getTime());
	}
	
	
	function subEjercicioCorrecto() {
		avanzarMismoEjercicio();
		mostrarBtnComenzar();
		ocultarBtnsCalific();
	}

	function actualizarPuntaje(puntajeObtenido:Int) {
	    Reg.puntosKaraoke += puntajeObtenido;
		actualizarPuntajeTotal(Reg.puntosKaraoke);
	}
	
	function ejercicioCorrecto() {
		calcularTiempoEmpleado();		
		ocultarBtnsCalific();
		posicionDentroItemGuardada = 0;
		reiniciarPosicionDentroEjercicio();
		ServicioPosta.instancia.postPlay(puntajeCorrecto, Reg.idAppKaraoke, Reg.idNivelesKaraoke[Reg.nivelKaraokeActual * 3 + Reg.ejercicioKaraokeActual], calcularTiempoEmpleado());
		actualizarPuntaje(Std.int(puntajeCorrecto));
		if (Reg.ejercicioKaraokeActual == 2) { 
			actualizarProgreso(100);	// Mostramos el 100
		}
		else {
			actualizarProgreso(100 / 3 * (Reg.ejercicioKaraokeActual + 1));
		}
		mostrarResultado(Std.int(puntajeCorrecto), true, avanzarEjercicio);
	}
	
	function avanzarEjercicio() {
		if (Reg.ejercicioKaraokeActual < (Nivel.niveles[Reg.nivelKaraokeActual].ejercicios.length -1)) { // Ejercicio no último del nivel?
			Reg.ejercicioKaraokeActual += 1;	// Avanza ejercicio
			if (Reg.ejercicioKaraokeActual + Reg.nivelKaraokeActual * 3 > Reg.maxLvlKaraoke) { // Mayor que el mayor guardado?
				Reg.maxLvlKaraoke += 1;			// Nuevo mayor
			}
		}
		else {
			if (Reg.ejercicioKaraokeActual == (Nivel.niveles[Reg.nivelKaraokeActual].ejercicios.length -1)) { // Máximo del nivel?
				if (Reg.nivelKaraokeActual == 3) {	// Último nivel?
					trace("GANASTE!");
				}
				else {	// No último nivel?
					Reg.maxLvlKaraoke += 1;
					Reg.nivelKaraokeActual += 1;
					Reg.ejercicioKaraokeActual = 0;
				}
			}
		}
		FlxG.switchState(new Logica());
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
	
	function ocultarBtnsTipoLetra() {
		btnCursiva.visible = false;
		btnMayuscula.visible = false;
		btnMinuscula.visible = false;
	}
	
	function reinciarOffset() {
		offset = 0;
	}
	
	function ejercicioIncorrecto() {
		calcularTiempoEmpleado();
		reiniciarPosicionDentroEjercicio();
		ocultarBtnsCalific();
		reproducirItem();
		reiniciarBtnsTipoLetra();
		reinciarOffset();
		ServicioPosta.instancia.postPlay(0.0, Reg.idAppKaraoke, Reg.idNivelesKaraoke[Reg.nivelKaraokeActual * 3 + Reg.ejercicioKaraokeActual], calcularTiempoEmpleado());
		ocultarBtnsTipoLetra();
		mostrarResultado(Std.int(0), false, ocultarResultado);
		actualizarPuntaje(0);
	}
	
	function ocultarResultado() {
		resultado.visible = false;
		FlxG.switchState(new Logica());
	}

	function guardarPosDentroItem(pos:Int) {
		posicionDentroItemGuardada = pos;
	}
	function avanzarMismoEjercicio() {
		if (posicionDentroEjercicio < Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual].texto.length - 1) {
			posicionDentroEjercicio += 1;
		}
		else {
			btnCorrectoParcial.visible = false;
		}
		if (Reg.nivelKaraokeActual >= 2) {
			
			offset = posicionDentroItemGuardada + 4; // La posicion es donde está frenado. Tiene un espacio y después recien la siguiente letra
		}
		else {
			offset = posicionDentroItemGuardada + 3;
		}

	}
	
	function reiniciarPosicionDentroEjercicio() {
		posicionDentroEjercicio = 0;
	}
	
	function resaltarSilabas(timer :FlxTimer) {
		var posicionDentroSubItem :Int = 0;
		var silabas = new Array();
		var silaba : String;
		silabas = obtenerPartesItem(Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual]);

		silaba = silabas[posicionDentroEjercicio][timer.elapsedLoops - 1];
		color = new FlxTextFormat(FlxColor.AZURE);
		
		for (i in 0...silabas[posicionDentroEjercicio].length) {
			if (i+1 == timer.elapsedLoops) {
				textItem.addFormat(color, posicionDentroSubItem + offset , posicionDentroSubItem + offset + silabas[posicionDentroEjercicio][i].length);
				guardarPosDentroItem(posicionDentroSubItem+offset);
			}
			else {
				if (textItem.text.charAt(posicionDentroSubItem + offset + silabas[posicionDentroEjercicio][i].length) == " "){
					posicionDentroSubItem += silabas[posicionDentroEjercicio][i].length + 1; 

				}

				else {
					posicionDentroSubItem += silabas[posicionDentroEjercicio][i].length;
				}
			}
		}		
		if (timer.loopsLeft == 0) {
			var item : Ejercicio = Nivel.niveles[Reg.nivelKaraokeActual].ejercicios[Reg.ejercicioKaraokeActual];
			var texto : String;
			texto = quitarPuntosItem(item);
			trace('posicionDentroItemGuardada = ' + posicionDentroItemGuardada);
			trace('texto.lenght = ' + texto.length);
			if (Reg.nivelKaraokeActual >= 2) {
				if (posicionDentroItemGuardada + 2 == texto.length || posicionDentroItemGuardada + 4 == texto.length) {
					mostrarBtnCorrecto();
					ocultarBtnCorrectoParcial();
					trace("fin del ejercicio");
				}
				else {
					mostrarBtnCorrectoParcial();
				}
			}
			else {
				if (posicionDentroItemGuardada + 2 == texto.length || posicionDentroItemGuardada + 3 == texto.length) {
					mostrarBtnCorrecto();
					ocultarBtnCorrectoParcial();
					trace("fin del ejercicio");
				}
				else {
					mostrarBtnCorrectoParcial();
				}
			}
			mostrarBtnIncorrecto();
		}
	}	
}
