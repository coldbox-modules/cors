component{

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "Your app name here",
			eventName 				= "event",

			//Development Settings
			reinitPassword			= "",
			handlersIndexAutoReload = true,

			//Implicit Events
			defaultEvent			= "",
			requestStartHandler		= "Main.onRequestStart",
			requestEndHandler		= "",
			applicationStartHandler = "Main.onAppInit",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "",

			//Extension Points
			applicationHelper 			= "includes/helpers/ApplicationHelper.cfm",
			viewsHelper					= "",
			modulesExternalLocation		= [ "modules_app" ],
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",
			controllerDecorator			= "",

			//Error/Exception Handling
			invalidHTTPMethodHandler = "",
			exceptionHandler		= "main.onException",
			onInvalidEvent			= "",
			customErrorTemplate		= "",

			//Application Aspects
			handlerCaching 			= false,
			eventCaching			= true,
			viewCaching				= false
		};

		// custom settings
		settings = {

        };

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			development = "localhost,^127\.0\.0\.1"
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root = { levelmax="DEBUG", appenders="*" },
			// Implicit Level Categories
            info = [ "coldbox.system" ]
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [];

        param url.testcase = "";
        switch( url.testcase ) {
            case "single_origin_string":
                moduleSettings = {
                    "cors" = {
                        "allowOrigins" = "example.com"
                    }
                };
                break;

            case "multiple_origin_string":
                moduleSettings = {
                    "cors" = {
                        "allowOrigins" = "example.net,example.com"
                    }
                };
                break;

            case "allow_methods_array":
                moduleSettings = {
                    "cors" = {
                        "allowMethods" = [ "GET", "POST" ]
                    }
                };
                break;

            case "explicit_allow_headers":
                moduleSettings = {
                    "cors" = {
                        "allowHeaders" = [ "Content-Type" ]
                    }
                };
                break;

            case "disallow_credentials":
                moduleSettings = {
                    "cors" = {
                        "allowCredentials" = false
                    }
                };
                break;

            case "custom_max_age":
                moduleSettings = {
                    "cors" = {
                        "maxAge" = 60
                    }
                };
                break;

            case "wildcard_allow_headers":
                moduleSettings = {
                    "cors" = {
                        "allowHeaders" = "*"
                    }
                };
                break;

            case "single_event_pattern":
                moduleSettings = {
                    "cors" = {
                        "eventPattern" = "main\.doSomething$"
                    }
                };
                break;

            case "multiple_event_patterns":
                moduleSettings = {
                    "cors" = {
                        "eventPattern" = [
                            "main\.doSomething$",
                            "doSomething"
                        ]
                    }
                };
                break;

            case "preflight_return_closure":
            	moduleSettings = {
            		"cors" = {
            			"shouldReturnPreflight" = function(event){
            				return event.getHTTPMethod( ) eq 'OPTIONS'
		                    AND event.getHTTPHeader('Origin', '') eq 'example.com'
		                    AND event.getHTTPHeader('Access-Control-Request-Method', '') neq ''
		                    AND event.getHTTPHeader('Test-header', '') eq 'test-value';
            			}
            		}
            	};
            	break;
        }

		/*
		// module setting overrides
		moduleSettings = {
			moduleName = {
				settingName = "overrideValue"
			}
		};

		// flash scope configuration
		flash = {
			scope = "session,client,cluster,ColdboxCache,or full path",
			properties = {}, // constructor properties for the flash scope implementation
			inflateToRC = true, // automatically inflate flash data into the RC scope
			inflateToPRC = false, // automatically inflate flash data into the PRC scope
			autoPurge = true, // automatically purge flash data for you
			autoSave = true // automatically save flash scopes at end of a request and on relocations.
		};

		//Register Layouts
		layouts = [
			{ name = "login",
		 	  file = "Layout.tester.cfm",
			  views = "vwLogin,test",
			  folders = "tags,pdf/single"
			}
		];

		//Conventions
		conventions = {
			handlersLocation = "handlers",
			viewsLocation 	 = "views",
			layoutsLocation  = "layouts",
			modelsLocation 	 = "models",
			eventAction 	 = "index"
		};

		//Datasources
		datasources = {
			mysite   = {name="mySite", dbType="mysql", username="root", password="pass"},
			blog_dsn = {name="myBlog", dbType="oracle", username="root", password="pass"}
		};
		*/

	}

	/**
	* Development environment
	*/
	function development(){
		coldbox.customErrorTemplate = "/coldbox/system/includes/BugReport.cfm";
    }

	function afterAspectsLoad() {
		variables.controller.getModuleService().registerAndActivateModule( "cors", "testingModuleRoot" );
	}

}
