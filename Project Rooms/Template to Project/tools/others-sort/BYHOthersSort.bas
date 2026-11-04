Option Explicit

Private sortBusy As Boolean
Private sortWatcher As BYHOthersQueryWatcher
Private lastSortError As String
Private syncScheduled As Boolean
Private syncTime As Date

Private Function SyncCallback() As String
    SyncCallback = "'" & Replace(ThisWorkbook.Name, "'", "''") & "'!BYHOthersSort.ScheduledSync"
End Function

Public Sub ScheduleOthersSync()
    If sortBusy Or syncScheduled Then Exit Sub
    syncTime = Now + TimeSerial(0, 0, 1)
    Application.OnTime syncTime, SyncCallback()
    syncScheduled = True
End Sub

Public Sub ScheduledSync()
    syncScheduled = False
    If SortTable("tblContractOthers").QueryTable.Refreshing Then
        ScheduleOthersSync
    Else
        TrySyncOthersPrices
    End If
End Sub

Private Function SortTable(ByVal tableName As String) As ListObject
    Set SortTable = ThisWorkbook.Worksheets("Others").ListObjects(tableName)
End Function

Private Function IndexKey(ByVal indexValue As Variant) As String
    If IsError(indexValue) Or IsEmpty(indexValue) Or Not IsNumeric(indexValue) Then Err.Raise vbObjectError + 701, , "Missing or invalid item Index."
    If CDbl(indexValue) <= 0 Or CDbl(indexValue) <> Fix(CDbl(indexValue)) Then Err.Raise vbObjectError + 702, , "Index must be a positive whole number."
    IndexKey = CStr(CDbl(indexValue))
End Function

Private Function SavedFilters(ByVal sourceTable As ListObject) As Collection
    Dim saved As New Collection, filterNumber As Long, activeFilter As Filter
    Dim firstCriterion As Variant, secondCriterion As Variant, hasFirst As Boolean, hasSecond As Boolean
    For filterNumber = 1 To sourceTable.AutoFilter.Filters.Count
        Set activeFilter = sourceTable.AutoFilter.Filters(filterNumber)
        If activeFilter.On Then
            If activeFilter.Operator <> 0 And activeFilter.Operator <> xlAnd And activeFilter.Operator <> xlOr And activeFilter.Operator <> xlFilterValues Then
                Err.Raise vbObjectError + 714, , "Use a value/text filter on the main table, or clear its special filter before aligning prices."
            End If
            firstCriterion = Empty: secondCriterion = Empty
            On Error Resume Next
            Err.Clear
            firstCriterion = activeFilter.Criteria1
            hasFirst = Err.Number = 0
            Err.Clear
            secondCriterion = activeFilter.Criteria2
            hasSecond = Err.Number = 0
            On Error GoTo 0
            If Not hasFirst And Not hasSecond Then Err.Raise vbObjectError + 715, , "Cannot safely preserve the main table filter."
            saved.Add Array(filterNumber, activeFilter.Operator, hasFirst, firstCriterion, hasSecond, secondCriterion)
        End If
    Next filterNumber
    Set SavedFilters = saved
End Function

Private Sub RestoreFilters(ByVal sourceTable As ListObject, ByVal saved As Collection)
    Dim entry As Variant
    For Each entry In saved
        If entry(1) = 0 And entry(2) Then
            sourceTable.Range.AutoFilter Field:=entry(0), Criteria1:=entry(3)
        ElseIf entry(2) And entry(4) Then
            sourceTable.Range.AutoFilter Field:=entry(0), Criteria1:=entry(3), Operator:=entry(1), Criteria2:=entry(5)
        ElseIf entry(2) Then
            sourceTable.Range.AutoFilter Field:=entry(0), Criteria1:=entry(3), Operator:=entry(1)
        Else
            sourceTable.Range.AutoFilter Field:=entry(0), Operator:=entry(1), Criteria2:=entry(5)
        End If
    Next entry
End Sub

Public Sub InitializeOthersSort()
    If sortWatcher Is Nothing Then
        Set sortWatcher = New BYHOthersQueryWatcher
        Set sortWatcher.SourceQuery = SortTable("tblContractOthers").QueryTable
    End If
    TrySyncOthersPrices
End Sub

Public Sub ReleaseOthersSort()
    If syncScheduled Then
        On Error Resume Next
        Application.OnTime syncTime, SyncCallback(), , False
        On Error GoTo 0
        syncScheduled = False
    End If
    Set sortWatcher = Nothing
    If lastSortError <> "" Then Application.StatusBar = False
End Sub

Public Sub TrySyncOthersPrices()
    On Error GoTo Failed
    If SyncOthersPrices() Then
        If lastSortError <> "" Then Application.StatusBar = False
        lastSortError = ""
    End If
    Exit Sub
Failed:
    lastSortError = Err.Description
    Application.StatusBar = "Others prices NOT aligned: " & lastSortError & " Use the Index labels; saved prices have not been reassigned."
End Sub

Public Function SyncOthersPrices(Optional ByVal forceSort As Boolean = False) As Boolean
    Dim source As ListObject, target As ListObject, positions As Object, existing As Object
    Dim oldPrices As Object, mainCount As Long, i As Long, itemKey As String, aligned As Boolean
    Dim targetId As Long, targetPrice As Long, targetItem As Long, targetNote As Long, orderCol As Long
    Dim sourceId As Long, sourceTitle As Long, overrideRow As ListRow, newRow As ListRow
    Dim eventsBefore As Boolean, screenBefore As Boolean, changedState As Boolean
    Dim errorNumber As Long, errorText As String, itemFormula As Variant, nextRange As Range
    Dim filtersBefore As Collection, filtersCleared As Boolean, hiddenBefore() As Boolean
    Dim calculationBefore As XlCalculation, orderValues() As Variant
    If sortBusy Then Exit Function
    On Error GoTo Failed
    sortBusy = True
    Set source = SortTable("tblContractOthers")
    Set target = SortTable("tblOthersPriceOverrides")
    If source.QueryTable.Refreshing Then GoTo Finished
    If source.HeaderRowRange.Row <> target.HeaderRowRange.Row Then Err.Raise vbObjectError + 703, , "The two table headers must start on the same row."
    If target.Parent.ProtectContents Then Err.Raise vbObjectError + 704, , "Others is protected."
    sourceId = source.ListColumns("Index").Index
    sourceTitle = source.ListColumns("Title").Index
    targetId = target.ListColumns("Index").Index
    targetPrice = target.ListColumns("Unit Price Override").Index
    targetItem = target.ListColumns("Item").Index
    targetNote = target.ListColumns("Mapping Note").Index
    orderCol = target.ListColumns("_Display Order").Index
    Set positions = CreateObject("Scripting.Dictionary")
    Set existing = CreateObject("Scripting.Dictionary")
    Set oldPrices = CreateObject("Scripting.Dictionary")
    mainCount = source.ListRows.Count
    For i = 1 To mainCount
        itemKey = IndexKey(source.ListRows(i).Range.Cells(1, sourceId).Value2)
        If positions.Exists(itemKey) Then Err.Raise vbObjectError + 705, , "Duplicate Index in the main table: " & itemKey
        positions.Add itemKey, i
    Next i
    aligned = target.ListRows.Count >= mainCount
    For i = 1 To target.ListRows.Count
        itemKey = IndexKey(target.ListRows(i).Range.Cells(1, targetId).Value2)
        If existing.Exists(itemKey) Then Err.Raise vbObjectError + 706, , "Duplicate Index in the override table: " & itemKey
        existing.Add itemKey, i
        itemFormula = target.ListRows(i).Range.Cells(1, targetPrice).Formula2
        oldPrices.Add itemKey, itemFormula
        If i <= mainCount Then
            If Not positions.Exists(itemKey) Then
                aligned = False
            ElseIf positions(itemKey) <> i Then
                aligned = False
            End If
        End If
    Next i
    If aligned And Not forceSort Then
        SyncOthersPrices = True
        GoTo Finished
    End If
    If target.AutoFilter.FilterMode Then Err.Raise vbObjectError + 707, , "Clear the override table filter before synchronizing. Filter the main table instead."
    Set filtersBefore = SavedFilters(source)
    ReDim hiddenBefore(1 To target.ListRows.Count)
    For i = 1 To target.ListRows.Count
        hiddenBefore(i) = target.ListRows(i).Range.EntireRow.Hidden
    Next i
    eventsBefore = Application.EnableEvents
    screenBefore = Application.ScreenUpdating
    calculationBefore = Application.Calculation
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    changedState = True
    Application.Calculation = xlCalculationManual
    ' A filter on the adjacent table hides whole worksheet rows. Native Sort would skip them.
    If source.AutoFilter.FilterMode Then
        source.AutoFilter.ShowAllData
        filtersCleared = True
    End If
    target.DataBodyRange.EntireRow.Hidden = False
    ' Add missing indexes without replacing any existing price or deleting inactive records.
    For i = 1 To mainCount
        itemKey = IndexKey(source.ListRows(i).Range.Cells(1, sourceId).Value2)
        If Not existing.Exists(itemKey) Then
            Set nextRange = target.Range.Rows(target.Range.Rows.Count).Offset(1)
            If Application.CountA(nextRange) <> 0 Then Err.Raise vbObjectError + 708, , "Content below the override table blocks adding a new item."
            Set newRow = target.ListRows.Add(AlwaysInsert:=False)
            newRow.Range.Cells(1, targetId).Value2 = CDbl(itemKey)
            newRow.Range.Cells(1, targetItem).Value2 = source.ListRows(i).Range.Cells(1, sourceTitle).Value2
            newRow.Range.Cells(1, targetPrice).ClearContents
            newRow.Range.Cells(1, targetNote).Value2 = "New Index; blank override uses Contract price"
            existing.Add itemKey, newRow.Index
        End If
    Next i
    ReDim orderValues(1 To target.ListRows.Count, 1 To 1)
    For i = 1 To target.ListRows.Count
        Set overrideRow = target.ListRows(i)
        itemKey = IndexKey(overrideRow.Range.Cells(1, targetId).Value2)
        If positions.Exists(itemKey) Then
            orderValues(i, 1) = positions(itemKey)
        Else
            orderValues(i, 1) = mainCount + i
        End If
    Next i
    target.ListColumns("_Display Order").DataBodyRange.Value2 = orderValues
    With target.Sort
        .SortFields.Clear
        .SortFields.Add Key:=target.ListColumns("_Display Order").DataBodyRange, SortOn:=xlSortOnValues, Order:=xlAscending
        .Header = xlYes
        .Apply
    End With
    For i = 1 To target.ListRows.Count
        itemKey = IndexKey(target.ListRows(i).Range.Cells(1, targetId).Value2)
        If oldPrices.Exists(itemKey) Then
            itemFormula = target.ListRows(i).Range.Cells(1, targetPrice).Formula2
            If VarType(itemFormula) <> VarType(oldPrices(itemKey)) Or CStr(itemFormula) <> CStr(oldPrices(itemKey)) Then Err.Raise vbObjectError + 709, , "Price preservation check failed for Index " & itemKey
        End If
        If i <= mainCount Then
            If itemKey <> IndexKey(source.ListRows(i).Range.Cells(1, sourceId).Value2) Then Err.Raise vbObjectError + 710, , "Table alignment verification failed."
        End If
    Next i
    If mainCount > 0 Then source.ListColumns("Unit Price 2").DataBodyRange.Calculate
    SyncOthersPrices = True
Finished:
    If changedState Then
        If filtersCleared Then RestoreFilters source, filtersBefore
        For i = 1 To UBound(hiddenBefore)
            target.ListRows(i).Range.EntireRow.Hidden = hiddenBefore(i)
        Next i
    End If
    If changedState Then
        Application.Calculation = calculationBefore
        Application.EnableEvents = eventsBefore
        Application.ScreenUpdating = screenBefore
    End If
    sortBusy = False
    Exit Function
Failed:
    errorNumber = Err.Number
    errorText = Err.Description
    On Error Resume Next
    If changedState Then
        If filtersCleared Then RestoreFilters source, filtersBefore
        For i = 1 To UBound(hiddenBefore)
            target.ListRows(i).Range.EntireRow.Hidden = hiddenBefore(i)
        Next i
    End If
    If changedState Then
        Application.Calculation = calculationBefore
        Application.EnableEvents = eventsBefore
        Application.ScreenUpdating = screenBefore
    End If
    sortBusy = False
    On Error GoTo 0
    Err.Raise errorNumber, "Others price alignment", errorText
End Function
