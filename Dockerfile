FROM postgres:18-trixie

COPY --from=ghcr.io/pglayers/pgx-pg_cron:18 \
    / \
    /extensions/pg_cron/
