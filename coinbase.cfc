<cfcomponent displayname="Coinbase" hint="I use the Coinbase API" output="false">


<cffunction name="init" access="public" output="false" returnType="any">
	<cfargument name="apiKey" type="string" required="true">
	<cfargument name="version" type="string" required="false" default="v1">
	<cfargument name="endPoint" type="string" required="false" default="https://coinbase.com/api/#arguments.version#/">
	
	<cfif structKeyExists( request, "debug" ) AND request.debug IS true>
		<cfset arguments.debug = true>
	</cfif>
	
	<cfset arguments.httpTimeOut = 120>
	<cfset structAppend( this, arguments, true )>
	
	<cfreturn this>
</cffunction>


<cffunction name="debugTrace" output="false" returnType="VOID">
	<cfargument name="input" type="any" required="true">
	
	<cfif structKeyExists( request, "trace" ) AND isCustomFunction( request.trace )>
		<cfif isSimpleValue( arguments.input )>
			<cfset request.trace( "Coinbase: " & arguments.input )>
		<cfelse>
			<cfset request.trace( arguments.input )>
		</cfif>
	<cfelse>
		<cftrace
			type="information"
			category="Coinbase"
			text="#( isSimpleValue( arguments.input ) ? arguments.input : "" )#"
			var="#arguments.input#"
		>
	</cfif>
	
	<cfreturn>
</cffunction>


<cffunction name="balance" access="public" output="false" returnType="struct">

	<cfset var args = {
		"action" = "account/balance"
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfif NOT req.success OR NOT structKeyExists( req, "amount" )>
		<cfset req.amount = 0>
		<cfset req.currency = "BTC">
	</cfif>
	
	<cfreturn req>
</cffunction>


<cffunction name="addresses" access="public" output="false" returnType="struct">

	<cfset var args = {
		"action" = "addresses"
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="receiveAddress" access="public" output="false" returnType="struct">

	<cfset var args = {
		"action" = "account/receive_address"
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="createAddress" access="public" output="false" returnType="struct">
	<cfargument name="label" type="string" default="">
	<cfargument name="callback" type="string" default="">

	<cfset var args = {
		"action" = "account/generate_receive_address"
	,	"httpMethod" = "POST"
	}>
	<cfif len( arguments.label )>
		<cfset args[ "address[label]" ] = arguments.label>
	</cfif>
	<cfif len( arguments.callback )>
		<cfset args[ "address[callback_url]" ] = arguments.callback>
	</cfif>
	
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="users" access="public" output="false" returnType="struct">
	
	<cfset var args = {
		"action" = "users"
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="buttons" access="public" output="false" returnType="struct">
	<cfargument name="type" type="string" default="buy_now">
	<cfargument name="name" type="string" required="true">
	<cfargument name="price" type="string" required="true">
	<cfargument name="currency" type="string" default="USD">
	<cfargument name="style" type="string" default="buy_now_large">
	<cfargument name="text" type="string" default="Pay with Bitcoin">
	<cfargument name="description" type="string" default="">
	<cfargument name="custom" type="string" default="">
	<cfargument name="customSecure" type="boolean" default="true">
	<cfargument name="callback" type="string" default="">
	<cfargument name="success" type="string" default="">
	<cfargument name="cancel" type="string" default="">
	<cfargument name="info" type="string" default="">

	<cfset var args = {
		"action" = "buttons"
	,	"httpMethod" = "POST"
	,	"button[name]" = arguments.name
	,	"button[price_string]" = arguments.price
	,	"button[price_currency_iso]" = arguments.currency
	,	"button[type]" = arguments.type
	}>
	<cfif len( arguments.description )>
		<cfset args[ "button[description]" ] = arguments.description>
	</cfif>
	<cfif len( arguments.custom )>
		<cfset args[ "button[custom]" ] = arguments.custom>
		<cfset args[ "button[custom_secure]" ] = arguments.customSecure>
	</cfif>
	<cfif len( arguments.callback )>
		<cfset args[ "button[callback]" ] = arguments.callback>
	</cfif>
	<cfif len( arguments.success )>
		<cfset args[ "button[success]" ] = arguments.success>
	</cfif>
	<cfif len( arguments.cancel )>
		<cfset args[ "button[cancel]" ] = arguments.cancel>
	</cfif>
	<cfif len( arguments.info )>
		<cfset args[ "button[info]" ] = arguments.info>
	</cfif>
	<cfset var req = this.apiRequest( argumentCollection = args )>

	<cfreturn req>
</cffunction>


<cffunction name="iframe" access="public" output="false" returnType="struct">
	<cfargument name="type" type="string" default="buy_now">
	<cfargument name="name" type="string" required="true">
	<cfargument name="price" type="string" required="true">
	<cfargument name="currency" type="string" default="USD">
	<cfargument name="style" type="string" default="buy_now_large">
	<cfargument name="text" type="string" default="Pay with Bitcoin">
	<cfargument name="description" type="string" default="">
	<cfargument name="custom" type="string" default="">
	<cfargument name="customSecure" type="boolean" default="true">
	<cfargument name="callback" type="string" default="">
	<cfargument name="success" type="string" default="">
	<cfargument name="cancel" type="string" default="">
	<cfargument name="info" type="string" default="">
	<cfargument name="size" type="string" default="width: 500px; height: 160px;">
	<cfargument name="css" type="string" default="border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.25);">

	<cfset var args = {
		"action" = "buttons"
	,	"httpMethod" = "POST"
	,	"button[name]" = arguments.name
	,	"button[price_string]" = arguments.price
	,	"button[price_currency_iso]" = arguments.currency
	,	"button[type]" = arguments.type
	}>
	<cfif len( arguments.style )>
		<cfset args[ "button[style]" ] = arguments.style>
	</cfif>
	<cfif len( arguments.text )>
		<cfset args[ "button[text]" ] = arguments.text>
	</cfif>
	<cfif len( arguments.description )>
		<cfset args[ "button[description]" ] = arguments.description>
	</cfif>
	<cfif len( arguments.custom )>
		<cfset args[ "button[custom]" ] = arguments.custom>
		<cfset args[ "button[custom_secure]" ] = arguments.customSecure>
	</cfif>
	<cfif len( arguments.callback )>
		<cfset args[ "button[callback]" ] = arguments.callback>
	</cfif>
	<cfif len( arguments.success )>
		<cfset args[ "button[success]" ] = arguments.success>
	</cfif>
	<cfif len( arguments.cancel )>
		<cfset args[ "button[cancel]" ] = arguments.cancel>
	</cfif>
	<cfif len( arguments.info )>
		<cfset args[ "button[info]" ] = arguments.info>
	</cfif>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	<cfset req.html = "">

	<cfif req.success>
		<cfset req.html = '<iframe
			src="https://coinbase.com/inline_payments/#req.response.button.code#"
			style="#arguments.size# #arguments.css# overflow: hidden;"
			scrolling="no"
			allowtransparency="true"
			frameborder="0"></iframe>'>
	</cfif>
	
	<cfreturn req>
</cffunction>


<cffunction name="order" access="public" output="false" returnType="struct">
	<cfargument name="id" type="string" required="true">
	
	<cfset var args = {
		"action" = "orders/#arguments.id#"
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="orders" access="public" output="false" returnType="struct">
	<cfargument name="page" type="numeric" default="1">
	
	<cfset var args = {
		"action" = "users"
	,	"httpMethod" = "GET"
	,	"page" = arguments.page
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="buyBTC" access="public" output="false" returnType="struct">
	<cfargument name="amount" type="numeric" required="true">
	<cfargument name="force" type="boolean" default="false">
	
	<cfset var args = {
		"action" = "buys"
	,	"qty" = arguments.amount
	,	"agree_btc_amount_varies" = arguments.force
	,	"httpMethod" = "POST"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="sellBTC" access="public" output="false" returnType="struct">
	<cfargument name="amount" type="numeric" required="true">
	
	<cfset var args = {
		"action" = "sells"
	,	"qty" = arguments.amount
	,	"httpMethod" = "POST"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="buyRate" access="public" output="false" returnType="struct">
	<cfargument name="amount" type="numeric" required="true">
	<cfargument name="currency" type="string" default="USD">
	
	<cfset var args = {
		"action" = "prices/buy"
	,	"qty" = arguments.amount
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="sellRate" access="public" output="false" returnType="struct">
	<cfargument name="amount" type="numeric" required="true">
	<cfargument name="currency" type="string" default="USD">
	
	<cfset var args = {
		"action" = "prices/sell"
	,	"qty" = arguments.amount
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="spotRate" access="public" output="false" returnType="struct">
	<cfargument name="currency" type="string" default="USD">
	
	<cfset var args = {
		"action" = "prices/spot_rate"
	,	"currency" = arguments.currency
	,	"httpMethod" = "GET"
	}>
	<cfset var req = this.apiRequest( argumentCollection = args )>
	
	<cfreturn req>
</cffunction>


<cffunction name="apiRequest" output="false" returnType="struct">
	<cfargument name="action" type="string" required="true">
	<cfargument name="httpMethod" type="string" default="GET">
	<cfargument name="debug" type="boolean" default="#this.debug#">

	<cfset var http = 0>
	<cfset var item = "">
	<cfset var paramType = ( arguments.httpMethod IS "GET" ? "url" : "formfield" )>
	<cfset var out = {
		url = this.endPoint & replace( arguments.action, "-", "/", "all" ) & "?api_key=" & this.apiKey
	,	action = arguments.action
	,	method = arguments.httpMethod
	,	success = false
	,	error = ""
	,	status = ""
	,	statusCode = 0
	,	response = ""
	,	debug= arguments.debug
	}>
	
	<cfset structDelete( arguments, "action" )>
	<cfset structDelete( arguments, "httpMethod" )>
	<cfset structDelete( arguments, "debug" )>

	<cfif out.method IS "get">
		<cfloop item="item" collection="#arguments#">
			<cfset out.url &= ( find( "?", out.url ) ? "&" : "?" ) & item & "=" & urlEncodedFormat( arguments[ item ] )>
			<cfset structDelete( arguments, item )>
		</cfloop>
	</cfif>
	
	<cfset this.debugTrace( out.url )>
	
	<cfif out.debug>
		<cfset this.debugTrace( arguments )>
	</cfif>
	
	<cfhttp result="http"
		method="#out.method#"
		url="#out.url#"
		charset="utf-8"
		timeOut="#this.httpTimeOut#"
		throwOnError="false"
	>
		<cfloop item="item" collection="#arguments#">
			<cfhttpparam name="#item#" type="#paramType#" value="#arguments[ item ]#" encoded="false">
		</cfloop>
	</cfhttp>
	
	<cfset out.response = toString( http.fileContent )>
	<cfset out.headers = http.responseHeader>

	<cfif out.debug>
		<cfset out.args = arguments>
		<cfset out.http = http>
		<cfset out.httpResponse = out.response>
	</cfif>
	
	<!--- RESPONSE CODE ERRORS --->
	<cfif NOT structKeyExists( http, "responseHeader" ) OR NOT structKeyExists( http.responseHeader, "Status_Code" ) OR http.responseHeader.Status_Code IS "">
		<cfset out.statusCode = 500>
	<cfelse>
		<cfset out.statusCode = http.responseHeader.Status_Code>
	</cfif>
	
	<cfif left( out.statusCode, 1 ) IS 4 OR left( out.statusCode, 1 ) IS 5>
		<cfset out.error = "status code error: #out.statusCode#;">
	<cfelseif out.response IS "Connection Timeout" OR out.response IS "Connection Failure">
		<cfset out.error = out.response>
	<cfelseif http.responseHeader.Status_Code IS "200">
		<cfset out.success = true>
	</cfif>
	
	<!--- parse response --->
	<cfif out.success AND len( out.response )>
		<cftry>
			<cfset out.response = deserializeJSON( out.response )>
			<cfcatch>
				<cfset out.error &= " JSON Error: " & cfcatch.message & "; ">
			</cfcatch>
		</cftry>
	</cfif>
	
	<cfif len( out.error )>
		<cfset out.error = trim( out.error )>
		<cfset out.success = false>
	</cfif>
	
	<cfif out.debug>
		<cfset this.debugTrace( out )>
	</cfif>
	
	<cfreturn out>
</cffunction>

</cfcomponent>