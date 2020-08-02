local ffi = require("ffi")
local love = require("love")

local la8 = require("la8")

local game = require("game")

local canvas ---@type Canvas
local lashader ---@type Shader

function love.load(arg)
	local format = love.graphics.getCanvasFormats().r8 and "r8" or "normal"

	-- Init game
	game.init(arg)

	-- Init canvas
	canvas = love.graphics.newCanvas(320, 180, {dpiscale = 1, format = format})
	canvas:setFilter("nearest", "nearest")

	-- Init shader
	lashader = love.graphics.newShader([[
		const float QUANTIZE = 64.0;

		vec4 effect(vec4 _, Image i, vec2 t, vec2 s)
		{
			return vec4(floor(Texel(i, t).rrr * QUANTIZE) / QUANTIZE, 1.0);
		}
	]])
end

love.update = game.update

function love.draw()
	canvas:renderTo(game.draw)

	local w, h = love.graphics.getDimensions()
	love.graphics.setShader(lashader)
	love.graphics.setBlendMode("none")
	love.graphics.draw(canvas, 0, 0, 0, w / 320, h / 180)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setShader()
end
