# Codex Python Runtime Rule

Use this rule when running Python for Admin wiki, project-room, document, spreadsheet, or skill-support work.

## Default Runtime

Do not call bare `python` or `python3` for routine Codex work in this repository.

Instead, use the Python executable provided by the Codex workspace runtime:

`C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`

If the runtime path is not already known in the current session, load the workspace dependencies first and use the returned Python executable path.

## User Environment

Do not ask Wes to install Python, add Python to `PATH`, or change Windows app execution aliases merely so Codex can run Admin wiki or project-room scripts.

If a user-owned script truly requires a separate local Python installation, explain that requirement separately and keep it distinct from routine Codex script execution.

## Command Pattern

For project-room scripts, use the full executable path:

```powershell
& 'C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' 'C:\Codex\Wiki Files\path\to\script.py'
```

If a script needs external packages, first check whether they are available in the Codex workspace runtime before asking Wes to install anything globally.
