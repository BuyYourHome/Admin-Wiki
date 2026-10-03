Attribute VB_Name = "BYHCarryingEdit"
Option Explicit

Private editLoaded As Boolean
Private editBusy As Boolean
Private editSnapshot As Variant
Private editLoadedValues As Variant
Private editFormValues(0 To 10) As Variant
Private editPriorForm(0 To 10) As Variant
Private editPriorFormats(0 To 10) As Variant
Private editPriorIsFormula(0 To 10) As Boolean
Private editSourceIsFormula() As Boolean

Private Function EditTable() As ListObject
    Dim editSheet As Worksheet
    For Each editSheet In ThisWorkbook.Worksheets
        On Error Resume Next
        Set EditTable = editSheet.ListObjects("tblCarryingExpenses")
        On Error GoTo 0
        If Not EditTable Is Nothing Then Exit Function
    Next editSheet
    Err.Raise vbObjectError + 540, , "Cannot find Carrying table."
End Function

Private Function EditHeaders() As Variant
    EditHeaders = Array("Include", "Category", "Date", "Vendor", "Description", "Amount", "Source", "Invoice #", "Source File", "Status", "Notes")
End Function

Private Function EditFields() As Variant
    EditFields = Array("Include", "Category", "Date", "Vendor", "Description", "Amount", "Source", "Invoice", "SourceFile", "Status", "Notes")
End Function

Private Function EditCell(ByVal editFieldName As String) As Range
    Set EditCell = ThisWorkbook.Names("ce" & editFieldName).RefersToRange
End Function

Private Function EditEqual(ByVal editA As Variant, ByVal editB As Variant) As Boolean
    If IsError(editA) Or IsError(editB) Then Exit Function
    If IsEmpty(editA) Or IsEmpty(editB) Then
        EditEqual = (IsEmpty(editA) And IsEmpty(editB))
    ElseIf VarType(editA) <> VarType(editB) Then
        If VarType(editA) <> vbString And VarType(editB) <> vbString And _
           VarType(editA) <> vbBoolean And VarType(editB) <> vbBoolean Then
            If IsNumeric(editA) And IsNumeric(editB) Then EditEqual = (CDbl(editA) = CDbl(editB))
        End If
    Else
        EditEqual = (CStr(editA) = CStr(editB))
    End If
End Function

Private Function EditText(ByVal editValue As Variant) As String
    If Not IsError(editValue) Then EditText = Trim$(CStr(editValue))
End Function

Private Function EditActive() As Boolean
    EditActive = CBool(Application.Evaluate(ThisWorkbook.Names("ceEditActive").RefersTo))
End Function

Private Sub EditState(ByVal editOn As Boolean)
    ThisWorkbook.Names("ceEditActive").RefersTo = IIf(editOn, "=TRUE", "=FALSE")
    With EditTable().Parent
        .Shapes("ceSaveButton").ControlFormat.Enabled = editOn
        .Shapes("ceCancelButton").ControlFormat.Enabled = editOn
    End With
End Sub

Private Sub EditFeedback(ByVal editMessage As String)
    On Error Resume Next
    EditCell("Feedback").Value2 = editMessage
    On Error GoTo 0
End Sub

Private Sub EditContext(ByVal editAction As String)
    Dim editHelp As String
    Select Case editAction
        Case "Edit Record"
            editHelp = "Select a bill's date or amount, then Edit Record. Change the yellow fields and use Save Changes, or Cancel Edit to leave the record unchanged."
        Case "Save Changes"
            editHelp = "Save Changes updates the loaded record, not a new row. Invalid or duplicate entries remain in the form for correction. Check the result message below."
        Case "Cancel Edit"
            editHelp = "Cancel Edit discards unsaved edits without changing the table. After reopening a saved edit, cancel it and select the bill again before editing."
        Case "Insert Record"
            editHelp = "Insert Record adds a new bill from the yellow fields after validation and duplicate checks. Finish any current edit first. Check the result message below."
        Case "Recurring Bill"
            editHelp = "Select a bill's date or amount in the grid, then Recurring Bill. Its vendor and category choose the latest matching bill. Review the suggested fields, then Insert Record."
    End Select
    ' Older installations may not yet have the optional context box.
    On Error Resume Next
    ThisWorkbook.Names("ceButtonContext").RefersToRange.Value2 = editAction & ": " & editHelp
    On Error GoTo 0
End Sub

Private Sub EditLiteral(ByVal editTarget As Range, ByVal editValue As Variant)
    Dim editFormat As Variant
    editFormat = editTarget.NumberFormat
    If IsEmpty(editValue) Then
        editTarget.MergeArea.ClearContents
    Else
        If VarType(editValue) = vbString Then editTarget.NumberFormat = "@"
        editTarget.Value2 = editValue
        editTarget.NumberFormat = editFormat
    End If
End Sub

Private Function EditDateKey(ByVal editDateValue As Variant) As Double
    If EditText(editDateValue) = "" Then
        EditDateKey = 1E+99
    Else
        EditDateKey = CDbl(editDateValue)
    End If
End Function

Private Function EditChosenRow(ByVal editList As ListObject) As Long
    Dim editChoice As Range, editGrid As Range, editHeading As Range
    Dim editData As Variant, editRows() As Long, editCount As Long
    Dim editI As Long, editJ As Long, editTemp As Long, editColumn As Long, editOrdinal As Long
    Dim editCategory As String, editDateCol As Long, editAmountCol As Long
    If TypeName(Selection) <> "Range" Then Exit Function
    Set editChoice = Selection
    If Not editChoice.Parent Is editList.Parent Then Exit Function
    If editChoice.Cells.CountLarge <> 1 Then Exit Function
    If editList.DataBodyRange Is Nothing Then Exit Function
    If Not Intersect(editChoice, editList.DataBodyRange) Is Nothing Then
        EditChosenRow = editChoice.Row - editList.DataBodyRange.Row + 1
        Exit Function
    End If
    Set editGrid = ThisWorkbook.Names("ceEditGrid").RefersToRange
    Set editHeading = ThisWorkbook.Names("ceEditHeaders").RefersToRange
    If Intersect(editChoice, editGrid) Is Nothing Then Exit Function
    editColumn = editChoice.Column - editGrid.Column
    If editColumn Mod 3 = 2 Then Exit Function
    editColumn = (editColumn \ 3) * 3 + 1
    If Not editGrid.Cells(editChoice.Row - editGrid.Row + 1, editColumn).HasFormula Then Exit Function
    editCategory = CStr(editHeading.Cells(1, editColumn).Value2)
    If editCategory = "Mortgage Payment paid after Reinstatement" Then editCategory = "Mortgage Payment"
    editData = editList.DataBodyRange.Value2
    ReDim editRows(1 To UBound(editData, 1))
    editDateCol = editList.ListColumns("Date").Index
    editAmountCol = editList.ListColumns("Amount").Index
    For editI = 1 To UBound(editData, 1)
        If EditText(editData(editI, editList.ListColumns("Include").Index)) = "Yes" And _
           EditText(editData(editI, editList.ListColumns("Category").Index)) = editCategory Then
            If IsError(editData(editI, editDateCol)) Then Exit Function
            If EditText(editData(editI, editDateCol)) <> "" Then
                If Not IsNumeric(editData(editI, editDateCol)) Then Exit Function
            End If
            editCount = editCount + 1: editRows(editCount) = editI
        End If
    Next editI
    ' Match the grid's chronological order, retaining table order for equal dates.
    For editI = 2 To editCount
        editTemp = editRows(editI): editJ = editI - 1
        Do While editJ >= 1
            If EditDateKey(editData(editRows(editJ), editDateCol)) <= EditDateKey(editData(editTemp, editDateCol)) Then Exit Do
            editRows(editJ + 1) = editRows(editJ): editJ = editJ - 1
        Loop
        editRows(editJ + 1) = editTemp
    Next editI
    editOrdinal = editChoice.Row - editGrid.Row + 1
    If editOrdinal > editCount Then Exit Function
    editTemp = editRows(editOrdinal)
    If EditText(editData(editTemp, editDateCol)) = "" Then
        If EditText(editGrid.Cells(editOrdinal, editColumn).Value2) <> "" Then Exit Function
    ElseIf Not EditEqual(editGrid.Cells(editOrdinal, editColumn).Value2, editData(editTemp, editDateCol)) Then
        Exit Function
    End If
    If Not editGrid.Cells(editOrdinal, editColumn + 1).HasFormula Then Exit Function
    If IsEmpty(editData(editTemp, editAmountCol)) Then
        If editGrid.Cells(editOrdinal, editColumn + 1).Value2 <> 0 Then Exit Function
    ElseIf Not EditEqual(editGrid.Cells(editOrdinal, editColumn + 1).Value2, editData(editTemp, editAmountCol)) Then
        Exit Function
    End If
    EditChosenRow = editTemp
End Function

Public Sub CarryingEdit_EditRecord()
    Dim editResult As String
    editResult = CarryingEdit_Load()
End Sub

Public Function CarryingEdit_Load(Optional ByVal editRowIndex As Long = 0) As String
    Dim editList As ListObject, editRow As Range, editNames As Variant, editCols As Variant
    Dim editI As Long, editCol As Long, editMessage As String, editValue As Variant
    Dim editEvents As Boolean, editStarted As Boolean
    EditContext "Edit Record"
    On Error GoTo Failed
    If editBusy Then Exit Function
    If EditActive() Then
        editMessage = "Save Changes or Cancel Edit before choosing another record.": GoTo Finished
    End If
    Set editList = EditTable()
    If ThisWorkbook.ReadOnly Or editList.Parent.ProtectContents Then
        editMessage = "Not loaded: Carrying is read-only or protected.": GoTo Finished
    End If
    If editRowIndex = 0 Then editRowIndex = EditChosenRow(editList)
    If editRowIndex < 1 Or editRowIndex > editList.ListRows.Count Then
        editMessage = "Select a bill's date or amount in the grid, or a source-table cell, then Edit Record.": GoTo Finished
    End If
    Set editRow = editList.ListRows(editRowIndex).Range
    editSnapshot = editRow.Formula2: editLoadedValues = editRow.Value2
    ReDim editSourceIsFormula(1 To editRow.Columns.Count)
    For editI = 1 To editRow.Columns.Count
        editSourceIsFormula(editI) = editRow.Cells(1, editI).HasFormula
    Next editI
    editNames = EditFields(): editCols = EditHeaders()
    For editI = 0 To 10
        editCol = editList.ListColumns(CStr(editCols(editI))).Index
        If IsError(editLoadedValues(1, editCol)) Then
            editMessage = "Not loaded: source record contains an error.": GoTo Finished
        End If
        editPriorForm(editI) = EditCell(CStr(editNames(editI))).Formula2
        editPriorFormats(editI) = EditCell(CStr(editNames(editI))).NumberFormat
        editPriorIsFormula(editI) = EditCell(CStr(editNames(editI))).HasFormula
    Next editI
    editEvents = Application.EnableEvents: Application.EnableEvents = False: editStarted = True
    For editI = 0 To 10
        editCol = editList.ListColumns(CStr(editCols(editI))).Index
        editValue = editLoadedValues(1, editCol)
        If editI = 0 Then editValue = (EditText(editValue) = "Yes")
        EditLiteral EditCell(CStr(editNames(editI))), editValue
        editFormValues(editI) = EditCell(CStr(editNames(editI))).Value2
    Next editI
    editLoaded = True: EditState True
    editMessage = "Editing " & EditText(editLoadedValues(1, editList.ListColumns("Vendor").Index)) & "."
    Application.GoTo EditCell("Amount"), False
    GoTo Finished
Failed:
    editMessage = "Not loaded: " & Err.description
    If editStarted Then
        On Error Resume Next
        EditRestoreForm
        EditState False
        editLoaded = False
        On Error GoTo 0
    End If
Finished:
    If editStarted Then Application.EnableEvents = editEvents
    EditFeedback editMessage
    CarryingEdit_Load = editMessage
End Function

Private Function EditFindUnchanged(ByVal editList As ListObject) As Long
    Dim editRow As ListRow, editData As Variant, editCol As Long, editMatch As Boolean, editCount As Long
    For Each editRow In editList.ListRows
        editData = editRow.Range.Formula2: editMatch = True
        For editCol = 1 To UBound(editSnapshot, 2)
            If Not EditEqual(editSnapshot(1, editCol), editData(1, editCol)) Then editMatch = False: Exit For
            If editRow.Range.Cells(1, editCol).HasFormula <> editSourceIsFormula(editCol) Then editMatch = False: Exit For
        Next editCol
        If editMatch Then editCount = editCount + 1: EditFindUnchanged = editRow.Index
    Next editRow
    If editCount <> 1 Then EditFindUnchanged = 0
End Function

Private Sub EditRestoreForm()
    Dim editNames As Variant, editI As Long, editTarget As Range
    editNames = EditFields()
    For editI = 0 To 10
        Set editTarget = EditCell(CStr(editNames(editI)))
        If VarType(editPriorForm(editI)) = vbString Then
            If editPriorIsFormula(editI) Then
                editTarget.Formula2 = editPriorForm(editI)
            Else
                EditLiteral editTarget, editPriorForm(editI)
            End If
        Else
            EditLiteral editTarget, editPriorForm(editI)
        End If
        editTarget.NumberFormat = editPriorFormats(editI)
    Next editI
End Sub

Public Sub CarryingEdit_SaveChanges()
    Dim editResult As String
    editResult = CarryingEdit_Save()
End Sub

Public Function CarryingEdit_Save() As String
    Dim editList As ListObject, editRow As Range, editOther As ListRow
    Dim editNames As Variant, editCols As Variant, editValues(0 To 10) As Variant
    Dim editChanged(0 To 10) As Boolean, editFormats(0 To 10) As Variant
    Dim editI As Long, editCol As Long, editIndex As Long, editChanges As Long
    Dim editMessage As String, editCategory As Variant, editValid As Boolean
    Dim editEvents As Boolean, editStarted As Boolean, editCommitted As Boolean
    Dim editVendor As String, editInvoice As String, editFailure As String
    EditContext "Save Changes"
    On Error GoTo Failed
    If editBusy Then Exit Function
    editBusy = True
    If Not EditActive() Or Not editLoaded Then
        editMessage = "Not saved: select Cancel Edit, then load the record again.": GoTo Finished
    End If
    Set editList = EditTable()
    If ThisWorkbook.ReadOnly Or editList.Parent.ProtectContents Then
        editMessage = "Not saved: Carrying is read-only or protected.": GoTo Finished
    End If
    editIndex = EditFindUnchanged(editList)
    If editIndex = 0 Then
        editMessage = "Not saved: record changed, was removed, or has an identical duplicate. Cancel and reload.": GoTo Finished
    End If
    Set editRow = editList.ListRows(editIndex).Range
    editNames = EditFields(): editCols = EditHeaders()
    For editI = 0 To 10
        editCol = editList.ListColumns(CStr(editCols(editI))).Index
        editValues(editI) = EditCell(CStr(editNames(editI))).Value2
        If IsError(editValues(editI)) Then editMessage = "Not saved: an input contains an error.": GoTo Finished
        editChanged(editI) = Not EditEqual(editValues(editI), editFormValues(editI))
        If editChanged(editI) Then editChanges = editChanges + 1
        If Not editChanged(editI) Then editValues(editI) = editLoadedValues(1, editCol)
        editFormats(editI) = editRow.Cells(1, editCol).NumberFormat
    Next editI
    If editChanged(0) Then
        If VarType(editValues(0)) <> vbBoolean Then editMessage = "Not saved: use the Include checkbox.": GoTo Finished
        editValues(0) = IIf(editValues(0), "Yes", "No")
    End If
    If editChanged(1) Then
        For Each editCategory In Split(CStr(Application.Evaluate(ThisWorkbook.Names("ceCategories").RefersTo)), ",")
            If StrComp(EditText(editValues(1)), CStr(editCategory), vbTextCompare) = 0 Then editValues(1) = editCategory: editValid = True: Exit For
        Next editCategory
        If Not editValid Then editMessage = "Not saved: select a valid Category.": GoTo Finished
    End If
    If editChanged(2) Then
        If EditText(editValues(2)) = "" Or Not IsDate(EditCell("Date").Value) Then editMessage = "Not saved: enter a valid Date.": GoTo Finished
        editValues(2) = CDbl(DateValue(CDate(EditCell("Date").Value)))
        If ThisWorkbook.Date1904 Then editValues(2) = editValues(2) - 1462
    End If
    If editChanged(5) And EditText(editValues(5)) <> "" Then
        If Not IsNumeric(editValues(5)) Or VarType(editValues(5)) = vbBoolean Then editMessage = "Not saved: Amount must be numeric or blank.": GoTo Finished
        editValues(5) = CDbl(editValues(5))
    End If
    For editI = 3 To 4
        If editChanged(editI) And EditText(editValues(editI)) = "" Then editMessage = "Not saved: Vendor and Description cannot be cleared.": GoTo Finished
    Next editI
    editVendor = EditText(editValues(3)): editInvoice = EditText(editValues(7))
    If editChanges > 0 Then
        For Each editOther In editList.ListRows
            If editOther.Index <> editIndex Then
                If StrComp(EditText(editOther.Range.Cells(1, editList.ListColumns("Vendor").Index).Value2), editVendor, vbTextCompare) = 0 Then
                    If editInvoice <> "" And StrComp(EditText(editOther.Range.Cells(1, editList.ListColumns("Invoice #").Index).Value2), editInvoice, vbTextCompare) = 0 Then
                        editMessage = "Not saved: possible duplicate vendor/invoice number.": GoTo Finished
                    End If
                    If EditText(editValues(5)) <> "" And IsNumeric(editValues(5)) Then
                        If StrComp(EditText(editOther.Range.Cells(1, editList.ListColumns("Category").Index).Value2), EditText(editValues(1)), vbTextCompare) = 0 And _
                           EditEqual(editOther.Range.Cells(1, editList.ListColumns("Date").Index).Value2, editValues(2)) And _
                           EditEqual(editOther.Range.Cells(1, editList.ListColumns("Amount").Index).Value2, editValues(5)) Then
                            editMessage = "Not saved: possible duplicate vendor/category/date/amount.": GoTo Finished
                        End If
                    End If
                End If
            End If
        Next editOther
    End If
    editEvents = Application.EnableEvents: Application.EnableEvents = False: editStarted = True
    ' Write only changed fields; existing formulas, blanks, dates and provenance survive untouched.
    For editI = 0 To 10
        If editChanged(editI) Then
            editCol = editList.ListColumns(CStr(editCols(editI))).Index
            EditLiteral editRow.Cells(1, editCol), editValues(editI)
            If editRow.Cells(1, editCol).HasFormula Or Not EditEqual(editRow.Cells(1, editCol).Value2, editValues(editI)) Then
                Err.Raise vbObjectError + 541, , "Changed-field verification failed."
            End If
        End If
    Next editI
    editCommitted = True
    Call EditRestoreForm
    EditState False
    editLoaded = False
    editMessage = "Saved changes to " & editVendor & "."
    If editChanges = 0 Then editMessage = "No changes; edit closed."
    GoTo Finished
Failed:
    editFailure = Err.description
    If editCommitted Then
        editMessage = "Saved, but form reset failed. Do not re-enter. " & editFailure
    ElseIf editStarted Then
        On Error Resume Next
        Err.Clear
        For editI = 0 To 10
            If editChanged(editI) Then
                editCol = editList.ListColumns(CStr(editCols(editI))).Index
                If editSourceIsFormula(editCol) Then
                    editRow.Cells(1, editCol).Formula2 = editSnapshot(1, editCol)
                Else
                    EditLiteral editRow.Cells(1, editCol), editLoadedValues(1, editCol)
                End If
                editRow.Cells(1, editCol).NumberFormat = editFormats(editI)
            End If
        Next editI
        If Err.Number = 0 Then editMessage = "Not saved; original record restored. " & editFailure Else editMessage = "Edit uncertain; inspect source record before retrying. " & editFailure
        On Error GoTo 0
    Else
        editMessage = "Not saved: " & editFailure
    End If
Finished:
    If editStarted Then Application.EnableEvents = editEvents
    editBusy = False
    EditFeedback editMessage
    CarryingEdit_Save = editMessage
End Function

Public Sub CarryingEdit_CancelButton()
    EditContext "Cancel Edit"
    If MsgBox("Cancel this edit and discard its unsaved changes?", vbQuestion + vbYesNo, "Cancel Edit") <> vbYes Then Exit Sub
    Dim editResult As String
    editResult = CarryingEdit_Cancel()
End Sub

Public Function CarryingEdit_Cancel() As String
    Dim editEvents As Boolean
    EditContext "Cancel Edit"
    On Error GoTo Failed
    editEvents = Application.EnableEvents: Application.EnableEvents = False
    If editLoaded Then
        EditRestoreForm
    ElseIf EditActive() Then
        ' A reopened session cannot safely recover the prior form or identify its record.
        Dim editResetField As Variant
        For Each editResetField In Array("Date", "Category", "Vendor", "Description", "Amount", "Invoice", "SourceFile", "Notes")
            EditCell(CStr(editResetField)).MergeArea.ClearContents
        Next editResetField
        EditCell("Source").Value2 = "Manual Entry"
        EditCell("Status").Value2 = "Entered"
        EditCell("Include").Value2 = True
        CarryingEdit_Cancel = "Stale edit cleared; source record unchanged."
    End If
    EditState False: editLoaded = False
    If CarryingEdit_Cancel = "" Then CarryingEdit_Cancel = "Edit cancelled; source record unchanged."
    GoTo Finished
Failed:
    CarryingEdit_Cancel = "Could not cancel: " & Err.description
Finished:
    Application.EnableEvents = editEvents
    EditFeedback CarryingEdit_Cancel
End Function

Public Sub CarryingEdit_InsertGuard()
    EditContext "Insert Record"
    If EditActive() Then
        EditFeedback "Finish Save Changes or Cancel Edit before inserting a record."
    Else
        CarryingEntry_Insert
    End If
End Sub

Public Sub CarryingEdit_RecurringGuard()
    Dim editResult As String
    editResult = CarryingEdit_RecurringFromSelection()
End Sub

Public Function CarryingEdit_RecurringFromSelection() As String
    Dim editList As ListObject, editIndex As Long, editVendor As Variant
    Dim editOldVendor As Variant, editOldFormula As Boolean, editOldFormat As Variant
    Dim editEvents As Boolean, editStarted As Boolean, editMessage As String
    EditContext "Recurring Bill"
    On Error GoTo Failed
    If EditActive() Then
        editMessage = "Finish Save Changes or Cancel Edit before using Recurring Bill.": GoTo Finished
    End If
    Set editList = EditTable()
    If ThisWorkbook.ReadOnly Or editList.Parent.ProtectContents Then
        editMessage = "Not filled: Carrying is read-only or protected.": GoTo Finished
    End If
    editIndex = EditChosenRow(editList)
    If editIndex = 0 Then
        editMessage = "Select a bill's date or amount in the grid, or a source-table cell, then Recurring Bill.": GoTo Finished
    End If
    editVendor = editList.ListRows(editIndex).Range.Cells(1, editList.ListColumns("Vendor").Index).Value2
    If IsError(editVendor) Then
        editMessage = "Not filled: the selected bill's Vendor contains an error.": GoTo Finished
    End If
    If EditText(editVendor) = "" Then
        editMessage = "Not filled: the selected bill has no Vendor.": GoTo Finished
    End If
    editOldVendor = EditCell("Vendor").Formula2
    editOldFormula = EditCell("Vendor").HasFormula
    editOldFormat = EditCell("Vendor").NumberFormat
    editEvents = Application.EnableEvents: Application.EnableEvents = False: editStarted = True
    EditLiteral EditCell("Vendor"), editVendor
    ' Reuse recurrence inference, explicitly identifying this vendor's selected category.
    editMessage = CarryingEntry_Prefill(editIndex)
    If Left$(editMessage, 7) = "Filled." Then GoTo Finished
    GoTo RestoreVendor
Failed:
    editMessage = "Not filled: " & Err.description
RestoreVendor:
    If editStarted Then
        On Error Resume Next
        If editOldFormula Then
            EditCell("Vendor").Formula2 = editOldVendor
        Else
            EditLiteral EditCell("Vendor"), editOldVendor
        End If
        EditCell("Vendor").NumberFormat = editOldFormat
        On Error GoTo 0
    End If
Finished:
    If editStarted Then Application.EnableEvents = editEvents
    EditFeedback editMessage
    CarryingEdit_RecurringFromSelection = editMessage
End Function
