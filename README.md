# Menu FiChips - Digital Signage Local

Projeto base para abrir um painel local de 3840x720 em um computador Windows, dividido visualmente em 3 colunas.

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
- abertura automática do painel 3840x720 5 minutos após login
- desligamento automático todos os dias à meia-noite

## Remover tarefas automáticas

Clique com botão direito em:

scripts\remover-tarefas.bat

E escolha:

Executar como administrador

## Importante sobre o painel

A configuração atual abre apenas um documento principal:

app\screen-1.html

Esse documento foi pensado para uma área de 3840x720 e é dividido em 3 colunas internas.

A primeira coluna mostra o produto em destaque com foto, nome, preço e gramatura.
As outras duas colunas ficam reservadas para próximos conteúdos do cardápio.

Se o Windows estiver usando mais de uma TV/saída de vídeo, configure a resolução final para entregar um painel único de 3840x720 ou ajuste `scripts\launch-screens.ps1` conforme o mapeamento real da tela.

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
# Menu-Fichips
