create docker image:

docker build -t claude-code-sandbox:ubuntu .

run the container, maooing $PWD/<input folder> to /workspace

docker run --rm -it --network=host -v "$PWD/test_docker_sandboxing:/workspace" -w /workspace -e ANTHROPIC_AUTH_TOKEN=ollama -e ANTHROPIC_BASE_URL=http://localhost:11434 -e ANTHROPIC_API_KEY="" claude-code-sandbox:ubuntu 



