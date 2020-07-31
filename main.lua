local ffi = require("ffi")
local love = require("love")

local la8 = require("la8")

function love.load()
	la8ImageData = love.image.newImageData(256, 256, "rg8")
	la8ImageData:mapPixel(function(x, y)
		local a = (y - x) % 64 / 63
		return 0.5, a, 0.5, 0.5, 1
	end)
	la8.set(la8ImageData)
	la8img = love.graphics.newImage(la8ImageData)
	print(la8img:getFormat())
end

function love.draw()
	love.graphics.draw(la8img, 128, 128)
end
