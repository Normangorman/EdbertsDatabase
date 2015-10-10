#!/bin/bash

psql --username=postgres EdbertsDatabase -c "$1"
