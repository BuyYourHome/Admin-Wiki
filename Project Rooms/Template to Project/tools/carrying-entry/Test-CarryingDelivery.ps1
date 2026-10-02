param([Parameter(Mandatory)][string]$Root)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=1
try{
    foreach($file in Get-ChildItem -LiteralPath (Join-Path $Root 'verified') -Filter '*.xlsm'){
        $id=$file.Name.Substring(0,2);$b=$e.Workbooks.Open($file.FullName,0,$false)
        try{
            $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
            $count=$t.ListRows.Count;$before=$t.DataBodyRange.Formula2;$profit=$b.Worksheets.Item('Profit').Range('B43').Value2
            Assert ($e.Calculation -eq -4105) 'Downloaded file not Automatic.'
            $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
            $expected=Get-Content -LiteralPath (Join-Path $Root "evidence\$id\vba-after.json") -Raw|ConvertFrom-Json
            foreach($c in $v.VBComponents){$code=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''};Assert ($code -ceq $expected.PSObject.Properties[$c.Name].Value) "Saved VBA mismatch $($c.Name)"}
            function Run($name){$e.Run("'"+$b.Name.Replace("'","''")+"'!"+$name)}
            $grid=$b.Names.Item('ceEditGrid').RefersToRange;$headers=$b.Names.Item('ceEditHeaders').RefersToRange
            $choice=$null
            for($col=1;$col -le $headers.Columns.Count;$col+=3){if($grid.Cells.Item(1,$col).Value2){$choice=$grid.Cells.Item(1,$col);break}}
            Assert ($null -ne $choice) 'No existing grid bill found.'
            $s.Activate();$choice.Select()
            $result=[string](Run 'CarryingEdit_Load')
            Assert ($result.StartsWith('Editing')) "Downloaded grid editor failed: $result"
            $vendor=$b.Names.Item('ceVendor').RefersToRange.Value2;$category=$b.Names.Item('ceCategory').RefersToRange.Value2
            [void](Run 'CarryingEdit_Cancel');$choice.Select()
            [void](Run 'CarryingEdit_RecurringFromSelection')
            Assert ($b.Names.Item('ceVendor').RefersToRange.Value2 -eq $vendor -and $b.Names.Item('ceCategory').RefersToRange.Value2 -eq $category) 'Downloaded recurring selection mismatch.'
            $cb=$s.Shapes.Item('ceIncludeCheckbox');$cb.ControlFormat.Value=-4146
            Assert ($b.Names.Item('ceInclude').RefersToRange.Value2 -eq $false) 'Unchecked Include link failed.'
            $cb.ControlFormat.Value=1
            Assert ($b.Names.Item('ceInclude').RefersToRange.Value2 -eq $true) 'Checked Include link failed.'
            foreach($name in @('ceRecurringButton','ceInsertButton','ceEditButton','ceSaveButton','ceCancelButton')){Assert ($s.Shapes.Item($name).DrawingObject.PrintObject) "Nonprinting toolbar button $name"}
            $after=$t.DataBodyRange.Formula2
            Assert ($count -eq $t.ListRows.Count -and $b.Worksheets.Item('Profit').Range('B43').Value2 -eq $profit) 'Unsaved delivery test changed records or totals.'
            for($r=1;$r -le $count;$r++){for($c=1;$c -le 11;$c++){Assert ($before[$r,$c] -ceq $after[$r,$c]) "Record changed $r,$c"}}
            $result=[ordered]@{file=$b.Name;records=$count;expenseTotal=$profit;nativeReopen=$true;vbaVerified=$true;gridEditAndRecurring=$true;checkboxVerified=$true;changesSaved=$false}
            $result|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $Root "evidence\$id\delivery-test.json")
            $result|ConvertTo-Json
        }finally{$b.Close($false);$b=$null}
    }
}catch{Write-Output $_.ScriptStackTrace;throw}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
