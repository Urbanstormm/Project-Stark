function Invdiscord(a)
    pcall(
        function()
            local b = game:GetService("HttpService")
            local c = syn and syn.request or (http and http.request or request)
            if not c then
                warn("❌ HTTP request function not available.")
                return
            end
            local d = {cmd = "INVITE_BROWSER", args = {code = a}, nonce = b:GenerateGUID(false)}
            c(
                {
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
                    Body = b:JSONEncode(d)
                }
            )
        end
    )
end
Invdiscord("hAsH4bQ6YG")
game:GetService("Players").LocalPlayer:Kick(
    "❌ Script not released yet.\nJoin the Discord for updates:\nhttps://discord.gg/hAsH4bQ6YG"
)
