@echo off
FOR /f "tokens=1,2*" %%E in ('reg query "HKEY_CURRENT_USER\Software\Valve\Steam"') DO (
	IF "%%E"=="SteamPath" (
		set SteamPath=%%G
	)
)
IF "%SteamPath%"=="" (
	echo Not able to determine Steam install path. Make sure you have Steam installed
	pause
	exit /B
)
IF "%sourcesdk%"=="" (
	echo SourceSDK environment variable is not set. Run Source SDK once before executing this script
	pause
	exit /B
)

set GameDir=%SteamPath%/steamapps/common/Fortress Forever
set ModDir=%GameDir%/FortressForever

IF NOT EXIST "%GameDir%" (
	echo "%GameDir%" does not exist. Make sure Fortress Forever is installed
	pause
	exit /B
)

set Ep1BinDir=%sourcesdk%\bin\ep1\bin
set ConfigFile=%Ep1BinDir%\GameConfig.txt
set SchemeDir=%Ep1BinDir%\resource
set SchemeFile=%SchemeDir%\SourceScheme.res
set GameInfoDir=%GameDir%/sdk
set GameInfoFile=%GameInfoDir%/gameinfo.txt

echo(
echo Writing "%ConfigFile%"...
(
echo "Configs"
echo {
echo 	"SDKVersion"		"2"
echo 	"Games"
echo 	{
echo 		"Fortress Forever"
echo 		{
echo 			"GameDir"		"%GameDir%/sdk"
echo 			"hammer"
echo 			{
echo 				"GameData0"		"%ModDir%/fortressforever.fgd"
echo 				"TextureFormat"		"5"
echo 				"MapFormat"		"4"
echo 				"DefaultTextureScale"		"0.250000"
echo 				"DefaultLightmapScale"		"16"
echo 				"GameExe"		"%GameDir%/hl2.exe"
echo 				"DefaultSolidEntity"		"func_detail"
echo 				"DefaultPointEntity"		"info_ff_script"
echo 				"BSP"		"%Ep1BinDir%\vbsp.exe"
echo 				"Vis"		"%Ep1BinDir%\vvis.exe"
echo 				"Light"		"%Ep1BinDir%\vrad.exe"
echo 				"GameExeDir"		"%GameDir%"
echo 				"MapDir"		"%ModDir%/mapsrc"
echo 				"BSPDir"		"%ModDir%/maps"
echo 				"CordonTexture"		"tools\toolsskybox"
echo 				"MaterialExcludeCount"		"0"
echo 			}
echo 		}
echo 	}
echo }
) >"%ConfigFile%"
echo  -^> Done

IF NOT EXIST "%GameInfoDir%" mkdir "%GameInfoDir%"
echo(
echo Writing "%GameInfoFile%"...
(
echo "GameInfo"
echo {
echo 	game	"Fortress Forever"
echo 	title	"Fortress Forever"
echo 	name	"Fortress Forever"
echo 	type multiplayer_only
echo(
echo 	FileSystem
echo 	{
echo 		SteamAppId				215
echo 		ToolsAppId				211
echo 		SearchPaths
echo 		{
echo 			Game				^|gameinfo_path^|..\FortressForever
echo 			Game				^|gameinfo_path^|..\hl2
echo 			Game				^|gameinfo_path^|..\platform
echo 		}
echo 	}
echo }
) > "%GameInfoFile%"
echo  -^> Done

:: Need a SourceScheme.res in bin/ep1/bin/resource so that Hammer doesn't throw
:: a 'Failed to load the default scheme file' error
:: The contents of this scheme file are unimportant; it can be totally blank
echo(
echo Writing "%SchemeFile%"...
IF NOT EXIST "%SchemeFile%" (
	IF NOT EXIST "%SchemeDir%" mkdir "%SchemeDir%"
    echo( >"%SchemeFile%"
    echo  -^> Done
) ELSE (
    echo  -^> File already exists
)

echo(
echo Source SDK setup completed successfully.
echo(

pause
