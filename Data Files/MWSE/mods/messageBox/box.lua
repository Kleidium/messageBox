local config = require("messageBox.config")
local func = require("messageBox.common")
local log = mwse.Logger.new()


local box = {}


--Creates the message box.
function box.createBox()
	local viewportWidth, viewportHeight = tes3ui.getViewportSize()
	local width = tonumber(config.width)
	local height = tonumber(config.height)

	local menu = tes3ui.createMenu({ id = "kl_mb_menu", dragFrame = true })
	menu.minHeight = 87
	menu.minWidth = 237
	if config.minSize then
		menu.minHeight = height
		menu.minWidth = width
	end
	menu.height = height
	menu.width = width
	menu.text = config.titleText
	menu.positionY = (viewportHeight * 0.5)
	menu.positionX = (menu.width / 2) * -1
	if config.position == "bottom" then
		menu.positionY = (viewportHeight * -0.5) + menu.height
	elseif config.position == "tLeft" then
		menu.positionX = menu.positionX + (viewportWidth * -0.5) + (menu.width / 2)
	elseif config.position == "tRight" then
		menu.positionX = menu.positionX + (viewportWidth * 0.5) - (menu.width / 2)
	end
	menu.alpha = config.alpha

	local pane = menu:createVerticalScrollPane({})
	pane.autoHeight = true
	pane.width = width - 97 --100 less than menu width
	pane.height = height - 47 --50 less than menu height
	pane.minHeight = 37

	box.menu = menu
	box.pane = pane
	box.num = 1
	box.time = 0
 
	local label = pane:createLabel({text = "_|___|___|___|___|___|___|___|___|___|___|___|_\n___|___|___|___|___|___|___|___|___|___|___|___\n_|___|___|_M_|_e_|_s_|_s_|_a_|_g_|_e_|___|___|_\n___|___|___|___|___|_B_|_o_|_x_|___|___|___|___\n_|___|___|___|___|___|___|___|___|___|___|___|_"})
	label.wrapText = true
	label.justifyText = tes3.justifyText.center
	label.color = box.colors[math.random(1, #box.colors)]
	label.borderBottom = config.msgOffset

	box.modData = func.getModDataP()
	local lastMsg = pane:createLabel({ text = "Last Message:\n" .. box.modData.lastMsg .. "\n" })
	lastMsg.color = { config.lastRed, config.lastGreen, config.lastBlue }
	lastMsg.borderBottom = config.msgOffset

	menu:findChild("PartDragMenu_left_title_block"):destroy()
	menu:findChild("PartDragMenu_right_title_block"):destroy()
	menu:findChild("PartDragMenu_title_tint").maxHeight = 17
	menu.visible = box.modData.visible
	menu:updateLayout()
	log:debug("Message Box created.")

	if config.msgTimer then
		timer.start({ type = timer.real, duration = 1, iterations = -1, persist = false, callback =
		function()
			if box.menu then
				box.time = box.time + 1
				if box.time >= config.msgTime then
					box.menu.visible = false
				end
			end
		end })
	end
end

box.colors = {
	[1] = { 1.0, 1.0, 1.0 }, --White
	[2] = { 0.6, 0.2, 0.2 }, --Health Red
	[3] = { 0.21, 0.27, 0.62 }, --Magicka Blue
	[4] = { 0.2, 0.6, 0.2 }, --Fatigue Green
	[5] = { 0.50, 0.20, 0.66 }, --Technique Purple
	[6] = { 0.35, 0.35, 0.35 }, --Grey
	[7] = { 1.0, 0.62, 0.0 }, --Orangish
	[8] = { 0.792, 0.647, 0.376 }, --Morrowind Font Color
	[9] = { 0.18, 1.0, 0.95 }, --Light Blue
	[10] = { 0.6, 0.6, 0.0 }, --Goldish
	[11] = { 0.38, 0.13, 0.36 }, --Text Purple
	[12] = { 0.3, 0.3, 0.7 }, --Brighter UI Blue Text
	[13] = { 1.0, 0.274, 0.635 },  --Sharp Pink
	[14] = { 0.6, 0.0, 0.0 }, --Blood Karma Crimson
	[15] = { 0.9, 0.0, 0.0 }, --Lycanthropic Power "Bloodmoon"
	[16] = { 0.0, 0.5, 1.0 }, --Soul Energy Azure
	[17] = { 0.74, 0.97, 0.61 }, --Minty
	[18] = { 1.00, 1.00, 0.00 }, --Yellow
	[19] = { 1.00, 0.70, 0.80 }, --Light Pink
	[20] = { 0.53, 0.82, 0.96 } --Baby Blue
}

return box