git pull https://github.com/LlysiX/guitar-hero-3-deluxe main
@echo OFF
for /R "%~dp0..\build\xbox\DATA\DELUXE" %%f in (*) do del "%%f"
rmdir /s /q "%~dp0..\build\xbox\DATA\DELUXE"
echo:Building Guitar Hero 3 Deluxe files...
"%~dp0..\dependencies\windows\Honeycomb-CLI\honeycomb" pak compile "%~dp0..\_qb" -g gh3 -c xbox
mkdir "%~dp0..\build\xbox\DATA\DELUXE"
move "%~dp0..\_qb.pak.xen" "%~dp0..\build\xbox\DATA\DELUXE\deluxe.pak.xen"
echo:Created Guitar Hero 3 Deluxe files.
echo:Complete! Copy the contents of the xbox folder in build into your GH3 Disc folder.
pause