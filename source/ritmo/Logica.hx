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
	var esperandoPrimerToque : Bool = false;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia de pulsos del ejercicio (Para grabar y escuchar)
	var secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var botonesInterfaz = new FlxTypedGroup<FlxButton>();
	var btnEscuchar : FlxButton;
	var btnJugar : FlxButton;
	var btnToques : FlxButton;
	
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
	    agregarTitulo("SIGUE EL RITMO");	
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
		
		// Según qué ejercicio es, mostramos el progreso en la barra
		actualizarProgreso(100 / 3 * Reg.ejercicioRitmoActual);
		
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
		actualizarPuntajeTotal(Reg.puntosRitmo);
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
			var textoNivel = new FlxText(x, 8, 0, "Nivel " + (Nivel.niveles.indexOf(nivel) + 1), 20);
			textoNivel.font = AssetPaths.carter__ttf;
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
		var alturaBotonesSuperiores = 120;
		
		// Los botones van a altura fija y de lado siempre con respecto a la mitdas del ancho del juego (O entre sí horizontalmente)
		
		// Botón jugar
		btnJugar = new FlxButton(0, 0, '', btnJugarOnClick);
		btnJugar.loadGraphic(AssetPaths.boton_jugar__png);		
		// El usuario no puede jugar de entrada. Tiene que haber escuchado la secuencia antes
		btnJugar.visible = false;
		
		// Botón escuchar
		btnEscuchar = new FlxButton(0, 0, '', btnEscucharOnClick);
		btnEscuchar.loadGraphic(AssetPaths.boton_escuchar__png);
		
		btnEscuchar.setPosition(mitadAncho - (btnEscuchar.width + btnJugar.width + 20) / 2 - 40, alturaBotonesSuperiores);
		btnJugar.setPosition(btnEscuchar.width + btnEscuchar.x + 20, alturaBotonesSuperiores);
		
		botonesInterfaz.add(btnEscuchar);
		botonesInterfaz.add(btnJugar);
		
		// Panel de niveles
		
		// Botón de toques
		btnToques = new FlxButton((FlxG.width / 2), (alturaBotonesSuperiores + FlxG.height * 0.3), '', btnToquesOnClick);
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
		txtNumeroDeSecuencia.setPosition(cuadroPuntajeTotal.x + cuadroPuntajeTotal.width, nombreJuego.y);
		txtNumeroDeSecuencia.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLACK, 3, 1);
		actualizarNumeroDeSecuenciaActual();
		add(txtNumeroDeSecuencia);
		
		add(botonesInterfaz);
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
			FlxG.sound.play(AssetPaths.coin__wav);
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
			Reg.puntosRitmo += Std.int(resultado / 3);
			actualizarPuntajeTotal(Std.int(Reg.puntosRitmo));
			
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
				
				// Dividimos el puntaje de ejercicio porque el puntaje es la suma de las 3 secuencias que como máximo dan 300
				ServicioPosta.instancia.postPlay(puntajeDeEjercicio / 3, Reg.idAppRitmo, Reg.idNivelesRitmo[Reg.nivelRitmoActual * 3 + Reg.ejercicioRitmoActual], tiempoDeJuego);
				
				var estrella = new FlxSprite(0, 0, AssetPaths.estrella_menu_ejercicios__png);
				var botonDeEjercicioActual = botonesDeNivel[((Reg.nivelRitmoActual * 3) + Reg.ejercicioRitmoActual)];
				menuDesplegable.add(estrella);
				estrella.setPosition(botonDeEjercicioActual.x - estrella.width * 1.5, botonDeEjercicioActual.y); // La movemos un poco a la izq del boton
				
				if (puntajeDeEjercicio >= 250) {
					// Sólo ejecuto el código que hace el cambio de nivel si superó el puntaje este
					
					Reg.maxLvlRitmo += 1; // Habilito al usuario para que después pueda cambiar a mano el ejercicio
					
					if (Reg.ejercicioRitmoActual == 2) {
						actualizarProgreso(100);	// Mostramos el 100
						Reg.ejercicioRitmoActual = 0;
						
						if (Reg.nivelRitmoActual == 2) {
							trace("TODO: No tenemos más niveles. Qué hacemos?");
							//TODO!
							// Ojo que no hace switch state porque termina este if y entre lo que tarda ejecuta el switch state de abajo
						}
						else {
							Reg.nivelRitmoActual += 1;
						}
					}
					else {
						Reg.ejercicioRitmoActual += 1;
					}
					mostrarResultado(Std.int(puntajeDeEjercicio / 3), true, popupBienHechoOnClick);
				}
				else {
					mostrarResultado(Std.int(puntajeDeEjercicio / 3), false, popupMalHechoOnClick);
				}
				
				secuenciaActual = 0;
				puntajeDeEjercicio = 0;
				// Cambiamos de estado (ejercicio puede ser otro ahora... O el mismo si no superó puntaje)
				
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
	
	function computarClick() {
		secuenciaUsuario[acumulador] += 1;
		FlxG.sound.play(AssetPaths.coin__wav);
		txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
		trace("click");
	}
	
	function avancePrimerMedioIntervalo(timer : FlxTimer) {
		// Esto se ejecuta medio intervalo después luego de haber pulsado el boton de pulsos
		// Ni bien termina este "medio intervalo" muerto, se hace lo siguiente:
		acumulador += 1;	// Avanzamos al siguiente
		// E iniciamos el contador de verdad... pero con un intervalo menos porque este medio ya cuenta como uno
		new FlxTimer(ejercicio.secuencias[secuenciaActual].intervalo, avanceGrabacion, ejercicio.secuencias[secuenciaActual].pulsos.length - 1);
	}
	
	function btnToquesOnClick() {
		// Grabamos en un array
		if (enCurso) {
				computarClick();
		}
		else {
			// Si no está en curso y el botón de Jugar está invisible, quiere decir que se está esperando para empezar.
			// El primer toque pone el juego en curso
			if (esperandoPrimerToque) {
				esperandoPrimerToque = false;
				enCurso = true;
				// Iniciamos un ciclo que dura sólo medio intervalo para sincronizar los toques con las casillas, éste se encarga de arrancar el timer "de verdad" para el resto de la secuencia
				new FlxTimer((ejercicio.secuencias[secuenciaActual].intervalo / 2), avancePrimerMedioIntervalo, 1);
				computarClick(); // Le tomamos esta primera pulsación
			}
		}
	}
	
	function popupBienHechoOnClick() {
		FlxG.switchState(new Logica());
	}
	
	function popupMalHechoOnClick()	{
		FlxG.switchState(new Logica());
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
		btnJugar.visible = false;
		btnEscuchar.visible = false;
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		secuenciaUsuario = [for (x in 0...ejercicio.secuencias[secuenciaActual].pulsos.length) 0];
		esperandoPrimerToque = true;
	}	
	
}
