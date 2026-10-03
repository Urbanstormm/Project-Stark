-- Project Stark hub loader (public entry script).
-- v2: per-user keys validated against the server API, locked to the user's
-- Roblox account + HWID. Private content (UI + game scripts) is served
-- key-gated by the API and never lives in this repo.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local KEY_VERIFIED_FLAG = "ProjectStarkKeyVerified"
-- urbanstorm.uk/api/* is reverse-proxied to the origin by the site Worker,
-- which keeps the API reachable on networks that block the api.* subdomain.
-- api.hyxx.win is kept as a fallback.
local HUB_API_BASES = {
	"https://urbanstorm.uk",
	"https://api.hyxx.win",
}
local activeBase = nil

-- Defaults only: the server's /api/hub/config overrides these at startup so
-- links and policies are not baked into the public loader.
local hubConfig = {
	site = "https://urbanstorm.uk",
	discord = "https://urbanstorm.uk/discord",
	grace_seconds = 3600,
	max_attempts = 3,
}

local skipKeyCheck = false
local keyFileName = "ProjectStark_Key.txt"
local wrongAttempts = 0
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
		setclipboard(hubConfig.site)
	end)
end

local function copyDiscordLink()
	pcall(function()
		setclipboard(hubConfig.discord)
	end)
end

local function joinDiscord()
	copyDiscordLink()
	-- Resolve a fresh invite code so the Discord RPC path can join directly.
	local ok, body = pcall(function()
		return game:HttpGet(hubConfig.discord .. "?format=json", true)
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
		game:GetService("GuiService"):OpenBrowserWindow(hubConfig.discord)
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

local lastNetError = nil
local lastHttpDetail = nil

local function debugLog(message)
	pcall(function()
		warn("[Project Stark] " .. tostring(message))
	end)
end

local function baseOrder()
	local bases = {}
	if activeBase then
		table.insert(bases, activeBase)
	end
	for _, base in ipairs(HUB_API_BASES) do
		if base ~= activeBase then
			table.insert(bases, base)
		end
	end
	return bases
end

-- Executor `request`/`http_request` first: it exposes status codes and works
-- on executors where game:HttpGet misbehaves. Falls back to game:HttpGet.
local function httpGetRaw(url)
	local req = (syn and syn.request) or (http and http.request) or http_request or request
	if type(req) == "function" then
		local ok, res = pcall(req, {
			Url = url,
			Method = "GET",
			Headers = {
				["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
				["Accept"] = "application/json, text/plain, */*",
			},
		})
		if ok and type(res) == "table" then
			local body = res.Body or res.body
			local status = res.StatusCode or res.Status or res.status
			if type(body) == "string" and #body > 0 then
				if type(status) == "number" and (status < 200 or status >= 300) then
					lastHttpDetail = "request http " .. tostring(status)
				else
					lastHttpDetail = "request ok"
				end
				return body
			end
			lastHttpDetail = "request empty body"
		else
			lastHttpDetail = "request error: " .. tostring(res)
		end
	end
	local ok, res = pcall(function()
		return game:HttpGet(url, true)
	end)
	if ok and type(res) == "string" and #res > 0 then
		lastHttpDetail = "HttpGet ok"
		return res
	end
	local firstErr = res
	ok, res = pcall(function()
		return game:HttpGet(url)
	end)
	if ok and type(res) == "string" and #res > 0 then
		lastHttpDetail = "HttpGet ok"
		return res
	end
	lastHttpDetail = "HttpGet error: " .. tostring(firstErr or res)
	return nil
end

local function hubHttpGet(path)
	local lastErr = nil
	for _, base in ipairs(baseOrder()) do
		local res = httpGetRaw(base .. path)
		if res then
			local okDecode, data = pcall(function()
				return HttpService:JSONDecode(res)
			end)
			if okDecode and type(data) == "table" then
				activeBase = base
				return data, nil
			end
			lastErr = lastHttpDetail or "bad response"
		else
			lastErr = lastHttpDetail or "no response"
		end
	end
	lastNetError = lastErr
	debugLog("api request failed: " .. tostring(path) .. " -> " .. tostring(lastErr))
	return nil, "network"
end

local function fetchRaw(path)
	for _, base in ipairs(baseOrder()) do
		local res = httpGetRaw(base .. path)
		if res and res ~= "" and res:sub(1, 1) ~= "{" then
			activeBase = base
			return res
		end
		if res and res:sub(1, 1) == "{" then
			debugLog("script fetch got JSON error for " .. tostring(path) .. " via " .. base .. ": " .. res:sub(1, 160))
		end
	end
	debugLog("script fetch failed: " .. tostring(path) .. " -> " .. tostring(lastHttpDetail))
	return nil
end

local function netErrorSuffix()
	if not lastNetError then
		return ""
	end
	return " [" .. tostring(lastNetError):sub(1, 140) .. "]"
end

local function fetchHubConfig()
	local data = hubHttpGet("/api/hub/config")
	if type(data) ~= "table" or data.success ~= true then
		return
	end
	debugLog("config ok via " .. tostring(activeBase))
	if type(data.site) == "string" and #data.site > 0 then
		hubConfig.site = data.site
	end
	if type(data.discord) == "string" and #data.discord > 0 then
		hubConfig.discord = data.discord
	end
	local grace = tonumber(data.grace_seconds)
	if grace and grace > 0 then
		hubConfig.grace_seconds = grace
	end
	local attempts = tonumber(data.max_attempts)
	if attempts and attempts > 0 then
		hubConfig.max_attempts = attempts
	end
end

local function verifyKey(key)
	local player = Players.LocalPlayer
	local userId = player and player.UserId or 0
	local hwid = getHwid()
	local path = string.format(
		"/api/hub/verify?key=%s&user_id=%s&hwid=%s",
		HttpService:UrlEncode(key), tostring(userId), HttpService:UrlEncode(hwid)
	)
	local data = hubHttpGet(path)
	if not data then
		return nil, "network", nil
	end
	if data.valid == true then
		return data, nil, nil
	end
	-- The server owns the user-facing wording for every rejection.
	return nil, data.code or "HUB_INVALID", data.error
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

	if wrongAttempts >= hubConfig.max_attempts then
		notify("Too many invalid attempts. Get a key at " .. hubConfig.site, "error")
		task.delay(1, function()
			kickPlayer("Project Stark: too many invalid key attempts.")
		end)
	end
end

local function handleKeyValidation(rawInput)
	local cleanKey, issues = sanitizeKey(rawInput)

	if issues.empty or issues.tooShort or issues.tooLong then
		notify("Enter your key from " .. hubConfig.site, "error")
		return false
	end

	if wrongAttempts >= hubConfig.max_attempts then
		return false
	end

	local data, code, errText = verifyKey(cleanKey)
	if data then
		setActiveSession(cleanKey, data)
		setKeyVerified()
		notify("Key accepted. Loading Project Stark...", "success")
		loadScript()
		return true
	end

	if code == "network" then
		notify("Could not reach the key server. Check your connection and try again." .. netErrorSuffix(), "error")
		return false
	end

	notify(errText or ("Key check failed. Get a new key at " .. hubConfig.site), "error")
	handleWrongKey()
	return false
end

clearLegacyKeyCheck()

-- Server-side client config (links, grace window, attempt limit).
fetchHubConfig()

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
		local data, code, errText = verifyKey(cleanSavedKey)
		if data then
			setActiveSession(cleanSavedKey, data)
			setKeyVerified()
			loadScript()
			return
		elseif code == "network" then
			local lastOk = tonumber(saved.last_ok) or 0
			local secondsLeft = tonumber(saved.seconds_left) or 0
			local notExpired = saved.lifetime == true or (lastOk + secondsLeft) > os.time()
			if (os.time() - lastOk) <= hubConfig.grace_seconds and notExpired then
				setActiveSession(cleanSavedKey, saved)
				setKeyVerified()
				local mins = math.max(1, math.floor(hubConfig.grace_seconds / 60))
				notify("Key server unreachable - using your key for up to " .. mins .. " minutes.", "warn")
				loadScript()
				return
			end
			notify("Could not reach the key server. Check your connection and try again." .. netErrorSuffix(), "error")
		else
			deleteSavedKey()
			savedRejected = true
			notify(errText or ("Key check failed. Get a new key at " .. hubConfig.site), "error")
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
	if type(_G.ProjectStarkUILib) == "table" then
		return _G.ProjectStarkUILib
	end
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
	-- The UI library is public: it renders the key-entry window before the
	-- user has a key. Game scripts stay key-gated.
	local source = fetchRaw("/api/hub/script?id=ui")
	if source then
		local okRemote, remoteLib = pcall(function()
			return loadstring(source)()
		end)
		if okRemote and remoteLib then
			return remoteLib
		end
		debugLog("ui loadstring failed: " .. tostring(remoteLib))
		local okLoad, loaded = pcall(function()
			return (loadstring(source) or load(source))()
		end)
		if okLoad and loaded then
			return loaded
		end
		debugLog("ui load failed: " .. tostring(loaded))
	else
		debugLog("ui fetch failed: " .. tostring(lastHttpDetail or lastNetError or "unknown"))
	end
	return _G.ProjectStarkUILib
end

local Lib = loadUiLib()
if not Lib then
	notify("Could not load the hub UI. Rejoin and try again." .. netErrorSuffix(), "error")
	debugLog("UI unavailable: http=" .. tostring(lastHttpDetail) .. " net=" .. tostring(lastNetError))
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
	notify("Link copied: claim a free 4-hour key or buy lifetime at " .. hubConfig.site)
end)

local HelpTab = win:Tab("Help")

HelpTab:Button("Where do I get a key?", function()
	copyKeyLink()
	notify("Log in with Discord at " .. hubConfig.site .. ", complete the checkpoint, and paste your personal key here.")
end)

HelpTab:Button("Why isn't my key working?", function()
	notify("Keys are personal: they only work on the Roblox account and PC that first used them.")
end)

HelpTab:Button("Key locked to an old PC?", function()
	notify("Run /hubreset in the Project Stark Discord server, then enter your key again.")
end)

HelpTab:Button("My key expired", function()
	copyKeyLink()
	notify("Free keys last 4 hours. Grab a new one at " .. hubConfig.site)
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

Credits:Button(hubConfig.discord .. " - Click to copy", function()
	joinDiscord()
end)
