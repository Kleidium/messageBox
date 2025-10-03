local EasyMCM = require("easyMCM.EasyMCM");
local config  = require("messageBox.config")
local log = mwse.Logger.new()
local box = require("messageBox.box")

local modName = 'Message Box';
local template = EasyMCM.createTemplate { name = modName }
template:saveOnClose(modName, config)
template:register()



local function createPage(label)
    local page = template:createSideBarPage {
        label = label,
        noScroll = false,
    }
    page.sidebar:createInfo {
        text = "                          [Message Box] \n\nLogs all message boxes that pop up on the screen. These message boxes can come from anywhere, such as dialogue subtitles or messages displayed by mods. Optionally add additional logging such as exploration logging, combat logging, death logging, and spell resist logging. Toggle the box by using the box button (Default: B key).\n\n\nRecommended Box Dimensions:\n\nMessage Offset 2\n237x87 (Tiny, 2 lines)\n317x127 (Small, 4 lines)\n437x167 (Medium, 6 lines)\n517x207 (Large, 8 lines)\n597x247 (Extra Large, 10 lines)"
    }
    page.sidebar:createHyperLink {
        text = "Made by Kleidium",
        exec = "start https://www.nexusmods.com/users/5374229?tab=user+files",
        postCreate = function(self)
            self.elements.outerContainer.borderAllSides = self.indent
            self.elements.outerContainer.alignY = 1.0
            self.elements.info.layoutOriginFractionX = 0.5
        end,
    }
    return page
end

local settings = createPage("General Settings")
local cPage = createPage("Color Settings")



----Global Settings-------------------------------------------------------------------------------------------------------------------------
local cdSettings = settings:createCategory("General Settings")

cdSettings:createTextField {
    label = "Initial Box Width",
    description = "The initial width of the box, before any manual resizing is done. Default width: 317\nMinimum width: 237",
    variable = mwse.mcm.createTableVariable { id = "width", table = config },
    numbersOnly = true,
    callback = function(self)
        if box.menu then
            if tonumber(self.variable.value) < 237 then
                self.variable.value = "237"
                tes3.messageBox("Minimum width is 237.")
            end
            if config.minSize then
                box.menu.minWidth = tonumber(self.variable.value)
            else
                box.menu.minWidth = 237
            end
            box.menu.width = tonumber(self.variable.value)
            box.pane.width = tonumber(self.variable.value) - 100
            box.menu:updateLayout()
        end
        tes3.messageBox("Width: " .. self.variable.value)
    end
}

cdSettings:createTextField {
    label = "Initial Box Height",
    description = "The initial height of the box, before any manual resizing is done. Default height: 127\nMinimum height: 87",
    variable = mwse.mcm.createTableVariable { id = "height", table = config },
    numbersOnly = true,
    callback = function(self)
        if box.menu then
            if tonumber(self.variable.value) < 87 then
                self.variable.value = "87"
                tes3.messageBox("Minimum height is 87.")
            end
            if config.minSize then
                box.menu.minHeight = tonumber(self.variable.value)
            else
                box.menu.minHeight = 87
            end
            box.menu.height = tonumber(self.variable.value)
            box.pane.height = tonumber(self.variable.value) - 50
            box.menu:updateLayout()
        end
        tes3.messageBox("Height: " .. self.variable.value)
    end
}

cdSettings:createOnOffButton {
    label = "Initial Size is Minimum Size",
    description = "With this turned on, the initial height/width of your box is also the minimum size of that box.\n\nUsed to easily return to your preferred size after manual resizing. Default: On",
    variable = mwse.mcm.createTableVariable { id = "minSize", table = config },
    callback = function(self)
        if box.menu then
            if self.variable.value then
                box.menu.minHeight = tonumber(config.height)
                box.menu.minWidth = tonumber(config.width)
            else
                box.menu.minHeight = 87
                box.menu.minWidth = 237
            end
            box.menu:updateLayout()
        end
    end
}

cdSettings:createSlider {
    label = "Box Opacity",
    description = "The opacity value of the box, from 0.0 to 1.0. Default: 0.7",
    min = 0.0,
    max = 1.0,
    step = 0.1,
    jump = 0.2,
    decimalPlaces = 1,
    variable = EasyMCM:createTableVariable {
        id = "alpha",
        table = config
    },
    restartRequired = true
}

cdSettings:createDropdown {
    label = "Initial Position",
    description = "Set the initial box position. Default: Top Right",
    options = {
        { label = "Top", value = "top" },
        { label = "Bottom", value = "bottom" },
        { label = "Top Left", value = "tLeft" },
        { label = "Top Right", value = "tRight" },
    },
    variable = mwse.mcm.createTableVariable { id = "position", table = config }
}

cdSettings:createOnOffButton {
    label = "Vanilla Pop-Ups",
    description = "Turn on or off most vanilla pop-up boxes. Turn this off if you want Message Box to replace vanilla pop-ups completely. Boxes with buttons function as normal. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "notify", table = config }
}

cdSettings:createOnOffButton {
    label = "Message Timer",
    description = "Turn on or off the box message timer. This will cause the box to disappear after a certain amount of time has passed. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "msgTimer", table = config },
    restartRequired = true
}

cdSettings:createSlider {
    label = "Message Time",
    description = "The amount of time that needs to pass for the box to disappear after the last message is displayed. Default: 10 seconds",
    max = 60,
    min = 3,
	jump = 5,
	step = 1,
    variable = EasyMCM:createTableVariable {
        id = "msgTime",
        table = config
    }
}

cdSettings:createOnOffButton {
    label = "Delete Older Messages",
    description = "Turn on or off the message limit. When the message limit is reached, older messages will be deleted. Default: On",
    variable = mwse.mcm.createTableVariable { id = "msgLimit", table = config }
}

cdSettings:createTextField {
    label = "Message Limit",
    description = "The amount of messages required to begin deleting older messages. Default amount: 250",
    variable = mwse.mcm.createTableVariable { id = "maxMessages", table = config },
    numbersOnly = true
}

cdSettings:createOnOffButton {
    label = "Show Timestamp",
    description = "Turn on or off message timestamps. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "timeStamp", table = config }
}

cdSettings:createDropdown {
    label = "Timestamp Format",
    description = "Set the timestamp format.",
    options = {
        { label = "(24 hr) hr/min/sec", value = "%X" },
        { label = "(24 hr) hr/min", value = "%H:%M" },
		{ label = "(12 hr) hr/min/sec", value = "%I:%M:%S" },
		{ label = "(12 hr) hr/min", value = "%I:%M" },
    },
    variable = mwse.mcm.createTableVariable { id = "timeFormat", table = config }
}

cdSettings:createSlider {
    label = "Message Offset",
    description = "The extra space in between each new message. Default: 2",
    max = 10,
    min = 0,
	jump = 2,
	step = 1,
    variable = EasyMCM:createTableVariable {
        id = "msgOffset",
        table = config
    }
}

cdSettings:createKeyBinder {
    label = "Toggle Message Box Hotkey",
    description = "Press this key to toggle the message box on or off.\n\nDefault: B",
    variable = mwse.mcm.createTableVariable { id = "boxBind", table = config },
    allowCombinations = true
}

cdSettings:createTextField {
    label = "Message Box Title",
    description = "Rename the message box if you wish. Default title: Message Box",
    variable = mwse.mcm.createTableVariable { id = "titleText", table = config },
	restartRequired = true
}

cdSettings:createTextField {
    label = "Highlighted Phrase",
    description = "Any message containing this phrase will be highlighted with the chosen highlight color. Default phrase: ERROR",
    variable = mwse.mcm.createTableVariable { id = "highText", table = config }
}

cdSettings:createTextField {
    label = "Filtered Phrase",
    description = "Any message containing this phrase will not be logged. Default phrase: @@@@",
    variable = mwse.mcm.createTableVariable { id = "filterText", table = config }
}

cdSettings:createDropdown {
    label = "Debug Logging Level",
    description = "Set the log level.",
    options = {
        { label = "TRACE", value = "TRACE" },
        { label = "DEBUG", value = "DEBUG" },
        { label = "INFO", value = "INFO" },
        { label = "ERROR", value = "ERROR" },
        { label = "NONE", value = "NONE" },
    },
    variable = mwse.mcm.createTableVariable { id = "logLevel", table = config },
    callback = function(self)
        log.level = self.variable.value
    end
}


local logSettings = settings:createCategory("Log Settings")

logSettings:createOnOffButton {
    label = "Exploration Logging",
    description = "Turn on or off exploration logging. Exploration logging will announce your location when you travel around/change cells. Default: On",
    variable = mwse.mcm.createTableVariable { id = "cellLog", table = config }
}

logSettings:createOnOffButton {
    label = "Quest Logging",
    description = "Turn on or off quest logging. Quest logging will display journal entries as they are written. Default: On",
    variable = mwse.mcm.createTableVariable { id = "questLog", table = config }
}

logSettings:createOnOffButton {
    label = "Chat Logging",
    description = "Turn on or off chat logging. Chat logging will log your conversations with NPCs. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "chatLog", table = config }
}

logSettings:createOnOffButton {
    label = "Combat Logging",
    description = "Turn on or off combat logging. Combat logging will announce damage dealt to and by the player by non-magical attacks. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "dmgLog", table = config }
}

logSettings:createOnOffButton {
    label = "Spell Cast Logging",
    description = "Turn on or off spell cast logging. Spell cast logging will announce when any entity successfully casts a spell or uses a potion. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "castLog", table = config }
}

logSettings:createOnOffButton {
    label = "Spell Resist Logging",
    description = "Turn on or off spell resist logging. Spell resist logging will announce when any entity resists, absorbs, or reflects a magic effect. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "resistLog", table = config }
}

logSettings:createOnOffButton {
    label = "Death Logging",
    description = "Turn on or off death logging. Death logging will announce when any entity dies. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "deathLog", table = config }
}

logSettings:createOnOffButton {
    label = "Music Logging",
    description = "Turn on or off music logging. Music logging will announce when a new music track is played. Default: Off",
    variable = mwse.mcm.createTableVariable { id = "musicLog", table = config }
}



--Colors----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local cSettings = cPage:createCategory("Default Text Color") --White

cSettings:createSlider {
    label = "Text Color: Red",
    description = "RGB RED value for message box text color. Default: 1.0",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "textRed",
        table = config
    }
}

cSettings:createSlider {
    label = "Text Color: Green",
    description = "RGB GREEN value for message box text color. Default: 1.0",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "textGreen",
        table = config
    }
}

cSettings:createSlider {
    label = "Text Color: Blue",
    description = "RGB BLUE value for message box text color. Default: 1.0",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "textBlue",
        table = config
    }
}


local hSettings = cPage:createCategory("Highlighted Text Color") --Pink

hSettings:createSlider {
    label = "Highlight Color: Red",
    description = "RGB RED value for message box highlighted text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "highRed",
        table = config
    }
}

hSettings:createSlider {
    label = "Highlight Color: Green",
    description = "RGB GREEN value for message box highlighted text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "highGreen",
        table = config
    }
}

hSettings:createSlider {
    label = "Highlight Color: Blue",
    description = "RGB BLUE value for message box highlighted text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "highBlue",
        table = config
    }
}

local lasSettings = cPage:createCategory("Last Message Text Color") --Grey

lasSettings:createSlider {
    label = "Last Msg Color: Red",
    description = "RGB RED value for message box \"last message\" color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "lastRed",
        table = config
    }
}

lasSettings:createSlider {
    label = "Last Msg Color: Green",
    description = "RGB GREEN value for message box \"last message\" color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "lastGreen",
        table = config
    }
}

lasSettings:createSlider {
    label = "Last Msg Color: Blue",
    description = "RGB BLUE value for message box \"last message\" color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "lastBlue",
        table = config
    }
}


local cellSettings = cPage:createCategory("Exploration Log Text Color") --Green

cellSettings:createSlider {
    label = "Highlight Color: Red",
    description = "RGB RED value for message box exploration text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "cellRed",
        table = config
    }
}

cellSettings:createSlider {
    label = "Highlight Color: Green",
    description = "RGB GREEN value for message box exploration text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "cellGreen",
        table = config
    }
}

cellSettings:createSlider {
    label = "Highlight Color: Blue",
    description = "RGB BLUE value for message box exploration text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "cellBlue",
        table = config
    }
}

local dmgSettings = cPage:createCategory("Combat Log Text Color") --Red

dmgSettings:createSlider {
    label = "Combat Color: Red",
    description = "RGB RED value for message box combat text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "dmgRed",
        table = config
    }
}

dmgSettings:createSlider {
    label = "Combat Color: Green",
    description = "RGB GREEN value for message box combat text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "dmgGreen",
        table = config
    }
}

dmgSettings:createSlider {
    label = "Combat Color: Blue",
    description = "RGB BLUE value for message box combat text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "dmgBlue",
        table = config
    }
}

local castSettings = cPage:createCategory("Cast Log Text Color") --Baby Blue

castSettings:createSlider {
    label = "Cast Color: Red",
    description = "RGB RED value for message box cast log text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "castRed",
        table = config
    }
}

castSettings:createSlider {
    label = "Cast Color: Green",
    description = "RGB GREEN value for message box cast log text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "castGreen",
        table = config
    }
}

castSettings:createSlider {
    label = "Cast Color: Blue",
    description = "RGB BLUE value for message box cast log text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "castBlue",
        table = config
    }
}


local resSettings = cPage:createCategory("Resist Log Text Color") --Purple

resSettings:createSlider {
    label = "Resist Color: Red",
    description = "RGB RED value for message box resist text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "resRed",
        table = config
    }
}

resSettings:createSlider {
    label = "Resist Color: Green",
    description = "RGB GREEN value for message box resist text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "resGreen",
        table = config
    }
}

resSettings:createSlider {
    label = "Resist Color: Blue",
    description = "RGB BLUE value for message box resist text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "resBlue",
        table = config
    }
}


local dedSettings = cPage:createCategory("Death Log Text Color") --Orangish

dedSettings:createSlider {
    label = "Death Color: Red",
    description = "RGB RED value for message box death text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "dedRed",
        table = config
    }
}

dedSettings:createSlider {
    label = "Death Color: Green",
    description = "RGB GREEN value for message box death text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "dedGreen",
        table = config
    }
}

dedSettings:createSlider {
    label = "Death Color: Blue",
    description = "RGB BLUE value for message box death text color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "dedBlue",
        table = config
    }
}

local queSettings = cPage:createCategory("Quest Log Text Color") --Neon Blue

queSettings:createSlider {
    label = "Quest Color: Red",
    description = "RGB RED value for message box quest log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "queRed",
        table = config
    }
}

queSettings:createSlider {
    label = "Quest Color: Green",
    description = "RGB GREEN value for message box quest log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "queGreen",
        table = config
    }
}

queSettings:createSlider {
    label = "Quest Color: Blue",
    description = "RGB BLUE value for message box quest log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "queBlue",
        table = config
    }
}

local diaSettings = cPage:createCategory("Chat Log Text Color") --Yellow

diaSettings:createSlider {
    label = "Chat Color: Red",
    description = "RGB RED value for message box chat log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "diaRed",
        table = config
    }
}

diaSettings:createSlider {
    label = "Chat Color: Green",
    description = "RGB GREEN value for message box chat log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "diaGreen",
        table = config
    }
}

diaSettings:createSlider {
    label = "Chat Color: Blue",
    description = "RGB BLUE value for message box chat log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "diaBlue",
        table = config
    }
}


local musSettings = cPage:createCategory("Music Log Text Color") --Minty

musSettings:createSlider {
    label = "Music Color: Red",
    description = "RGB RED value for message box music log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "musRed",
        table = config
    }
}

musSettings:createSlider {
    label = "Music Color: Green",
    description = "RGB GREEN value for message box music log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "musGreen",
        table = config
    }
}

musSettings:createSlider {
    label = "Music Color: Blue",
    description = "RGB BLUE value for message box music log color.",
    max = 1.00,
    min = 0.00,
	jump = 0.10,
	step = 0.01,
	decimalPlaces = 2,
    variable = EasyMCM:createTableVariable {
        id = "musBlue",
        table = config
    }
}