--// Project Stark UI Themes (LOCKED / Non-editable at runtime)
-- Return a read-only table of themes.

local Themes = {
    -- Base / Default
    DarkPurpleCosmic = {
        Background     = Color3.fromRGB(20, 15, 30),
        Sidebar        = Color3.fromRGB(24, 18, 36),
        Panel          = Color3.fromRGB(31, 31, 41),
        Accent         = Color3.fromRGB(138, 80, 255),
        Text           = Color3.fromRGB(230, 230, 255),
        Glow           = Color3.fromRGB(90, 0, 160),
        Shadow         = Color3.fromRGB(0, 0, 0),
        Transparency   = 0.08,
        Blur           = true,
        BlurIntensity  = 12,
        UseWindowAccent = true, -- allows old Window(accent) to tint title/line
    },

    DiscordDark = {
        Background     = Color3.fromRGB(32,34,37),
        Sidebar        = Color3.fromRGB(47,49,54),
        Panel          = Color3.fromRGB(54,57,63),
        Accent         = Color3.fromRGB(114,137,218), -- blurple
        Text           = Color3.fromRGB(240,240,240),
        Glow           = Color3.fromRGB(60,80,200),
        Shadow         = Color3.fromRGB(0, 0, 0),
        Transparency   = 0.06,
        Blur           = false,
        BlurIntensity  = 0,
        UseWindowAccent = false,
    },

    CyberNeon = {
        Background     = Color3.fromRGB(16,16,22),
        Sidebar        = Color3.fromRGB(18,18,26),
        Panel          = Color3.fromRGB(22,22,30),
        Accent         = Color3.fromRGB(0, 255, 200),
        Text           = Color3.fromRGB(225, 255, 245),
        Glow           = Color3.fromRGB(0, 200, 255),
        Shadow         = Color3.fromRGB(0, 0, 0),
        Transparency   = 0.07,
        Blur           = true,
        BlurIntensity  = 10,
        UseWindowAccent = false,
    },

    GlassMinimal = {
        Background     = Color3.fromRGB(28,28,34),
        Sidebar        = Color3.fromRGB(30,30,36),
        Panel          = Color3.fromRGB(34,34,42),
        Accent         = Color3.fromRGB(255, 255, 255),
        Text           = Color3.fromRGB(240, 240, 245),
        Glow           = Color3.fromRGB(180, 180, 200),
        Shadow         = Color3.fromRGB(0, 0, 0),
        Transparency   = 0.2,  -- glassy
        Blur           = true,
        BlurIntensity  = 16,
        UseWindowAccent = false,
    },
}

-- LOCK the table against edits
local mt
mt = {
    __index = Themes,
    __newindex = function()
        warn("[PS-UI] Themes are protected and cannot be edited.")
    end,
    __metatable = "ProjectStarkThemes_LOCKED"
}

-- replace each sub-table with read-only proxy too
local function lockTable(t)
    return setmetatable({}, {
        __index = t,
        __newindex = function() warn("[PS-UI] Themes are protected and cannot be edited.") end,
        __metatable = "LOCKED_SUBTABLE"
    })
end

local locked = {}
for k,v in pairs(Themes) do
    locked[k] = lockTable(v)
end
locked._LOCKED = true

return setmetatable(locked, mt)
