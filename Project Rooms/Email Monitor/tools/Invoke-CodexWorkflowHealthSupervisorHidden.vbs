Option Explicit

Dim arguments, command, registryPath, scriptPath, shell
Set arguments = WScript.Arguments

If arguments.Count = 1 Then
    If CStr(arguments(0)) = "--validate" Then
        WScript.Quit 0
    End If
    WScript.Quit 87
ElseIf arguments.Count <> 2 Then
    WScript.Quit 87
End If

Function QuoteArgument(value)
    QuoteArgument = Chr(34) & Replace(CStr(value), Chr(34), Chr(34) & Chr(34)) & Chr(34)
End Function

scriptPath = CStr(arguments(0))
registryPath = CStr(arguments(1))
command = QuoteArgument("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe") _
    & " -NoProfile -NonInteractive -ExecutionPolicy Bypass -File " & QuoteArgument(scriptPath) _
    & " -RegistryPath " & QuoteArgument(registryPath)

Set shell = CreateObject("WScript.Shell")
WScript.Quit shell.Run(command, 0, True)
