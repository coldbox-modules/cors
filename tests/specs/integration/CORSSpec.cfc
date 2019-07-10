component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    this.loadColdBox = false;
    this.unloadColdBox = false;

    function run() {
        describe( "CORS Spec", function() {
            aroundEach( function( spec ) {
                var originalSettings = duplicate( getController().getConfigSettings().modules.cors.settings );
                getPageContext().getResponse().reset();
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

                var headerValue = getHeader( "Access-Control-Allow-Origin", event );
                expect( headerValue ).toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );
            } );

            it( "sets the correct headers for an options request", function() {
                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", event ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );
                expect( getHeader( "Access-Control-Allow-Methods", event ) )
                    .toBe(
                        "DELETE, GET, PATCH, POST, PUT, OPTIONS",
                        "The 'Access-Control-Allow-Methods' should be set to 'DELETE, GET, PATCH, POST, PUT, OPTIONS'."
                    );
                expect( getHeader( "Access-Control-Allow-Headers", event ) )
                    .toBe(
                        "Content-Type, X-Auth-Token, Origin, Authorization",
                        "The 'Access-Control-Allow-Headers' should be 'Content-Type, X-Auth-Token, Origin, Authorization'."
                    );
                expect( getHeader( "Access-Control-Max-Age", event ) )
                    .toBe( "86400", "The 'Access-Control-Max-Age' should be '86400'." );
                expect( getHeader( "Access-Control-Allow-Credentials", event ) )
                    .toBe( "true", "The 'Access-Control-Allow-Credentials' should be 'true'." );
            } );

            it( "sets the correct headers for an allowed method request", function() {
                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "GET" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", event ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );
                expect( getHeader( "Access-Control-Allow-Credentials", event) )
                    .toBe( "true", "The 'Access-Control-Allow-Credentials' should be 'true'." );

                expect( getHeaderNames( event ) )
                    .notToInclude(
                        "Access-Control-Allow-Methods",
                        "'Access-Control-Allow-Methods' should not be in the headers"
                    );
                expect( getHeaderNames( event ) )
                    .notToInclude(
                        "Access-Control-Allow-Headers",
                        "'Access-Control-Allow-Headers' should not be in the headers"
                    );
                expect( getHeaderNames( event ) )
                    .notToInclude(
                        "Access-Control-Max-Age",
                        "'Access-Control-Max-Age' should not be in the headers"
                    );
            } );

            it( "can configure the allowed origins", function() {
                getController().getConfigSettings().modules.cors.settings.allowOrigins = "example.com";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", event ) )
                    .toBe( "example.com", "The 'Access-Control-Allow-Origin' should be set to 'example.com'." );
            } );

            it( "rejects the request if the origin is incorrect", function() {
                getController().getConfigSettings().modules.cors.settings.allowOrigins = "example.com";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "foobar.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getStatusCode( event ) ).toBe( 403 );
                expect( getHeaderNames( event ) )
                    .notToInclude(
                        "Access-Control-Allow-Origin",
                        "'Access-Control-Allow-Origin' should not be in the headers"
                    );
            } );

            it( "can configure the allowed methods", function() {
                getController().getConfigSettings().modules.cors.settings.allowMethods = [ "OPTIONS", "GET", "POST" ];

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Methods", event ) )
                    .toBe( "OPTIONS, GET, POST", "The 'Access-Control-Allow-Methods' should be set to 'OPTIONS, GET, POST'." );
            } );

            it( "can configure the allowed headers", function() {
                getController().getConfigSettings().modules.cors.settings.allowHeaders = [ "Content-Type" ];

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Headers", event ) )
                    .toBe( "Content-Type", "The 'Access-Control-Allow-Headers' should be set to 'Content-Type'." );
            } );

            it( "can configure if credentials are allowed", function() {
                getController().getConfigSettings().modules.cors.settings.allowCredentials = false;

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Credentials", event ) )
                    .toBe( "false", "The 'Access-Control-Allow-Credentials' should be set to 'false'." );
            } );

            it( "can configure the max age", function() {
                getController().getConfigSettings().modules.cors.settings.maxAge = 60;

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( route = "/", renderResults = true );

                expect( getHeader( "Access-Control-Max-Age", event ) )
                    .toBe( "60", "The 'Access-Control-Max-Age' should be set to '60'." );
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

                expect( getHeader( "Access-Control-Allow-Headers", event ) )
                    .toBe( "Content-Type, X-Auth-Token, Origin", "The 'Access-Control-Allow-Headers' should be set to 'Content-Type, X-Auth-Token, Origin'." );
            } );

            it( "can be configured with a regex for routes to process", function() {
                getController().getConfigSettings().modules.cors.settings.eventPattern = "Main\.doSomething$";

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.index", renderResults = true );

                expect( getHeaderNames( event ) )
                    .notToInclude( "Access-Control-Allow-Origin", "The 'Access-Control-Allow-Origin' should not be set." );

                getPageContext().getResponse().reset();
                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomething", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", event ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );

                getPageContext().getResponse().reset();
                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomethingElse", renderResults = true );

                expect( getHeaderNames( event ) )
                    .notToInclude( "Access-Control-Allow-Origin", "The 'Access-Control-Allow-Origin' should not be set." );
            } );

            it( "can be configured with a regex for routes to process", function() {
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

                expect( getHeaderNames( event ) )
                    .notToInclude( "Access-Control-Allow-Origin", "The 'Access-Control-Allow-Origin' should not be set." );

                getPageContext().getResponse().reset();
                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomething", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", event ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );

                getPageContext().getResponse().reset();
                setup();

                prepareMock( getRequestContext() )
                    .$( "getHTTPMethod", "OPTIONS" )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" );
                var event = execute( event = "Main.doSomethingElse", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", event ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );
            } );

            it( "skips over events that are cached", function() {
                getController().getCache( "template" ).clearAllEvents();

                prepareMock( getRequestContext() )
                    .$( "getHTTPHeader" )
                    .$args( "Origin", "" )
                    .$results( "example.com" )
                    .$( "getEventCacheableKey", {} );
                var eventOne = execute( event = "Main.cached", renderResults = true );

                expect( getHeader( "Access-Control-Allow-Origin", eventOne ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );

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

                expect( getHeader( "Access-Control-Allow-Origin", eventTwo ) )
                    .toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );


                // var cachedRoute = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/tests/resources/app/index.cfm/main/cached";
                // // execute twice to ensure it is cached
                // var resultOne = "";
                // cfhttp( url = cachedRoute, result = "resultOne" ) {
                //     cfhttpparam( type = "header", name = "Origin", value = "example.com" );
                // }
                // expect( resultOne.responseheader ).notToHaveKey( "x-coldbox-cache-response" );
                // expect( resultOne.responseheader ).toHaveKey( "Access-Control-Allow-Origin" );

                // var resultTwo = "";
                // cfhttp( url = cachedRoute, result = "resultTwo" ) {
                //     cfhttpparam( type = "header", name = "Origin", value = "example.com" );
                // }
                // expect( resultOne.responseheader ).toHaveKey( "x-coldbox-cache-response" );
                // expect( resultTwo.responseheader ).toHaveKey( "Access-Control-Allow-Origin" );
                // expect( resultTwo.responseheader[ "Access-Control-Allow-Origin" ] )
                //     .notToBeArray( "Access-Control-Allow-Origin should be a single value. Recieved: #serializeJSON( resultTwo.responseheader[ "Access-Control-Allow-Origin" ] )#" );
            } );
        } );
    }

    private function getHeader( name ) {
        if ( isACF() ) {
            return getPageContext().getResponse().getResponse().getHeader( name );
        }
        else {
            return getPageContext().getResponse().getHeader( name );
        }
    }

    private function getHeaderNames() {
        if ( isACF() ) {
            return getPageContext().getResponse().getResponse().getHeaderNames().toArray();
        }
        else {
            return getPageContext().getResponse().getHeaderNames().toArray();
        }
    }

    private function getStatusCode() {
        if ( isACF() ) {
            return getPageContext().getResponse().getResponse().getStatus();
        }
        else {
            return getPageContext().getResponse().getStatus();
        }
    }

    private function isACF() {
        return ! structKeyExists( server, "lucee" );
    }
}
