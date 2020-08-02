local love = require("love")

local la8 = require("la8")

local game = {}

local daylight ---@type Mesh

local function fadeOut(x, y, w, h, v)
	return v * (1 - y / (h - 1))
end

function game.init(arg)
	game.ground = love.graphics.newImage(la8.set(game.createRandomTile(1234, fadeOut, 32, 32)))
	game.font = love.graphics.newFont(9, "mono", 1)
	game.font:setFilter("nearest", "nearest")
end

function game.update(dt)
end

function game.draw()
	love.graphics.clear()

	love.graphics.draw(game.ground, 64, 32)
	love.graphics.draw(game.ground, 64+32, 32)
	love.graphics.draw(game.ground, 64-32, 32)
	love.graphics.print("game.ground pixfmt: "..game.ground:getFormat(), game.font)
end

function game.createRandomTile(seed, post, w, h, octave)
	octave = octave or 4
	w = w or 16
	h = h or 16
	local rng = love.math.newRandomGenerator(seed)
	local ix = rng:random() * octave
	local iy = rng:random() * octave

	local img = love.image.newImageData(w, h, "rg8")
	img:mapPixel(function(x, y, r, g, b, a)
		local s = x / w
		local t = y / h
		local xd = ix / 2 / math.pi
		local yd = ix / 2 / math.pi

		local v = love.math.noise(
			ix + math.cos(s * 2 * math.pi) * xd,
			iy + math.cos(t * 2 * math.pi) * yd,
			ix + math.sin(s * 2 * math.pi) * xd,
			iy + math.sin(t * 2 * math.pi) * yd
		)
		if post then
			v = post(x, y, w, h, v)
		end

		return v, 1, 1, 1
	end)

	return img
end

return game
