component {
    
    this.name = "cors";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cors";

    function configure() {}

    function preProcess( event, interceptData, buffer, rc, prc ) {
        event.setHTTPHeader( name = "Access-Control-Allow-Origin", value = "*" );
        event.setHTTPHeader( name = "Access-Control-Allow-Methods", value = "POST,GET,OPTIONS,PUT,PATCH,DELETE" );
		event.setHTTPHeader( name = "Access-Control-Allow-Headers", value = "X-Requested-With, Content-Type,x-api-token" );
    }

}
