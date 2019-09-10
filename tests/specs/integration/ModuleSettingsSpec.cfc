component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {

    function run() {
        describe( "module settings", function() {
            it( "registers the interceptor automatically by default", function() {
                getController().getModuleService()
                    .registerAndActivateModule( "cors", "testingModuleRoot" );
                expect( function() {
                    getController().getInterceptorService().getInterceptor( "CORS" );
                } ).notToThrow();
            } );

            it( "can prevent the interceptor from being added automatically", function() {
                getController().getInterceptorService().unregister( "CORS" );
                getWireBox().getBinder().unMap( "interceptor-CORS" );
                getController().getConfigSettings().moduleSettings.cors.autoRegisterInterceptor = false;
                getController().getModuleService()
                    .registerAndActivateModule( "cors", "testingModuleRoot" );
                expect( function() {
                    getController().getInterceptorService().getInterceptor( "CORS" );
                } ).toThrow( "Injector.InstanceNotFoundException" );
            } );
        } );
  }

}
