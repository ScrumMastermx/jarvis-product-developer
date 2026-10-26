# Setup on Windows (about 15 minutes)

Copy and paste each block. Steps 1 and 2 need the machine's admin account once.

## 1. Git and GitHub CLI

Admin PowerShell (Start → type `powershell` → right-click → Run as administrator):

```powershell
winget install Git.Git GitHub.cli
```

Close the window. This installs Git and the GitHub CLI (`gh`), which `/ship` uses to open pull requests.

## 2. Claude Code

Normal PowerShell (not admin):

```powershell
irm https://claude.ai/install.ps1 | iex
```

A Claude plan that includes Claude Code is needed. Sign-in happens the first time you run `claude`, not during
the install. Open a new PowerShell window and confirm:

```powershell
claude --version
```

If it prints a version, continue. If "not recognized": close every terminal, open a new PowerShell, try again.

## 3. Clone and set up

PowerShell:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
mkdir ~\code -Force | Out-Null; cd ~\code
git clone https://github.com/ScrumMastermx/jarvis-product-developer.git
cd jarvis-product-developer
.\scripts\setup.ps1
gh auth login
```

The script checks the tools, sets LF line endings and rebase-on-pull, and asks for the git name and email if
they are not set. Re-run it any time; `.\scripts\setup.ps1 -Check` only reports.

`gh auth login` signs the GitHub CLI in (it also stores the credential Git uses for pushes). Pick GitHub.com →
HTTPS → login with a web browser, and follow the code it shows.

## 4. Projects

Clone the repos you work in **next to** this folder, so they land at `~\code\<project>`:

```powershell
cd ~\code
git clone <url-of-your-project>
```

Add each one to `projects.txt` (folder name + URL) so Claude knows it exists.

## 5. First session

```powershell
cd ~\code\jarvis-product-developer
claude
```

The first run asks you to sign in with the Claude account in the browser. Type `/` to see the commands below.

Inside Claude:

- `/onboard <project>` maps a project (stack, how to run, how to test) into `notes/projects/`.
- `/spec` starts a feature spec from a conversation.
- Then `/plan`, `/test`, `/review`, `/ship` as you build.

## Desktop app instead of the terminal

The Claude desktop app's Code tab can open this folder too (open folder → `~\code\jarvis-product-developer`).
Same skills, same rules. Claude's own shell tool still runs through Git Bash.

## Troubleshooting

- **"running scripts is disabled on this system"**: run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force`,
  or one-off: `powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1`.
- **"The term 'claude' (or git, gh) is not recognized"**: PATH is read when a window opens. Close the window, open a
  new PowerShell, then `where.exe claude` to see where it is installed.
- **`^M` or CRLF warnings, scripts fail with `\r`**: `git config --global core.autocrlf false`, then
  `git checkout -- .` in the affected repo. `.gitattributes` keeps LF from then on.
- **`python3` opens the Microsoft Store**: Settings → Apps → Advanced app settings → App execution aliases →
  turn off the `python3.exe` and `python.exe` aliases. Then install Python from python.org or
  `winget install Python.Python.3.12` and open a new window.
- **Git asks for a password on push**: use a GitHub personal access token as the password, or run `gh auth login`
  and let the GitHub CLI manage credentials.
- **Antivirus slows `git` or `claude`**: exclude `~\code` from real-time scanning if company policy allows.
- **Prefer Git Bash? use `bash scripts/setup.sh`**: open Git Bash and run it from the repo folder (not `./scripts/setup.sh`,
  which can fail with "Permission denied"). Variables set in `~/.bashrc` are missing in Git Bash because it reads
  `~/.bash_profile`; add `[ -f ~/.bashrc ] && . ~/.bashrc` there.
