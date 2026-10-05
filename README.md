# test-copilot

This repository configures GitHub Copilot CLI hooks to record submitted prompts and completed assistant responses as JSONL.

## Agent conversation logs

Copilot CLI writes one record for each submitted prompt and one for each completed assistant response to [`agent-logs/conversations.jsonl`](agent-logs/conversations.jsonl). Each record includes the hook's original payload and a timestamp. The hook stages the log automatically; commit and push as usual to publish it alongside code changes. It does not create commits or push on its own.

The hooks are configured in `.github/hooks/agent-logs.json` and use the PowerShell script at `.github/hooks/record-agent-log.ps1`. Start a new Copilot CLI session after installing or changing the hooks so the CLI loads the configuration.

**Privacy:** prompts and responses may contain sensitive information. The conversation log is intended to be committed and visible to anyone with repository access; do not submit secrets or private data in prompts recorded here.

## Development

There are no application dependencies or build steps in this repository.
