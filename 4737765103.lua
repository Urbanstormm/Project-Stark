local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local keyCheck = LocalPlayer:FindFirstChild("Project Stark Key Check")

local HttpService = game:GetService("HttpService")
local JSONEncode = HttpService.JSONEncode
local GenerateGUID = HttpService.GenerateGUID
local Request = syn and syn.request or request

function discord(inviteCode)
pcall(function()
    Request({
        Url = "http://127.0.0.1:6463/rpc?v=1",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Origin"] = "https://discord.com"
        },
        Body = JSONEncode(HttpService, {
            cmd = "INVITE_BROWSER",
            args = {
                code = inviteCode
            },
            nonce = GenerateGUID(HttpService, false)
        }),
    })
end)
end


if not keyCheck then
    pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Urbanstormm/Project-Stark/main/Main.lua'))()
    end)
    discord("hAsH4bQ6YG")

elseif keyCheck.Value ~= true then
    pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Urbanstormm/Project-Stark/main/Main.lua'))()
    end)
    discord("hAsH4bQ6YG")
else
    keyCheck:Destroy()
    warn("-SN")
    --script here
end
