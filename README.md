# PostgreSQL + pg_cron

Custom PostgreSQL Docker image based on the official PostgreSQL image, with the [`pg_cron`](https://github.com/citusdata/pg_cron) extension provided by [`pglayers`](https://github.com/pglayers/pglayers).

## Image

Published to:

```text
ghcr.io/scumbug/postgres:18
```

Base image:

```text
postgres:18-trixie
```

Included extension:

```text
pg_cron
```

## Dockerfile

```dockerfile
FROM postgres:18-trixie

COPY --from=ghcr.io/pglayers/pgx-pg_cron:18 \
    / \
    /extensions/pg_cron/
```

## PostgreSQL 18 configuration

pglayers uses an isolated extension layout for PostgreSQL 18.

The following PostgreSQL options are required:

```text
extension_control_path=/extensions/pg_cron/share:$system
dynamic_library_path=/extensions/pg_cron/lib:$libdir
shared_preload_libraries=pg_cron
```

Example Docker Compose configuration:

```yaml
services:
  postgres:
    image: ghcr.io/scumbug/postgres:18

    command: >
      postgres
      -c extension_control_path=/extensions/pg_cron/share:$$system
      -c dynamic_library_path=/extensions/pg_cron/lib:$$libdir
      -c shared_preload_libraries=pg_cron
      -c cron.database_name=splitpro
      -c cron.timezone=UTC
```

Replace `splitpro` with the database where `pg_cron` should be installed.

After starting PostgreSQL:

```sql
CREATE EXTENSION IF NOT EXISTS pg_cron;
```

## Automated builds

GitHub Actions automatically builds and publishes the image to GHCR.

Builds run:

- On pushes to `main`
- When manually triggered
- Weekly to pick up updates to the PostgreSQL base image and pg_cron layer

## Notes

This image intentionally contains only:

```text
Official PostgreSQL 18
+
pg_cron
```

No additional PostgreSQL extensions are included.
