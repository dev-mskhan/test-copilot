param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("userPromptSubmitted", "agentStop")]
    [string] $Event
)

$ErrorActionPreference = "Stop"
$payloadJson = [Console]::In.ReadToEnd()

if ([string]::IsNullOrWhiteSpace($payloadJson)) {
    [Console]::Error.WriteLine("Agent log hook received an empty payload for event '$Event'.")
    exit 1
}

try {
    $payload = $payloadJson | ConvertFrom-Json
} catch {
    [Console]::Error.WriteLine("Agent log hook received invalid JSON for event '$Event': $($_.Exception.Message)")
    exit 1
}

$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$logDirectory = Join-Path $repositoryRoot "agent-logs"
$logPath = Join-Path $logDirectory "conversations.jsonl"

try {
    [System.IO.Directory]::CreateDirectory($logDirectory) | Out-Null
    $record = [ordered]@{
        recorded_at_utc = [DateTime]::UtcNow.ToString("o")
        event           = $Event
        payload         = $payload
    }
    $line = ConvertTo-Json -InputObject $record -Depth 100 -Compress
    [System.IO.File]::AppendAllText(
        $logPath,
        $line + [Environment]::NewLine,
        (New-Object System.Text.UTF8Encoding($false))
    )
    & git -C $repositoryRoot add -- $logPath
    if ($LASTEXITCODE -ne 0) {
        throw "git add failed with exit code $LASTEXITCODE"
    }
} catch {
    [Console]::Error.WriteLine("Agent log hook could not write '$logPath': $($_.Exception.Message)")
    exit 1
}
