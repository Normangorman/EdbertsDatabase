FROM postgres:9.4 as base

FROM base as sample-data

COPY sample_data.sql /tmp/
RUN cat /tmp/sample_data.sql >> /docker-entrypoint-initdb.d/init.sql \
    && cat /docker-entrypoint-initdb.d/init.sql
