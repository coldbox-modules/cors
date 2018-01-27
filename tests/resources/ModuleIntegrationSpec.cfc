component extends="coldbox.system.testing.BaseTestCase" {

    function beforeAll() {
        super.beforeAll();

        getController().getModuleService()
            .registerAndActivateModule( "cors", "testingModuleRoot" );
    }

    /**
    * @beforeEach
    */
    function setupIntegrationTest() {
        setup();
    }

}
