component {

    this.name = "cors";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cors";

    function configure() {
        settings = {
            allowOrigins = function( event ) {
                return event.getHTTPHeader( "Origin", "*" );
            },
            allowMethods = [ "DELETE", "GET", "PATCH", "POST", "PUT", "OPTIONS" ],
            allowHeaders = [ "Content-Type", "X-Auth-Token", "Origin", "Authorization" ],
            maxAge = 60 * 60 * 24, // 1 day
            allowCredentials = true,
            eventPattern = ".*"
        };

        interceptors = [
            { class = "#moduleMapping#.interceptors.CORS" }
        ];
    }

}
