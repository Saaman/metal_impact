#!/bin/bash

#set -x

#start processes on Heroku
heroku ps:scale web=0 worker=0