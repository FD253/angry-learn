package ritmo;

import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup;
import Reg;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import openfl.events.MouseEvent;
import flixel.util.FlxColor;
import ritmo.Nivel.Ejercicio;
import flixel.util.FlxPoint;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


/**
 * Para entender la estructura de datos que maneja este ejercicio ver la documentación en ritmo.Niveles
 */
class Logica extends BaseJuego
{
	// STATIC ATRIBUTES	
	// El ejercicio consta de 3 secuencias. Siempre se arranca de la primer sencuencia. Guardamos la secuencia actual en secuenciaActual:
	var secuenciaActual : Int;	
	
	var puntajeDeEjercicio : Float = 0;
	
	public static var feedbackVisualInicio : Bool = false;
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var momentoInicioEjercicio : Date;
	var momentoFinEjercicio : Date;
	
	var ejercicio : Ejercicio;
	var feedbackVisual : Bool = false;	// mostrar o no la representacion de la secuencia
	var txtNumeroDeSecuencia : FlxText;	// Muesta cuál de las secuencias del ejercicio actual se está jugando
	
	var enCurso : Bool = false;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia de pulsos del ejercicio (Para grabar y escuchar)
	var secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var botonesInterfaz = new FlxTypedGroup<FlxButton>();
	var btnEscuchar : FlxButton;
	var btnJugar : FlxButton;
	var btnToques : FlxButton;
	
	var popupBienHecho : FlxButton;
	
	var txtRepresentacionSecuencia : FlxText;	// Esto va a mostrar la secuencia de la forma "00 00 00" para que el usuario la vea
	var formatoTween : FlxTextFormat;
	
	var tmrPrincipal : FlxTimer;	// Esta referencia sirve para el timer tanto de juego como de escucha
	
	var txtRetardo : FlxText;
	var tweenOptionsRitmo : TweenOptions = { type: FlxTween.BACKWARD, ease: FlxEase.quartInOut };
	var tweenMarcadorRitmo : FlxTween;	
	
	var botonesDeNivel : Array<FlxButton>;	// Esto guarda los botones que se usan para switchear nivel. Cosa de tenerluego su posición, etc
	
	// PUCLIC METHODS
	override public function create() {
		super.create();
		trace('creating state');
		
		if ((Reg.nivelRitmoActual * 3 + Reg.ejercicioRitmoActual) > Reg.maxLvlRitmo) {
			// Si se quiere iniciar un estado mayor al que se tiene acceso, se arranca en ese último
			// TODO: acá hay un bichito:
			function Modulo(n : Int, d : Int) : Int {
				var r = n % d;
				if(r < 0) r+=d;
				return r;
			}
			var ejercicio = Modulo(Reg.maxLvlRitmo , 3);
			var nivel = Std.int(Reg.maxLvlRitmo / 3);
			//var ejercicio = Math.floor(Reg.maxLvlRitmo / 3);	// El resto de la division-1 es el ejercicio
			trace (nivel, ejercicio);
			Reg.nivelRitmoActual = nivel;
			Reg.ejercicioRitmoActual = ejercicio;
		}
			
		ejercicio = Nivel.niveles[Reg.nivelRitmoActual].ejercicios[Reg.ejercicioRitmoActual];  // Buscamos el nivel que antes se debe haber definido en Reg
		secuenciaActual = 0; // Arrancamos en la primera secuencia de este ejercicio (Como es un array la primera es la 0)
		
		feedbackVisual = feedbackVisualInicio;
		
		definirRepresentacionSecuencia();
		agregarInterfaz();
		definirMenuDesplegable();
		var botonDeEjercicioActual = botonesDeNivel[((Reg.nivelRitmoActual * 3) + Reg.ejercicioRitmoActual)];
		botonDeEjercicioActual.text = botonDeEjercicioActual.text + " <<<";
		for (boton in botonesDeNivel) {
			// Si el boton pertenece a un nivel ya alcanzado, le ponemos una estrella
			if (botonesDeNivel.indexOf(boton) <= Reg.maxLvlRitmo)  {
				
				var estrella = new FlxSprite(0, 0, AssetPaths.estrella_menu_ejercicios__png);
				menuDesplegable.add(estrella);
				estrella.setPosition(boton.x - estrella.width * 1.5, boton.y); // La movemos un poco a la izq del boton
			}
		}
		btnMenuDesplegarOnClick();
	}
	
	
	// PRIVATE METHODS
	function definirRepresentacionSecuencia() {
		// Esto define el texto que muestra cómo es la secuencia (Ej: 0 000 00 )
		
		var mitadAncho = FlxG.width / 2;
		
		txtRepresentacionSecuencia = new FlxText();
		txtRepresentacionSecuencia.wordWrap = false;
		txtRepresentacionSecuencia.size = 20;
		txtRepresentacionSecuencia.setPosition(20, FlxG.height * 0.4);
		inicializarRepresentacionSecuencia();
		
		if (feedbackVisual) {	// Sólo mostrarlo si es requerido. Sino permanece oculto
			add(txtRepresentacionSecuencia);
		}
	}
	
	function inicializarRepresentacionSecuencia() {
		txtRepresentacionSecuencia.clearFormats();
		txtRepresentacionSecuencia.text = ejercicio.secuencias[secuenciaActual].pulsos.toString();
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, ",", ""); 	// Quitamos las comas
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, "0", " ");	// Ponemos espacios en los silencios
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, "1", "0");	// Ponemos "círculos" en cada sonido
	}
	
	function definirMenuDesplegable() {
		menuDesplegable.add(new FlxSprite(0, 0, AssetPaths.fondo_menu_desplegable__png));
		
		botonesDeNivel = new Array<FlxButton>();
		
		var xInicial = menuDesplegable.width * 0.15;
		var yInicial = menuDesplegable.height * 0.3;
		var altoBoton = 32;
		var anchoBoton = 165;
		for (nivel in Nivel.niveles) {
			var xEspacio = (menuDesplegable.width - xInicial - anchoBoton * Nivel.niveles.length) / Nivel.niveles.length;
			var x = xInicial + (anchoBoton + xEspacio) * Nivel.niveles.indexOf(nivel);
			var textoNivel = new FlxText(x, 15, 0, "Nivel " + (Nivel.niveles.indexOf(nivel) + 1));
			textoNivel.size = 18;
			menuDesplegable.add(textoNivel);
			for (ejercicio in nivel.ejercicios) {
				var yEspacio = (menuDesplegable.height - yInicial - altoBoton * nivel.ejercicios.length) / nivel.ejercicios.length;
				var y = yInicial + (altoBoton + yEspacio) * nivel.ejercicios.indexOf(ejercicio);
				var boton = new FlxButton(x, y, 'Ejercicio ' + (nivel.ejercicios.indexOf(ejercicio) + 1), function () { 
									//Inline, para no crear los handlers a mano
										Reg.nivelRitmoActual = Nivel.niveles.indexOf(nivel);
										Reg.ejercicioRitmoActual = nivel.ejercicios.indexOf(ejercicio);
										trace('nivel: ' + Nivel.niveles.indexOf(nivel) + ', ejercicio: ' + Std.string(nivel.ejercicios.indexOf(ejercicio)));
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
				//boton.label.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 1.9, 1);
				boton.loadGraphic(AssetPaths.boton_ejercicio__png);
				menuDesplegable.add(boton);
				botonesDeNivel.push(boton); // Lo ponemos en un array para luego marcarlo segun se completan los lvls
			}
		}
	}
	
	function agregarInterfaz() {
		var mitadAncho = FlxG.width / 2;
		var alturaBotonesSuperiores = 75;
		
		// Nombre del juego
		var nombreJuego = new FlxText(0, encabezado.height * 0.25);
		nombreJuego.size = 38; // HARDCODED
		nombreJuego.text = "RITMO LECTOR";
		nombreJuego.font = AssetPaths.carter__ttf;
		nombreJuego.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		nombreJuego.x = FlxG.width / 2 - nombreJuego.fieldWidth / 2;	// Centramos al medio, manteniendo la altura
		add(nombreJuego);
		
		
		// Los botones van a altura fija y de lado siempre con respecto a la mitdas del ancho del juego (O entre sí horizontalmente)
		
		// Botón jugar
		btnJugar = new FlxButton(0, 0, '', btnJugarOnClick);
		btnJugar.loadGraphic(AssetPaths.boton_jugar__png);
		btnJugar.setPosition(mitadAncho - btnJugar.width - 20, alturaBotonesSuperiores);
		botonesInterfaz.add(btnJugar);
		// El usuario no puede jugar de entrada. Tiene que haber escuchado la secuencia antes
		btnJugar.visible = false;
		
		// Botón escuchar
		btnEscuchar = new FlxButton(0, 0, '', btnEscucharOnClick);
		btnEscuchar.loadGraphic(AssetPaths.boton_escuchar__png);
		btnEscuchar.setPosition(btnJugar.x - btnEscuchar.width - 40, alturaBotonesSuperiores);
		botonesInterfaz.add(btnEscuchar);
		
		// Panel de niveles
		
		// Botón de toques
		btnToques = new FlxButton((FlxG.width / 2), (FlxG.height * 0.4), '', btnToquesOnClick);
		btnToques.loadGraphic(AssetPaths.boton__png, true, 297, 305); // HARDCODED
		btnToques.x = btnToques.x - btnToques.width / 2;
		btnToques.y = btnToques.y - btnToques.height / 2;
		add(btnToques);
		
		// Misc
		txtRetardo = new FlxText();
		txtRetardo.wordWrap = false;
		txtRetardo.autoSize = false;
		txtRetardo.fieldWidth = 300;
		txtRetardo.size = 30;
		txtRetardo.setPosition(mitadAncho - txtRetardo.fieldWidth / 2, alturaBotonesSuperiores + 10 + 25);
		txtRetardo.alignment = "center";
		add(txtRetardo);
		
		// Numero de secuencia del ejercicio actual
		txtNumeroDeSecuencia = new FlxText();
		txtNumeroDeSecuencia.wordWrap = false;
		txtNumeroDeSecuencia.autoSize = false;
		txtNumeroDeSecuencia.fieldWidth = 100;
		txtNumeroDeSecuencia.size = 40;
		txtNumeroDeSecuencia.alignment = "center";
		txtNumeroDeSecuencia.font = AssetPaths.carter__ttf;
		txtNumeroDeSecuencia.setPosition(FlxG.width - txtNumeroDeSecuencia.width - FlxG.width * 0.1,
										 txtNumeroDeSecuencia.height * 0.05);
		actualizarNumeroDeSecuenciaActual();
		add(txtNumeroDeSecuencia);
		
		add(botonesInterfaz);
		
		
		// Cartel de bien hecho
		popupBienHecho = new FlxButton(FlxG.width * 0.45, FlxG.height * 0.3, '', popupBienHechoOnClick);
		popupBienHecho.loadGraphic(AssetPaths.popup_ejercicio_bien__png);
		popupBienHecho.visible = false;
		add(popupBienHecho);
	}
	
	function actualizarNumeroDeSecuenciaActual() {
		txtNumeroDeSecuencia.text = Std.string(secuenciaActual + 1) + "/" + Std.string(ejercicio.secuencias.length);
	}
	
	function avanceReproduccion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			botonesInterfaz.setAll("visible", true);
			txtRepresentacionSecuencia.clearFormats();
		}
		if (ejercicio.secuencias[secuenciaActual].pulsos[acumulador] == 1 && timer.loopsLeft > 0) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
		}
		acumulador += 1;
	}
	
	function avanceGrabacion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace("terminó");
			trace(ejercicio.secuencias[secuenciaActual].pulsos);
			trace(secuenciaUsuario);
			
			var errores = 0;
			// TODO: Contabilizar el acierto
			for (i in 0...ejercicio.secuencias[secuenciaActual].pulsos.length) {
				if (ejercicio.secuencias[secuenciaActual].pulsos[i] != secuenciaUsuario[i]) {
					errores += Std.int(Math.abs(secuenciaUsuario[i] - ejercicio.secuencias[secuenciaActual].pulsos[i]));
				}
				//else {
					//if (secuenciaUsuario[i] = true) {
						//errores = Std.int(errores / 2);
					//}
				//}
			}
			var resultado = 100 - (errores / ejercicio.secuencias[secuenciaActual].pulsos.length) * 100; // Porcentaje de aciertos = 100 - porcentaje de erorres
			
			// Si lo hizo asquerosamente mal, su puntuación puede ser negativa, así que directamente eso es un CERO
			if (resultado < 0) {
				resultado = 0;
			}
			
			trace("resultado: ", resultado);
			Reg.puntosRitmo += Std.int(resultado);
			
			btnJugar.visible = false;
			btnJugar.active = true;
			btnEscuchar.visible = true;
			txtRetardo.text = "";
			
			enCurso = false;
			
			// Avanzamos...
			if (secuenciaActual == ejercicio.secuencias.length - 1) {
				puntajeDeEjercicio += resultado;
				// Si terminó el ejercicio, avanzamos a otro
				trace('Se terminó el ejercicio');
				
				momentoFinEjercicio = Date.now();
				// Calculamos cuántos segundos pasaron desde que empezó (Restamos tiempos y pasamos de milisegundos a segundos)
				var tiempoDeJuego = (momentoFinEjercicio.getTime() - momentoInicioEjercicio.getTime()) / 1000;
				
				ServicioPosta.instancia.postPlay(puntajeDeEjercicio, Reg.idAppRitmo, Reg.idNivelesRitmo[Reg.nivelRitmoActual * 3 + Reg.ejercicioRitmoActual], tiempoDeJuego);
				
				var estrella = new FlxSprite(0, 0, AssetPaths.estrella_menu_ejercicios__png);
				var botonDeEjercicioActual = botonesDeNivel[((Reg.nivelRitmoActual * 3) + Reg.ejercicioRitmoActual)];
				menuDesplegable.add(estrella);
				estrella.setPosition(botonDeEjercicioActual.x - estrella.width * 1.5, botonDeEjercicioActual.y); // La movemos un poco a la izq del boton
				
				if (puntajeDeEjercicio >= 250) {
					// Sólo ejecuto el código que hace el cambio de nivel si superó el puntaje este
					
					Reg.maxLvlRitmo += 1; // Habilito al usuario para que después pueda cambiar a mano el ejercicio
					
					if (Reg.ejercicioRitmoActual == 2) {
						Reg.ejercicioRitmoActual = 0;
						
						if (Reg.nivelRitmoActual == 2) {
							trace("TODO: No tenemos más niveles. Qué hacemos?");
							//TODO!
							FlxG.switchState(new Logo());
							// Ojo que no hace switch state porque termina este if y entre lo que tarda ejecuta el switch state de abajo
						}
						else {
							Reg.nivelRitmoActual += 1;
						}
					}
					else {
						Reg.ejercicioRitmoActual += 1;
					}
					popupBienHecho.visible = true;  // Mostramos cartel de bien hecho
				}
				
				secuenciaActual = 0;
				puntajeDeEjercicio = 0;
				// Cambiamos de estado (ejercicio puede ser otro ahora... O el mismo si no superó puntaje)
				//FlxG.switchState(new Logica());
			}
			else {
				// Avanzamos a la siguiente secuencia de este ejercicio sin cambiar de estado
				secuenciaActual += 1;
				// Acumulamos el puntaje de la secuencia que se jugó al total del ejercicio
				puntajeDeEjercicio += resultado;
			}
			actualizarNumeroDeSecuenciaActual();
			inicializarRepresentacionSecuencia();
		}
		else {
			acumulador += 1;
		}
	}
	
	function inicioRetardado(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace('inicio de juego');
			txtRetardo.text += " A JUGAR! ";
			
			enCurso = true;
			new FlxTimer(ejercicio.secuencias[secuenciaActual].intervalo, avanceGrabacion, ejercicio.secuencias[secuenciaActual].pulsos.length);
		}
		else {
			txtRetardo.text += " . ";
		}
	}
	
	function btnToquesOnClick() {
		// Grabamos en un array
		if (enCurso) {
				secuenciaUsuario[acumulador] += 1;
				FlxG.sound.play(AssetPaths.ritmo_bell__wav);
				txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
				trace("click");
		}
		else {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		}
	}
	
	function popupBienHechoOnClick() {
		popupBienHecho.visible = false;
	}
	
	function btnEscucharOnClick() {
		botonesInterfaz.setAll("visible", false);
		
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		
		// Cuando el usuario quiere escuchar la primera secuencia del ejercicio, tomamos el tiempo para luego saber cuánto tarda en completar el ejercicio
		if (secuenciaActual == 0) {
			momentoInicioEjercicio = Date.now();
		}
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		tmrPrincipal = new FlxTimer(ejercicio.secuencias[secuenciaActual].intervalo, avanceReproduccion, ejercicio.secuencias[secuenciaActual].pulsos.length + 1); // Agregamos un loop extra para el resaltado del último golpe de la secuencia
	}
	
	function btnJugarOnClick() {
		btnJugar.active = false;
		btnEscuchar.visible = false;
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		secuenciaUsuario = [for (x in 0...ejercicio.secuencias[secuenciaActual].pulsos.length) 0];
		
		trace('inicio de retardo');
		tmrPrincipal = new FlxTimer(		// Esto es sólo para mostrar el texto 1 .. 2 .. 3 .. Go!
			0.2,	// Delay en segundos
			inicioRetardado,	// Handler
			4	// Loops
		);
	}	
	
}