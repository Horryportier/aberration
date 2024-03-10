---@diagnostic disable: unused-local
local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

return {
	lua = {
		-- unpack transform
		s("utrans", {
			t("local "),
			c(1, {
				t("t, r, s, o = "),
				t("translation, rotation, scale, offset = "),
			}),
			i(2),
			t(":get()"),
		}),
		-- new vec2
		s("vec2", {
			t("Vec2.new("),
			i(1),
			t({ ")", "" }),
		}),
		s("g", { t("love.graphics."), i(1) }),
		s("p", { t("love.physics."), i(1) }),
	},
}
