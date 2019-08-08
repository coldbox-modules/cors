component {

    property name="wirebox" inject="wirebox";
    property name="log" inject="logbox:logger:{this}";

    function preProcess( event, interceptData, buffer, rc, prc ) {
        log.debug( "Starting CORS lifecycle event: preProcess" );

        if ( ! isCORSRequest( event ) ) {
            log.debug( "Not a CORS request. Continuing with request." );
            return;
        }

        if ( isCachedEvent( event ) ) {
            log.debug( "Cached event detected. Continuing with request." );
            return;
        }

        if ( event.getHTTPMethod() != "OPTIONS" ) {
            log.debug( "Not an OPTIONS request. Continuing with request." );
            return;
        }

        var settings = wirebox.getInstance( dsl = "coldbox:moduleSettings:cors" );

        if ( ! shouldProcessEvent( event, settings ) ) {
            log.debug( "Should not process event with CORS according to CORS settings.  Continuing with request." );
            return;
        }

        if ( ! isAllowed( event, settings ) ) {
            log.debug( "Method or Origin is not allowed according to CORS settings.  Aborting (403)." );

            event.noExecution();
            event.setHTTPHeader( 403, "Forbidden (CORS)" );
            event.renderData( type = "plain", data = "Forbidden (CORS)", statusCode = 403 );
            return;
        }

        var allowedOrigins = settings.allowOrigins;
        if ( isClosure( allowedOrigins ) || isCustomFunction( allowedOrigins ) ) {
            allowedOrigins = allowedOrigins( event );
        }
        if ( ! isSimpleValue( allowedOrigins ) ) {
            allowedOrigins = arrayToList( allowedOrigins, ", " );
        }
        log.debug( "Setting the 'Access-Control-Allow-Origin' header to #allowedOrigins#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Origin", value = allowedOrigins );
        log.debug( "Setting the 'Access-Control-Allow-Credentials' header to #toString( settings.allowCredentials )#." );
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

        log.debug( "Setting the 'Access-Control-Allow-Headers' header to #allowedHeaders#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Headers", value = allowedHeaders );
        log.debug( "Setting the 'Access-Control-Allow-Methods' header to #arrayToList( settings.allowMethods, ", " )#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Methods", value = arrayToList( settings.allowMethods, ", " ) );
        log.debug( "Setting the 'Access-Control-Max-Age' header to #settings.maxAge#." );
        event.setHTTPHeader( name = "Access-Control-Max-Age", value = settings.maxAge );

        if ( event.isInvalidHTTPMethod() ) {
            log.debug( "No handler action for an OPTIONS request.  Returning a 200 OK." );
            event.noExecution();
            event.renderData( "plain", "Preflight OK" );
            return;
        }
    }

    function preEvent( event, interceptData, buffer, rc, prc ) {
        log.debug( "Starting CORS lifecycle event: preEvent" );

        if ( ! isCORSRequest( event ) && ! isCachedEvent( event ) ) {
            log.debug( "Event is not a cached event or a CORS request. Continuing with request." );
            return;
        }

        var settings = wirebox.getInstance( dsl = "coldbox:moduleSettings:cors" );

        if ( ! shouldProcessEvent( event, settings ) ) {
            log.debug( "Should not process event with CORS according to CORS settings.  Continuing with request." );
            return;
        }

        if ( ! isAllowed( event, settings ) ) {
            log.debug( "Method or Origin is not allowed according to CORS settings.  Aborting (403)." );

            event.noExecution();
            event.setHTTPHeader( 403, "Forbidden (CORS)" );
            event.renderData( type = "plain", data = "Forbidden (CORS)", statusCode = 403 );
            return;
        }

        var currentHeaders = event.getResponseHeaders();

        if ( ! structKeyExists( currentHeaders, "Access-Control-Allow-Origin" ) ) {
            var allowedOrigins = settings.allowOrigins;
            if ( isClosure( allowedOrigins ) || isCustomFunction( allowedOrigins ) ) {
                allowedOrigins = allowedOrigins( event );
            }
            if ( ! isSimpleValue( allowedOrigins ) ) {
                allowedOrigins = arrayToList( allowedOrigins, ", " );
            }
            log.debug( "Setting the 'Access-Control-Allow-Origin' header to #allowedOrigins#." );
            event.setHTTPHeader( name = "Access-Control-Allow-Origin", value = allowedOrigins );
        }

        if ( ! structKeyExists( currentHeaders, "Access-Control-Allow-Credentials" ) ) {
            log.debug( "Setting the 'Access-Control-Allow-Credentials' header to #toString( settings.allowCredentials )#." );
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
        if ( isClosure( allowedOrigins ) || isCustomFunction( allowedOrigins ) ) {
            allowedOrigins = allowedOrigins( event );
        }
        if ( isSimpleValue( allowedOrigins ) ) {
            if ( allowedOrigins == "*" ) {
                return true;
            }
            allowedOrigins = listToArray( allowedOrigins, "," );
        }
        return arrayContains( allowedOrigins, event.getHTTPHeader( "Origin", "" ) );
    }

}
