package ;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import haxe.Json;


class ServicioPosta {
	
	public function new() {	}
	
	public static var instancia(get, null) : ServicioPosta;
	
	private inline static var ruta_api : String = "api/v1/";
	private inline static var ruta_base : String = "https://ucseapijuegos.herokuapp.com/" + ruta_api;
	private inline static var formato : String = "json";
	
	private inline static var ruta_level : String = "level/";
	private inline static var ruta_user : String = "user/";
	private inline static var ruta_play : String = "play/";
	private inline static var ruta_puntajes: String = "points/";
	private inline static var ruta_login : String = ruta_user + "login/";
	
	public static function obtenerUriUsuario(idUsuario : String) : String {
		// A partir de un id de usuario numérico (pasado como string porque así devuelve la API)
		// construimos y devolvemos la URI del recurso user
		return "/" + ruta_api + ruta_user + idUsuario + "/";
	}
	
	private static function get_instancia() : ServicioPosta {
		if (null == instancia) {
			instancia = new ServicioPosta();
		}
		return instancia;
	}
	
	public function obtenerPuntajes(usuario:String, callback : Event -> Void) {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback );
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		var ruta : String = ruta_base + ruta_user + Reg.obtenerIdResource(usuario) + '/' + ruta_puntajes + '?format='+ServicioPosta.formato + '&api_key=' + Reg.apiKey + '&api_username=' + Reg.usernameActual;
	
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		request.method = URLRequestMethod.GET;
		
		cargador.load(request);
	}
	
	
	public function obtenerMaximosNiveles(usuario:String, callback : Event -> Void) {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback );
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		var ruta : String = ruta_base + ruta_user + Reg.obtenerIdResource(usuario) + '/levels/' + '?format='+ServicioPosta.formato + '&api_key=' + Reg.apiKey + '&api_username=' + Reg.usernameActual ;
		
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		request.method = URLRequestMethod.GET;
		
		cargador.load(request);
	}
	
	
	public function loguearUsuario(usuario : String, clave : String, callback : Event -> Void) {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback);
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, callback);	// Usamos el mismo callback
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		var ruta : String = ruta_base + ruta_login + '?format=' + formato;
		trace(ruta);
		
		var params : Dynamic = { };
		params.username = usuario;
		params.password = clave;
		trace(params);
		
		var request:URLRequest = new URLRequest(ruta);
		request.method = URLRequestMethod.POST;
		request.data = Json.stringify(params);
		request.contentType = 'application/json';

		cargador.load(request);
	}
	
	
	public function obtenerUsuarios(callback : Event -> Void, onErrorHandler : Event -> Void) {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback);
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
		var ruta : String = ruta_base + ruta_user + '?format=' + ServicioPosta.formato + '&api_key=' + Reg.apiKey + '&api_username=' + Reg.usernameActual;
		
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		request.method = URLRequestMethod.GET;
		
		cargador.load(request);
	}
	
	public function postPlay(puntaje : Float, appId : String, levelId : String, usedTime : Float) {
		if (Reg.modoDeJuego == Reg.REGISTRADO) {
			var cargador:URLLoader = new URLLoader();
			cargador.addEventListener(Event.COMPLETE, function(e:Event) {
				trace("Event COMPLETE post play");
			} );
			cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			cargador.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event) {
				FlxG.resetGame(); // Si el server no se pudo alcanzar guardando la jugada, chau
			});
			cargador.addEventListener(Event.OPEN, openHandler);
			cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			var ruta : String = ruta_base + ruta_play;
			
			var params : Dynamic = { };
			params.device_app_version = Reg.deviceAppVersion;
			params.device_id = Reg.deviceId;
			params.player = Reg.usuarioActual;
			params.play_date = Date.now().toString(); // Se jugó cuando se envió.
			params.app = appId;
			params.level = levelId;
			params.used_time = Std.string(Std.int(usedTime));
			params.result = Std.string(Std.int(puntaje));
			
			var request:URLRequest = new URLRequest(ruta);
			request.requestHeaders.push(new URLRequestHeader("Authorization", "ApiKey " + Reg.usernameActual + ":" + Reg.apiKey));
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			request.method = URLRequestMethod.POST;
			request.data = Json.stringify(params);

			cargador.load(request);
		}
	}
	
	private function errorHandler(e : Event):Void {
		trace( "errorHandler > e : " + e );
	}
	
	private function progressHandler(e:ProgressEvent):Void {
		trace( "Servicio.progressHandler > e : " + e );
	}
	
	private function openHandler(e:Event):Void {
		trace( "Servicio.openHandler > e : " + e );
	}
	
	private function httpStatusHandler(e:HTTPStatusEvent):Void {
		trace( "Servicio.httpStatusHandler > e : " + e.status );
	}
	
}