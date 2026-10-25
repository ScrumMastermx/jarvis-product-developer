# Setup on Windows (about 15 minutes)

Copy and paste each block. Steps 1 and 2 need the machine's admin account once.

## 1. Git for Windows

Admin PowerShell (Start → type `powershell` → right-click → Run as administrator):

```powershell
winget install Git.Git GitHub.cli
```

Close the window. This installs Git plus **Git Bash** (the terminal used for everything below) and the GitHub CLI (`gh`), which `/ship` uses to open pull requests.

## 2. Claude Code

Normal PowerShell (not admin):

```powershell
irm https://claude.ai/install.ps1 | iex
```

A Claude plan that includes Claude Code is needed. Sign-in happens the first time you run `claude`, not during
the install. Open a new Git Bash window (Start → "Git Bash") and confirm:

```bash
claude --version
```

If it prints a version, continue. If "command not found": close every terminal, reopen Git Bash, try again.

## 3. Clone and set up

Git Bash:

```bash
mkdir -p ~/code && cd ~/code
git clone https://github.com/ScrumMastermx/jarvis-product-developer.git
cd jarvis-product-developer
bash scripts/setup.sh
```

The script checks the tools, sets LF line endings and rebase-on-pull, and asks for the git name and email if
they are not set. Re-run it any time; `bash scripts/setup.sh --check` only reports.

Then sign the GitHub CLI in (it also stores the credential Git uses for pushes):

```bash
gh auth login
```

Pick GitHub.com → HTTPS → login with a web browser, and follow the code it shows.

## 4. Projects

Clone the repos you work in **next to** this folder, so they land at `~/code/<project>`:

```bash
cd ~/code
git clone <url-of-your-project>
```

Add each one to `projects.txt` (folder name + URL) so Claude knows it exists.

## 5. First session

```bash
cd ~/code/jarvis-product-developer
claude
```

The first run asks you to sign in with the Claude account in the browser. Type `/` to see the commands below.

Inside Claude:

- `/onboard <project>` maps a project (stack, how to run, how to test) into `notes/projects/`.
- `/spec` starts a feature spec from a conversation.
- Then `/plan`, `/test`, `/review`, `/ship` as you build.

## Desktop app instead of the terminal

The Claude desktop app's Code tab can open this folder too (open folder → `~/code/jarvis-product-developer`).
Same skills, same rules. The shell behind it is still Git Bash.

## Troubleshooting

- **`^M` or CRLF warnings, scripts fail with `\r`**: `git config --global core.autocrlf false`, then
  `git checkout -- .` in the affected repo. `.gitattributes` keeps LF from then on.
- **`python3` opens the Microsoft Store**: Settings → Apps → Advanced app settings → App execution aliases →
  turn off the `python3.exe` and `python.exe` aliases. Then install Python from python.org or
  `winget install Python.Python.3.12` and reopen Git Bash.
- **Environment variables set in `~/.bashrc` are missing**: Git Bash opens a login shell, which reads
  `~/.bash_profile`, not `~/.bashrc`. Add this line to `~/.bash_profile`: `[ -f ~/.bashrc ] && . ~/.bashrc`.
- **`bash: scripts/setup.sh: Permission denied`**: run it as `bash scripts/setup.sh`, not `./scripts/setup.sh`.
- **Git asks for a password on push**: use a GitHub personal access token as the password, or install the GitHub
  CLI (`winget install GitHub.cli`, then `gh auth login`) and let it manage credentials.
- **Antivirus slows `git` or `claude`**: exclude `~/code` from real-time scanning if company policy allows.
