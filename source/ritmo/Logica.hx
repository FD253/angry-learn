package ritmo;

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
class Logica extends FlxState
{
	// STATIC ATRIBUTES
	// Esta variable debe ser seteada con el nivel que uno quiere que se ejecute...
	//   Por supesto que antes de instanciar el ejercicio, porque es lo que usa el método create() para definir el nivel del ejercicio
	public static var nivelInicio : Nivel;	
	
	// PUBLIC ATRIBUTES
	
	
	// PRIVATE ATRIBUTES
	var nivel : Nivel;
	
	var acumulador = 0;	// Se emplea para recorrer la secuencia del ejercicio (Para grabar y escuchar)
	var secuenciaUsuario : Array<Int>; // Creamos un array para grabar lo que hace el usuario
	
	var btnCancelar : FlxButton;
	
	var botonesInterfaz = new FlxTypedGroup<FlxButton>();
	
	var btnMenuVolver : FlxButton;
	var btnEscuchar : FlxButton;
	var btnJugar : FlxButton;
	var tmrPrincipal : FlxTimer;	// Esta referencia sirve para el timer tanto de juego como de escucha
	
	var txtRetardo : FlxText;
	var sptMarcadorRitmo : FlxSprite;
	var tweenOptionsRitmo : TweenOptions = { type: FlxTween.BACKWARD, ease: FlxEase.quartInOut };
	var tweenMarcadorRitmo : FlxTween;
	
	
	// PUCLIC METHODS
	override public function create() {
		super.create();
		nivel = nivelInicio;	// Pasamos a la instancia el nivel que antes se debe haber definido en la clase
		
		// Botones del menú de juego
		btnMenuVolver = new FlxButton(10, 10, "Volver al menú", botonMenuVolverOnClick);
		botonesInterfaz.add(btnMenuVolver);
		
		btnCancelar = new FlxButton(40, 10, "Detener", botonCancelarOnClick);
		btnCancelar.x = FlxG.stage.stageWidth - btnCancelar.width - 10;
		btnCancelar.visible = false;
		//botonesInterfaz.add(botonCancelar);
		add(btnCancelar); // No lo tomamos como botón del grupo interfaz
		
		var mitadAncho = FlxG.stage.stageWidth / 2;
		var alturaBotones = 10; //FlxG.stage.stageHeight * 0.2;
		
		sptMarcadorRitmo = new FlxSprite();
		sptMarcadorRitmo.makeGraphic(150, 150, FlxColor.WHITE);
		sptMarcadorRitmo.setPosition(mitadAncho - sptMarcadorRitmo.width / 2, FlxG.stage.stageHeight * 0.4);
		add(sptMarcadorRitmo);
		
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
	function botonMenuVolverOnClick() {
		FlxG.switchState(new MenuNiveles());
	}
	
	function botonCancelarOnClick() {
		tmrPrincipal.destroy();
		btnCancelar.visible = false;
		botonesInterfaz.setAll("visible", true);
	}
	
	function avanceReproduccion(timer : FlxTimer) {
		add(sptMarcadorRitmo);
		
		if (timer.loopsLeft == 0) {
			botonesInterfaz.setAll("visible", true);
			btnCancelar.visible = false;
		}
		if (nivel.secuencia[acumulador] == 1) {
			FlxG.sound.play(AssetPaths.ritmo_bell__wav);
			FlxTween.color(sptMarcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, tweenOptionsRitmo);
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
	
	function registrarPulsacion(e : MouseEvent) {
		// Grabamos en un array
		secuenciaUsuario[acumulador] += 1;
		FlxG.sound.play(AssetPaths.ritmo_bell__wav);
		tweenMarcadorRitmo = FlxTween.color(sptMarcadorRitmo, 0.4, FlxColor.WHITE, FlxColor.WHITE, 1, 0, tweenOptionsRitmo);
		trace("click");
	}
	
	function botonEscucharOnClick() {
		btnCancelar.visible = true;
		botonesInterfaz.setAll("visible", false);
		
		acumulador = 0;
		
		// Un timer de duración de intervalo (slot) definida en Niveles, que va a ir reproduciendo si hace falta
		tmrPrincipal = new FlxTimer(nivel.intervalo, avanceReproduccion, nivel.secuencia.length);
	}
	
	function inicioRetardado(timer : FlxTimer) {
		if (timer.loopsLeft == 0) {
			trace('inicio de juego');
			txtRetardo.text += " Go! ";
			// Escuchamos el click para "grabar" lo que hace el usuario
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, registrarPulsacion);
			new FlxTimer(nivel.intervalo, avanceGrabacion, nivel.secuencia.length);
		}
		else {
			txtRetardo.text += " . ";
		}
	}
	
	function botonJugarOnClick() {
		btnJugar.active = false;
		btnEscuchar.visible = false;
		acumulador = 0;
		secuenciaUsuario = [for (x in 0...nivel.secuencia.length) 0];
		
		trace('inicio de retardo');
		tmrPrincipal = new FlxTimer(
			0.2,	// Delay en segundos
			inicioRetardado,	// Handler
			4	// Loops
		);
	}


	
	
	
	
}