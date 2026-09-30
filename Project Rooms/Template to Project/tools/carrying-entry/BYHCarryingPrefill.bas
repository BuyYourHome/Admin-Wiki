Attribute VB_Name = "BYHCarryingPrefill"
Option Explicit

Private Function PrefillField(ByVal prefillFieldName As String) As Range
    Set PrefillField = ThisWorkbook.Names("ce" & prefillFieldName).RefersToRange
End Function

Private Function PrefillTable() As ListObject
    Dim prefillSheet As Worksheet
    For Each prefillSheet In ThisWorkbook.Worksheets
        On Error Resume Next
        Set PrefillTable = prefillSheet.ListObjects("tblCarryingExpenses")
        On Error GoTo 0
        If Not PrefillTable Is Nothing Then Exit Function
    Next prefillSheet
    Err.Raise vbObjectError + 510, , "Cannot find tblCarryingExpenses."
End Function

Private Function PrefillText(ByVal prefillValue As Variant) As String
    If Not IsError(prefillValue) Then PrefillText = Trim$(CStr(prefillValue))
End Function

Public Sub CarryingEntry_Recurring()
    Dim prefillResult As String, prefillChoice As Range, prefillList As ListObject
    prefillResult = CarryingEntry_Prefill()
    If Left$(prefillResult, 9) <> "Choose a " Then Exit Sub
    Set prefillList = PrefillTable()
    On Error Resume Next
    Set prefillChoice = Application.InputBox( _
        "This vendor has different bill types. Select one cell in its Carrying table record, or Cancel.", _
        "Choose recurring bill", Type:=8)
    On Error GoTo 0
    If prefillChoice Is Nothing Then Exit Sub
    If Not prefillChoice.Parent Is prefillList.Parent Then Exit Sub
    If prefillChoice.Cells.CountLarge <> 1 Then Exit Sub
    If Intersect(prefillChoice, prefillList.DataBodyRange) Is Nothing Then Exit Sub
    prefillResult = CarryingEntry_Prefill(prefillChoice.Row - prefillList.DataBodyRange.Row + 1)
End Sub

Public Function CarryingEntry_Prefill(Optional ByVal prefillRow As Long = 0) As String
    Dim prefillList As ListObject, prefillData As Variant, prefillHeaders As Variant
    Dim prefillCols(0 To 5) As Long, prefillIndex As Long, prefillCandidate As Long
    Dim prefillVendor As String, prefillGroup As String, prefillFirstGroup As String
    Dim prefillGroupsDiffer As Boolean, prefillNewest As Double, prefillDate As Double
    Dim prefillOutcome As String, prefillOldEvents As Boolean, prefillStarted As Boolean
    Dim prefillNames As Variant, prefillValues As Variant, prefillOld() As Variant
    Dim prefillNumber As Variant, prefillFailure As String
    On Error GoTo PrefillFailed
    Set prefillList = PrefillTable()
    If ThisWorkbook.ReadOnly Or prefillList.Parent.ProtectContents Then
        prefillOutcome = "Not filled: Carrying is read-only or protected."
        GoTo PrefillFinished
    End If
    prefillVendor = PrefillText(PrefillField("Vendor").Value2)
    If prefillVendor = "" Then
        prefillOutcome = "Not filled: select a Vendor."
        GoTo PrefillFinished
    End If
    If prefillList.DataBodyRange Is Nothing Then
        prefillOutcome = "Not filled: no prior records."
        GoTo PrefillFinished
    End If
    prefillHeaders = Array("Vendor", "Category", "Description", "Amount", "Date", "Include")
    For prefillIndex = 0 To 5
        prefillCols(prefillIndex) = prefillList.ListColumns(CStr(prefillHeaders(prefillIndex))).Index
    Next prefillIndex
    prefillData = prefillList.DataBodyRange.Value2
    prefillNewest = -1
    For prefillIndex = 1 To UBound(prefillData, 1)
        If StrComp(PrefillText(prefillData(prefillIndex, prefillCols(0))), prefillVendor, vbTextCompare) = 0 Then
            If prefillRow = 0 Or prefillRow = prefillIndex Then
                prefillGroup = LCase$(PrefillText(prefillData(prefillIndex, prefillCols(1)))) & vbTab & _
                    LCase$(PrefillText(prefillData(prefillIndex, prefillCols(2))))
                If prefillFirstGroup = "" Then prefillFirstGroup = prefillGroup
                If prefillGroup <> prefillFirstGroup Then prefillGroupsDiffer = True
                prefillDate = -1
                If Not IsError(prefillData(prefillIndex, prefillCols(4))) Then
                    If IsNumeric(prefillData(prefillIndex, prefillCols(4))) Then
                        If Not IsEmpty(prefillData(prefillIndex, prefillCols(4))) Then prefillDate = CDbl(prefillData(prefillIndex, prefillCols(4)))
                    End If
                End If
                If prefillCandidate = 0 Or prefillDate >= prefillNewest Then
                    prefillCandidate = prefillIndex
                    prefillNewest = prefillDate
                End If
            End If
        End If
    Next prefillIndex
    If prefillCandidate = 0 Then
        prefillOutcome = "Not filled: no matching Vendor record."
        GoTo PrefillFinished
    End If
    If prefillGroupsDiffer Then
        prefillOutcome = "Choose a record: this Vendor has different bill types."
        GoTo PrefillFinished
    End If
    prefillNumber = Empty
    If Not IsError(prefillData(prefillCandidate, prefillCols(3))) Then
        If Len(PrefillText(prefillData(prefillCandidate, prefillCols(3)))) > 0 Then
            If IsNumeric(prefillData(prefillCandidate, prefillCols(3))) Then prefillNumber = CDbl(prefillData(prefillCandidate, prefillCols(3)))
        End If
    End If
    prefillNames = Array("Category", "Vendor", "Description", "Amount", "Include", "Invoice", "Source", "SourceFile", "Status", "Notes")
    prefillValues = Array(PrefillText(prefillData(prefillCandidate, prefillCols(1))), _
        PrefillText(prefillData(prefillCandidate, prefillCols(0))), _
        PrefillText(prefillData(prefillCandidate, prefillCols(2))), prefillNumber, _
        StrComp(PrefillText(prefillData(prefillCandidate, prefillCols(5))), "Yes", vbTextCompare) = 0, _
        Empty, "Manual Entry", Empty, "Entered", Empty)
    ReDim prefillOld(0 To UBound(prefillNames))
    For prefillIndex = 0 To UBound(prefillNames)
        prefillOld(prefillIndex) = PrefillField(CStr(prefillNames(prefillIndex))).Value2
    Next prefillIndex
    prefillOldEvents = Application.EnableEvents
    Application.EnableEvents = False
    prefillStarted = True
    For prefillIndex = 0 To UBound(prefillNames)
        PrefillField(CStr(prefillNames(prefillIndex))).Value2 = prefillValues(prefillIndex)
    Next prefillIndex
    prefillStarted = False
    Application.EnableEvents = prefillOldEvents
    prefillOutcome = "Filled from table row " & prefillCandidate & ". Check Date and Amount."
    GoTo PrefillFinished
PrefillFailed:
    prefillFailure = Err.Description
    On Error Resume Next
    If prefillStarted Then
        For prefillIndex = 0 To UBound(prefillNames)
            PrefillField(CStr(prefillNames(prefillIndex))).Value2 = prefillOld(prefillIndex)
        Next prefillIndex
        Application.EnableEvents = prefillOldEvents
    End If
    prefillOutcome = "Not filled: " & prefillFailure
PrefillFinished:
    On Error Resume Next
    PrefillField("Feedback").Value2 = prefillOutcome
    CarryingEntry_Prefill = prefillOutcome
End Function
