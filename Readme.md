# How to create a local C++ coding assistant with bitnet LLM
Missing statement: I got courious about how bitnet LLM from Microsoft can be used
as local LLM to build a coding assistent for C++.

Design Goal: 
- Open Source only (therefore the use of podman instead of docker!)
- it must be useable on a laptop without network access
- more ???

## What we need
- podman (or docker)
- this document
- bitnet xx.yy


## Create the podman/docker image
Use the files Dockerfile and docker-compose.yml in folder ./models to define & start the image.

---------- 
working
----------
initialize podman after installation with
```cmd
podman init
podman start
```


