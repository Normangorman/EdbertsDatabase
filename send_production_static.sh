#!/bin/bash

#options mean: recurse on all files, print verbose output, compress data, make the output human readable
rsync -rvzh --progress static/* root@178.62.94.90:/srv/static
