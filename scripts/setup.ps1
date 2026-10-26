# setup.ps1 - one-time (re-runnable) machine check and git setup for this workspace, native PowerShell.
# Same behaviour as setup.sh. Works in Windows PowerShell 5.1 and PowerShell 7+.
#   .\scripts\setup.ps1          check tools, set safe git defaults, ask for git identity if missing
#   .\scripts\setup.ps1 -Check   report only: no prompts, no writes
[CmdletBinding()]
param([switch]$Check)

$ErrorActionPreference = 'Stop'

function Say($msg)  { Write-Host $msg }
function Warn($msg) { Write-Host "WARNING: $msg" -ForegroundColor Yellow }

function Get-GitConfig($key) {
    $prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    $v = & git config --global --get $key 2>$null
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prev
    if ($code -ne 0 -or $null -eq $v) { return '' }
    return ([string]($v | Select-Object -First 1)).Trim()
}

function Get-FirstLine($exe, $arg) {
    try {
        $out = & $exe $arg 2>$null
        if ($null -eq $out) { return '' }
        return [string]($out | Select-Object -First 1)
    } catch { return '' }
}

# ---- 1. platform ------------------------------------------------------------
$osName = [System.Environment]::OSVersion.Platform
Say "== 1/4 Platform: PowerShell $($PSVersionTable.PSVersion) on $osName"

# ---- 2. tools ---------------------------------------------------------------
Say '== 2/4 Required tools'
$missing = @()
foreach ($t in @('git', 'curl.exe')) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue
    if ($cmd) {
        $ver = ''
        if ($t -eq 'git') { $ver = " ($(Get-FirstLine 'git' '--version'))" }
        Say "  ok      $t$ver"
    } else {
        Say "  MISSING $t"
        $missing += $t
    }
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Say '  ok      claude'
} else {
    Warn 'claude (Claude Code) not found. Install it with:  irm https://claude.ai/install.ps1 | iex  then open a new PowerShell window.'
}

# gh is what /ship uses to open pull requests; without it /ship stops after the push and prints the compare URL.
if (Get-Command gh -ErrorAction SilentlyContinue) {
    # gh writes to stderr when signed out; in Windows PowerShell 5.1 that would throw under 'Stop'.
    $prev = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    & gh auth status *> $null
    $ghExit = $LASTEXITCODE
    $ErrorActionPreference = $prev
    if ($ghExit -eq 0) {
        Say '  ok      gh (signed in)'
    } else {
        Warn 'gh is installed but not signed in: run  gh auth login  (needed by /ship to open PRs)'
    }
} else {
    Warn 'gh (GitHub CLI) not found: admin PowerShell  winget install GitHub.cli  then open a new window and run  gh auth login'
}

if ($missing.Count -gt 0) {
    Say 'Install from an admin PowerShell:  winget install Git.Git GitHub.cli   (curl.exe ships with Windows 10+ and Git for Windows), then open a new window'
    Write-Host 'ERROR: Install the missing tools above, then re-run scripts\setup.ps1' -ForegroundColor Red
    exit 1
}

Say '  Optional runtimes (depends on the projects you work in):'
foreach ($t in @('node', 'npm', 'python', 'python3')) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $cmd) {
        Say "  --      $t not found (install only if a project needs it)"
        continue
    }
    # python/python3 may be the Microsoft Store alias stub: running it opens the Store. Detect it by path
    # (WindowsApps) and never execute it.
    if ($cmd.Source -like '*WindowsApps*') {
        Say "  --      $t is the Microsoft Store stub, not Python (see docs/SETUP-WINDOWS.md troubleshooting)"
        continue
    }
    $ver = Get-FirstLine $t '--version'
    if ($ver) { Say "  ok      $t ($ver)" } else { Say "  --      $t found but did not report a version" }
}

# ---- 3. git defaults --------------------------------------------------------
Say '== 3/4 Git defaults'
function Set-IfUnset($key, $value, $why) {
    $cur = Get-GitConfig $key
    if ($cur) {
        Say "  $key = $cur (kept)"
    } elseif ($Check) {
        Say "  $key unset (would set to ${value}: $why)"
    } else {
        & git config --global $key $value
        Say "  $key = $value ($why)"
    }
}
Set-IfUnset 'core.autocrlf' 'false' 'LF line endings everywhere; .gitattributes enforces it per repo'
Set-IfUnset 'pull.rebase' 'true' 'linear history, no accidental merge commits'
Set-IfUnset 'init.defaultBranch' 'main' 'new repos start on main'

$interactive = [Environment]::UserInteractive -and ([Console]::IsInputRedirected -eq $false)
foreach ($key in @('user.name', 'user.email')) {
    $cur = Get-GitConfig $key
    if ($cur) {
        Say "  $key = $cur"
    } elseif ($Check -or -not $interactive) {
        Warn "$key is not set. Set it yourself:  git config --global $key `"...`""
    } else {
        $val = Read-Host "  $key is not set. Enter it"
        if ($val -and $val.Trim()) {
            & git config --global $key $val.Trim()
            Say "  $key = $($val.Trim())"
        } else {
            Warn "$key left unset; run: git config --global $key `"...`""
        }
    }
}

# ---- 4. done ----------------------------------------------------------------
Say '== 4/4 Done'
if ($Check) {
    Say 'Check complete. Run without -Check to apply the git defaults.'
} else {
    Say 'Next: cd into this folder, run  claude  and type  /onboard <project>  for a repo in ..\ or  /spec  to start a feature.'
    Say 'First time? docs/SETUP-WINDOWS.md has the walkthrough; docs/EXTENDING.md shows how to add skills.'
}
exit 0
