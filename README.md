# Menu FiChips - Digital Signage Local

Projeto base para abrir 3 telas locais em um computador Windows.

## Caminho recomendado

Extraia a pasta exatamente em:

C:\Users\Usuario\Documents\Menu FiChips

A estrutura deve ficar assim:

C:\Users\Usuario\Documents\Menu FiChips
├── app
│   ├── screen-1.html
│   ├── screen-2.html
│   ├── screen-3.html
│   └── assets
└── scripts
    ├── abrir-menu.bat
    ├── launch-screens.ps1
    ├── instalar-inicializacao.bat
    ├── install-startup-task.ps1
    ├── install-shutdown-task.ps1
    └── remover-tarefas.bat

## Teste manual

Clique duas vezes em:

scripts\abrir-menu.bat

## Instalar abertura automática

Clique com botão direito em:

scripts\instalar-inicializacao.bat

E escolha:

Executar como administrador

Isso cria:
- abertura automática 5 minutos após login
- desligamento automático todos os dias à meia-noite

## Remover tarefas automáticas

Clique com botão direito em:

scripts\remover-tarefas.bat

E escolha:

Executar como administrador

## Importante sobre as telas

Para mostrar 3 conteúdos diferentes, o Windows precisa reconhecer 3 monitores diferentes.

Não serve HDMI splitter comum, porque splitter comum só espelha a mesma imagem.

O correto é usar:
- 3 saídas de vídeo reais
- adaptador USB/DisplayLink
- placa de vídeo com múltiplas saídas
- controlador/matriz que entregue telas independentes

No Windows, use:

Configurações > Sistema > Tela > Estender estes vídeos

## Ligar automaticamente às 08:00

Script não liga computador totalmente desligado.

Para ligar às 08:00, configure na BIOS/UEFI:

- RTC Alarm
- Wake on RTC
- Power On By RTC
- Resume By Alarm
- Automatic Power On

Também ative, se disponível:

- Restore on AC Power Loss
- Power On After Power Failure
# Menu-Fichips
# Menu-Fichips
# Menu-Fichips
