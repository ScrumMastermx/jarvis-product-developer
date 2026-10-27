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

# Finds a real Python. The "python" under WindowsApps is the Microsoft Store shortcut: never executed.
function Find-Python {
    $tries = @(
        @{ Name = 'py';      Args = @('-3') },
        @{ Name = 'python';  Args = @() },
        @{ Name = 'python3'; Args = @() }
    )
    foreach ($t in $tries) {
        $cmd = Get-Command $t.Name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -eq $cmd) { continue }
        if ($cmd.Source -like '*WindowsApps*') { continue }
        try {
            $ver = & $cmd.Source @($t.Args) -c "import sys; assert sys.version_info >= (3, 9); print(sys.version)" 2>$null
            if ($LASTEXITCODE -eq 0 -and $ver) {
                return @{ Exe = $cmd.Source; Args = $t.Args; Version = (($ver | Select-Object -First 1) -split ' ')[0] }
            }
        } catch { continue }
    }
    return $null
}

# ---- 1. platform ------------------------------------------------------------
$osName = [System.Environment]::OSVersion.Platform
Say "== 1/5 Platform: PowerShell $($PSVersionTable.PSVersion) on $osName"

# ---- 2. tools ---------------------------------------------------------------
Say '== 2/5 Required tools'
$missing = @()
foreach ($t in @('git')) {
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

# Python runs the admin tools (/facturas, /conciliar, /inventario, /excel, /reporte).
$py = Find-Python
if ($py) { Say "  ok      python ($($py.Version))" } else { Say '  MISSING python 3.9+ (needed by the admin tools; the Microsoft Store stub does not count)'; $missing += 'python' }

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
    Say 'Install from an admin PowerShell:  winget install Git.Git GitHub.cli Python.Python.3.12   then open a new window'
    Say 'If "python" opens the Microsoft Store: Settings > Apps > Advanced app settings > App execution aliases, turn python off.'
    Write-Host 'ERROR: Install the missing tools above, then re-run scripts\setup.ps1' -ForegroundColor Red
    exit 1
}


Say '  Optional runtimes (depends on the projects you work in):'
foreach ($t in @('node', 'npm')) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $cmd) {
        Say "  --      $t not found (install only if a project needs it)"
        continue
    }
    $ver = Get-FirstLine $t '--version'
    if ($ver) { Say "  ok      $t ($ver)" } else { Say "  --      $t found but did not report a version" }
}

# ---- 3. python venv for the admin tools -------------------------------------
Say '== 3/5 Python environment (.venv) for the admin tools'
$Root = Split-Path -Parent $PSScriptRoot
# Windows: .venv\Scripts\python.exe. macOS/Linux (pwsh): .venv/bin/python.
function Get-VenvPython { $w = Join-Path $Root '.venv\Scripts\python.exe'; $u = Join-Path $Root '.venv/bin/python'; if (Test-Path $w) { return $w } elseif (Test-Path $u) { return $u } else { return $w } }
$venvPy = Get-VenvPython
if ($Check) {
    if (Test-Path $venvPy) { Say '  ok      .venv exists' } else { Say '  MISSING .venv (run: .\scripts\setup.ps1)' }
} else {
    if (-not (Test-Path $venvPy)) {
        & $py.Exe @($py.Args) -m venv (Join-Path $Root '.venv')
        if ($LASTEXITCODE -ne 0) { Write-Host 'ERROR: could not create .venv' -ForegroundColor Red; exit 1 }
        $venvPy = Get-VenvPython
    }
    & $venvPy -m pip install -q --disable-pip-version-check -r (Join-Path $Root 'requirements.txt')
    if ($LASTEXITCODE -ne 0) { Write-Host 'ERROR: pip could not install requirements.txt. Internet?' -ForegroundColor Red; exit 1 }
    $v = & $venvPy -c "import openpyxl; print(openpyxl.__version__)"
    if ($LASTEXITCODE -ne 0) { Write-Host 'ERROR: openpyxl did not install.' -ForegroundColor Red; exit 1 }
    Say "  ok      .venv ready (openpyxl $v)"
}

# ---- 4. git defaults --------------------------------------------------------
Say '== 4/5 Git defaults'
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

# ---- 5. done ----------------------------------------------------------------
Say '== 5/5 Done'
if ($Check) {
    Say 'Check complete. Run without -Check to create .venv and apply the git defaults.'
} else {
    Say 'Next: cd into this folder, run  claude  and type  /onboard <project>  for a repo in ..\ or  /spec  to start a feature.'
    Say 'Admin tools: try  /facturas ejemplos/cfdi  (writes an Excel to reportes\).'
    Say 'First time? docs/SETUP-WINDOWS.md has the walkthrough; docs/EXTENDING.md shows how to add skills.'
}
exit 0
