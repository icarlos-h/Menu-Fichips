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

$Screen1 = To-FileUrl (Join-Path $AppRoot "screen-1.html")
$Screen2 = To-FileUrl (Join-Path $AppRoot "screen-2.html")
$Screen3 = To-FileUrl (Join-Path $AppRoot "screen-3.html")

# Ajuste estes valores quando as 3 telas estiverem conectadas.
# Configuração padrão: 3 telas Full HD lado a lado.
$Monitors = @(
    @{ Url = $Screen1; X = 0;    Y = 0; Width = 1920; Height = 1080; Profile = "fichips-screen-1" },
    @{ Url = $Screen2; X = 1920; Y = 0; Width = 1920; Height = 1080; Profile = "fichips-screen-2" },
    @{ Url = $Screen3; X = 3840; Y = 0; Width = 1920; Height = 1080; Profile = "fichips-screen-3" }
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
