component extends="coldbox.system.testing.BaseTestCase" {

    function beforeAll() {
        this.loadColdBox = true;
        super.beforeAll();
        this.loadColdBox = false;

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
