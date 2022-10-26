component {

    property name="wirebox" inject="wirebox";
    property name="log" inject="logbox:logger:{this}";

    function preProcess( event, interceptData, buffer, rc, prc ) {
        log.debug( "Starting CORS lifecycle event: preProcess" );
        log.debug( "Current event is: #event.getCurrentEvent()#" );

        if ( ! isCORSRequest( event ) ) {
            log.debug( "Not a CORS request. Continuing with request." );
            return;
        }

        var settings = wirebox.getInstance( dsl = "coldbox:moduleSettings:cors" );

        if ( ! shouldProcessEvent( event, settings ) ) {
            log.debug( "Should not process event with CORS according to CORS settings.  Continuing with request." );
            return;
        }

        if ( ! isAllowedOrigin( event, settings ) ) {
            log.debug( "Origin is not allowed according to CORS settings.  Aborting (403)." );

            event.noExecution();
            event.setHTTPHeader( 403, "Forbidden (CORS)" );
            event.renderData( type = "plain", data = "Forbidden (CORS)", statusCode = 403 );
            return;
        }

        if ( ! isAllowedMethod( event, settings ) ) {
            log.debug( "Method is not allowed according to CORS settings.  Aborting (403)." );

            event.noExecution();
            event.setHTTPHeader( 403, "Forbidden (CORS)" );
            event.renderData( type = "plain", data = "Forbidden (CORS)", statusCode = 403 );
            return;
        }

        var allowedOrigin = event.getHTTPHeader( "Origin", "" );

        if ( isCachedEvent( event ) ) {
        
            var cacheKey = event.getEventCacheableEntry().cacheKey;
            var templateCache = getController().getCache( "template" );
            var cachedEvent = templateCache.get( event.getEventCacheableEntry().cacheKey );
            
            if ( event.getHTTPMethod() != "OPTIONS" ) {
                log.debug( "Cached event detected. Overriding `Access-Control-Allow-Origin` and `Access-Control-Allow-Credentials` headers." );

                log.debug( "Setting the 'Access-Control-Allow-Origin' header to #allowedOrigin# for the cached event." );
                cachedEvent.responseHeaders[ "Access-Control-Allow-Origin" ] = allowedOrigin;

                log.debug( "Setting the 'Access-Control-Allow-Credentials' header to #toString( settings.allowCredentials )# for the cached event." );
                cachedEvent.responseHeaders[ "Access-Control-Allow-Credentials" ] = toString( settings.allowCredentials );

                templateCache.set( cacheKey, cachedEvent );
                return;
            }

            // OPTIONS requests for CORS should not be cached
            log.warn( "OPTIONS requests for CORS should not be cached.  Removing the cached event.", event.getCurrentEvent() );
            templateCache.clear( cacheKey );
        }

        log.debug( "Setting the 'Access-Control-Allow-Origin' header to #allowedOrigin#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Origin", value = allowedOrigin );
        log.debug( "Setting the 'Access-Control-Allow-Credentials' header to #toString( settings.allowCredentials )#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Credentials", value = toString( settings.allowCredentials ) );

        // The rest of the method is only for OPTIONS requests
        if ( event.getHTTPMethod() != "OPTIONS" ) {
            return;
        }

        var allowedHeaders = settings.allowHeaders;
        if ( isClosure( allowedHeaders ) || isCustomFunction( allowedHeaders ) ) {
            allowedHeaders = allowedHeaders( event );
        }
        if ( isSimpleValue( allowedHeaders ) ) {
            // TODO: This is needed for legacy reasons. We can remove it in the next breaking change
            allowedHeaders = allowedHeaders == "*" ?
                event.getHTTPHeader( "Access-Control-Request-Headers", "" ) :
                allowedHeaders;
        }
        else {
            allowedHeaders = arrayToList( allowedHeaders, ", " );
        }

        log.debug( "Setting the 'Access-Control-Allow-Headers' header to #allowedHeaders#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Headers", value = allowedHeaders );

        var allowedMethods = settings.allowMethods;
        if ( isClosure( allowedMethods ) || isCustomFunction( allowedMethods ) ) {
            allowedMethods = allowedMethods( event );
        }
        if ( isArray( allowedMethods ) ) {
            allowedMethods = arrayToList( allowedMethods, ", " );
        }
        log.debug( "Setting the 'Access-Control-Allow-Methods' header to #allowedMethods#." );
        event.setHTTPHeader( name = "Access-Control-Allow-Methods", value = allowedMethods );

        log.debug( "Setting the 'Access-Control-Max-Age' header to #settings.maxAge#." );
        event.setHTTPHeader( name = "Access-Control-Max-Age", value = settings.maxAge );

        // check if preflight response should be returned
        if ( settings.shouldReturnPreflight(event) ) {
            log.debug( "Preflight return check passed.  Returning a 200 OK." );
            event.noExecution();
            event.renderData( "plain", "Preflight OK" );
            return;
        }
    }

    private function isCORSRequest( event ) {
        log.debug( "Current Origin is: #event.getHTTPHeader( "Origin", "" )#" );
        if ( event.getHTTPHeader( "Origin", "" ) == "" ) {
            return false;
        }
        var schemeAndHost = event.isSSL() ? "https://" : "http://" & CGI.HTTP_HOST;
        return event.getHTTPHeader( "Origin", "" ) != schemeAndHost;
    }

    private function isCachedEvent( event ) {
        var cacheableEntry = event.getEventCacheableEntry();
        return cacheableEntry.keyExists( "cacheKey" ) &&
            cacheableEntry.keyExists( "provider" ) &&
            getController().getCache( cacheableEntry.provider ).lookup( cacheableEntry.cacheKey );
    }

    private function shouldProcessEvent( event, settings ) {
        var eventPatterns = isSimpleValue( settings.eventPattern ) ?
            settings.eventPattern.listToArray(",") :
            settings.eventPattern;

        log.debug( "Allowed event patterns are: #arrayToList( eventPatterns, ", " )#" );

        return eventPatterns.reduce( function( any, pattern ) {
            return REFind( pattern, event.getCurrentEvent() ) > 0 ? true : any;
        }, false );
    }

    private function isAllowedMethod( event, settings ) {
        if ( event.getHTTPMethod() == "OPTIONS" ) {
            return true;
        }

        var allowedMethods = settings.allowMethods;
        if ( isClosure( allowedMethods ) || isCustomFunction( allowedMethods ) ) {
            allowedMethods = allowedMethods( event );
        }
        if ( isSimpleValue( allowedMethods ) ) {
            allowedMethods = listToArray( allowedMethods, "," );
        }
        return arrayContains( allowedMethods, event.getHTTPMethod() );
    }

    private function isAllowedOrigin( event, settings ) {
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
        log.debug( "Allowed origins are: #arrayToList( allowedOrigins, ", " )#" );
        return arrayContains( allowedOrigins, event.getHTTPHeader( "Origin", "" ) );
    }

}
