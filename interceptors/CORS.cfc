component {

    property name="wirebox" inject="wirebox";

    function preProcess( event, interceptData, buffer, rc, prc ) {
        if ( ! isCORSRequest( event ) ) {
            return;
        }

        if ( isCachedEvent( event ) ) {
            return;
        }

        var settings = wirebox.getInstance( dsl = "coldbox:moduleSettings:cors" );

        if ( ! shouldProcessEvent( event, settings ) ) {
            return;
        }

        if ( ! isAllowed( event, settings ) ) {
            event.noExecution();
            event.setHTTPHeader( 403, "Forbidden (CORS)" );
            event.renderData( type = "plain", data = "Forbidden (CORS)", statusCode = 403 );
            return;
        }

        if ( event.getHTTPMethod() == "OPTIONS" ) {
            var allowedOrigins = settings.allowOrigins;
            if ( ! isSimpleValue( settings.allowOrigins ) ) {
                allowedOrigins = arrayToList( settings.allowOrigins, ", " );
            }
            event.setHTTPHeader( name = "Access-Control-Allow-Origin", value = allowedOrigins );
            event.setHTTPHeader( name = "Access-Control-Allow-Credentials", value = toString( settings.allowCredentials ) );

            var allowedHeaders = "";
            if ( isSimpleValue( settings.allowHeaders ) ) {
                allowedHeaders = settings.allowHeaders == "*" ?
                    event.getHTTPHeader( "Access-Control-Request-Headers", "" ) :
                    settings.allowHeaders;
            }
            else {
                allowedHeaders = arrayToList( settings.allowHeaders, ", " );
            }

            event.setHTTPHeader( name = "Access-Control-Allow-Headers", value = allowedHeaders );
            event.setHTTPHeader( name = "Access-Control-Allow-Methods", value = arrayToList( settings.allowMethods, ", " ) );
            event.setHTTPHeader( name = "Access-Control-Max-Age", value = settings.maxAge );

            if ( event.isInvalidHTTPMethod() ) {
                event.noExecution();
                event.renderData( "plain", "Preflight OK" );
                return;
            }
        }
    }

    function postProcess( event, interceptData, buffer, rc, prc ) {
        if ( ! isCORSRequest( event ) ) {
            return;
        }

        var settings = wirebox.getInstance( dsl = "coldbox:moduleSettings:cors" );

        if ( ! shouldProcessEvent( event, settings ) ) {
            return;
        }

        if ( ! isAllowed( event, settings ) ) {
            event.noExecution();
            event.setHTTPHeader( 403, "Forbidden (CORS)" );
            event.renderData( type = "plain", data = "Forbidden (CORS)", statusCode = 403 );
            return;
        }

        var currentHeaders = event.getResponseHeaders();

        if ( ! structKeyExists( currentHeaders, "Access-Control-Allow-Origin" ) ) {
            var allowedOrigins = settings.allowOrigins;
            if ( ! isSimpleValue( settings.allowOrigins ) ) {
                allowedOrigins = arrayToList( settings.allowOrigins, ", " );
            }
            event.setHTTPHeader( name = "Access-Control-Allow-Origin", value = allowedOrigins );
        }

        if ( ! structKeyExists( currentHeaders, "Access-Control-Allow-Credentials" ) ) {
            event.setHTTPHeader( name = "Access-Control-Allow-Credentials", value = toString( settings.allowCredentials ) );
        }
    }

    private function isCORSRequest( event ) {
        if ( event.getHTTPHeader( "Origin", "" ) == "" ) {
            return false;
        }
        var schemeAndHost = event.isSSL() ? "https://" : "http://" & CGI.HTTP_HOST;
        return event.getHTTPHeader( "Origin", "" ) != schemeAndHost;
    }

    private function isCachedEvent( event ) {
        return structKeyExists( event.getEventCacheableEntry(), "cacheKey" ) &&
            getController().getCache( "template" ).lookup( event.getEventCacheableEntry().cacheKey );
    }

    private function shouldProcessEvent( event, settings ) {
        var eventPatterns = isSimpleValue( settings.eventPattern ) ?
            settings.eventPattern.listToArray(",") :
            settings.eventPattern;

        return eventPatterns.reduce( function( any, pattern ) {
            return REFind( pattern, event.getCurrentEvent() ) > 0 ? true : any;
        }, false );
    }

    private function isAllowed( event, settings ) {
        if ( ! arrayContains( settings.allowMethods, event.getHTTPMethod() ) ) {
            return false;
        }

        var allowedOrigins = settings.allowOrigins;
        if ( isSimpleValue( allowedOrigins ) ) {
            if ( settings.allowOrigins == "*" ) {
                return true;
            }
            allowedOrigins = listToArray( settings.allowOrigins, "," );
        }
        return arrayContains( allowedOrigins, event.getHTTPHeader( "Origin", "" ) );
    }

}
