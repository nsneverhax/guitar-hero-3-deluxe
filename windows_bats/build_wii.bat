@echo OFF
for /R "%~dp0..\build\wii\files\deluxe" %%f in (*) do del "%%f"
rmdir /s /q "%~dp0..\build\wii\files\deluxe"
echo:Building Guitar Hero 3 Deluxe files...
"%~dp0..\dependencies\windows\Honeycomb-CLI\honeycomb" pak compile "%~dp0..\_qb" -g gh3 -c wii
mkdir "%~dp0..\build\wii\files\deluxe"
move "%~dp0..\_qb.pak.ngc" "%~dp0..\build\wii\files\deluxe\gh3dx.pak.ngc"
echo:Created Guitar Hero 3 Deluxe files.
echo:Complete! Copy the contents of the wii folder in build into your GH3 Disc folder.
pause