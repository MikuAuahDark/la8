local love = require("love")

local la8 = require("la8")

local map = require("game.map")

local game = {}

local daylight ---@type Mesh

local function fadeOut(x, y, w, h, v)
	v = v or 1
	return v * (1 - y / (h - 1))
end

local function cube(x, y, w, h, v)
	return v * v * v * fadeOut(x, y, w, h, v)
end

local function tiledNoise(x, y, w, h, ix, iy)
	local s = x / w
	local t = y / h
	local xd = ix / 2 / math.pi
	local yd = ix / 2 / math.pi

	return love.math.noise(
		ix + math.cos(s * 2 * math.pi) * xd,
		iy + math.cos(t * 2 * math.pi) * yd,
		ix + math.sin(s * 2 * math.pi) * xd,
		iy + math.sin(t * 2 * math.pi) * yd
	)
end

local function quat3Bit(x, y, w, h, v)
	return math.floor(v * 8) / 8
end

local function chain(f1, f2)
	return function(x, y, w, h, v)
		return f2(x, y, w, h, f1(x, y, w, h, v))
	end
end

function game.init(arg)
	love.graphics.setDefaultFilter("nearest", "nearest", 16)

	game.groundOutside = game.newLA8Image(game.createRandomTile(0, chain(fadeOut, quat3Bit), 32, 32, 2))
	game.groundInside = game.newLA8Image(game.createTileFromFormula(fadeOut, 32, 32, chain(cube, quat3Bit)))
	game.wall = game.newLA8Image("images/wall_quat.png")
	game.door = game.newLA8Image("images/door_quat.png")
	game.wallFade = game.newLA8Image("images/wall_fadein_quat.png")

	game.font = love.graphics.newFont(9, "mono", 1)
	game.font:setFilter("nearest", "nearest", 16)

	game.map = map.load(1)
	game.tileMapping = {
		g = game.groundOutside,
		f = game.groundInside,
		w = game.wall,
		u = game.wallFade,
		d = game.door,
	}
end

function game.update(dt)
end

function game.draw()
	for i, v in ipairs(game.map) do
		for j = 1, #v do
			local u = v:sub(j, j):lower()
			local x = (j - 1) * 32
			local y = 148 - (#game.map - i) * 32

			if game.tileMapping[u] then
				love.graphics.draw(game.tileMapping[u], x, y)
			end
		end
	end

	for i, v in ipairs(game.map) do
		for j = 1, #v do
			love.graphics.rectangle("line", (j - 1) * 32 + 0.5, 148 - (#game.map - i) * 32 + 0.5, 32, 32)
		end
	end

	love.graphics.print("game.groundOutside pixfmt: "..game.groundOutside:getFormat(), game.font)
end

function game.createTileFromFormula(formula, w, h, post)
	local img = love.image.newImageData(w, h, "rg8")
	img:mapPixel(function(x, y, r, g, b, a)
		local v, a = formula(x, y, w, h)
		if post then
			v = post(x, y, w, h, v)
		end
		return v, a or 1, 1, 1
	end)

	return img
end

function game.createRandomTile(seed, post, w, h, octave)
	octave = octave or 2
	w = w or 16
	h = h or 16
	local rng = love.math.newRandomGenerator(seed)
	local ix = rng:random() * 2 ^ octave
	local iy = rng:random() * 2 ^ octave

	local img = love.image.newImageData(w, h, "rg8")
	img:mapPixel(function(x, y, r, g, b, a)
		local v = tiledNoise(x, y, w, h, ix, iy)

		if post then
			v = post(x, y, w, h, v)
		end

		return v, 1, 1, 1
	end)

	return img
end

function game.newLA8Image(path, settings)
	if type(path) == "string" then
		local temp = love.image.newImageData(path)
		path = love.image.newImageData(temp:getWidth(), temp:getHeight(), "rg8")
		path:mapPixel(function(x, y)
			local a, b, c, d = temp:getPixel(x, y)
			return a, d, 1, 1
		end)
	end

	local img = love.graphics.newImage(la8.set(path), settings)
	la8.unset(path)

	return img
end

return game
