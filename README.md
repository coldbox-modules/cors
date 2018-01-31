# cors

## Add CORS headers to your app in one module

This module detects CORS requests, validates them against the configured origins,
and handles preflight requests.

The following is the default configuration.

```
settings = {
    allowOrigins = "*",
    allowMethods = [ "DELETE", "GET", "PATCH", "POST", "PUT", "OPTIONS" ],
    allowHeaders = [ "Content-Type", "X-Auth-Token", "Origin", "Authorization" ],
    maxAge = 60 * 60 * 24, // 1 day
    allowCredentials = true,
    eventPattern = [ "^Main\.ajax$", "api" ]
};
```
