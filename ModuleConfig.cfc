component {

    this.name = "cors";
    this.author = "Eric Peterson";
    this.cfmapping = "cors";
    this.webUrl = "https://github.com/elpete/cors";

    function configure() {
        settings = {
            autoRegisterInterceptor = true,
            allowOrigins = function( event ) {
                return event.getHTTPHeader( "Origin", "*" );
            },
            allowMethods = function( event ) {
                return event.getHTTPMethod();
            },
            allowHeaders = function( event ) {
                return event.getHTTPHeader( "Access-Control-Request-Headers", "" );
            },
            maxAge = 60 * 60 * 24, // 1 day
            allowCredentials = true,
            eventPattern = ".*"
        };
    }

    function onLoad() {
        if ( settings.autoRegisterInterceptor ) {
            controller.getInterceptorService().registerInterceptor(
                interceptorName = "CORS",
                interceptorClass = "#moduleMapping#.interceptors.CORS"
            );
        }
    }

}
