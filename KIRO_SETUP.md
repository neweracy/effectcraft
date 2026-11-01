# Kiro setup (fork notes)

Personal setup for driving this EffectCraft fork from [Kiro](https://kiro.dev). These files live only
in the fork (`neweracy/effectcraft`); they are not part of upstream EffectCraft.

## 1. Build the MCP server

```sh
cargo build --release -p effectcraft-cli   # about 10 minutes from clean
```

The server is `target/release/effectcraft-cli.exe mcp` (JSON-RPC over stdio). See
[docs/agents.md](docs/agents.md) for every tool.

## 2. Register it in Kiro

Paste this into `.kiro/settings/mcp.json` (this repo) and the `effectcraft` entry into
`~/.kiro/settings/mcp.json` (every project):

```json
{
  "mcpServers": {
    "effectcraft": {
      "command": "d:/code/effectcraft/target/release/effectcraft-cli.exe",
      "args": ["mcp", "--demo"],
      "disabled": false,
      "autoApprove": [
        "list_commands", "describe_command", "command_list", "get_state", "get_project",
        "get_comp", "get_layer", "get_property", "list_effects", "list_fonts",
        "doc_inspect", "render_preview"
      ]
    },
    "effectcraft-app": {
      "command": "d:/code/effectcraft/target/release/effectcraft-cli.exe",
      "args": ["mcp", "--bridge", "9877"],
      "disabled": true,
      "autoApprove": [
        "list_commands", "describe_command", "command_list", "get_state", "get_project",
        "get_comp", "get_layer", "get_property", "list_effects", "list_fonts",
        "doc_inspect", "render_preview"
      ]
    },
    "web-search": {
      "command": "uvx",
      "args": ["duckduckgo-mcp-server@0.7.0"],
      "disabled": false,
      "autoApprove": ["search"]
    }
  }
}
```

- `autoApprove` holds exactly the tools the server marks `readOnlyHint: true`. `render_frame` is left
  out because it can write files; every edit, `undo` and `run_script` prompts.
- `effectcraft-app` drives a running desktop app started with `cargo run -p effectcraft -- --control 9877`.
  It ships disabled.
- `web-search` is pinned. Only `search` is auto-approved; fetching pages prompts.

## 3. Agent rules

[`.kiro/steering/effectcraft-agent.md`](.kiro/steering/effectcraft-agent.md) is always included:
research techniques on the web, build them from built-in effects, never download third-party assets
(AGENTS.md §1 and §2).

## 4. Bedrock model

Use `us.anthropic.claude-sonnet-4-5-20250929-v1:0` (us-east-1). It was verified with Converse,
including tool calls. Newer profiles (`us.anthropic.claude-sonnet-5-5`, `opus-5-5`, every `global.*`
profile) return `AccessDeniedException` until the IAM user can run `aws-marketplace:ViewSubscriptions`
and `aws-marketplace:Subscribe`. Credentials stay in `~/.aws/credentials`, never in this repo.

## 5. Auto-update

`scripts/kiro-auto-update.sh` fetches `upstream`, merges `upstream/main` and rebuilds the CLI. It
skips a dirty tree, aborts a conflicting merge, and exits quietly if the repo is missing. It does not
push.

The global hook `~/.kiro/hooks/effectcraft-auto-update.json` runs it on every Kiro session start.
Run it by hand with `bash scripts/kiro-auto-update.sh`.

## Remotes

```sh
origin    https://github.com/neweracy/effectcraft.git   # the fork
upstream  https://github.com/storytold/effectcraft.git  # fetch only (push URL is DISABLE)
```
