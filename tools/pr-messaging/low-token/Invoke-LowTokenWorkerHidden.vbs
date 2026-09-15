Option Explicit

Dim arguments, command, messageId, mode, shell
Set arguments = WScript.Arguments

If arguments.Count < 4 Or arguments.Count > 5 Then
    WScript.Quit 87
End If

Function QuoteArgument(value)
    QuoteArgument = Chr(34) & Replace(CStr(value), Chr(34), Chr(34) & Chr(34)) & Chr(34)
End Function

mode = CStr(arguments(3))
If mode <> "Paused" And mode <> "Validation" And mode <> "Live" Then
    WScript.Quit 87
End If

command = QuoteArgument(arguments(0)) _
    & " -NoProfile -ExecutionPolicy Bypass -File " & QuoteArgument(arguments(1)) _
    & " -ConfigPath " & QuoteArgument(arguments(2)) _
    & " -Mode " & QuoteArgument(mode)

If arguments.Count = 5 Then
    messageId = CStr(arguments(4))
    command = command & " -MessageId " & QuoteArgument(messageId)
End If

Set shell = CreateObject("WScript.Shell")
WScript.Quit shell.Run(command, 0, True)
