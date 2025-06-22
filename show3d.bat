@if (true == false) @end /*
@echo off
title CST-3DViewer (Bigger Screen, Centered Cube)
color 0A
mode 80,30
setlocal EnableDelayedExpansion

:: Bigger graphics buffer
if defined __ goto :START
set __=.
cmdgfx_input.exe m0unW14x | call %0 %* | cmdgfx_gdi "" Sf0:0,0,100,40W0
set __=
goto :eof

:START
:: Bigger screen means bigger midpoints
set /a XMID=100/2, YMID=40/2
set /a DIST=2000, ASPECT=1000/1000
set /a RY=30
set /a RX=20
set /a ZOOM=1200
set /a CUBE_Z_POS=4000

:: Start JScript part
cscript //nologo //e:javascript "%~f0"
exit /b 0
*/

// ----- JScript Below -----
var shell = new ActiveXObject("WScript.Shell");
var stdin = WScript.StdIn;

var XMID = parseInt(shell.ExpandEnvironmentStrings("%XMID%")) || 50;
var YMID = parseInt(shell.ExpandEnvironmentStrings("%YMID%")) || 20;
var DIST = parseInt(shell.ExpandEnvironmentStrings("%DIST%")) || 2000;
var RX = parseInt(shell.ExpandEnvironmentStrings("%RX%")) || 20;
var RY = parseInt(shell.ExpandEnvironmentStrings("%RY%")) || 30;
var ZOOM = parseInt(shell.ExpandEnvironmentStrings("%ZOOM%")) || 1200;
var CUBE_Z_POS = parseInt(shell.ExpandEnvironmentStrings("%CUBE_Z_POS%")) || 4000;

var ASPECT = 1.0;
var CUBE_MODEL = "3d cube.ply";
var CUBE_POSITION_X = 0;
var CUBE_POSITION_Y = -150;
var CUBE_SCALE = "-250,-250,-250,0,0,0";
var CUBE_LIGHTING = "0,0,0,10";

var cubecols_palettes = [
    "4 c db 4 c db  4 c b1  4 c b1  4 c 20",
    "6 0 db 6 0 db  6 e b1  6 e b1  6 e 20",
    "2 a db 2 a db  2 a b1  2 a b1  2 a 20",
    "5 d db 5 d db  5 d b1  5 d b1  5 d 20"
];

while (true) {
    WScript.Echo("\"cmdgfx: fbox 0 0 20 0,0,100,40\"");

    var effectiveZ = CUBE_Z_POS * (ZOOM / 1000);
    var colorPaletteIndex = 0;
    if (effectiveZ > 4000) colorPaletteIndex = 1;
    if (effectiveZ > 6000) colorPaletteIndex = 2;
    if (effectiveZ > 8000) colorPaletteIndex = 3;
    if (colorPaletteIndex >= cubecols_palettes.length)
        colorPaletteIndex = cubecols_palettes.length - 1;

    var CUBE_COLORS = cubecols_palettes[colorPaletteIndex];

    var drawCommand = CUBE_MODEL + " 0,-1 " + RX + "," + RY + ",0 " +
                      CUBE_POSITION_X + "," + CUBE_POSITION_Y + "," + CUBE_Z_POS + " " +
                      CUBE_SCALE + " " + CUBE_LIGHTING + " " +
                      XMID + "," + YMID + "," + ZOOM + "," + ASPECT + " " + CUBE_COLORS;

    WScript.Echo("\"cmdgfx: " + drawCommand + "\"");
    WScript.Sleep(50);

    var input = stdin.ReadLine();
    var parts = input.split(" ");
    var isKeyPressed = parts[3];
    var key = parts[5];

    if (isKeyPressed == "1") {
        if (key == "27") break;
        if (key == "328") RX -= 5;
        if (key == "336") RX += 5;
        if (key == "331") RY -= 5;
        if (key == "333") RY += 5;
        if (key == "43") ZOOM += 100;
        if (key == "45") ZOOM -= 100;
        if (key == "338") CUBE_Z_POS += 200;
        if (key == "337") CUBE_Z_POS -= 200;
    }

    RX = (RX % 360 + 360) % 360;
    RY = (RY % 360 + 360) % 360;
    if (ZOOM < 100) ZOOM = 100;
    if (ZOOM > 10000) ZOOM = 10000;
    if (CUBE_Z_POS < 1000) CUBE_Z_POS = 1000;
    if (CUBE_Z_POS > 10000) CUBE_Z_POS = 10000;
}

WScript.Echo("\"cmdgfx: quit\"");
