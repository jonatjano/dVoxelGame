#!/bin/bash
docker build . -t locald && docker run -v `pwd`:/code -w /code --name locald --rm -ti locald bash
