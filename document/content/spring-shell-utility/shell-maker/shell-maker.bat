@ECHO off
setlocal enableDelayedExpansion
IF "%1" == "" (
  ECHO usage: %0 "<main class full path>"
  ECHO example: %0 com.example.demo.DemoApplication
  EXIT 1
) ELSE (
  ECHO main class: %1
  SET MAIN_CLASS_FULL_PATH=%1
)

set NL=^



set SHELL_NAME=bin-script-generator-bat.sh
ECHO #^^!/bin/bash !NL!>!SHELL_NAME!
ECHO DEFAULT_MAIN_CLASS_FULL_PATH=%MAIN_CLASS_FULL_PATH% !NL!>>!SHELL_NAME!
type shell-maker-script.sh>>!SHELL_NAME!

copy !SHELL_NAME! ..\
endlocal
