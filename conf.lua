local love = require("love")
local ffi = require("ffi")

local SDL = ffi.load("SDL2")
ffi.cdef[[
int Setenv(const char *, const char *, int) asm("SDL_setenv");
]]

SDL.Setenv("LOVE_GRAPHICS_USE_GL2", "1", 1) -- HACK LA8 SUPPORT

function love.conf(t)
	t.window.width = 960
	t.window.height = 540
	t.modules.joystick = false
	t.modules.video = false
end
