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
	
	public static var instancia(get, null) : ServicioPosta;
	//http://demo-api-juegos.herokuapp.com/api/v1/?format=json&api_username=croldan&api_key=33038804fc87018da64435810462096e99f2439e
	//http://demo-api-juegos.herokuapp.com/api/v1/juego/schema/?format=json&api_username=croldan&api_key=33038804fc87018da64435810462096e99f2439e
	//http://demo-api-juegos.herokuapp.com/api/v1/juego/?format=json&api_username=croldan&api_key=33038804fc87018da64435810462096e99f2439e
	private inline static var ruta_base : String = "https://ucseapijuegos.herokuapp.com/api/v1/";
	private inline static var formato : String = "json";
	private inline static var api_key : String = "ddbaec6ee3f8fca507320c8ae3ed7c40e01e958b";
	private inline static var api_username : String = "apiuser";
	private inline static var password : String = "UserAPI2015$";
	
	private inline static var ruta_level : String = "level/";
	private inline static var ruta_user : String = "user/";
	private inline static var ruta_play : String = "play/";
	private inline static var ruta_puntajes: String = "points/";
	
	private function new() {
		
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
		var ruta : String = ruta_base + ruta_user + Reg.obtenerIdResource(usuario)+'/' + ruta_puntajes + '?format='+ServicioPosta.formato + '&api_key=' + ServicioPosta.api_key + '&api_username=' + ServicioPosta.api_username ;
		trace(ruta);
		
		
		var request : URLRequest = new URLRequest(ruta);
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		trace(request);
		request.method = URLRequestMethod.GET;
		//request.data = parametros;
		
		cargador.load(request);
		
	}
	
	public function obtenerUsuarios(pantalla : SeleccionUsuario) : Void {
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, pantalla.mostrarUsuarios);
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		var ruta : String = ruta_base + ruta_user + '?format='+ServicioPosta.formato + '&api_key=' + ServicioPosta.api_key + '&api_username=' + ServicioPosta.api_username ;
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
		var cargador:URLLoader = new URLLoader();
		cargador.addEventListener(Event.COMPLETE, function(e:Event) {});
		cargador.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
		cargador.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event) {
			FlxG.resetGame(); // Si el server no se pudo alcanzar guardando el juego, chau
		});//ioErrorHandler);
		cargador.addEventListener(Event.OPEN, openHandler);
		cargador.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		cargador.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		var ruta : String = ruta_base + ruta_play ; //+ '&api_key=' + ServicioPosta.api_key + '&api_username=' + ServicioPosta.api_username ;
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
        request.requestHeaders.push(new URLRequestHeader("Authorization", "ApiKey " + api_username + ":" + api_key));
		request.requestHeaders.push(new URLRequestHeader("Content-Type", "application/json"));
		request.method = URLRequestMethod.POST;
		request.data = Json.stringify(params);
		trace(request.data);

		cargador.load(request);
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