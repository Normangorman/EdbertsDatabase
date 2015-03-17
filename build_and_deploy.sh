#!/bin/bash

cabal configure
cabal build
wait

ssh root@178.62.94.90 "stop edberts"
wait

rsync -rvzh --progress dist/build/EdbertsDatabase/EdbertsDatabase root@178.62.94.90:/srv/EdbertsDatabase
wait

ssh root@gormangames.com "start edberts"
