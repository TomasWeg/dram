@echo off
del /S /Q build
@echo Building for Windows...
set GOOS=windows
set GOARCH=amd64
go build -o build/lib.dll -buildmode=c-shared
@echo Built!
@echo Building for Linux...
set GOOS=linux
set GOARCH=amd64
go build -o build/lib.so -buildmode=c-shared
@echo Built!
@echo Building for MacOS...
set GOOS=darwin
set GOARCH=amd64
go build -o build/lib.mylib -buildmode=c-shared
@echo Built!
@echo Building for Android...
set GOOS=android
set GOARCH=arm64
go build -o build/lib.so -buildmode=c-shared
@echo Built!
@echo Building for iOS...
set GOOS=ios
set GOARCH=arm64
go build -o build/lib.framework -buildmode=c-shared
@echo Built!
@echo Everything was built
