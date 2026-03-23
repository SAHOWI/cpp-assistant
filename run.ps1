podman run --rm -it `
  -p 127.0.0.1:8080:8080 `
  --mount type=bind,src=${PWD}\models,dst=/models `
  --mount type=bind,src=${PWD}\workspace,dst=/workspace `
  cpp-assistant
