$ErrorActionPreference = "Stop"

$TaskName = "Menu FiChips - Abrir Telas"
$ScriptPath = Join-Path $PSScriptRoot "launch-screens.ps1"

if (-not (Test-Path $ScriptPath)) {
    throw "Arquivo não encontrado: $ScriptPath"
}

$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Trigger.Delay = "PT5M"

$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Description "Abre as telas do Menu FiChips 5 minutos após login." `
    -Force

Write-Host "Tarefa criada/atualizada: $TaskName"
