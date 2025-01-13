@echo OFF
for /R "%~dp0..\build\pc\DATA\DELUXE" %%f in (*) do del "%%f"
rmdir /s /q "%~dp0..\build\pc\DATA\DELUXE"
echo:Building Guitar Hero 3 Deluxe files...
"%~dp0..\dependencies\windows\Honeycomb-CLI\honeycomb" pak compile "%~dp0..\_qb" -g gh3 -c pc
mkdir "%~dp0..\build\pc\DATA\DELUXE"
move "%~dp0..\_qb.pak.xen" "%~dp0..\build\pc\DATA\DELUXE\gh3dx.pak.xen"
echo:Created Guitar Hero 3 Deluxe files.
echo:Complete! Copy the contents of the pc folder in build into your GH3 install folder.
pause