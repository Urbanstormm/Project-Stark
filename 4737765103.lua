local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local keyCheck = LocalPlayer:FindFirstChild("Project Stark Key Check")

if not keyCheck then
    LocalPlayer:Kick("🚫 You must pass the Project Stark key system first!")
elseif keyCheck.Value ~= true then
    LocalPlayer:Kick("🚫 Your Project Stark key validation failed or expired!")
else
    -- Passed the check
    print("✅ Script Executed Successfully!")

    -- Clean up for neatness
    keyCheck:Destroy()
end
