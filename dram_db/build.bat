@echo off
del /S /Q build
@echo Building...
go build -o build/lib.a -buildmode=c-shared
@echo Built!