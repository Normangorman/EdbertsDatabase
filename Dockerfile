FROM ubuntu:18.04 AS build

# zlib headers required to compile the zlib Haskell package
# libpq required for postgresql-libpq Haskell package
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ghc \
      cabal-install \
      zlib1g-dev \
      libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.cabal/bin:${PATH}"

WORKDIR /build
COPY app app
COPY Handler Handler
COPY messages messages
COPY Settings Settings
COPY templates templates
COPY config config
COPY static static
COPY test test
COPY .dir-locals.el .dir-locals.el
COPY .ghci .ghci
COPY EdbertsDatabase.cabal EdbertsDatabase.cabal
COPY cabal.config cabal.config
COPY *.hs ./

RUN cabal update
RUN cabal install alex-3.2.4
RUN cabal install happy-1.19.12
RUN cabal install language-javascript-0.6.0.0
RUN cabal install

FROM ubuntu:18.04 AS production

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      zlib1g-dev \
      libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv
COPY config/ /srv/config/
COPY static/ /srv/static/
COPY --from=build /build/dist/build/EdbertsDatabase/EdbertsDatabase /srv
ENTRYPOINT ["./EdbertsDatabase"]
