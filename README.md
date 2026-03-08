#instructions

## create docker image 

docker build -t claude-code-sandbox:ubuntu .

details:
- this is for a non-privileged user, assuming everything that is needed is specified in the dockerfile
- it's easy to edit the dockerfile to remove this, and then claude could install any packages it needed

## create a persistent folder

mkdir workspace; chmod -R ugo+rwx workspace

details:
- this is the only persistent thing, so any repos or claude.md files will need to be here
- claude will not remember its own configuration beyond that

## start the container

docker run --name "claude_container" --rm -it --network=host -v "$PWD/workspace:/workspace" -w /workspace -e OLLAMA_CONTEXT_LENGTH=256000 -e ANTHROPIC_AUTH_TOKEN=ollama -e ANTHROPIC_BASE_URL=http://localhost:11434 -e ANTHROPIC_API_KEY="" claude-code-sandbox:ubuntu

details:
- the command line parameters are all the ones one would pass to run Claude Code with Ollama

## get any folders you want into this, e.g. checkout git repos

## run claude code (it can use any of the models served by Ollama in the host)

claude --model qwen3-coder

## if you really want to try yolo mode, go nuts

claude --dangerously-skip-permissions --model qwen3-coder