param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Output,[Parameter(Mandatory)][string]$ExpectedHash)
$ErrorActionPreference='Stop'
function Assert($ok,$message){if(-not $ok){throw $message}}
Assert ((Get-FileHash -LiteralPath $Source).Hash -eq $ExpectedHash) 'Source changed; remap.'
Assert (-not (Test-Path -LiteralPath $Output)) 'Output exists.'
[void](New-Item -ItemType Directory -Path (Split-Path -Parent $Output) -Force)
Copy-Item -LiteralPath $Source -Destination $Output
$e=New-Object -ComObject Excel.Application
$e.Visible=$false;$e.DisplayAlerts=$false;$e.EnableEvents=$false;$e.AutomationSecurity=3
try{
    $b=$e.Workbooks.Open($Output,0,$false)
    Assert (-not $b.ReadOnly -and $b.FileFormat -eq 52 -and -not $b.Date1904) 'Expected writable 1900-date XLSM.'
    $s=$b.Worksheets.Item('Carrying');$t=$s.ListObjects.Item('tblCarryingExpenses')
    Assert ($t.Range.Address() -eq '$AL$2:$AV$58' -and $t.ListRows.Count -eq 56) 'Tensity table map changed.'
    Assert ($s.Range('A5').Text -eq 'Duke Electric' -and $s.Range('AH5').Text -eq 'Labor') 'Grid layout changed.'
    $profit=$b.Worksheets.Item('Profit').Range('B43').Value2
    Assert ([math]::Abs($profit-28224.97) -lt .001) 'Baseline total changed.'
    $v=$b.GetType().InvokeMember('VBProject',[Reflection.BindingFlags]::GetProperty,$null,$b,$null)
    Assert ($v.Protection -eq 0) 'VBA project protected.'
    $code=@{};foreach($c in $v.VBComponents){$code[$c.Name]=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}}
    Assert (-not $code.ContainsKey('BYHCarryingEdit')) 'Editor already exists.'
    $before=$t.DataBodyRange.Formula2
    [void]$b.Names.Add('ceEditActive','=FALSE',$false)
    [void]$b.Names.Add('ceEditVersion','="1.0"',$false)
    [void]$b.Names.Add('ceEditGrid',"=Carrying!`$A`$8:`$AJ`$28",$false)
    [void]$b.Names.Add('ceEditHeaders',"=Carrying!`$A`$5:`$AJ`$5",$false)
    $base=$s.Shapes.Item('ceInsertButton');$left=$s.Range('Z1').Left
    $definitions=@(@('ceEditButton','Edit Record','CarryingEdit_EditRecord'),@('ceSaveButton','Save Changes','CarryingEdit_SaveChanges'),@('ceCancelButton','Cancel Edit','CarryingEdit_CancelButton'))
    for($i=0;$i -lt 3;$i++){
        $x=$left+$i*($base.Width+8)
        Assert ($x+$base.Width -le $s.Range('AJ1').Left+$s.Range('AJ1').Width) 'Editor toolbar exceeds grid width.'
        Assert ($base.Top+$base.Height -le $s.Range('Z3').Top) 'Toolbar overlaps feedback.'
        $button=$s.Shapes.AddFormControl(0,$x,$base.Top,$base.Width,$base.Height)
        $button.Name=$definitions[$i][0];$button.Placement=$base.Placement;$button.Visible=-1
        $button.DrawingObject.PrintObject=$true;$button.TextFrame.Characters().Text=$definitions[$i][1]
        $button.TextFrame.Characters().Font.Size=$base.TextFrame.Characters().Font.Size
        $button.OnAction="'"+$b.Name.Replace("'","''")+"'!"+$definitions[$i][2]
        $button.ControlFormat.Enabled=($i -eq 0)
    }
    $s.Shapes.Item('ceInsertButton').OnAction="'"+$b.Name.Replace("'","''")+"'!CarryingEdit_InsertGuard"
    $s.Shapes.Item('ceRecurringButton').OnAction="'"+$b.Name.Replace("'","''")+"'!CarryingEdit_RecurringGuard"
    [void]$v.VBComponents.Import((Join-Path $PSScriptRoot 'BYHCarryingEdit.bas'))
    foreach($c in $v.VBComponents){if($code.ContainsKey($c.Name)){
        $after=if($c.CodeModule.CountOfLines){$c.CodeModule.Lines(1,$c.CodeModule.CountOfLines)}else{''}
        Assert ($after -ceq $code[$c.Name]) "Original VBA changed: $($c.Name)"
    }}
    $after=$t.DataBodyRange.Formula2
    for($r=1;$r -le $before.GetLength(0);$r++){for($c=1;$c -le $before.GetLength(1);$c++){Assert ($before[$r,$c] -ceq $after[$r,$c]) "Record changed $r,$c"}}
    Assert ($null -eq $b.LinkSources(1)) 'Unexpected external links.'
    $e.Calculation=-4105;$e.CalculateFullRebuild()
    Assert ([math]::Abs($b.Worksheets.Item('Profit').Range('B43').Value2-$profit) -lt .001) 'Total changed.'
    $s.Activate();$s.Range('A1').Select();$b.Save()
    [ordered]@{output=$Output;records=$t.ListRows.Count;profit=$profit;originalVbaPreserved=$code.Count;newButtons=3;calculation=$e.Calculation}|ConvertTo-Json
}finally{
    if($b){$b.Close($false)};$e.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($e)
    [GC]::Collect();[GC]::WaitForPendingFinalizers()
}
