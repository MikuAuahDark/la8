local map = {}

-- Tile reference:
-- w = Wall
-- g = Ground (outside)
-- f = Ground (inside)/floor
-- u = Wall fade
-- d = Door
-- Anything else is black/ignored

local mapData = {
	-- Level 1
	{
		"uuuuuuuuuu",
		"wwwwwwwwww",
		"wwwwwdwwww",
		"wwwww wwww",
		"gggggggggg"
	}
}

-- Assertions
for _, v in ipairs(mapData) do
	local l1 = nil

	for _, u in ipairs(v) do
		assert(l1 == nil or l1 == #u, "map size mismatch")
		l1 = #u
	end
end

function map.load(index)
	return assert(mapData[index])
end

return map
