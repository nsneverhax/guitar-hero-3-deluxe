git pull https://github.com/LlysiX/guitar-hero-3-deluxe main
@echo OFF
for /R "%~dp0..\build\ps3\DATA\DELUXE" %%f in (*) do del "%%f"
rmdir /s /q "%~dp0..\build\ps3\DATA\DELUXE"
echo:Building Guitar Hero 3 Deluxe files...
"%~dp0..\dependencies\windows\Honeycomb-CLI\honeycomb" pak compile "%~dp0..\_qb" -g gh3 -c ps3
mkdir "%~dp0..\build\ps3\DATA\DELUXE"
move "%~dp0..\_QB.PAK.PS3" "%~dp0..\build\ps3\DATA\DELUXE\DELUXE.PAK.PS3"
copy "%~dp0..\build\ps3\DATA\DELUXE\DELUXE.PAK.PS3" "%~dp0..\build\ps3\DATA\DELUXE\DELUXE_VRAM.PAK.PS3"
echo:Created Guitar Hero 3 Deluxe files.
echo:Complete! Copy the contents of the ps3 folder in build into your GH3 Disc folder.
pause