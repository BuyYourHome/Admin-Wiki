Option Explicit

Dim shell
Dim command
Dim hostIp
Dim port
Dim fso
Dim scriptPath
Dim toolsFolder
Dim dashboardFolder
Dim projectRoomsFolder
Dim repositoryRoot
Dim serverScript
Const DefaultHostIp = "10.0.0.105"
Const DefaultPort = "8765"

hostIp = DefaultHostIp
port = DefaultPort

If WScript.Arguments.Count >= 1 Then
    hostIp = WScript.Arguments(0)
End If

If WScript.Arguments.Count >= 2 Then
    port = WScript.Arguments(1)
End If

scriptPath = WScript.ScriptFullName

Set fso = CreateObject("Scripting.FileSystemObject")
toolsFolder = fso.GetParentFolderName(scriptPath)
dashboardFolder = fso.GetParentFolderName(toolsFolder)
projectRoomsFolder = fso.GetParentFolderName(dashboardFolder)
repositoryRoot = fso.GetParentFolderName(projectRoomsFolder)
serverScript = toolsFolder & "\Dashboard-LanServer.ps1"

command = "C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ _
    & serverScript & """ -Port " & port & " -HostIp """ & hostIp & """ -RepositoryRoot """ & repositoryRoot & """"

Set shell = CreateObject("WScript.Shell")
shell.Run command, 0, False
