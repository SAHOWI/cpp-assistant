podman run -it `
  --name cpp-assistant-debug `
  -p 127.0.0.1:9090:9090 `
  --mount type=bind,src=C:\data\ai\cpp-assistant\models,dst=/models `
  --mount type=bind,src=C:\data\ai\cpp-assistant\workspace,dst=/workspace `
  cpp-assistant `
  bash