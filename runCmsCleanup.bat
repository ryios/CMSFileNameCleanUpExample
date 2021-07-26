
set pathToFiles=./ExampleFiles
set logFile= ./cleanUpLog.txt

Powershell.exe -executionpolicy remotesigned -File .\Scripts\cleanUpFileNames.ps1 %pathToFiles% %logFile%
