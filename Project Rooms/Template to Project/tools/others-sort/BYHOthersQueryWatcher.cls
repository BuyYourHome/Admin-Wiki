Option Explicit

Public WithEvents SourceQuery As Excel.QueryTable

Private Sub SourceQuery_AfterRefresh(ByVal Success As Boolean)
    If Success Then BYHOthersSort.ScheduleOthersSync
End Sub
