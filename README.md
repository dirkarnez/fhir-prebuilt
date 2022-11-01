fhir-prebuilt
=============
- [Getting Started with Bazel Docker Container](https://bazel.build/install/docker-container)

### TODOs
- [ ] Redo using msvc [dirkarnez/bazel-msys2-mingw64](https://github.com/dirkarnez/bazel-msys2-mingw64)
- [ ] Redo using [dirkarnez/docker-bazel](https://github.com/dirkarnez/docker-bazel)
  - ```bazel build //cc/google/fhir/...```

### Old settings
```cmd
REM run as Administrator
@echo off

@REM expect JAVA installation in path, WIP

set DOWNLOADS_DIR=%USERPROFILE%\Downloads
set DOWNLOADS_DIR_LINUX=%DOWNLOAD_DIR:\=/%

@REM set ROOT=%DOWNLOADS_DIR%
set ROOT=D:\Softwares

rem del %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin\bash

mklink %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin\bash.exe  %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\mingw64\bin\bash.exe
mklink D:\Softwares\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\mingw64\usr\bin\bash   %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\mingw64\bin\bash.exe
rem mklink %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\mingw64\bin\gcc.exe %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin\gcc.exe  
rem mklink /j %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\mingw64\bin\ %ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin\ 

SET JAVA_HOME=%ROOT%\jdk-11.0.13+8
set BAZEL_SH=%ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin\bash

SET PATH=^
C:\Windows\System32\WindowsPowerShell\v1.0;^
%ROOT%\PortableGit\bin;^
%ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0;^
%ROOT%\x86_64-8.1.0-release-posix-seh-rt_v6-rev0\bin;^
%ROOT%\cmake-3.23.0-rc1-windows-x86_64\bin;^
%ROOT%\bazel\bazel-5.3.2-windows-x86_64;^
%ROOT%jdk-11.0.13+8\bin

bazel query @local_config_cc//:toolchain --output=build
pause
bazel build --compiler=mingw-gcc //cc/google/fhir:references --verbose_failures &&^
echo "Successful build"
pause
```
