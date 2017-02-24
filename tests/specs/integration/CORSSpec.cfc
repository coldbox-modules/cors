component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "CORS Spec", function() {
            it( "activates the module", function() {
                expect( getController().getModuleService().isModuleRegistered( "cors" ) ).toBeTrue();
            } );

            it( "sets the CORS headers directly", function() {
                var event = execute( event = "Main.index", renderResults = true );
                var headerValue = getPageContext().getResponse().getHeader( "Access-Control-Allow-Origin" );
                expect( headerValue ).toBe( "*", "The 'Access-Control-Allow-Origin' should be set to '*'." );
            } );
        } );
    }
}