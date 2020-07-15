# v3.0.4
## 15 Jul 2020 — 20:39:40 UTC

### fix

+ __CI:__ Fix for packaging up a recursive zip
 ([e57bf90](https://github.com/elpete/cors/commit/e57bf907edf22308611c803e37baccda824e6701))


# v3.0.3
## 13 Feb 2020 — 17:26:11 UTC

### other

+ __\*:__ chore: Use forgeboxStorage ([6168181](https://github.com/elpete/cors/commit/616818187fbf80de3e4f52a6db883257c15ca7f4))


# v3.0.2
## 15 Jan 2020 — 23:37:40 UTC

### fix

+ __CORS:__ Fix automatic options requests
 ([2a2cdc6](https://github.com/elpete/cors/commit/2a2cdc664d6e1e9212e742d616579637ce143910))


# v3.0.1
## 24 Oct 2019 — 02:37:12 UTC

### other

+ __\*:__ fix: Use dynamic provider instead of just template for cached events
 ([dbe5c3e](https://github.com/elpete/cors/commit/dbe5c3e3c8f4a9b7625005fe3d2473f1d20c317d))


# v3.0.0
## 23 Oct 2019 — 16:24:43 UTC

### BREAKING

+ __\*:__ fix: Fix event caching ([b60d18b](https://github.com/elpete/cors/commit/b60d18be53c11588a797fba99555cc808893d49e))


# v2.2.2
## 16 Oct 2019 — 17:58:04 UTC

### other

+ __\*:__ fix: Use the Access-Control-Allow-Method if present ([a218419](https://github.com/elpete/cors/commit/a21841990cabf68749e22db5c1833d8df1e4c57b))
+ __\*:__ fix: OPTIONS requests are always allowed in preflight requests ([b71a57e](https://github.com/elpete/cors/commit/b71a57e1eedf3306186c37b53c25b4763e3216d5))


# v2.2.1
## 17 Sep 2019 — 22:56:58 UTC

### docs

+ __README:__ Update default settings
 ([a10c90a](https://github.com/elpete/cors/commit/a10c90a51705942f7ff1e59a7f809ed0fd11ce52))


# v2.2.0
## 10 Sep 2019 — 21:52:09 UTC

### feat

+ __ModuleConfig:__ Add flag to prevent automatic loading ([240e306](https://github.com/elpete/cors/commit/240e3060da8d03ececcf58e550b2c39237a2f489))

### fix

+ __build:__ Use OpenJDK instead of Oracle
 ([b0cc52b](https://github.com/elpete/cors/commit/b0cc52b212666648b5c0cfa29403854eb0abd0e4))


# v2.1.0
## 09 Aug 2019 — 21:57:25 UTC

### chore

+ __build:__ Add adobe@2018 to testing matrix
 ([ee5e50c](https://github.com/elpete/cors/commit/ee5e50ce9fbd7b326b9df4e1d2c20b45ebd2c73f))

### feat

+ __cors:__ Dynamically determine allowed headers
 ([25a98ba](https://github.com/elpete/cors/commit/25a98ba7eb1cb8f89170fa1e4a5a65b49db02f24))
+ __cors:__ Dynamically determine allowed methods
 ([1e33450](https://github.com/elpete/cors/commit/1e33450725cf49fcd8ffb0c9b6258a6097374d8d))
+ __cors:__ Dynamically determine allowed origins
 ([97cae05](https://github.com/elpete/cors/commit/97cae0531f64f57cd9ad7c66389d546f44bea0a1))


# v2.0.3
## 16 Jul 2019 — 21:38:52 UTC

### other

+ __\*:__ chore: Add debug logging for future debugging
 ([73c0190](https://github.com/elpete/cors/commit/73c01905baaddda0a04adebc2a2e61433564a735))


# v2.0.2
## 15 Jul 2019 — 16:35:09 UTC

### other

+ __\*:__ chore: remove Node dependencies
 ([429e68c](https://github.com/elpete/cors/commit/429e68cdcbd92a6228cd95367f9d42bd9b3d3253))
+ __\*:__ fix: Move postProcess to preEvent to fit within caching lifecycle
 ([d2184f0](https://github.com/elpete/cors/commit/d2184f01755e37d431b5f3a5c637595b41a5a04a))
+ __\*:__ fix: Remove duplicate code
 ([091140e](https://github.com/elpete/cors/commit/091140eb50388c0d1a89910ec88d9354885727bf))


# v2.0.1
## 11 Jul 2019 — 22:08:54 UTC

### fix

+ __Caching:__ Fix for event caching when expiring
 ([a06dbfa](https://github.com/elpete/cors/commit/a06dbfac07879d45de5f1bea2fc9174977fca9b8))


# v2.0.0
## 10 Jul 2019 — 19:41:08 UTC

### BREAKING

+ __CORS:__ Ignore cached events for CORS ([9d6fd4c](https://github.com/elpete/cors/commit/9d6fd4cb6c6c82dfd957f9b4007dc3fccb642acc))


# 31 Jan 2018 — 23:23:01 UTC

### chore

+ __build:__ trigger minor release ([ef05a5c](https://github.com/elpete/cors/commit/ef05a5c2fe6440716aee12fc99421d6a1953dc70))


# 31 Jan 2018 — 23:11:40 UTC

### feat

+ __events:__ Add eventPattern to settings (#2) ([b7544a9](https://github.com/elpete/cors/commit/b7544a90c59ebb372fd3201dfabd7ff610b8d859))


# 27 Jan 2018 — 06:09:38 UTC

### chore

+ __build:__ Remove unnecessary package scripts ([88f7e90](https://github.com/elpete/cors/commit/88f7e908914d93c8c638dd7df775c33470fb20dc))
+ __build:__ Fix ACF builds ([dc433de](https://github.com/elpete/cors/commit/dc433de2e35269978fc578685f3a58b0b08c79c0))
+ __build:__ Add Travis CI and Semantic Release ([d084e2f](https://github.com/elpete/cors/commit/d084e2f60f50d1aebd646d3a078c4e04d304138f))

### feat

+ __cors:__ Add isAllowed check and response ([36d605e](https://github.com/elpete/cors/commit/36d605e1fd211c7d45714221a801df34b2f7909b))
+ __cors:__ Send a generic preflight back if none defined ([352e20d](https://github.com/elpete/cors/commit/352e20d85ee947722e18c38d8f22cebea890ddaf))

### other

+ __\*:__ 1.1.0 ([c41dc40](https://github.com/elpete/cors/commit/c41dc405bd441d06012da4a4d474164f226f82f7))
+ __\*:__ Fill out CORS spec with settings overrides ([5da1fa5](https://github.com/elpete/cors/commit/5da1fa50c9077029fb0293277a06631e681f468e))
+ __\*:__ Additional CORS Headers (#1) ([9d39d74](https://github.com/elpete/cors/commit/9d39d74fcf61da59071cdacff049631749991368))
+ __\*:__ add MIT License ([1ca7413](https://github.com/elpete/cors/commit/1ca741301753bd37d4aa027a3c87c321feb90f69))
+ __\*:__ Fill out README ([1a6ffb7](https://github.com/elpete/cors/commit/1a6ffb74c5f7d2f96ef69845ff96fb355bd836bd))
+ __\*:__ 1.0.0 ([0158993](https://github.com/elpete/cors/commit/01589935f1d9bd467475a9af4bd8b7dfd80b4bdb))
+ __\*:__ Add CORS headers on every response ([ce21689](https://github.com/elpete/cors/commit/ce21689688cdc844f0f5fdffa48db995a0e905f9))
+ __\*:__ Initial commit ([5ee486a](https://github.com/elpete/cors/commit/5ee486a93d9fc28ef55c7b01429f8bde67cedd76))
