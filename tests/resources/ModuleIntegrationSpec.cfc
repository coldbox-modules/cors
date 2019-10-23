component extends="coldbox.system.testing.BaseTestCase" {

    function beforeAll() {
        super.beforeAll();

        getWireBox().autowire( this );
    }

    function setup() {
        getPageContext().getResponse().reset();
        super.setup();
        getController().getModuleService()
            .registerAndActivateModule( "cors", "testingModuleRoot" );
    }

}
