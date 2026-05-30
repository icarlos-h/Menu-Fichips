param(
    [bool]$FullscreenInsteadOfPositioned = $false
)

$ErrorActionPreference = "Stop"

# Este script foi feito para funcionar neste caminho:
# C:\Users\Usuario\Documents\Menu FiChips\scripts
# Mesmo assim, ele calcula a pasta raiz automaticamente.
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$AppRoot = Join-Path $ProjectRoot "app"

$EdgePaths = @(
    "$env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)

$Edge = $EdgePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $Edge) {
    [System.Windows.Forms.MessageBox]::Show("Microsoft Edge não encontrado.", "Menu FiChips")
    throw "Microsoft Edge não encontrado."
}

function To-FileUrl($Path) {
    return "file:///" + ($Path.Replace("\", "/").Replace(" ", "%20"))
}

$MainScreen = To-FileUrl (Join-Path $AppRoot "screen-1.html")

# Configuração atual: uma única janela 3840x720.
# O HTML principal divide esse painel em 3 colunas internas.
$Monitors = @(
    @{ Url = $MainScreen; X = 0; Y = 0; Width = 3840; Height = 720; Profile = "fichips-main-panel" }
)

# Fecha processos Edge criados por este projeto quando possível.
Get-Process msedge -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -like "*Microsoft\Edge\Application\msedge.exe"
} | Stop-Process -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 2

foreach ($Monitor in $Monitors) {
    $UserDataDir = Join-Path $env:TEMP $Monitor.Profile

    if ($FullscreenInsteadOfPositioned) {
        $Args = @(
            "--new-window",
            "--app=$($Monitor.Url)",
            "--start-fullscreen",
            "--no-first-run",
            "--disable-session-crashed-bubble",
            "--user-data-dir=$UserDataDir"
        )
    } else {
        $Args = @(
            "--new-window",
            "--app=$($Monitor.Url)",
            "--window-position=$($Monitor.X),$($Monitor.Y)",
            "--window-size=$($Monitor.Width),$($Monitor.Height)",
            "--no-first-run",
            "--disable-session-crashed-bubble",
            "--user-data-dir=$UserDataDir"
        )
    }

    Start-Process -FilePath $Edge -ArgumentList $Args
    Start-Sleep -Seconds 1
}
