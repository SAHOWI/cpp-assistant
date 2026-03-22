# How to create a local C++ coding assistant with bitnet LLM
Missing statement: I got courious about how bitnet LLM from Microsoft can be used
as local LLM to build a coding assistent for C++.

Design Goal: 
- Open Source only (therefore the use of podman instead of docker!)
- it must be useable on a laptop without network access
- more ???

## What we need
- this document :-)
- python 3.xx (make sure it is up-to-date)
- podman
- podman-compose
- bitnet xx.yy
- 

## Installation
### Preparation
Ensure you have WSL2 installed

### Install packages
- Install python3 from e.g from Microsoft store
- Install Podman (and Podman Desktop) from podman.io
- Install podman-compse via
```cmd
mkdir C:\data\ai\
git clone git@github.com:SAHOWI/cpp-assistant.git
python.exe -m venv venv-podman
venv-podman\Scripts\activate
(venv-podman) pip install podman-compose
```
REMINDER: You have to execute venv-podman\Scripts\activate again from within C:\data\ai\cpp-assistant after every new start of your cmd shell.

 




## Create the podman/docker image
Use the files Dockerfile and docker-compose.yml in folder ./models to define & start the image.

---------- 
working
----------
Assuming the repo is cloned to C:\data\ai\cpp-assistant, initialize podman after installation with
```cmd
cd C:\data\ai\cpp-assistant
podman init
podman start
```

```cmd
(venv-podman) C:\data\ai\cpp-assistant> cd models
(venv-podman) C:\data\ai\cpp-assistant> podman compose up --build -d
```

