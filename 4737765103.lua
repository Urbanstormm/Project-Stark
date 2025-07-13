function Invdiscord(inviteCode)
    pcall(
        function()
            local HttpService = game:GetService("HttpService")
            local JSONEncode = HttpService.JSONEncode
            local GenerateGUID = HttpService.GenerateGUID
            local Request = syn and syn.request or request
            Request(
                {
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = JSONEncode(
                        HttpService,
                        {
                            cmd = "INVITE_BROWSER",
                            args = {
                                code = inviteCode
                            },
                            nonce = GenerateGUID(HttpService, false)
                        }
                    )
                }
            )
        end
    )
end
Invdiscord("hAsH4bQ6YG")
LocalPlayer:Kick("❌Script not released yet\njoin the discord for updates\nhttps://discord.gg/hAsH4bQ6YG")
