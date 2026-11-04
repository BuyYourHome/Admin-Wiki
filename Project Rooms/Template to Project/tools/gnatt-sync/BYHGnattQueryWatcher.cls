Option Explicit
Public WithEvents GnattQuery As Excel.QueryTable

Private Sub GnattQuery_AfterRefresh(ByVal Success As Boolean)
    If Success Then
        BYHGnattSync.ScheduleGnattSync
    Else
        BYHGnattSync.ReportGnattError "A source query failed to refresh."
    End If
End Sub
