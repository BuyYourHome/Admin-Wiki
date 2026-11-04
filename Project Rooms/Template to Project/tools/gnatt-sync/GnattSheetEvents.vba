Option Explicit

Private Sub Worksheet_Change(ByVal Target As Range)
    If Not Intersect(Target, Me.ListObjects("Contract_Edits").Range) Is Nothing Then
        BYHGnattSync.ScheduleGnattSync
    End If
End Sub

Private Sub Worksheet_Activate()
    BYHGnattSync.NoticeGnattCalculation
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    BYHGnattSync.NoticeGnattCalculation
End Sub
