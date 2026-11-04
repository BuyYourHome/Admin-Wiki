Option Explicit

Private gnattBusy As Boolean
Private gnattPending As Boolean
Private gnattDue As Date
Private gnattWaitStarted As Date
Private gnattWatchers As Collection
Private gnattLastState As String
Private gnattLastError As String

Private Function GnattTable(ByVal gnattName As String) As ListObject
    Set GnattTable = ThisWorkbook.Worksheets("Gnatt Chart").ListObjects(gnattName)
End Function

Private Function GnattCallback() As String
    GnattCallback = "'" & Replace(ThisWorkbook.Name, "'", "''") & "'!BYHGnattSync.RunScheduledGnatt"
End Function

Private Function GnattToken(ByVal gnattValue As Variant) As String
    Dim gnattText As String
    If IsError(gnattValue) Then
        gnattText = "ERROR"
    ElseIf IsEmpty(gnattValue) Then
        gnattText = "EMPTY"
    Else
        gnattText = CStr(gnattValue)
    End If
    GnattToken = CStr(VarType(gnattValue)) & ":" & Len(gnattText) & ":" & gnattText & ";"
End Function

Private Function GnattState() As String
    Dim gnattData As Variant, gnattRow As Long, gnattCol As Long, gnattResult As String
    gnattData = GnattTable("Contract_Edits").DataBodyRange.Value2
    For gnattRow = 1 To UBound(gnattData, 1)
        For gnattCol = 1 To UBound(gnattData, 2)
            gnattResult = gnattResult & GnattToken(gnattData(gnattRow, gnattCol))
        Next gnattCol
    Next gnattRow
    gnattData = GnattTable("qryContractsToGnatt").DataBodyRange.Value2
    For gnattRow = 1 To UBound(gnattData, 1)
        For gnattCol = 1 To UBound(gnattData, 2)
            gnattResult = gnattResult & GnattToken(gnattData(gnattRow, gnattCol))
        Next gnattCol
    Next gnattRow
    GnattState = gnattResult
End Function

Public Sub NoticeGnattCalculation()
    If gnattBusy Or gnattPending Then Exit Sub
    On Error GoTo GnattNoticeFailed
    If GnattState() <> gnattLastState Then ScheduleGnattSync
    Exit Sub
GnattNoticeFailed:
    ReportGnattError Err.Description
End Sub

Public Sub ScheduleGnattSync()
    If gnattBusy Or gnattPending Then Exit Sub
    On Error GoTo GnattScheduleFailed
    If gnattWaitStarted = 0 Then gnattWaitStarted = Now
    gnattDue = Now + TimeSerial(0, 0, 1)
    Application.OnTime gnattDue, GnattCallback()
    gnattPending = True
    Exit Sub
GnattScheduleFailed:
    ReportGnattError Err.Description
End Sub

Private Function GnattRefreshing() As Boolean
    Dim gnattSheet As Worksheet, gnattQuery As QueryTable
    For Each gnattSheet In ThisWorkbook.Worksheets
        For Each gnattQuery In gnattSheet.QueryTables
            If gnattQuery.Refreshing Then
                GnattRefreshing = True
                Exit Function
            End If
        Next gnattQuery
    Next gnattSheet
End Function

Public Sub RunScheduledGnatt()
    gnattPending = False
    On Error GoTo GnattScheduledFailed
    If Not Application.Ready Or Application.CalculationState = xlCalculating Or GnattRefreshing() Then
        If DateDiff("s", gnattWaitStarted, Now) > 120 Then Err.Raise vbObjectError + 801, , "Refresh has not finished after two minutes."
        ScheduleGnattSync
        Exit Sub
    End If
    SynchronizeGnatt
    Exit Sub
GnattScheduledFailed:
    gnattWaitStarted = 0
    ReportGnattError Err.Description
End Sub

Public Sub ReportGnattError(ByVal gnattMessage As String)
    gnattLastError = gnattMessage
    Application.StatusBar = "Gnatt Chart NOT synchronized: " & gnattMessage & " Check Index on both sides before editing."
End Sub

Public Sub InitializeGnattSync()
    Dim gnattSheetName As Variant, gnattQuery As QueryTable, gnattWatcher As BYHGnattQueryWatcher
    Set gnattWatchers = New Collection
    For Each gnattSheetName In Array("Depends", "Glasgow", "Tim", "Others", "Gnatt Chart")
        For Each gnattQuery In ThisWorkbook.Worksheets(CStr(gnattSheetName)).QueryTables
            Set gnattWatcher = New BYHGnattQueryWatcher
            Set gnattWatcher.GnattQuery = gnattQuery
            gnattWatchers.Add gnattWatcher
        Next gnattQuery
    Next gnattSheetName
    ScheduleGnattSync
End Sub

Public Sub ReleaseGnattSync()
    If gnattPending Then
        On Error Resume Next
        Application.OnTime gnattDue, GnattCallback(), , False
        On Error GoTo 0
    End If
    gnattPending = False
    gnattWaitStarted = 0
    Set gnattWatchers = Nothing
    If gnattLastError <> "" Then Application.StatusBar = False
End Sub

Public Function GnattIsPending() As Boolean
    GnattIsPending = gnattBusy Or gnattPending
End Function

Public Function RunGnattForAutomation() As String
    On Error GoTo GnattAutomationFailed
    If SynchronizeGnatt() Then RunGnattForAutomation = "OK"
    Exit Function
GnattAutomationFailed:
    RunGnattForAutomation = "ERROR: " & Err.Description
End Function

Private Function GnattSorted(ByVal gnattEdits As ListObject) As Boolean
    Dim gnattValues As Variant, gnattPosition As Long, gnattOrderCol As Long, gnattIdCol As Long
    gnattValues = gnattEdits.DataBodyRange.Value2
    gnattOrderCol = gnattEdits.ListColumns("Order").Index
    gnattIdCol = gnattEdits.ListColumns("Index").Index
    For gnattPosition = 1 To UBound(gnattValues, 1)
        If IsError(gnattValues(gnattPosition, gnattOrderCol)) Or Not IsNumeric(gnattValues(gnattPosition, gnattOrderCol)) Then Err.Raise vbObjectError + 802, , "Invalid Order at record " & gnattPosition
        If IsError(gnattValues(gnattPosition, gnattIdCol)) Or Not IsNumeric(gnattValues(gnattPosition, gnattIdCol)) Then Err.Raise vbObjectError + 803, , "Invalid Index at record " & gnattPosition
        If gnattPosition > 1 Then
            If CDbl(gnattValues(gnattPosition - 1, gnattOrderCol)) > CDbl(gnattValues(gnattPosition, gnattOrderCol)) Then Exit Function
            If CDbl(gnattValues(gnattPosition - 1, gnattOrderCol)) = CDbl(gnattValues(gnattPosition, gnattOrderCol)) Then
                If CDbl(gnattValues(gnattPosition - 1, gnattIdCol)) > CDbl(gnattValues(gnattPosition, gnattIdCol)) Then Exit Function
            End If
        End If
    Next gnattPosition
    GnattSorted = True
End Function

Private Sub StabilizeGnattOrder(ByVal gnattEdits As ListObject)
    Dim gnattPass As Long
    gnattEdits.Parent.Calculate
    For gnattPass = 1 To 8
        If GnattSorted(gnattEdits) Then Exit Sub
        With gnattEdits.Sort
            .SortFields.Clear
            .SortFields.Add Key:=gnattEdits.ListColumns("Order").DataBodyRange, SortOn:=xlSortOnValues, Order:=xlAscending
            .SortFields.Add Key:=gnattEdits.ListColumns("Index").DataBodyRange, SortOn:=xlSortOnValues, Order:=xlAscending
            .Header = xlYes
            .Apply
        End With
        gnattEdits.Parent.Calculate
    Next gnattPass
    If Not GnattSorted(gnattEdits) Then Err.Raise vbObjectError + 804, , "Order formulas did not stabilize after eight sorts."
End Sub

Public Function GnattAligned() As Boolean
    Dim gnattLeft As ListObject, gnattRight As ListObject, gnattLeftIds As Variant, gnattRightIds As Variant
    Dim gnattPosition As Long, gnattSeen As Object, gnattKey As String
    Set gnattLeft = GnattTable("qryContractsToGnatt")
    Set gnattRight = GnattTable("Contract_Edits")
    If gnattLeft.ListRows.Count > gnattRight.ListRows.Count Then Exit Function
    If gnattLeft.HeaderRowRange.Row <> gnattRight.HeaderRowRange.Row Then Exit Function
    gnattLeftIds = gnattLeft.ListColumns("Index").DataBodyRange.Value2
    gnattRightIds = gnattRight.ListColumns("Index").DataBodyRange.Value2
    Set gnattSeen = CreateObject("Scripting.Dictionary")
    For gnattPosition = 1 To UBound(gnattLeftIds, 1)
        gnattKey = CStr(gnattLeftIds(gnattPosition, 1))
        If gnattSeen.Exists(gnattKey) Then Err.Raise vbObjectError + 805, , "Duplicate displayed Index " & gnattKey
        gnattSeen.Add gnattKey, True
        If gnattKey <> CStr(gnattRightIds(gnattPosition, 1)) Then Exit Function
    Next gnattPosition
    GnattAligned = True
End Function

Private Function GnattRecords(ByVal gnattEdits As ListObject) As Object
    Dim gnattRecordsMap As Object, gnattValues As Variant, gnattFormulas As Variant
    Dim gnattRow As Long, gnattCol As Long, gnattRecord As String
    Set gnattRecordsMap = CreateObject("Scripting.Dictionary")
    gnattValues = gnattEdits.DataBodyRange.Value2
    gnattFormulas = gnattEdits.DataBodyRange.Formula2
    For gnattRow = 1 To UBound(gnattValues, 1)
        gnattRecord = ""
        For gnattCol = 1 To UBound(gnattValues, 2)
            ' Preserve formulas, not their row-position-dependent cached results.
            gnattRecord = gnattRecord & GnattToken(gnattFormulas(gnattRow, gnattCol))
        Next gnattCol
        If gnattRecordsMap.Exists(gnattRecord) Then
            gnattRecordsMap(gnattRecord) = gnattRecordsMap(gnattRecord) + 1
        Else
            gnattRecordsMap.Add gnattRecord, 1
        End If
    Next gnattRow
    Set GnattRecords = gnattRecordsMap
End Function

Public Function SynchronizeGnatt() As Boolean
    Dim gnattEdits As ListObject, gnattView As ListObject, gnattRecordsBefore As Object, gnattRecordsAfter As Object
    Dim gnattEventsBefore As Boolean, gnattScreenBefore As Boolean, gnattCalcBefore As XlCalculation
    Dim gnattChangedState As Boolean, gnattErrorNumber As Long, gnattErrorText As String
    Dim gnattFeed As Variant, gnattKey As Variant, gnattAttempt As Long, gnattStage As String
    If gnattBusy Then Exit Function
    On Error GoTo GnattFailed
    gnattStage = "checking refresh state"
    If GnattRefreshing() Then Err.Raise vbObjectError + 806, , "A query is still refreshing. Try again after it finishes."
    gnattBusy = True
    If gnattPending Then
        Application.OnTime gnattDue, GnattCallback(), , False
        gnattPending = False
    End If
    Set gnattEdits = GnattTable("Contract_Edits")
    Set gnattView = GnattTable("qryContractsToGnatt")
    gnattStage = "checking tables"
    If gnattEdits.Parent.ProtectContents Then Err.Raise vbObjectError + 807, , "Gnatt Chart is protected."
    If Not gnattEdits.AutoFilter Is Nothing Then
        If gnattEdits.AutoFilter.FilterMode Then Err.Raise vbObjectError + 808, , "Clear Gnatt table filters before synchronizing."
    End If
    If Not gnattView.AutoFilter Is Nothing Then
        If gnattView.AutoFilter.FilterMode Then Err.Raise vbObjectError + 808, , "Clear Gnatt table filters before synchronizing."
    End If
    If IsNull(gnattEdits.DataBodyRange.EntireRow.Hidden) Then Err.Raise vbObjectError + 809, , "Unhide Gnatt record rows before synchronizing."
    If gnattEdits.DataBodyRange.EntireRow.Hidden Then Err.Raise vbObjectError + 809, , "Unhide Gnatt record rows before synchronizing."
    gnattStage = "capturing editable records"
    Set gnattRecordsBefore = GnattRecords(gnattEdits)
    gnattEventsBefore = Application.EnableEvents
    gnattScreenBefore = Application.ScreenUpdating
    gnattCalcBefore = Application.Calculation
    gnattChangedState = True
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual
    For gnattAttempt = 1 To 3
        gnattStage = "stabilizing Order"
        StabilizeGnattOrder gnattEdits
        gnattStage = "calculating query inputs"
        For Each gnattFeed In Array("Depends", "Glasgow", "Tim", "Others")
            ThisWorkbook.Worksheets(CStr(gnattFeed)).Calculate
        Next gnattFeed
        gnattStage = "refreshing Gnatt query"
        If Not gnattView.QueryTable.Refresh(False) Then Err.Raise vbObjectError + 810, , "Gnatt query refresh was cancelled."
        gnattStage = "verifying refreshed Index sequence"
        gnattEdits.Parent.Calculate
        If GnattSorted(gnattEdits) And GnattAligned() Then Exit For
    Next gnattAttempt
    If Not GnattAligned() Then Err.Raise vbObjectError + 811, , "Left and right Index sequences differ after refresh."
    If Not GnattSorted(gnattEdits) Then Err.Raise vbObjectError + 812, , "Order changed after refresh."
    Set gnattRecordsAfter = GnattRecords(gnattEdits)
    If gnattRecordsBefore.Count <> gnattRecordsAfter.Count Then Err.Raise vbObjectError + 813, , "Editable record preservation check failed."
    For Each gnattKey In gnattRecordsBefore.Keys
        If Not gnattRecordsAfter.Exists(gnattKey) Then Err.Raise vbObjectError + 813, , "An editable record changed during synchronization."
        If gnattRecordsBefore(gnattKey) <> gnattRecordsAfter(gnattKey) Then Err.Raise vbObjectError + 813, , "Editable record count changed."
    Next gnattKey
    Application.Calculation = gnattCalcBefore
    gnattLastState = GnattState()
    If gnattLastError <> "" Then Application.StatusBar = False
    gnattLastError = ""
    Application.EnableEvents = gnattEventsBefore
    Application.ScreenUpdating = gnattScreenBefore
    gnattBusy = False
    gnattWaitStarted = 0
    SynchronizeGnatt = True
    Exit Function
GnattFailed:
    gnattErrorNumber = Err.Number
    gnattErrorText = gnattStage & ": " & Err.Description
    On Error Resume Next
    If gnattChangedState Then
        Application.Calculation = gnattCalcBefore
        Application.EnableEvents = gnattEventsBefore
        Application.ScreenUpdating = gnattScreenBefore
    End If
    gnattBusy = False
    gnattWaitStarted = 0
    ReportGnattError gnattErrorText
    On Error GoTo 0
    Err.Raise gnattErrorNumber, "Gnatt synchronization", gnattErrorText
End Function
