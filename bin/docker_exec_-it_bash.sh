#!/bin/bash
docker exec -it "$(docker ps | peco | cut -c -12)" /bin/bash
