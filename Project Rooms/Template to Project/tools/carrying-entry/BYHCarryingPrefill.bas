Attribute VB_Name = "BYHCarryingPrefill"
Option Explicit

Private Function PrefillField(ByVal prefillFieldName As String) As Range
    Set PrefillField = ThisWorkbook.Names("ce" & prefillFieldName).RefersToRange
End Function

Private Function PrefillNextDate(ByRef prefillData As Variant, ByRef prefillCols() As Long, ByVal prefillCandidate As Long) As Variant
    Dim prefillDays(1 To 3) As Double, prefillIndex As Long, prefillSlot As Long, prefillMove As Long
    Dim prefillValue As Variant, prefillDay As Double, prefillMatch As Boolean, prefillCol As Long
    Dim prefillMonths As Long, prefillAnchor As Long, prefillEnd As Long, prefillAllEnds As Boolean
    Dim prefillExpected As Date, prefillExact As Boolean
    PrefillNextDate = Empty
    'Use the three latest distinct calendar dates for this exact bill type, including hidden rows.
    For prefillIndex = 1 To UBound(prefillData, 1)
        prefillMatch = True
        For prefillCol = 0 To 2
            If StrComp(PrefillText(prefillData(prefillIndex, prefillCols(prefillCol))), _
                PrefillText(prefillData(prefillCandidate, prefillCols(prefillCol))), vbTextCompare) <> 0 Then prefillMatch = False
        Next prefillCol
        If prefillMatch Then
            prefillValue = prefillData(prefillIndex, prefillCols(4))
            If Not IsError(prefillValue) Then
                If VarType(prefillValue) <> vbString And Not IsEmpty(prefillValue) And VarType(prefillValue) <> vbBoolean Then
                    If IsNumeric(prefillValue) Then
                        prefillDay = Fix(CDbl(prefillValue))
                        If prefillDay >= 61 And prefillDay < CDbl(DateSerial(9998, 1, 1)) Then
                            If prefillDay <> prefillDays(1) And prefillDay <> prefillDays(2) And prefillDay <> prefillDays(3) Then
                                For prefillSlot = 1 To 3
                                    If prefillDay > prefillDays(prefillSlot) Then
                                        For prefillMove = 3 To prefillSlot + 1 Step -1
                                            prefillDays(prefillMove) = prefillDays(prefillMove - 1)
                                        Next prefillMove
                                        prefillDays(prefillSlot) = prefillDay
                                        Exit For
                                    End If
                                Next prefillSlot
                            End If
                        End If
                    End If
                End If
            End If
        End If
    Next prefillIndex
    If prefillDays(3) = 0 Then Exit Function
    If prefillDays(1) - prefillDays(2) = 7 And prefillDays(2) - prefillDays(3) = 7 Then
        PrefillNextDate = prefillDays(1) + 7
        Exit Function
    End If
    prefillMonths = DateDiff("m", CDate(prefillDays(2)), CDate(prefillDays(1)))
    If prefillMonths <> 1 And prefillMonths <> 3 And prefillMonths <> 12 Then Exit Function
    If DateDiff("m", CDate(prefillDays(3)), CDate(prefillDays(2))) <> prefillMonths Then Exit Function
    prefillAllEnds = True
    For prefillSlot = 1 To 3
        prefillEnd = Day(DateSerial(Year(CDate(prefillDays(prefillSlot))), Month(CDate(prefillDays(prefillSlot))) + 1, 0))
        If Day(CDate(prefillDays(prefillSlot))) <> prefillEnd Then prefillAllEnds = False
        If Day(CDate(prefillDays(prefillSlot))) > prefillAnchor Then prefillAnchor = Day(CDate(prefillDays(prefillSlot)))
    Next prefillSlot
    If prefillAllEnds Then
        PrefillNextDate = CDbl(DateSerial(Year(CDate(prefillDays(1))), Month(CDate(prefillDays(1))) + prefillMonths + 1, 0))
        Exit Function
    End If
    'Recover a fixed day clamped by February; otherwise permit up to three days of billing jitter.
    prefillExact = True
    For prefillSlot = 1 To 3
        prefillEnd = Day(DateSerial(Year(CDate(prefillDays(prefillSlot))), Month(CDate(prefillDays(prefillSlot))) + 1, 0))
        prefillDay = prefillAnchor
        If prefillDay > prefillEnd Then prefillDay = prefillEnd
        If Day(CDate(prefillDays(prefillSlot))) <> prefillDay Then prefillExact = False
    Next prefillSlot
    If prefillExact Then
        prefillExpected = DateSerial(Year(CDate(prefillDays(1))), Month(CDate(prefillDays(1))) + prefillMonths, 1)
        prefillEnd = Day(DateSerial(Year(prefillExpected), Month(prefillExpected) + 1, 0))
        If prefillAnchor > prefillEnd Then prefillAnchor = prefillEnd
        PrefillNextDate = CDbl(DateSerial(Year(prefillExpected), Month(prefillExpected), prefillAnchor))
        Exit Function
    End If
    For prefillSlot = 2 To 3
        prefillExpected = DateAdd("m", prefillMonths * (prefillSlot - 1), CDate(prefillDays(prefillSlot)))
        If Abs(CDbl(prefillExpected) - prefillDays(1)) > 3 Then Exit Function
    Next prefillSlot
    PrefillNextDate = CDbl(DateAdd("m", prefillMonths, CDate(prefillDays(1))))
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
    Dim prefillNumber As Variant, prefillFailure As String, prefillSuggested As Variant, prefillDateMessage As String
    Dim prefillWriteDate As Boolean
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
    prefillSuggested = PrefillField("Date").Value2
    prefillDateMessage = "Date retained."
    If Not PrefillField("Date").HasFormula And PrefillText(prefillSuggested) = "" Then
        prefillWriteDate = True
        prefillSuggested = PrefillNextDate(prefillData, prefillCols, prefillCandidate)
        If IsEmpty(prefillSuggested) Then
            prefillDateMessage = "Date unclear; enter it."
        Else
            prefillDateMessage = "Date suggested; verify it."
        End If
    End If
    prefillNames = Array("Category", "Vendor", "Description", "Amount", "Include", "Invoice", "Source", "SourceFile", "Status", "Notes", "Date")
    prefillValues = Array(PrefillText(prefillData(prefillCandidate, prefillCols(1))), _
        PrefillText(prefillData(prefillCandidate, prefillCols(0))), _
        PrefillText(prefillData(prefillCandidate, prefillCols(2))), prefillNumber, _
        StrComp(PrefillText(prefillData(prefillCandidate, prefillCols(5))), "Yes", vbTextCompare) = 0, _
        Empty, "Manual Entry", Empty, "Entered", Empty, prefillSuggested)
    ReDim prefillOld(0 To UBound(prefillNames))
    For prefillIndex = 0 To UBound(prefillNames)
        prefillOld(prefillIndex) = PrefillField(CStr(prefillNames(prefillIndex))).Value2
    Next prefillIndex
    prefillOldEvents = Application.EnableEvents
    Application.EnableEvents = False
    prefillStarted = True
    For prefillIndex = 0 To UBound(prefillNames)
        If prefillNames(prefillIndex) <> "Date" Or prefillWriteDate Then
            PrefillField(CStr(prefillNames(prefillIndex))).Value2 = prefillValues(prefillIndex)
        End If
    Next prefillIndex
    prefillStarted = False
    Application.EnableEvents = prefillOldEvents
    prefillOutcome = "Filled. " & prefillDateMessage & " Check Amount."
    GoTo PrefillFinished
PrefillFailed:
    prefillFailure = Err.Description
    On Error Resume Next
    If prefillStarted Then
        For prefillIndex = 0 To UBound(prefillNames)
            If prefillNames(prefillIndex) <> "Date" Or prefillWriteDate Then
                PrefillField(CStr(prefillNames(prefillIndex))).Value2 = prefillOld(prefillIndex)
            End If
        Next prefillIndex
        Application.EnableEvents = prefillOldEvents
    End If
    prefillOutcome = "Not filled: " & prefillFailure
PrefillFinished:
    On Error Resume Next
    PrefillField("Feedback").Value2 = prefillOutcome
    CarryingEntry_Prefill = prefillOutcome
End Function
