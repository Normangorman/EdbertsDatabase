FROM ubuntu:latest AS build

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

ENV PATH="~/.cabal/bin:${PATH}"

WORKDIR /build
COPY app app
COPY config config
COPY Handler Handler
COPY messages messages
COPY Settings Settings
COPY static static
COPY templates templates
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

RUN mkdir -p /srv
RUN cp -r config/ /srv/config/
RUN cp -r static/ /srv/static
RUN cp dist/build/EdbertsDatabase/EdbertsDatabase /srv
WORKDIR /srv
ENTRYPOINT ["./EdbertsDatabase"]
