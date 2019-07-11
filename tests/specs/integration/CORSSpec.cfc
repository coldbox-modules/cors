component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    this.loadColdBox = true;
    this.unloadColdBox = false;

    function run() {
        describe( "CORS Spec", function() {
            aroundEach( function( spec ) {
                var originalSettings = duplicate( getController().getConfigSettings().modules.cors.settings );
                setup();
                spec.body();
                getController().getConfigSettings().modules.cors.settings = originalSettings;
            } );

            it( "activates the module", function() {
                expect( getController().getModuleService().isModuleRegistered( "cors" ) ).toBeTrue();
            } );

            it( "sets the CORS headers directly", function() {
                prepareMock( getRequestContext() )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.index", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin", "The 'Access-Control-Allow-Origin' should be set." );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );
            } );

            it( "sets the correct headers for an options request", function() {
                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "*" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders[ "Access-Control-Allow-Methods" ] ).toBe( "DELETE, GET, PATCH, POST, PUT, OPTIONS" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type, X-Auth-Token, Origin, Authorization" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Max-Age" );
                expect( responseHeaders[ "Access-Control-Max-Age" ] ).toBe( "86400" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Credentials" );
                expect( responseHeaders[ "Access-Control-Allow-Credentials" ] ).toBe( "true" );
            } );

            it( "sets the correct headers for an allowed method request", function() {
                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "GET" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "*" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Credentials" );
                expect( responseHeaders[ "Access-Control-Allow-Credentials" ] ).toBe( "true" );

                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Max-Age" );
            } );

            it( "can configure the allowed origins", function() {
                getController().getConfigSettings().modules.cors.settings.allowOrigins = "example.com";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );
            } );

            it( "rejects the request if the origin is incorrect", function() {
                getController().getConfigSettings().modules.cors.settings.allowOrigins = "example.com";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "foobar.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( getStatusCode( event ) ).toBe( 403 );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Origin" );
            } );

            it( "can configure the allowed methods", function() {
                getController().getConfigSettings().modules.cors.settings.allowMethods = [ "OPTIONS", "GET", "POST" ];

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders[ "Access-Control-Allow-Methods" ] ).toBe( "OPTIONS, GET, POST" );
            } );

            it( "can configure the allowed headers", function() {
                getController().getConfigSettings().modules.cors.settings.allowHeaders = [ "Content-Type" ];

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type" );
            } );

            it( "can configure if credentials are allowed", function() {
                getController().getConfigSettings().modules.cors.settings.allowCredentials = false;

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Credentials" );
                expect( responseHeaders[ "Access-Control-Allow-Credentials" ] ).toBe( "false" );
            } );

            it( "can configure the max age", function() {
                getController().getConfigSettings().modules.cors.settings.maxAge = 60;

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Max-Age" );
                expect( responseHeaders[ "Access-Control-Max-Age" ] ).toBe( "60" );
            } );

            it( "interprets * as all headers passed in as `Access-Control-Request-Headers`", function() {
                getController().getConfigSettings().modules.cors.settings.allowHeaders = "*";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Access-Control-Request-Headers", "" )
                    .$results( "Content-Type, X-Auth-Token, Origin" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                var responseHeaders = getHeaders( event );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type, X-Auth-Token, Origin" );
            } );

            it( "can be configured with a regex for events to process", function() {
                getController().getConfigSettings().modules.cors.settings.eventPattern = "Main\.doSomething$";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.index", renderResults = true );
                var responseHeaders = getHeaders( event );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Origin" );

                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomething", renderResults = true );
                var responseHeaders = getHeaders( event );
                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "*" );

                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomethingElse", renderResults = true );
                var responseHeaders = getHeaders( event );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Origin" );
            } );

            it( "can be configured with an array of regexes for events to process", function() {
                getController().getConfigSettings().modules.cors.settings.eventPattern = [
                    "Main\.doSomething$",
                    "doSomething"
                ];

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.index", renderResults = true );
                var responseHeaders = getHeaders( event );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Origin" );

                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomething", renderResults = true );
                var responseHeaders = getHeaders( event );
                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "*" );

                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomethingElse", renderResults = true );
                var responseHeaders = getHeaders( event );
                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "*" );
            } );

            it( "skips over events that are cached", function() {
                getController().getCache( "template" ).clearAllEvents();

                prepareMock( getRequestContext() )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" )
                    .$( "getEventCacheableKey", {} );
                var eventOne = execute( event = "Main.cached", renderResults = true );
                var responseHeadersOne = getHeaders( eventOne );
                expect( responseHeadersOne ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeadersOne[ "Access-Control-Allow-Origin" ] ).toBe( "*" );

                setup();
                prepareMock( getRequestContext() )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" )
                    .$( "getEventCacheableKey", {
                        "provider": "template",
                        "cacheable": true,
                        "suffix": "",
                        "cacheKey": "cbox_event-Main.cached--F05820553EEBD486F74AC25FB978E335",
                        "lastAccessTimeout": "15",
                        "timeout": "30"
                    } );
                var eventTwo = execute( event = "Main.cached", renderResults = true );
                var responseHeadersTwo = getHeaders( eventTwo );
                expect( responseHeadersTwo ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeadersTwo[ "Access-Control-Allow-Origin" ] ).toBe( "*" );
            } );
        } );
    }

    private struct function getHeaders( event ) {
        var headers = {};
        structAppend( headers, event.getValue( "cbox_headers", {} ) );
        structAppend( headers, event.getResponseHeaders() );
        return headers;
    }

    private function getStatusCode( event ) {
        if ( event.valueExists( "cbox_statusCode" ) ) {
            return event.getValue( "cbox_statusCode" );
        } else if ( isACF() ) {
            return getPageContext().getResponse().getResponse().getStatus();
        } else {
            return getPageContext().getResponse().getStatus();
        }
    }

    private function isACF() {
        return ! structKeyExists( server, "lucee" );
    }
}
