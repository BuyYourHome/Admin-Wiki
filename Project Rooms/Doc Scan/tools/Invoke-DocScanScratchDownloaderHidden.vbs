Option Explicit

Dim arguments, command, fileSystem, processor, shell
Set arguments = WScript.Arguments

If arguments.Count = 1 Then
    If CStr(arguments(0)) = "--validate" Then
        WScript.Quit 0
    End If
    WScript.Quit 87
ElseIf arguments.Count <> 0 Then
    WScript.Quit 87
End If

Function QuoteArgument(value)
    QuoteArgument = Chr(34) & Replace(CStr(value), Chr(34), Chr(34) & Chr(34)) & Chr(34)
End Function

Set fileSystem = CreateObject("Scripting.FileSystemObject")
processor = fileSystem.BuildPath(fileSystem.GetParentFolderName(WScript.ScriptFullName), "Process-DocScanDownloadRequests.ps1")
command = QuoteArgument("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe") _
    & " -NoProfile -ExecutionPolicy Bypass -File " & QuoteArgument(processor)

Set shell = CreateObject("WScript.Shell")
WScript.Quit shell.Run(command, 0, True)
