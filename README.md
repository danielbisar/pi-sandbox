# pi-sandbox

A containerized environment for running the Pi AI agent.

## Usage

```bash
./run.sh [--extensions <extensions_path>] [--skills <skills_path>]... [--session <session_id>] [--shell] <repo_path>
```

- `--extensions <extensions_path>` — optional path to a custom extensions folder (mounted to `/home/pi/.pi/agent/extensions/`)
- `--skills <skills_path>` — optional path to a custom skill folder; may be repeated
- `--skill <skills_path>` — alias for `--skills`
- `--session <session_id>` — optional Pi session ID to resume, passed as `pi --session <session_id>`
- `--shell` — run `/bin/bash` in the container instead of launching `pi`
- `repo_path` — path to the repository you want the agent to work on

Examples:

```bash
./run.sh /path/to/repo
./run.sh --session 019e7839-ab7b-7a8f-984b-49a9824c2155 /path/to/repo
./run.sh --extensions /path/to/extensions --skills /path/to/skill-a --skills /path/to/skill-b /path/to/repo
./run.sh --shell /path/to/repo
```

Run `./run.sh --help` for details.

## Building

```bash
./build.sh
```

If your network intercepts TLS with a private CA, provide the PEM contents as `NPM_EXTRA_CA_CERT` when building:

```bash
NPM_EXTRA_CA_CERT="$(cat /path/to/corp-ca.pem)" ./build.sh
```
