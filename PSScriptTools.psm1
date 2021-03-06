
Get-ChildItem -path $PSScriptRoot\*.ps1 | foreach-object -process {
    . $_.FullName
}

$aliases = @()
$aliases+= Set-Alias -Name Tee-Verbose -Value Out-VerboseTee -PassThru
$aliases+= Set-Alias -Name occ -Value Out-ConditionalColor -PassThru
$aliases+= Set-Alias -Name pswho -Value Get-PSWho -PassThru
$aliases+= Set-Alias -Name cc -Value Copy-Command -PassThru
$aliases+= Set-Alias -Name fv -Value Format-Value -PassThru
$aliases+= Set-Alias -Name fp -value Format-Percent -PassThru
$aliases+= Set-Alias -name fs -value Format-String -PassThru
$aliases+= Set-Alias -Name om -Value Out-More -PassThru
$aliases+= Set-Alias -name ibx -value Invoke-InputBox -PassThru

$exportParams = @{
    Function = 'Add-Border','Tee-Verbose','Write-Detail','Out-VerboseTee',
    'Get-PSWho','Out-ConditionalColor','New-RandomFileName','New-CustomFileName',
    'Copy-Command','Format-Value','Format-String','Format-Percent','Get-PSLocation',
    'Get-PowerShellEngine','Out-More','Invoke-Inputbox'
    Alias = $aliases.Name
}
Export-ModuleMember @exportParams

if ($psEditor) {
    $sb = {
        Param(
            [Microsoft.PowerShell.EditorServices.Extensions.EditorContext]$context
        )
    
        Add-Type -AssemblyName "microsoft.visualbasic" -ErrorAction Stop 
        $prompt = "What do you need to do?"
        $title = "To Do"
        $item = Invoke-Inputbox -Title $title -Prompt $prompt
        $todo = "# [$(Get-Date)] TODO: $item"
        $context.CurrentFile.InsertText($todo)
    }
    Register-EditorCommand -Name "Insert.ToDo" -DisplayName "Insert ToDo" -ScriptBlock $sb -SuppressOutput
    
}
elseif ($psise) {
    $action = { 
        Add-Type -AssemblyName "microsoft.visualbasic" -ErrorAction Stop 
        $prompt = "What do you need to do?"
        $title = "To Do"
        $item = Invoke-Inputbox -Title $title -Prompt $prompt
        $todo = "# [$(Get-Date)] TODO: $item"
        $psise.CurrentFile.Editor.InsertText($Todo)
        #jump cursor to the end
        $psise.CurrentFile.editor.SetCaretPosition($psise.CurrentFile.Editor.CaretLine,$psise.CurrentFile.Editor.CaretColumn)
    }
    
    #add the action to the Add-Ons menu
    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ToDo",$Action,"Ctrl+Alt+2" ) | Out-Null
}
