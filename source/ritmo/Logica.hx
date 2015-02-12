package ritmo;

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

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


/**
 * 
 * Para entender la estructura de datos que maneja este ejercicio ver la documentación en ritmo.Niveles
 * 
 * @author Gabriel
 */
class Logica extends BaseJuego
{
	// STATIC ATRIBUTES
	// Esta variable debe ser seteada con el nivel que uno quiere que se ejecute...
	//   Por supesto que antes de instanciar el ejercicio, porque es lo que usa el método create() para definir el nivel del ejercicio
	public static var nivelInicio : Nivel;
	public static var feedbackVisualInicio : Bool = false;
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	var feedbackVisual : Bool;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia del ejercicio (Para grabar y escuchar)
	var secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var btnCancelar : FlxButton;
	
	var botonesInterfaz = new FlxTypedGroup<FlxButton>();
	
	var txtRepresentacionSecuencia : FlxText;	// Esto va a mostrar la secuencia de la forma "00 00 00" para que el usuario la vea
	var formatoTween : FlxTextFormat;

	
	var btnMenuVolver : FlxButton;
	var btnEscuchar : FlxButton;
	var btnJugar : FlxButton;
	var tmrPrincipal : FlxTimer;	// Esta referencia sirve para el timer tanto de juego como de escucha
	
	var txtRetardo : FlxText;
	//var sptMarcadorRitmo : FlxSprite;
	var tweenOptionsRitmo : TweenOptions = { type: FlxTween.BACKWARD, ease: FlxEase.quartInOut };
	var tweenMarcadorRitmo : FlxTween;
	
	
	// PUCLIC METHODS	
	override public function create() {
		super.create();
		nivel = Logica.nivelInicio;// Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		feedbackVisual = feedbackVisualInicio;
		
		Reg.level = Nivel.niveles.indexOf(nivelInicio);	// Guardamos el nivel en el que estamos (La posic del array) para los botones
		
		FlxG.state.bgColor = FlxColor.OLIVE;	// Arrancamos con color "reproduciendo"
		
		// Botones del menú de juego
		btnMenuVolver = new FlxButton(10, 10, "Volver al menú", botonMenuVolverOnClick);
		botonesInterfaz.add(btnMenuVolver);
		
		btnCancelar = new FlxButton(40, 10, "Detener", botonCancelarOnClick);
		btnCancelar.x = FlxG.width - btnCancelar.width - 10;
		btnCancelar.visible = false;
		
		add(btnCancelar); // No lo tomamos como botón del grupo interfaz
		
		var mitadAncho = FlxG.width / 2;
		var alturaBotones = 10;
		
		definirRepresentacionSecuencia();
		
		btnEscuchar = new FlxButton(mitadAncho + 10, alturaBotones, "Escuchar", botonEscucharOnClick);
		botonesInterfaz.add(btnEscuchar);
		
		btnJugar = new FlxButton(mitadAncho - 10, alturaBotones, "Jugar", botonJugarOnClick);
		btnJugar.x -= btnJugar.width;
		botonesInterfaz.add(btnJugar);
		
		txtRetardo = new FlxText();
		txtRetardo.wordWrap = false;
		txtRetardo.autoSize = false;
		txtRetardo.fieldWidth = 300;
		txtRetardo.size = 30;
		txtRetardo.setPosition(mitadAncho - txtRetardo.fieldWidth / 2, alturaBotones + 10 + 25);
		txtRetardo.alignment = "center";
		add(txtRetardo);
		
		// El usuario no puede jugar de entrada. Tiene que haber escuchado la secuencia antes
		btnJugar.visible = false;
		
		add(botonesInterfaz);
	}
	
	
	// PRIVATE METHODS
	function definirRepresentacionSecuencia() {
		// Esto define el texto que muestra cómo es la secuencia (Ej: 0 000 00 )
		
		var mitadAncho = FlxG.width / 2;
		
		txtRepresentacionSecuencia = new FlxText();
		txtRepresentacionSecuencia.wordWrap = false;
		txtRepresentacionSecuencia.alignment = "center";
		txtRepresentacionSecuencia.text = nivel.secuencia.toString();
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, ",", ""); 	// Quitamos las comas
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, "0", " ");	// Ponemos espacios en los silencios
		txtRepresentacionSecuencia.text = StringTools.replace(txtRepresentacionSecuencia.text, "1", "0");	// Ponemos "círculos" en cada sonido
		txtRepresentacionSecuencia.size = 40;
		txtRepresentacionSecuencia.setPosition(mitadAncho - txtRepresentacionSecuencia.fieldWidth / 2, FlxG.height * 0.4);
		
		if (feedbackVisual) {	// Sólo mostrarlo si es requerido. Sino permanece oculto
			add(txtRepresentacionSecuencia);
		}
	}
	
	function avanceReproduccion(timer : FlxTimer) {
		
		if (timer.loopsLeft == 0) {
			botonesInterfaz.setAll("visible", true);
			btnCancelar.visible = false;
			//txtRepresentacionSecuencia.removeFormat(formatoTween);
			txtRepresentacionSecuencia.clearFormats();
		}
		if (nivel.secuencia[acumulador] == 1 && timer.loopsLeft > 0) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
			//FlxTween.color(sptMarcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, tweenOptionsRitmo);
		}
		
		acumulador += 1;
	}
	
	function avanceGrabacion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace("terminó");
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, registrarPulsacion);
			trace(nivel.secuencia);
			trace(secuenciaUsuario);
			
			var errores = 0;
			// TODO: Contabilizar el acierto
			for (i in 0...nivel.secuencia.length) {
				if (nivel.secuencia[i] != secuenciaUsuario[i]) {
					errores += 1;
				}
			}
			var resultado = 100 - (errores / nivel.secuencia.length) * 100; // Porcentaje de aciertos = 100 - porcentaje de erorres
			trace("resultado: ", resultado);
			
			btnJugar.active = true;
			btnEscuchar.visible = true;
			txtRetardo.text = "";
			
			FinNivel.resultadoInicio = resultado;	// Seteamos el static para que create() lo use para mostrarlo
			FlxG.switchState(new FinNivel());
		}
		else {
			acumulador += 1;
		}
	}
	
	function inicioRetardado(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace('inicio de juego');
			txtRetardo.text += " Go! ";
			FlxG.state.bgColor = FlxColor.CRIMSON; // Color "grabando"
			
			// Escuchamos el click para "grabar" lo que hace el usuario
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, registrarPulsacion);
			new FlxTimer(nivel.intervalo, avanceGrabacion, nivel.secuencia.length);
		}
		else {
			txtRetardo.text += " . ";
		}
	}
	
	function registrarPulsacion(e : MouseEvent) {
		// Grabamos en un array
		if (secuenciaUsuario[acumulador] == 0) {	// No permitimos que el usuario registre más de una pulsación por intervalo
			secuenciaUsuario[acumulador] += 1;
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			//tweenMarcadorRitmo = FlxTween.color(sptMarcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, tweenOptionsRitmo);
			txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
			trace("click");
		}
	}
	
	function botonMenuVolverOnClick() {
		FlxG.switchState(new MenuNiveles());
	}
	
	function botonCancelarOnClick() {
		tmrPrincipal.destroy();
		btnCancelar.visible = false;
		botonesInterfaz.setAll("visible", true);
	}
	
	function botonEscucharOnClick() {
		btnCancelar.visible = true;
		botonesInterfaz.setAll("visible", false);
		FlxG.state.bgColor = FlxColor.OLIVE;	// Color "reproduciendo"
		
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		tmrPrincipal = new FlxTimer(nivel.intervalo, avanceReproduccion, nivel.secuencia.length + 1); // Agregamos un loop extra para el resaltado del último golpe de la secuencia
	}
	
	function botonJugarOnClick() {
		FlxG.state.bgColor = FlxColor.GRAY; // Color "preparando"
		btnJugar.active = false;
		btnEscuchar.visible = false;
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		secuenciaUsuario = [for (x in 0...nivel.secuencia.length) 0];
		
		trace('inicio de retardo');
		tmrPrincipal = new FlxTimer(		// Esto es sólo para mostrar el texto 1 .. 2 .. 3 .. Go!
			0.2,	// Delay en segundos
			inicioRetardado,	// Handler
			4	// Loops
		);
	}


	
	
	
	
}