# test-copilot

This repository contains configuration for integrating the [Entire CLI](https://github.com/entireio/cli) with GitHub Copilot CLI. It currently has no application source code or build/test commands.

## Configuration

- `.github/hooks/entire.json` enables Entire integration, disables telemetry, links commits, and stores checkpoints using Git refs.
- `.entire/settings.json` registers Entire CLI hooks for Copilot CLI lifecycle and tool events.
- `.entire/.gitignore` excludes local settings, logs, and temporary Entire data from version control.

The hooks invoke the `entire` executable when it is available. Install and configure the Entire CLI if you want those hooks to record session activity; without it, the Bash hook commands exit without running.

## Development

There are no application dependencies or build steps in this repository. Changes to the integration can be made directly in the configuration files above.
