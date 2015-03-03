package ritmo;

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
	var feedbackVisual : Bool = false;
	
	var enCurso : Bool = false;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia del ejercicio (Para grabar y escuchar)
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
	
	
	// PUCLIC METHODS
	override public function create() {
		super.create();
		nivel = Logica.nivelInicio;  // Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		feedbackVisual = feedbackVisualInicio;
		
		definirRepresentacionSecuencia();
		agregarInterfaz();
		definirMenuDesplegable();
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
	
	function definirMenuDesplegable() {
		menuDesplegable.add(new FlxSprite(0, 0, AssetPaths.fondo_menu_desplegable__png));
	}
	
	function agregarInterfaz() {
		var mitadAncho = FlxG.width / 2;
		var alturaBotonesSuperiores = 75;
		
		// Nombre del juego
		var nombreJuego = new FlxSprite(mitadAncho, 14, AssetPaths.nombre_juego__png);
		nombreJuego.x = nombreJuego.x - nombreJuego.width / 2;	// Centramos al medio, manteniendo la altura
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
		btnToques = new FlxButton((FlxG.width / 2), (FlxG.height / 2), '', btnToquesOnClick);
		btnToques.loadGraphic(AssetPaths.boton__png, true, 180, 184);
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
		
		add(botonesInterfaz);
	}
	
	function avanceReproduccion(timer : FlxTimer) {
		
		if (timer.loopsLeft == 0) {
			botonesInterfaz.setAll("visible", true);
			txtRepresentacionSecuencia.clearFormats();
		}
		if (nivel.secuencia[acumulador] == 1 && timer.loopsLeft > 0) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
		}
		
		acumulador += 1;
	}
	
	function avanceGrabacion(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace("terminó");
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
			
			enCurso = false;
			
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
			txtRetardo.text += " A JUGAR! ";
			
			enCurso = true;
			new FlxTimer(nivel.intervalo, avanceGrabacion, nivel.secuencia.length);
		}
		else {
			txtRetardo.text += " . ";
		}
	}
	
	function btnToquesOnClick() {
		// Grabamos en un array
		if (enCurso) {
			if (secuenciaUsuario[acumulador] == 0) {	// No permitimos que el usuario registre más de una pulsación por intervalo
				secuenciaUsuario[acumulador] += 1;
				FlxG.sound.play(AssetPaths.ritmo_bell__wav);
				txtRepresentacionSecuencia.addFormat(formatoTween, acumulador, acumulador + 1);
				trace("click");
			}
		}
		else {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		}
	}
	
	function btnEscucharOnClick() {
		botonesInterfaz.setAll("visible", false);
		
		acumulador = 0;
		formatoTween = new FlxTextFormat(FlxColor.GOLDEN);
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		tmrPrincipal = new FlxTimer(nivel.intervalo, avanceReproduccion, nivel.secuencia.length + 1); // Agregamos un loop extra para el resaltado del último golpe de la secuencia
	}
	
	function btnJugarOnClick() {
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