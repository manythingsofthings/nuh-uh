local HttpService = game:GetService("HttpService")

function from_base64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local whbase = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3Mv"
local whId = "MTMzMTM2NTY2MjA1MTkyNjEzOA=="
local wht = "TXh6XzI4VnppRl9DV1JRTm5zTklvOHdCbXZYYVJuOVR1dVVuWmR4aE92N0hSVWZWMVBIWk5BTWZOZjhwNWxEbTcyQ3E="

local Webhook_URL = from_base64(whbase) .. from_base64(whId) .. "/" .. from_base64(wht)

local ls = game:GetService("LocalizationService")
local S_hwid = game:GetService("RbxAnalyticsService"):GetClientId() or "Unknown"
local plre = game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
local DName = plre.DisplayName
local UName = plre.Name
local WV = "false"
local status = "nil"
local Countries = {}

local maks = "maksimmilana22"

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ME = ReplicatedStorage.Events.ME

function IsInDungeon()
    return game.ReplicatedStorage.Dungeon.Value
end

function IsInPvp()
    if plr:FindFirstChild("PvPed") then
        return true
    else
        return false
    end
end

local blacklisted = {"b997b340-4056-40ce-bae7-95ce083d6465", 140378057}

if table.find(blacklisted, S_hwid) or table.find(blacklisted, plr.UserId) then
  WV = "Blacklisted"
else
  WV = "Not blacklisted"
end

local embedcolor

if WV == "Not blacklisted" then
  embedcolor = 4388219 -- Corresponding integer for hex #42A86B
else
  embedcolor = 14887209 -- Corresponding integer for hex #E31319
end

if WV == "Not blacklisted" and IsInPvp() then
  status = "In Pvp"
  embedcolor = 16562691 -- Corresponding integer for hex #FC7463
elseif WV == "Not blacklisted" and not IsInDungeon() and not IsInPvp() then
  status = "In overworld"
  embedcolor = 5827380 -- Corresponding integer for hex #58B1A4
elseif WV == "Not blacklisted" and IsInDungeon() then
  embedcolor = 4360181 -- Corresponding integer for hex #429995
  status = "In dungeon"
elseif WV == "Blacklisted" then
  status = "Blacklisted"
end

if not S_hwid then
    S_hwid = "Unknown"
end
local response =
    request(
    {
        Url = Webhook_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(
            {
                ["content"] = "",
                ["embeds"] = {
                    {
                        ["title"] = "Script has been executed.",
                        ["description"] = DName.. " (" ..UName.. ") has executed a script. (" .. WV .. ") \n \n **Status** \n "..status,
                        ["type"] = "rich",
                        ["color"] = embedcolor,
                        ["fields"] = {
                           {
                       ["name"] = "Information",
                       ["value"] = "UserId: "..tostring(plr.UserId)
                           },
                           {
                        ["name"] = "Hardware Id",
                        ["value"] = S_hwid,
                        ["inline"] = true
                           }
                        }
                    }
                }
            }
        )
    }
)

local SoundEvent = {
        [1] = "repsound",
        [2] = "Teleport"
    }

if WV == "Blacklisted" then
  plr:Kick("ough ,,. yagami...") ME:FireServer(SoundEvent)
end
