Option Explicit

Private Sub Worksheet_Activate()
    BYHOthersSort.InitializeOthersSort
End Sub

Private Sub Worksheet_Calculate()
    BYHOthersSort.ScheduleOthersSync
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    BYHOthersSort.InitializeOthersSort
End Sub

Private Sub Worksheet_Change(ByVal Target As Range)
    BYHOthersSort.ScheduleOthersSync
End Sub
