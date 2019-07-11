component extends="coldbox.system.testing.BaseTestCase" {

    function beforeAll() {
        super.beforeAll();

        getController().getModuleService()
            .registerAndActivateModule( "cors", "testingModuleRoot" );
    }

    function setup() {
        getPageContext().getResponse().reset();
        super.setup();
        getController().getModuleService()
            .registerAndActivateModule( "cors", "testingModuleRoot" );
    }

}
