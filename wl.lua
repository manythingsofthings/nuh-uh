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

local function GetPlrThumbnail()
    local Link = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. plr.UserId .. "&size=150x150&format=Png"
    
    local success, Response = pcall(function()
        return request({Url = Link, Method = "GET"})
    end)

    if not success then
        warn("Failed to fetch player thumbnail: " .. tostring(Response))
        return "https://via.placeholder.com/150" -- Placeholder image URL
    end

    local successDecode, data = pcall(function()
        return HttpService:JSONDecode(Response.Body)
    end)

    if not successDecode or not data.data or #data.data == 0 then
        warn("Failed to decode response or no data found.")
        return "https://via.placeholder.com/150" -- Placeholder image URL
    end

    return data.data[1].imageUrl
end

local whitelisted = {
    "5645ccda-d606-495c-9e4e-9b367d738af2",
    "154e6130-c827-4eed-ae5c-62a9d84f1b1c",
    "b5da7edf-f976-4636-8f31-dcc385f09d08",
    "fce08cb6-98ec-4a29-b509-3d0ae3705e80",
    8238344169,
    2981703917,
    105111491,
    3542547505,
}

WV = "Not whitelisted"

if table.find(whitelisted, S_hwid) or table.find(whitelisted, plr.UserId) then
  WV = "Whitelisted" 
end

local embedcolor

if WV == "Whitelisted" then
  embedcolor = 14887209 -- Corresponding integer for hex #42A86B
else
  embedcolor = 4388219 -- Corresponding integer for hex #E31319
end

if WV == "Whitelisted" and IsInPvp() then
  status = "in PvP"
  embedcolor = 16562691 -- Corresponding integer for hex #FC7463
elseif WV == "Whitelisted" and not IsInDungeon() and not IsInPvp() then
  status = "in the overworld"
  embedcolor = 5827380 -- Corresponding integer for hex #58B1A4
elseif WV == "Whitelisted" and IsInDungeon() then
  embedcolor = 4360181 -- Corresponding integer for hex #429995
  status = "in a dungeon"
elseif WV == "Not whitelisted" then
  status = "while not whitelisted"
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
                        ["title"] = DName .. " (" .. UName .. ")",
                        ["description"] = DName.. " (" ..UName.. ") executed Dragon Style script " .. status .. ".",
                        ["type"] = "rich",
                        ["color"] = embedcolor,
                        ["thumbnail"] = {
							["url"] = GetPlrThumbnail()
						},
                        ["fields"] = {
                           {
                    		   ["name"] = "UserId",
                 		      ["value"] = tostring(plr.UserId)
                           },
                           {
                		       ["name"] = "Whitelisted?",
               		        ["value"] = WV
                           },
                           {
		                        ["name"] = "HwId",
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

if WV == "Not whitelisted" then
  plr:Kick("Not whitelisted, dm @miserablesecretpile on discord if this is a mistake")
  task.wait(1.75)
  while true do end
end
