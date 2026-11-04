Option Explicit

Private gnattBusy As Boolean
Private gnattPending As Boolean
Private gnattDue As Date
Private gnattWaitStarted As Date
Private gnattIdleSince As Date
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

Private Function GnattTableState(ByVal gnattStateTable As ListObject) As String
    Dim gnattData As Variant, gnattRow As Long, gnattCol As Long, gnattResult As String
    gnattResult = GnattToken(gnattStateTable.Name) & GnattToken(gnattStateTable.ListRows.Count)
    If gnattStateTable.DataBodyRange Is Nothing Then
        GnattTableState = gnattResult
        Exit Function
    End If
    gnattData = gnattStateTable.DataBodyRange.Value2
    For gnattRow = 1 To UBound(gnattData, 1)
        For gnattCol = 1 To UBound(gnattData, 2)
            gnattResult = gnattResult & GnattToken(gnattData(gnattRow, gnattCol))
        Next gnattCol
    Next gnattRow
    GnattTableState = gnattResult
End Function

Private Function GnattState() As String
    Dim gnattStateSheet As Variant, gnattStateTable As ListObject, gnattResult As String
    For Each gnattStateSheet In Array("Depends", "Glasgow", "Tim", "Others", "Gnatt Chart")
        For Each gnattStateTable In ThisWorkbook.Worksheets(CStr(gnattStateSheet)).ListObjects
            gnattResult = gnattResult & GnattTableState(gnattStateTable)
        Next gnattStateTable
    Next gnattStateSheet
    GnattState = gnattResult
End Function

Public Sub NoticeGnattSource(ByVal gnattChangedSheet As Object)
    Select Case gnattChangedSheet.Name
        Case "Depends", "Glasgow", "Tim", "Others", "Gnatt Chart"
            NoticeGnattCalculation
    End Select
End Sub

Public Sub NoticeGnattCalculation()
    If gnattBusy Or gnattPending Then Exit Sub
    On Error GoTo GnattNoticeFailed
    If GnattRefreshing() Then
        ScheduleGnattSync
        Exit Sub
    End If
    If GnattState() <> gnattLastState Or Not GnattRuleCurrent() Then ScheduleGnattSync
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
    Dim gnattSheet As Worksheet, gnattWatchedQuery As QueryTable
    Dim gnattConnection As WorkbookConnection
    For Each gnattConnection In ThisWorkbook.Connections
        If gnattConnection.Type = xlConnectionTypeOLEDB Then
            If gnattConnection.OLEDBConnection.Refreshing Then
                GnattRefreshing = True
                Exit Function
            End If
        End If
    Next gnattConnection
    For Each gnattSheet In ThisWorkbook.Worksheets
        For Each gnattWatchedQuery In gnattSheet.QueryTables
            If gnattWatchedQuery.Refreshing Then
                GnattRefreshing = True
                Exit Function
            End If
        Next gnattWatchedQuery
    Next gnattSheet
End Function

Public Sub RunScheduledGnatt()
    gnattPending = False
    On Error GoTo GnattScheduledFailed
    If Not Application.Ready Or Application.CalculationState = xlCalculating Or GnattRefreshing() Then
        gnattIdleSince = 0
        If DateDiff("s", gnattWaitStarted, Now) > 120 Then Err.Raise vbObjectError + 801, , "Refresh has not finished after two minutes."
        ScheduleGnattSync
        Exit Sub
    End If
    If gnattIdleSince = 0 Then gnattIdleSince = Now
    If DateDiff("s", gnattIdleSince, Now) < 2 Then
        ScheduleGnattSync
        Exit Sub
    End If
    gnattIdleSince = 0
    SynchronizeGnatt
    Exit Sub
GnattScheduledFailed:
    gnattWaitStarted = 0
    gnattIdleSince = 0
    ReportGnattError Err.Description
End Sub

Public Sub ReportGnattError(ByVal gnattMessage As String)
    gnattLastError = gnattMessage
    Application.StatusBar = "Gnatt Chart NOT synchronized: " & gnattMessage & " Check Index on both sides before editing."
End Sub

Public Sub InitializeGnattSync()
    Dim gnattSheetName As Variant, gnattWatchedQuery As QueryTable, gnattWatcher As BYHGnattQueryWatcher
    Set gnattWatchers = New Collection
    For Each gnattSheetName In Array("Depends", "Glasgow", "Tim", "Others", "Gnatt Chart")
        For Each gnattWatchedQuery In ThisWorkbook.Worksheets(CStr(gnattSheetName)).QueryTables
            Set gnattWatcher = New BYHGnattQueryWatcher
            Set gnattWatcher.GnattQuery = gnattWatchedQuery
            gnattWatchers.Add gnattWatcher
        Next gnattWatchedQuery
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
    gnattIdleSince = 0
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

Private Function GnattId(ByVal gnattValue As Variant) As String
    If IsError(gnattValue) Or IsEmpty(gnattValue) Or Not IsNumeric(gnattValue) Then Err.Raise vbObjectError + 802, , "Missing or invalid item Index."
    If CDbl(gnattValue) <= 0 Or CDbl(gnattValue) <> Fix(CDbl(gnattValue)) Then Err.Raise vbObjectError + 803, , "Index must be a positive whole number."
    GnattId = CStr(CDbl(gnattValue))
End Function

Private Sub AlignGnattRecords(ByVal gnattEdits As ListObject, ByVal gnattView As ListObject)
    Dim gnattPositions As Object, gnattCounts As Object, gnattLeftIds As Variant, gnattRightIds As Variant
    Dim gnattRow As Long, gnattKey As Variant, gnattSortValues() As Variant
    Dim gnattScratch As Range, gnattScratchFormulas As Variant, gnattFormula As String
    Dim gnattScratchWritten As Boolean, gnattSortError As Long, gnattSortMessage As String
    On Error GoTo GnattAlignFailed
    Set gnattPositions = CreateObject("Scripting.Dictionary")
    Set gnattCounts = CreateObject("Scripting.Dictionary")
    gnattLeftIds = gnattView.ListColumns("Index").DataBodyRange.Value2
    gnattRightIds = gnattEdits.ListColumns("Index").DataBodyRange.Value2
    For gnattRow = 1 To UBound(gnattLeftIds, 1)
        gnattKey = GnattId(gnattLeftIds(gnattRow, 1))
        If gnattPositions.Exists(gnattKey) Then Err.Raise vbObjectError + 805, , "Duplicate displayed Index " & gnattKey
        gnattPositions.Add gnattKey, gnattRow
    Next gnattRow
    ReDim gnattSortValues(1 To UBound(gnattRightIds, 1), 1 To 1)
    For gnattRow = 1 To UBound(gnattRightIds, 1)
        gnattKey = GnattId(gnattRightIds(gnattRow, 1))
        If gnattCounts.Exists(gnattKey) Then
            gnattCounts(gnattKey) = gnattCounts(gnattKey) + 1
        Else
            gnattCounts.Add gnattKey, 1
        End If
        If gnattPositions.Exists(gnattKey) Then
            gnattSortValues(gnattRow, 1) = gnattPositions(gnattKey)
        Else
            gnattSortValues(gnattRow, 1) = gnattPositions.Count + gnattRow
        End If
    Next gnattRow
    For Each gnattKey In gnattPositions.Keys
        If Not gnattCounts.Exists(gnattKey) Then Err.Raise vbObjectError + 814, , "No editable record for displayed Index " & gnattKey
        If gnattCounts(gnattKey) <> 1 Then Err.Raise vbObjectError + 815, , "Duplicate editable records for displayed Index " & gnattKey
    Next gnattKey
    Set gnattScratch = gnattEdits.ListColumns("RowPos").DataBodyRange
    gnattScratchFormulas = gnattScratch.Formula2
    gnattFormula = CStr(gnattScratchFormulas(1, 1))
    If gnattFormula <> "=ROW()-ROW(Contract_Edits[#Headers])" Then Err.Raise vbObjectError + 816, , "RowPos has a nonstandard formula; no records were moved."
    For gnattRow = 1 To UBound(gnattScratchFormulas, 1)
        If CStr(gnattScratchFormulas(gnattRow, 1)) <> gnattFormula Then Err.Raise vbObjectError + 816, , "RowPos contains an exception; no records were moved."
    Next gnattRow
    ' Reuse the calculated position column only while events/calculation are suspended.
    ' Restore its exact formula before any calculation, refresh, return or save.
    gnattScratchWritten = True
    gnattScratch.Value2 = gnattSortValues
    With gnattEdits.Sort
        .SortFields.Clear
        .SortFields.Add Key:=gnattScratch, SortOn:=xlSortOnValues, Order:=xlAscending
        .Header = xlYes
        .Apply
    End With
    gnattScratch.Formula2 = gnattFormula
    Exit Sub
GnattAlignFailed:
    gnattSortError = Err.Number
    gnattSortMessage = Err.Description
    If gnattScratchWritten Then
        On Error Resume Next
        gnattScratch.Formula2 = gnattFormula
        If Err.Number <> 0 Then gnattSortMessage = gnattSortMessage & " RowPos restoration failed; do not save this workbook."
        On Error GoTo 0
    End If
    Err.Raise gnattSortError, "Gnatt record alignment", gnattSortMessage
End Sub

Private Function GnattMismatchRange() As Range
    Dim gnattFirstRow As Long
    gnattFirstRow = GnattTable("qryContractsToGnatt").HeaderRowRange.Row + 1
    Set GnattMismatchRange = ThisWorkbook.Worksheets("Gnatt Chart").Range("K" & gnattFirstRow & ":K" & ThisWorkbook.Worksheets("Gnatt Chart").Rows.Count)
End Function

Private Function GnattMismatchFormula() As String
    Dim gnattFirstRow As Long
    gnattFirstRow = GnattTable("qryContractsToGnatt").HeaderRowRange.Row + 1
    GnattMismatchFormula = "=AND($J" & gnattFirstRow & "<>"""",$J" & gnattFirstRow & "<>$L" & gnattFirstRow & ")"
End Function

Public Function GnattRuleCurrent() As Boolean
    Dim gnattRange As Range, gnattRule As FormatCondition
    Set gnattRange = GnattMismatchRange()
    If gnattRange.FormatConditions.Count <> 1 Then Exit Function
    Set gnattRule = gnattRange.FormatConditions(1)
    If gnattRule.Type <> xlExpression Then Exit Function
    If gnattRule.AppliesTo.Address <> gnattRange.Address Then Exit Function
    GnattRuleCurrent = gnattRule.Formula1 = GnattMismatchFormula()
End Function

Public Sub EnsureGnattMismatchRule()
    Dim gnattRange As Range, gnattRule As FormatCondition
    If GnattRuleCurrent() Then Exit Sub
    Set gnattRange = GnattMismatchRange()
    gnattRange.FormatConditions.Delete
    Set gnattRule = gnattRange.FormatConditions.Add(Type:=xlExpression, Formula1:=GnattMismatchFormula())
    gnattRule.Interior.Color = RGB(255, 0, 0)
    gnattRule.StopIfTrue = False
End Sub

Private Function GnattSaveFilters(ByVal gnattSource As ListObject) As Collection
    Dim gnattSaved As New Collection, gnattFilter As Filter, gnattField As Long
    Dim gnattFirst As Variant, gnattSecond As Variant, gnattHasFirst As Boolean, gnattHasSecond As Boolean
    If Not gnattSource.AutoFilter Is Nothing Then
        For gnattField = 1 To gnattSource.AutoFilter.Filters.Count
            Set gnattFilter = gnattSource.AutoFilter.Filters(gnattField)
            If gnattFilter.On Then
                If gnattFilter.Operator <> 0 And gnattFilter.Operator <> xlAnd And gnattFilter.Operator <> xlOr And gnattFilter.Operator <> xlFilterValues Then Err.Raise vbObjectError + 808, , "Clear special color/icon/top-ten Gnatt filters before synchronizing."
                gnattFirst = Empty: gnattSecond = Empty
                On Error Resume Next
                Err.Clear
                gnattFirst = gnattFilter.Criteria1
                gnattHasFirst = Err.Number = 0
                Err.Clear
                gnattSecond = gnattFilter.Criteria2
                gnattHasSecond = Err.Number = 0
                On Error GoTo 0
                If Not gnattHasFirst And Not gnattHasSecond Then Err.Raise vbObjectError + 808, , "Cannot preserve this Gnatt filter safely."
                gnattSaved.Add Array(gnattField, gnattFilter.Operator, gnattHasFirst, gnattFirst, gnattHasSecond, gnattSecond)
            End If
        Next gnattField
    End If
    Set GnattSaveFilters = gnattSaved
End Function

Private Sub GnattRestoreFilters(ByVal gnattSource As ListObject, ByVal gnattSaved As Collection)
    Dim gnattEntry As Variant
    For Each gnattEntry In gnattSaved
        If gnattEntry(1) = 0 And gnattEntry(2) Then
            gnattSource.Range.AutoFilter Field:=gnattEntry(0), Criteria1:=gnattEntry(3)
        ElseIf gnattEntry(2) And gnattEntry(4) Then
            gnattSource.Range.AutoFilter Field:=gnattEntry(0), Criteria1:=gnattEntry(3), Operator:=gnattEntry(1), Criteria2:=gnattEntry(5)
        ElseIf gnattEntry(2) Then
            gnattSource.Range.AutoFilter Field:=gnattEntry(0), Criteria1:=gnattEntry(3), Operator:=gnattEntry(1)
        Else
            gnattSource.Range.AutoFilter Field:=gnattEntry(0), Operator:=gnattEntry(1), Criteria2:=gnattEntry(5)
        End If
    Next gnattEntry
End Sub

Public Function GnattAligned() As Boolean
    Dim gnattLeft As ListObject, gnattRight As ListObject, gnattLeftIds As Variant, gnattRightIds As Variant
    Dim gnattPosition As Long, gnattSeen As Object, gnattRightCounts As Object, gnattKey As String
    Set gnattLeft = GnattTable("qryContractsToGnatt")
    Set gnattRight = GnattTable("Contract_Edits")
    If gnattLeft.ListRows.Count > gnattRight.ListRows.Count Then Exit Function
    If gnattLeft.HeaderRowRange.Row <> gnattRight.HeaderRowRange.Row Then Exit Function
    gnattLeftIds = gnattLeft.ListColumns("Index").DataBodyRange.Value2
    gnattRightIds = gnattRight.ListColumns("Index").DataBodyRange.Value2
    Set gnattSeen = CreateObject("Scripting.Dictionary")
    Set gnattRightCounts = CreateObject("Scripting.Dictionary")
    For gnattPosition = 1 To UBound(gnattRightIds, 1)
        gnattKey = GnattId(gnattRightIds(gnattPosition, 1))
        If gnattRightCounts.Exists(gnattKey) Then
            gnattRightCounts(gnattKey) = gnattRightCounts(gnattKey) + 1
        Else
            gnattRightCounts.Add gnattKey, 1
        End If
    Next gnattPosition
    For gnattPosition = 1 To UBound(gnattLeftIds, 1)
        gnattKey = GnattId(gnattLeftIds(gnattPosition, 1))
        If gnattSeen.Exists(gnattKey) Then Err.Raise vbObjectError + 805, , "Duplicate displayed Index " & gnattKey
        gnattSeen.Add gnattKey, True
        If Not gnattRightCounts.Exists(gnattKey) Then Err.Raise vbObjectError + 814, , "No editable record for displayed Index " & gnattKey
        If gnattRightCounts(gnattKey) <> 1 Then Err.Raise vbObjectError + 815, , "Duplicate editable records for displayed Index " & gnattKey
        If gnattKey <> GnattId(gnattRightIds(gnattPosition, 1)) Then Exit Function
    Next gnattPosition
    GnattAligned = True
End Function

Private Function GnattRecords(ByVal gnattEdits As ListObject) As Object
    Dim gnattRecordsMap As Object, gnattValues As Variant, gnattFormulas As Variant
    Dim gnattRow As Long, gnattCol As Long, gnattRecord As String, gnattIndexCol As Long, gnattIndexFormulas As Variant
    Set gnattRecordsMap = CreateObject("Scripting.Dictionary")
    gnattValues = gnattEdits.DataBodyRange.Value2
    gnattFormulas = gnattEdits.DataBodyRange.Formula2
    gnattIndexCol = gnattEdits.ListColumns("Index").Index
    gnattIndexFormulas = gnattEdits.ListColumns("Index").DataBodyRange.Formula2R1C1
    For gnattRow = 1 To UBound(gnattValues, 1)
        gnattRecord = ""
        For gnattCol = 1 To UBound(gnattValues, 2)
            ' Preserve formulas, not their row-position-dependent cached results.
            If gnattCol = gnattIndexCol Then
                ' A legacy Index formula may move with its referenced record.
                ' Require both its relative formula and evaluated identity to survive.
                gnattRecord = gnattRecord & GnattToken(gnattIndexFormulas(gnattRow, 1)) & GnattToken(gnattValues(gnattRow, gnattCol))
            Else
                gnattRecord = gnattRecord & GnattToken(gnattFormulas(gnattRow, gnattCol))
            End If
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
    Dim gnattFeed As Variant, gnattKey As Variant, gnattAttempt As Long, gnattStage As String, gnattStable As Boolean
    Dim gnattViewFilters As Collection, gnattEditFilters As Collection, gnattFiltersChanged As Boolean
    Dim gnattManualHidden() As Boolean, gnattRow As Long
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
    Set gnattViewFilters = GnattSaveFilters(gnattView)
    Set gnattEditFilters = GnattSaveFilters(gnattEdits)
    gnattStage = "capturing editable records"
    Set gnattRecordsBefore = GnattRecords(gnattEdits)
    gnattEventsBefore = Application.EnableEvents
    gnattScreenBefore = Application.ScreenUpdating
    gnattCalcBefore = Application.Calculation
    gnattChangedState = True
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual
    ReDim gnattManualHidden(1 To gnattEdits.ListRows.Count)
    gnattFiltersChanged = True
    If gnattViewFilters.Count > 0 Then gnattView.AutoFilter.ShowAllData
    If gnattEditFilters.Count > 0 Then gnattEdits.AutoFilter.ShowAllData
    For gnattRow = 1 To gnattEdits.ListRows.Count
        gnattManualHidden(gnattRow) = gnattEdits.ListRows(gnattRow).Range.EntireRow.Hidden
    Next gnattRow
    gnattEdits.DataBodyRange.EntireRow.Hidden = False
    gnattStage = "maintaining the column K rule"
    EnsureGnattMismatchRule
    For gnattAttempt = 1 To 8
        gnattStage = "calculating Order"
        gnattEdits.Parent.Calculate
        gnattStage = "calculating query inputs"
        For Each gnattFeed In Array("Depends", "Glasgow", "Tim", "Others")
            ThisWorkbook.Worksheets(CStr(gnattFeed)).Calculate
        Next gnattFeed
        gnattStage = "refreshing Gnatt query"
        If Not gnattView.QueryTable.Refresh(False) Then Err.Raise vbObjectError + 810, , "Gnatt query refresh was cancelled."
        gnattStage = "verifying refreshed Index sequence"
        If GnattAligned() Then
            gnattStable = True
            Exit For
        End If
        gnattStage = "placing active records before unused records"
        AlignGnattRecords gnattEdits, gnattView
    Next gnattAttempt
    If Not gnattStable Then Err.Raise vbObjectError + 811, , "Displayed Index order did not stabilize after eight passes."
    EnsureGnattMismatchRule
    Set gnattRecordsAfter = GnattRecords(gnattEdits)
    If gnattRecordsBefore.Count <> gnattRecordsAfter.Count Then Err.Raise vbObjectError + 813, , "Editable record preservation check failed."
    For Each gnattKey In gnattRecordsBefore.Keys
        If Not gnattRecordsAfter.Exists(gnattKey) Then Err.Raise vbObjectError + 813, , "An editable record changed during synchronization."
        If gnattRecordsBefore(gnattKey) <> gnattRecordsAfter(gnattKey) Then Err.Raise vbObjectError + 813, , "Editable record count changed."
    Next gnattKey
    GnattRestoreFilters gnattEdits, gnattEditFilters
    GnattRestoreFilters gnattView, gnattViewFilters
    For gnattRow = 1 To UBound(gnattManualHidden)
        If gnattManualHidden(gnattRow) Then gnattEdits.ListRows(gnattRow).Range.EntireRow.Hidden = True
    Next gnattRow
    gnattFiltersChanged = False
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
    If gnattFiltersChanged Then
        GnattRestoreFilters gnattEdits, gnattEditFilters
        GnattRestoreFilters gnattView, gnattViewFilters
        For gnattRow = 1 To UBound(gnattManualHidden)
            If gnattManualHidden(gnattRow) Then gnattEdits.ListRows(gnattRow).Range.EntireRow.Hidden = True
        Next gnattRow
    End If
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
