-- Set LA8 pixel format to ImageData

local love = require("love")
local ffi = require("ffi")

---@language cpp
if love._os == "Windows" then
	ffi.cdef[[
	struct LOVEImageData
	{
		void *vtable;
		int count, _unk;

		int format;
	};
	]]
else
	ffi.cdef[[
	struct LOVEImageData
	{
		void *vtable;
		int count;

		int format;
	};
	]]
end

local la8 = {}

---@param imageData ImageData
function la8.set(imageData)
	assert(imageData:typeOf("ImageData"))
	-- Make sure it's memoized
	imageData:getFormat()
	ffi.cast("struct LOVEImageData**", imageData)[1].format = 16 -- "PIXELFORMAT_LA8"
	return imageData
end

---@param imageData ImageData
function la8.unset(imageData)
	assert(imageData:typeOf("ImageData"))
	ffi.cast("struct LOVEImageData**", imageData)[1].format = 4 -- "PIXELFORMAT_RG8"
	return imageData
end

return la8
