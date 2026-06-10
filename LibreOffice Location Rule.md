# LibreOffice Location Rule

Use this rule when a workflow needs LibreOffice for Word/PDF rendering, DOCX-to-PDF conversion, or visual QA.

## Installed Path

- Executable: `C:\Program Files\LibreOffice\program\soffice.exe`
- Program folder: `C:\Program Files\LibreOffice\program`

Do not assume `soffice.exe` is available on the system PATH.

## Command Pattern

When a render/conversion helper expects `soffice.exe` on PATH, prepend the LibreOffice program folder for that command:

```powershell
$env:PATH = 'C:\Program Files\LibreOffice\program;' + $env:PATH
```

For direct conversion, prefer the full executable path:

```powershell
& 'C:\Program Files\LibreOffice\program\soffice.exe' --headless --nologo --nofirststartwizard --convert-to pdf --outdir '<output-folder>' '<input-docx>'
```

## Timeout Cleanup

If a LibreOffice render or conversion command times out, check for leftover `soffice` or `soffice.bin` processes from that attempted conversion and stop those conversion processes before continuing.

Do not close Microsoft Word or other user-opened applications unless Wes explicitly asks.
