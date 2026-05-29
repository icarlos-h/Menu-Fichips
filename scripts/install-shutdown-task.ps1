$ErrorActionPreference = "Stop"

$TaskName = "Menu FiChips - Desligar Meia-Noite"

$Action = New-ScheduledTaskAction `
    -Execute "shutdown.exe" `
    -Argument "/s /f /t 30 /c `"Desligamento automático do Menu FiChips.`""

$Trigger = New-ScheduledTaskTrigger -Daily -At "00:00"

$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Description "Desliga o computador automaticamente todos os dias à meia-noite." `
    -Force

Write-Host "Tarefa criada/atualizada: $TaskName"
