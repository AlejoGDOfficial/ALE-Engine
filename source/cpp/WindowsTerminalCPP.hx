package cpp;

/**
 * This file is in charge of providing some Windows terminal functions 
 * 
 * Author: Slushi
 */

#if windows
@:cppFileCode('
#include <Windows.h>
#include <windowsx.h>
#include <cstdio>
#include <iostream>
#include <tchar.h>
#include <dwmapi.h>
#include <winuser.h>
#include <winternl.h>
#include <Shlobj.h>
#include <commctrl.h>
#include <string>

#define UNICODE

#pragma comment(lib, "Dwmapi")
#pragma comment(lib, "ntdll.lib")
#pragma comment(lib, "User32.lib")
#pragma comment(lib, "Shell32.lib")
#pragma comment(lib, "gdi32.lib")
')
class WindowsTerminalCPP
{
	@:functionCode('
        system("CLS");
        std::cout<< "" <<std::flush;
    ')
	public static function clearTerminal() {}

	@:functionCode('
        if (!AllocConsole())
            return;

        freopen("CONIN$", "r", stdin);
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);

        HANDLE output = GetStdHandle(STD_OUTPUT_HANDLE);
        SetConsoleMode(output, ENABLE_PROCESSED_OUTPUT | ENABLE_VIRTUAL_TERMINAL_PROCESSING);
    ')
	public static function allocConsole() 
    {
        CoolVars.isConsoleVisible = true;
    }

	@:functionCode('
        SetConsoleTitleA(text);
    ')
	public static function setConsoleTitle(text:String) {}

	@:functionCode('
        HWND hwnd = GetConsoleWindow();
        HMENU hmenu = GetSystemMenu(hwnd, FALSE);
        EnableMenuItem(hmenu, SC_CLOSE, MF_GRAYED);
    ')
	public static function disableCloseConsoleWindow() {}

	@:functionCode('
        HWND hChild = GetConsoleWindow();
        ShowWindow(hChild, SW_HIDE);
    ')
	public static function hideConsoleWindow()
    {
        CoolVars.isConsoleVisible = false;
    }
}
#end