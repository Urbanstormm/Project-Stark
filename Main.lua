-- Project Stark hub loader (public entry script).
-- v2: per-user keys validated against the server API, locked to the user's
-- Roblox account + HWID. Private content (UI + game scripts) is served
-- key-gated by the API and never lives in this repo.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local KEY_VERIFIED_FLAG = "ProjectStarkKeyVerified"
-- hyxx.win/api/* is reverse-proxied to the origin by the site Worker, which
-- keeps the API reachable on networks whose ISP blocks the api.* subdomain.
-- api.hyxx.win is kept as a fallback.
local HUB_API_BASES = {
	"https://hyxx.win",
	"https://api.hyxx.win",
}
local activeBase = nil
local OFFLINE_GRACE_SECONDS = 3600

local skipKeyCheck = false
local discordUrl = "https://urbanstorm.uk/discord"
local keyLink = "https://Urbanstorm.uk"
local keyFileName = "ProjectStark_Key.txt"
local wrongAttempts = 0
local maxAttempts = 3
local win = nil
local userInput = ""
local activeKey = nil

local function notify(text, kind)
	pcall(function()
		local coreGui = game:GetService("CoreGui")
		local gui = coreGui:FindFirstChild("ProjectStarkNotify")
		if not gui then
			gui = Instance.new("ScreenGui")
			gui.Name = "ProjectStarkNotify"
			gui.ResetOnSpawn = false
			gui.IgnoreGuiInset = true
			gui.DisplayOrder = 999999
			gui.Parent = coreGui
		end
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 440, 0, 48)
		label.Position = UDim2.new(0.5, -220, 0, 24)
		if kind == "error" then
			label.BackgroundColor3 = Color3.fromRGB(122, 32, 44)
		elseif kind == "success" then
			label.BackgroundColor3 = Color3.fromRGB(44, 92, 62)
		else
			label.BackgroundColor3 = Color3.fromRGB(64, 46, 98)
		end
		label.BackgroundTransparency = 0.12
		label.BorderSizePixel = 0
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextWrapped = true
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 15
		label.Text = tostring(text)
		label.Parent = gui
		task.delay(7, function()
			pcall(function()
				label:Destroy()
			end)
		end)
	end)
end

local function saveKeyData(data)
	pcall(function()
		writefile(keyFileName, HttpService:JSONEncode(data))
	end)
end

local function loadSavedKeyData()
	local success, result = pcall(function()
		if isfile(keyFileName) then
			return readfile(keyFileName)
		end
		return nil
	end)
	if not success or type(result) ~= "string" or result == "" then
		return nil
	end
	-- Migrate the old plain-text format (raw key only).
	if result:sub(1, 1) ~= "{" then
		return { key = result }
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(result)
	end)
	if ok and type(data) == "table" then
		return data
	end
	return nil
end

local function deleteSavedKey()
	pcall(function()
		if isfile(keyFileName) then
			delfile(keyFileName)
		end
	end)
end

local function copyKeyLink()
	pcall(function()
		setclipboard(keyLink)
	end)
end

local function copyDiscordLink()
	pcall(function()
		setclipboard(discordUrl)
	end)
end

local function joinDiscord()
	copyDiscordLink()
	-- Resolve a fresh invite code so the Discord RPC path can join directly.
	local ok, body = pcall(function()
		return game:HttpGet(discordUrl .. "?format=json", true)
	end)
	if ok and type(body) == "string" and body:sub(1, 1) == "{" then
		local okDecode, data = pcall(function()
			return HttpService:JSONDecode(body)
		end)
		if okDecode and type(data) == "table" and type(data.code) == "string" and #data.code > 0 then
			Invdiscord(data.code)
			return
		end
	end
	pcall(function()
		game:GetService("GuiService"):OpenBrowserWindow(discordUrl)
	end)
end

_G.ProjectStarkJoinDiscord = joinDiscord

local function Invdiscord(code)
	pcall(function()
		local Request = (syn and syn.request) or request
		Request({
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				args = { code = code },
				nonce = HttpService:GenerateGUID(false),
			}),
		})
	end)
end

local function kickPlayer(message)
	pcall(function()
		local player = Players.LocalPlayer
		if player then
			player:Kick(message or "")
		end
	end)
end

local function clearLegacyKeyCheck()
	pcall(function()
		local legacy = Players.LocalPlayer:FindFirstChild("Project Stark Key Check")
		if legacy then
			legacy:Destroy()
		end
	end)
end

local function checkGameKey()
	return rawget(_G, KEY_VERIFIED_FLAG) == true
end

local function sanitizeKey(input)
	if not input or type(input) ~= "string" then
		return "", { empty = true }
	end

	input = input:match("^%s*(.-)%s*$") or ""
	input = input:gsub("%s+", "")
	input = input:gsub("[\194\160]", "")
	input = input:gsub("[\226\128\139]", "")
	input = input:gsub("[\226\128\140]", "")
	input = input:gsub("[\226\128\141]", "")
	input = input:gsub("[\239\187\191]", "")
	input = input:gsub('["\']', "")
	input = input:gsub("`", "")
	input = input:gsub("[\n\r\t]", "")
	input = input:gsub("^[Kk][Ee][Yy][:=%s]*", "")
	input = input:gsub("^[Cc][Oo][Dd][Ee][:=%s]*", "")
	input = input:upper()

	return input, {
		empty = (#input == 0),
		tooShort = (#input > 0 and #input < 5),
		tooLong = (#input > 100),
	}
end

local function getHwid()
	local getter = rawget(_G, "gethwid")
	if type(getter) == "function" then
		local ok, value = pcall(getter)
		if ok and type(value) == "string" and #value > 0 then
			return value
		end
	end
	if syn and type(syn.get_hwid) == "function" then
		local ok, value = pcall(syn.get_hwid)
		if ok and type(value) == "string" and #value > 0 then
			return value
		end
	end
	local ok, clientId = pcall(function()
		return game:GetService("RbxAnalyticsService"):GetClientId()
	end)
	if ok and type(clientId) == "string" and #clientId > 0 then
		return clientId
	end
	return ""
end

local function hubHttpGet(path)
	for _, base in ipairs(HUB_API_BASES) do
		local ok, res = pcall(function()
			return game:HttpGet(base .. path, true)
		end)
		if ok and type(res) == "string" and res ~= "" then
			local okDecode, data = pcall(function()
				return HttpService:JSONDecode(res)
			end)
			if okDecode and type(data) == "table" then
				activeBase = base
				return data, nil
			end
		end
	end
	return nil, "network"
end

local function hubErrorText(code)
	local messages = {
		HUB_INVALID = "Invalid key. Get one at urbanstorm.uk",
		HUB_REVOKED = "This key has been revoked.",
		HUB_EXPIRED = "Your key expired. Get a new one at urbanstorm.uk",
		HUB_USERID_MISMATCH = "This key belongs to a different Roblox account.",
		HUB_HWID_MISMATCH = "This key is locked to a different PC. Use /hubreset in the Project Stark Discord.",
		HUB_RATE_LIMITED = "Too many attempts - wait a minute and try again.",
		HUB_BAD_REQUEST = "Key check failed. Re-copy your key and try again.",
	}
	return messages[code] or "Key check failed. Get a new key at urbanstorm.uk"
end

local function verifyKey(key)
	local player = Players.LocalPlayer
	local userId = player and player.UserId or 0
	local hwid = getHwid()
	local path = string.format(
		"/api/hub/verify?key=%s&user_id=%s&hwid=%s",
		HttpService:UrlEncode(key), tostring(userId), HttpService:UrlEncode(hwid)
	)
	local data, netErr = hubHttpGet(path)
	if not data then
		return nil, "network"
	end
	if data.valid == true then
		return data, nil
	end
	return nil, data.code or "HUB_INVALID"
end

local function setActiveSession(key, data)
	activeKey = key
	local player = Players.LocalPlayer
	local userId = player and player.UserId or 0
	local hwid = getHwid()
	_G.ProjectStarkHubApi = {
		base = activeBase or HUB_API_BASES[1],
		key = key,
		user_id = tostring(userId),
		hwid = hwid,
	}
	_G.ProjectStarkHubFetchScript = function(id)
		local bases = {}
		if activeBase then
			table.insert(bases, activeBase)
		end
		for _, base in ipairs(HUB_API_BASES) do
			if base ~= activeBase then
				table.insert(bases, base)
			end
		end
		for _, base in ipairs(bases) do
			local url = string.format(
				"%s/api/hub/script?key=%s&user_id=%s&hwid=%s&id=%s",
				base, HttpService:UrlEncode(key), tostring(userId),
				HttpService:UrlEncode(hwid), tostring(id)
			)
			local ok, res = pcall(function()
				return game:HttpGet(url, true)
			end)
			if ok and type(res) == "string" and res ~= "" and res:sub(1, 1) ~= "{" then
				return res
			end
		end
		return nil
	end
	saveKeyData({
		key = key,
		last_ok = os.time(),
		seconds_left = data and data.seconds_left or nil,
		lifetime = data and data.lifetime == true or false,
	})
end

local function setKeyVerified()
	_G[KEY_VERIFIED_FLAG] = true
	clearLegacyKeyCheck()
end

local function clearKeyFlag()
	_G[KEY_VERIFIED_FLAG] = nil
	clearLegacyKeyCheck()
end

local function closeKeyUI()
	pcall(function()
		if win and win.Destroy then
			win:Destroy()
		end
		win = nil
	end)
end

local function getKeyInput()
	if win and win.Gui then
		for _, v in ipairs(win.Gui:GetDescendants()) do
			if v:IsA("TextBox") and v.PlaceholderText == "Enter your key" then
				return v.Text
			end
		end
	end
	return userInput
end

local function resumeHub()
	local cont = rawget(_G, "ProjectStarkHubContinue")
	if type(cont) ~= "function" then
		return false
	end
	_G.ProjectStarkHubContinue = nil
	clearKeyFlag()
	task.defer(cont)
	return true
end

local function loadScriptFromSource()
	local gameId = tostring(game.GameId)

	if readfile then
		for _, path in ipairs({
			gameId .. ".lua",
			"Bladeball.lua",
			"New script hub/Bladeball.lua",
			"New script hub/" .. gameId .. ".lua",
		}) do
			local ok, source = pcall(readfile, path)
			if ok and type(source) == "string" and source ~= "" then
				local run = loadstring(source)
				if run then
					pcall(run)
					return true
				end
			end
		end
	end

	if not activeKey then
		return false
	end
	local fetch = rawget(_G, "ProjectStarkHubFetchScript")
	if type(fetch) ~= "function" then
		return false
	end
	local source = fetch(gameId)
	if source then
		local run = loadstring(source)
		if run then
			pcall(run)
			return true
		end
	end
	return false
end

local function loadScript()
	closeKeyUI()

	if resumeHub() then
		return
	end

	if not loadScriptFromSource() then
		notify("No script is available for this game yet.", "error")
		task.delay(2, function()
			kickPlayer("Project Stark: no script available for this game yet.")
		end)
	end
end

local function handleWrongKey()
	wrongAttempts = wrongAttempts + 1
	copyKeyLink()

	if wrongAttempts >= maxAttempts then
		notify("Too many invalid attempts. Get a key at urbanstorm.uk", "error")
		task.delay(1, function()
			kickPlayer("Project Stark: too many invalid key attempts.")
		end)
	end
end

local function handleKeyValidation(rawInput)
	local cleanKey, issues = sanitizeKey(rawInput)

	if issues.empty or issues.tooShort or issues.tooLong then
		notify("Enter your key from urbanstorm.uk", "error")
		return false
	end

	if wrongAttempts >= maxAttempts then
		return false
	end

	local data, code = verifyKey(cleanKey)
	if data then
		setActiveSession(cleanKey, data)
		setKeyVerified()
		notify("Key accepted. Loading Project Stark...", "success")
		loadScript()
		return true
	end

	if code == "network" then
		notify("Could not reach the key server. Check your connection and try again.", "error")
		return false
	end

	notify(hubErrorText(code), "error")
	handleWrongKey()
	return false
end

clearLegacyKeyCheck()

local hubContinue = rawget(_G, "ProjectStarkHubContinue")

if checkGameKey() then
	if type(hubContinue) == "function" then
		loadScript()
		return
	end
	clearKeyFlag()
end

if skipKeyCheck then
	setKeyVerified()
	loadScript()
	return
end

-- Saved key: re-validate against the API. If the API is unreachable, allow a
-- 60-minute grace window based on the last successful check.
local saved = loadSavedKeyData()
local savedRejected = false

if saved and type(saved.key) == "string" and saved.key ~= "" then
	local cleanSavedKey = sanitizeKey(saved.key)
	if cleanSavedKey ~= "" then
		local data, code = verifyKey(cleanSavedKey)
		if data then
			setActiveSession(cleanSavedKey, data)
			setKeyVerified()
			loadScript()
			return
		elseif code == "network" then
			local lastOk = tonumber(saved.last_ok) or 0
			local secondsLeft = tonumber(saved.seconds_left) or 0
			local notExpired = saved.lifetime == true or (lastOk + secondsLeft) > os.time()
			if (os.time() - lastOk) <= OFFLINE_GRACE_SECONDS and notExpired then
				setActiveSession(cleanSavedKey, saved)
				setKeyVerified()
				notify("Key server unreachable - using your key for up to 60 minutes.", "warn")
				loadScript()
				return
			end
			notify("Could not reach the key server. Check your connection and try again.", "error")
		else
			deleteSavedKey()
			savedRejected = true
			notify(hubErrorText(code), "error")
		end
	else
		deleteSavedKey()
	end
end

pcall(function()
	local coreGui = game:GetService("CoreGui")
	local existingUI = coreGui:FindFirstChild("Project Stark Key System")
	if existingUI then
		existingUI:Destroy()
	end
end)

if savedRejected then
	copyKeyLink()
end

local function loadUiLib()
	if readfile then
		for _, path in ipairs({
			"Loadstring UI.lua",
			"New script hub/Loadstring UI.lua",
			"UiLib.lua",
			"New script hub/UiLib.lua",
		}) do
			local ok, source = pcall(readfile, path)
			if ok and type(source) == "string" and source ~= "" then
				local run = loadstring(source) or load(source)
				if run then
					local okRun, lib = pcall(run)
					if okRun and lib then
						return lib
					end
					return _G.ProjectStarkUILib
				end
			end
		end
	end
	local fetch = rawget(_G, "ProjectStarkHubFetchScript")
	if type(fetch) == "function" then
		local source = fetch("ui")
		if source then
			local okRemote, remoteLib = pcall(function()
				return loadstring(source)()
			end)
			if okRemote and remoteLib then
				return remoteLib
			end
		end
	end
	return _G.ProjectStarkUILib
end

local Lib = loadUiLib()
if not Lib then
	notify("Could not load the hub UI. Rejoin and try again.", "error")
	return
end

win = Lib:Window("Project Stark\nKey System", Color3.fromRGB(120, 81, 169))
local KeyTab = win:Tab("Key")

KeyTab:Textbox("Enter your key", false, function(text)
	userInput = text
end)

KeyTab:Button("Execute", function()
	pcall(function()
		handleKeyValidation(getKeyInput())
	end)
end)

KeyTab:Button("Get key (Copy link)", function()
	copyKeyLink()
	notify("Link copied: claim a free 4-hour key or buy lifetime at urbanstorm.uk")
end)

local HelpTab = win:Tab("Help")

HelpTab:Button("Where do I get a key?", function()
	copyKeyLink()
	notify("Log in with Discord at urbanstorm.uk, complete the checkpoint, and paste your personal key here.")
end)

HelpTab:Button("Why isn't my key working?", function()
	notify("Keys are personal: they only work on the Roblox account and PC that first used them.")
end)

HelpTab:Button("Key locked to an old PC?", function()
	notify("Run /hubreset in the Project Stark Discord server, then enter your key again.")
end)

HelpTab:Button("My key expired", function()
	copyKeyLink()
	notify("Free keys last 4 hours. Grab a new one at urbanstorm.uk")
end)

HelpTab:Button("Join Discord for help", function()
	joinDiscord()
end)

local Credits = win:Tab("Credits")

Credits:Button("Made by Urbanstorm", function()
	pcall(function()
		setclipboard("Urbanstorm")
	end)
end)

Credits:Button(discordUrl .. " - Click to copy", function()
	joinDiscord()
end)
