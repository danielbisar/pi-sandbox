# pi-sandbox

A containerized environment for running the Pi AI agent.

## Usage

```bash
./run.sh <repo_path> [extensions_path]
```

- `repo_path` — path to the repository you want the agent to work on
- `extensions_path` — optional path to a custom extensions folder (mounted to `/home/pi/.pi/agent/extensions/`)

Run `./run.sh --help` for details.

## Building

```bash
./build.sh
```
