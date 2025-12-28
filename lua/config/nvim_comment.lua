return {
	"numToStr/Comment.nvim",
	config = function()
		local Comment = require("Comment")
		local ft = require("Comment.ft")
		ft.set("blade", { "{{--%s--}}", "{{--%s--}}" })
		Comment.setup()
	end,
}
