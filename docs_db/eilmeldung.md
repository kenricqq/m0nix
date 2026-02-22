## Miniflux (RSS Backend)

```sh
psql -d postgres
# create miniflux table
`CREATE DATABASE miniflux OWNER miniflux;`

$env.DATABASE_URL = "postgres://miniflux:CHANGE_ME_DB@127.0.0.1:5432/miniflux?sslmode=disable"
$env.LISTEN_ADDR = "127.0.0.1:8080"
$env.RUN_MIGRATIONS = "1"
$env.CREATE_ADMIN = "1"
$env.ADMIN_USERNAME = "admin"
$env.ADMIN_PASSWORD = "rss-eilmeldung"
$env.ADMIN_EMAIL = "you@example.com"
```
