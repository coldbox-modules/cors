# cors

## Add CORS headers to your app in one module

This module detects CORS requests, validates them against the configured origins,
and handles preflight requests.

The following is the default configuration.

```
settings = {
    autoRegisterInterceptor = true,
    allowOrigins = function( event ) {
        return event.getHTTPHeader( "Origin", "*" );
    },
    allowMethods = function( event ) {
        return event.getHTTPMethod();
    },
    allowHeaders = function( event ) {
        return event.getHTTPHeader( "Access-Control-Request-Headers", "" );
    },
    maxAge = 60 * 60 * 24, // 1 day
    allowCredentials = true,
    eventPattern = ".*",
    shouldReturnPreflight = function( event ) {
        return event.isInvalidHTTPMethod( );
    }
};
```

## `autoRegisterInterceptor`

If you need more control over the order of your interceptors you can
disable the automatic loading of the CORS interceptor.  If you do this
you will need to register it yourself (most likely in `config/ColdBox.cfc`)
as `cors.interceptors.CORS`.
