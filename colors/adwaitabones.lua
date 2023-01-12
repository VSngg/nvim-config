local colors_name = "adwaitabones"
vim.g.colors_name = colors_name

local lush = require "lush"
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require "zenbones.util"

local bg = vim.o.background
local palette = util.palette_extend({
		bg = hsluv "#171717",
		fg = hsluv "#deddda",
		rose = hsluv "#ED333B",
		leaf = hsluv "#57E389",
		wood = hsluv "#FF7800",
		water = hsluv "#62A0EA",
		blossom = hsluv "#F66151",
		sky = hsluv "#93DDC2",
	}, bg)

local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

local specs = lush.extends({ base_specs }).with(function()
	return {
		ColorColumn { bg = hsluv("#1c1c1c")},
		CursorLine { bg = hsluv("#1c1c1c")}
	}
end)

lush(specs)

