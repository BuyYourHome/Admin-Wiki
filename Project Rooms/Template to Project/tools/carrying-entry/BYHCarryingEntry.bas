Attribute VB_Name = "BYHCarryingEntry"
Option Explicit

Private mBusy As Boolean

Private Function InputCell(ByVal entryFieldName As String) As Range
    Set InputCell = ThisWorkbook.Names("ce" & entryFieldName).RefersToRange
End Function

Private Function TextInput(ByVal entryFieldName As String) As String
    TextInput = Trim$(CStr(InputCell(entryFieldName).Value2))
End Function

Private Function ExpenseTable() As ListObject
    Dim ws As Worksheet, lo As ListObject
    For Each ws In ThisWorkbook.Worksheets
        For Each lo In ws.ListObjects
            If lo.Name = "tblCarryingExpenses" Then
                Set ExpenseTable = lo
                Exit Function
            End If
        Next lo
    Next ws
    Err.Raise vbObjectError + 501, , "Cannot find tblCarryingExpenses."
End Function

Private Function SameText(ByVal a As Variant, ByVal b As Variant) As Boolean
    If IsError(a) Or IsError(b) Then Exit Function
    SameText = (StrComp(Trim$(CStr(a)), Trim$(CStr(b)), vbTextCompare) = 0)
End Function

Public Sub CarryingEntry_Insert()
    Dim result As String
    result = CarryingEntry_Submit()
End Sub

Public Function CarryingEntry_Submit() As String
    Dim lo As ListObject, added As ListRow, r As ListRow
    Dim headers As Variant, values As Variant, cols(0 To 10) As Long
    Dim i As Long, d As Double, amount As Double, category As String
    Dim vendor As String, description As String, invoice As String
    Dim source As String, status As String, include As String
    Dim result As String, categories As String, matched As Boolean
    Dim oldEvents As Boolean, oldScreen As Boolean, stateChanged As Boolean
    Dim committed As Boolean, failure As String, visibleCount As Long
    If mBusy Then
        CarryingEntry_Submit = "Entry already in progress."
        Exit Function
    End If
    mBusy = True
    On Error GoTo Failed
    Set lo = ExpenseTable()
    If ThisWorkbook.ReadOnly Or lo.Parent.ProtectContents Then
        result = "Not inserted: workbook is read-only or Carrying is protected."
        GoTo Finished
    End If
    headers = Array("Include", "Category", "Date", "Vendor", "Description", _
                    "Amount", "Source", "Invoice #", "Source File", "Status", "Notes")
    For i = 0 To 10
        cols(i) = lo.ListColumns(CStr(headers(i))).Index
    Next i
    If Len(TextInput("Date")) = 0 Or Not IsDate(InputCell("Date").Value) Then
        result = "Not inserted: enter a valid Date."
        GoTo Finished
    End If
    d = CDbl(DateValue(CDate(InputCell("Date").Value)))
    If ThisWorkbook.Date1904 Then d = d - 1462
    category = TextInput("Category")
    categories = CStr(Application.Evaluate(ThisWorkbook.Names("ceCategories").RefersTo))
    matched = False
    For Each values In Split(categories, ",")
        If SameText(category, values) Then
            category = CStr(values)
            matched = True
            Exit For
        End If
    Next values
    If Not matched Then
        result = "Not inserted: select a Category from the list."
        GoTo Finished
    End If
    vendor = TextInput("Vendor")
    description = TextInput("Description")
    If Len(vendor) = 0 Or Len(description) = 0 Then
        result = "Not inserted: Vendor and Description are required."
        GoTo Finished
    End If
    If Len(TextInput("Amount")) = 0 Or Not IsNumeric(InputCell("Amount").Value2) Then
        result = "Not inserted: enter a numeric Amount (credits may be negative)."
        GoTo Finished
    End If
    amount = CDbl(InputCell("Amount").Value2)
    include = "No"
    If VarType(InputCell("Include").Value2) <> vbBoolean Then
        result = "Not inserted: use the Include checkbox."
        GoTo Finished
    End If
    If InputCell("Include").Value2 Then include = "Yes"
    invoice = TextInput("Invoice")
    source = TextInput("Source")
    If source = "" Then source = "Manual Entry"
    status = TextInput("Status")
    If status = "" Then status = "Entered"

    ' Inspect all records, including filtered, hidden and excluded records.
    For Each r In lo.ListRows
        If SameText(r.Range.Cells(1, cols(3)).Value2, vendor) Then
            If Not IsError(r.Range.Cells(1, cols(5)).Value2) Then
                If IsNumeric(r.Range.Cells(1, cols(5)).Value2) And _
                   Len(CStr(r.Range.Cells(1, cols(5)).Value2)) > 0 Then
                    If Abs(CDbl(r.Range.Cells(1, cols(5)).Value2) - amount) < 0.005 Then
                        matched = False
                        If invoice <> "" And SameText(r.Range.Cells(1, cols(7)).Value2, invoice) Then matched = True
                        If SameText(r.Range.Cells(1, cols(1)).Value2, category) And _
                           SameText(r.Range.Cells(1, cols(2)).Value2, d) Then matched = True
                        If matched Then
                            result = "Not inserted: possible duplicate in table row " & r.Index & ". Review that record first."
                            GoTo Finished
                        End If
                    End If
                End If
            End If
        End If
    Next r

    values = Array(include, category, d, vendor, description, amount, source, _
                   invoice, TextInput("SourceFile"), status, TextInput("Notes"))
    oldEvents = Application.EnableEvents
    oldScreen = Application.ScreenUpdating
    stateChanged = True
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Set added = lo.ListRows.Add(AlwaysInsert:=False)
    For i = 0 To 10
        With added.Range.Cells(1, cols(i))
            If i <> 2 And i <> 5 Then .NumberFormat = "@"
            .Value2 = values(i)
        End With
    Next i
    added.Range.Cells(1, cols(2)).NumberFormat = "m/d/yyyy"
    added.Range.Cells(1, cols(5)).NumberFormat = "#,##0.00;[Red](#,##0.00)"
    For i = 0 To 10
        If added.Range.Cells(1, cols(i)).HasFormula Or _
           Not SameText(added.Range.Cells(1, cols(i)).Value2, values(i)) Then
            Err.Raise vbObjectError + 502, , "Record verification failed."
        End If
    Next i
    committed = True
    For Each values In Array("Date", "Category", "Vendor", "Description", "Amount", "Invoice", "SourceFile", "Notes")
        InputCell(CStr(values)).MergeArea.ClearContents
    Next values
    InputCell("Source").Value2 = "Manual Entry"
    InputCell("Status").Value2 = "Entered"
    InputCell("Include").Value2 = True
    result = "Inserted " & category & ": " & Format$(amount, "$#,##0.00;($#,##0.00)") & "."
    For Each r In lo.ListRows
        If SameText(r.Range.Cells(1, cols(0)).Value2, "Yes") And _
           SameText(r.Range.Cells(1, cols(1)).Value2, category) Then visibleCount = visibleCount + 1
    Next r
    If visibleCount > CLng(Application.Evaluate(ThisWorkbook.Names("ceDisplayCapacity").RefersTo)) Then
        result = result & " Category exceeds grid capacity; see source table. Total includes every included row."
    End If
    GoTo Finished
Failed:
    failure = Err.Description
    If committed Then
        result = "Record inserted, but form cleanup failed. Do not re-enter. " & failure
    ElseIf Not added Is Nothing Then
        On Error Resume Next
        Err.Clear
        added.Delete
        If Err.Number = 0 Then
            result = "Not inserted; new row rolled back. " & failure
        Else
            result = "Insertion uncertain. Inspect the last table row before retrying. " & failure
        End If
        On Error GoTo 0
    Else
        result = "Not inserted: " & failure
    End If
Finished:
    On Error Resume Next
    If stateChanged Then
        Application.EnableEvents = oldEvents
        Application.ScreenUpdating = oldScreen
    End If
    InputCell("Feedback").Value2 = result
    mBusy = False
    CarryingEntry_Submit = result
End Function
