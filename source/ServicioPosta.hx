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
	//http://demo-api-juegos.herokuapp.com/api/v1/?format=json&api_username=croldan&api_key=33038804fc87018da64435810462096e99f2439e
	//http://demo-api-juegos.herokuapp.com/api/v1/juego/schema/?format=json&api_username=croldan&api_key=33038804fc87018da64435810462096e99f2439e
	//http://demo-api-juegos.herokuapp.com/api/v1/juego/?format=json&api_username=croldan&api_key=33038804fc87018da64435810462096e99f2439e
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
	private static function get_instancia():ServicioPosta {
		if (null == instancia) {
			instancia = new ServicioPosta();
		}
		return instancia;
	}
	
	public function obtenerPuntajes(usuario:String, callback : Event -> Void) :Void {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback );
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		var ruta : String = ruta_base + ruta_user + Reg.obtenerIdResource(usuario)+'/' + ruta_puntajes + '?format='+ServicioPosta.formato + '&api_key=' + Reg.apiKey + '&api_username=' + Reg.usernameActual ;
		trace(ruta);
		
		
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		trace(request);
		request.method = URLRequestMethod.GET;
		//request.data = parametros;
		
		cargador.load(request);
	}
	
	
	public function obtenerMaximosNiveles(usuario:String, callback : Event -> Void) :Void {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback );
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		var ruta : String = ruta_base + ruta_user + Reg.obtenerIdResource(usuario) + '/levels/' + '?format='+ServicioPosta.formato + '&api_key=' + Reg.apiKey + '&api_username=' + Reg.usernameActual ;
		trace(ruta);
		
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		trace(request);
		request.method = URLRequestMethod.GET;
		
		cargador.load(request);
	}
	
	
	public function loguearUsuario(usuario : String, clave : String, callback : Event -> Void) {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback);
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, callback);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
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
		trace(request.data);
		trace(request.contentType);
		cargador.load(request);
	}
	
	
	public function obtenerUsuarios(callback : Event -> Void, onErrorHandler : Event -> Void) : Void {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, callback);
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		var ruta : String = ruta_base + ruta_user + '?format='+ServicioPosta.formato + '&api_key=' + Reg.apiKey + '&api_username=' + Reg.usernameActual ;
		trace(ruta);
		
		
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		trace(request);
		request.method = URLRequestMethod.GET;
		//request.data = parametros;
		
		cargador.load(request);
	}
	
	static var timeoutTimer : FlxTimer;
	
	public function postPlay(puntaje : Float, appId : String, levelId : String, usedTime : Float):Void {
		trace(Reg.usernameActual, Reg.nombreUsuarioActual, Reg.apiKey, Reg.usuarioActual);
		if (Reg.modoDeJuego == Reg.REGISTRADO) {
			var cargador:URLLoader = new URLLoader();
			cargador.addEventListener(Event.COMPLETE, function(e:Event) {
				trace("Event COMPLETE post play");
			} );
			cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			cargador.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event) {
				trace(e.target.data);
				FlxG.resetGame(); // Si el server no se pudo alcanzar guardando el juego, chau
			});
			cargador.addEventListener(Event.OPEN, openHandler);
			cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			var ruta : String = ruta_base + ruta_play; //+ '&api_key=' + ServicioPosta.api_key + '&api_username=' + ServicioPosta.api_username ;
			trace(ruta);
			var params : Dynamic = { };
			params.device_app_version = Reg.deviceAppVersion;
			params.device_id = Reg.deviceId;
			params.player = Reg.usuarioActual;
			params.play_date = Date.now().toString(); // Se jugó cuando se envió. No guardamos datos offline
			
			params.app = appId;
			params.level = levelId;
			params.used_time = Std.string(Std.int(usedTime));
			params.result = Std.string(Std.int(puntaje));
			
			//params.id = Math.ceil(Math.random() * 100);
			//params.id = 41;
			
			trace(params);
			trace(Json.stringify(params));
			
			var request:URLRequest = new URLRequest(ruta);
			request.requestHeaders.push(new URLRequestHeader("Authorization", "ApiKey " + Reg.usernameActual + ":" + Reg.apiKey));
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
			request.method = URLRequestMethod.POST;
			request.data = Json.stringify(params);
			trace(request.data);

			cargador.load(request);
		}
	}
	
	//public function parchearJuego():Void {
		//var cargador:URLLoader = new URLLoader();
		//cargador.addEventListener(Event.COMPLETE, crearJuegoCompleto);
		////cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		//cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent) { trace(this); } );
		//cargador.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		//cargador.addEventListener(Event.OPEN, openHandler);
		//cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		//cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		//var ruta:String = ruta_base + ruta_user + "41/" + "?format=" + formato + "&api_username=" + api_username + "&api_key=" + api_key;
		//trace(ruta);
		//var params:Dynamic = {};
		////params.codigo = Math.ceil(Math.random() * 100);
		//params.descripcion = "esta es la descripcion cambiada";
		////params.id = Math.ceil(Math.random() * 100);
		////params.id = 41;
		////params.nombre = "Juego asombroso nro: " + Math.ceil(Math.random() * 100);
		//
		//trace(params);
		//trace(Json.stringify(params));
		//
		//var request:URLRequest = new URLRequest(ruta);
		//request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		//request.requestHeaders.push(new URLRequestHeader("X-HTTP-Method-Override", "PATCH"));
		//request.method = URLRequestMethod.POST;
		//request.data = Json.stringify(params);
		//
		//cargador.load(request);
	//}
	
	
	//public function obtenerRutas():Void {
	//
		////el cargador se encarga de llamar al servicio
		//var cargador:URLLoader = new URLLoader();
		////escucho todos los metodos como referencia. no hace falta en todos los casos
		//cargador.addEventListener(Event.COMPLETE, obtenerUsuariosOnComplete);
		//cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		//cargador.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		//cargador.addEventListener(Event.OPEN, openHandler);
		//cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		//cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
//
		////esto sirve para get, si hay que hacer post, hardcodear en la string de la ruta :(
		//var params:URLVariables = new URLVariables();
		//params.format = ServicioPosta.formato;
		//params.api_key = ServicioPosta.api_key;
		//params.api_username = ServicioPosta.api_username;
		//
		//var request:URLRequest = new URLRequest(ServicioPosta.ruta_base);
		//request.method = URLRequestMethod.GET;
		//request.data = params;
		//
		//cargador.load(request);
		//
	//}
	
	private function securityErrorHandler(e:SecurityErrorEvent):Void {
		trace( "Servicio.securityErrorHandler > e : " + e );
	}
	
	private function progressHandler(e:ProgressEvent):Void {
		trace( "Servicio.progressHandler > e : " + e );
	}
	
	private function openHandler(e:Event):Void {
		trace( "Servicio.openHandler > e : " + e );
	}
	
	private function ioErrorHandler(e:IOErrorEvent):Void {
		trace( "Servicio.ioErrorHandler > e : " + e );
		trace( "Servicio.ioErrorHandler > e : " + e.errorID );
		trace( "Servicio.ioErrorHandler > e : " + e.text );
	}
	
	private function httpStatusHandler(e:HTTPStatusEvent):Void {
		trace(this);
		trace( "Servicio.httpStatusHandler > e : " + e.status );
	}
	
	//private function cargaRutasCompleta(e:Event):Void {
		//trace( "Servicio.cargaRutasCompleta > e : " + e );
		//trace( "Servicio.cargaRutasCompleta > e : " + e.target.data );
		//trace( "Servicio.cargaRutasCompleta > e : " + Json.parse(e.target.data) );
		//trace( "Servicio.cargaRutasCompleta > e : " + Json.parse(e.target.data).jugada );
		//
	//}
	
}