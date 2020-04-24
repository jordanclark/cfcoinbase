component{
	// cfprocessingdirective( preserveCase=true );

	function init(
		required string apiKey
	,	string version= "v1"
	,	string endPoint= "https://coinbase.com/api/#arguments.version#"
	,	numeric httpTimeOut= 120
	,	boolean debug
	) {
		arguments.debug = ( arguments.debug ?: request.debug ?: false );
		structAppend( this, arguments, true );
		return this;
	}

	function debugLog(required input) {
		if ( structKeyExists( request, "log" ) && isCustomFunction( request.log ) ) {
			if ( isSimpleValue( arguments.input ) ) {
				request.log( "Coinbase: " & arguments.input );
			} else {
				request.log( arguments.input );
			}
		} else if( this.debug ) {
			var info= ( isSimpleValue( arguments.input ) ? arguments.input : serializeJson( arguments.input ) );
			cftrace(
				var= "info"
			,	category= "Coinbase"
			,	type= "information"
			);
		}
		return;
	}

	struct function balance() {
		var req = this.apiRequest( uri= "GET /account/balance" );
		if ( !req.success || !structKeyExists( req, "amount" ) ) {
			req.amount = 0;
			req.currency = "BTC";
		}
		return req;
	}

	struct function addresses() {
		var req = this.apiRequest( uri= "GET /addresses" );
		return req;
	}

	struct function receiveAddress() {
		var req = this.apiRequest( uri= "GET /account/receive_address" );
		return req;
	}

	struct function createAddress(string label= "", string callback= "") {
		var args = {};
		if ( len( arguments.label ) ) {
			args[ "address[label]" ] = arguments.label;
		}
		if ( len( arguments.callback ) ) {
			args[ "address[callback_url]" ] = arguments.callback;
		}
		var req = this.apiRequest( uri= "POST /account/generate_receive_address", argumentCollection = args );
		return req;
	}

	struct function users() {
		var req = this.apiRequest( uri= "GET /users" );
		return req;
	}

	struct function buttons(
		string type= "buy_now"
	,	required string name
	,	required string price
	,	string currency= "USD"
	,	string style= "buy_now_large"
	,	string text= "Pay with Bitcoin"
	,	string description= ""
	,	string custom= ""
	,	boolean customSecure= true
	,	string callback= ""
	,	string success= ""
	,	string cancel= ""
	,	string info= ""
	) {
		var args = {
			"button[name]" = arguments.name
		,	"button[price_string]" = arguments.price
		,	"button[price_currency_iso]" = arguments.currency
		,	"button[type]" = arguments.type
		};
		if ( len( arguments.description ) ) {
			args[ "button[description]" ] = arguments.description;
		}
		if ( len( arguments.custom ) ) {
			args[ "button[custom]" ] = arguments.custom;
			args[ "button[custom_secure]" ] = arguments.customSecure;
		}
		if ( len( arguments.callback ) ) {
			args[ "button[callback]" ] = arguments.callback;
		}
		if ( len( arguments.success ) ) {
			args[ "button[success]" ] = arguments.success;
		}
		if ( len( arguments.cancel ) ) {
			args[ "button[cancel]" ] = arguments.cancel;
		}
		if ( len( arguments.info ) ) {
			args[ "button[info]" ] = arguments.info;
		}
		var req = this.apiRequest( uri= "POST /buttons", argumentCollection = args );
		return req;
	}

	struct function iframe(
		string type= "buy_now"
	,	required string name
	,	required string price
	,	string currency= "USD"
	,	string style= "buy_now_large"
	,	string text= "Pay with Bitcoin"
	,	string description= ""
	,	string custom= ""
	,	boolean customSecure= true
	,	string callback= ""
	,	string success= ""
	,	string cancel= ""
	,	string info= ""
	,	string size= "width: 500px; height: 160px;"
	,	string css= "border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.25);"
	) {
		var args = {
			"button[name]" = arguments.name
		,	"button[price_string]" = arguments.price
		,	"button[price_currency_iso]" = arguments.currency
		,	"button[type]" = arguments.type
		};
		if ( len( arguments.style ) ) {
			args[ "button[style]" ] = arguments.style;
		}
		if ( len( arguments.text ) ) {
			args[ "button[text]" ] = arguments.text;
		}
		if ( len( arguments.description ) ) {
			args[ "button[description]" ] = arguments.description;
		}
		if ( len( arguments.custom ) ) {
			args[ "button[custom]" ] = arguments.custom;
			args[ "button[custom_secure]" ] = arguments.customSecure;
		}
		if ( len( arguments.callback ) ) {
			args[ "button[callback]" ] = arguments.callback;
		}
		if ( len( arguments.success ) ) {
			args[ "button[success]" ] = arguments.success;
		}
		if ( len( arguments.cancel ) ) {
			args[ "button[cancel]" ] = arguments.cancel;
		}
		if ( len( arguments.info ) ) {
			args[ "button[info]" ] = arguments.info;
		}
		var req = this.apiRequest( uri= "POST /buttons", argumentCollection = args );
		req.html = "";
		if ( req.success ) {
			req.html = '<iframe
				src="https://coinbase.com/inline_payments/#req.response.button.code#"
				style="#arguments.size# #arguments.css# overflow: hidden;"
				scrolling="no"
				allowtransparency="true"
				frameborder="0"></iframe>';
		}
		return req;
	}

	struct function order(required string id) {
		var req = this.apiRequest( uri= "GET /orders/#arguments.id#", argumentCollection = args );
		return req;
	}

	struct function orders(numeric page= 1) {
		var args = {
			"page" = arguments.page
		};
		var req = this.apiRequest( uri= "GET /users", argumentCollection = args );
		return req;
	}

	struct function buyBTC(required numeric amount, boolean force= false) {
		var args = {
			"qty" = arguments.amount
		,	"agree_btc_amount_varies" = arguments.force
		};
		var req = this.apiRequest( uri= "POST /buys", argumentCollection = args );
		return req;
	}

	struct function sellBTC(required numeric amount) {
		var args = {
			"qty" = arguments.amount
		};
		var req = this.apiRequest( uri= "POST /sells", argumentCollection = args );
		return req;
	}

	struct function buyRate(required numeric amount, string currency= "USD") {
		var args = {
			"qty" = arguments.amount
		};
		var req = this.apiRequest( uri= "GET /prices/buy", argumentCollection = args );
		return req;
	}

	struct function sellRate(required numeric amount, string currency= "USD") {
		var args = {
			"qty" = arguments.amount
		};
		var req = this.apiRequest( uri= "GET /prices/sell", argumentCollection = args );
		return req;
	}

	struct function spotRate(string currency= "USD") {
		var args = {
			"currency" = arguments.currency
		};
		var req = this.apiRequest( uri= "GET /prices/spot_rate", argumentCollection = args );
		return req;
	}

	struct function apiRequest(required string uri) {
		var http = 0;
		var item = "";
		var out = {
			url = this.endPoint & replace( listRest( arguments.uri, " " ), "-", "/", "all" ) & "?api_key=" & this.apiKey
		,	action = listRest( arguments.uri, " " )
		,	verb = listFirst( arguments.uri, " " )
		,	success = false
		,	error = ""
		,	status = ""
		,	statusCode = 0
		,	response = ""
		};
		var paramType = ( out.verb == "GET" ? "url" : "formfield" );
		structDelete( arguments, "uri" );
		if ( out.verb == "get" ) {
			for ( item in arguments ) {
				out.url &= ( find( "?", out.url ) ? "&" : "?" ) & item & "=" & urlEncodedFormat( arguments[ item ] );
				structDelete( arguments, item );
			}
		}
		this.debugLog( out.url );
		this.debugLog( arguments );
		cfhttp( result="http", method=out.verb, url=out.url, charset="utf-8", throwOnError=false, timeOut=this.httpTimeOut ) {
			for ( item in arguments ) {
				cfhttpparam( encoded=false, name=item, type=paramType, value=arguments[ item ] );
			}
		}
		out.response = toString( http.fileContent );
		out.headers = http.responseHeader;
		out.args = arguments;
		out.http = http;
		out.statusCode = http.responseHeader.Status_Code ?: 500;
		if ( left( out.statusCode, 1 ) == 4 || left( out.statusCode, 1 ) == 5 ) {
			out.error = "status code error: #out.statusCode#;";
		} else if ( out.response == "Connection Timeout" || out.response == "Connection Failure" ) {
			out.error = out.response;
		} else if ( left( out.statusCode, 1 ) == 2 ) {
			out.success = true;
		}
		// parse response 
		if ( out.success && len( out.response ) ) {
			try {
				out.response = deserializeJSON( out.response );
			} catch (any cfcatch) {
				out.error &= " JSON Error: " & (cfcatch.message?:"No catch message") & " " & (cfcatch.detail?:"No catch detail") & "; ";
			}
		}
		if ( len( out.error ) ) {
			out.error = trim( out.error );
			out.success = false;
		}
		this.debugLog( out.statusCode & " " & out.error );
		return out;
	}

}
