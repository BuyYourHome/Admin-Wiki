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

## Windows Fallback

If a DOCX render/conversion helper fails because `soffice.exe` is not found, retry once with the LibreOffice program folder prepended to `PATH` or with the full executable path above.

If LibreOffice still fails or times out on a DOCX that should otherwise open in Word, first retry from a short local workspace copy to rule out cloud-sync or long-path issues. If it still fails, use Microsoft Word's PDF export as the Windows fallback for visual QA. Export a read-only QA copy when possible, render the resulting PDF to page images, inspect the images, and report that Word export was used because LibreOffice headless conversion failed.

Do not ask Wes to install LibreOffice again or add LibreOffice to PATH when the documented executable exists. Treat repeated LibreOffice headless failures as a conversion-tool issue, not an installation issue.
