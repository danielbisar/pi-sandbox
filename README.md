# pi-sandbox

A containerized environment for running the Pi AI agent.

## Usage

```bash
./run.sh [--extensions <extensions_path>] [--skills <skills_path>]... [--shell] <repo_path>
```

- `--extensions <extensions_path>` — optional path to a custom extensions folder (mounted to `/home/pi/.pi/agent/extensions/`)
- `--skills <skills_path>` — optional path to a custom skill folder; may be repeated
- `--skill <skills_path>` — alias for `--skills`
- `--shell` — run `/bin/bash` in the container instead of launching `pi`
- `repo_path` — path to the repository you want the agent to work on

Examples:

```bash
./run.sh /path/to/repo
./run.sh --extensions /path/to/extensions --skills /path/to/skill-a --skills /path/to/skill-b /path/to/repo
./run.sh --shell /path/to/repo
```

Run `./run.sh --help` for details.

## Building

```bash
./build.sh
```
