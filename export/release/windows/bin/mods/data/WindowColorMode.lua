                      -----------------------------
                    --   WINDOW DARK MODE IN LUA   --
					--   CUSTOM COLORS EXTENSION   --
                      -----------------------------   

						    --   CREDITS   --						    
--   Script and code made by T-Bar: https://www.youtube.com/@tbar7460  --
--    (please leave this message in the script, it acts as credits)    --
--                                  :D                                 --

local ffi = require("ffi");
local dwmapi = ffi.load("dwmapi");
local addr = ffi.load("mods" ..((currentModDirectory == nil or currentModDirectory == "") and "/" or tostring("/" ..currentModDirectory.. "/")).. "include/AddressParser"); --Had to make a whole new libary to grab a variable's address...

ffi.cdef([[
	typedef void* CONST;
    typedef void* HWND;
    typedef unsigned long DWORD;
	typedef const void *LPCVOID;
	typedef int BOOL;
	
	typedef long LONG;
	typedef LONG HRESULT;
	
	HWND GetActiveWindow();
	HRESULT DwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);
	void UpdateWindow(HWND hWnd);
	int* get_address(int& var);
]])

local S_OK = 0x00000000;

---Internal function used to parse the weird BBGGRR format into a normal hexidecimal
--Made by Ghostglowdev
function _rgbHexToBGR(rgb)
	-- conv int hex to string hex
	if type(rgb) == 'number' then rgb = runHaxeCode('return StringTools.hex('.. rgb ..');') end
	-- discard if hex isn't string
	if type(rgb) ~= 'string' then 
		debugPrint('ERROR on loading: '.. scriptName ..': _rgbHexToBGR: Failed to parse into BGR format.') 
		return rgb
	end
	-- discard extras
	rgb = stringStartsWith(rgb, '0x') and rgb:sub(3,8) or stringStartsWith(rgb, '#') and rgb:sub(2,7) or rgb
	rgb = #rgb > 6 and rgb:sub(1,6) or rgb

	-- parse
	local b, g, r = rgb:sub(5,6), rgb:sub(3,4), rgb:sub(1,2)
	return b..g..r 
end

---Sets the window to dark mode
function setDarkMode()
	local window = ffi.C.GetActiveWindow();
	local isDark = dwmapi.DwmSetWindowAttribute(window, 19, addr.get_address(ffi.new("int[1]", 1)), ffi.sizeof(ffi.cast("DWORD", 1)));

	if isDark == 0 or isDark ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, addr.get_address(ffi.new("int[1]", 1)), ffi.sizeof(ffi.cast("DWORD", 1)));
	end
	
	ffi.C.UpdateWindow(window);
end

---Sets the window to light mode
function setLightMode()
	local window = ffi.C.GetActiveWindow();
	local isLight = dwmapi.DwmSetWindowAttribute(window, 19, addr.get_address(ffi.new("int[1]", 0)), ffi.sizeof(ffi.cast("DWORD", 0)));

	if isLight == 0 or isLight ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, addr.get_address(ffi.new("int[1]", 0)), ffi.sizeof(ffi.cast("DWORD", 0)));
	end
	
	ffi.C.UpdateWindow(window);
end

---Shortcut to both "setDarkMode" and "setLightMode", as one function
---@param isDark boolean Is the window dark mode?
function setWindowColorMode(isDark)
	local window = ffi.C.GetActiveWindow();
	local isDarkMode = (isDark and 1 or 0);
	local isColorMode = dwmapi.DwmSetWindowAttribute(window, 19, addr.get_address(ffi.new("int[1]", isDarkMode)), ffi.sizeof(ffi.cast("DWORD", isDarkMode)));

	if isColorMode == 0 or isColorMode ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, addr.get_address(ffi.new("int[1]", isDarkMode)), ffi.sizeof(ffi.cast("DWORD", isDarkMode)));
	end
	
	ffi.C.UpdateWindow(window);
end

---(Windows 11 ONLY) Sets the window border and header to a color of your choosing
---@param colorHex string The hexidecimal for the color. (The hex should be 0xRRGGBB, '0xRRGGBB', '#RRGGBB', 'RRGGBB')
---@param setHeader boolean Do you want to set the header's color?
---@param setBorder boolean Do you want to set the window border's color?
function setWindowBorderColor(colorHex, setHeader, setBorder)
	local window = ffi.C.GetActiveWindow();
	local strHex = (colorHex == nil or (type(colorHex) ~= 'number' and #colorHex < 6 or false)) and '0xFFFFFF' or _rgbHexToBGR(colorHex)
	local hex = tonumber('0x'..strHex)
	
	if setHeader == nil then setHeader = true end
	if setBorder == nil then setBorder = true end
	
	if setHeader then dwmapi.DwmSetWindowAttribute(window, 35, addr.get_address(ffi.new("int[1]", (hex))), ffi.sizeof(ffi.cast("DWORD", (hex)))); end
	if setBorder then dwmapi.DwmSetWindowAttribute(window, 34, addr.get_address(ffi.new("int[1]", (hex))), ffi.sizeof(ffi.cast("DWORD", (hex)))); end

	ffi.C.UpdateWindow(window);
end

---Resets the window. Be sure to run this after using "setDarkMode" to force the effect immediately
function resetScreenSize()
	setPropertyFromClass('lime.app.Application', 'current.window.fullscreen', true);
	setPropertyFromClass('lime.app.Application', 'current.window.fullscreen', false);
	ffi.C.UpdateWindow(ffi.C.GetActiveWindow());
end

                          -- -- Add your extra code here. -- --                        
-- This is currently a template that sets the window to dark mode for one song. Go crazy! --

function onCreate()
	setWindowColorMode(true)
	resetScreenSize();
end

local shit = false

function onUpdate()
	setWindowBorderColor('0xFF00FF', true, true)
end

function onDestroy()
	setWindowColorMode(false)
	resetScreenSize();
end