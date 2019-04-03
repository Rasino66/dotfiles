#!/bin/bash
docker kill "$(docker ps | peco | cut -c -6)"
