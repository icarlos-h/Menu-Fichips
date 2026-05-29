$Tasks = @(
    "Menu FiChips - Abrir Telas",
    "Menu FiChips - Desligar Meia-Noite",
    "DigitalSignage - Abrir Telas",
    "DigitalSignage - Desligar Meia-Noite"
)

foreach ($Task in $Tasks) {
    $Found = Get-ScheduledTask -TaskName $Task -ErrorAction SilentlyContinue

    if ($Found) {
        Unregister-ScheduledTask -TaskName $Task -Confirm:$false
        Write-Host "Tarefa removida: $Task"
    } else {
        Write-Host "Tarefa não encontrada: $Task"
    }
}
