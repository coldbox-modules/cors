component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {

    property name="hyper" inject="HyperBuilder@hyper";

    this.loadColdBox = true;
    this.unloadColdBox = false;

    function beforeAll() {
        super.beforeAll();
        hyper.defaults.setBaseUrl( "http://#CGI.http_host#/tests/resources/app/index.cfm" );
    }

    function run() {
        describe( "CORS Spec", function() {
            beforeEach( function() {
                setup();
            } );

            it( "activates the module", function() {
                expect( getController().getModuleService().isModuleRegistered( "cors" ) ).toBeTrue();
            } );

            it( "sets the CORS headers directly", function() {
                hyper.get( "/?fwreinit=true" );

                var res = hyper.withHeaders( {
                    "Origin": "example.com",
                    "Access-Control-Request-Method": "GET",
                    "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                } ).get( "/main/index" );

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin", "The 'Access-Control-Allow-Origin' should be set." );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "example.com", "The 'Access-Control-Allow-Origin' should be set to 'example.com'." );
            } );

            it( "sets the correct headers for an options request", function() {
                hyper.get( "/?fwreinit=true" );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders[ "Access-Control-Allow-Methods" ] ).toBe( "GET" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type, X-Auth-Token, Origin, Authorization" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Max-Age" );
                expect( responseHeaders[ "Access-Control-Max-Age" ] ).toBe( "86400" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Credentials" );
                expect( responseHeaders[ "Access-Control-Allow-Credentials" ] ).toBe( "true" );
            } );

            it( "sets the correct headers for an allowed method request", function() {
                hyper.get( "/?fwreinit=true" );

                var res = hyper.withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .get( "/" );

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Credentials" );
                expect( responseHeaders[ "Access-Control-Allow-Credentials" ] ).toBe( "true" );

                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders ).notToHaveKey( "Access-Control-Max-Age" );
            } );

            it( "can configure the allowed origins", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "single_origin_string"
                } );

                var resOne = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeadersOne = resOne.getHeaders();

                expect( responseHeadersOne ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeadersOne[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                var resTwo = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "exampleTwo.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeadersTwo = resTwo.getHeaders();

                expect( resTwo.getStatusCode() ).toBe( 403 );
                expect( responseHeadersTwo ).notToHaveKey( "Access-Control-Allow-Origin" );
            } );

            it( "can configure for multiple allowed origins", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "multiple_origin_string"
                } );

                var resOne = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeadersOne = resOne.getHeaders();

                expect( responseHeadersOne ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeadersOne[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                var resTwo = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "exampleTwo.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeadersTwo = resTwo.getHeaders();

                expect( resTwo.getStatusCode() ).toBe( 403 );
                expect( responseHeadersTwo ).notToHaveKey( "Access-Control-Allow-Origin" );
            } );

            it( "can accept a function for the allowed origins", function() {
                hyper.get( "/?fwreinit=true" );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "other.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeaders[ "Access-Control-Allow-Origin" ] ).toBe( "other.com" );
            } );

            it( "can configure the allowed methods", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "allow_methods_array"
                } );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders[ "Access-Control-Allow-Methods" ] ).toBe( "GET, POST" );
            } );

            it( "can configure the allowed methods with a closure", function() {
                hyper.get( "/?fwreinit=true" );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "PATCH",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Methods" );
                expect( responseHeaders[ "Access-Control-Allow-Methods" ] ).toBe( "PATCH" );
            } );

            it( "can configure the allowed headers", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "explicit_allow_headers"
                } );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type" );
            } );

            it( "can configure the allowed headers with a closure", function() {
                hyper.get( "/?fwreinit=true" );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type, X-Auth-Token, Origin, Authorization" );
            } );

            it( "can configure if credentials are allowed", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "disallow_credentials"
                } );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Credentials" );
                expect( responseHeaders[ "Access-Control-Allow-Credentials" ] ).toBe( "false" );
            } );

            it( "can configure the max age", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "custom_max_age"
                } );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Max-Age" );
                expect( responseHeaders[ "Access-Control-Max-Age" ] ).toBe( "60" );
            } );

            it( "interprets * as all headers passed in as `Access-Control-Request-Headers`", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "wildcard_allow_headers"
                } );

                var res = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/" )
                    .send();

                var responseHeaders = res.getHeaders();

                expect( responseHeaders ).toHaveKey( "Access-Control-Allow-Headers" );
                expect( responseHeaders[ "Access-Control-Allow-Headers" ] ).toBe( "Content-Type, X-Auth-Token, Origin, Authorization" );
            } );

            it( "can be configured with a regex for events to process", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "single_event_pattern"
                } );

                var resOne = hyper.setMethod( "OPTIONS" )
                    .withoutRedirecting()
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/main/index" )
                    .send();

                expect( resOne.getHeaders() ).notToHaveKey( "Access-Control-Allow-Origin" );

                var resTwo = hyper.setMethod( "OPTIONS" )
                    .withoutRedirecting()
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/main/doSomething" )
                    .send();

                expect( resTwo.getHeaders() ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( resTwo.getHeaders()[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                var resThree = hyper.setMethod( "OPTIONS" )
                    .withoutRedirecting()
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/main/doSomethingElse" )
                    .send();

                expect( resThree.getHeaders() ).notToHaveKey( "Access-Control-Allow-Origin" );
            } );

            it( "can be configured with an array of regexes for events to process", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "multiple_event_patterns"
                } );

                var resOne = hyper.setMethod( "OPTIONS" )
                    .withoutRedirecting()
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/main/index" )
                    .send();

                expect( resOne.getHeaders() ).notToHaveKey( "Access-Control-Allow-Origin" );

                var resTwo = hyper.setMethod( "OPTIONS" )
                    .withoutRedirecting()
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/main/doSomething" )
                    .send();

                expect( resTwo.getHeaders() ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( resTwo.getHeaders()[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                var resThree = hyper.setMethod( "OPTIONS" )
                    .withoutRedirecting()
                    .withHeaders( {
                        "Origin": "example.com",
                        "Access-Control-Request-Method": "GET",
                        "Access-Control-Request-Headers": "Content-Type, X-Auth-Token, Origin, Authorization"
                    } )
                    .setUrl( "/main/doSomethingElse" )
                    .send();

                expect( resThree.getHeaders() ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( resThree.getHeaders()[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );
            });

            xit( "skips over events that are cached", function() {
                hyper.get( "/?fwreinit=true" );

                sleep( 2000 );

                var resOne = hyper.withHeaders( {
                    "Origin": "example.com"
                } ).get( "/main/cached" );

                expect( resOne.isSuccess() ).toBeTrue( "Response should be a successful status code. Got #resOne.getStatusCode()#" );
                var responseHeadersOne = resOne.getHeaders();
                expect( responseHeadersOne ).notToHaveKey( "x-coldbox-cache-response" );
                expect( responseHeadersOne ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeadersOne[ "Access-Control-Allow-Origin" ] ).toBe( "example.com" );

                var resTwo = hyper.withHeaders( {
                    "Origin": "exampleTwo.com"
                } ).get( "/main/cached" );

                expect( resTwo.isSuccess() ).toBeTrue( "Response should be a successful status code. Got #resTwo.getStatusCode()#" );
                var responseHeadersTwo = resTwo.getHeaders();
                expect( responseHeadersTwo ).toHaveKey( "x-coldbox-cache-response" );
                expect( responseHeadersTwo[ "x-coldbox-cache-response" ] ).toBeTrue( "Response should have been event cached." );
                expect( responseHeadersTwo ).toHaveKey( "Access-Control-Allow-Origin" );
                expect( responseHeadersTwo[ "Access-Control-Allow-Origin" ] ).toBe( "exampleTwo.com" );
            } );


            it( "can be configured to check if preflight should return with a custom closure", function() {
                hyper.get( "/", {
                    "fwreinit": "true",
                    // testcase configures the module as needed for the test
                    "testcase": "preflight_return_closure"
                } );

                var resOne = hyper.setMethod( "OPTIONS" )
                    .withHeaders( {
                        "Origin": "example.com" ,
                        "Access-Control-Request-Method" : 'POST',
                        "Test-header" : 'test-value'})
                    .setUrl( "/main/doSomething" )
                    .send();

                var data = resOne.getData();
                var data = left(data, 12); 
                expect( data ).toBe( "Preflight OK" );
            });

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
