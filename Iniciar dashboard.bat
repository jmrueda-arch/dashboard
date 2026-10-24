@echo off
title Observatorio de ventas - servidor
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"
