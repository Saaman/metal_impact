#!/bin/bash

#set -x

#start processes on Heroku
heroku ps:scale web=1 worker=1