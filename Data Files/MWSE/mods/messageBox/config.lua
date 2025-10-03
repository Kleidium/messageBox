local defaultConfig = {

	notify = false,
	width = 317,
	height = 127,
	minSize = true,
	alpha = 0.7,
	position = "bottom",
	msgTimer = false,
	msgTime = 10,
	msgLimit = true,
	maxMessages = 250,
	cellLog = true,
	dmgLog = false,
	deathLog = false,
	resistLog = false,
	questLog = true,
	musicLog = false,
	chatLog = false,
	castLog = false,
	timeStamp = false,
	timeFormat = "%X",
	msgOffset = 2,
	titleText = "Message Box",
	highText = "ERROR",
	filterText = "@@@@",
	textRed = 1.00, --White
	textGreen = 1.00,
	textBlue = 1.00,
	highRed = 1.00, --Pink
	highGreen = 0.70,
	highBlue = 0.80,
	cellRed = 0.20, --Green
	cellGreen = 0.60,
	cellBlue = 0.20,
	dmgRed = 0.80, --Red
	dmgGreen = 0.40,
	dmgBlue = 0.40,
	lastRed = 0.60, --Grey
	lastGreen = 0.60,
	lastBlue = 0.60,
	dedRed = 1.00, --Orangish
	dedGreen = 0.60,
	dedBlue = 0.00,
	resRed = 0.50, --Purple
	resGreen = 0.20,
	resBlue = 0.70,
	musRed = 0.74, --Minty
	musGreen = 0.97,
	musBlue = 0.61,
	queRed = 0.30, --Neon Blue
	queGreen = 0.30,
	queBlue = 1.00,
	diaRed = 1.00,-- Yellow
	diaGreen = 1.00,
	diaBlue = 0.00,
	castRed = 0.53, --Baby Blue
	castGreen = 0.82,
	castBlue = 0.96,
	logLevel = "INFO",
	boxBind = {
		keyCode = tes3.scanCode.b
	},
}

local mwseConfig = mwse.loadConfig("Message Box", defaultConfig)

return mwseConfig;
