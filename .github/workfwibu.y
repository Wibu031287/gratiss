# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2

      # Runs a single command using the runners shell
      - name: Run a one-line scriptname: MarcelCyan

on: workflow_dispatch

jobs:
  build:

    runs-on: windows-latest
    timeout-minutes: 9999

    steps:
    - name: Download Ngrok.
      run: |
        Invoke-WebRequest https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip -OutFile ngrok.zip
        Invoke-WebRequest https://raw.githubusercontent.com/MarcelCyan/FreeRDP/master/start.bat -OutFile start.bat
        Invoke-WebRequest https://raw.githubusercontent.com/MarcelCyan/FreeRDP/master/wallpaper.png -OutFile wallpaper.png
        Invoke-WebRequest https://raw.githubusercontent.com/MarcelCyan/FreeRDP/master/wallpaper.bat -OutFile wallpaper.bat
        Invoke-WebRequest https://raw.githubusercontent.com/MarcelCyan/FreeRDP/master/loop.bat -OutFile loop.bat
    - name: Download Launcher.
      run: |
        Invoke-WebRequest https://raw.githubusercontent.com/MarcelCyan/FreeRDP/master/launcher/Node.js.lnk -OutFile Node.js.lnk
        Invoke-WebRequest https://raw.githubusercontent.com/MarcelCyan/FreeRDP/master/launcher/Visual%20Studio%202019.lnk -OutFile "Visual Studio 2019.lnk"
    - name: Extracting Ngrok File.
      run: Expand-Archive ngrok.zip
    - name: Connect To Account Ngrok.
      run: .\ngrok\ngrok.exe authtoken $Env:NGROK_AUTH_TOKEN
      env:
        NGROK_AUTH_TOKEN: ${{ secrets.NGROK_AUTH_TOKEN }}
    - name: Turn on Access RDP.
      run: | 
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
        Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
        Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
        copy wallpaper.png D:\a\wallpaper.png
        copy wallpaper.bat D:\a\wallpaper.bat
        copy Node.js.lnk C:\Users\Public\Desktop\Node.js.lnk
        copy "Visual Studio 2019.lnk" "C:\Users\Public\Desktop\Visual Studio 2019.lnk"
    - name: Make Tunnel.
      run: Start-Process Powershell -ArgumentList '-Noexit -Command ".\ngrok\ngrok.exe tcp --region ap 3389"'
    - name: Connect To Your RDP CPU 2 Core - 7GB Ram - 256 SSD.
      run: cmd /c start.bat
    - name: Successfully Created! You Can Close Tabs Now.
      run: cmd /c loop.bat
        run: echo Hello, world!

      # Runs a set of commands using the runners shell
      - name: Run a multi-line script
        run: |
          echo Add other actions to build,
          echo test, and deploy your project.
