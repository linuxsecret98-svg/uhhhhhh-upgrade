--[[
 ...    :::::        ::        ::        ::        ::        ::        
 ;;     ;;;;;;       ;;;       ;;;       ;;;       ;;;       ;;;       
[['     [[[[[[[cc,,. [[[[cc,,. [[[[cc,,. [[[[cc,,. [[[[cc,,. [[[[cc,,. 
$$      $$$$$$"""$$$ $$$"""$$$ $$$"""$$$ $$$"""$$$ $$$"""$$$ $$$"""$$$ 
88    .d888888   "88o888   "88o888   "88o888   "88o888   "88o888   "88o
 "YmmMMMM""MMM    YMMMMM    YMMMMM    YMMMMM    YMMMMM    YMMMMM    YMM
       "DREAMS WILL NEVER COME TRUE UNTIL YOU ACTUALLY MAKE IT."       

       Code:    STEVETHEREALONE
                BoredGal (mostly patches..)
       GFX:     STEVETHEREALONE
                AALib
                some random generators
       Music:   Original 8-bit chiptune (intro jingle + 2 tracks)

Thou shalth not steal. Point at this source if you used a snippet here.
]]

if _G.UhhhhhhLoaded then return end
_G.UhhhhhhLoaded = true

local UhhhhhhVersion = "1.0.9 BETA"

local Debris = cloneref(game:GetService("Debris"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local VRService = cloneref(game:GetService("VRService"))
local RunService = cloneref(game:GetService("RunService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local HttpService = cloneref(game:GetService("HttpService"))
local TextService = cloneref(game:GetService("TextService"))
local TweenService = cloneref(game:GetService("TweenService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))

local Util = {}

Util.RandomString = function(length)
	length = length or math.random(32, 256)
	local str = ""
	for _=1, length do
		str ..= string.char(math.random(32, 126))
	end
	return str
end
Util.DeepcopyTable = function(t)
	local c = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			v = Util.DeepcopyTable(v)
		end
		c[k] = v
	end
	return c
end
Util.Notify = function(text)
	StarterGui:SetCore("SendNotification", {
		Title = "Uhhhhhh",
		Text = text,
		Duration = 5
	})
end

cloneref = cloneref or function(o) return o end
getcustomasset = getcustomasset or getsynasset
gethiddengui = get_hidden_gui or gethui
request = request or (http and http.request)

local function ismissing(func)
	return not func or type(func) ~= "function"
end
do
	local function diefatal(msg)
		Util.Notify("Executor not supported. " .. msg)
		_G.UhhhhhhLoaded = nil
		error("fatal error cant start")
	end
	if ismissing(request) then
		diefatal("Missing `request` or `http.request` function!")
	end
	if ismissing(getcustomasset) then
		diefatal("Missing `getcustomasset` or `getsynasset` function!")
	end
	if ismissing(readfile)
		or ismissing(writefile)
		or ismissing(delfile)
		or ismissing(isfile)
		or ismissing(isfolder)
		or ismissing(makefolder)
		or ismissing(listfiles) then
		diefatal("Missing some filesystem functions!")
	end
	if ismissing(firetouchinterest) then
		diefatal("Missing `firetouchinterest` function!")
	end
	--if ismissing(replicatesignal) then
	--	diefatal("Missing `replicatesignal` function!")
	--end
	if ismissing(gethiddenproperty) then
		if ismissing(setscriptable) then
			diefatal("Missing `gethiddenproperty` and `setscriptable` function!")
		elseif ismissing(isscriptable) then
			gethiddenproperty = function(inst, prop, val)
				setscriptable(inst, prop, true)
				local val = inst[prop]
				setscriptable(inst, prop, false)
				return val
			end
		else
			gethiddenproperty = function(inst, prop, val)
				local was = isscriptable(inst, prop)
				if not was then setscriptable(inst, prop, true) end
				local val = inst[prop]
				if not was then setscriptable(inst, prop, false) end
				return val
			end
		end
	end
	if ismissing(sethiddenproperty) then
		if ismissing(setscriptable) then
			diefatal("Missing `sethiddenproperty` and `setscriptable` function!")
		elseif ismissing(isscriptable) then
			sethiddenproperty = function(inst, prop, val)
				setscriptable(inst, prop, true)
				inst[prop] = val
				setscriptable(inst, prop, false)
			end
		else
			gethiddenproperty = function(inst, prop, val)
				local was = isscriptable(inst, prop)
				if not was then setscriptable(inst, prop, true) end
				inst[prop] = val
				if not was then setscriptable(inst, prop, false) end
			end
		end
	end
	--if ismissing(hookmetamethod) or ismissing(hookfunction) then
	--	diefatal("Missing `hookmetamethod` and `hookfunction` function!")
	--end
	local loadstringreturn = false
	local val = math.random(-65536, 65536)
	local _, func = pcall(loadstring, "return " .. val)
	if func then
		local s, val2 = pcall(func)
		if s and val == val2 then
			loadstringreturn = true
		end
	end
	if not loadstringreturn then
		diefatal("`loadstring` makes a function that does not return values!")
	end
	if not ismissing(isfile) then
		local s, e = pcall(isfile, Util.RandomString(32))
		if s and e then
			-- stupid executor
			isfile = function(path)
				local s, e = pcall(readfile, path)
				return not not (s and e)
			end
		end
	else
		-- THIS LITERALLY SHOULDNT HAPPEN
		diefatal("T-this one shouldn't happen!")
	end
end

-- WILL THIS FIX CRASHES IDK ????????
local pcall = function(func, ...)
	return pcall(function(...)
		return func(...)
	end, ...)
end
local xpcall = function(func, ...)
	return xpcall(function(...)
		return func(...)
	end, ...)
end
local b_getfenv = getfenv

local Player = Players.LocalPlayer

if not game:IsLoaded() then
	local notLoaded = Instance.new("Message")
	xpcall(function()
		notLoaded.Parent = CoreGui
	end, function()
		notLoaded.Parent = workspace
	end)
	notLoaded.Text = "Uhhhhhh is waiting for the game to load"
	game.Loaded:Wait()
	for i=1, 60 do
		while task.wait() > 1 / 10 do end
	end
	notLoaded:Destroy()
end

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = workspace.CurrentCamera
	if newCamera ~= nil then
		Camera = newCamera
	end
end)
Util._scrsiz = Vector2.new(512, 512)
Util.GetScreenSize = function()
	if Camera ~= nil then
		Util._scrsiz = Camera.ViewportSize
	end
	return Util._scrsiz
end
Util.LoopedHSV = function(h, s, v)
	h %= 1
	s = math.clamp(s, 0, 1)
	v = math.clamp(v, 0, 1)
	return Color3.fromHSV(h, s, v)
end
Util.Instance = function(cl, p)
	local i = Instance.new(cl)
	i.Name = Util.RandomString()
	i.Parent = p
	return i
end
Util.LinkDestroyI2C = function(a, b)
	a.Destroying:Once(function()
		b:Disconnect()
	end)
end
Util.LinkDestroyI2I = function(a, b)
	Util.LinkDestroyI2C(b, a.Destroying:Once(function()
		task.defer(b.Destroy, b)
	end))
end
Util.ClearAllChildrenGui = function(a)
	for _,v in a:GetChildren() do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end
Util.GetTransparency = function(part)
	return 1 - (1 - part.Transparency) * (1 - part.LocalTransparencyModifier)
end
Util.ScaleCFrame = function(cf, scale)
	return cf + cf.Position * (scale - 1)
end
Util.IsGuiVisible = function(guiObject)
	if not guiObject or not guiObject:IsA("GuiObject") then return false end
	while guiObject do
		if not guiObject.Visible then
			return false
		end
		guiObject = guiObject:FindFirstAncestorWhichIsA("GuiObject")
	end
	return true
end
Util.IsGuiInteractable = function(guiObject)
	if not guiObject or not guiObject:IsA("GuiObject") then return false end
	while guiObject do
		if not guiObject.Visible or not guiObject.Interactable then
			return false
		end
		guiObject = guiObject:FindFirstAncestorWhichIsA("GuiObject")
	end
	return true
end
Util.WillGuiSinkInput = function(guiObject)
	return Util.IsGuiInteractable(guiObject) and (guiObject.Active or guiObject:IsA("GuiButton"))
end
Util.UDim2ToVector2Scale = function(x)
	return Vector2.new(x.X.Scale, x.Y.Scale)
end
Util.UDim2ToVector2Offset = function(x)
	return Vector2.new(x.X.Offset, x.Y.Offset)
end
Util.Vector2ToUDim2Scale = function(x)
	return UDim2.fromScale(x.X, x.Y)
end
Util.Vector2ToUDim2Offset = function(x)
	return UDim2.fromOffset(x.X, x.Y)
end
Util.ForceTextSize = function(inst)
	if inst:IsA("TextLabel") then
		local original = inst.TextSize
		local conn conn = RunService.PreRender:Connect(function()
			local size = GuiService.PreferredTextSize.Name
			if size == "Medium" then
				inst.TextSize = original
			elseif size == "Large" then
				inst.TextSize = original - 4
			elseif size == "Larger" then
				inst.TextSize = original - 9
			elseif size == "Largest" then
				inst.TextSize = original - 14
			end
		end)
		Util.LinkDestroyI2C(inst, conn)
	end
end
Util.QueryPlayerSelector = function(query, excludespeaker)
	if #query == 0 then return end
	query = query:lower()
	local t = {}
	for _,player in Players:GetPlayers() do
		if player ~= Player or not excludespeaker then
			local a = player.DisplayName:lower():find(query)
			local b = player.Name:lower():find(query)
			if a then table.insert(t, {player, 1, a}) end
			if b then table.insert(t, {player, 0, b}) end
		end
	end
	table.sort(t, function(a, b)
		if a[2] == b[2] then
			return a[3] < b[3]
		end
		return a[2] < b[2]
	end)
	if t[1] then
		return t[1][1]
	end
	return nil
end

local IsUhhhhhhFullyLoaded = false

local SCREENGUI = Util.Instance("ScreenGui")
SCREENGUI.IgnoreGuiInset = true
SCREENGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SCREENGUI.ClipToDeviceSafeArea = false
SCREENGUI.ResetOnSpawn = false
SCREENGUI.ScreenInsets = Enum.ScreenInsets.None
SCREENGUI.DisplayOrder = 2147483647
if gethiddengui then
	SCREENGUI.Parent = gethiddengui()
else
	SCREENGUI.Parent = CoreGui
end

local UIMainFrame = Util.Instance("Frame", SCREENGUI)
UIMainFrame.AnchorPoint = Vector2.new(0, 0)
UIMainFrame.Position = UDim2.new(0, 0, 0, 0)
UIMainFrame.Size = UDim2.new(1, 0, 1, 0)
UIMainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
UIMainFrame.BackgroundTransparency = 1
UIMainFrame.BorderSizePixel = 0
UIMainFrame.ZIndex = 2147483647

local SaveData = {}
do
	pcall(makefolder, "UhhhhhhReanim")
	pcall(writefile, "UhhhhhhReanim/.nomedia", "")
	local SaveDataFilename = "UhhhhhhReanim/tree.ehehetilde"
	local s, data = pcall(readfile, SaveDataFilename)
	if s and data then
		s, data = pcall(HttpService.JSONDecode, HttpService, data)
		if s and data then
			SaveData = data
		else
			pcall(writefile, SaveDataFilename, "{}")
		end
	else
		pcall(writefile, SaveDataFilename, "{}")
	end
	task.spawn(function()
		local odata = nil
		local savefailwarn = false
		while true do
			task.wait()
			local s, data = pcall(HttpService.JSONEncode, HttpService, SaveData)
			if s then
				odata = odata or data
				if odata ~= data then
					local s, err = pcall(writefile, SaveDataFilename, data)
					if s then
						savefailwarn = false
						odata = data
					else
						if not savefailwarn then
							Util.Notify("Failed to write tree.ehehetilde (your save file)")
							savefailwarn = true
						end
					end
					task.wait(5)
				end
			else
				if not savefailwarn then
					Util.Notify("Failed to write tree.ehehetilde (your save file)")
					savefailwarn = true
				end
			end
		end
	end)
	pcall(makefolder, "UhhhhhhReanim/Assets")
	pcall(makefolder, "UhhhhhhReanim/Modules")
	pcall(makefolder, "UhhhhhhReanim/Muzik")
	pcall(makefolder, "UhhhhhhReanim/BuiltinModules")
	pcall(makefolder, "UhhhhhhReanim/Content")
	pcall(makefolder, "UhhhhhhReanim/Content/Anims")
	pcall(makefolder, "UhhhhhhReanim/Content/Sounds")
	pcall(makefolder, "UhhhhhhReanim/Content/Images")
	pcall(makefolder, "UhhhhhhReanim/Content/Models")
	pcall(makefolder, "UhhhhhhReanim/Content/Unknown")
end

do
	local CDNVersion = 3
	local AllFileNames = {
		"lightinursoul.graphic.png",
		"letriangul.graphic.png",
	}
	local redownloadeverything = SaveData.CDNVersion ~= CDNVersion
	local theresassetsmissing = redownloadeverything
	for _,rfile in AllFileNames do
		local fil = "UhhhhhhReanim/Assets/" .. rfile
		local s, d = pcall(isfile, fil)
		if not (s and d) then
			theresassetsmissing = true
		end
	end
	if theresassetsmissing then
		local downloaded = 0
		local skipped = 0
		local assetsdownload = 0
		local downloadfile = function(meta)
			local fil = "UhhhhhhReanim/Assets/" .. meta.name
			if not redownloadeverything then
				local s, d = pcall(isfile, fil)
				if s and d then
					downloaded += 1
					return
				end
			end
			if not pcall(function()
				writefile(fil, game:HttpGet(meta.download_url))
			end) then skipped += 1 end
			downloaded += 1
		end
		local Downloading = Util.Instance("TextLabel", UIMainFrame)
		Downloading.AnchorPoint = Vector2.new(0.5, 0.5)
		Downloading.Position = UDim2.new(0.5, 0, 0.5, 0)
		Downloading.Size = UDim2.new(1, 0, 0, 0)
		Downloading.BackgroundColor3 = Color3.new(0, 0, 0)
		Downloading.BackgroundTransparency = 0.2
		Downloading.ClipsDescendants = true
		Downloading.BorderSizePixel = 0
		Downloading.TextColor3 = Color3.new(1, 1, 1)
		Downloading.TextSize = 20
		Downloading.Font = Enum.Font.Code
		Downloading.Text = "Fetching Assets metadata..."
		Util.ForceTextSize(Downloading)
		TweenService:Create(Downloading, TweenInfo.new(0.5), {
			Size = UDim2.new(1, 0, 0, 32)
		}):Play()
		task.wait(0.5)
		local s, assetsof = pcall(game.HttpGet, game, "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/uiassets/")
		if s and assetsof then
			s, assetsof = pcall(HttpService.JSONDecode, HttpService, assetsof)
			if s and assetsof then
				for i,file in assetsof do
					if not table.find(AllFileNames, file.name) then
						continue
					end
					assetsdownload += 1
					task.spawn(downloadfile, file)
				end
				repeat
					Downloading.Text = `Downloading assets {downloaded}/{assetsdownload}... ({skipped} skipped)`
					Downloading.BackgroundColor3 = Color3.new(0, 0, 0)
					task.wait()
				until downloaded == assetsdownload
				Downloading.Text = "Download complete! \\(^o^)/"
				Downloading.BackgroundColor3 = Color3.new(0, 1, 0)
				theresassetsmissing = false
			end
		end
		SaveData.CDNVersion = CDNVersion
		if theresassetsmissing then
			Downloading.Text = "Asset downloading failed. 3:"
			Downloading.BackgroundColor3 = Color3.new(1, 0, 0)
		end
		TweenService:Create(Downloading, TweenInfo.new(0.5), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
		}):Play()
		task.wait(0.5)
		Downloading:Destroy()
	end
end

-- ==========================================================================
--  RETRO AUDIO  ::  original 8-bit soundtrack (embedded, written on first run)
--  intro jingle (synced to the intro animation) + 2 background tracks
-- ==========================================================================
do
	local ASSET_DIR = "UhhhhhhReanim/Assets/"
	local RETRO = {
		Intro = {"rn1_intro.mp3", 26872, [==[
SUQzBAAAAAAAI1RTU0UAAAAPAAADTGF2ZjYwLjE2LjEwMAAAAAAAAAAAAAAA//NwwAAAAAAAAAAAAEluZm8AAAAPAAAA/wAAaMsABAcJDA4REx
YYGx4gIyUoKi0vMjU3Ojw/QURGSUtOUVNWWFtdYGJlaGptb3J0d3l8foGEhomLjpCTlZibnaCipaeqrK+xtLe5vL7Bw8bIy87Q09XY2t3f4uTn
6uzv8fT2+fv+AAAAAExhdmM2MC4zMQAAAAAAAAAAAAAAACQDBgAAAAAAAGjLRYEWuQAAAAAAAAAAAAAAAAD/80DEAAxwIrQXQxgAdaN0IVcDAw
MW9QIAgsEHQQBMHwfB8PxACAYz/lw//y4f4If4f9H8uD78Yc//8//ggGG2yx2FIGEFgVAlolExMCVULLOwXHZYkQVNIkE/SbwxdkYOJGxED4rq
hv/zQsQpHunK1l+PSACRpqROTAAFBpbIucqolaE2wk2unJK9hDFVdtrGa1Kr3G720rza9fL8/db/5e452O6ryfhTrL+baaB0g9lV7W2IPtNzhh
T/tQlTqI1L/8i//AZQmollYmhBrfwCSv/zQMQJFdFW4t3JKAAykog68qXcqtD9DsatKM0oPREdSsrGVHZ2S6VslLIrWvsqILu4KwfEQ4UVFBAO
xMHyQKLGhaGxyCQJgV4meTcOSXUcLgNMo4nal2L10frqilVmrIP78tYhEYnX//NCxAwXkFbe7EjGJTotgOjIFcQpkISIVIoKC5JlkpUYB4Z4Ea
qLfQvpXeiqqKmxwxvV2eYS10ZYWdNucOLNynYltNVmDwztShC46SiJ59wGTXDSzzOYX68yRe2fnzcqiXV2uccqqwNJ//NAxAkV2Jre9DCG4Eut
A8nCJTQdESdiElSYi085AlCiQ4x+xQFraGgCARK0aWBlQiFkGg6ZMhFjhyUIvMHGjBQUuc5LqDr2Nqkh+y4zvHUPbSx9OymwXWbQcVXfbW622y
PwBY0glTj/80LEDBSRDwpce8Zyy2L75l3FeQ/LN8eLek6kLqBnJOAvhWHem1Qr7CRwgRxSOEeEh7BATwkyHi/ODOIBjmFwfB8mSFhUoyYV+jLb
f6XAa+k1etU4h0SMuf3ahaqB802rwu8nzcLgSQL/80DEFRPhEt70M8SkQEpJsOE9CdFyIKXuVz6Kxr2ayPpqDc7zxBwhIqVOA0PExJQ3pTeh15
YXAM76px8i5FvchrmLbZ/b/qWpeDUhRxtqwBMmdHx37NfLHEbYWbEoMBELAx7Xr9NPuP/zQsQgE3Du2vx+BoQIgFANtslZQT5wjSWhzCZqKFSg
JHTokJwipaxskzewWPJcnRiv3pt/ItqcmMahaSQwAcc1VYXbSEfT8MeEjALwAOCSGtIUF0y2RMfUjEfllO5Nz6QWict4hVELDf/zQMQuExCu0v
RLzESlsmqBSIold7nIoKxthadt2Ps3dtyWfd//7q5dw/pVukABquqMxmtWr2rzS2fF2g2pZILJC7GnEBoVo13KOJwUXVkVSdksRsISn6VXGtPM
/elnTpqSB2njpRlC//NCxDwUeS7KNMGGdGdLYwYKBHToe4BWq0p/pZfR//70WSqLcEVmXa67b8Y2Mog7Km4iECmnvBi1dZBYHnNceyaWlr1a2a
/vAlTYSmi+Z7Epv+ZWp5mT6hJNxuRUVxz7zZFLHU0Np10b//NAxEYUYSLi/sMGVLQ6u3UnxzKv0ef+uqkAEy5rd9tuA/E7KGxtSME3GnrV3XKC
UDBoaWoKKuxMRQjvRRR1QnKqpKRSaO9FqzKCRrjO5iWdDrnTaa7dd7P8zg20xrsfcx2/6bU2xOv/80LETxRhyt7+wMR83f6qAKUvcy+syAxILt
EoKQPrgClczMjExOboUfLYj2uLZUjOyGt0o6pYRtCUwewioegSOYZCqAXoTk1F3d60thGtoHCRIuLeJaSFXup/8d/RCTeCW4uNfsWJSzn/80DE
WRN43rxUwwY0KlS3p1xVKGHC5sLbIy2VtnkVOvILVJV63Am11B3bRqMtW1ah/9qf7GP2ZW/bRB0FgDyxznVpacu1Pv3/////////tZDlEgHZGT
elGmxLVx9slO5bxxhsUKeWH//zQsRmFWLytArDzj1FlgxMO3s0eBW817Wxu/9F8Bmg2ifas10XNMoh2cZPR3Y49VmMrUPNulX/8TA31bSdV031
dHnmzjrLq6mob6bVemY/6////hYNfQtRB/WqjZiq4XRLQAMLWejEzP/zQMRsF4ruwD7DzjyqcnB+sMLHZghsLC8a3sDDlVvj2pv2gAGsTuef5A
zHEOGGfGWsp59MywTBK1M9rSwxc/82Fdm0lOpSTqQ2TQSUn+gs+boJ//1u9RnahVXWtKvV///kQhfnhGpg//NCxGgbEu64HnjbLESAEePqBAAv
kN1vEh7r5PykcF7anTqPw34guESks8se94s1NW9L1uAxXvEteHXal65VKjKmLUsMViXLGIemYROx6/Qs5mpLOqXdKindE0OWv/r1jC9SdJ2OTJ
F1//NAxFckcvK9Hn5nJC2MkUbFI3J0sFYV0Y4DNQOJHAOIjTQniieMTA+ZoJLZSq1JLZVSd1spbLW9kl/Z6utePorfcmKuJUhWAgTBNOC/DbWM
01m04IUNdR0XYGElmoEYTwsBe4GJwtL/80LEIBri8rmeeaBwjogTVTP1rNwiE8tFkmuy32rdaSlv3901dfTsnseG6KMmyG9db1oXZa2TTX+mKc
h//+l67PsuvZ7dF1pJoJtUz1R+HemsUSFyu5qeul742TLZHdhOVkAoiSB3OUT/80DEEBe68uW+WNVKEiafLzc1mHOMz6Z412Oc+owlfH/9iq8S
piV6ra4ZuMiCi2aMbqGY0h7HW93B0RX+qdPW39HB4LD//+rTv/+/NRG1VLVU5HKB1FHrIumWKdAcZgvAqVasLHwfbP/zQsQMFjLutF5kVOi4aV
q9DDBz0JPNTpt6Gz6OqtgfGUtGvc+EwbMhIeydTrTJ1zylVOauzIr//gyNN65rs5ptc5f+kiDn//PTW2iPT/7P33R0TmEQJtMIpXIWb8O9D5FB
DU6pu1Khgf/zQMQPForutB54VUi5lfPYUaFmzzPvSFvWqZ+YQCvu9t6/+JwdiU2IjVGbyhYN3wkNtmNGX/w9Cy3bv5v0/0jMNU//zNtHVdWtR9
daeaeln0xICOslIfSqjmC+zJR0WtCwqV/WG+tC//NCxA8WUu7A9ntVApmONnxoa3LS1Zb43Azq+5FgrGj9DweD6bm023P7os9btdCByzMjvf/D
0IGbbvSvoiP/QwK4ff/71rXvajd633/T9Nw2ooZTjgQ7KhuXUHIO1p4Zy7n2/u9yrWCk//NAxBEXovK01ntVFo93aE9mq4OcGS99Vv7lQDvzb5
xIXAyLW6aemu55JNE3TRu6aK3pakle3szWcxDyhay0Ton//QGRr//9KdaU+fvpUz7eqqjBsqlvPv34ygmlBkG6rKSJLTpaKg3/80LEDRbC8qy2
wmA3oDIwjMW9dWCJ74Vi7lbrd6YQxtLXzh8fg3l2c1tp0UGUc22dJ9DVVRWg2v+YEI3//7f9hqv//+////detGyLu6rVHBh2UPSOtOXsr/uVDo
lBxuKzD1XBGFRdgUz/80DEDhWC8sWeehRS4CwPGkmtEpZh5dpaKdpwk7/S4czm3VqpNPcxWpM2T2snba1IkBSr3a77OrKj7sn1YKo3//7WRzKm
bK7N+1P//lBt+itShQ2NCrlSAXI3Gy/5QSGwsVBVlcUEyv/zQsQTEzIGpLbCYjTHYMp0iYS17TJu/UdABBu5OV8yYjwZEmUlWrrUrfXd2R6ak6
uq9/qWPzLZX/r9f/WxdG23V6ez//hmACUjq2A93Av4RDE5OUN5SeV7Xe496uV8QPfXt96zgBhp4//zQMQiE2rqrV54T0jf+3kofIWHVV/MDM3I
7vMZlWW1fgoMf/tVV6f6mA03//1M+3o39///oJjXdQFuJtRSgY6ywB5cLO4UCDAU00WJdytutFJXWuvaEs9X1MRRR67fep5zaV7TmR9K//NCxC
8Uauq5fntOz3/gYPv6HocyIhyNafv9YoD2//q7zdvfZrfqi+fs7s6UEa2CCqeByOu3CZOCeBt46gUMQUtFen7js4I21jvNvDjV+kXh9OsZpOna
Ol2V9KOdbrX/wrBb+fbsboky//NAxDkUMu7FnmGUNsZ+qBUHW//6HJ3vt7c9P0/35hYz+YvJLiG1HEi7ZpuB5BiwBylmKRA2AsKPIb50Sg+qVu
uoFm9L6ReH1t/7VmPorbPsic7/4uC1ba6HLuetc5K/wYO//5jfq1v/80LEQxOa7tZeM1TmvNq3+p2unPU4at0ViZpCSOu0DwEIeEgQCdo5e+eU
Abwbv2TzTGxUu2BU2+kXh9ID9j2ZlPUnOc+j03OQ5X2O3/8iC32ptVjjj3cxKU+kMhM//9HT/3f26N//5hL/80DEUBQK7sGeeZRSqkIAMFxRag
YUzDywARBIyAODYrZQNkatieRLSrUt2bDMp3e8yADW8211mRqDGAoqX+re+1F+kujU9+z/9aQv/q+v6/+qfHR/6k408Ks3f+QqCAmB+1KB+i4b
MP/zQsRaE9IGoh7CWjjNHwvSeygODgKNRXaLG26BFF8elh0rR+phDiQ9X2TXXe7pMtqmS9r//rHX1vt///UoikH///2q6//qdlq9XruZsnRVDB
lAtqKQD3ivVwBzSAsL7e5YLlM2Su94bv/zQMRmEwrusZZ5mlbUkH5sfVd1FwNlPT6kDQO4tEFNX+pJG7JJpvVQTu2ukr/6lkLXWyC0FN96//QH
0oN//oT/+CqSp/2XJIip1L/mCIbvoHFwb8QlFkjOylMvpDMC/FLjnAcKBOmc//NCxHQTugaxn09oAkBhmzIPlIcLOI4rONYPAQiJAxyyZNSAic
j3dVTLdYpwyJS/l8yJwuIublEGgCPTpiOQN/offfTqNtc6LMRMvU39k03t+gZhqwvpE2T6N1LYr///vdD/W5URPDJl//NAxIEla9KsAZiQASWg
Wkk9CUS3///3Uxov//0lFEYIFQxoBIXGgbmbl+yQGaFLZbVeQR4ZU20urVYAp5dAUNjlhu7Xot6i6it1GYRy8mgzpO6BgDCSi2Wqk6jI2Aiz31
zIkgB0HCP/80LERiWjRq2d2GgBohUaJOpIdwEzJI2coDtLTIwMiTOHExjnCmYDx1GQn6KPVzItCFLqSlmT1onAdRSNqkOpbqb+tAYFfUlomINJ
5XP+oh+r//rRHp9fWSInKLpVIAgxIG4ahXckj0//80DECxazQsI8fFTY5C7SWoBMp6d7v4iZ2zBHAsmXrs9Y0ddfY8Ls1/6x2I+rrF8aldBkme
0xEcNoQVSqJIy0w9uMv/EsPtGbzgLf///Jvr4VT/f1JP///K/+QFlEDDBy9zeEasmmeP/zQsQLFkNCxjx8FNiGl5dRwxlW2vf8wGfsIShM6kX3
47n/seFN/+OND+yItBoTx2ZH7LqFPdGpOZqrmOpKyl/FX/wzFHt6iGf///ji/6iSJ66/Qj///8ff+UaDkKxwpTTgN1npNQITtf/zQMQOFks+wC
p6FOgh0MlKX8/BJDygMCGAB2V3dwh0+yBQxEDN1/qIRfXwnE72+fLiILOlGt6kZ5/qPv+oVS36GMhJ/MPP/t7mGf7Dq9vne7//Mbt/q5EqACgW
KMGo5g3tqDn3QgT4//NCxA8XUwLJkjPaPEmQMG+M5VspVLVcJIJE5Qrb3lHa3jFhZGLZFd9+vHv/0RPLqVVdKoxJcIUurZf60SVP/t/5X95Ui0
3/4miT/+cL//OH//R9F//qJWnyZGqAAOAJSJnAKS7VSIVP//NAxA0UIwLSXDPUVMnbkZb2/mpfOT2j5xINSv1/BSdXDwvxeXtOu2ojfOdpgVjP
+iDEOV9fQK1vv/4vL/i5sgp6WC2W/+qf9P//Kf/x39qasRVzcts0kTCSj5iLeRr8rhGlWqDCKgT/80LEFxRCXwJeSZQyReYI4S0vwVXRIPBujs
FUU0s6WwuaLn7FQAS//ND6h6qhjbwljh6+W/8Yjv5Tm0/hQr/9yX1f/859a4AIFS/QO17Yr0Kx/vDTQEovY4wr9z4np5hjY+b7eJV/r3z/80DE
IhOKKtGUY87IiAZ5UvXY93zv/EhtP0MUOz0b+Iv1JjYsr1+VD9VsnJf6BAX/fT/n5X8Q/tbVglvAKhuvN+l9dFZIHWRFFa9g66Sjf0HhF+cWLs
Sleg53YoXrUvacBMkd1/6O3//zQsQuE8q20Mozzjz9S1TBe38p6mmgHmt/y/Ukanb+0e//fyp3//Kjj7PnH/WqzQU7T1ackVCSratqsKerkxdE
KBvTM7YRLoj+Rd9YD0YuhiolIGKMo00BBc1GU7r+S//Utxn/P/HQWf/zQMQ6E+q26l5bTsj/lC/jWj7/8f9P/yr+v/xj/a71Lc5FgA8KCUR91n
plvqpnPr2C/fT4O17JNc3u8frI6t+3+QmZsZ/K3bew7cImXt1+pBv/ZS2pf/N/QJf/KP4232/7P//5V//9//NCxEUT0v7NjHmPIMTDXyv/sPT/
qWMVlAAiArwAMUClMxQ3mkQoxeIP+i4qxmdFWiPgnDfD3qzJjE2PGg3mDOsTdH3aYYY5cQDop/+2r/6foD/+nxv//Gf//Cx9Nf/QH2fOnvUsZS
pC//NAxFET2rbaXktK0NY03zkkyNylDG4XJWekGp/Fgc4u2+1fX6GJi9fnFswJ1USxzKigQf7enugfI77+sV1/7/qAn/iB/Gb//QTAATI7f/r8
TT/qLf5ZH6A9zJYxjLfg3RFBauqtlJn/80LEXBN6uswAS8qUImoTZ0jKPiJUzFbYL0boGTUgbbul9IjhDewybz/t4qCmhCWJW6FGFCSpJ/kP8l
/8p8/f/TmhkX//6v5X/1JNf0J/kpAAKSgXCJslEiVZSlBKIXkor+kbZNENDtD/80DEahRCuuJcS1TIjMtIbW7KCQLorb5FF6+K//ZrzxsExiO6
+iuLdS3+n6E//E3zN/9eUA5v//fyr/9Bb//7//9mLIACMUqhBAovFxTyQ6wpmE+3is/lPLwmZ9DERiwZRDpsouB2jv/zQMR0E/tC2lxLTsz0ej
B6Grq5QBAJHVGoLOv4WBNpt7UOEuHaFv9/5T/yn33zf/Exb/1/8q//Q////330TMEZM1vd0MgSIsEiASN6ztK+MUARSRR6aD2vh0UUDMmDBpIv
qEue38fy//NCxH8Wqz7SPnqO6YzBFIZi+FsAkxoJUl2TU163cmEf+jSIBGcQKlvr/L/6fbff/U5h3//v5R6uHG7/8QfYgiroylEJKki0PkVjpd
N7VSBLRDv5laLC5WK2VBeEVTtAYVm/sPq9Szqz//NAxIAV2prZnktK1IA7SXZXtqiDwf2bOoeVBFEEx8eL70RnSuX/9Pv9v+OuW///95UY/Z8j
StvOeYgXYKzuhNe+m3TyBCy13T5JTbZMaki+2qmyIjPAT4pNbax7EKhWxTON31RMqvH/80LEgxb7Atm+S07QW6mMQKYiyZ1fSpji4U/yuhUPmk
RPvvnelTP/Iiyr9M//QRjy3/R/W/KF4xDX+3/9OotKggFCybm2rAhXtWwjCeCGswPb8eiaGNvHkJ2bPVjJ1rYyNFNKyP9SQkT/80DEgxZbAsAA
fFVAgur6ZpQcF39OVN5f/T+3/29Kl8z9MSyPb+Yvv6PKgz9SPnt/R5yhJ+sfBwEIEwSkse9U3ALVEP246sMhrdAXj6VFcC8brohIhs0U9tAHVr
/QkeDh8XV5L6KObf/zQsSEFLsGzOxjTuz/zfiBCf+39//wFf///01DOQigIIEvLf++gR7/8hBdsqfsc0elqbGzWnSa9/+Uir3jQVegdH0jVx0+
iA8Gil5wdq0VF8Vzz347Dal/0hNCEJQ+XFo6lWdxWLW/p//zQMSNE/NC1PRCiuxW+KgX6Nt1aulTt+/dBQe23///t+hv//7//42dhqD8atHc7B
BeFdUA63+hNQWP8EeMSIo45IMb3fXACcd+oy5Y0a6dqNAUkSf+gWODRhQmaerLME4tX7fb88HT//NCxJgWM0MSXktOutP6+6o5O5mqUR4PiLZ3
///lv7///t//idWIDQ0ITwHnCm1lX54k2NOOOFaFYniuLfqAVvu6hj4i+b+FjF85R2seks9DZru3M/B8WdpyfNHSx9zKN9P2Dnp/X1Qx//NAxJ
sV0z7qXjLOzHrz+6iE1v/+n/LfnkvX////xENVioA8LMrWwYp3SLN9fJ5u9Q7tmljdYUOfQJr3+6hxzqc4U6gQWRun1Wlv+zbbHOhP+D//fxGt
1nU91VyARFO5/9uMf1ag78b/80LEnhWTQtWcS88Ign//vT/14GdTkjKfq2+b9gFomyqbRF+zuY3tBsrjWQXkmLplUlifPbrsXR7isi1XZRFIcR
9Wruw3Qzd9kIavtdFBcDb/kIuVNOsj9ileLPzNBKCjFHtu03yj+Zr/80DEoxPDQuY2MorkFv5b/d/WnENIAwG0iLRSTUultysntRYNTn4Pk08g
WjqfvrQADnr0OYRw51IcY5Tr2qYNv/OVu26AiDrU/kf/X3X5f/j4VLdDXY1DHRLFH7HZRrIbcKCOmqkDqP/zQsSvFnq29v4zVMyVrjWX1/+KGm
OUMp7HPjt/hMa6WorS7FdW7CI3WkC4/uY8mtq/wGr69PFIZdLjixx6+ndHDfVPsv/Ez/9Cfz//Mqm315oHk+n9K0fz6lL36Bt10T16K1O3X6Em
qv/zQMSxFzNC1bZajxRqRFOOuVNuQVXsY7JTiAnnS7LJyeKo61LE7SZaqwTK74oFxIuPhQISyojtGTVHjKp3ZxqDTTTHXTJCci1PhY7/qd/6t7
16/8oKRn3/9PldP5Ubepvr6rX+n2FL//NCxK8U0z76/jLOyej+QChlZy6UN44UAi6XqpNdO8makRZxk//wWjiBqKh1KZjpQjEO/K5Lm2f+Mi5K
eUYs9WU89noXvYSg+f+egWG/4vN9qtc79GiuSAmvL/u9Sm7QqMqUe1sqHN7f//NAxLcXAz76XjNOrn6kr/1+wUL0Kq42prTiskoXdZ8Lu8v4AZ
o16sg0DkBeX4101BQtdH3ND9OmUa/n/Kl2bn+pVu/oOJ+c5AAXehtNVFUUTDLzVp/5oyC11f3P9PkZej83KCz6I3v/80LEthjzRtm+So8c+9u3
ai7CLHyTZ40EApGPaIHFi0QL7NJlQdlJZbDWjekkVo51tIs78/AJ039nPndYNt8kTPZPSyQsfp/Ic77+gx/zxG7Mq6ORbmze3/KCAZ//6fuhhj
fOJ9vpLvT/80DErhb7RvY+WZQz/DSgTYJceqHvXm/WLaVDdsx22sdl8tyaMG1WYhsHVnkKtlGxT7Fbl4JKmy3d3ajTRCDWRfVs0NZr7SoY3/MF
t39KGt6bb/8VFH///6PKC3+X/3HP1dxE2PJJHv/zQsStFPq60jRhT0iuHQM86aTx5DV6YHnGXz0ko8zBLl0a4gKps9SCmQjr6DohWGyM61dZgg
Q2vm11Zw/1f1HP+g3/8qb///kZn///o9C36p9P/dCP+tUIBBhigTbUFIi2E5fEcG2rpf/zQMS1FLq2xMpjTtCTW2gRH8kQAoLP0AWe2+ppGJ+q
ESQ2GtX1+4jjN/pVhwe19RWHaN9Si/8dP68zX9aES7///9MoMfqW//9lL/0KgAgoYoAc99jGfns5BAXFHoQdmI/zLwSft71w//NCxL0UEwbJlG
NU7CUmZ/hVbvTJzvmZwxr//SESQnC6I738/lXW3icW/6GCSe/1yq/qW//EH/9/+mULfmN//+Q/UUoIwwBsUJgT8z6T7+K5tkdaM+lKM7QIv3d4
zBmO1KeaVyRZHsti//NAxMgUGwbFlEqO7ED603duis1JERkF4eeZ+8v28Lmav8eGEOt89Sf2Vtunz27///9C3XQt6//1//xqRiQIxA8AlhpYRF
t/ijit7GDZRRiO4uFhnvNCBK5hZkjMk7C5IglUn/8RgtD/80LE0hRjAsmUWg9k3LbRUEh6/wvp+YDvVqUy5rLUlUs/XG20///6N+j+3/83/+FV
CAiQrPM0KEunIcx7v7bmUq9mqiXUB1rbRh5U3XUgbP9+07FsFYgW3GnThf9P1e+BxIXmGEgqzKj/80DE3BUzQsQ0Y08MYNSgvT+IX/7BZqtZ7K
ee9zhyxG6m6JXBYTZ69t2Tod/KFv5f//3t/6cRzoUAYCjZ1EE5uWjJYuzv7CZp003barR1/tMZPqOFQBGbflrH2H9CX8JTkwuo//7lz//zQsTi
E5s+0HxCitRjbP6X0L+IS6u36A97f/lWtv/Zhsretm3bqWSqH44WrTHTPX/6T//8asrAAEkwMAkrhONgyfSzk0fhS/PDb9xuGOcgMHZ7tqJ3rx
v7W7a3HgTt0ROpWoLxhsv+1v/zQMTvGMNC0b5KzuwYjqkNinoqodlzyrEIBgzJDq/in/tP9P/7SowGvNRrmfqW/o2d443n/9Taf/4yCEKG9GuN
CUCGSo/tTdqJTnBTGUmnPxLR6q6lgxZ7upFMRwildF4zsqtWzUVH//NCxOcWW0LKNkrO7AqFs3t6SCa8/fBiTf/Hxp9/R/P+315YRgZ7fX1LP3
ztd3EwPfQ1/8qMyP/+EZ1HnX0liasjersccCd/miPXDxLHH38dVz82ABPTHs5Sa+NQvveaQdpw9Tz6CaH1//NAxOkYAz7BlGPVBJePr9fsr3vh
iQ2/iv+qIfyUbfPpxJQV//+3r/6A6en/1f//FWVMTyrBphmxlQJuzBiTNJrHZGpDR2pDWV4yBnYgK5Z1/XyBqremsyZbkpE1bWFdOHUdiHw5v/
D/80LE5Ba7Qr1US0740rX+/0fV6WAkJLzv1J/+UJe9G+vTUDwzajf+reVej/qS9P/vb9/rFTIqqDKTT/OO8T65CpMpC+7UxPntgiIwieDw96s3
vmNQAGt/5lNXsU/bcEl8ZctbvljXDpX/80DE5RSjQsAKY0to3Q7ez+ZdcatQk2TYcXc9fun/ccPftt//ELe///q/+w6W9Tf+mf/T1NFbVQYQLm
PRNUW6ZYkbMr2iFiPLDbf4CN3KjrlkJeJfBxfcO/2I1G+P5JvvK+mscSwrMf/zQsTtF6tCwZR6zyjRS9pAY5L2HdXEH7ZqFQwv+xH/yj++37/O
Cr/9X9W9S//QW+qf9M79j9KmiIRRKjFheMesNngJne8qpdSndPlMIXWVloehX1zGSu/v4lF5F1B+4XagPBC5rLRyxP/zQMTqF3tC2l5Kzviso8
v+KzVtU3zEbt0FYclP3Df9alPm0bfT9RS+n/Jn2aidT/Qj+HYRZKwNsJ9oAc0gvqSLtQPXqicYTxHPKvukEvqSQPDvV8A7q033chJanzVJQRlz
nPRrfEl0//NCxOcXm0bCNnlPSGsr71Ihq1DK4xGuv8gVFoqXvXp2z06NQrPP//7P3eUN0vl9B+Ky7XtP58og8ZBMhZjB6HpQdtF4nfjdPR2KWr
UGHiZs42lkDAtlct83IOcLEXcMrjp9CqUFA/QW//NAxOQU8iq0KnoPJFZKtwt9qeiIO7eNHf+X+mZvvbr/td70/+zbcJPf/6kfpFXOkRmevTiS
TgyNAJ1tRDK7VmXV2+Ezv6aux6fvDYfXjxE3eW2sSGfS+L1LePNEWb+2kAMOVxc+pyf/80LE6xjqtrwqehTkmKJvlKrqJZShVtVrC5bT2y//nN
/bp79K//+3okTeY1SDqfjD91SoHYLTCkrHACJt+w2aIEreCI8vbwgyytjYmjM2aZRVtyxCqpSTV4BdN5tnK5jX3WAfWvmsHWD/80DE4xQCksAy
wgp8oYm6EkVqvVANcofddWmFSGm1QqWz/5n/uW06P/7R9lbr//6Ym939Jb+1dUaSACHxLXHGBRN3f+zTXbeEd1BXIOqMpjTA+9zw1psMaKQBJc
onMIr3ObHXcWctpP/zQsTuGFq21Z56Dy7F6ft/7tqgFxqEUIMP9bd/Cz5fzkX/2/R/9uXbp//6Yz+hP//2//cRDwaSLukbjekjrGGRwuLoxR7/
KOBf+Nhyb4FAb2QyPznKHgDS017YlnVf3FaVyyL/ivgkkf/zQMToFtqStFTDznzHCybUVY2vQJ5CdPQDS7U9lQjro2i389P/tKWb///6edOKPm
z3/24+l//lVScCKkYnW+8eJhRAN7GFU6gYKysP9C38em3NMsE4p0WKS+agKU7D1ruLnbcrkdSp//NCxOcWw0K4VMrKnf5ZkWKgWkVDhGzce27e
Mx3Wvyd65anP9Pnf+yev2+3ppp8v//+d2+3ipqUhAw5PzqeZW1qaq9LF6L934K1HsrHjaksqIW42uitnSD2tfnq3HxBX5TlEjdfh4Wdz//NAxO
gXEz7xvkrPEs7dBbWreIhv36inp8pvX7f9fxBuz6/00etNQ96f/aXv9lqgGFtaFTiqScy3pcheGEgHcDEblPXOsXBOXhEPhGBA/xaZbv9UGyhu
Lhqij4BMfCY7Nxk6kLv38jf/80LE5hZjPs5cwlQ48h/+25OEgRBGn1lBApzifyIv7ff59DyCRk3In9vv9qPb1Extsz/kaHvp/5CqAIgBRNDchE
fRsDSzKrsaG/8+1JI9nzh3HfQuur+nfY3/jBO9//FK/xCpWbLZJwr/80DE6BXTRsD0w0qUzVHjvfqKS5Q93FBfecOGrt4WDH/cEvR9WYk/f2T5
xx6jwUF75op9z38vbU2jzvKBKb1Kv/oSVOv/jlURfIQEcCucCEwdu2y2lfDc3OlX0SVD448RV0GpKZYVgf/zQsTrGAs+zb55lFQHtU8nqCpBVR
rxoeea+1uhj+cnsevoY0VBntfqQi/6T9t9jyN+EM/b6TzmI3/zu59GOmr1P1q/nIp87xfhgPoZgkAuWKTkqfomemq38RWzu47EFkL8xBllNpn+
xP/zQMTmGks+vb7DzlzbH/qgTl/6Xa8uVBlAZK4k0xnj5eiv9vr+Ys4Zr/L/6X/f6f0bxnfpk/v6bMt35M6jXWBlYElgzxIjxMKAIQ7z0xXAHq
ogEsbC+EAtkEgxGFy1QEOlv6vuowJt//NCxNcXq0K8KnnK3BIVsW8R9QN/RfVW+DaDG/7v/6N+j/t+jPwf///+wN3RKL8/tG6dajXAm6ozHXxH
eArSGlv0kI3zVMEbdKI29Qc4OZBcCfcFsDwBYKx/D7FbMYXtrGxAyCRlY9t1//NAxNQTqkLOVMJKXAI/oL/Vvrjen5RD7+JJp0f6t33HPxD2l9
1bv/yjm7t9vz/ohVLGoA56knUIKDspUKAqV1oO03LC7+F35zVBeaEex35BDhlIhJ7VHUVA0+48xW+BCPyx4idBcmL/80LE4BQDBrzsekQ8/o/O
O9Bb2G+9qBNVn/Qv/Qg7+/19tSvxa1LJSr+r+/dBq0Ub32ltTl2gpuPqKAk6VEw6ENlG3LXe/ZOZmgjPSzqVeJHIOkxCEmMr16JII5wpehcmtv
CMvORXelf/80DE7BfzPsm+ekpdEst9vj769zBSn5hjX/9O56fU89ffU3q/u7c8+1UJyAWP1Aw7uOUr6yexdUnI7JbJW45RZeBzQOWKbpdF65Zy
S08lAqoO/sgUg8yYn+flC3ImtNYfT51gyHcXNP/zQsTnFxrKsMzCyrB5lAYLmY8zlPHW9TbVYdGf6D/T1/zftt/s9/lKt1///oX4iP9ft0lcJw
yqAUzRVaN/XrMNYBiwN6F27IycO/OlO1ZG8tSU0VGmRleu9+mEIGl87iPZwBy7Fz2gDv/zQMTmFlqSwPbCTjwcOHyPdAIZ6AI2lmm4MU2alQMX
v5v83+b32DUfpsw3Be31fomgry3nuU9nVQC4WGmZwYHvddB2N0s/jLqWYkR2y1QnUjaNMew0iJ7kg1w1NH7l5PQGJv/dXAht//NAxOcWipb2Xm
PO6oOC0WytdAMY6JBNLspy/wo+vt/l6uTVXY5udrzVVpBpf7ep/APu6/amxTqVCATkEg1h+GOATLACkhh+OeHbnDwyR/SA6yxak1TfRXmbkliM
PgmZWkv20iLtuXL/80LE5xcqmtp+YoVAT5IUf3Er/5r3m7CY/+uH1M/9ccDtM7KPFrdOSkUtgEcbsDgrK/9T+z39X5QAKixcEDX4WmIHHADfxq
RUaPsuhVSdzapHRCi+IURLAghgPz2GtAbiEfhmWMuIR2T/80DE5haiMrh0wsR8BpPIwb2IR15zkQ45MKhQak8PS3wqrXEOKrk6uN6kD0a2ds6u
WJyEqLZ7HtZ9O6cja76ImpMIcVC1TyckPIRb9O9f+tXT23kZOK4yEwjJx4UNH4xHSTKH///yj//zQsTmFwl6vR1PWAD//1JziARVKTkkkbkbjc
HUDAyehVQlyFUrCoxbjCQ0znpduZFQUDLpiav5sfbzPFVVz0jTNszyPG1tvNNmU1xPX9238Tf/zV7XP1213HMTZujzFpcOMdTDltyTNP/zQMTl
I8vSuAGYUAFJqLUQkSQolXIpFnoPODRdMGi7lXpPfbtbbZZRJSCMWEJTZ2C2tcwX8nidU9wMV1239lAbVO0Pc2MFROR8JtToY9Zl0uDuEo2uwU
KVVHmzdSVERKIO97dTP6ah//NCxLAaEjcGX8lAAnGqUzf/+3Mu3vUAyUSQJ6RwtofDcZsLMaVxtKqox0HB49/onjbYEY/PG+q2l6UBfXvY2pUm
DAdEPhEtL4QRKh9LI6gVclNRRysRK2O7JAk7EymoKX3sizm+1VgJ//NAxKMUIRsaXmIGzk8m1rt1juGByXDFTqeQPLHMQxSh3e+NO1ribPZkDs
i7dRivROubnLdmnf1bW+pVUV5wVK3YyUfSrTPE+ig/40Of/1PhrX6LNs0hvRUEaJJFSioIAzhUxG+O3zz/80LErRQ5HsWSwkYYaaaV480MQuRh
DsrjyyKv5cqH7cXeOQkTp0XKtVychidVtWgg0l2xoYHRdr70VVpoWkcUWvE27FO7Z0VLf7jb3VZRKj9aK2gOmzJK2LY9u3s5rJ06VaPOYQ+YmS
T/80DEuBMZ0uZeYko0ACab+NCO0fkOQJNbFX3tdsDQ6LRrv48oO7bdD+oIpeq4Nml77Ner2rV0bwfbp3ld36fi/1e+v9EIADZQbAlIiyJAUnCS
Pr2XMwJayJr8PdOrtUO79zQPUi/awv/zQsTGFFl2zbZ6CpTi/zw2qqUpQFTpsHlJtdwJ2Ja93SC+vBl07763/Z7evPSb4Jj/FvyPTs/eBBUVbo
5DVkipEywHGtqvuxW7AWFoUX5fpor5QFMjamg6CEUqqAfNX82E88fdAfeOl//zQMTQFDpiwCjCBJyW+6rcHNsg7k0RAgX0R6vZWzTs7HY9ColX
t69tPSoRNfO/V5yW/Hc29KTiKjKDM15ttrrKBCEeAI3QnlzHSkv290k7y1laGwnInDANZ57kY5qv2KNth5qtfVVb//NCxNoTeia9kHpEfCrRPH
7prWt7UL/mWhVqCK7VdNR8r/Ui0pb3V1l6Kf+yKZW5Pe//vR9/bwdXopPtJ5dNddqBFRwgTQhuAXdM231zw+lqaVc683fXnsIb+LrU6hPQkd+h
z2ZtVWxw//NAxOgXEirBFMJEnPJRyE/RnSzIUgqL3RXp/sdf9SHX8hNkQjlLJdJESlFO8m1nF1b5DOP01RE0M0B8h6TTQ7REWA8mjYO7eKpk54
rhyp9BQFDF1NMNAFOnPvLm9rjwFALOSf19twP/80LE5hbyytr+esScBLNU3sUZPWGAV66kt+JMjub2/UntX/K5vXzP7Y6v0yfK6B2zeyduDfMa
58KlEQjSx5YUi5OxCnrUVa997dfM45iKVcmprKkgqrtdluoKla51kkRyoqVZGsO19Vf/80DE5hYKmxJeewoa5qnENXBgbPNpYxn15EJ7tXzf8m
ZdNl6+d/rR10///qd/r/pp//Qo9dYMvvVquWxtwPNAdJh0encX1eQfCj4NLg1HBFtsetpSP7J+oBJr0kNjT1s/rsb1nvXiG//zQsToF3MmvMh5
xNnxV56HuB5d/1G5jp2KWUJC6OR+6u+yqOVHV90/qdmSunelf/1//7P/l2//eLN+KQAIEjWTlCrENHO1pUGl/O48Wj+oU0gixfn20pFKJ1n6D0
/yotmnN3fsvD6+Yv/zQMTmFfsqvHDDVJjvm456OVvERzrd/cXHHHtLCTEbcvqhehSHtjmE5IxrQm3VsRrczclidvfWECiiadbs+iKSEhRCj4R0
V33CKo46odSUfk1fP5zhqfbZr7jXTJSQCMX3uOUaU96q//NCxOkYOyrSXmLK9A1tAPA6+7j918MHtsYhcRV/ERNzxUkAWl7jntTaVrHkTADxBY
5HCnX+oCCIYtahoWbc1zFbB4QfX7s2iJ30mLVVAMUIDMMxQGjYj4CNNnbCIGs2L7TIea1GakxE//NAxOQV+XK+MsMWDF+8alMToHS+teNnfrFl
U70nUetqrUaE3gogRM2MY1rR3Uy5V1q2/jEbJGTi3ldRP/rdta194hXgywgXYpVo8WXO6fv01pfcqBS1F0tpEZ8y/dXEqAwsd13xeyf/80LE5x
waAsZcesbcr//BY4Ah1+LiihW++q99ixYii9ZB7FJRXyOINxdhvxgtGklS9dKvruJJAfoVPpxhmr9fX+a6ywWQ35xnfxZqPr6prFsKeuXH6z/9
f5Uq1mdIOr+ub4jY1qnmexP/80DE0iJ6irGSy9DcLeNMRJwzmksvupIiIy1WwPDShtUU3LUrKK58PHbUrd3529AbGKhaJRjI5NdWVptaorH/8G
ZFqOuxxSySMXU4lun6EQsn+xhmdYaj1VxkIe+J0lor3aOwSf+fpP/zQsSjH0NCyb56hcTgzVOaY0v/6u8eGO+yZzGvkRFAuazspid9Fd7rEAwj
JtW57VXtiozWOPore9FqO01Sv6Is9rfnzKr/8rXVAIrtL+g2kQWlBaHIPu/e3y0vFo9WWMhGtoCM9VUOIP/zQMSCGIs+8l56Tj4VkiMqPBe+r7
f+JvoO/dO2prCRu1b2KvukpgzDAXE5YMNApYWBh66qJTvP27bl9Nc10gHrNLA3OAuuBMZRfOKRvvbRfDW7PO7aqdAy2iS46vXLqpZH619O6a+i
//NCxHoUOdbJlHpKNA7dsiq6xnQ//g3ag1lZWZ3T6IVtexLlRc19CjPZioaPq3p+vo0VAGksnbWgwp4vZaKttZ7XY7WMEm2JkJszbMSdAALIuF
T0IIDU9mFrbBmI6tOhlvXy9fCSW8g6//NAxIUTmdLNvHsEXMk7tu+Uzld2qmejlEqwhLgntah5G7/7LmIVgNasTSyzCp4otDXIlbwjgudw3ly4
M3F3Vp2dLf51vrrGv8D77yNjsi8bo7gMgY4z1+tVRbu79UXn8XaRocZiNWn/80LEkRPRFtW0elA43rRe1BUs4ehRt4d/b79KBKcks0ejjcHgVA
uYusNZrhVmtZicsw5i5YqybYlFbu53fh+8iQt9xdwpWfQ/rD0BlEms99JaMn1WNsooY2Mis+bS58ehO1G6Fr1dV+7/80DEnRPp1sRSwkRcy6P1
bCEzW7fX7bXWgTZwJC0ekRLC8PlIF3KH4XOW1O9q24II/q/Nzf50ug65gyekp/Jp2guFtQ9yCjAsH3l73OQZFD92/WbomAs89MMU932d37GafU
oGx5ph4//zQsSoFHmK2l5hhFxvZrQOBJMSLRE7Enq9JPn9VYs121/VOhju0ea1zsvW+Wp22NseqNWZ2S3domMD5gg4QgLaUdNj76LK6STh5/Ej
knF9jGhbjjabP6XitQCTXdvraI2BRRk1jtzI8//zQMSyFBknEl5ixurjv6TtpQjeSZGpwEbZG/DhUTx6420jg1nioofvJyqiRaN3O2bT66P5hz
/YGbhIDSbzH/m/a2TFr/XT09ZBLcrcltkkkkGvamDg6Np21VHw0ct55O+LzGy7tzVu//NCxLwUWRrmfksEzBMUoRiI4hB1V1PiFtlvl3PR0H3R
X8/eYVYQZfQm0s9iT1RFNWVQnZvZbFDHbPOi2hNbrmklAILLlRQgmWQPtfSBxqamN1yfKpw+MMD6NuwaBEatjVHIrApQZ/Ms//NAxMYS8VbiXn
pGXG1V1SNARilmkuzzasyGBPy3fCFmHQUY0P/KbH52sjo1//G2UP+S/Z+xTtkct1tskYHVpMnGMVxop6iyIsdzZdY8e/+8FtfHU9RtkAJZ9Wm1
jjI+k7EGWJq9j8n/80LE1RShcwJeSsR+6nWCxCH1xdo8WVEXPyYPEIw5sxWKvIwobplkjr0p+ZF2oYn+xSo9HHbZJI2Bi0FXUYyAcHLE9Ca3s5
balvpQv0hrbTO/aOngj63KuX2A/7nKz9mUUewUtObMZkL/80DE3hPxUsm6egSYhTleSitcim+Kpc0+mp1vMy6ZxdjSsDM3FSRcLmChhH7hqByr
vpaLlKkB1f+lgqRjAKCQT8CY5NdLCGqMG44V5WewOyO7WFa8yrpVZ3FZ4cGaV5/lp3h2M9Aliv/zQsTpFaFy/l56UFZ31IxAHGMQJSRBjNrZ7s
ZBouWMqB6prR7BHR3W4PCZT9z2MPVhStAJyDMCvuF0QKxZAQ3kEqU05x+btqk8cAvPQ0TastzYtd47whUesyBe6DvGt8Wz+dt9QzXURf/zQMTu
F/Hy8l5hR2a1OBwwZz4wDbmIwm9lf6cRYkZa5OzxbWiwf8v7m1pGnWkSnRoOhy6NPFmLpJgNuSbr2WpQbcmY7mPFKpEWUWu3dyvqJYgYCoPASr
0ttocFWSfKUc8LD9u6RS/x//NCxOkZ4XbFknsKXOs1lI5U28gq7l6tl/69EG3XRnUYSzG/9Y0c5RAjMXpoCNdSnIDVM+R9tC9KjR66lprhKEOJ
9NOZ/NMRszSpLlkalQMIQJU0G4+gFc0aOFkl0Js5TBOsNChJpFGr//NAxN0YgdLNtHqLIH/OlE77qTmy9llAyZMudZ64t/3f/w84mxI68LnBwj
gAsRaKV6H2rfU5P1bSi+2u+xHRp+zstSmPPKSm1QrPMNFcuVZ1a96n2mzRvqd34yL+5avi+b4QfUfOWfT/80LE1hgRztZceMtAPH7YkkrJ/+Db
Qh5qaulp11bV3MDWPgIBlnvF6IoNKORMCFy5Pe3PfnkeNNohOCyE9KoGWSVu6RvwO8y1I5GVbiIPIfOucw575eA4zd73Efz5hF91EMpAEQ2Gzp
//80DE0RSBJsW4eZZM6XSeQh8P0yh6u42/mV7sZ6WzFqQ1cQrdVUCNMBBjpVOre22LLxS5jqLiFQKvFd4fWyRtjcUemi6zlEYsqs0hRGHVp8EP
vVL5uuWbxTbMS+3CjlAQDa3kTnNv8//zQsTaFQmWxRLCRFztCPUMPXUZCTV03Vowi0yoW6enpqdm6i0vdOHIlm3dWe9VZ1GclVC48WWoJbHuoU
/RNu5KzQtV6wfIlHb60iUy2Bamw7inSS0eBUUCCRLz/rZgx8HsQJrVIPnbhP/zQMThFRki9lxgWQLuoJfIcjYq2XJiEL88STVc8yVAT55+87qF
D9bxcglCQ8g2yxznzIJ9vo6QHKs0hJahr0f7PclHU6sCyQtySNpkIVwl8exartJ5Uh0qeGybeRLftPKH87o5Y1PW//NCxOcaAhrefnrFRDJuV8
wb85cw6lBlctuvmSjfUXzTlTUIZpCFkMs6Gz60NIrVk+5GqTS6mLBdKq+RfuuSnJoAgSZNTe1qlPsWSdtSzMpDz3PJL8J2a7uCTD63wrc6ksuo
cqKp6d0u//NAxNsXQSLSXHpWUB255Ns3W9VwXABMHBPes8A6VwxKpn6mwknelGtNz93ff7P6un72eioBpYuS+xplFkICxwJqs4bVNwahmeEdo9
fVvDODj/B6bshhlsQw+H3wrqCgcBcDa7ADjwr/80LE2RVpItJceZbMJrEj2jQBDHYbq22NhciBiDCmbbaTGRUYcXSTUCDln2HDSbDlV2YIIjT8
TgcYA0UtHHJuEX+/TCyJegJoh1eWfayR2DAQxW/ixusKxwbrnK0/nJ/NHl8WagRIhPr/80DE3xPQ+tr8eVKs7FAzHs3pOG9UKrnNXZnmObITRM
ji7hoob3MLaALf2PpQIaEaVsd223dc65QsUcqHmMVVI0Uu2RFg0kcUgaVxSGI9HjrV16lsuINdmDLL81yTgor3VyEPTP1aH//zQsTqGyF23lxh
krCx8ju64OHdchnFrhVVq9HWqPpSjIxxESHiholUb0JFdVlFCSV2lyfUAYBCT2sqWqUZlb4N7L33a1dvYNUefQ/ijBT1sMORBoq5z1AVEA1+ae
rYmk5FE+Hg11aoSP/zQMTZFakK/x4rDBjn4yk2Uy+Y6wCag1cSiMdF0w25JZ1poiVQwijPOToijVHxZyWRPUKsU+xVBIhn908lj7DJlF6FpUDK
cTjcey3DPie4kdNEyA6amRFbLD597FTB4KEPCLLloSZs//NCxN0TeXLmfGDLCKWdWYQj2SOwHNqc8pUwHXgUleh88L0eixL7l6uKLopS3HPLMX
DVbDBVC1mkc9dbpiIsBLAIDB6UiYfK5TWOAoWmaa27O4mvk8/TG270o/egVlA0dxlUYMn+nD99//NAxOsXqW7KyMIGjOvRB2MhpcYOLPy80JyB
gaOMWKSCA8CUg+9BSsPxO/IIFKuOLq7lfq18voWqArzlCVKZk0iBY6GpWWiWeocErx8Ogj/RUSAu8YN4Ua8ZCDfb4uv5JpLHDYtbZX7/80DE5x
YxKuL8ekaM9YtwCmNdVItPwt+0s6TW0MouMacQg83TCl66iSp9Ct9rT9+EdxnqSRrq6lW3PFICZ6WREkbRKSK8of0ukWzR3U9IQUX7wikLgsF3
FL5zg6ieaphiGqPQJQYtOv/zQsTpF4lS5lxhkKQqn3rhygFRzDy5iuvm8UaohabuJZZGCdgkHqGuFFH6XNkf9amhBbt+FCFukU1P/XUC6ynNEj
aVtsw5IballOuKs2plKt0Nryty0fr0ZSCnV7lsEY1siLKpahgnBv/zQMTmF3F23nJiRrAxFlH1R1TwLOtbGIuzQwlnh7WyPSuE45kv/zme/V3V
WynTZ2/61QftP9rdE+Yl2Lu9TK0cEsmQrvdKJwP9tdeHqo1Bk8YT6yQRfi9Uzk1eoyXyqQt8tSh7YlZB//NCxOMW2XLefHsQOHIMBjhSC1qBp8
VutAe4OUUny4HauGx4oHxhAe950Ql1Qyoskf3RlxTpo0Rr377VlY1/MNVPS6WayNv4HDwGnh3wigcUdeZxtMgFc7LgObGn3u+LSvlG2GJiSRCM
//NAxOMUUTbeennE8NtRF9uM/8Zd8gih9Yhh8ZtUCbwQOb6smCCROo4MVHBjiAIiRXIaA8s/fZ//Wk5dppLZG/8tIV0GmJcq65lKWx4BW0/oUe
0e/dlH3ciYLDbGsiMwx0NarWlUVKn/80LE7BohOtpcexY4xGptS3Et1bOf352TXK0v/8lD4oGtN4pOmnpGJErqA4HHoe14RDTjdelzpBekWyC4
11emJLT/LLoFV6hZhVvsssY+mCJzmVfbrQB14NP/0V9JDBlBrSRAfa1j6sn/80DE3xUpEwZcYkxSHVfccWnK/VRqA6WTOIiGPsd01KKX003d1s
sdirFFe0xD3emEyde0Aiz4sN30Tv9dHQwrsJSUrHjC+cD2iuUn3Do2T8TVMwHn1lR8B1ymsoUw0EYtyBenne/Kpv/zQsTlGWFLClxg2OaNACz3
3H0vsXu9XUr5fU9sQXEdiHlileinftV5G9MW6Vr/X3barREnbvJ9TIZWBDTTUkFwxrM8dJUsrZoMVKD/x0iFbKOtBdZnzXbPC47visf/lbVXO5
VK8Bp5Yf/zQMTbFYGe+x5KBQxiQDeInipIMrHmjqH3IBsAWMOgTcNHKC5sXotCpo0HD4GnyBABzDPdahgvYWd1VRJXLO5IW6AYWBNh4cLzu9Zc
gco920bLF9vdOfuImx5O1f8tcOSIjikTp7km//NCxOATwZ7VsHoEnGpOINzyWv8hAAEFPaBrnKMUhUeHxonfLvJ0hgTvKMi79YHwxahoPgNNzW
FTrpU+MFcGpWOB4jyJ9WLXjzazZ+W33QKhufLzIrHUC58o2wn9eks3RuKrWA9mwax4//NAxO0ZCP7WVHrSxOhEjscLyLY8wPYy752qTMuykowX
EiP1Po29I7mRZ0W3R9jnBUCuuXSoJKVC62uapDC93u742gY3I6novwQLSmQavXqW8RfcaiKsIaIFLdg4DLzaMEWirYyNxY3/80LE4xS5OuZcYM
UMROz1NA0ca424dnPKX23pUNR06KydbpVVvEs8g5d616FvhpSWw4LUTJixjmt14yoCF+LpaLIDsE3kUhHCP9+lfSOGsWV2/gHNMwmshO5kdWWq
VlBHMJOiAjp0eTf/80DE7BqiDuZ0YkcIf01E/7bevd3ZB3oqad9fZ3eopjhZiHpZGSzXdCv/0QKpZ7G9MoZ0IQ+Sa0bqGs+aTQc5con10VlU2e
l6RnMNuQjcViCjTF3MXC5tjv+84b8Q1jdd7fWi9/H9vf/zQsTcFNGm3lB6BJi/h0rIcJY5/3FKVUlhhANrD6CZ6bGh4ohCyz0PvskhZCoDcARZ
a2yH7z1Cc8ke9ft0tmDHAtcLuHyKFORt+fUY/xQAAk6FQLJpueD6YZd7GtSEazhMoVCxw/SgTv/zQMTkEvoK3lRqRDgfYkUnBODAxNBRBcT3Yv
LiSoQODwZ6HjhUUwxCCsfC6/LnKmdmg3FhZh51Sr2jtkskjTEpwnZ2vMxjBAX+20KohCt/1TEEgQHtV+2lWWozv2XUf+LtPfm1LxY8//NCxPMZ
qaLWVHmG9GasW3MHilLZ0hEV1u2Ex+P1+HSGvODA/Vt8uXgqfFIRm3JcNI2CMQhVV3pFaaIbWLEbWtqlGoMn29Yxrq0OTjOictSVzrcwJkQ8ZD
mXT76//nTJAw7UAgSB3WWg//NAxOgW6NL+XkmK5MNDld8RGsTOoP644P7lwI3F6KJ8i3/dy0NqQx+Qaagxo33GxI62g5XIerCaaPKhg6700uja
gjui+q/uN6P0Bv6ovKX23QHvvs+nRu4J71vf7h1FpNi/VYZJqyv/80LE5yF6Ow5ewxEqYe3mYruA8IDJxFAW0jzh+PYYHjcnyalr0eA/Dudlq8
1eyLtQ5VRSBjKXRtVp6SpKuxhZ67N6+fd77lBjvyVaz17Od3Cq1uK1MzzPrUYZqSJtVEYRoVhANNJLZtv/80DEvRcqhuo0Y8UEWYUKRXH9AR+R
L/G6XJCpUSCIkTEp0It3rCd16eIE4u9gm2QS7FcIrMeWzs7dAsqPXTFK1iD+v1rm09UUzCyPulkYYWayISbtqUqVqQ/o2/uvh+pIWdO29Zbbbf
/zQsS7FjIq2AB7BHi20LwSta1HXyeIwEJ1RsEdMRLzpchEMYWgbhrfNl4O+Y/KBxlLOOYyxcqMsWRWqy5wmpnsiOuOXVR6086vV2RPs/WP3Z+3
OPGDLFvoyE5lhfH1aS6SXsSqkiikcv/zQMS+FvH/Bv56RDxJa5IBo8EJs+Li5ol5pPPEym1L8dN1FY+bFhclw2FxZys+FqpmYsb5AN9YtInPPI
gpoGTu8DQW9JQYiESmlBEqj5HfacTxR9fxDeQ3VvinV64jCZoqCTm6JEQt//NCxL0XSdMqXnsKPqqCkehQ4h1T1DJbZU8QSL/UWb001UDtq3Zo
Ph0ILM13DCxA2bdFJpqFHO5hz9CsckijU60dgfxdf8E9JBkTg47We2DrqnJCLozBSsmtp3Fjtnj6YI62KMfxyxVi//NAxLsVMVsaXmLG6mR5yw
8iDfFGxTWfA+QgqO4u0Qq/5iMBkpwi9L+OXnQ9gNHGxFGo570xY6LnqprKz1G3dWuWT6f+C+ajLNXt2509rnTp5QbXc7W8vuKJru2Eqglk1Q9K
b7xdX4L/80LEwRch/uD0YgUktvgo55Tlw21D9gTzWOGqrP6vXJM/XKzJSBlZ0BaqiHCntpchyXKd7eqe3rqT+FTr2gudjgla6FNa3qdIGrV2+r
6/spRVIgRqGk4aTtBAVgaGuhAuxDyygpWaonH/80DEwBZSiu2cSYUks8pLWKzatwCdYyKKxWG6JCCNox0ZTGlkEjuXMQrO9WbGo1ehG+btboCb
YhD0DKwtopW+jJo9vrVTo+QVKhmFRX5E9T0ywlyezJE2Nqhc8s6BMzFm3Dy6AVjdpv/zQsTBE4nS4LJgxSxpai1AO0jsL7093dK1eejKyqFCqP
XKgiWpdW9vZBz9St2k0flRvRfsvbWr+/WPr/c+/akcSJND8tv2+18HNqI0QDCwqFM5I7RQxNpDIkNBkdCYn6eKoPpf87RILv/zQMTOFJHS5PRJ
RQi3tAUj7dKHIyUZFsEHvZtJlVnglp3dWte8n/RBmquLqfqRt3bt/goyRX3j3XeqGAUppaoksJrmAIrnQ6vokQp5q2aQdFEQYuyiEb7dgmZeXS
0rHN8v6At1/l2G//NCxNYUurbs/EmKqFX0I781VwSjUQf/NS/X7fGVJAcmgi/Ghqllj4s5oo9icrs+57jteOfFalSY43I47ZBRPZAaGwLnk6Qr
sNAeqHi1YuTaPPsq4PNUpr1KjYrN082Lztw7NNZTqRWD//NAxN8VcdcK/koE0M5aVyLVWqoaepF0Oqo9Yt+/GjnsUOOhUidOxcp5rptR2boxNh
jm+OZXUvS1afSmCE7SFpdNjJxkkF1kGkZOYWHC9l7Vo0qFDehaWhul+0sUiHsboijgifSJvff/80LE5BWR/uWUYYTs7iF+T1RWxo+mrq7O1qwT
tZVlGsyo4/JY23TRfbV0RdqNbGIrtP0fUijtST6aV5aSU46UUmNS1/GfJ3H6hvh4vYDXm7Vizp3rLM23Z2f/JX9+lUm9nZAzCzRMKYH/80DE6R
gyivW+MsrQqhKWZqYLXlM5Um2VANFSh2vClzHGkVmAbMyPXVXfWlmS61bwWb/H2o1W+kv//g0NTU5I23JJJI5BK7IG2zFyKamjKml06aGnMjX0
HPOwy1nRjvC1bMQZyPymbv/zQsTjFiKK3KpiCujRlD08VTMJmZfXyPq1MqONtWlmUaKJdleq9mVQkMu7j+cbsriyI8oMiV9Ro2bVo0ZD1nI9zV
5ZFunaIkLPpJo8MoKHApapyvSszZsMKQIC4TdZcfemcraMSIfcvP/zQMTmF+s+2ApgRWQvdj7sKOqVgs7MNQTyi0/EDT/RaqRcMdbo8zVdpYFS
iq68a6ny0THLfqbtRfunXCvRov0O3esy1dUTqsRI3O4uWLuh+iiiejSYmxvvtjTZ5+7C3jGTQBzrvFWG//NCxOEY+isOXmGLRv6SZ+V445WbLo
e3KWPTlKqFmSz6qprJjeRNLVaYU6696u/NTY6l0bpfb2yJUyjdDtXN9vT/5799/qVhmTylDAWahZCZtdNK0s6ftRLvKQvSuM0DWy2j7e7V3Ljx
//NAxNkWif7Y0mDLRLimZGXKZpYdqej29fRzN2MjItyQZ1X5Y1nUI1c/Oz1Wo1kb9R6lr8n/W/v8/q1tf/QXT6f5LdP/BOctLiaajabkjkHPoS
YXRYCjIMAotxxh7DwO7zQpGgU4iwT/80LE2RfjQtg0YkTw8GOkJfaSI8vtXsROxOzenW9kKCodr/amqSW0odh2KaGZFRQNTtTeyPt/J9vX/dlF
CzW9n/ASEIJlV/ngueci/Nlv5P3E+dCoTMeeBfHEs4zR3KHgOQ3THtvJIbT/80DE1RYzPtVKYYUouLK7SMRxjxU1V3QTmFRig21VJWoO7LItEc
3VBO+y0SOnWnJ/zBP9KBftRiBRzrb8ZatXT/I1GAhVuCYk3KqAdRw9mYYc60uoRU6lcrGt976+zvtW8QaUrW676//zQsTXFWq3Dl4yBQbWubQv
mg7/swQ2V3XmVoOiiTM5uWRWMOv/X4//o/prl/8F9rcV66aD//+3/tbtpW+gYfWqYhFZCghaWroGP5hzyfYpUokbMKnC0L1bDuevT13gaWRxuy
T6zNIXm//zQMTdFtq64jRiBPBYSfaBmTj1qAsRmcM3R7aj6TfTvEN/wT21+Kt/o39sZayQAQR8prCdeW0/J3q4o3JJbJaxJilOySgMwJ/ueQl+
vyj9hoyE9HXZ7JzveAbTbV5FnRUYQajkKFdF//NCxNwWC0bdlGGFRBCuiMegTZ3dg6uqoZBNFHWriNEnZFWHS/6gvko8g3/Sz9H6H9WV8M76Uo
iC0R5P68az9apizNGbY/XYmiyzx+y6jO0MyW7dDDU3VXtfey0LwfXXRUgferRQ55tM//NAxN8U+lrY9GJE6FzhUctb7anPTjZNkZzg3Mq/1oiq
BJ00oGtA6npF/Jb0IOV4p6hNmlefO9euIlixqKRX2kgxmqbqCGkot4ZSL1srxZoNxgXozuOs+GLb7+Yb2x2pcVwX2xZvy+n/80LE5hiK/xJeYU
VG7Su2yK0CnLxm+6aDUW8zVWTKqiv38Yz7ih2ewotq+om1crP18a9JbRoyXznR1uoqJACZqPCtCacXsxw7h+2d60wPr+8diaNz/J3LbRvyPD2b
qq+VjE56ryBK3LX/80DE3xTxztCqYYUk1fzu94NrWZLGUQl5W3p6G+/28dZ8+39b7Bvme8GnkVaMx8+i5HUdEjY5qKpOWDihQdOiE6ySP0SJil
9KGyFpQYFYTJjKc6JmXiAVUbycmPIJc8eYsGbDps7PUf/zQsTmF5JuzKp7Cuz3tiQ9OKuxkYeMMLqwYvVqa36+r9VHdhF2ewz7c1+w2/bsNI3p
6+n0Z1/slXpTq3jEKiIiSVVsbqDA+hlwSRqHXIFMuHKV0YyEk/jFe8vk9x306q2ST47CYlajHP/zQMTjFMJu1WxhRUDb228VMdHhKzWIh7BICk
O9z7OUyZTbVb1XxLfLvT9v/f1+hf2RIvrTsoLS3xUIneZqZiIiTZgiRRQxtzie1TpAjw0SFQmtdr4ZTaTTDEGbpJ9w6EkJ2nhSUf9P//NCxOsZ
Q0LiPkrK0H9tHcUKmf2E0dox12UfXTRWDFfUvY5k5WvYWT3/9P/KvoT/3//97f/4xQ8AJfBiAX02TkXMZwcWa9mOyZko/Ia9h7dzGu9lwSFbHo
pQAUeQ09BlUqNw45lcLkC5//NAxOIWArrqXjJKtLUbKlUaaioLU5j+PI9RMTqc6l6/U8wNzzq+4rZ2yW6y1tfu3nfbberSjf9U9NP7Nr/TWa5c
29fF0AbsVZEoUqkba2T1jOox3WGOzk2PjnY0myG4SwkheGQkXh//80LE5RYDQtmUSsskQJSfIBaC3GBqOEZJLhzkzAyJVNFi0+UlD0Ky4Znqii
55iIZkxZiiZnszrWvWy0XVQROVKaXPeo6Xz8mrZTLHAqtCyaK9lttrfQQtUnTTP2PnqtCttvtqUpJ+99T/80DE6Ro7RsoNTzgB+dRMn9K6/db/
//Upn///nXUAwgJgSc+Il6m3lGOzxGWYHjN3bUSdjztzTo21B7l8yYyl1IXnm6BWORErNlBiClKakEx+ZJakS35+qmVHn53ZSzJTaz/rf3s6zv
/zQMTbJCPS1ZWPaAAO9BXauZF02bnK3qMH6Tcxo+rbbzE+1looqVrq/1vrV+qvtXqqrMCfahkAIUErtjzXB9vVxNd348HaZu3rkvTq+1S2CtV+
NyP4bArmuc84cKltICI1wmFiG0yK//NCxKUcqzrKM89oAM4TXSCETQe6UCgQEniG6MBXPUTDXvV6ra1YE/t0DEbnVeD/8Lfr/9+oX//0ev+W//
9wt1yKMzAMRR4PmbEZ5PLP2yzy8RfOBui9RGwIkvW2ijK1bwJFUzVVQ7zC//NAxI4Zo0LNsnlFTFIWfLcyPrXwT4fzES7RUCzrvdkgy2QLQt5h
dCJeuoj9uqCr8lXVhL/oosz6bZPv6u6fqo/zd9vNb99tUGiq1Zda7LbdtJLR5PgVahpsSUeL9DKuYpX7ZLAN2c//80LEghlbQsg0esrxel625A
PbpXR/3CZYS1P8i+ZXQVHLqNVuAMQsdyk3wwrqg0ca8owYg42z1HK8r8T/+s/4k26t39YxIQf0IKFzY2Ubl9eL3F+zBcEeKPEi6K59JiJJS2sz
mBSk3vD/80DEeBUxdxpeYkrytZiSO6av6qferY7+y5NYQDh+m2LXqNDC9S1Ls2QR/+KtyV2Fvmfs3yp/0bP/6g0qDIlqLRisChLNBh6n/NohvI
MjOSxgbr1uvlgNibnSulDN20SCw4dKWRvVuv/zQsR+FIn+yOhjytAcMFudWfY7koGf1SvqBl/9v/b/0f6Wy0zj+4cBgNP1Zb6kUfZVKQWmWstJ
Y7po6eNdnRhCWqYoK1nEg6v0Zo882GUfEV9Qcj3rjcyadZXPEGL+LcQAxWW06qHC+f/zQMSHE8qK3Z4yCpjcYGdVej09gz4n0Ll/Uc++h8RP8R
7ft/iyDAqesAMq0bD6puHsP0N/ylbAzZnRBaxM8SCmqwBUOuUPMzxeHH7CnTOPY2YljCwqBhdJ48zJUaXqUb26/oJfrF97//NCxJIT6abZnFoL
gGc8RfRpqZ9///QRCACnDwaaTpzc056HkiRqQeDK20gCAFc6mtE7qdxMnM2qIWo0D+UUmsXHptNa9TeP7WK43G51bCq2o1Wl+T/wt/avX/oHm+
+rEXyWz7v5Gmqm//NAxJ4TQaLNcEvOiGJtyav/OORpySU3fp0Wh6eVqJ8GA/TLq/g53qd2A0WGrcRmtkt7m9QuJA6chgPC8TIoiFTGiYNoq2LW
OmP6/+ad53zv/Ui/qyOS+7+n/J2iFAoGCxvSp+uUdnT/80LErBOiLs1wS0rUSS5frKcXOTVEHYUkckYu9YFynJUtRzSETb4lvTN2zvLDVKyL5V
W3FLryei0+Z/8f+bXm/9TSnm/X0f5T7NKq9zv1mEKUIWzb8m8sgzpC0Eba03DL5Yw5B1ioG7r/80DEuRQqMwJcSo7CaFx8CWZqOuPTvPtsB4Xc
002r4i5vgPZOu4eY8XFkAiysijIqtk4SfP7qmVafp2bN+c8vkfv/rQqBkiv39SUhAVUieQn41b3cRQ8AjvqFhLK1ElCELcE7p75uof/zQsTDE8
KOzPRjVMD5MIep2DdXPmrXXsId+hiiIAzQ/W4XKthclT6nMf8z/3I7d3l3+jI5r7///AOvbD25X+tyYNpnoE6RW6kZRL2AFqZgbQz5a84GfQNI
B/FOfCCGUWc3ujxYZ35qL//zQMTQFBle3lwx1sBvToZklnZOUlqAAgx4m1Oq8ekbuFtTGP5PQR/6Dn822f18TM3//TxMhf/+v/2/2/FxQUoVDQ
gjEVIsw3ik2TyG9jrWI1KGer4Lc4H1FOGItat35cXKPHlbBZfH//NCxNoT+dLaPErPDIcJc/WcdC1vxLaCMJaI3VlMuLbqs78Aud9UCHeec8BU
pOcdGPR6Z9OE3RPQl9atjT/ikz/5no3HQ991VvSn8qHFIpAoeVuRKpDTSaYkOgLJRvWkhj8uJl9UPTuC//NAxOYYk0LiXmLLLIFM/si9jWr3BV
MbhJ0S4Z+cCmlPum3gkzhhvpo5M0+Gu8DGpSckPRZcaEzEiKBM7cc8q/mfHP/GDem2V+3Qlf/zfKehI3to6OvIi27X9pnev84idQqKGlXCRk7/
80LE3hnigr24es9kydLAiq/byAZ06e7aeChtIuQSWt4ur9xKW3tG1k+9KnW6xTdF9m8BrClcaSWiG/v0zBjbp5C6EeqqcPNfByraFvU70+T/9x
9+f877dCRJv+/p9Sf/T66aHN3+3/X/80DE0hujQs5eS9S4QeZjMrGX9+tywMdWZwN1mjWm0mt7B9IK3oClf5sY1deOeWTB845VofhIaP0gRL7p
Yif+Iwkal1e2EyNghPoXT+n/qGfk2y/9VCt/29PqHb/j+z/t0v//xSpuFP/zQsS+GUNGybxLzpyjcktZbx9GA/gkEQw3+1UkOmB/akWqi4hnoW
Wo3fwDjakzo6lS6IJ8Q+B+Wer5Fn9562tNuUvhI8TRMv2F5gRpn9LdKj/f63+n5X76tZLxbZ9rv4iqhwIhKMfYIv/zQMS1FatG4l5ZxWQegEw8
BjcW8c9RdC9FLY/OsHTSY6zjG6n8TPWtS0FMsKxU3WwhVqSuSVbJPvAQBY8oPEiFRwugFjWSUJ/3ai+Q/8dJe32/6GG/+3o3QaEm/7ev////Qd
HVRhI8//NCxLkVkV7uXFvTYpQhnczuZhSz3Ji0EgxFVsqZv2tGUiQYJyE21aJI3U1X5Nz41nH18bL9N65imB/nOmGmP5JsU9RDlBtUi9a5Ef7w
stX8N9dU/i//UWf32z/9A6b//p4wBf0f/1El//NAxL4Xmz7OXGNO0esUIAzpkCD+IA1GohOHzp//tYs/0QL67MriAQNX60/GwXxN27+4Ct8lEl
pPMrbJ0dXN2pVVciU1YlCkXs6H+GTyv/s8SPoynqT/VlH/2f/xOoOEMC014CowWOr/80LEuheigsoYewuCNCHEijIV/VpbOcXPWOu4oayA1nql
VwnKhjHF2k7CFCO9hAvTJfTWgOIxU0fiDdkNQLwmLNF420mPRn35v/n/fbX/yb/6+jee//l/Vuav2vp/8gWujP2ozXl86cH/80DEtxQpXtJaY9
aIXMri3xKyv/egmwkNHv/KVRr0AuXtcpILdEVAa17js02n//HEmPmCGlwMj4NK4IXUj/v/8nl+b/qMAv/3/9Cf9U///bv/1ABI9FU/La8yYQKw
6qJlzu/zXTQPof/zQsTBF0NC0l5L1KSxVTMkxSGm/b1b+AJtrZnr5NiR9MDcy0ZztU65oQgo5qExxnJUERxlpUt6pV/7f+UVud83f+UKF+v29C
3UwICR/o//9SVICSAMw4j8aGbix1fHvCCpszRCFtk1Nv/zQMTAFItG6ZxLRSpW1bLrO4BPRWa7iIJKcRXpv/7BKMKXGg+zjrGBGODLVBD7TFpf
//KFm5WnJf9C4RPqnz/Qh6iUMnUf//1ElapUSqL7lIDlCKUfTy+Ea6ywWX32kZoKbsbFxnVx//NCxMgVco7M/krO0Cp6vWgsWQyKkzgVht1lDZ
M7XwmRRGUkTB5mRPcYI8gEwJIYM0lAz96Jf5v/QVCS3Snb/yp7+jEr///+DyrAGqxlykWwyeKk/a5xJw9KYf9ehUA3BSnHWcst42r6//NAxM4V
Eo7FnGLOUNVaCgi4nLnZ4W5ZXSPut66nrF1JxGQUeHRqAO4seFAtCUSfL8f9+gdFvPTn/40Nb//26jzren//wyHqGsz1uQ1o/KhAug12vUgQjn
Jm1J43Cpn5cuccxyQbx73/80LE1BZKKsj4Y07aH54FG+IaGN8PudqzXWAgsbnDd5lQiRZwHKjmTtVZvkPU/Yyc8Ju/tqAvr1OZ/Vy9aUagdkma
UiEojTLMV86pIxZ2NHUoMHyA4e/7Kvr+OTDV4NYNNeHBFcQUW2v/80DE1hZihrxYY0rUB2b+Nat/jH9PvkyQHpPpSW3Dj7L7aeSMf0/+f/2P/6
/9Gf/29W7hIdf0bVez+AWCzLWYhXF0fC2L/gbYsAL7hiRYWeVBb97La3cI8QpdV/iMft/RDrWnVFP/hP/zQsTXE+mi3Zwyzn7FSOaJLMVwCY2g
/7f+n/u/pTiX/ceHm/7+rdWO3/+z/+t//7lEXcJZ6DPdIY6oTR6jpj8SGuzS4FL6clHp3gibeekmM/5ObdpYOM+SnV6GWx7l1j4pe7N///T/Kv
/zQMTjFrKO7l5LyxJSn1pubTvthl+x++ePUNfe6U+Nf/HWfn05H/qRUt/09W6ExWW//01/3t//uWMViuKwGpbxDXLVShe3nj6pvWkM6TlMWjT9
ovYv8Am/8W21RqrA/cpQDBe5riF///NCxOMUc0bZnDLK0vEgVD6HG5zuLR6YvFO9zqvT53/1ft9//MHrf6L6t6lhxvTt+7+oeo3JLbdttJLBbA
zKcS3yzDFo50XAp0YWBAbgCjzZ25bViut/LZ710xOAOcJQ+ruiH63fNlUl//NAxO0Y00a4WmPO2IxI+1ReEJiMxyTZ4cV4XJTnsyDh9VP6/9Sp
j96ct/0FAp//6/Qcb/Ulnfn3/iYBVdWO4jrKsPmNkc7SQprfUeRTW+XC01WwSCfS9RkeWrb4gP+P/Edui7BBXpD/80LE5BTqjsBcW9Uge0aW7+
OOM6M4o7BfZ8btIa11+FjvfMTR+n/UYK7t/of/bWAvu//5URKDFCYjHkKBm1Ca4suJ3CR3N2wvK2rmNVBrGJm2jEnKmdQc/MqVqbDAjcibY1fP
6SrrsoT/80DE7BkKtvpeS88KELxmZGo7SUQWTUYoDtNjCVBCrTUlXZE6BL83dS1+dvmf+cd//1804v93//LAnaAIIKqJSWCGMViHJtDPqJryoe
ay8scAnwLlbH06lVhbFrJFkn6w+JeSbdzStv/zQsTiFOnS1Zx6yxJd0eFTLt1zDhYvObELYaeXOagZ981a/Gf+olEMrr9Zr+vY////jZQMKt8F
+s3aWcs179v8ZzKY7+bQrOqObXmUF7h6zdk8gh8Odu1UnATAzbasLL8y4nzCtOi7cv/zQMTqGCqKuPh7TvZgAh6MnynS2UxAeCKoflQjVPtjUZ
Db+I/8o3m3zf+MJf+vNs9Oz/+DYcXUjKUqwYvoA3ItykhRuz78IyilDgoama0GkH2qSaBlQnQrFrRa9alCCkpXUJ8g9GYO//NCxOQUwdbBmGvP
grNuvUCUC9n5NiICGsbKEhwBZBhGpEI77uK7Ujt8s+vR8G3/8SBny3//icXV4AhQDUGABmuMtKvp4HffThKmdeCWloLFDCWi91nQFEFloEnOTZ
c0L12xXauf/0Hw//NAxO0X4i65mMLE+IInaPx6yj9nEhhxoMDeUbLxiexe3O/8jKeU3yb/oeIod7bpNXlS/U0Xh+ebo2//yoZVcBhhLwj4/wal
koEH4V+H+c2xgEdbXaFkKWkcI76AHOptrLMAfE7xNeT/80LE6BcRhsGaY1bWDnmbfqRgWig4uPBgXQeGQnuOHRkFucns1fr/0YvvXfb/4yf/v6
v5ozOX6Zvp/9/tv/IBeWUqyygnsCnudrTD1fTV9xZEdTwjXrdsqUCa8lT6NtrwOs5Z3UzgKif/80DE5xhSjrGeeNTg9AJNTXP28BB5w4PnmKg+
PHgopbcPm/RKfM/6Csbem+f/1cxv+3q/Q81v//////1MIdQIYTjDh6AZPtLX1/2qTzpk2RVOCMNH1CnN+A+vZbf+RQIbjw/rb/ZylP/zQsTgF4
tGsZxiVDDtivAOEz0rqXUyGkCqWtzEapn4vtu6b6/+Rv//9Ct//187Fb/v/////goSGAxiPwEv1wg3Dc21RqrLI2T9cmJZ6yRTnCw3LqLbXr8n
DrE+q/+lwtSx56xjpc6U9f/zQMTdFbtCrPp6zuhj5W/+lQVXYdaXmTZPskUisjTYipc/DdH3xXDf9AF/b6/8N//9fCqId57f9P6wrVGUICinWX
GygxBJgqIdVKEqy8cLyqiCOZZ4S0MYta7roPWN3T9SQn42ujUJ//NCxOEVKzq5mkrE37dUwQopaSSagIIUmbnjS//MKuAFYLLEKjGdS5j0ryP/
lCHq9Yf/3xR3o//8GrhMYRiDIOdBIjhGc9f9Dcuyy0sF+SSBBwgo2a2MVDMqBzNIfsE3aaEsaz2cja+3//NAxOgX6oqhmnrFaEBaFDjwaE5VWI
0MApDIaq5CKKJ52ny//qWbtXkv/NHowb9t16l+5CLyx/6/p/rMqnqMOF6x4T0jd8Qxgaoez++oUjVv2WnF9VIi6zaz5iL9QD7Nzn3w06aj7XD/
80LE4xZBzrJaaw+C69sn/hYu8jCBkR2AowvDPlqlfk/8Ydv+//SVv/+/VxId//d/Kko4RBQJ4KfSTBWnC2QI5s4udrYnp8JlPamjIcH66mxtXP
tRtahlyh3Pxruz2k8V90Cck5DBftv/80DE5heKkqGcfFRSq2CyLBucix+aw2MpFwa/eQntVuQ/9T3a0lry2/7lAZLf929+poVl/5/pp/7d/+cV
GRDVKAxlqwER7D6T5KcY+jSS+dUI7FlhQWxLjUrRajjT2s6qeBIOs+INvP/zQsTiFDKOplx6yuiLf9BBEZDqymkSGGIsYX+iulen/kGt3+//mD
///v5BIev+/////+ijTDiKVBFsHs3lUMjtYR/Bk4ZvpEuoxUiPiQpIlNnqrHu9JPrU4RBta4teiOV3/URxeea5xv/zQMTtGgtGgbJ7VSDc9WFw
4zwUF6UzUEYTOpv//G5fzfmf+Li7/9fvxwsNy6f1b//zb/t+OEyC1SIeU7JL0SHpr6LKaLkjC8wGfu9ii7mr5aN0L3r8nB/nFs+WFGGMNWNeIr
XInYa1//NAxN8UO0aNnEqK8DTbQIQKxY1WFtmLVEIFEYQSgp/qfX5n9chVud9f+rJ//79yI//29P/nW//k6ypCE6ghfQNqUfROcuLWlNaYbU1R
MI6RVzGTv1DN1qS9zgbk1rUR2rYeqjspzmL/80LE6ReLRom8S07MoACFlpxzmoXeNxd47/NWn1/6DMn9a87/oY3//R+Qyf/+j+gEagk9ktXN5x
v7nIfIHlx3edMeLNglxvtWPZ1BFdYyi7NbWajMjF8kD/YnnSPvddIxDumCZrbKphT/80DE5hcLOnj6W9Sxc9ioaVOseKK5vjb/nCoPetK83/nE
iv//R+hI776/p0+XCFUnuYTE7XOqHtBdEBel2xd6KTu0RiARMHOLRsgRyKSaVQz+tSk3mJ0L9CfkUsgXVNa1bKfIKKXbR//zQsTkFFKKbFpclM
zd5xjtGp/e31Bf+gmCPxtWxb/jQIDhv7duj9xURf/m9P/pXt/qQw8tSg7QgB2UHqK9F3IDnEo7GPTElMI8ouLCSl+ET/dWOCwN8db32/QCQBR6
V7aI+VLfzR1voP/zQMTuFkqKaPpMTtTP9EOCAUkuUq1C3/HRSBgf//o/qIv/UWusu7f4iE1MAaBsbhEtO2K0BYIY8sBWS0sGhMzJMWn3kIXJa+
tSWE4ifkBelTaP/cL0FqitNUokLaiv///+gDB4f1+///NCxO8YG0ZECHzK1P4RAQG//0fxodHP96h1urVZS9SiR24lL/jRYqpMQU1FqsgQTiHQ
wESnNhyVEl+nvJYSAc8qVugE/5UFTPeBCnT/9WDD/8yPhRKfmM/yt6PM5SAQqjq3//CiAI////NAxOoUOrZEFkPOwP/QM33zATobNK36FKyGUB
Y74aoJSAZrH6QsN36Z6y06SpUxdKR2eK1Nq23Np/TV52NZMoW0IEEJEFGATs6ELVDO8fw6b+yKqFMIiQ0YNGkdv7OqKi///Qyocg//80LE9BYL
RiQWSorwFQGCImKOztVEVuYREhioqHIqJ/2djFEhEJBQmKD2f9n/4tXVTEFNRTMuMTAwVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVX/80DE8hNjFgReEYRQVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zQsT/GsqdXABjyyRVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ==
]==]},
		Neon = {"rn1_neondrive.mp3", 128436, [==[
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
SFC09z2IRJKFv/u34yf////+v/V815/bvVHRug8Lo6t7P6URu2ACYKnQGSKKcTaIvy3m1FgQsUviuM4rn32nC5u6Z/sW6f6/r741THt5WXjfpI
QxloHEgN//80LE4haavwr+Wlp+/iKc39UMEQJCBM8w9rHnupro1cM//+e23RE1c8bpV///65Qs3x5/8oGPyD0KCcvaL0b8cSDsXCSavSc9N5rO
45zTpdciECBPfpm9f7LZEw516JmUgISONjLa+mL/80DE4xQyuxJeehQ22W/5mHJ5pY1RdYxTjLGI6lApXVPv9K/0r6hQ29GrX230ohoJVfq/+b
/oR9XBthdkBcwNgDqCZmFqCFNjip26ls6nfWiowLqimE5Uz5WTNq1urWp/WiJIR//rGf/zQsTtGJq21lx+D0DRq/qyNjdOJpMksezDyVTqE7//
9fp0+Ij////1DPJ/89+ptQIiWHg+2voChvlGKml6d5mkudxIGo3xEhLyBhQzBLW2qY+CS7z87NHuzqIMXF1sTASOf/z8eBUj///zQMTmF4MG4l
5clUD/7Ow5khyBo0xYzSduJnNwIoqlc49d6Vajjr3RTv5r5l16UoAjEI1nP///QMp8n+31yhn/pWo9ETljLiZrZDF0JCZia3NkjU4qdMkTSksx
UaopiEGAqbOAkx5k//NCxOMTmpbWWmmPoBTFFKlOjZ6qhB325tXTjvG//50siKFpsJIJJ3e099agjLu62M89b///F/+n6f5sgD6z/5f+lU5b5C
o5NNkrDqHs2raDqBGukqiXVT2oe5vgCYs/iP9TupZuuCwX//NAxPAb80LW/nrLOO3ap0KoiFY57ZyReB3NIhic4wMZDiUjJHK6uOmrmtzkR0//
1oIg7///+hbyX+Lf0GS1NLQVVKSWBXQzmilMYGZSZSDIrQzdV2lY3/REEejs7U029eItnf/zp5n/80LE2xZimupcalWib120pPGR4QEkIhAkom
9cDMrKj1X0Szf/p6+BY2/+ns6feTDP6Nt//qLG/XUE1ohwB3BaQGABPF1KeJc2JQnWTyzdZw3TOCeCGa+XBaminey6SJ1FO1SahNSH/17/80DE
3RV6mvpcalQ2OE13/VIo2xGYfN09QockK3SKIZoZnezTLN/r62TqFCN2v///bF41bpP7/b/kL//kASoQVNyQDbB1BEBCE71c6ssSZqNA77oUhR
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
oIzM6QhPR3uyiO5UvMBaPLrCzIT5fWcR5no1ntSYQAiT35zf9tQs//NCxOUTu0KtWnrOeIXoVOJzpdRoLE27pp///EIT///8ZmdDnU/p25xg4B
Izi4n////2//njZUW+oClSkgvVOFiCa7pdKRpcg8AumuSqBUutyBhCR++Tb3S//sQjL/j4/j6+PaRwi6FG//NAxPIa+0aqHltVYDommu3hvK1N
XRrSF2l//1hzn///5RX2Ze9ToJs28QQNkeiSZMS6u3t7N9bm9lbtVyQGKbXX7pUAwRFwJzG/K7X4ykdttZoEtqe5HrqcCgTXOHqRd41Poi6rZg
D/80LE4RTjQqi+ahWA5t81ojG2+/UJppmSq90QlEkQzqYh7mnI2pizf/8Pn///43Kf//4uFK79nalzEUtf8uzoxNSa/8Kw2xWAgFhKsFzEyCGO
iogcojvOptGsYayywMQoupaiSPNzXST/80DE6RoTQsGeWNujlrayAgJDSbSa7UHv1ag6OhcsL7T/gLGOx9P0zf/8oDWX6f//EMV/9P+RBs6mP+
l52yfutDtKu+3oJhGHKArIRlhPggQcFBBEZ/BIo3vVI1tgnCoLWpSZB0Vfx//zQsTbF5M6qX56FLC6rX1Qhgm9cVXSMP///wecdRZJ7XKQYUH/
U6+zL6f/8DX///1FIBjfX/+poB5A1v//////uMpABwGGOCIIJiASgJT4jkL+N5EKD2iCT+ai41dax46+q5d510Hfqv/zQMTYF4NCpN5plYAQxq
qvdW993///lAzIZiMnFkG+eQLv//Ob///xD66f39RwJAzf//////7ARJ0AaDGgF/hZCbPcad/5z8alNN8s3+o66FHZrpZWItcv7cV/QqARamxW
pIe5f/jc//NCxNUU60Kw3FoPEh8D8xDzSzlzqCpa2+mn//5E7///oEj///5gm///////4rfauAxNex0MPMiTHYaDON5gtxP1D/rRePYekj9lqb
MxwPNTAuNqWNArN33VQ/8aywoEF5wSETliUwFa//NAxN0Uq0auPlgPoELV69XObbOO1f/oDWFL///woH9q2Vz3VqGzScSAxOPOR1//////yAfO
xX25rxyWB5GPBNKCoOkdiCWeVG9BEkYwC1zZx+p7XGZlkRB0NUb5RJv/UGSUGJhZpBP/80LE5RQDRql6eg7sLiowhIBtDX9f26/+gLLdap1/6g
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
yTRY7O2nkzdar6kNjqIVSmx9A708xj0CEl3QMdSqWtPXlEjKhIbSSJvOVTo2DBYk8jhXktl61xJD+QpeH/80LE4BTRhlQQywyV6ml7v1zZri1h
BKHIBWKFh6w8epuNFjnN6vFRh2LSrDwlWC3g0Wfbf/XVZy/ZlGgmwPPOpkyajPFNocQNOySESB0SfpfRb4KJVepq/LMmDOjAsq777RuBYatAws
L/80DE6BYJPkAI09J4TZ5xIGSBQCSsjMtTJCkwk61Erc65//pyVkc7PAMUkEwEOBgO0hJ38KpMQU1FMy4xMDCqqqqqqqqqqqqqqqqqqqqqqqqq
qqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zQMTqFwlSJADT0LCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq//NCxOgWqU3wAM4MVKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
]==]},
		Sunset = {"rn1_pixelsunset.mp3", 126451, [==[
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
80LEShRrUtW2W87F//Uma320JVoWHsAByyEKJGFC2w3u6+l9PT+3ptMKJ5N0JUNQsczPs7+UR7vqeCNmnvulxHF3/t9CACf0//en55Fv//4nLe
lTv////mO3v8Yf//yx34rVAFaItlb/80DEVBOLItD0ek7oAmXRYFJIVT8EslrZXAuSN49fRBRkEVCAiPTDUdlFT0sWB6JRtS7RJ2Ijjf9vooOn
//9E/5qt///Cow3NlXV////+62/4jf/+pCQyetUA2FiU0BNM8cDFxk4VQ//zQsRgFFMi3l5LToh+r8RdfIqM17Fu/9IYkKPT8sTfqi7CSb7FCO
adQRM4cLf//JAVb7/+rtWvo39//xOMP3ZTF/T///m//if/WDTm3yhlBuQckICIcEHz8kSInbuRIcBYU/gFav/QCP/zQMRqFDLW2l5jzowdB8P1
nfU55If9O6qgPEcvjrnrVOHi3//4b////9D3+v/8Vm//////5n18wCD//01HTUb4jQGFDogtsplqDuTuAunT2u3nridtVW6neFCVs2MwgcTwKN
G8uFQ///NAxHQT4yblvlpOtrU88hjBGKp+q6kCLf/+Kwp//9T/+Y///+FT/cn/1///tT7t7jX//7f/nFllDcS5QOSheMFidAXJLrueSPVFnyyA
3t+aJYZgUKLqhlZrewhLMkz6CAX77UPd/4D/80LEfxPjVtm2ek7pn/t/UWl6MfoYc5t/1/7jpLzDv/////6t6ipv////x5VGu2G11qeVwOqdL6
IpAvyKckdsDOi1v+IRgDhop85T+/6rabZ3OULC///6Bb//8RjMsYXMPcWA7c0bmlj/80DEixOTVtGaY87A+2v/QA0vzhbt/8/X9fon1b6Df//1
//lVSlsr/3tum3Eh4V4OIczwATsXgMeoOkoyBUYKONTBodVb7MPhtCabD6qgQBN//8aCQDH//8rs7vyo4zf//oIH6n7f/P/zQsSXFONXBl4zzo
b2r/T8ofypHrKAUL/v/rPNmUS9VBwqD6o2z6edVDXgSCDk41Ly/JoR/MI7j/5LNnOdhmtjZRbXW8/CRv+Kgdm3MVbE2/uAOW//9CB27HHakCFL
vb/7iIIW8lp/9f/zQMSfFitbFl4SjorztNv99W9REf//6Xbv8bNVKYchpfeSGQxoYhVZx23dNmhL94bLs6cAYHTEis4OLOy/VHKA9T/igCyr2O
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
ICebDjy/jA7aWVW3nAqUfisPnP/zQMTjFOtq7x5YjxBZIUDBEE82xAWu5sQEhRS3Ml87/8YHW//f////3//6DyCv//6a+9v////UcHBUZYqrXQ
Hj/za6CdoUmnRi1S0rzh0GsIC3p8/hMJtR3we7SZFMyCVHVv7hIieZ//NCxOobG2ruXntPapy4ujKYyvXf6TQdhj+vzLe9LKvXW/Sllv/8oAYF
xI//+qW/9V/p//5gQEiCiu7d2UJnfv2fD247Ue495tP9trlVuNGfMtdtmN+n+BTXXGkozEneEadArSa6e48G//NAxNkUK2LqXHmKN7TcqRMaVe
72se2SL9aAgiq/6nTctd2siGs6N7f+36/6BGaY30/slqVob1Xb//c3p4YD8gVaQtnhEv5RJ/GVBY4rk5RBtOzsug0RRBpEdS7iApfU5cJq3HZ4
Rm7/80LE4xYbXuZ+Wg6djnJROWNu3RfqXY+xrMcqJol0OVv6UDYQD6/vun1O///9f/6hUFs9v//p/0+n///kQhi0lUFneoht3AIIhSHCIAr7xm
GGCyUCy9nKdHrmbSM110638fMoUOPxae7/80DE5hjzYuJ+eZUF4AtetK5TwB/W6vd19ervvv57f8BI2b///+nzW3X///xsW///TXovqc3sv//5
oPTESjF1WcwnEwxb3gSJAOTxJWFncVV8poyk+3JhE0gw0bTP3+Qwr+ojte+54P/zQsTdFlteylR61H1HGR/M374V+tfJ/0H4Yk//7fWybf////
84iF7/////////6EB4vL0ziDa0W3QxiYfwULFIVSBVbwRhRvfudK6cJHK2kiy5+f5FGgugH0KpFbUyitiW1GitUc6Ei//zQMTfFhti1v55jwkd
+S5i2VP9RFASDb/pvSur//f/9v/oPUFR//76//p/+k8lXQp7jA+DSKwSplO5WywyBkfwQcaGSkJOBfH08WbXix8VhR/0i4z/PzYZB5bYCaLWzS
ERUa3OFi/d//NCxOEUK2bO+niVEFWjRrl6fN/eosgeO/7aX2sx69vUt/t//0HSIe///9P/T///9C5GKxK9j08kWltTriHxDDZNdUm2poS560pG
JDJMR8tP7Ws/y/wQ44+1SS+v20wXslBSG2Ut7jjM//NAxOwXu2bW/nlVEK2QjIgRU1Z7MhWX/ED/+//167PnqzTt5zO//0EgakH////T9f///4
+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
58RJQjr///9SA/+JHAAJxt17gITuNlUCFFbSB+rWqksga4i1HG3EhTeK+xDGp/tCLWaUrcxOd8kgKQ2QQOzn3WpaQb//NAxOAWAvbWXGPUiMJB
GszOOVi+ikQkqZ42AaZTbVq2fTMR7opIJUHdMugXpJmi0VBNxkLbS0u3X+/t0SREoQzItf///+tTG7/rDKqIBvwYly/ziCG2Xk2k//GxqB2EDy
5xftQjb8L/80LE4xQy+uZeW9SE3Y5EKVds6OOW9LQC2ezO3A7//qRBAYGpIUBQ8dG8sQoagiE0ITev92oezeZjBp6iwWv///X/6BONegk////6
6ip/5OqAkBq1CZrRGtZmYEISeyc70rxgbWaiXWL/80DE7h2LAsW8etromZ0CiBQTLcaS9GfP/hOL+j92vQgCeN0NWXKDrqT+QA4NP/p1/80ZPy
of++3///1UYF+hr////8p//1klgA8EMCdq6quwMQH4jKp1BZiL1PCJax1AsCmi/47xtf/zQsTSF5MC0Zp52y6vN5pTvq26ATQhP0f/HeSB+61V
K0Oodgbpr//1fbqODidVh4iR9qk/3/X/XnRlG3SRNv///6BTLv9oJsAqSwARmAalcHQBhixHzkyi2AyxPhBEZFNw9lXnFFA8h//zQMTPFOtG0l
xaVIhzFNZkbb8oKG//4716N+olKn/5U40drdDGdkEogWsEAFxd///1V/tHxcNvKs////6kgx/VpihqciaVTdEnEc+LwMhwieu21vBGYJMWFmjl
B2VxAp5s6cULLJrV//NCxNYWev69dMMaNNQVf/+p/9/44f//QtOdlqrJUgH5uPiT/////GI/T1////ypOv/erPoXbsjlOACVYFi6y4hPb1oaJ9
3v8NFI8K5gA/R9652TdBIVV+VN8jJhQ8+StRM/RFuW8hFT//NAxNgVOvbNvFvOiGmrLa9AviZv/5e3c53apYZkchGJL///1mHd80hCMlPzji3/
//9R46/zWsmshJ01VYI4G/TTiboZ76AwdRa610G1ZzldHGaS1Jxx4qIPzbuqF8nv4OhZ9+reaV//80LE3hR7RvZeW9SHTP/UUgNf/90uetFdnY
9Rac1Qhf/////A0AwzSU////qUByE7/qdceValRsozHoIAAIEwb/mTzorKcVKn7gS5rXHDAaUtlGd2L6hqZ05/qq1paFfxKQfNVn9V5Qn/80DE
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
x41GhB08fLnGnTl/kyH///V/VE1zTW+v//cBQL36s//V/VNtt/Xb/mliH6DJUIJgUs0CCISFo+vo1Zqul+UCbJj7OyuKEw3+cssC4AtOicopFA
691VP6td//YxHstJBP/zQMToFltizbp4VSbrTMHRXb+sYQNBQ//3+RkBnKuplzKNm3VVln/+cgZP6EH85jGWn93MVf79behpI3xEDxUCg5oVxc
Lm0cXMWB2b46/hYYxejDg0elIOwRtZIarf2sk3T/2DpmKp//NCxOkXA2byXmKOwlCl3Zyf3AMd///lcdkZ+ldSOzsVC1X/4QDv5G//NT/pbX0/
uMOFtqLhACCDKioQihAIA5dZUxt47/ZtLHtC35/pqjlQTV5v40pxFTrslcsar6vdWbRG/fxKHw7o//NAxOkZE2bFvmNU+Ox9W1+pxwFACNTP//
5hC3R9LI////qC+ODz6o3//////90fqK4UxNFqAYiYEkTBhCHB8fOGBpBORXTemcy5QhTY+kUOmWQa0Xll0nHoGaaTMpIxPrSdmVusztr/80LE
3xULatpeMcqonV9S3++1XqrFHOL/v//P5xxirSzV76JWf/qAYNT/r///////x34XEYdLzwz6hLrg64h+LxYRnkolOxr033izMj40a31zQIghai
ekilNg9urmXpEI9FWdZdHGBK7/80DE5hXTYsEceNUB1auiopyfWocGn///dTn3axre+q+yt/0AlFoxvO9fVP/9H///n+QiEGDoDGRHUWAgZFjA
uN4ITb4CvCfwSY/pu3nEEvJw4hEUCRYvy+bvddXqejuqrU3oFJJRkv/zQsTpFztiyl5Mjt1JX+zeljBB4b///meeae7HnorVY39//QQQKP6//+
mdV22VP//X5EOkhFWOSaw+2YuKMYHIjm+6saVzsyZ1BdlRnCTolz4OKwz/8jPdkaWQIiRQc7+0xFIlHM/ruf/zQMToFsNi0b5KFOyEwVKjlOp3
dTKv6ign///1H+uvv/r//xYPv//9U/+v//+v1GgKLOoCFuAZtQLJMDT6ryEsDjRVK+Wik9RTdelsQP7srOmoICPU2QM1iZU9lKPuzV2rtr2ZPJ
5p//NCxOgWk2LJvktU3VtTTY1S/+orCtI//9r8oQLnPo7bf/no//yQiAQfzv9Hb////79F/icUknqOOSs22VSNoSCdHBJKzppyiLvUD1a3GBDb
1U2shnJSvx/kz1nnD7pBZMTIce0ikMpq//NAxOkWG2r2XnpKdqETvnMC8q2Kl3Rk/jwKDP7f/lCaIfpfP01pv7f+aAQIvr////9v/+/9kKNVmZ
o9qBVJkvxSNWl3lc5p5fPjfny6rMzGLNq/8hYHXOBLalnZLo91cshnbovQBxT/80LE6xejasZcY074UUDxFOd1K3/WMc9///qPoq6v1////Oht
l8w9T///q/b///+ouD1NYSptySM2WQyOQa6NmljqM49XVNrmLIaTejqG47OzMgaQJUCaRC97N9ZCuu8xUze+0dNtT+f/80DE6BcLZvJeeU8S/8
SCP9Wf9/MJI9z+/9/6z/8qAIwl+h3//+3//86m7+BgQmiwomoIhARfhEEiaGN1gWPFpyLGefS3l3XIHECcXzMjQcAwc0NbTqR6vVpvTTQ2U7ro
JsqxRIYed//zQMTmFcti2Zx5WxNdNtlLR+lUHJkC///3POZ9f3pX0qi/+wIIsit/f/7P/9Nf//R+Mgp1ImoFN2ofWcKloZBrK0VGRjntLYVGzm
wihJgQj/5wBwjZosUfh8z7O0RB001kst/9fC9D//NCxOkWE2byXmIPCkH+55p22p0f+JAD////VnqruYyHTj5iOdp//QIhYa37///T9///9PGo
wMlUbtv0GtuTjDHM/ObpNZNzZy3YaNZUikrzdAVSmZwMFbefwd9Q2pCiAydJcNTwrzzN//NAxOwXo2a9tGQU3FV6b/uKgLHUPFCy05qIi/0MCj
f//7G3un/16f/6DhQH5f7///////8/44wmLTR1WoQIX3p0DCSCr58UjMyiD1V5DQFli8YrGhAXf3B2Xjy1jpi3ej2MZtnv6/H/80LE6BdDatJe
Wg8QO+ZoYphzK/9A2DoY///3X0///O//Lxz///////VTX5f4oHTAmHVy22w224yEIdIoOBHE8NYuuyRxW/apLrJdphDH4bh0Xx7w8xvNNnUIdt
ZNTe073E21c/dNTuL/80DE5xc7ZvZeeg7anipeVkVVUXOPw3uv4oALf//RBoIZz7ruSjPSvfX/5Bi/////////9Bc4THpKx2ION4uBPo24GSZA
gCYNwsbSc+dcQTpgitqwnjj10BwTLDczVB7IpI5IYW3RbP/zQsTlFPNm4x5iTkzaMtt4XonDMWhDCIArjowGohT3GQ3b9AyGn+vZvbJDnf9f//
/+Ro3///////+36jMieaoJJAUxBI8DKB0Jxiq46Hxy0prBHLjVdKdzABKsQ1IuHVm0xMnV1NqrfP/zQMTtGGtm8l56yr7i9fT7F4/dbr21IN96
hIyNf///U19fb//7/5ZGcYqfZNv//////XpP5TMHONUJqS26DgGDMafEKlHvdxfjcf3zNJQ2AlRueSxBNpo/Frj7opbV32ia/u/+aWQS//NCxO
YYU2LeXHsUT5S7mDBsNSt+2HYdh///+6jN3quzL/sgz0FpW/6xKTzt6mb///////+YkZKRT92RAl9eXjWOfGJV4vgqmy0bUPMCS2Js5zrT2N//
KMu/qz3nlWJpBQ4hAyiTQNaG//NAxOAVW2a9sGIoTLo6kBadZZHRj7L/BUKN///nM7zylGdjHmJ9v/+IxBv7f/T7p3V2W///t42EoWlDVWvJcx
9/ywM5nOswjYJIr9tvk+YK0TKUmRQT3c/AajXlRyWVfXd9MYnD4tj/80LE5RZzXsGcehq9oziqqGXTX49JPcxaWNV3X9x+GL///86//////mHD
9/////////9SNxXJ1W5ZEIIbetsyjFwckewFxjGHyEdxUfzOltYwM6qfcG4S6CrwB32KgoQJYXH4h3MSXMn/80DE5xfTatp+eE8kfqsp+pvXYx
DkBuC2b/+/6r///6n/+spmA9H//rb/+r/+9T+k3k8wIo9C4fVrWxMfb0SmEeEbWF2QEvcLbPpixFUqS3xQylr+wUBboXozOU7t7GG9/CwuO0rm
Ev/zQsTiFVNm2lx61Jxui0ItWqdP/FYDjv//9kNPsP+1Xo9Nm//qUEQ///7dNf12///9Sw4NBCpvOUwb++WiAdJoHEpdBVMN4u4PnhQ8xfrH3W
+s/EpL98Ab8OY2iGLXgsEynmPb6aM3kP/zQMToFyNq1n5Y2wz4KV4EIoZf1W4cAjv//d9nNPV6H8xG63vX//UZo3//7/2+tuz///kFikM52RtX
AooxF+SKigMcI8LBgfl6aIkOTRUs451PXoACYw7LbOE3lO61zb1cxatmv31M//NCxOYWC2LWXnoOnSvdtE6r9KgtCs39/7fZXoj1dN/9lZq/4v
CUSkn6/2929f3//vM6PxIFcwXl6rLd9TtrnZKxUKd7IiC/mrGqydlwxynC8VhTIFwLC6yvwIwn6hpw9m9qpFLoqqp2//NAxOkWo17WXnjVEWi7
/m45kbEc9JTmtLf+oXort+nrX6uyvp////+oHTzm9P/t/9a/pz//9CYVakdsOkkDhaGSMrfwT043t0dMzTjQ3Lymye5RdCN32JnQVKMj0kejw+
dPNkHOW3X/80LE6ReTZs5eghUIY6maiGV1VBdC1VV9f+Ei///6pV50bnWY7UX//8SFG///rT3++3///lAosDKO6ZkCW97tNo56oOVvNBBUsUM7
35bXmHP4ljNTuvx/ygaftX3i4mlRT9itCOJnbEb/80DE5ha7WwJeehS/9PF5yM7Ojc1H/miIA0NP/+ZqzVft/vm///QgQW3//oybP/6f9//+gq
FRqUdLxxoW2wvPPBNttPcXYUhnZRZLT+Mpnt2bFZdwsTfP8isTfIbPcl+8ZEhsjzfLRv/zQsTmFqti6l57CncpbXraCmrSf/6hihNyD//t600V
7L6v/6l//kuZEo//97f/1L//rb1t5xNQ7SlVruukV1tUqDHOwivKr0DnAV6pgeY/XKGsY+agxb/gFQ/IOqN9ogy5tN0lzz+iZf/zQMTnFwNq3n
541SRTF+6+/+JAv///17v1azrN+9v/QQf/////////o4mLTkSVaTUJb7u61DlQlmxdDZH/eMTmfOnM/otDhzjOl61t4/hh/pfxlDHvo/IbT3mu
hx0iRrGGOzPbV4zU//NCxOYXC2bOXHjbDMRXZj3VdvRioB41//7e5sn0StKH5ytay3v/zofzQsT+pX6t//2s33//+skzzdVEZmm0/a5yy0c+LN
SYPw1psg4sW8Q/UQVTFWvdWjW9/+hjvzsG8Ygym7qusw/j//NAxOUTe2MCXnoKsyKBp8+Hm/imW9mUhsX60BhH///zvTbv//f/icByGf/+//7f
/+0//C4OCo4JQpR5Rgh/8JVmONJYs2JgWg3mw365s/UzipHGUg0aMFNfIBkEsOIpYHkmTjYg177/80LE8hoLXtseeps5JUalKYOWvSrVBU9aiO
rh5iq/TE8Xf//9kXa2n/+//1Dhpzf/skxktvXu39d//+aF6XHqbtscOtlMikHSTRDbV81U/UkjlCkZZ/esZFRjPgBA7OA9ymDghdk9L9b/80DE
5RaDYwb+eM8vlWKRvzLRsck02dMTWv8ak///9D2Xf6PZO7+//42IG///9el/P+if/v6CUAMVLkZq2SMy25xoQaQ4VMSkfyEeA0x+1FmvVqWMRu
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
3FQ8VOMXLGONorTJ//NAxOAWA2bCXnjPDPb1ftyrXnOnV2/oAkB4x//vfbQtnEcdbWZbVUon/yCFH//pV7f/T///+hdBURpCBFMTXYukIZGms4
5vi9a7N/dbCtY6B0jiXjnhwNMyw963hot49zruYafUkyH/80LE4xXTYtW8e07jiW0zaIx81fT9DgKt//37aNNH2olv/X//HSZH/////////x5C
BlUCAoIOOQJCIbSll9ynERRo6eld3Mm/+zKovWz1L/oqlWtrDnbxVArR2lraz1LOhYYkgZOtNZf/80DE5xdjZs5eeg7U4EEfx/Y2qwzoopdaX+
oD5B/p21M05A2Vf9Wa/VP/6B4pn/9UNo+lKmaNfslq32/8qLYFUalCZZK7pBddXNLBxTTXoxgagelfomwxh+YUUqyanHFUvPiFqjZkhv/zQsTk
FItmyl56DnyMKVHizFl3PREWXLFsoLtiZIlfrZM1/8HAiv///6NsXnmoyJsy81HPf/iYAEft//9u3/////lQxnUIIC/wl0SR+VyCNE0O2wc+Zy
46zj+uwchMudD1XgEv0bZvuv/zQMTtGyNqsl7A1SynHZyHoHNLnoahjrNV786kzstrsav6VATDw7///0bT//9v/oCpy7f////////7CBJ3j0oF
WhZthdNR4Bt4ejfK0+NGGzeeNsunUtTWqah4Zl/GnPl7JTLMrutm//NCxNsXI17yXnpOU7tfa6IzOyLWl//Fpf/T/1d5QzKN1ejNf//9Qeg6Fn
//+q+i6Kluv//6IRFw6ipNcoXa5LMQYsHMIBSP5fRL1eDVaY1ovhtRUYEhH7I+2KlBR7N7GOAmuBcZ9PiG//NAxNoVQ161knsUXZzfL+UcBIv/
//9Oe1fX3XSe//niWgVL///////9//U8aicudQQg5awo4wKYtZNgVxBJ26s23er5z83vidvtfULUsIcaC7eqfvy2LZLe8w9qF2//1GnbayeQ+3
b/80LE4BWLas5ees5Ursku//jqGwUv/9n7ZzndSv/tUl/9ZKIER//6kqv/1P//v/6ygsepeQGVU1f/jOaRipkpA8TBEy/R3IjsYtslcxXbXVHg
FHPRLorc4C2AT1BRCAQNYmdKm5RICIn/80DE5RRrasm+WE9Ilo739/8WBv///bHmqOk0U9Wqaxh3dm//jpMa///v0166f///1PJGqgHxPloUbY
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
LmR9qXf01HJZ7h0xIMBZViRzLFUEc6TktAH/bVONwrknphsqd5Qt8pETJXjDvErBNv7E/izHx/F8EjhAgqvQfkbh//NCxOYWum6hfnmUcnn/k/
ivW3SDnOPT6GZCBBMCxOdeWB9kisOPRfKAeqHg15oJ5QB+6kYVvMfgvw8uaHanByXNBwjVqCVCeQ5wHgPN4HKkyGxzOiuKOWRIocTbpQlUK+CJ
csh6csaj//NAxOcXCm6hnniTV4UWmQ/ElAhyj9KUOy44rVn2Qg9DqjsucnY7m6vUiPrc9aU6eGN9aAQoAJT2wA/fFHoLMdRqLEsobnAxPfSDVj
gyHRWFFwfJRH3ZFHBXePJtXBNYnBYlwySRZ2n/80LE5RQBip1+ega2B1e6uJeXbe/9zEGz/w/0/1A/lc9VRDjq1ZPVm2rFfo8sL3hn6SoMntiF
DwE46KfgxW0OLrlustyNuO7VFmi2KZC+GRILe8hAtYbbbM8ocUQcij/ArdlCVJCEhFn/80DE8RhCanAWywS0FP4a8JKK+rCZ06wrnD5mPV0490
z1n/EU9Fxj7L8MwmLYelRCdEuKUR3i8CKAAEpQAPxyjQoAALCJ5wL8D1zeBpaAiLZbJWXVIetbLALuQPqAeT7mvte9cDL/Mf/zQsTrF2H+eZ7C
xrh1BSlI5pSdQLaUg1/zgrdBClhDvityvhA/EphaorIhqs1oEUSqeMkXqaxT6iAb/u1UwsGMnMBwBMeQMkdo04SVSUoCL2fFWispxzZAHexRHt
SuzGMwXO9pUUsP4//zQMTpF2kyXAwOmBxJpgaS1cHhzG9c3NSz4KU96Js2IVwQQk2vu5cg5l4BaA1QdEyjrK///pomOpscCwyIZ4ddZbLwKCUp
N0NhmDELlw2UrW7Nf1mKCVhUcq7I0cH4Q9W1xGASXHD8//NCxOYWkUZkXspFCCHNLJaNPy7I6QSsHyElYz0+PtaoWr6Wz9qB/UpRMpQel2ULKr
ka7yfSFHCZ1LY05EYBfxgCZghBrTSsUBvbC3ogZ4l1X8mso2rd6XleYKgkzvyxpWlQfm3VMGWI//NAxOcWYXZYsNLHJOp6Yzd0vBUZPMmJe6ZL
xtLLtZxd+W+gmVvBmL/mCuEvO552lVU7BUkeoOeIEVmgENLVTBEFDRYQtc4zCU1WBRiBnRexE5Q9A1E5pZPIoJF8fRyQRBSYOI8BUhj/80LE6B
WhOkQI09LogmAVDiQyIDYvllo+uJKV1lMHCcamSc2CR6JIrZanmn//eKsiWok7rAqM10xBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVX/80DE7RYBdiwA0wUoVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zQsTwGPl55ADLDOxVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQ==
]==]},
	}

	local B64 = {}
	do
		local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		for i = 1, #alphabet do
			B64[string.byte(alphabet, i)] = i - 1
		end
	end

	local function decode(data)
		data = string.gsub(data, "[^A-Za-z0-9%+/]", "")
		local len = #data
		local out, buf, nb = {}, {}, 0
		local char, unpack, byte = string.char, table.unpack, string.byte
		for i = 1, len - 3, 4 do
			local a, b, c, d = byte(data, i, i + 3)
			local n = B64[a] * 262144 + B64[b] * 4096 + B64[c] * 64 + B64[d]
			buf[nb + 1] = n // 65536
			buf[nb + 2] = (n // 256) % 256
			buf[nb + 3] = n % 256
			nb = nb + 3
			if nb >= 2997 then
				out[#out + 1] = char(unpack(buf, 1, nb))
				nb = 0
			end
		end
		local rem = len % 4
		if rem >= 2 then
			local base = len - rem
			local a, b, c = byte(data, base + 1, base + 3)
			local n = B64[a] * 262144 + B64[b] * 4096 + (c and B64[c] or 0) * 64
			buf[nb + 1] = n // 65536
			nb = nb + 1
			if rem == 3 then
				buf[nb + 1] = (n // 256) % 256
				nb = nb + 1
			end
		end
		if nb > 0 then
			out[#out + 1] = char(unpack(buf, 1, nb))
		end
		return table.concat(out)
	end

	Util.RetroAudio = {}
	for key, info in RETRO do
		local path = ASSET_DIR .. info[1]
		Util.RetroAudio[key] = path
		local okFile, exists = pcall(isfile, path)
		local good = false
		if okFile and exists then
			local okRead, content = pcall(readfile, path)
			good = okRead and type(content) == "string" and #content == info[2]
		end
		if not good then
			local okDec, bin = pcall(decode, info[3])
			if okDec and #bin == info[2] then
				pcall(writefile, path, bin)
			end
		end
	end
end

Util.GetCDNAsset = function(filename)
	local path = "UhhhhhhReanim/Assets/" .. filename
	local s, id = pcall(isfile, path)
	if s and id then
		s, id = pcall(getcustomasset, path)
		if s then return id end
	end
	return ""
end

Util.MakeTriforce = function(tris, color, dur)
	dur = dur or 8
	local function CreateTriangle(parent, radius, width, rotation, color)
		local height = (math.sqrt(3) / 2) * width
		local pivot = Util.Instance("Frame", parent)
		pivot.AnchorPoint = Vector2.new(0.5, 0.5)
		pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
		pivot.Size = UDim2.new(1, 0, 1, 0)
		pivot.BackgroundTransparency = 1
		pivot.BorderSizePixel = 0
		pivot.Rotation = rotation
		local tri = Util.Instance("ImageLabel", pivot)
		tri.AnchorPoint = Vector2.new(0.5, 1)
		tri.Position = UDim2.new(0.5, 0, 0.5 - radius, 0)
		tri.Size = UDim2.new(width, 0, height, 0)
		tri.BackgroundTransparency = 1
		tri.BorderSizePixel = 0
		tri.Image = Util.GetCDNAsset("letriangul.graphic.png")
		local grey = math.max(color.R, color.G, color.B) * 0.5
		tri.ImageColor3 = Color3.new(grey, grey, grey)
		TweenService:Create(tri, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
			ImageColor3 = color
		}):Play()
	end
	local radius = 0.1
	local pivot = Util.Instance("Frame")
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
	pivot.BackgroundTransparency = 1
	pivot.BorderSizePixel = 0
	local width = 2 * radius * math.sin(math.pi / tris) * 2
	for i=1, tris do
		CreateTriangle(pivot, radius, width, (i / tris) * 360, color)
	end
	return pivot
end
Util.MakeText = function(text)
	text = text:upper()
	local ls = "BCDEIKOPQRSTUVYZ\\_`N^MJ"
	local lt = ""
	-- !, ", #, $, %, &, ', (, ), *, +, ,, -, ., /
	lt ..= "DDDDD@DFF@@@@@FSFSFSF@@@@@@@@@@@@@@EMMUKKTDD@@@@@DEEEEEDDBBBBBD@@@@@@@@@@@@@@@@@@@DE@@@G@@@@@@@@@DABBDEEI"
	-- numbers
	lt ..= "GJJJJJGDVDDDDSGJAGIISRAAGAARWJJSAAASIIRAARGIIRJJGSAABBDDGJJGJJGGJJHAAG"
	-- :, ;, <, =, >, ?, @
	lt ..= "@DD@DD@@DD@DE@@BDEDB@@@G@G@@@EDBDE@GJABD@D@@@@@@@"
	-- capital letters
	lt ..= "DFJSJJJRJJRJJRGJIIIJGRJJJJJRSIIRIISSIIRIIIHIILJJHJJJSJJJGDDDDDGAAAAAJHJKMOMKJIIIIIISJQNJJJJJJPNLJJGJJJJJGRJJRIIIGJJJNGCRJJRMKJGJIGAJGSDDDDDDJJJJJJGJJJJJFDJJJNQJJJJFDFJJJJFDDDDSABDEIS"
	local pixs = {}
	local totalsize = 0
	for i=0, 6 do
		local row = {}
		for j=1, text:len() do
			local c = text:byte(j, j)
			local w = 0
			if c ~= 0x20 then
				local k = (c - 33) * 7 + i
				w = lt:byte(k + 1, k + 1)
				if w ~= nil and w > 64 then
					w = ls:byte(w - 64, w - 64) - 65
				else
					w = 0
				end
			end
			for k=0, 5 do
				local h = (j - 1) * 6 + (4 - k)
				totalsize = math.max(totalsize, h + 1)
				local p = (w // math.pow(2, k)) % 2
				if p > 0 then
					row[h] = true
				end
			end
		end
		pixs[i] = row
	end
	local pivot = Util.Instance("Frame")
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.new(0.5, 0, 0.5, 0)
	pivot.Size = UDim2.new(0, totalsize, 0, 7)
	pivot.BackgroundTransparency = 1
	pivot.BorderSizePixel = 0
	for i=0, 6 do
		local row = pixs[i]
		local olde = nil
		local olds = 0
		for j=0, totalsize - 1 do
			local pix = row[j]
			if pix == true then
				if olde ~= nil then
					olds += 1
					olde.Size = UDim2.new(olds / totalsize, 0, 1 / 7, 0)
				else
					olde = Util.Instance("Frame", pivot)
					olde.AnchorPoint = Vector2.new(0, 0)
					olde.Position = UDim2.new(j / totalsize, 0, i / 7, 0)
					olde.Size = UDim2.new(1 / totalsize, 0, 1 / 7, 0)
					olde.BackgroundTransparency = 1
					olde.BorderSizePixel = 0
					olds = 1
				end
			else
				olde = nil
				olds = 0
			end
		end
	end
	return pivot
end
Util.SetTextColor = function(text, color, tran)
	for _,v in text:GetChildren() do
		v.BackgroundColor3 = color
		v.BackgroundTransparency = tran
	end
end

local UISound = {}

UISound.Music = Util.Instance("Sound", UIMainFrame)
UISound.Music.Looped = false
UISound.Music.PlaybackRegionsEnabled = false
UISound.Music.Volume = 1
UISound.Music.PlaybackSpeed = 1

local MusicPlayer = {}
MusicPlayer.IntroTrack = {Util.RetroAudio.Intro, "8-Bit Boot Jingle"}
MusicPlayer.Database = {
	{Util.RetroAudio.Neon, "Neon Drive (8-bit original)"},
	{Util.RetroAudio.Sunset, "Pixel Sunset (8-bit original)"},
}
pcall(function()
	local future = table.clone(MusicPlayer.Database)
	if isfile("UhhhhhhReanim/Muzik/nobuiltin") then
		table.clear(future)
	end
	for _,file in listfiles("UhhhhhhReanim/Muzik") do
		if isfile(file) and file:sub(-4, -1) == ".mp3" then
			table.insert(future, {file, file:sub(21, -5)})
		end
	end
	if #future > 0 then
		MusicPlayer.Database = future
	end
end)
MusicPlayer.Switching = false
MusicPlayer.Last = 1
MusicPlayer.Fails = 0
MusicPlayer.PlayMusic = function(i)
	if MusicPlayer.Switching then return end
	MusicPlayer.Switching = true
	local last = MusicPlayer.LastMusic
	local hi
	if type(i) == "table" then
		-- a track given directly (used for the intro jingle)
		hi = i
		MusicPlayer.LastMusic = nil
	else
		if not i then
			repeat
				i = math.random(1, #MusicPlayer.Database)
				task.wait()
			until i ~= last or #MusicPlayer.Database <= 1
		end
		MusicPlayer.LastMusic = i
		hi = MusicPlayer.Database[i]
	end
	local soundid, soundname = hi[1], hi[2]
	local s, id = pcall(isfile, soundid)
	if s and id then
		s, id = pcall(getcustomasset, soundid)
		if s then
			soundid = id
		else
			soundid = ""
		end
	else
		soundid = ""
	end
	if #soundid == 0 then
		MusicPlayer.Switching = false
		MusicPlayer.Fails = MusicPlayer.Fails + 1
		if MusicPlayer.Fails > #MusicPlayer.Database + 1 then
			MusicPlayer.Fails = 0
			return -- nothing playable on this executor, stay silent instead of looping forever
		end
		return MusicPlayer.PlayMusic()
	end
	MusicPlayer.Fails = 0
	UISound.Music.SoundId = soundid
	UISound.Music.Name = soundname
	UISound.Music:Stop()
	task.wait()
	UISound.Music.TimePosition = 0
	task.wait()
	UISound.Music:Play()
	task.wait()
	MusicPlayer.Switching = false
end
UISound.Music.Ended:Connect(function()
	MusicPlayer.PlayMusic()
end)

SaveData.SkipIntro = not not SaveData.SkipIntro
if SaveData.SkipIntro then
	MusicPlayer.PlayMusic()
else
	UISound.Music.Volume = 0
	MusicPlayer.PlayMusic(MusicPlayer.IntroTrack)
	local loadStart = os.clock()
	repeat RunService.RenderStepped:Wait() until UISound.Music.IsLoaded or os.clock() - loadStart > 3
	UISound.Music:Stop()
	task.wait()
	UISound.Music:Play()
	UISound.Music.Volume = 1
	UISound.Music.TimePosition = 0
	-- ==========================================================================
	--  RETRO INTRO  :: synthwave cracktro, synced to the intro music (5.256s)
	--  CRT power-on -> rising sun + neon grid -> dropping logo -> loading bar
	--  -> beat hit + glitch -> white-out -> UI
	-- ==========================================================================
	local INTRO_LEN = 5.256
	local INTRO_BEAT = 4.256
	local introMessages = {
		"   *** UHHHHHH REANIMATE PRESENTS ***   INSERT COIN TO CONTINUE ...   GREETINGS TO ALL THE RETRO SCENE LOVERS ...   ORIGINAL 8-BIT SOUNDTRACK ...   CODE BY STEVETHEREALONE ...   ",
		"   WELCOME, PLAYER ONE ...   LOADING THE GOOD STUFF ...   NO CHEATS, ONLY CHIPTUNES ...   ORIGINAL 8-BIT SOUNDTRACK ...   KEEP IT RETRO, KEEP IT SMOOTH ...   ",
		"   1UP   HIGH SCORE 999999   READY PLAYER ...   POWERED BY PURE NOSTALGIA ...   CHIPTUNE MUSIC FOREVER ...   GREETINGS FROM THE UHHHHHH CREW ...   ",
		"   PRESS START ...   BOOTING UHHHHHH REANIMATE ...   8-BIT HEARTS, 16-BIT DREAMS ...   BLIP BLOOP, ENJOY THE BEEPS ...   ENJOY THE SHOW ...   ",
	}
	local introMessage = introMessages[math.random(1, #introMessages)]

	local Intro = nil
	local introOk, introErr = pcall(function()
		-- ---------- tiny helpers ----------
		local function MakeFrame(parent, z)
			local f = Util.Instance("Frame", parent)
			f.BorderSizePixel = 0
			f.BackgroundColor3 = Color3.new(0, 0, 0)
			f.ZIndex = z or 1
			return f
		end
		local function MakeLabel(parent, text, z)
			local l = Util.Instance("TextLabel", parent)
			l.BackgroundTransparency = 1
			l.BorderSizePixel = 0
			l.Font = Enum.Font.Arcade
			l.Text = text
			l.TextColor3 = Color3.new(1, 1, 1)
			l.ZIndex = z or 1
			return l
		end
		local function Gradient(inst, rotation, c0, c1)
			local g = Util.Instance("UIGradient", inst)
			g.Rotation = rotation
			g.Color = ColorSequence.new(c0, c1)
			return g
		end
		local function Bounce(x)
			local n1, d1 = 7.5625, 2.75
			if x < 1 / d1 then
				return n1 * x * x
			elseif x < 2 / d1 then
				x -= 1.5 / d1
				return n1 * x * x + 0.75
			elseif x < 2.5 / d1 then
				x -= 2.25 / d1
				return n1 * x * x + 0.9375
			end
			x -= 2.625 / d1
			return n1 * x * x + 0.984375
		end
		local function Clamp01(x)
			return math.clamp(x, 0, 1)
		end

		local CYAN = Color3.fromRGB(0, 255, 240)
		local MAGENTA = Color3.fromRGB(255, 50, 200)
		local SKY_TOP = Color3.fromRGB(8, 0, 28)
		local SKY_BOT = Color3.fromRGB(70, 10, 100)

		-- ---------- root ----------
		Intro = MakeFrame(UIMainFrame, 1)
		Intro.Size = UDim2.fromScale(1, 1)
		Intro.ClipsDescendants = true

		local Scene = MakeFrame(Intro, 1)
		Scene.BackgroundTransparency = 1
		Scene.Size = UDim2.fromScale(1, 1)
		Scene.Visible = false

		-- ---------- sky, stars, sun ----------
		local Sky = MakeFrame(Scene, 1)
		Sky.BackgroundColor3 = Color3.new(1, 1, 1)
		Sky.ClipsDescendants = true
		Gradient(Sky, 90, SKY_TOP, SKY_BOT)

		local stars = {}
		for i = 1, 55 do
			local s = MakeFrame(Sky, 1)
			s.BackgroundColor3 = Color3.new(1, 1, 1)
			local sz = math.random(1, 2)
			s.Size = UDim2.fromOffset(sz, sz)
			stars[i] = {
				f = s,
				x = math.random(),
				y = math.random() * 0.9,
				speed = 0.004 + math.random() * 0.03,
				phase = math.random() * math.pi * 2,
			}
		end

		local Sun = Util.Instance("CanvasGroup", Sky)
		Sun.BorderSizePixel = 0
		Sun.BackgroundColor3 = Color3.new(1, 1, 1)
		Sun.AnchorPoint = Vector2.new(0.5, 0.5)
		Sun.ZIndex = 2
		Util.Instance("UICorner", Sun).CornerRadius = UDim.new(0.5, 0)
		Gradient(Sun, 90, Color3.fromRGB(255, 240, 90), Color3.fromRGB(255, 40, 140))
		local sunStripes = {}
		for i = 1, 6 do
			local s = MakeFrame(Sun, 3)
			s.BackgroundColor3 = SKY_BOT
			s.Size = UDim2.new(1, 0, 0.012 + i * 0.011, 0)
			sunStripes[i] = {f = s, y = 0.46 + i * 0.085}
		end

		-- ---------- neon floor ----------
		local Floor = MakeFrame(Scene, 1)
		Floor.BackgroundColor3 = Color3.new(1, 1, 1)
		Floor.ClipsDescendants = true
		Gradient(Floor, 90, Color3.fromRGB(45, 0, 75), Color3.fromRGB(4, 0, 16))

		local hLines = {}
		for i = 1, 11 do
			local l = MakeFrame(Floor, 2)
			l.BackgroundColor3 = MAGENTA
			hLines[i] = l
		end
		local vLines = {}
		local V_COUNT = 17
		for i = 1, V_COUNT do
			local l = MakeFrame(Floor, 2)
			l.BackgroundColor3 = MAGENTA
			l.BackgroundTransparency = 0.35
			l.AnchorPoint = Vector2.new(0.5, 0.5)
			vLines[i] = l
		end

		local Horizon = MakeFrame(Scene, 3)
		Horizon.BackgroundColor3 = CYAN
		Horizon.AnchorPoint = Vector2.new(0, 0.5)

		-- ---------- logo ----------
		local LOGO = "UHHHHHH"
		local letters = {}
		for i = 1, #LOGO do
			local ch = LOGO:sub(i, i)
			local shadow = MakeLabel(Scene, ch, 5)
			shadow.TextScaled = true
			shadow.AnchorPoint = Vector2.new(0.5, 0.5)
			local main = MakeLabel(Scene, ch, 6)
			main.TextScaled = true
			main.AnchorPoint = Vector2.new(0.5, 0.5)
			local stroke = Util.Instance("UIStroke", main)
			stroke.Color = Color3.new(0, 0, 0)
			stroke.Thickness = 3
			shadow.Visible = false
			main.Visible = false
			letters[i] = {shadow = shadow, main = main}
		end

		local subtitleFull = "REANIMATE  V" .. UhhhhhhVersion
		local Subtitle = MakeLabel(Scene, "", 6)
		Subtitle.TextColor3 = CYAN
		Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
		Subtitle.TextXAlignment = Enum.TextXAlignment.Center
		local subStroke = Util.Instance("UIStroke", Subtitle)
		subStroke.Color = Color3.new(0, 0, 0)
		subStroke.Thickness = 2

		local Credits = MakeLabel(Scene, "CODE: STEVETHEREALONE    MUSIC: 8-BIT ORIGINAL", 6)
		Credits.AnchorPoint = Vector2.new(0.5, 0.5)
		Credits.TextXAlignment = Enum.TextXAlignment.Center
		Credits.TextTransparency = 1
		local credStroke = Util.Instance("UIStroke", Credits)
		credStroke.Color = Color3.new(0, 0, 0)
		credStroke.Thickness = 2

		-- ---------- loading bar ----------
		local LoadText = MakeLabel(Scene, "LOADING", 7)
		LoadText.TextXAlignment = Enum.TextXAlignment.Left
		LoadText.AnchorPoint = Vector2.new(0, 1)
		local LoadPct = MakeLabel(Scene, "0%", 7)
		LoadPct.TextXAlignment = Enum.TextXAlignment.Right
		LoadPct.AnchorPoint = Vector2.new(1, 1)
		LoadPct.TextColor3 = CYAN

		local Bar = MakeFrame(Scene, 7)
		Bar.BackgroundTransparency = 0.3
		Bar.BorderSizePixel = 2
		Bar.BorderColor3 = CYAN
		Bar.AnchorPoint = Vector2.new(0.5, 0)
		local BAR_BLOCKS = 24
		local barBlocks = {}
		for i = 1, BAR_BLOCKS do
			local b = MakeFrame(Bar, 1)
			b.BackgroundColor3 = Color3.fromHSV(0.88 - 0.38 * ((i - 1) / (BAR_BLOCKS - 1)), 0.8, 1)
			b.Position = UDim2.new((i - 1) / BAR_BLOCKS, 2, 0, 2)
			b.Size = UDim2.new(1 / BAR_BLOCKS, -3, 1, -4)
			b.Visible = false
			barBlocks[i] = b
		end

		-- ---------- scroller ----------
		local Band = MakeFrame(Scene, 8)
		Band.BackgroundTransparency = 0.25
		Band.BackgroundColor3 = Color3.fromRGB(10, 0, 30)
		local BandLine = MakeFrame(Band, 1)
		BandLine.BackgroundColor3 = MAGENTA
		BandLine.Size = UDim2.new(1, 0, 0, 2)
		local Scroller = MakeLabel(Band, introMessage, 2)
		Scroller.AnchorPoint = Vector2.new(0, 0.5)
		Scroller.TextXAlignment = Enum.TextXAlignment.Left
		Scroller.TextColor3 = Color3.fromRGB(255, 240, 120)
		Scroller.TextWrapped = false
		local scrollerWidthCache = 0
		local scrollerSizeCache = 0

		-- ---------- screen effects ----------
		local glitchStrips = {}
		for i = 1, 5 do
			local g = MakeFrame(Scene, 15)
			g.BackgroundColor3 = (i % 2 == 0) and CYAN or MAGENTA
			g.BackgroundTransparency = 0.45
			g.Visible = false
			glitchStrips[i] = g
		end

		local Scan = MakeFrame(Intro, 20)
		Scan.BackgroundTransparency = 1
		Scan.Size = UDim2.fromScale(1, 1)
		local scanCount = math.clamp(math.ceil(Util.GetScreenSize().Y / 4), 60, 320)
		for i = 0, scanCount - 1 do
			local s = MakeFrame(Scan, 1)
			s.BackgroundTransparency = 0.8
			s.Position = UDim2.fromOffset(0, i * 4 + 2)
			s.Size = UDim2.new(1, 0, 0, 1)
		end

		local Flicker = MakeFrame(Intro, 21)
		Flicker.BackgroundColor3 = Color3.new(1, 1, 1)
		Flicker.BackgroundTransparency = 0.97
		Flicker.Size = UDim2.fromScale(1, 1)

		local Crt = MakeFrame(Intro, 30)
		Crt.BackgroundColor3 = Color3.new(1, 1, 1)
		Crt.AnchorPoint = Vector2.new(0.5, 0.5)
		Crt.Position = UDim2.fromScale(0.5, 0.5)

		local WhiteFx = MakeFrame(Intro, 31)
		WhiteFx.BackgroundColor3 = Color3.new(1, 1, 1)
		WhiteFx.Size = UDim2.fromScale(1, 1)
		WhiteFx.BackgroundTransparency = 1

		-- ---------- main loop ----------
		local startClock = os.clock()
		while true do
			RunService.Heartbeat:Wait()
			local clockT = os.clock() - startClock
			local t = UISound.Music.IsPlaying and UISound.Music.TimePosition or clockT
			if t >= INTRO_LEN or clockT > INTRO_LEN + 3 then break end

			local scr = Util.GetScreenSize()
			local W, H = scr.X, scr.Y
			local horizonY = H * 0.64
			local floorH = H - horizonY

			-- CRT power-on
			if t < 0.12 then
				Crt.Visible = true
				Crt.BackgroundTransparency = 0
				Crt.Size = UDim2.fromOffset(W * Clamp01(t / 0.12), 3)
			elseif t < 0.32 then
				local a = Clamp01((t - 0.12) / 0.2)
				a = 1 - (1 - a) ^ 3
				Crt.Size = UDim2.fromOffset(W, 3 + (H - 3) * a)
			elseif t < 0.6 then
				Crt.Size = UDim2.fromOffset(W, H)
				Crt.BackgroundTransparency = Clamp01((t - 0.32) / 0.28)
			else
				Crt.Visible = false
			end
			Scene.Visible = t >= 0.32

			-- layout
			Sky.Size = UDim2.fromOffset(W, horizonY)
			Floor.Position = UDim2.fromOffset(0, horizonY)
			Floor.Size = UDim2.fromOffset(W, floorH)
			Horizon.Position = UDim2.fromOffset(0, horizonY)
			Horizon.Size = UDim2.fromOffset(W, 3)

			-- stars
			for _, s in stars do
				local x = (s.x - t * s.speed) % 1
				s.f.Position = UDim2.new(x, 0, s.y, 0)
				s.f.BackgroundTransparency = 0.25 + 0.5 * (0.5 + 0.5 * math.sin(t * 4 + s.phase))
			end

			-- sun rising
			local D = math.min(W * 0.5, H * 0.44)
			local rise = Clamp01((t - 0.4) / 1.3)
			rise = 1 - (1 - rise) ^ 3
			Sun.Size = UDim2.fromOffset(D, D)
			Sun.Position = UDim2.fromOffset(W / 2, horizonY - D * 0.3 + (1 - rise) * D * 0.9)
			for i, s in sunStripes do
				s.f.Position = UDim2.new(0, 0, s.y + 0.008 * math.sin(t * 2 + i), 0)
			end

			-- grid floor (perspective)
			for i, l in hLines do
				local p = ((i - 1) / #hLines + t * 0.22) % 1
				local y = floorH * (p ^ 2.2)
				l.Position = UDim2.fromOffset(0, y)
				l.Size = UDim2.new(1, 0, 0, math.max(1, math.floor(p * 3)))
				l.BackgroundTransparency = 0.7 - 0.7 * p
			end
			for i, l in vLines do
				local theta = ((i - 1) / (V_COUNT - 1) * 2 - 1) * math.rad(64)
				local len = floorH / math.cos(theta) + 20
				local cx = W / 2 + math.sin(theta) * len / 2
				local cy = math.cos(theta) * len / 2
				l.Position = UDim2.fromOffset(cx, cy)
				l.Size = UDim2.fromOffset(2, len)
				l.Rotation = -math.deg(theta)
			end

			-- logo
			local L = math.clamp(math.min(H * 0.17, W / 7.4), 24, 100)
			local spacing = L * 0.92
			local baseY = H * 0.29
			local sinceBeat = t - INTRO_BEAT
			local pop = 1
			if sinceBeat > 0 then
				pop = 1 + 0.28 * math.exp(-sinceBeat * 9)
			end
			for i, lt in letters do
				local startAt = 0.6 + (i - 1) * 0.11
				local p = Clamp01((t - startAt) / 0.75)
				if p <= 0 then
					lt.main.Visible = false
					lt.shadow.Visible = false
				else
					lt.main.Visible = true
					lt.shadow.Visible = true
					local y = baseY - (1 - Bounce(p)) * (baseY + L * 1.5)
					if p >= 1 then
						y += math.sin(t * 5 + i * 0.7) * L * 0.05
					end
					local x = W / 2 + (i - (#LOGO + 1) / 2) * spacing
					local size = L * pop
					if sinceBeat > 0 and math.random() < 0.3 then
						x += (math.random() - 0.5) * L * 0.18
					end
					local hue = t * 0.35 + i * 0.09
					lt.main.TextColor3 = Util.LoopedHSV(hue, 0.65, 1)
					lt.shadow.TextColor3 = Util.LoopedHSV(hue + 0.5, 0.9, 0.55)
					lt.main.Size = UDim2.fromOffset(size, size)
					lt.shadow.Size = UDim2.fromOffset(size, size)
					lt.main.Position = UDim2.fromOffset(x, y)
					lt.shadow.Position = UDim2.fromOffset(x + L * 0.06, y + L * 0.08)
				end
			end

			-- subtitle typewriter
			local subSize = math.clamp(L * 0.3, 12, 32)
			local typed = math.floor(Clamp01((t - 1.7) / 1.0) * #subtitleFull)
			Subtitle.TextSize = subSize
			Subtitle.Size = UDim2.fromOffset(W, subSize + 6)
			Subtitle.Position = UDim2.fromOffset(W / 2, baseY + L * 0.78)
			if t >= 1.7 then
				local cursor = (t < 3.2 and math.floor(t * 6) % 2 == 0) and "_" or ""
				Subtitle.Text = subtitleFull:sub(1, typed) .. cursor
			end

			-- credits
			local credSize = math.clamp(H * 0.025, 10, 18)
			Credits.TextSize = credSize
			Credits.Size = UDim2.fromOffset(W, credSize + 6)
			Credits.Position = UDim2.fromOffset(W / 2, baseY + L * 0.78 + subSize + 12)
			Credits.TextTransparency = 1 - 0.85 * Clamp01((t - 2.8) / 0.5)
			credStroke.Transparency = Credits.TextTransparency

			-- loading bar
			local barW = math.min(W * 0.6, 460)
			local barH = math.clamp(H * 0.035, 14, 24)
			local barY = H * 0.78
			Bar.Position = UDim2.fromOffset(W / 2, barY)
			Bar.Size = UDim2.fromOffset(barW, barH)
			Bar.Visible = t >= 0.9
			local ltSize = math.clamp(H * 0.028, 11, 20)
			LoadText.TextSize = ltSize
			LoadPct.TextSize = ltSize
			LoadText.Size = UDim2.fromOffset(barW * 0.6, ltSize + 4)
			LoadPct.Size = UDim2.fromOffset(barW * 0.4, ltSize + 4)
			LoadText.Position = UDim2.fromOffset(W / 2 - barW / 2, barY - 4)
			LoadPct.Position = UDim2.fromOffset(W / 2 + barW / 2, barY - 4)
			LoadText.Visible = t >= 0.9
			LoadPct.Visible = t >= 0.9
			local prog = Clamp01((t - 1.0) / 3.9)
			prog = Clamp01(prog + math.sin(prog * math.pi * 6) * 0.012)
			local filled = math.floor(prog * BAR_BLOCKS + 0.5)
			for i, b in barBlocks do
				b.Visible = i <= filled
			end
			if prog >= 1 then
				LoadText.Text = (math.floor(t * 8) % 2 == 0) and "READY!" or ""
				LoadPct.Text = "100%"
			else
				local dots = string.rep(".", math.floor(t * 4) % 4)
				LoadText.Text = "LOADING" .. dots
				LoadPct.Text = math.floor(prog * 100) .. "%"
			end

			-- scroller
			local bandH = math.clamp(H * 0.07, 26, 56)
			local scSize = math.clamp(bandH * 0.5, 12, 26)
			Band.Position = UDim2.fromOffset(0, H - bandH)
			Band.Size = UDim2.fromOffset(W, bandH)
			Scroller.TextSize = scSize
			Scroller.Size = UDim2.fromOffset(scrollerWidthCache + 40, scSize + 6)
			if scrollerSizeCache ~= scSize then
				scrollerSizeCache = scSize
				local ok, ts = pcall(function()
					return TextService:GetTextSize(introMessage, scSize, Enum.Font.Arcade, Vector2.new(100000, 100000))
				end)
				scrollerWidthCache = ok and ts.X or (#introMessage * scSize * 0.6)
			end
			local scrollSpeed = (W + scrollerWidthCache) / (INTRO_LEN + 1.5)
			Scroller.Position = UDim2.new(0, W - t * scrollSpeed, 0.5, 1)

			-- flicker (tiny CRT brightness wobble)
			Flicker.BackgroundTransparency = 0.965 + math.random() * 0.03

			-- beat hit: glitch + shake
			if sinceBeat > 0 then
				for _, g in glitchStrips do
					if math.random() < 0.35 then
						g.Visible = true
						local gh = math.random(2, math.max(3, math.floor(H * 0.05)))
						g.Position = UDim2.fromOffset(0, math.random(0, math.max(1, math.floor(H - gh))))
						g.Size = UDim2.fromOffset(W, gh)
					else
						g.Visible = false
					end
				end
				if math.random() < 0.4 then
					Scene.Position = UDim2.fromOffset(math.random(-7, 7), math.random(-3, 3))
				end
			end

			-- white pulse on the beat + white-out at the end
			local pulse = (sinceBeat > 0) and (0.55 * math.exp(-sinceBeat * 14)) or 0
			local out = Clamp01((t - 4.9) / (INTRO_LEN - 4.9))
			WhiteFx.BackgroundTransparency = 1 - math.max(pulse, out)
		end
	end)

	if not introOk then
		warn("[Uhhhhhh] intro error: " .. tostring(introErr))
	end
	if Intro then
		Intro:Destroy()
	end
	UIMainFrame.BackgroundTransparency = 1
	local flash = Util.Instance("Frame", UIMainFrame)
	flash.AnchorPoint = Vector2.new(0, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.new(1, 1, 1)
	flash.BackgroundTransparency = 0
	flash.BorderSizePixel = 0
	flash.Interactable = false
	flash.ZIndex = 256
	TweenService:Create(flash, TweenInfo.new(1), {
		BackgroundTransparency = 1
	}):Play()
	Debris:AddItem(flash, 1)
end

SaveData.MuteUIMusic = not not SaveData.MuteUIMusic
SaveData.MuteReanimMusic = not not SaveData.MuteReanimMusic
SaveData.MuteUISound = not not SaveData.MuteUISound

if SaveData.MuteUIMusic then
	if SaveData.SkipIntro then
		UISound.Music.Volume = 0
	else
		TweenService:Create(UISound.Music, TweenInfo.new(3, Enum.EasingStyle.Linear), {
			Volume = 0
		}):Play()
	end
end

UISound.Click = Util.Instance("Sound", UIMainFrame)
UISound.Click.SoundId = "rbxassetid://118806752369227"
UISound.Click.Volume = 1
UISound.Click.PlaybackSpeed = 1
if SaveData.MuteUISound then
	UISound.Click.Volume = 0
end

local StylizedObjs = {}
local function Stylize(obj, options)
	options = options or {}
	Util.Instance("UICorner", obj).CornerRadius = UDim.new(0, 5)
	local Out = Util.Instance("UIStroke", obj)
	Out.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Out.Color = Color3.new(1, 1, 1)
	Out.LineJoinMode = Enum.LineJoinMode.Round
	Out.Thickness = 1
	Out.Transparency = 0
	Out.Enabled = true
	obj.BackgroundColor3 = Color3.new(0, 0, 0)
	local Glos = {}
	if options.Glow == true then
		local GloF = Util.Instance("Frame", UIMainFrame)
		Util.LinkDestroyI2I(obj, GloF)
		GloF.Interactable = false
		GloF.BackgroundTransparency = 1
		local function update()
			GloF.AnchorPoint = obj.AnchorPoint
			GloF.Position = obj.Position - Util.Vector2ToUDim2Offset((obj.AnchorPoint * 2 - Vector2.one) * 5)
			GloF.Size = obj.Size - UDim2.fromOffset(10, 10)
			GloF.Visible = obj.Visible
			GloF.ZIndex = obj.ZIndex - 2
		end
		update()
		obj.Changed:Connect(update)
		local tex = Util.GetCDNAsset("lightinursoul.graphic.png")
		for x=0, 2 do
			for y=0, 2 do
				local Glo = Util.Instance("ImageLabel", GloF)
				Glo.AnchorPoint = Vector2.new(1 - math.min(x, 1), 1 - math.min(y, 1))
				Glo.Position = UDim2.fromScale(math.max(x - 1, 0), math.max(y - 1, 0))
				Glo.Size = UDim2.new(1 - math.abs(x - 1), x == 1 and 0 or 32, 1 - math.abs(y - 1), y == 1 and 0 or 32)
				Glo.BackgroundTransparency = 1
				Glo.Image = tex
				Glo.ImageRectOffset = Vector2.new(math.min(x, 1) * 256, math.min(y, 1) * 256)
				Glo.ImageRectSize = Vector2.new(x == 1 and 0 or 256, y == 1 and 0 or 256)
				table.insert(Glos, Glo)
			end
		end
	end
	table.insert(StylizedObjs, {
		obj = obj,
		Out = Out,
		Glos = Glos,
		options = options,
	})
end
local ForceUIColor = nil
local ForceUIBGColor = nil
local function GetUIColor(t)
	if ForceUIColor then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = ForceUIColor:ToHSV()
		if s < 0.2 then
			v *= 0.8 + si * 0.2
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Util.LoopedHSV(t / 10, 0.8, 1)
end
local function GetUIBGColor(t)
	if ForceUIBGColor then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = ForceUIBGColor:ToHSV()
		if s < 0.2 then
			if v > 0.5 then
				v *= 0.95 + si * 0.05
			else
				v *= 1.05 + si * 0.05
			end
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Color3.new(0, 0, 0)
end
local UITextColor = Util.Instance("Color3Value")
UITextColor.Value = Color3.new(1, 1, 1)
local function RegisterTextLabel(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		obj.TextColor3 = UITextColor.Value
		Util.LinkDestroyI2C(obj, UITextColor.Changed:Connect(function(val)
			obj.TextColor3 = val
		end))
	end
	if obj:IsA("TextBox") then
		local h, s, v = UITextColor.Value:ToHSV()
		obj.TextColor3 = UITextColor.Value
		obj.PlaceholderColor3 = Color3.fromHSV(h, s, 0.5 + (v - 0.5) * 0.4)
		Util.LinkDestroyI2C(obj, UITextColor.Changed:Connect(function(val)
			h, s, v = val:ToHSV()
			obj.TextColor3 = val
			obj.PlaceholderColor3 = Color3.fromHSV(h, s, 0.5 + (v - 0.5) * 0.4)
		end))
	end
end
local function UpdateGrads(t)
	local c = GetUIColor(t)
	local bgc = GetUIBGColor(t)
	local h, s, v = bgc:ToHSV()
	local bgcd = Color3.fromHSV(h, s, v * 0.9)
	local h2, s2, v2 = c:ToHSV()
	local glc = c
	if v > v2 then
		glc = bgc
	end
	for _,grad in StylizedObjs do
		local obj, Out, Glos, options = grad.obj, grad.Out, grad.Glos, grad.options
		Out.Color = c
		if options.Depthed then
			obj.BackgroundColor3 = bgcd
		else
			obj.BackgroundColor3 = bgc
		end
		for _,v in Glos do
			v.ImageColor3 = glc
		end
	end
end
local function SetUITheme(index)
	local UIThemes = {
		-- RGB/Default
		{},
		-- ALONE
		{Fore = Color3.new(1, 1, 1), SndClick = "rbxassetid://81715128969224"},
		-- Oxide
		{Fore = Color3.fromRGB(49, 203, 233), Back = Color3.fromRGB(38, 38, 38), Text = Color3.fromRGB(49, 203, 233)},
		-- Patchma-like
		{Fore = Color3.new(0.0941177, 0.317647, 0.878431), Text = Color3.new(0.560784, 0.560784, 0.560784)},
		-- Genesis V4 - Neptunian V
		{Fore = Color3.fromHex("7733FF"), Back = Color3.fromHex("161330"), SndClick = "rbxassetid://80526571264304"},
		-- Crimson
		{Fore = Color3.new(0.9, 0, 0), Back = Color3.new(0.05, 0, 0)},
		-- r/masterhacker
		{Fore = Color3.new(0, 1, 0), Text = Color3.new(0, 1, 0)},
		-- Homer simpson
		{Fore = Color3.new(0, 0, 0), Back = Color3.new(1, 0.95, 0), Text = Color3.new(0, 0, 0)},
		-- Immortality Lord
		{Fore = Color3.new(0.1, 0.1, 0.1), Text = Color3.new(1, 1, 1)},
		-- RGB LIGHT
		{Back = Color3.new(1, 1, 1), Text = Color3.new(0, 0, 0)},
		-- ALONE LIGHT
		{Fore = Color3.new(0, 0, 0), Back = Color3.new(1, 1, 1), Text = Color3.new(0, 0, 0), SndClick = "rbxassetid://81715128969224"},
		-- ROSR
		{Fore = Color3.new(0, 0, 0), Back = Color3.new(1, 0.6, 0)},
		-- FastTracker II Blue
		{Fore = Color3.fromHex("333780"), Back = Color3.fromHex("666EFF"), Text = Color3.new(1, 1, 1)},
		-- Cherry Blossom
		{Fore = Color3.fromHex("75284B"), Back = Color3.fromHex("F7ABE8"), Text = Color3.fromHex("75284B")},
		-- Cherry Blossom Inverted
		{Fore = Color3.fromHex("F7ABE8"), Back = Color3.fromHex("75284B"), Text = Color3.new(1, 1, 1)},
		-- Tommorow Night 80s
		{Fore = Color3.fromHex("272727"), Back = Color3.fromHex("2D2D2D"), Text = Color3.fromHex("BEBEBE"), SndClick = "rbxassetid://86097124503088"},
	}
	local theme = {nil, nil, Color3.new(1, 1, 1), "rbxassetid://118806752369227"}
	local function processtable(t)
		if typeof(t.Fore) == "Color3" then
			theme[1] = t.Fore
		end
		if typeof(t.Back) == "Color3" then
			theme[2] = t.Back
		end
		if typeof(t.Text) == "Color3" then
			theme[3] = t.Text
		end
		if typeof(t.Fore) == "string" then
			theme[1] = Color3.fromHex(t.Fore)
		end
		if typeof(t.Back) == "string" then
			theme[2] = Color3.fromHex(t.Back)
		end
		if typeof(t.Text) == "string" then
			theme[3] = Color3.fromHex(t.Text)
		end
		if typeof(t.Text) == "string" then
			theme[3] = Color3.fromHex(t.Text)
		end
		if typeof(t.SndClick) == "string" then
			theme[4] = t.SndClick
		end
	end
	if index == #UIThemes + 1 then
		if type(_G.UhhhhhhTheme) == "table" and getmetatable(_G.UhhhhhhTheme) == nil then
			processtable(_G.UhhhhhhTheme)
			SaveData.UIThemeUserDefined = {
				Fore = theme[1] and theme[1]:ToHex(),
				Back = theme[2] and theme[2]:ToHex(),
				Text = theme[3] and theme[3]:ToHex() or "FFFFFF",
				SndClick = theme[4],
			}
		elseif type(SaveData.UIThemeUserDefined) == "table" then
			processtable(SaveData.UIThemeUserDefined)
		end
	elseif UIThemes[index] then
		processtable(UIThemes[index])
	end
	if theme then
		ForceUIColor = theme[1]
		ForceUIBGColor = theme[2]
		UITextColor.Value = theme[3]
		UISound.Click.SoundId = theme[4]
	end
end
SaveData.UITheme = SaveData.UITheme or 1
SetUITheme(SaveData.UITheme)

local CracktroFrameText = "Uhhhhhh Reanimate V" .. UhhhhhhVersion
local UIMainWindow, WindowContent do
	UIMainWindow = Util.Instance("Frame", UIMainFrame)
	UIMainWindow.Active = true
	UIMainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
	UIMainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
	UIMainWindow.Size = UDim2.new(0, 360, 0, 240)
	UIMainWindow.BackgroundTransparency = 0
	UIMainWindow.BackgroundColor3 = Color3.new(1, 1, 1)
	UIMainWindow.BorderSizePixel = 0
	Stylize(UIMainWindow, {
		Glow = true
	})
	local _clicksndclicked = false
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			_clicksndclicked = false
		end
	end)
	local function _registerclicksnd(v)
		if v:GetAttribute("ClickSnd") then return end
		v:SetAttribute("ClickSnd", true)
		v.InputBegan:Connect(function(input)
			if _clicksndclicked then return end
			if input.UserInputState ~= Enum.UserInputState.Begin then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				UISound.Click:Play()
				_clicksndclicked = true
			end
		end)
	end
	_registerclicksnd(UIMainWindow)
	UIMainWindow.DescendantAdded:Connect(function(v)
		if v:IsA("GuiObject") then
			_registerclicksnd(v)
		end
	end)
	
	local TopBarFrame = Util.Instance("Frame", UIMainWindow)
	TopBarFrame.Position = UDim2.new(0, 0, 0, 0)
	TopBarFrame.Size = UDim2.new(1, 0, 0, 30)
	TopBarFrame.BackgroundTransparency = 0
	TopBarFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	TopBarFrame.BorderSizePixel = 0
	TopBarFrame.ClipsDescendants = true
	TopBarFrame.ZIndex = 1
	Stylize(TopBarFrame)
	
	local TopBarText = Util.Instance("TextLabel", TopBarFrame)
	TopBarText.AnchorPoint = Vector2.new(0, 0.5)
	TopBarText.Position = UDim2.new(0, 8, 0.5, 0)
	TopBarText.Size = UDim2.new(1, -35, 1, 0)
	TopBarText.BackgroundTransparency = 1
	TopBarText.ClipsDescendants = true
	TopBarText.Font = Enum.Font.Code
	TopBarText.TextColor3 = Color3.new(1, 1, 1)
	TopBarText.TextSize = 20
	TopBarText.TextXAlignment = Enum.TextXAlignment.Left
	TopBarText.Text = "Uhhhhhh Reanimate | v" .. UhhhhhhVersion
	TopBarText.RichText = true
	RegisterTextLabel(TopBarText)
	Util.ForceTextSize(TopBarText)
	if (SaveData.SkipIntro and math.random(2) == 1) or os.date("%m %d") ~= "04 01" then
		local quotes = {
			"Ohhhhhh Re-create | v" .. UhhhhhhVersion,
			"jumpscare",
			"you'll never see it coming",
			Player.Name .. "'s Uhhhhhh Session",
			"genesis hat collide releaser admin gui",
			"Delta Executor",
			"optimise the optimised",
			":troll:",
			"solara executor",
			"wait a minute smth aint right",
			"gta6 releaser",
			"HD Admin",
			"The Return Of STEVE's Roserika",
			"HI",
			"<font color=\"#00DDFF\">Oxide</font> Version 67",
			"currentangle v5",
			"patchma hub by <font color=\"#0000FF\">MyWorld</font>",
			"Genesis FE with extra steps",
			"Gugu Gaga",
			"Half Life 3 Releaser",
			"hatdrop hub",
			"uhhhh hub",
			"Emperyan Reanimate",
			"<font color=\"#0000FF\">IM BLUE BADA DEE BADA DIE</font>",
			"Delta Reanimate | v" .. UhhhhhhVersion,
		}
		if os.date("%m") == "12" and math.random(4) == 1 then
			quotes = {
				"ho ho ho",
				"dess from deltarune",
				"jesus christmas",
				"Happy Xmas, " .. Player.Name,
				"Razor1911 says... SOCIALIZE!",
				"UHHHHHHHHHHHHHHHHHHHHHHHHHHHH",
				"its cold outside get in here",
				"christmas tree builder",
				"UHHHH]",
			}
		end
		if os.date("%m") == "01" and math.random(4) == 1 then
			quotes = {
				"new year new me",
				"HAVE A HAPPY NEW YEAR",
				"A NEW YEAR??",
				"New Years, " .. Player.Name,
				"did u explode yet?",
				"KEEP YER KIDS SAFE FROM FIREWORK",
				"kaboom? yes rico, kaboom.",
			}
		end
		local aprilfools = os.date("%m") == "04 01"
		if aprilfools then
			local troll = math.random(3)
			if troll == 1 then
				CracktroFrameText = "Oxide Reanimation V67"
				quotes = {"<font color=\"#00DDFF\">Oxide</font>   Reanimation"}
				SetUITheme(3)
			end
			if troll == 2 then
				CracktroFrameText = "patchma hub V67"
				quotes = {"<font color=\"#0000FF\">patchma hub</font> by MyWorld"}
				SetUITheme(4)
			end
			if troll == 3 then
				CracktroFrameText = "Genesis V4 but better"
				quotes = {"<font color=\"#CC11FF\">Genesis V4 - Neptunian V</font>"}
				SetUITheme(5)
			end
		end
		TopBarText.Text = quotes[math.random(1, #quotes)]
		if not aprilfools then
			task.delay(2, function()
				TopBarText.Text = "Uhhhhhh Reanimate | v" .. UhhhhhhVersion
			end)
		end
	end
	
	local TopBarClose = Util.Instance("TextButton", TopBarFrame)
	TopBarClose.AnchorPoint = Vector2.new(1, 0)
	TopBarClose.Position = UDim2.new(1, 0, 0, 0)
	TopBarClose.Size = UDim2.new(0, 30, 1, 0)
	TopBarClose.BackgroundTransparency = 1
	TopBarClose.Text = ""
	do
		local A = Util.Instance("Frame", TopBarClose)
		A.AnchorPoint = Vector2.new(0.5, 0.5)
		A.Position = UDim2.new(0.5, 0, 0.5, 0)
		A.Size = UDim2.new(0, 16, 0, 2)
		A.Rotation = 0
		A.BackgroundTransparency = 0
		A.BackgroundColor3 = UITextColor.Value
		A.BorderSizePixel = 0
		A.Name = "A"
		A = Util.Instance("Frame", A)
		A.AnchorPoint = Vector2.new(0.5, 0.5)
		A.Position = UDim2.new(0.5, 0, 0.5, 0)
		A.Size = UDim2.new(0, 2, 0, 0)
		A.Rotation = 0
		A.BackgroundTransparency = 0
		A.BackgroundColor3 = UITextColor.Value
		A.BorderSizePixel = 0
		A.Name = "B"
		UITextColor.Changed:Connect(function(val)
			TopBarClose.A.BackgroundColor3 = val
			TopBarClose.A.B.BackgroundColor3 = val
		end)
	end
	
	WindowContent = Util.Instance("Frame", UIMainWindow)
	WindowContent.Position = UDim2.new(0, 0, 0, 30)
	WindowContent.Size = UDim2.new(1, 0, 1, -35)
	WindowContent.BackgroundTransparency = 1
	WindowContent.ClipsDescendants = true
	WindowContent.ZIndex = 0
	
	local MainWindowClosed = false
	local MainWindowTweening = false
	local MainWindowPosOpen = nil
	local MainWindowPosClose = nil
	if SaveData.WindowClosedPosition then
		MainWindowPosClose = UDim2.new(unpack(SaveData.WindowClosedPosition))
	end
	if MainWindowPosClose and (MainWindowPosClose.X.Scale < 0 or MainWindowPosClose.X.Scale > 1) then
		MainWindowPosClose = nil
	end
	if MainWindowPosClose and (MainWindowPosClose.Y.Scale < 0 or MainWindowPosClose.Y.Scale > 1) then
		MainWindowPosClose = nil
	end
	TopBarClose.Activated:Connect(function()
		if MainWindowTweening then return end
		MainWindowTweening = true
		MainWindowClosed = not MainWindowClosed
		if MainWindowClosed then
			MainWindowPosOpen = UIMainWindow.Position
			TweenService:Create(UIMainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = MainWindowPosClose,
				Size = UDim2.fromOffset(112, 30)
			}):Play()
			TweenService:Create(TopBarClose.A, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Rotation = 180
			}):Play()
			TweenService:Create(TopBarClose.A.B, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 2, 0, 16)
			}):Play()
			task.delay(0.6, function()
				WindowContent.Visible = false
				MainWindowTweening = false
			end)
		else
			WindowContent.Visible = true
			MainWindowPosClose = UIMainWindow.Position
			SaveData.WindowClosedPosition = {MainWindowPosClose.X.Scale, MainWindowPosClose.X.Offset, MainWindowPosClose.Y.Scale, MainWindowPosClose.Y.Offset}
			TweenService:Create(UIMainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = MainWindowPosOpen,
				Size = UDim2.fromOffset(360, 240)
			}):Play()
			TweenService:Create(TopBarClose.A, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Rotation = 0
			}):Play()
			TweenService:Create(TopBarClose.A.B, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 2, 0, 0)
			}):Play()
			task.delay(0.6, function()
				MainWindowTweening = false
			end)
		end
		WindowContent.Active = not MainWindowClosed
		WindowContent.Interactable = not MainWindowClosed
	end)
	
	local dragref = nil
	local offset = Vector2.new(0, 0)
	TopBarFrame.InputBegan:Connect(function(input)
		if dragref then return end
		if input.UserInputState ~= Enum.UserInputState.Begin then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			WindowContent.Interactable = false
			local screen = Util.GetScreenSize()
			local ch = (Vector2.new(input.Position.X, input.Position.Y) + SCREENGUI.AbsolutePosition) / screen
			offset = Util.UDim2ToVector2Scale(UIMainWindow.Position) - ch
			dragref = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragref then
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and dragref == input) then
				local screen = Util.GetScreenSize()
				local ch = (Vector2.new(input.Position.X, input.Position.Y) + SCREENGUI.AbsolutePosition) / screen
				local pos = ch + offset
				local dowsize = Util.UDim2ToVector2Offset(UIMainWindow.Size)
				local imjollx = (dowsize.X * 0.5 - 100) / screen.X
				local imjolly = dowsize.Y * -0.5 / screen.Y
				local boxy = 31 / screen.Y
				pos = Vector2.new(
					math.clamp(pos.X, -imjollx, 1 + imjollx),
					math.clamp(pos.Y, -imjolly, 1 - imjolly - boxy)
				)
				UIMainWindow.Position = Util.Vector2ToUDim2Scale(pos)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragref and dragref == input then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				WindowContent.Interactable = true
				dragref = nil
			end
		end
	end)
end

local _funcrefreshes = {}
local function AddToRenderStep(func, linkto)
	table.insert(_funcrefreshes, func)
	if linkto then
		linkto.Destroying:Connect(function()
			local i = table.find(_funcrefreshes, func)
			if i then
				table.remove(_funcrefreshes, i)
			end
		end)
	end
	return func
end
local _totalrendertime = 0
RunService:BindToRenderStep("Uhhhhhh_Render" .. Util.RandomString(), Enum.RenderPriority.Last.Value - 69, function(dt)
	_totalrendertime += dt
	UpdateGrads(_totalrendertime)
	WindowContent.Visible = UIMainWindow.Size.Y.Offset > 35
	for _,func in _funcrefreshes do
		local s, e = pcall(func, _totalrendertime, dt)
		if not s then warn(e) end
	end
end)

do
	local uinotif = {
		Text = "hi",
		Progress = -1,
		LastNotif = -67,
		Animation = 1,
		ProgressSm = 0,
	}
	Util.UINotify = function(text, prog)
		uinotif.Text, uinotif.Progress = text, prog or 1
		uinotif.LastNotif = _totalrendertime
	end
	local UINotifyFrame = Instance.new("Frame", UIMainFrame)
	UINotifyFrame.AnchorPoint = Vector2.new(0.5, 0)
	UINotifyFrame.Position = UDim2.new(0.5, 0, 1, 10)
	UINotifyFrame.Size = UDim2.new(0, 300, 0, 30)
	UINotifyFrame.BackgroundTransparency = 0
	UINotifyFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	UINotifyFrame.BorderSizePixel = 0
	UINotifyFrame.Visible = false
	UINotifyFrame.ZIndex = -1
	Stylize(UINotifyFrame, {
		Glow = true,
	})
	local Progress = Instance.new("Frame", UINotifyFrame)
	Progress.AnchorPoint = Vector2.new(0.5, 0)
	Progress.Position = UDim2.new(0.5, 0, 0, 0)
	Progress.Size = UDim2.new(1, -10, 1, 0)
	Progress.BackgroundTransparency = 1
	Progress.BackgroundColor3 = Color3.new(1, 1, 1)
	Progress.BorderSizePixel = 0
	local ProgressTop = Instance.new("Frame", Progress)
	ProgressTop.AnchorPoint = Vector2.new(0.5, 0)
	ProgressTop.Position = UDim2.new(0.5, 0, 0, 0)
	ProgressTop.Size = UDim2.new(0, 0, 0, 4)
	ProgressTop.BackgroundTransparency = 0
	ProgressTop.BackgroundColor3 = Color3.new(1, 1, 1)
	ProgressTop.BorderSizePixel = 0
	local ProgressBot = Instance.new("Frame", Progress)
	ProgressBot.AnchorPoint = Vector2.new(0.5, 1)
	ProgressBot.Position = UDim2.new(0.5, 0, 1, 0)
	ProgressBot.Size = UDim2.new(0, 0, 0, 4)
	ProgressBot.BackgroundTransparency = 0
	ProgressBot.BackgroundColor3 = Color3.new(1, 1, 1)
	ProgressBot.BorderSizePixel = 0
	local NotifyText = Util.Instance("TextLabel", UINotifyFrame)
	NotifyText.AnchorPoint = Vector2.new(0.5, 0.5)
	NotifyText.Position = UDim2.new(0.5, 0, 0.5, 0)
	NotifyText.Size = UDim2.new(1, 0, 0, 20)
	NotifyText.BackgroundTransparency = 1
	NotifyText.ClipsDescendants = true
	NotifyText.Font = Enum.Font.Code
	NotifyText.TextColor3 = Color3.new(1, 1, 1)
	NotifyText.TextSize = 18
	NotifyText.TextXAlignment = Enum.TextXAlignment.Center
	NotifyText.Text = ""
	RegisterTextLabel(NotifyText)
	AddToRenderStep(function(t, dt)
		if t - uinotif.LastNotif < 4 or uinotif.Progress < 1 then
			uinotif.Animation = math.max(0, uinotif.Animation - dt * 2)
		else
			uinotif.Animation = math.min(1, uinotif.Animation + dt * 2)
		end
		if uinotif.Animation < 1 then
			UINotifyFrame.Visible = true
			UINotifyFrame.Position = UIMainWindow.Position + UDim2.new(0, 0, 0, UIMainWindow.Size.Y.Offset / 2 + 10 + math.pow(uinotif.Animation, 3) * -40)
			if uinotif.Progress >= 1 then
				Progress.BackgroundTransparency = math.min(t - uinotif.LastNotif, 0.5) * 2 * 0.3 + 0.7
			else
				Progress.BackgroundTransparency = 1
			end
			local c = GetUIColor(t)
			local s = math.sin(t * 3) * 0.5 + 0.5
			if uinotif.Progress > 0 then
				uinotif.ProgressSm = uinotif.Progress + (uinotif.ProgressSm - uinotif.Progress) * math.exp(-16 * dt)
				ProgressTop.BackgroundTransparency = 0
				ProgressBot.BackgroundTransparency = 0
				ProgressTop.Size = UDim2.new(uinotif.ProgressSm, 0, 0, 4)
				ProgressBot.Size = UDim2.new(uinotif.ProgressSm, 0, 0, 4)
			else
				uinotif.ProgressSm = 1
				ProgressTop.BackgroundTransparency = s
				ProgressBot.BackgroundTransparency = s
				ProgressTop.Size = UDim2.new(1, 0, 0, 4)
				ProgressBot.Size = UDim2.new(1, 0, 0, 4)
			end
			ProgressTop.BackgroundColor3 = c
			ProgressBot.BackgroundColor3 = c
			NotifyText.Text = uinotif.Text
		else
			UINotifyFrame.Visible = false
		end
	end, UINotifyFrame)
end

local CracktroFrame = Util.Instance("Frame", WindowContent)
CracktroFrame.Active = true
CracktroFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CracktroFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CracktroFrame.Size = UDim2.new(0, 360, 0, 205)
CracktroFrame.BackgroundTransparency = 0
CracktroFrame.BackgroundColor3 = Color3.new(0, 0, 0)
CracktroFrame.BorderSizePixel = 1
CracktroFrame.BorderColor3 = Color3.new(1, 1, 1)
CracktroFrame.ZIndex = 10
CracktroFrame.ClipsDescendants = true
AddToRenderStep(function(t)
	CracktroFrame.BorderColor3 = GetUIColor(t)
	CracktroFrame.BackgroundColor3 = GetUIBGColor(t)
end, CracktroFrame)

do -- homepage
	local TriforceClip = Util.Instance("CanvasGroup", CracktroFrame)
	TriforceClip.Position = UDim2.new(0, 0, 0, 0)
	TriforceClip.Size = UDim2.new(1, 0, 1, 0)
	TriforceClip.BackgroundTransparency = 1
	TriforceClip.ZIndex = 0

	local Glowy = Util.Instance("ImageLabel", CracktroFrame)
	Glowy.AnchorPoint = Vector2.new(0.5, 0.5)
	Glowy.Position = UDim2.new(0.5, 0, 0.5, 0)
	Glowy.Size = UDim2.new(0, 260, 0, 260)
	Glowy.BackgroundTransparency = 1
	Glowy.Image = Util.GetCDNAsset("lightinursoul.graphic.png")
	Glowy.ImageColor3 = UITextColor.Value
	Glowy.ImageTransparency = 0.7
	Glowy.ZIndex = -2

	local Triforce = Util.MakeTriforce(3, Color3.new(1, 0.7, 0), 0)
	Triforce.AnchorPoint = Vector2.new(0.5, 0.5)
	Triforce.Position = UDim2.new(0.5, 0, 0.5, 0)
	Triforce.Size = UDim2.new(0, 160, 0, 160)
	Triforce.Parent = TriforceClip

	local particles = {}
	local ps = 128
	local psc = Color3.new(1, 0.9, 0)
	for i=1, ps do
		local r = (i / ps) * 2 * math.pi
		local p = Util.Instance("Frame", CracktroFrame)
		p.AnchorPoint = Vector2.new(0.5, 0.5)
		p.Size = UDim2.fromOffset(2, 2)
		p.BackgroundColor3 = psc
		p.BackgroundTransparency = 0
		p.BorderSizePixel = 0
		p.ZIndex = -1
		p.Visible = false
		table.insert(particles, {
			p, Vector2.new(math.sin(r), math.cos(r)) * 8,
			Vector2.new(math.random(-128, 128), math.random(-128, 128)),
			math.random() * 2 - 1, false, -1
		})
	end

	local trivel = 360
	local oldpbl = 0

	local text = Util.MakeText(CracktroFrameText)
	text.AnchorPoint = Vector2.new(0.5, 1)
	text.Position = UDim2.new(0.5, 0, 1, -25)
	text.ZIndex = 3
	text.Parent = CracktroFrame
	local text0 = Util.MakeText("Discord: discord.gg/NASNUKRBVM")
	text0.AnchorPoint = Vector2.new(0.5, 1)
	text0.Position = UDim2.new(0.5, 0, 1, -17)
	text0.ZIndex = 3
	text0.Parent = CracktroFrame
	local text1 = Util.MakeText("Made by STEVETHEREALONE :" .. (math.random() < 0.333 and "3" or (math.random() < 0.5 and "D" or "P")))
	text1.AnchorPoint = Vector2.new(0.5, 1)
	text1.Position = UDim2.new(0.5, 0, 1, -17)
	text1.ZIndex = 3
	text1.Parent = CracktroFrame
	local text2 = Util.MakeText("Click me to start!")
	text2.AnchorPoint = Vector2.new(0.5, 1)
	text2.Position = UDim2.new(0.5, 0, 1, -17)
	text2.ZIndex = 3
	text2.Parent = CracktroFrame
	Util.SetTextColor(text, UITextColor.Value, 0)
	Util.SetTextColor(text0, UITextColor.Value, 0)
	Util.SetTextColor(text1, UITextColor.Value, 0)
	Util.SetTextColor(text2, UITextColor.Value, 0)
	local quotes = {
		"\"EVERY CLIENT ORBITS A SERVER...\"",
		Player.Name .. ", how is your " .. os.date("%A") .. "?",
		"A great " .. os.date("%A") .. " today, eh?",
		"Hello, " .. Player.Name .. ".",
		"What makes you play at " .. os.date("%I %p") .. "?",
		"You are going to love Uhhhhhh, I just know it.",
		"This script is very \"verbose\".",
		"Written mostly on a mobile phone.",
		"I am pretty new in this community! :D",
		"\"Dreams come true!\"",
		"Idea originated from a dream.",
		"If you love this program, join my Discord!",
		"boredgal was here..",
		"gugu gaga ultimate",
		"Kleiner me to start!",
		"Spongebob squarepants",
		"I'm a Razor 1911 'fan' btw!",
	}
	local text3 = nil
	local text3mustchange = false
	local function changequote()
		if text3 then text3:Destroy() end
		text3 = Util.MakeText(quotes[math.random(1, #quotes)])
		text3.AnchorPoint = Vector2.new(0.5, 1)
		text3.Position = UDim2.new(0.5, 0, 1, -17)
		text3.ZIndex = 3
		text3.Parent = CracktroFrame
		Util.SetTextColor(text3, UITextColor.Value, 0)
	end
	changequote()
	UITextColor.Changed:Connect(function(val)
		Util.SetTextColor(text, val, 0)
		Util.SetTextColor(text0, val, 0)
		Util.SetTextColor(text1, val, 0)
		Util.SetTextColor(text2, val, 0)
		Util.SetTextColor(text3, val, 0)
	end)

	local PositionProcessor = {
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local d = pos.Magnitude
			if d > 0 then
				local r = math.atan2(pos.X / d, pos.Y / d)
				local a = math.pi * 0.375
				local out = Vector2.new(math.sin(r + a), math.cos(r + a))
				local tp = out * (40 + pbl / 12)
				local tv = (tp - pos) * 2
				vel = tv:Lerp(vel, math.exp(-2 * dt))
				if math.random() < 0.01 then
					vel += Vector2.new(math.random(-64, 64), math.random(-64, 64))
				end
				if spike > 64 then
					vel += out * 64 * math.random()
				end
				pos += vel * dt
			else
				pos += Vector2.new(0, 10)
			end
			v[2], v[3] = pos, vel
			return Vector3.new(zind * pos.Magnitude / 6, pos.Y, pos.X)
		end,
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local a = i / ps
			local s = (a * 6) % 1
			local r = (a + s / 8) * 2 * math.pi + os.clock() * 2 + zind * math.pi * 0.125 * (pbl / 200) * (1 - s)
			pos = Vector2.new(math.sin(r), math.cos(r)) * s * (100 + pbl / 15)
			v[2], v[3] = pos, Vector2.zero
			return Vector3.new(0, pos.Y, pos.X)
		end,
		function(i, v, dt, pbl, spike)
			local inst, pos, vel, zind, lvis, lzind = unpack(v)
			local a = i / ps
			local b = 1 / 3
			local c = math.sqrt(3) / 2
			local d = {
				{Vector2.new(0, b + c), Vector2.new(-0.5, b)},
				{Vector2.new(-0.5, b), Vector2.new(-1, b - c)},
				{Vector2.new(-1, b - c), Vector2.new(0, b - c)},
				{Vector2.new(0, b - c), Vector2.new(1, b - c)},
				{Vector2.new(1, b - c), Vector2.new(0.5, b)},
				{Vector2.new(0.5, b), Vector2.new(0, b - c)},
				{Vector2.new(0, b - c), Vector2.new(-0.5, b)},
				{Vector2.new(-0.5, b), Vector2.new(0.5, b)},
				{Vector2.new(0.5, b), Vector2.new(0, b + c)},
			}
			local t = a * #d
			local i = math.floor(t) + 1
			local u = t % 1
			if i > #d then
				i = #d
				u = 1
			end
			pos = d[i][1]:Lerp(d[i][2], u) * 150
			local r = os.clock() * 2
			pos = Vector2.new(
				pos.X * math.cos(r) - pos.Y * math.sin(r),
				pos.X * math.sin(r) + pos.Y * math.cos(r)
			)
			v[2], v[3] = pos, Vector2.zero
			return Vector3.new(0, pos.Y, pos.X)
		end,
	}
	local currentprocessor = 1

	AddToRenderStep(function(t, dt)
		if Util.IsGuiVisible(CracktroFrame) then
			local pp = PositionProcessor[currentprocessor]
			local CracktroFrameAbsoluteSize = CracktroFrame.AbsoluteSize
			Glowy.ImageColor3 = UITextColor.Value
			Glowy.ImageTransparency = 0.75 + math.sin(((os.clock() / 10) % 2) * math.pi) * 0.05
			local pbl = UISound.Music.PlaybackLoudness
			local spike = math.max(0, (pbl - oldpbl) - 16)
			oldpbl = pbl
			local trivelt = pbl * 2 * dt
			trivel = trivelt + (trivel - trivelt) * math.exp(-8 * dt)
			Triforce.Rotation = (Triforce.Rotation + trivel) % 360
			local ring = CFrame.Angles(
				0,
				math.cos(((t / 5) % 2) * math.pi) * math.pi * 0.5,
				(1 - math.cos(((t / 7) % 2) * math.pi)) * math.pi * 0.5
			)
			local fov = 220
			for i,v in particles do
				local inst, pos, vel, zind, lvis, lzind = unpack(v)
				local sp = ring:VectorToWorldSpace(pp(i, v, dt, pbl, spike))
				local z = sp.Z
				local sc = fov / (z + fov)
				sp = Vector2.new(sp.X, sp.Y) * sc
				local nvis, nzind = lvis, lzind
				if z > 1 - fov then
					inst.Position = Util.Vector2ToUDim2Offset(sp + CracktroFrameAbsoluteSize / 2)
					inst.Size = UDim2.fromOffset(sc * 2.5, sc * 2.5)
					--inst.BackgroundColor3 = psc:Lerp(Color3.new(0, 0, 0), math.clamp(z / (fov * 2), 0, 1))
					nvis = true
					if z > 0 then
						nzind = -1
					else
						nzind = 1
					end
				else
					nvis = false
				end
				if lvis ~= nvis then
					inst.Visible = nvis
					v[5] = nvis
				end
				if lzind ~= nzind then
					inst.ZIndex = nzind
					v[6] = nzind
				end
			end
			local textsel = t % 9
			if IsUhhhhhhFullyLoaded then
				textsel = t % 12
			end
			textsel //= 3
			if text3mustchange ~= (textsel == 3) then
				text3mustchange = (textsel == 3)
				if text3mustchange then changequote() end
			end
			if textsel == 0 then
				text0.Visible = true
				text1.Visible = false
				text2.Visible = false
				text3.Visible = false
			elseif textsel == 1 then
				text0.Visible = false
				text1.Visible = true
				text2.Visible = false
				text3.Visible = false
			elseif textsel == 2 then
				text0.Visible = false
				text1.Visible = false
				text2.Visible = false
				text3.Visible = true
			else
				text0.Visible = false
				text1.Visible = false
				text2.Visible = true
				text3.Visible = false
			end
		else
			currentprocessor = math.random(1, #PositionProcessor)
		end
	end, CracktroFrame)
end
task.wait()

local UI = {}
function UI.CreatePage()
	local Frame = Util.Instance("ScrollingFrame", WindowContent)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 205)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 1
	Frame.BorderColor3 = Color3.new(1, 1, 1)
	Frame.Visible = true
	Frame.ZIndex = 0
	Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	Frame.ClipsDescendants = true
	AddToRenderStep(function(t)
		Frame.BorderColor3 = GetUIColor(t)
		Frame.BackgroundColor3 = GetUIBGColor(t)
	end, Frame)
	Frame.ScrollingDirection = Enum.ScrollingDirection.Y
	Frame.ScrollBarThickness = 3
	Frame.ElasticBehavior = Enum.ElasticBehavior.Always
	Frame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Frame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Frame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Frame.ScrollBarImageTransparency = 0.5
	Frame.ScrollBarImageColor3 = UITextColor.Value
	Util.LinkDestroyI2C(Frame, UITextColor.Changed:Connect(function(val)
		Frame.ScrollBarImageColor3 = val
	end))
	local Padding = Util.Instance("UIPadding", Frame)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 0)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", Frame)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	return Frame
end
function UI.CreateText(parent, text, size, alignment)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 1, -margin + 1)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = alignment
	Text.TextYAlignment = Enum.TextYAlignment.Top
	Text.TextWrapped = true
	Text.TextSize = size
	RegisterTextLabel(Text)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(Text.ContentText, Text.TextSize, Text.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin)
	end
	Text.Text = text
	update()
	Text.Changed:Connect(update)
	return Text
end
function UI.CreateSeparator(parent)
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 7)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Sep = Util.Instance("Frame", Container)
	Sep.AnchorPoint = Vector2.new(0.5, 0.5)
	Sep.Position = UDim2.new(0.5, 0, 0.5, 0)
	Sep.Size = UDim2.new(1, -8, 0, 1)
	Sep.BackgroundColor3 = UITextColor.Value
	Sep.BackgroundTransparency = 0.8
	Sep.BorderSizePixel = 0
	Util.LinkDestroyI2C(Sep, UITextColor.Changed:Connect(function(val)
		Sep.BackgroundColor3 = val
	end))
end
function UI.CreateButton(parent, text, size)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Button = Util.Instance("TextButton", Container)
	Button.AnchorPoint = Vector2.new(0, 0)
	Button.Position = UDim2.new(0, margin, 0, margin // 2)
	Button.Size = UDim2.new(1, margin * -2, 1, -margin)
	Button.BackgroundTransparency = 0
	Button.BackgroundColor3 = Color3.new(1, 1, 1)
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.AutoButtonColor = true
	local ButtonText = Util.Instance("TextLabel", Button)
	ButtonText.AnchorPoint = Vector2.new(0, 0.5)
	ButtonText.Position = UDim2.new(0, 0, 0.5, 0)
	ButtonText.Size = UDim2.new(1, 0, 1, -margin)
	ButtonText.BackgroundTransparency = 1
	ButtonText.RichText = true
	ButtonText.Font = Enum.Font.Code
	ButtonText.TextColor3 = Color3.new(1, 1, 1)
	ButtonText.TextTransparency = 0
	ButtonText.TextXAlignment = Enum.TextXAlignment.Center
	ButtonText.TextYAlignment = Enum.TextYAlignment.Center
	ButtonText.TextWrapped = true
	ButtonText.TextSize = size
	RegisterTextLabel(ButtonText)
	Stylize(Button)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(ButtonText.ContentText, ButtonText.TextSize, ButtonText.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin * 2)
	end
	ButtonText.Text = text
	update()
	ButtonText.Changed:Connect(update)
	return Button, ButtonText
end
function UI.CreateSwitch(parent, text, value)
	local margin = 5
	local switchsize = 50
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 10)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Button = Util.Instance("TextButton", Container)
	Button.AnchorPoint = Vector2.new(0, 0)
	Button.Position = UDim2.new(0, 0, 0, 0)
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	local ButtonText = Util.Instance("TextLabel", Button)
	ButtonText.AnchorPoint = Vector2.new(0, 0)
	ButtonText.Position = UDim2.new(0, margin, 0, 0)
	ButtonText.Size = UDim2.new(1, margin * -3 - switchsize, 1, 0)
	ButtonText.BackgroundTransparency = 1
	ButtonText.RichText = true
	ButtonText.Font = Enum.Font.Code
	ButtonText.TextColor3 = Color3.new(1, 1, 1)
	ButtonText.TextTransparency = 0
	ButtonText.TextXAlignment = Enum.TextXAlignment.Left
	ButtonText.TextYAlignment = Enum.TextYAlignment.Center
	ButtonText.TextWrapped = true
	ButtonText.TextSize = 20
	RegisterTextLabel(ButtonText)
	local function update()
		local x = parent.AbsoluteSize.X
		local size = TextService:GetTextSize(ButtonText.ContentText, ButtonText.TextSize, ButtonText.Font, Vector2.new(x - margin * 3 - switchsize, math.huge))
		Container.Size = UDim2.new(1, 0, 0, math.max(35, size.Y))
	end
	ButtonText.Text = text
	update()
	ButtonText.Changed:Connect(update)
	local Switch = Util.Instance("Frame", Container)
	Switch.AnchorPoint = Vector2.new(1, 0.5)
	Switch.Position = UDim2.new(1, -margin, 0.5, 0)
	Switch.Size = UDim2.new(0, 25, 0, 25)
	Switch.BackgroundTransparency = 0
	Switch.BackgroundColor3 = Color3.new(0, 0, 0)
	Switch.BorderSizePixel = 0
	Util.Instance("UICorner", Switch).CornerRadius = UDim.new(0, 5)
	Stylize(Switch)
	local SwitchDot = Util.Instance("Frame", Switch)
	SwitchDot.AnchorPoint = Vector2.new(0.5, 0.5)
	SwitchDot.Position = UDim2.new(0.5, 0, 0.5, 0)
	SwitchDot.Size = UDim2.new(0, 19, 0, 19)
	SwitchDot.BackgroundTransparency = 0.2
	SwitchDot.BackgroundColor3 = UITextColor.Value
	SwitchDot.BorderSizePixel = 0
	Util.LinkDestroyI2C(SwitchDot, UITextColor.Changed:Connect(function(val)
		SwitchDot.BackgroundColor3 = val
	end))
	Util.Instance("UICorner", SwitchDot).CornerRadius = UDim.new(0, 2)
	local Lever = Util.Instance("BoolValue")
	Lever.Value = value
	local function updatesw()
		SwitchDot.Visible = Lever.Value
	end
	Lever.Changed:Connect(updatesw)
	updatesw()
	Button.Activated:Connect(function()
		Lever.Value = not Lever.Value
	end)
	return Lever, ButtonText
end
function UI.CreateTextbox(parent, text, placeholder, size)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65536)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Box = Util.Instance("Frame", Container)
	Box.AnchorPoint = Vector2.new(0, 0)
	Box.Position = UDim2.new(0, margin, 0, margin // 2)
	Box.Size = UDim2.new(1, margin * -2, 1, -margin)
	Box.BackgroundTransparency = 0
	Box.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	Box.BorderSizePixel = 0
	local BoxText = Util.Instance("TextBox", Box)
	BoxText.AnchorPoint = Vector2.new(0, 0.5)
	BoxText.Position = UDim2.new(0, 0, 0.5, 0)
	BoxText.Size = UDim2.new(1, 0, 1, -margin)
	BoxText.BackgroundTransparency = 1
	BoxText.Font = Enum.Font.Code
	BoxText.TextColor3 = Color3.new(1, 1, 1)
	BoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	BoxText.TextTransparency = 0
	BoxText.TextXAlignment = Enum.TextXAlignment.Center
	BoxText.TextYAlignment = Enum.TextYAlignment.Center
	BoxText.TextWrapped = true
	BoxText.TextSize = size
	BoxText.ClearTextOnFocus = false
	RegisterTextLabel(BoxText)
	BoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(Box, {
		Depthed = true,
	})
	local function update()
		local x = parent.AbsoluteSize.X
		if not BoxText.TextWrapped then
			x = math.huge
		end
		local t = BoxText.Text
		if t:len() == 0 then
			t = BoxText.PlaceholderText
		end
		local size = TextService:GetTextSize(t, BoxText.TextSize, BoxText.Font, Vector2.new(x - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, size.Y + margin * 2 + 2)
	end
	BoxText.Text = text
	BoxText.PlaceholderText = placeholder
	update()
	BoxText.Changed:Connect(update)
	return BoxText
end
function UI.CreateSlider(parent, text, value, min, max, step)
	min = min or 1
	max = max or 10
	step = math.abs(step or 0)
	assert(max > min)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 65)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.AnchorPoint = Vector2.new(0, 0)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 0, 35)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.TextWrapped = true
	Text.TextSize = 20
	Text.Text = text
	RegisterTextLabel(Text)
	local Box = Util.Instance("Frame", Container)
	Box.AnchorPoint = Vector2.new(1, 0)
	Box.Position = UDim2.new(1, -margin, 0, margin)
	Box.Size = UDim2.new(0, 80, 0, 35 - margin * 2)
	Box.BackgroundTransparency = 0
	Box.BackgroundColor3 = Color3.new(1, 1, 1)
	Box.BorderSizePixel = 0
	local BoxText = Util.Instance("TextBox", Box)
	BoxText.AnchorPoint = Vector2.new(0, 0.5)
	BoxText.Position = UDim2.new(0, 0, 0.5, 0)
	BoxText.Size = UDim2.new(1, 0, 1, -margin)
	BoxText.BackgroundTransparency = 1
	BoxText.Font = Enum.Font.Code
	BoxText.TextColor3 = Color3.new(1, 1, 1)
	BoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	BoxText.TextTransparency = 0
	BoxText.TextXAlignment = Enum.TextXAlignment.Center
	BoxText.TextYAlignment = Enum.TextYAlignment.Center
	BoxText.TextWrapped = true
	BoxText.TextSize = 15
	BoxText.ClearTextOnFocus = false
	RegisterTextLabel(BoxText)
	BoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(Box, {
		Depthed = true,
	})
	local SliderC = Util.Instance("TextButton", Container)
	SliderC.AnchorPoint = Vector2.new(0, 0)
	SliderC.Position = UDim2.new(0, 0, 0, 40)
	SliderC.Size = UDim2.new(1, 0, 0, 20)
	SliderC.BackgroundTransparency = 1
	SliderC.Text = ""
	SliderC.AutoButtonColor = true
	local SliderR = Util.Instance("Frame", SliderC)
	SliderR.AnchorPoint = Vector2.new(0.5, 0.5)
	SliderR.Position = UDim2.new(0.5, 0, 0.5, 0)
	SliderR.Size = UDim2.new(1, margin * -2 - 18, 0, 5)
	SliderR.BackgroundTransparency = 0
	SliderR.BackgroundColor3 = Color3.new(1, 1, 1)
	SliderR.BorderSizePixel = 0
	local SliderB = Util.Instance("Frame", SliderR)
	SliderB.AnchorPoint = Vector2.new(0.5, 0.5)
	SliderB.Position = UDim2.new(0, 0, 0.5, 0)
	SliderB.Size = UDim2.new(0, 18, 0, 18)
	SliderB.BackgroundTransparency = 0
	SliderB.BackgroundColor3 = Color3.new(1, 1, 1)
	SliderB.BorderSizePixel = 0
	SliderB.ZIndex = 2
	Stylize(SliderR, {
		Depthed = true,
	})
	Stylize(SliderB)
	local range = max - min
	if step > 0 then
		if range / step < 20 then
			local i = min + step
			while i < max do
				local snaps = Util.Instance("Frame", SliderR)
				snaps.AnchorPoint = Vector2.new(0.5, 0)
				snaps.Position = UDim2.new((i - min) / range, 0, 0, 1)
				snaps.Size = UDim2.new(0, 1, 0, 3)
				snaps.BackgroundTransparency = 0.5
				snaps.BackgroundColor3 = Color3.new(1, 1, 1)
				snaps.BorderSizePixel = 0
				i += step
			end
		end
	end
	local Select = Util.Instance("NumberValue")
	local function update()
		local str = string.format("%.3f", Select.Value)
		if str:find("%.") then
			while str:sub(-1) == "0" do
				str = str:sub(1, -2)
				if str:sub(-1) == "." then
					str = str:sub(1, -2)
					break
				end
			end
		end
		BoxText.Text = str
		SliderB.Position = UDim2.new(math.clamp((Select.Value - min) / (max - min), 0, 1), 0, 0.5, 0)
		if math.random(4) == 1 then
			if str:find("67") or str:find("6.7") then
				Util.UINotify("SIX SEVENNNN 67 67 67 67 OMG")
			end
		end
	end
	Select.Value = value
	Select.Changed:Connect(update)
	update()
	BoxText.FocusLost:Connect(function()
		Select.Value = tonumber(BoxText.Text) or Select.Value
		update()
	end)
	local function ondrag(x)
		local val = range * math.clamp((x - SliderR.AbsolutePosition.X) / SliderR.AbsoluteSize.X, 0, 1)
		if step > 0 then
			val = math.round(val / step) * step
		end
		val += min
		Select.Value = val
	end
	local dragref = nil
	local start = nil
	SliderC.InputBegan:Connect(function(input)
		if input.UserInputState ~= Enum.UserInputState.Begin then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragref = input
			start = input.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragref then
			if input.UserInputType == Enum.UserInputType.MouseMovement or (input.UserInputType == Enum.UserInputType.Touch and dragref == input) then
				if start then
					local delta = input.Position - start
					if delta.Magnitude > 10 then
						start = nil
						if math.abs(delta.X) < math.abs(delta.Y) then
							dragref = nil
						end
					end
				else
					ondrag(input.Position.X)
				end
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragref and dragref == input then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				ondrag(input.Position.X)
				dragref = nil
			end
		end
	end)
	return Select
end
function UI.CreateDropdown(parent, text, array, value)
	value = value and math.clamp(value, 1, #array) or 1
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 10)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Text = Util.Instance("TextLabel", Container)
	Text.AnchorPoint = Vector2.new(0, 0)
	Text.Position = UDim2.new(0, margin, 0, 0)
	Text.Size = UDim2.new(1, margin * -2, 1, 0)
	Text.BackgroundTransparency = 1
	Text.RichText = true
	Text.Font = Enum.Font.Code
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.TextTransparency = 0
	Text.TextXAlignment = Enum.TextXAlignment.Left
	Text.TextYAlignment = Enum.TextYAlignment.Center
	Text.TextWrapped = true
	Text.TextSize = 20
	RegisterTextLabel(Text)
	local Dropdown = Util.Instance("TextButton", Container)
	Dropdown.AnchorPoint = Vector2.new(1, 0.5)
	Dropdown.Position = UDim2.new(1, -margin, 0.5, 0)
	Dropdown.Size = UDim2.new(0.5, 0, 1, -margin)
	Dropdown.BackgroundTransparency = 0
	Dropdown.BackgroundColor3 = Color3.new(1, 1, 1)
	Dropdown.BorderSizePixel = 0
	Dropdown.Text = ""
	Dropdown.AutoButtonColor = true
	local DropdownText = Util.Instance("TextLabel", Dropdown)
	DropdownText.AnchorPoint = Vector2.new(0.5, 0.5)
	DropdownText.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropdownText.Size = UDim2.new(1, -margin * 2, 1, -margin)
	DropdownText.BackgroundTransparency = 1
	DropdownText.RichText = true
	DropdownText.Font = Enum.Font.Code
	DropdownText.TextColor3 = Color3.new(1, 1, 1)
	DropdownText.TextTransparency = 0
	DropdownText.TextXAlignment = Enum.TextXAlignment.Center
	DropdownText.TextYAlignment = Enum.TextYAlignment.Center
	DropdownText.TextWrapped = true
	DropdownText.TextSize = 15
	RegisterTextLabel(DropdownText)
	Stylize(Dropdown)
	local function update()
		local x = parent.AbsoluteSize.X
		local size1 = TextService:GetTextSize(Text.ContentText, Text.TextSize, Text.Font, Vector2.new(x - margin * 2, math.huge))
		local size2 = TextService:GetTextSize(DropdownText.ContentText, DropdownText.TextSize, DropdownText.Font, Vector2.new(x * 0.8 - margin * 2, math.huge))
		Container.Size = UDim2.new(1, 0, 0, math.max(35, size1.Y, size2.Y + margin * 2))
		Dropdown.Size = UDim2.new(0, math.max(60, size2.X + margin * 2 + 2), 0, math.max(25, size2.Y + margin * 2))
	end
	Text.Text = text
	DropdownText.Text = array[value]
	update()
	Text.Changed:Connect(update)
	DropdownText.Changed:Connect(update)
	local Select = Util.Instance("IntValue")
	Select.Value = value
	Select.Changed:Connect(function()
		DropdownText.Text = array[Select.Value]
	end)
	local Droplist = Util.Instance("ScrollingFrame", UIMainFrame)
	Droplist.AnchorPoint = Vector2.new(0, 0)
	Droplist.Position = UDim2.new(0, 0, 0, 0)
	Droplist.Size = UDim2.new(0, 0, 0, 0)
	Droplist.BackgroundTransparency = 0
	Droplist.BackgroundColor3 = Color3.new(1, 1, 1)
	Droplist.BorderSizePixel = 0
	Droplist.Visible = false
	Droplist.CanvasSize = UDim2.new(0, 0, 0, 0)
	Droplist.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Droplist.ScrollBarThickness = 0
	Droplist.ScrollingDirection = Enum.ScrollingDirection.Y
	local Padding = Util.Instance("UIPadding", Droplist)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	Padding.PaddingTop = UDim.new(0, 0)
	Padding.PaddingBottom = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", Droplist)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Stylize(Droplist, {
		Glow = true
	})
	local items = {}
	local sizex = 60
	local interact = false
	local opened = false
	Util.LinkDestroyI2I(Dropdown, Droplist)
	for i,itemname in array do
		local Item = Util.Instance("TextButton", Droplist)
		Item.Size = UDim2.new(1, 0, 0, 20)
		Item.BackgroundTransparency = 0
		Item.BackgroundColor3 = Color3.new(0, 0, 0)
		Item.BorderSizePixel = 0
		Item.AutoButtonColor = true
		Item.LayoutOrder = i
		Item.Text = itemname
		Item.TextSize = 15
		Item.Font = Enum.Font.Code
		Item.TextColor3 = Color3.new(1, 1, 1)
		Item.TextXAlignment = Enum.TextXAlignment.Left
		Item.TextYAlignment = Enum.TextYAlignment.Center
		Item.TextWrapped = false
		RegisterTextLabel(Item)
		table.insert(items, Item)
		local size = TextService:GetTextSize(itemname, Item.TextSize, Item.Font, Vector2.new(math.huge, math.huge))
		sizex = math.max(sizex, size.X + 12)
		Item.Activated:Connect(function()
			Select.Value = i
			opened = false
			interact = true
		end)
		Item.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				interact = true
				UISound.Click:Play()
			end
		end)
	end
	Dropdown.Activated:Connect(function()
		opened = not opened
		interact = true
	end)
	local conn = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			task.wait()
			if not interact then
				opened = false
			end
			interact = false
		end
	end)
	Util.LinkDestroyI2C(Dropdown, conn)
	local scrollframe = Container:FindFirstAncestorWhichIsA("ScrollingFrame")
	if scrollframe then
		local conn = scrollframe:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			opened = false
		end)
	end
	local opentween = 0
	AddToRenderStep(function(t, dt)
		if opened then
			opentween = 1 + (opentween - 1) * math.exp(-32 * dt)
			Droplist.ZIndex = 4
			Droplist.Interactable = true
		else
			opentween *= math.exp(-32 * dt)
			Droplist.ZIndex = 3
			Droplist.Interactable = false
		end
		local ysize = math.round(math.min(90, #items * 20) * opentween)
		if ysize >= 1 then
			Droplist.Position = Util.Vector2ToUDim2Offset((Dropdown.AbsolutePosition + Vector2.new(0, Dropdown.AbsoluteSize.Y)) - UIMainFrame.AbsolutePosition)
			Droplist.Size = UDim2.new(0, math.max(Dropdown.Size.X.Offset, sizex), 0, ysize)
			Droplist.Visible = true
		else
			Droplist.Visible = false
		end
		local i1 = GetUIBGColor(t)
		local i2 = i1:Lerp(Color3.new(1, 1, 1), 0.1)
		for i,v in items do
			if i == Select.Value then
				v.BackgroundColor3 = i2
			else
				v.BackgroundColor3 = i1
			end
		end
	end, Droplist)
	Util.LinkDestroyI2I(Dropdown, Select)
	return Select, Text
end
function UI.CreateCanvas(parent)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	Container.AutomaticSize = Enum.AutomaticSize.Y
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("Frame", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticSize = Enum.AutomaticSize.Y
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end
function UI.CreateScrollCanvas(parent, height)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, height)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("ScrollingFrame", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
	ListBox.ClipsDescendants = true
	ListBox.ScrollingDirection = Enum.ScrollingDirection.Y
	ListBox.ScrollBarThickness = 3
	ListBox.ElasticBehavior = Enum.ElasticBehavior.Always
	ListBox.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.ScrollBarImageTransparency = 0.5
	ListBox.ScrollBarImageColor3 = UITextColor.Value
	Util.LinkDestroyI2C(ListBox, UITextColor.Changed:Connect(function(val)
		ListBox.ScrollBarImageColor3 = val
	end))
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end
function UI.CreateItemListPage()
	local margin = 5
	local Frame = Util.Instance("Frame", WindowContent)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.Size = UDim2.new(0, 360, 0, 205)
	Frame.BackgroundTransparency = 0
	Frame.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 1
	Frame.BorderColor3 = Color3.new(1, 1, 1)
	Frame.Visible = true
	Frame.ZIndex = 0
	Frame.ClipsDescendants = true
	AddToRenderStep(function(t)
		Frame.BorderColor3 = GetUIColor(t)
		Frame.BackgroundColor3 = GetUIBGColor(t)
	end, Frame)
	local Padding = Util.Instance("UIPadding", Frame)
	Padding.PaddingTop = UDim.new(0, margin)
	Padding.PaddingBottom = UDim.new(0, margin)
	Padding.PaddingLeft = UDim.new(0, margin)
	Padding.PaddingRight = UDim.new(0, margin)
	local BackButton = Util.Instance("TextButton", Frame)
	BackButton.AnchorPoint = Vector2.new(0, 0)
	BackButton.Position = UDim2.new(0, 0, 0, 0)
	BackButton.Size = UDim2.new(0, 30, 0, 25)
	BackButton.BackgroundTransparency = 0
	BackButton.BackgroundColor3 = Color3.new(1, 1, 1)
	BackButton.BorderSizePixel = 0
	BackButton.Text = ""
	BackButton.AutoButtonColor = true
	local BackButtonText = Util.Instance("TextLabel", BackButton)
	BackButtonText.AnchorPoint = Vector2.new(0.5, 0.5)
	BackButtonText.Position = UDim2.new(0.5, 0, 0.5, 0)
	BackButtonText.Size = UDim2.new(1, margin * -2, 1, -margin)
	BackButtonText.BackgroundTransparency = 1
	BackButtonText.Font = Enum.Font.Code
	BackButtonText.TextColor3 = Color3.new(1, 1, 1)
	BackButtonText.TextTransparency = 0
	BackButtonText.TextXAlignment = Enum.TextXAlignment.Center
	BackButtonText.TextYAlignment = Enum.TextYAlignment.Center
	BackButtonText.TextWrapped = true
	BackButtonText.TextSize = 20
	BackButtonText.Text = "<"
	RegisterTextLabel(BackButtonText)
	Stylize(BackButton)
	local SearchBox = Util.Instance("Frame", Frame)
	SearchBox.AnchorPoint = Vector2.new(1, 0)
	SearchBox.Position = UDim2.new(1, 0, 0, 0)
	SearchBox.Size = UDim2.new(1, -margin - 30, 0, 25)
	SearchBox.BackgroundTransparency = 0
	SearchBox.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
	SearchBox.BorderSizePixel = 0
	local SearchBoxText = Util.Instance("TextBox", SearchBox)
	SearchBoxText.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchBoxText.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchBoxText.Size = UDim2.new(1, margin * -2, 1, -margin)
	SearchBoxText.BackgroundTransparency = 1
	SearchBoxText.Font = Enum.Font.Code
	SearchBoxText.TextColor3 = Color3.new(1, 1, 1)
	SearchBoxText.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
	SearchBoxText.TextTransparency = 0
	SearchBoxText.TextXAlignment = Enum.TextXAlignment.Left
	SearchBoxText.TextYAlignment = Enum.TextYAlignment.Center
	SearchBoxText.TextWrapped = true
	SearchBoxText.TextSize = 20
	SearchBoxText.ClearTextOnFocus = false
	SearchBoxText.Focused:Connect(function()
		UISound.Click:Play()
	end)
	Stylize(SearchBox, {
		Depthed = true,
	})
	SearchBoxText.Text = ""
	SearchBoxText.PlaceholderText = "Seek..."
	RegisterTextLabel(SearchBoxText)
	local ListBox = Util.Instance("ScrollingFrame", Frame)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 25 + margin)
	ListBox.Size = UDim2.new(1, 0, 1, -margin - 25)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ListBox.CanvasSize = UDim2.new(0, 0, 0, 0)
	ListBox.ClipsDescendants = true
	ListBox.ScrollingDirection = Enum.ScrollingDirection.Y
	ListBox.ScrollBarThickness = 3
	ListBox.ElasticBehavior = Enum.ElasticBehavior.Always
	ListBox.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ListBox.ScrollBarImageTransparency = 0.5
	ListBox.ScrollBarImageColor3 = UITextColor.Value
	Util.LinkDestroyI2C(ListBox, UITextColor.Changed:Connect(function(val)
		ListBox.ScrollBarImageColor3 = val
	end))
	Stylize(ListBox, {
		Depthed = true,
	})
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	BackButton.Name = "Back"
	BackButtonText.Name = "Label"
	SearchBox.Name = "Search"
	SearchBoxText.Name = "Box"
	ListBox.Name = "List"
	SearchBoxText:GetPropertyChangedSignal("Text"):Connect(function()
		for _,v in ListBox:GetChildren() do
			if v:IsA("GuiObject") then
				v.Visible = not not v.Name:lower():find(SearchBoxText.Text:lower())
			end
		end
	end)
	return Frame
end
function UI.CreateItemListItem(parent)
	local margin = 5
	local Container = Util.Instance("Frame", parent)
	Container.AnchorPoint = Vector2.new(0.5, 0)
	Container.Size = UDim2.new(1, 0, 0, 30)
	Container.BackgroundTransparency = 1
	Container.LayoutOrder = #parent:GetChildren()
	Container.AutomaticSize = Enum.AutomaticSize.Y
	local Padding = Util.Instance("UIPadding", Container)
	Padding.PaddingTop = UDim.new(0, 2)
	Padding.PaddingBottom = UDim.new(0, 2)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 5)
	local ListBox = Util.Instance("TextButton", Container)
	ListBox.AnchorPoint = Vector2.new(0, 0)
	ListBox.Position = UDim2.new(0, 0, 0, 0)
	ListBox.Size = UDim2.new(1, 0, 0, 26)
	ListBox.BackgroundTransparency = 0
	ListBox.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
	ListBox.BorderSizePixel = 0
	ListBox.AutomaticSize = Enum.AutomaticSize.Y
	ListBox.Text = ""
	Stylize(ListBox)
	Padding = Util.Instance("UIPadding", ListBox)
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingBottom = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 0)
	Padding.PaddingRight = UDim.new(0, 0)
	local UIList = Util.Instance("UIListLayout", ListBox)
	UIList.FillDirection = Enum.FillDirection.Vertical
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Top
	UIList.Padding = UDim.new(0, 0)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	Util.LinkDestroyI2I(ListBox, Container)
	return ListBox
end

local MainPage = UI.CreatePage()
MainPage.Interactable = false
CracktroFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if _totalrendertime < 1 or not IsUhhhhhhFullyLoaded then return end
		CracktroFrame.Interactable = false
		CracktroFrame.Visible = true
		MainPage.Interactable = false
		local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -362, 0.5, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			CracktroFrame.Visible = false
			MainPage.Interactable = true
		end)
	end
end)
local AsciiText = UI.CreateText(MainPage, "", 12, Enum.TextXAlignment.Center)
Util.ForceTextSize(AsciiText)
task.spawn(function()
	-- nice ascii art steve
	local AsciiTextarts = {
		{
			"  ____ ___.__    .__    .__    .__    .__    .__      ",
			" |    |   \\  |__ |  |__ |  |__ |  |__ |  |__ |  |__   ",
			" |    |   /  |  \\|  |  \\|  |  \\|  |  \\|  |  \\|  |  \\  ",
			" |    |  /|   Y  \\   Y  \\   Y  \\   Y  \\   Y  \\   Y  \\ ",
			" |______/ |___|  /___|  /___|  /___|  /___|  /___|  / ",
			"               \\/     \\/     \\/     \\/     \\/     \\/  ",
		},
		{
			"  _   _ _     _     _     _     _     _      ",
			" | | | | |   | |   | |   | |   | |   | |     ",
			" | | | | |__ | |__ | |__ | |__ | |__ | |__   ",
			" | | | | '_ \\| '_ \\| '_ \\| '_ \\| '_ \\| '_ \\  ",
			" | |_| | | | | | | | | | | | | | | | | | | | ",
			"  \\___/|_| |_|_| |_|_| |_|_| |_|_| |_|_| |_| ",
		},
		{
			"     (   ( /(  ( /(  ( /(  ( /(  ( /(  ( /(  ",
			"     )\\  )\\()) )\\()) )\\()) )\\()) )\\()) )\\()) ",
			"  _ ((_)((_)\\ ((_)\\ ((_)\\ ((_)\\ ((_)\\ ((_)\\  ",
			" | | | || |(_)| |(_)| |(_)| |(_)| |(_)| |(_) ",
			" | |_| || ' \\ | ' \\ | ' \\ | ' \\ | ' \\ | ' \\  ",
			"  \\___/ |_||_||_||_||_||_||_||_||_||_||_||_| ",
		},
		{
			" db    db db      db      db      db      db      db      ",
			" 88    88 88      88      88      88      88      88      ",
			" 88    88 888888. 888888. 888888. 888888. 888888. 888888. ",
			" 88    88 88   88 88   88 88   88 88   88 88   88 88   88 ",
			" 88.  .88 88   88 88   88 88   88 88   88 88   88 88   88 ",
			"  Y8888P  YP   YP YP   YP YP   YP YP   YP YP   YP YP   YP ",
		},
		{
			" Un    iv er      sa      lH      ie      ra      rc      ",
			" hi    ca l6      Re      an      im      at      eB      ",
			" yS    TE VETHERE ALONEUn iversal Hierarc hical6R eanimat ",
			" eB    yS TE   VE TH   ER EA   LO NE   Un iv   er sa   lH ",
			" ier  arc ic   al 6R   ea ni   ma te   By ST   EV ET   HE ",
			"  REALON  EU   ni ve   rs al   Hi er   ar ch   ic al   6R ",
		},
		{
			"animatio'   .jQQQ|;;;;;;;;;;;;;|QQWp,   'tionanim",
			"ationan'   .JTTVV|;;;;;;;;;;;;;|VVVVm>   'nimatio",
			"nanima'   _mQc;~~|.............|~~+jQmc   'ionani",
			"matio'   _QQQQg, |             |  jQQQQc.  'imati",
			"onan'   <QQQQQQm;|   Uhhhhhh   |.wQQQQWQa,  'onan",
			"ima'   jWQQQQQQQQ|             |mQQQQQQQQg,  'mat",
		},
		{
			"fore! It is really great! Good product! Feel alive, NO",
			"st part^ '' '  \"\"*E! (excluding taxes and the bills) N",
			"r seu- . Uhhhhhh .-|u ihis! It has become something ne",
			"rse! We ,... . ,.-rs of yellow-orange shiny triangles.",
			"ns at a really stable framerate, so optimised it handl",
			"ow, BUY OUR PRODUCT FOR FREE! We know you like it! We ",
		},
		{ -- omg hi steveee-
			"....... gmWWWQQQQQQPg ..............................",
			":;:;:; qm#WWNWQQWQWWmp ;:;:;:.                  .;:;",
			"!!?!!?.WX##: W#W :###W.?!!?:.  hi im steve!      .:!",
			"lilili:ZSXS: XSX :X##Z:ilil!. welcome to Uhhhhhh .!i",
			"EEEEEE:YLkk2S2SXSXSXZP:EEEEEi:                  :iEE",
			"%%%%%%%;vnvkkkk2S2vnv;%%%%%%%%%oooooooooooooooo%%%%%",
		},
		{
			"  Get Uhhhhhh today! Feel the difference!       ",
			"           (-_-)         EPIC!    (^~^)   .vv=E ",
			"       ()-(:::::)-()         .()-(:::::)-()'    ",
			"LAME!  || |.....| ||      3=^^'  /...../        ",
			"       YP |     | YP            (     )   COOL! ",
			"      Without Uhhhhhh   vs.   With Uhhhhhh      ",
		},
		{
			"55 68 68 68 68 68 68 55 68 68 68 68 68 68",
			"68 68 68 68 68 68 55 68 68 68 68 68 68 55",
			"68 68 68 68 68 55 68 68 68 68 68 68 55 68",
			"68 68 68 68 Uhhhhhh  68 68 68 68 55 68 68",
			"68 68 68 55 68 68 68 68 68 68 55 68 68 68",
			"68 68 55 68 68 68 68 68 68 55 68 68 68 68",
		},
		{
			"  Uhhhhhh          ",
			"  01010101         ",
			"   01101000        ",
			"    01101000       ",
			"     01101000      ",
			"      01101000     ",
			"       01101000    ",
			"        01101000   ",
			"         Uhhhhhh   ",
		},
		{
			"+-[ Uhhhhhh Reanimate ]-----------------[#]-+",
			"|    ___                                    |",
			"|   / o \\   Hello, world! Programmed to     |",
			"|   \\ l /   work and not to feel.           |",
			"|    \"\"\"                                    |",
			"+-------------------------------------------+",
		},
		{
			"       cIyyyyyyF0\\ `TFyyyyyyq8_                 ",
			"           i+`}0v       V!'xD~                  ",
			"           &x~[.        W|11   --Uhhhhhh--      ",
			"          ~W,          }D                       ",
			"        <d$-         tg3`                       ",
			"   \".''   ......             '.      \"`   ;     ",
			"   2]~<J  ;!ci2q' rrrr^   <1_q'   -inr   `0;    ",
			"   F` '2    F<;            [&I- _+r%)    `@<}!  ",
			"    ~1}`  `}\\    ;*111*; ^[; .^    +\\    `x     ",
		},
		{
			"  local oldsec = 0          .-+=* Uhhhhhh *=+-. ",
			"  while i < #keyframes do     (code-ception!)   ",
			"      local k = keyframes[i]                    ",
			"      local sec = k.Time // self._optimiser     ",
			"      while oldsec < sec do                     ",
			"          local j = math.max(1, i - 1)          ",
		},
		{
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
			"--------------------------------------------       ",
			"so, Uhhhhhh...                                     ",
			"--------------------------------------------       ",
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
			"er failed to process http://assetgame.roblox.com/as",
		},
		{
			"usage: clone this repo and change the token and the",
			"(unless you like chaos) also make sure you have all",
			"the dev portal cuz Uhhhhhh.                        ",
			"                                                   ",
			"\"it's not fast it's shit\"                          ",
			"Believe me friend, its fuckingly fast, you don't ev",
		},
		{
			"Uhhhhhh  https://discord.gg/NASNUKRBVM  Uhhhhhh",
			"Uhhhhhh Uhhhhhh Uhhhhhh Uhhhhhh STEVETHEREALONE",
			"Uhhhhhh Uhhhhhh Uhhhhhh STEVETHEREALONE Uhhhhhh",
			"Uhhhhhh Uhhhhhh STEVETHEREALONE Uhhhhhh Uhhhhhh",
			"Uhhhhhh STEVETHEREALONE Uhhhhhh Uhhhhhh Uhhhhhh",
			"STEVETHEREALONE Uhhhhhh Uhhhhhh Uhhhhhh Uhhhhhh",
		},
	}
	AsciiText.Text = table.concat(AsciiTextarts[math.random(1, #AsciiTextarts)], "\n")
	local AsciiTextartsw = false
	local AsciiTextarttr = {}
	do -- generate transitions
		-- wipe to right
		local a = {}
		for i=0, 59 do
			local t = i / 60
			t *= 5
			t = (t - 1) / 3
			t *= 5
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local prog = x / 64
					prog *= 5
					table.insert(layer, math.round(math.clamp(t - prog + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		table.insert(AsciiTextarttr, a)
		-- noisy fade
		a = {}
		for i=0, 59 do
			local t = i / 60
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					table.insert(layer, math.round(math.clamp(t * 2 - 1 + math.random() * 0.8, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		-- circle outward
		a = {}
		for i=0, 59 do
			local t = i / 60
			t *= 5
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local dist = math.sqrt(math.pow(x - 32, 2) + math.pow(y - 32, 2)) / 64
					dist *= 5
					table.insert(layer, math.round(math.clamp(t - dist + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
		-- circle inward
		a = {}
		for i=0, 59 do
			local t = 1 - i / 60
			t *= 5
			t -= 1
			local map = {}
			for y=0, 64 do
				local layer = {}
				for x=0, 64 do
					local dist = math.sqrt(math.pow(x - 32, 2) + math.pow(y - 32, 2)) / 64
					dist *= 5
					table.insert(layer, math.round(math.clamp(dist - t + math.random() * 0.2, 0, 1) * 3))
				end
				table.insert(map, layer)
			end
			table.insert(a, map)
			task.wait()
		end
		table.insert(AsciiTextarttr, a)
	end
	local function switchart()
		if AsciiTextartsw then return end
		AsciiTextartsw = true
		local function animation(art, inv)
			local transmap = AsciiTextarttr[math.random(1, #AsciiTextarttr)]
			local rot = math.random(0, 3)
			local st = os.clock()
			repeat
				local t = os.clock() - st
				local i = math.clamp(math.floor(t * 60) + 1, 1, 60)
				local render = {}
				for iy=1, #art do
					local y = (iy - 1) / #art
					local conc = ""
					local txt = art[iy]
					for ix=1, #txt do
						local x = (ix - 1) / #txt
						local ch = string.sub(txt, ix, ix)
						local b = 0
						if rot == 0 then
							b = transmap[i][math.floor(y * 64) + 1][math.floor(x * 64) + 1]
						elseif rot == 1 then
							b = transmap[i][math.floor(x * 64) + 1][64 - math.floor(y * 64)]
						elseif rot == 2 then
							b = transmap[i][64 - math.floor(y * 64)][64 - math.floor(x * 64)]
						elseif rot == 3 then
							b = transmap[i][64 - math.floor(x * 64)][math.floor(y * 64) + 1]
						end
						if inv then b = 3 - b end
						if b == 1 then
							if (ch == ch:upper() and ch ~= ch:lower()) or ch == "8" or ch == "0" then
								ch = "?"
							elseif ch == ":" or ch == ";" or ch == "_" then
								ch = "."
							elseif ch == "." or ch == "," or ch == " " then
								ch = " "
							else
								ch = ":"
							end
						elseif b == 2 then
							if (ch == ch:upper() and ch ~= ch:lower()) or ch == "8" or ch == "0" then
								ch = ":"
							elseif ch == ":" or ch == ";" or ch == "_" or ch == "." or ch == "," or ch == " " then
								ch = " "
							else
								ch = "."
							end
						elseif b == 3 then
							ch = " "
						end
						conc ..= ch
					end
					table.insert(render, conc)
				end
				AsciiText.Text = table.concat(render, "\n")
				task.wait()
			until os.clock() > st + 1
		end
		local source = string.split(AsciiText.Text, "\n")
		local target = source
		while table.concat(source, "\n") == table.concat(target, "\n") do
			task.wait()
			target = AsciiTextarts[math.random(1, #AsciiTextarts)]
		end
		animation(source, false)
		animation(target, true)
		AsciiText.Text = table.concat(target, "\n")
		AsciiTextartsw = false
	end
	local AsciiTextartin = nil
	AsciiText.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			AsciiTextartin = input
		end
	end)
	AsciiText.InputEnded:Connect(function(input)
		if AsciiTextartin == input then
			AsciiTextartin = nil
			switchart()
		end
	end)
	switchart()
end)
UI.CreateText(MainPage, `Reanimate V{UhhhhhhVersion}, By STEVE :D`, 15, Enum.TextXAlignment.Right)
UI.CreateSeparator(MainPage)
UI.CreateButton(MainPage, " &lt; Back to cool scene", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
end)
UI.CreateSwitch(MainPage, "Skip Intro", SaveData.SkipIntro).Changed:Connect(function(value)
	SaveData.SkipIntro = value
end)
UI.CreateDropdown(MainPage, "UI Theme", {
	"RGB/Default",
	"ALONE",
	"Oxide",
	"Patchma Hub",
	"Genesis V4",
	"Crimson",
	"r/masterhacker",
	"Homer Simpson",
	"Immortality Lord",
	"LIGHT RGB",
	"LIGHT ALONE",
	"Roserika",
	"FastTracker II Blue",
	"Cherry Blossom",
	"Sakura",
	"Tommorow Night 80s", -- my personal IDE theme
	"User Defined (see README)",
}, SaveData.UITheme).Changed:Connect(function(val)
	SaveData.UITheme = val
	SetUITheme(SaveData.UITheme)
end)
UI.CreateSeparator(MainPage)

local MusicName = UI.CreateText(MainPage, "", 15, Enum.TextXAlignment.Center)
UI.CreateButton(MainPage, "Random UI Music", 20).Activated:Connect(function()
	MusicPlayer.PlayMusic()
end)
local _musicnames = {"-- Choose --"}
for i=1, #MusicPlayer.Database do
	local hi = MusicPlayer.Database[i]
	table.insert(_musicnames, hi[2])
end
local MusicSelect = UI.CreateDropdown(MainPage, "UI Music", _musicnames, 1)
MusicSelect.Changed:Connect(function(val)
	if val > 1 then
		MusicSelect.Value = 1
		MusicPlayer.PlayMusic(val - 1)
	end
end)
UI.CreateSwitch(MainPage, math.random(8) == 1 and "Mute @Noober 67s" or "Mute UI Music", SaveData.MuteUIMusic).Changed:Connect(function(value)
	SaveData.MuteUIMusic = value
end)
UI.CreateSwitch(MainPage, "Mute Reanim Music", SaveData.MuteReanimMusic).Changed:Connect(function(value)
	SaveData.MuteReanimMusic = value
end)
UI.CreateSwitch(MainPage, "Mute Sounds", SaveData.MuteUISound).Changed:Connect(function(value)
	SaveData.MuteUISound = value
	if value then
		UISound.Click.Volume = 0
	else
		UISound.Click.Volume = 1
	end
end)
UI.CreateSeparator(MainPage)

UISound.MovesetMusic = Util.Instance("Sound", UIMainFrame)
UISound.MovesetMusic.Looped = true
UISound.MovesetMusic.PlaybackRegionsEnabled = false
UISound.MovesetMusic.Volume = 1
UISound.MovesetMusic.Name = "(unknown)"
UISound.MovesetMusic:SetAttribute("Volume", 1)
local function SetOverrideMovesetMusic(soundid, soundname, volume, region)
	if soundid then
		UISound.MovesetMusic.SoundId = soundid
		UISound.MovesetMusic.Name = soundname or "(unknown)"
		if volume ~= nil then
			UISound.MovesetMusic:SetAttribute("Volume", volume)
		else
			UISound.MovesetMusic:SetAttribute("Volume", 1)
		end
		if region ~= nil then
			UISound.MovesetMusic.PlaybackRegionsEnabled = true
			UISound.MovesetMusic.LoopRegion = region
		else
			UISound.MovesetMusic.PlaybackRegionsEnabled = false
		end
		UISound.MovesetMusic.PlaybackSpeed = 1
		UISound.MovesetMusic.TimePosition = 0
		UISound.MovesetMusic:Play()
	else
		UISound.MovesetMusic:Stop()
	end
end
local function GetOverrideMovesetMusicTime()
	return UISound.MovesetMusic.TimePosition
end
local function SetOverrideMovesetMusicTime(t)
	UISound.MovesetMusic.TimePosition = t
end
local function SetOverrideMovesetMusicSpeed(speed)
	UISound.MovesetMusic.PlaybackSpeed = speed
end
UISound.DanceMusic = Util.Instance("Sound", UIMainFrame)
UISound.DanceMusic.Looped = true
UISound.DanceMusic.PlaybackRegionsEnabled = false
UISound.DanceMusic.Volume = 1
UISound.DanceMusic.Name = "(unknown)"
UISound.DanceMusic:SetAttribute("Volume", 1)
local function SetOverrideDanceMusic(soundid, soundname, volume, region)
	if soundid then
		UISound.DanceMusic.SoundId = soundid
		UISound.DanceMusic.Name = soundname or "(unknown)"
		if volume ~= nil then
			UISound.DanceMusic:SetAttribute("Volume", volume)
		else
			UISound.DanceMusic:SetAttribute("Volume", 1)
		end
		if region ~= nil then
			UISound.DanceMusic.PlaybackRegionsEnabled = true
			UISound.DanceMusic.LoopRegion = region
		else
			UISound.DanceMusic.PlaybackRegionsEnabled = false
		end
		UISound.DanceMusic.PlaybackSpeed = 1
		UISound.DanceMusic.TimePosition = 0
		UISound.DanceMusic:Play()
	else
		UISound.DanceMusic:Stop()
	end
end
local function GetOverrideDanceMusicTime()
	return UISound.DanceMusic.TimePosition
end
local function SetOverrideDanceMusicTime(t)
	UISound.DanceMusic.TimePosition = t
end
local function SetOverrideDanceMusicSpeed(speed)
	UISound.DanceMusic.PlaybackSpeed = speed
end

local _MainMusicIsMuted = SaveData.MuteUIMusic
AddToRenderStep(function()
	local musicname = UISound.Music.Name
	local mustmute = SaveData.MuteUIMusic
	if SaveData.MuteReanimMusic then
		UISound.MovesetMusic.Volume = 0
		UISound.DanceMusic.Volume = 0
	else
		if UISound.DanceMusic.IsPlaying then
			mustmute = true
			UISound.DanceMusic.Volume = UISound.DanceMusic:GetAttribute("Volume")
			UISound.MovesetMusic.Volume = 0
			musicname = UISound.DanceMusic.Name
		elseif UISound.MovesetMusic.IsPlaying then
			mustmute = true
			UISound.MovesetMusic.Volume = UISound.MovesetMusic:GetAttribute("Volume")
			musicname = UISound.MovesetMusic.Name
		end
	end
	if _MainMusicIsMuted ~= mustmute then
		_MainMusicIsMuted = mustmute
		if mustmute then
			UISound.Music.Volume = 0
		else
			UISound.Music.Volume = 1
		end
	end
	MusicName.Text = `Current Music Playing:\n{musicname:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")}`
end)
task.wait()

FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
if FallenPartsDestroyHeight ~= FallenPartsDestroyHeight then
	FallenPartsDestroyHeight = -500
end
local RejectCharacterDeletionsDisabled = false
pcall(function()
	local rcd, _ = gethiddenproperty(workspace, "RejectCharacterDeletions")
	if rcd.Name == "Disabled" then
		RejectCharacterDeletionsDisabled = true
	end
end)

local function CreateHumanoidCharacter()
	local char = Util.Instance("Model")
	char.Name = "(C) Uhhhhhh V" .. UhhhhhhVersion

	local god = Util.Instance("ForceField", char)
	god.Name = "heyy!! :33"
	god.Visible = false

	local hum = Util.Instance("Humanoid", char)
	hum.Name = "Humanoid"
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.RequiresNeck = false
	hum.BreakJointsOnDeath = false
	hum.UseJumpPower = true
	hum.WalkSpeed = 16
	hum.JumpPower = 50
	hum.Health = 100
	hum.MaxHealth = 100
	hum.MaxSlopeAngle = 89
	hum.HipHeight = 0
	hum.AutoRotate = true
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local function makePart(name, size, pos)
		local part = Util.Instance("Part", char)
		part.Name = name
		part.Size = size
		part.Position = pos
		part.Anchored = false
		part.CanCollide = false
		part.Transparency = 1
		part.Reflectance = 0
		part.Color = Color3.new(1, 0, 0)
		part.CastShadow = false
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth
		part.LeftSurface = Enum.SurfaceType.Smooth
		part.RightSurface = Enum.SurfaceType.Smooth
		part.FrontSurface = Enum.SurfaceType.Smooth
		part.BackSurface = Enum.SurfaceType.Smooth
		return part
	end

	local root = makePart("HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
	local torso = makePart("Torso", Vector3.new(2, 2, 1), Vector3.new(0, 0, 0))
	local head = makePart("Head", Vector3.new(2, 1, 1), Vector3.new(0, 1.5, 0))
	local leftArm = makePart("Left Arm", Vector3.new(1, 2, 1), Vector3.new(-1.5, 0, 0))
	local rightArm = makePart("Right Arm", Vector3.new(1, 2, 1), Vector3.new(1.5, 0, 0))
	local leftLeg = makePart("Left Leg", Vector3.new(1, 2, 1), Vector3.new(-0.5, -2, 0))
	local rightLeg = makePart("Right Leg", Vector3.new(1, 2, 1), Vector3.new(0.5, -2, 0))

	local function makeMotor(name, p0, p1, c0, c1)
		local motor = Instance.new("Motor6D", p0)
		motor.Name = name
		motor.Part0 = p0
		motor.Part1 = p1
		motor.C0 = c0
		motor.C1 = c1
		motor.MaxVelocity = 0
		Util.LinkDestroyI2C(motor, RunService.PreRender:Connect(function()
			local scale = char:GetScale()
			motor:SetAttribute("Transform", Util.ScaleCFrame(motor.Transform, 1 / scale))
			motor.Transform = Util.ScaleCFrame(motor:GetAttribute("Transform") or CFrame.identity, scale)
		end))
	end

	makeMotor(
		"RootJoint", root, torso,
		CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
		CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	)
	makeMotor(
		"Neck", torso, head,
		CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0),
		CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)
	)
	makeMotor(
		"Left Shoulder", torso, leftArm,
		CFrame.new(-1, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		CFrame.new(0.5, 0.5, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	)
	makeMotor(
		"Right Shoulder", torso, rightArm,
		CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		CFrame.new(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	)
	makeMotor(
		"Left Hip", torso, leftLeg,
		CFrame.new(-1, -1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0),
		CFrame.new(-0.5, 1, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0)
	)
	makeMotor(
		"Right Hip", torso, rightLeg,
		CFrame.new(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0),
		CFrame.new(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	)

	local headshape = Util.Instance("SpecialMesh", head)
	headshape.Name = "Mesh"
	headshape.MeshType = Enum.MeshType.Head
	headshape.Scale = Vector3.new(1.25, 1.25, 1.25)

	local face = Util.Instance("Decal", head)
	face.Name = "face"
	face.Texture = "rbxassetid://123572006339559"
	face.Color3 = Color3.new(0, 0, 0)

	local tshirt = Util.Instance("Decal", torso)
	tshirt.Name = "triforce"
	tshirt.Texture = "rbxassetid://101055520647223"
	tshirt.Color3 = Color3.new(1, 1, 1)
	
	Util.LinkDestroyI2C(char, RunService.PreRender:Connect(function()
		face.Transparency = Util.GetTransparency(head)
		tshirt.Transparency = Util.GetTransparency(torso)
	end))

	char.PrimaryPart = root

	return char
end

local GameSettings = UserSettings():GetService("UserGameSettings")

SaveData.NoInfiniteJump = not not SaveData.NoInfiniteJump
SaveData.NoclipEnabled = not not SaveData.NoclipEnabled
SaveData.CtrlClickEnabled = not not SaveData.CtrlClickEnabled
SaveData.ClickFlingEnabled = not not SaveData.ClickFlingEnabled
SaveData.NoSmoothCam = not not SaveData.NoSmoothCam
SaveData.FirstPersonBody = not not SaveData.FirstPersonBody
SaveData.NoSeatSitEnabled = not SaveData.NoSeatSitEnabled
SaveData.ToolGrabEnabled = not not SaveData.ToolGrabEnabled
SaveData.ScaleGravityEnabled = not not SaveData.ScaleGravityEnabled
SaveData.CharacterScale = SaveData.CharacterScale or 1
SaveData.P2PCollision = not not SaveData.P2PCollision
SaveData.ShiftlockDisabled = not not SaveData.ShiftlockDisabled
SaveData.NoLoadAnimationHook = not not SaveData.NoLoadAnimationHook
SaveData.NoPhysicsRepRootPart = not not SaveData.NoPhysicsRepRootPart
SaveData.NetlessVelocity = SaveData.NetlessVelocity or 25.01
SaveData.UsePatchmaLikeNetless = not not SaveData.UsePatchmaLikeNetless
SaveData.UseAngularVelocity = not not SaveData.UseAngularVelocity
SaveData.PatchmaVoidFloat = not not SaveData.PatchmaVoidFloat
SaveData.PlaceholderTransparency = SaveData.PlaceholderTransparency or 0.5

-- empyrean-like thing
local _G_Uhhhhhh = {}
-- jjsloit didnt have _G, just making sure if 100% unc execs dont have this even
pcall(function() _G.Uhhhhhh = _G_Uhhhhhh end)
_G_Uhhhhhh.BindableEvent = Util.Instance("BindableEvent") -- not used 3:

local Reanimate = {
	Current = nil,
	Character = nil,
	CharacterLTMs = {},
	Starting = false,
	Stopping = false,
	UseLoadAnimationHook = not SaveData.NoLoadAnimationHook,
	UsePhysicsRepRootPart = not SaveData.NoPhysicsRepRootPart,
	PhysicsRepRootPartFling = 1 / 10,
	NetlessVelocity = SaveData.NetlessVelocity,
	UsePatchmaLikeNetless = SaveData.UsePatchmaLikeNetless,
	UseAngularVelocity = SaveData.UseAngularVelocity,
	InfiniteJump = not SaveData.NoInfiniteJump,
	Noclip = SaveData.NoclipEnabled,
	CtrlClick = SaveData.CtrlClickEnabled,
	ClickFling = SaveData.ClickFlingEnabled,
	SmoothCam = not SaveData.NoSmoothCam,
	FirstPersonBody = SaveData.FirstPersonBody,
	SeatSit = not SaveData.NoSeatSitEnabled,
	ToolGrab = SaveData.ToolGrabEnabled,
	ScaleGravity = SaveData.ScaleGravityEnabled,
	PatchmaVoidFloat = SaveData.PatchmaVoidFloat,
	AntiExplosions = true,
	CharacterScale = SaveData.CharacterScale,
	PlaceholderTransparency = SaveData.PlaceholderTransparency,
	P2PCollision = false,
	ShiftlockEnabled = not SaveData.ShiftlockDisabled,
	Shiftlocked = false,
	ShouldRotationType = function(self)
		if self.Camera:IsMouseLocked() and not self.Camera.Scriptable and self.Character then
			local hum = self.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.AutoRotate and hum.RootPart and not hum.RootPart:IsGrounded() then
				local state = hum:GetState().Name
				if table.find({"Running", "Jumping", "Freefall", "Landed", "Climbing"}, state) then
					return true
				end
			end
		end
		return false
	end,
	Camera = {
		CFrame = CFrame.identity,
		Focus = CFrame.identity,
		Scriptable = false,
		VRMode = false,
		FPSLocked = false,
		Zoom = 16,
		FieldOfView = 70,
		Input = Vector3.zero,
		_Zoom = 16,
		OnReset = function(self)
			self.Zoom = (self.Focus.Position - self.CFrame.Position).Magnitude
			self._Zoom = self.Zoom
			self.Scriptable = false
			self.FPSLocked = false
			self.FieldOfView = 70
			self.Inputs:Reset()
		end,
		OnPanInput = function(self, vec, accum)
			if accum then
				self.Input += Vector3.new(vec.X, vec.Y, 0)
			else
				self.Input = Vector3.new(vec.X, vec.Y, self.Input.Z)
			end
		end,
		OnZoomInput = function(self, zoom)
			self.Input = Vector3.new(self.Input.X, self.Input.Y, zoom)
		end,
		Inputs = {
			KB = {
				Left = false,
				Right = false,
			},
			MS = {
				RMB = false,
			},
			TC = {
				DJ = nil,
				Touch = {},
				LP = nil,
			},
			GP = {
				DJ = Vector2.zero,
			},
			Reset = function(self)
				self.KB.Left = false
				self.KB.Right = false
				self.MS.RMB = false
				self.TC.DJ = nil
				table.clear(self.TC.Touch)
				self.TC.LP = nil
				self.GP.DJ = Vector2.zero
			end,
		},
	},
	LocalTransparencyModifier = 0,
	Control = {
		Move = Vector3.zero,
		Jump = false,
		Inputs = {
			KB = {
				Up = false,
				Down = false,
				Left = false,
				Right = false,
				Space = false,
			},
			TC = {
				DJ = nil,
				LP = nil,
				JB = nil,
			},
			GP = {
				DJ = Vector2.zero,
				JB = false,
			},
			Reset = function(self)
				self.KB.Up = false
				self.KB.Down = false
				self.KB.Left = false
				self.KB.Right = false
				self.KB.Space = false
				self.TC.DJ = nil
				self.TC.LP = nil
				self.TC.JB = nil
				self.GP.DJ = Vector2.zero
				self.GP.JB = false
			end,
		}
	}
}
Reanimate.Camera.IsFirstPerson = function(self)
	return self.Zoom < 0.75
end
Reanimate.Camera.IsMouseLocked = function(self)
	return self:IsFirstPerson() or Reanimate.Shiftlocked
end
Reanimate.Camera.IsMousePanning = function(self)
	return self:IsMouseLocked() or self.Inputs.MS.RMB
end
Reanimate.Camera.GetMovementCFrame = function(self)
	local ccf = Reanimate.Camera.CFrame
	if Reanimate.Camera.VRMode then
		local _,y,_ = VRService:GetUserCFrame(Enum.UserCFrame.Head):ToEulerAngles(Enum.RotationOrder.YXZ)
		ccf *= CFrame.Angles(0, y, 0)
	end
	return ccf
end
do
	local thumbstickAreaTopLeft = nil
	local thumbstickAreaBottomRight = nil
	local jumpButtonTopLeft = nil
	local jumpButtonBottomRight = nil
	local function IsInArea(pos, tl, br)
		return pos.X >= tl.X and pos.Y >= tl.Y and pos.X <= br.X and pos.Y <= br.Y
	end
	local function WillSinkToWorld(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		local touchGui
		if playerGui then
			touchGui = playerGui:FindFirstChild("TouchGui")
		end
		local corestuff = CoreGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
		for _,v in corestuff do
			if Util.WillGuiSinkInput(v) then
				return false
			end
		end
		local plrstuff = playerGui:GetGuiObjectsAtPosition(pos.X, pos.Y)
		for _,v in plrstuff do
			if v:IsDescendantOf(touchGui) then
				return true
			end
			if Util.WillGuiSinkInput(v) then
				return false
			end
		end
		return true
	end
	local function IsInThumbstickArea(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local touchGui = playerGui:FindFirstChild("TouchGui")
			if touchGui and touchGui.Enabled then
				local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
				local thumbstickFrame = touchFrame and (touchFrame:FindFirstChild("DynamicThumbstickFrame") or touchFrame:FindFirstChild("ThumbstickFrame"))
				if thumbstickFrame then
					thumbstickAreaTopLeft = thumbstickFrame.AbsolutePosition
					thumbstickAreaBottomRight = thumbstickAreaTopLeft + thumbstickFrame.AbsoluteSize
				end
			end
		end
		if thumbstickAreaTopLeft and thumbstickAreaBottomRight then
			return IsInArea(pos, thumbstickAreaTopLeft, thumbstickAreaBottomRight)
		end
		return false
	end
	local function IsInJumpButtonArea(pos)
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local touchGui = playerGui:FindFirstChild("TouchGui")
			if touchGui and touchGui.Enabled then
				local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
				local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
				if jumpButton then
					jumpButtonTopLeft = jumpButton.AbsolutePosition
					jumpButtonBottomRight = jumpButtonTopLeft + jumpButton.AbsoluteSize
				end
			end
		end
		if jumpButtonTopLeft and jumpButtonBottomRight then
			return IsInArea(pos, jumpButtonTopLeft, jumpButtonBottomRight)
		end
		return false
	end
	do -- Control
		local self = Reanimate.Control
		UserInputService.InputBegan:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then
					self.Inputs.KB.Up = true
				end
				if input.KeyCode == Enum.KeyCode.S then
					self.Inputs.KB.Down = true
				end
				if input.KeyCode == Enum.KeyCode.Up then
					self.Inputs.KB.Up = true
				end
				if input.KeyCode == Enum.KeyCode.Down then
					self.Inputs.KB.Down = true
				end
				if input.KeyCode == Enum.KeyCode.A then
					self.Inputs.KB.Left = true
				end
				if input.KeyCode == Enum.KeyCode.D then
					self.Inputs.KB.Right = true
				end
				if input.KeyCode == Enum.KeyCode.Space then
					self.Inputs.KB.Space = true
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonA then
				self.Inputs.GP.JB = true
			end
			if input.UserInputType == Enum.UserInputType.Touch and WillSinkToWorld(input.Position) then
				if self.Inputs.TC.DJ == nil and IsInThumbstickArea(input.Position) then
					self.Inputs.TC.DJ = input
					self.Inputs.TC.LP = input.Position
					return
				end
				if self.Inputs.TC.JB == nil and IsInJumpButtonArea(input.Position) then
					self.Inputs.TC.JB = input
					return
				end
			end
		end)
		UserInputService.InputChanged:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				self.Inputs.GP.DJ = Vector2.new(input.Position.X, -input.Position.Y)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then
					self.Inputs.KB.Up = false
				end
				if input.KeyCode == Enum.KeyCode.S then
					self.Inputs.KB.Down = false
				end
				if input.KeyCode == Enum.KeyCode.Up then
					self.Inputs.KB.Up = false
				end
				if input.KeyCode == Enum.KeyCode.Down then
					self.Inputs.KB.Down = false
				end
				if input.KeyCode == Enum.KeyCode.A then
					self.Inputs.KB.Left = false
				end
				if input.KeyCode == Enum.KeyCode.D then
					self.Inputs.KB.Right = false
				end
				if input.KeyCode == Enum.KeyCode.Space then
					self.Inputs.KB.Space = false
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonA then
				self.Inputs.GP.JB = false
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					self.Inputs.TC.DJ = nil
					self.Inputs.TC.LP = nil
				elseif self.Inputs.TC.JB == input then
					self.Inputs.TC.JB = nil
				end
			end
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				self.Inputs.GP.DJ = Vector2.zero
			end
		end)
		local function resetInputDevices()
			self.Inputs:Reset()
		end
		UserInputService.WindowFocused:Connect(resetInputDevices)
		UserInputService.WindowFocusReleased:Connect(resetInputDevices)
		UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
		GuiService.MenuOpened:Connect(resetInputDevices)
		RunService:BindToRenderStep("Uhhhhhh_Control", Enum.RenderPriority.Input.Value + 1, function(dt)
			if UserInputService:GetFocusedTextBox() then
				resetInputDevices()
			end
			local screensize = Util.GetScreenSize()
			self.Move = Vector3.zero
			if self.Inputs.KB.Up then
				self.Move += Vector3.new(0, 0, -1)
			end
			if self.Inputs.KB.Down then
				self.Move += Vector3.new(0, 0, 1)
			end
			if self.Inputs.KB.Left then
				self.Move += Vector3.new(-1, 0, 0)
			end
			if self.Inputs.KB.Right then
				self.Move += Vector3.new(1, 0, 0)
			end
			if self.Inputs.TC.DJ and self.Inputs.TC.LP then
				local stickrad = 40
				if math.min(screensize.X, screensize.Y) < 500 then
					stickrad = 20
				end
				local dir = (self.Inputs.TC.DJ.Position - self.Inputs.TC.LP) / stickrad
				if dir.Magnitude > 0.05 then
					dir = dir.Unit * math.min(1, (dir.Magnitude - 0.05) / (1 - 0.05))
					self.Move += Vector3.new(dir.X, 0, dir.Y)
				end
			end
			if self.Inputs.GP.DJ.Magnitude > 0.2 then
				self.Move += Vector3.new(self.Inputs.GP.DJ.X, 0, self.Inputs.GP.DJ.Y)
			end
			if self.Move.Magnitude > 1 then self.Move = self.Move.Unit end
			self.Jump = false
			if self.Inputs.KB.Space then
				self.Jump = true
			end
			if self.Inputs.TC.JB then
				self.Jump = true
			end
			if self.Inputs.GP.JB then
				self.Jump = true
			end
		end)
	end
	do -- Camera
		local self = Reanimate.Camera
		local function AdjustTouchPitchSensitivity(delta)
			local pitch = Camera.CFrame:ToEulerAnglesYXZ()
			if delta.Y * pitch >= 0 then
				return delta
			end
			local curveY = 1 - (2 * math.abs(pitch) / math.pi) ^ 0.75
			local sensitivity = curveY * 0.75 + 0.25
			return Vector2.new(1, sensitivity) * delta
		end
		local thumbstickCurve do
			local K_CURVATURE = 2 -- amount of upwards curvature (0 is flat)
			local K_DEADZONE = 0.1 -- deadzone
			function thumbstickCurve(x)
				local fDeadzone = (math.abs(x) - K_DEADZONE)/(1 - K_DEADZONE)
				local fCurve = (math.exp(K_CURVATURE*fDeadzone) - 1)/(math.exp(K_CURVATURE) - 1)
				return math.sign(x)*math.clamp(fCurve, 0, 1)
			end
		end
		UserInputService.InputBegan:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
					Reanimate.Shiftlocked = Reanimate.ShiftlockEnabled and not Reanimate.Shiftlocked
				end
				if input.KeyCode == Enum.KeyCode.Left then
					self.Inputs.KB.Left = true
				end
				if input.KeyCode == Enum.KeyCode.Right then
					self.Inputs.KB.Right = true
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonL3 then
				if self.VRMode then
					if self.Zoom < 7 then
						self.Zoom = 7
					else
						self.Zoom = 0.5
					end
				else
					if self.Zoom <= 0.5 then
						self.Zoom = 20
					elseif self.Zoom <= 10 then
						self.Zoom = 0.5
					elseif self.Zoom <= 20 then
						self.Zoom = 10
					else
						self.Zoom = 20
					end
				end
			end
			if input.KeyCode == Enum.KeyCode.ButtonR3 then
				if self.VRMode then
					-- laziest implementation
					VRService:RecenterUserHeadCFrame()
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				if gpe then return end
				self.Inputs.MS.RMB = true
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if gpe then return end
				if self.Inputs.TC.DJ == nil and IsInThumbstickArea(input.Position) then
					self.Inputs.TC.DJ = input
					return
				end
				self.Inputs.TC.Touch[input] = true
			end
		end)
		UserInputService.InputChanged:Connect(function(input, gpe)
			if GuiService.MenuIsOpen then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if self:IsMousePanning() then
					self:OnPanInput(Vector2.new(input.Delta.X, input.Delta.Y) * Vector2.new(1, 0.77) * math.rad(0.5), false)
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				if gpe then return end
				self:OnZoomInput(-input.Position.Z)
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					return
				end
				local touches = {}
				for touch,exist in self.Inputs.TC.Touch do
					if exist then table.insert(touches, touch) end
				end
				if #touches == 1 then
					if touches[1] == input then
						self:OnPanInput(Vector2.new(input.Delta.X, input.Delta.Y) * Vector2.new(1, 0.66) * math.rad(1), true)
					end
				end
				if #touches == 2 then
					local pinch = (touches[1].Position - touches[2].Position).Magnitude
					if self.Inputs.TC.LP then
						local zoom = (self.Inputs.TC.LP - pinch) * 0.04
						self:OnZoomInput(zoom)
					end
					self.Inputs.TC.LP = pinch
				else
					self.Inputs.TC.LP = nil
				end
			end
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				self.Inputs.GP.DJ = Vector2.new(thumbstickCurve(input.Position.X), -thumbstickCurve(input.Position.Y))
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if GuiService.MenuIsOpen then return end
			if UserInputService:GetFocusedTextBox() then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Left then
					self.Inputs.KB.Left = false
				end
				if input.KeyCode == Enum.KeyCode.Right then
					self.Inputs.KB.Right = false
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				self.Inputs.MS.RMB = false
			end
			if input.UserInputType == Enum.UserInputType.Touch then
				if self.Inputs.TC.DJ == input then
					self.Inputs.TC.DJ = nil
					return
				end
				self.Inputs.TC.LP = nil
				self.Inputs.TC.Touch[input] = false
			end
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				self.Inputs.GP.DJ = Vector2.zero
			end
		end)
		UserInputService.PointerAction:Connect(function(wheel, pan, pinch, gpe)
			if not gpe then
				self:OnPanInput(pan * Vector2.new(1, 0.77) * math.rad(7), false)
				self:OnZoomInput(-wheel - pinch)
			end
		end)
		local function resetInputDevices()
			self.Inputs:Reset()
		end
		UserInputService.WindowFocused:Connect(resetInputDevices)
		UserInputService.WindowFocusReleased:Connect(resetInputDevices)
		UserInputService.TextBoxFocusReleased:Connect(resetInputDevices)
		GuiService.MenuOpened:Connect(resetInputDevices)
		local states = {
			[false] = "rbxasset://textures/ui/mouseLock_off@2x.png",
			[true] = "rbxasset://textures/ui/mouseLock_on@2x.png"
		}
		local MobileShiftlock = Instance.new("ImageButton")
		MobileShiftlock.Parent = SCREENGUI
		MobileShiftlock.BackgroundTransparency = 1
		MobileShiftlock.Position = UDim2.new(1, -190, 1, -60)
		MobileShiftlock.Size = UDim2.new(0, 40, 0, 40)
		MobileShiftlock.Image = states[false]
		local state = false
		AddToRenderStep(function()
			local playerGui = Player:FindFirstChildOfClass("PlayerGui")
			local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
			if not touchGui or not touchGui.Enabled then
				MobileShiftlock.Visible = false
				return
			end
			local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
			local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
			if not jumpButton then
				MobileShiftlock.Visible = false
				return
			end
			if state ~= Reanimate.Shiftlocked then
				state = Reanimate.Shiftlocked
				MobileShiftlock.Image = states[state]
			end
			MobileShiftlock.Visible = not not Reanimate.Character
			local pos = jumpButton.AbsolutePosition - SCREENGUI.AbsolutePosition
			local size = jumpButton.AbsoluteSize
			local ratio = 4 / 7
			pos += Vector2.new(-size.X * (ratio + 0.2), size.Y * (1 - ratio))
			size *= ratio
			MobileShiftlock.Position = UDim2.fromOffset(pos.X, pos.Y)
			MobileShiftlock.Size = UDim2.fromOffset(size.X, size.Y)
		end)
		MobileShiftlock.Activated:Connect(function()
			Reanimate.Shiftlocked = Reanimate.ShiftlockEnabled and not Reanimate.Shiftlocked
		end)
		RunService:BindToRenderStep("Uhhhhhh_Camera", Enum.RenderPriority.Camera.Value + 1, function(dt)
			self.VRMode = VRService.VREnabled
			if UserInputService:GetFocusedTextBox() then
				resetInputDevices()
			end
			if self.Inputs.KB.Left then
				self:OnPanInput(Vector2.new(math.rad(-120) * dt, 0), true)
			end
			if self.Inputs.KB.Right then
				self:OnPanInput(Vector2.new(math.rad(120) * dt, 0), true)
			end
			self:OnPanInput(self.Inputs.GP.DJ * Vector2.new(1, 0.77) * math.rad(4) * 60 * dt * GameSettings.GamepadCameraSensitivity, true)
			local input = self.Input * Vector3.new(1, GameSettings:GetCameraYInvertValue(), 1)
			self.Input = Vector3.zero
			local zoomDelta = input.Z
			if math.abs(zoomDelta) > 0 then
				if zoomDelta > 0 then
					self.Zoom += zoomDelta * (1 + self.Zoom * 0.5)
				else
					self.Zoom = (self.Zoom + zoomDelta) / (1 - zoomDelta * 0.5)
				end
			end
			self.Zoom = math.clamp(self.Zoom, 0.5, 100000)
			local rzoom = self.Zoom
			if self.FPSLocked then
				self.Zoom = 0.5
				rzoom = 0.5
			end
			if self.VRMode then
				input *= Vector3.new(1, 0, 1)
				rzoom *= Reanimate.CharacterScale
				self._Zoom = rzoom
			end
			self._Zoom = rzoom + (self._Zoom - rzoom) * math.exp(-32 * dt)
			local ltm = Reanimate.LocalTransparencyModifier
			local tltm = 0
			local sltm = dt * 3
			if not self.Scriptable then
				if self:IsFirstPerson() then
					tltm = 1
				elseif rzoom < 1.5 * Reanimate.CharacterScale then
					tltm = 0.5
				end
			end
			if math.abs(ltm - tltm) <= sltm then
				ltm = tltm
			elseif ltm < tltm then
				ltm += sltm
			else
				ltm -= sltm
			end
			Reanimate.LocalTransparencyModifier = ltm
			if not Reanimate.ShiftlockEnabled and Reanimate.Shiftlocked then
				Reanimate.Shiftlocked = false
			end
			if Reanimate.Character then
				local targetMouseBehavior = Enum.MouseBehavior.Default
				if self:IsMousePanning() then
					if self:IsMouseLocked() then
						if UserInputService.TouchEnabled then
							targetMouseBehavior = Enum.MouseBehavior.LockCurrentPosition
						else
							targetMouseBehavior = Enum.MouseBehavior.LockCenter
						end
					else
						targetMouseBehavior = Enum.MouseBehavior.LockCurrentPosition
					end
				end
				if UserInputService.MouseBehavior ~= targetMouseBehavior then
					UserInputService.MouseBehavior = targetMouseBehavior
				end
				local targetMouseIcon = ""
				if Reanimate.Shiftlocked then
					targetMouseIcon = "rbxasset://textures/Cursors/CrossMouseIcon.png"
				end
				if UserInputService.MouseIcon ~= targetMouseIcon then
					UserInputService.MouseIcon = targetMouseIcon
				end
				if GameSettings.RotationType ~= Enum.RotationType.MovementRelative then
					GameSettings.RotationType = Enum.RotationType.MovementRelative
				end
				local Humanoid = Reanimate.Character:FindFirstChildOfClass("Humanoid")
				local RootPart = Reanimate.Character:FindFirstChild("HumanoidRootPart")
				if Humanoid and RootPart and Camera.CameraSubject == Humanoid then
					if self.Scriptable then
						Camera.FieldOfView = self.FieldOfView
						Camera.FieldOfViewMode = "Vertical"
					else
						Camera.FieldOfView = 70
						Camera.FieldOfViewMode = "Vertical"
						local newCameraCFrame, newCameraFocus = self.CFrame, self.Focus
						local subjectPosition = RootPart.Position + RootPart.CFrame.UpVector * 1.5
						if not self.VRMode then subjectPosition += RootPart.CFrame.Rotation * Humanoid.CameraOffset end
						local currLookVector = suppliedLookVector or newCameraCFrame.LookVector
						local currPitchAngle = math.asin(currLookVector.Y)
						local constrainedRotateInput = Vector2.new(input.X, math.clamp(input.Y, math.rad(-80) + currPitchAngle, math.rad(80) + currPitchAngle))
						local startCFrame = CFrame.lookAt(Vector3.zero, currLookVector)
						local newLookCFrame = CFrame.Angles(0, -constrainedRotateInput.X, 0) * startCFrame * CFrame.Angles(-constrainedRotateInput.Y, 0, 0)
						local newLookVector = newLookCFrame.LookVector
						if self.VRMode then
							newLookVector = (newLookVector * Vector3.new(1, 0, 1)).Unit
							if newLookVector.Magnitude == 0 or newLookVector ~= newLookVector then
								newLookVector = Vector3.zAxis
							end
						end
						if self:IsMouseLocked() and not self:IsFirstPerson() then
							local cameraRelativeOffset = newLookCFrame * Vector3.new(1.7, 0, 0)
							if cameraRelativeOffset == cameraRelativeOffset then
								subjectPosition += cameraRelativeOffset
							end
						end
						newCameraFocus = CFrame.new(subjectPosition)
						local cameraFocusP = newCameraFocus.Position
						if self.VRMode then
							cameraFocusP += newLookVector * 0.5
						end
						newCameraCFrame = CFrame.lookAt(cameraFocusP - newLookVector * self._Zoom, cameraFocusP)
						self.CFrame, self.Focus = newCameraCFrame, newCameraFocus
					end
					Camera.CFrame, Camera.Focus = self.CFrame, self.Focus
				end
				for _,v in Reanimate.CharacterLTMs do
					v.LocalTransparencyModifier = ltm
				end
			end
			pcall(function() CoreGui.TopBarApp.TopBarApp.FullScreenFrame.HurtOverlay.Visible = false end)
		end)
	end
end
Reanimate.CameraLockCharacter = function()
	local RCRootPart = Reanimate.Character and Reanimate.Character:FindFirstChild("HumanoidRootPart")
	if RCRootPart and RCRootPart:IsA("BasePart") then
		local ccf = Reanimate.Camera:GetMovementCFrame()
		local rcf = RCRootPart.CFrame
		local ax, ay, az = ccf:ToEulerAngles(Enum.RotationOrder.YXZ)
		local bx, by, bz = rcf:ToEulerAngles(Enum.RotationOrder.YXZ)
		RCRootPart.CFrame = CFrame.fromEulerAngles(bx, ay, bz, Enum.RotationOrder.YXZ) + rcf.Position
	end
end
Reanimate.CreateCharacter = function(InitCFrame)
	local RC = Reanimate.Character
	local cf = CFrame.new(Camera.Focus.Position)
	if RC then
		local r = RC:FindFirstChild("HumanoidRootPart")
		if r then
			cf = r.CFrame
		end
		RC:Destroy()
	elseif Player.Character then
		local r = Player.Character:FindFirstChild("HumanoidRootPart")
		if r then
			cf = r.CFrame
		end
	end
	if InitCFrame then
		cf = InitCFrame
	end
	Reanimate.Camera.CFrame, Reanimate.Camera.Focus = Camera.CFrame, Camera.Focus
	Reanimate.Camera:OnReset()
	RC = CreateHumanoidCharacter()
	RC.ModelStreamingMode = "Persistent"
	Player.ReplicationFocus = workspace
	local ltmparts = Reanimate.CharacterLTMs
	table.clear(ltmparts)
	local function OnDescendant(v)
		local exist = pcall(function()
			return v.LocalTransparencyModifier
		end)
		if exist then
			table.insert(ltmparts, v)
			local conn = nil
			conn = v.AncestryChanged:Connect(function()
				if not v:IsDescendantOf(RC) then
					local i = table.find(ltmparts, v)
					if i then
						table.remove(ltmparts, i)
					end
					conn:Disconnect()
				end
			end)
		end
	end
	RC.DescendantAdded:Connect(OnDescendant)
	for _,v in RC:GetDescendants() do
		task.spawn(OnDescendant, v)
	end
	RC:ScaleTo(Reanimate.CharacterScale)
	local RCHumanoid, RCRootPart = RC.Humanoid, RC.HumanoidRootPart
	local RCHead, RCTorso, RCRootJoint, RCNeck = RC.Head, RC.Torso, RCRootPart.RootJoint, RC.Torso.Neck
	--[[local Anchor = Instance.new("Part", RCRootPart)
	Anchor.Name = "i can take explosions >:3"
	Anchor.Transparency = 1
	Anchor.Anchored = false
	Anchor.CanCollide = false
	Anchor.CanQuery = false
	Anchor.CanTouch = false
	Anchor.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 0, 0)
	Anchor.Size = Vector3.new(2048, 2048, 2048)
	local AnchorWeld = Instance.new("Weld")]]
	local BodyForce = Instance.new("BodyForce")
	BodyForce.Parent = RCRootPart
	BodyForce.Force = Vector3.zero
	RC.Parent = workspace
	RCRootPart.RootPriority = 67
	RCRootPart.CFrame = cf
	local SafeY = cf.Y
	local IsFloat = false
	local SeatWeld = nil
	local LastJumpOffSeat = 0
	RCHumanoid.Touched:Connect(function(part, limb)
		if Reanimate.SeatSit and part:IsA("Seat") and not RCHumanoid.Sit and os.clock() - LastJumpOffSeat > 2 then
			RCHumanoid.Sit = true
			if SeatWeld ~= nil then
				SeatWeld = SeatWeld:Destroy()
			end
			SeatWeld = Instance.new("Weld")
			SeatWeld.Name = "hell yeah!! :3"
			SeatWeld.Parent = RCRootPart
			SeatWeld.Part0 = part
			SeatWeld.Part1 = RCRootPart
			SeatWeld.C0 = CFrame.new(0, part.Size.Y / 2, 0)
			SeatWeld.C1 = CFrame.new(0, -1.5 * RC:GetScale(), 0)
			Util.LinkDestroyI2C(SeatWeld, RCHumanoid:GetPropertyChangedSignal("Jump"):Connect(function()
				if RCHumanoid.Jump then
					RCHumanoid.Sit = false
					SeatWeld:Destroy()
				end
			end))
		end
		if part.Name == "Handle" and part.Parent:IsA("Tool") and not part.Parent.Parent:FindFirstChildOfClass("Humanoid") then
			if Reanimate.ToolGrab then
				if Player.Character then
					local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						Humanoid:EquipTool(part.Parent)
					end
				end
			end
		end
	end)
	RCHumanoid.Seated:Connect(function(active)
		if not active then
			if SeatWeld ~= nil then
				SeatWeld = SeatWeld:Destroy()
			end
			LastJumpOffSeat = os.clock()
		end
	end)
	local LastJump = false
	local RCP = RaycastParams.new()
	RCP.RespectCanCollide = true
	RCP.FilterType = Enum.RaycastFilterType.Exclude
	RCP.FilterDescendantsInstances = {RC}
	local noclipStates = {"Running", "Jumping", "Freefall", "Landed", "Climbing", "Swimming"}
	local fallingStates = {"Jumping", "Freefall", "PlatformStanding", "Physics", "Ragdoll", "GettingUp", "Seated", "Flying", "FallingDown"}
	local LastSafest = RCRootPart.CFrame
	local CMove, CJump = Vector3.zero, false
	Util.LinkDestroyI2C(RC, RunService.PreAnimation:Connect(function(dt)
		CMove, CJump = Reanimate.Control.Move, Reanimate.Control.Jump
		local CamCF = Reanimate.Camera:GetMovementCFrame()
		local _,x,_ = CamCF:ToEulerAngles(Enum.RotationOrder.YXZ)
		local MoveCF = CFrame.Angles(0, x, 0)
		pcall(sethiddenproperty, RCRootPart, "PhysicsRepRootPart", nil)
		local scale = Reanimate.CharacterScale
		if scale ~= RC:GetScale() then
			RC:ScaleTo(scale)
		end
		local force = Vector3.zero
		local RCHumanoidState = RCHumanoid:GetState().Name
		if RCHumanoidState == "Swimming" then
			force += Vector3.new(0, workspace.Gravity * 0.5, 0) * RCRootPart.AssemblyMass
		end
		local gravaff = not not table.find(fallingStates, RCHumanoidState)
		if gravaff then
			if Reanimate.ScaleGravity and not RCRootPart:IsGrounded() then
				force += Vector3.new(0, -workspace.Gravity * (scale - 1), 0) * RCRootPart.AssemblyMass
			end
		end
		if LastJump ~= CJump then
			if CJump then
				if Reanimate.InfiniteJump and RCHumanoid:GetState() == Enum.HumanoidStateType.Freefall and RCHumanoid.JumpPower > 0 then
					RCRootPart.Velocity = Vector3.new(
						RCRootPart.Velocity.X, RCHumanoid.JumpPower, RCRootPart.Velocity.Z
					)
				end
			end
		end
		LastJump = CJump
		local TargetCameraPosition = RCRootPart.CFrame * Vector3.new(0, 1.5 * scale, 0)
		if RCRootJoint.Active then
			TargetCameraPosition = RCTorso.CFrame * Vector3.new(0, 1.5 * scale, 0)
			if RCNeck.Active then
				TargetCameraPosition = RCHead.Position
			end
		end
		local TargetCameraOffset = (RCRootPart.CFrame * CFrame.new(0, 1.5, 0)):PointToObjectSpace(TargetCameraPosition)
		if not Reanimate.SmoothCam then
			TargetCameraOffset = Vector3.new(0, -1.5, 0) + Vector3.new(0, 1.5, 0) * scale
		end
		RCHumanoid.CameraOffset = TargetCameraOffset:Lerp(RCHumanoid.CameraOffset, math.exp(-9.8 * dt))
		if RCHumanoidState == "Swimming" then
			RCHumanoid:Move(CamCF:VectorToWorldSpace(CMove))
		else
			RCHumanoid:Move(MoveCF:VectorToWorldSpace(CMove))
		end
		RCHumanoid.Jump = CJump
		BodyForce.Force = force
		if RCRootPart.Position.Y < FallenPartsDestroyHeight + 3 * Reanimate.CharacterScale then
			RCRootPart.CFrame = LastSafest
			RCRootPart.Velocity = Vector3.new(0, 50, 0)
			RCRootPart.RotVelocity = Vector3.zero
		end
	end))
	Util.LinkDestroyI2C(RC, RunService.PreSimulation:Connect(function(dt)
		local RCHumanoidState = RCHumanoid:GetState().Name
		local clip = not table.find(noclipStates, RCHumanoidState)
		for _,v in RC:GetChildren() do
			if v:IsA("BasePart") then
				v.CanCollide = clip or (not Reanimate.Noclip and v == RCRootPart)
			end
		end
	end))
	Util.LinkDestroyI2C(RC, RunService.PostSimulation:Connect(function(dt)
		RCHumanoid.Jump = CJump
		local tcf, pos = RCRootPart.CFrame.Rotation, RCRootPart.CFrame.Position
		local RCHumanoidState = RCHumanoid:GetState().Name
		local safe = true
		local void = true
		for i=1, 8 do
			local off = CFrame.Angles(0, (i / 4) * math.pi, 0):VectorToWorldSpace(Vector3.new(0, 0, -0.5))
			local r = workspace:Raycast(RCRootPart.Position + off, Vector3.new(0, -65536, 0), RCP)
			if r then
				void = false
				if r.Distance > 3 * Reanimate.CharacterScale + 8 + RCHumanoid.HipHeight then
					safe = false
				end
			else
				safe = false
			end
		end
		if safe then
			LastSafest = RCRootPart.CFrame
		end
		if RCHumanoidState == "Climbing" or not void then
			SafeY = pos.Y
			IsFloat = false
		else
			IsFloat = true
		end
		if Reanimate.PatchmaVoidFloat and IsFloat then
			pos = Vector3.new(pos.X, SafeY, pos.Z)
			RCRootPart.Velocity *= Vector3.new(1, 0, 1)
		end
		RCRootPart.CFrame = tcf + pos
		if Reanimate:ShouldRotationType() then
			Reanimate:CameraLockCharacter()
		end
	end))
	Reanimate.Character = RC
	_G_Uhhhhhh.Character = RC
end
Reanimate.DestroyCharacter = function()
	if Reanimate.Character then
		Reanimate.Character = Reanimate.Character:Destroy()
		_G_Uhhhhhh.Character = nil
	end
end

do
	local AntiflingHumanoids = {}
	local AntiflingBaseParts = {}
	local OnStepped = function()
		for i,v in AntiflingBaseParts do
			if v:IsDescendantOf(workspace) then
				if v.CanCollide then v.CanCollide = false end
				v.AssemblyLinearVelocity, v.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
			else
				table.remove(AntiflingBaseParts, i)
			end
		end
		for i,v in AntiflingHumanoids do
			if v:IsDescendantOf(workspace) then
				if v.EvaluateStateMachine then v.EvaluateStateMachine = false end
			else
				table.remove(AntiflingHumanoids, i)
			end
		end
	end
	RunService.PreAnimation:Connect(OnStepped)
	RunService.PreSimulation:Connect(OnStepped)
	RunService.Stepped:Connect(OnStepped)
	local OnBasePart = function(v)
		if v:IsA("BasePart") then
			v.CanCollide = false
			if not table.find(AntiflingBaseParts, v) then
				table.insert(AntiflingBaseParts, v)
			end
		end
		if v:IsA("Humanoid") then
			v.EvaluateStateMachine = false
			if not table.find(AntiflingHumanoids, v) then
				table.insert(AntiflingHumanoids, v)
			end
		end
	end
	local OnCharacter = function(character)
		character.DescendantAdded:Connect(OnBasePart)
		for _,v in character:GetDescendants() do
			OnBasePart(v)
		end
	end
	local OnPlayer = function(player)
		if player == Player then return end
		player.CharacterAdded:Connect(OnCharacter)
		if player.Character then OnCharacter(player.Character) end
	end
	Players.PlayerAdded:Connect(OnPlayer)
	for _,player in Players:GetPlayers() do
		OnPlayer(player)
	end
end

local HumanoidLASetHookState
if ismissing(hookmetamethod) or ismissing(hookfunction) then
	HumanoidLASetHookState = function(hooked) end
else
	local LoadAnimation_old = nil
	local function LoadAnimation_new(animation)
		local char = Instance.new("Model")
		char.Parent = workspace
		local hum = Instance.new("Humanoid")
		hum.Parent = char
		local anim = LoadAnimation_old(hum, animation)
		hum.Parent = nil
		char:Destroy()
		--warn("LoadAnimation prevented!")
		return anim
	end
	local LoadAnimation_nc = nil
	local _HumanoidDummy = Instance.new("Humanoid")
	local _HumanoidLA = _HumanoidDummy.LoadAnimation
	local newloadanimation = newcclosure(function(self, animation)
		if not checkcaller() and typeof(self) == "Instance" and (self:IsA("Humanoid") or self:IsA("Animator")) and typeof(animation) == "Instance" and animation:IsA("Animation") then
			return LoadAnimation_new(animation)
		end
		return LoadAnimation_old(self, animation)
	end)
	local newnamecall = newcclosure(function(...)
		local method = getnamecallmethod()
		if not checkcaller() and method and (method == "LoadAnimation" or method == "loadAnimation") then
			local self, animation = ...
			if typeof(self) == "Instance" and (self:IsA("Humanoid") or self:IsA("Animator")) and typeof(animation) == "Instance" and animation:IsA("Animation") then
				return LoadAnimation_new(animation)
			end
		end
		return LoadAnimation_nc(...)
	end)
	HumanoidLASetHookState = function(hooked)
		if hooked then
			if not LoadAnimation_old then
				LoadAnimation_old = hookfunction(_HumanoidLA, clonefunction(newloadanimation))
			end
			if not LoadAnimation_nc then
				LoadAnimation_nc = hookmetamethod(_HumanoidDummy, "__namecall", clonefunction(newnamecall))
			end
		else
			if LoadAnimation_old then
				hookfunction(_HumanoidLA, LoadAnimation_old)
				LoadAnimation_old = nil
			end
			if LoadAnimation_nc then
				hookmetamethod(_HumanoidDummy, "__namecall", LoadAnimation_nc)
				LoadAnimation_nc = nil
			end
		end
	end
end

Util.SetMotor6DTransform = function(motor, transform)
	local name = motor.Name
	motor.MaxVelocity = 9e9
	local _, _, angle = transform:ToEulerAngles(Enum.RotationOrder.ZYX)
	motor.DesiredAngle = angle
	motor:SetDesiredAngle(angle)
	local axis, angle = transform:ToAxisAngle()
	local newangle = axis * angle
	pcall(sethiddenproperty, motor, "ReplicateCurrentOffset6D", transform.Position)
	pcall(sethiddenproperty, motor, "ReplicateCurrentAngle6D", newangle)
end
Util.SetMotor6DOffset = function(motor, offset)
	Util.SetMotor6DTransform(motor, motor.C0:Inverse() * offset * motor.C1)
end

Util.ShowPartHitbox = function(part)
	local w = Instance.new("WireframeHandleAdornment")
	w.Name = "TempWireframe"
	w.Adornee = part
	w.Color3 = Color3.new(0, 1, 0)
	w.Transparency = 0
	w.ZIndex = 10
	w.AlwaysOnTop = true
	w.Thickness = 1
	w.Parent = SCREENGUI
	local hs = part.Size / 2
	local verts = {
		Vector3.new(-hs.X, -hs.Y, -hs.Z),
		Vector3.new( hs.X, -hs.Y, -hs.Z),
		Vector3.new( hs.X,  hs.Y, -hs.Z),
		Vector3.new(-hs.X,  hs.Y, -hs.Z),
		Vector3.new(-hs.X, -hs.Y,  hs.Z),
		Vector3.new( hs.X, -hs.Y,  hs.Z),
		Vector3.new( hs.X,  hs.Y,  hs.Z),
		Vector3.new(-hs.X,  hs.Y,  hs.Z),
	}
	w:AddLine(verts[1], verts[2])
	w:AddLine(verts[2], verts[3])
	w:AddLine(verts[3], verts[4])
	w:AddLine(verts[4], verts[1])
	w:AddLine(verts[5], verts[6])
	w:AddLine(verts[6], verts[7])
	w:AddLine(verts[7], verts[8])
	w:AddLine(verts[8], verts[5])
	w:AddLine(verts[1], verts[5])
	w:AddLine(verts[2], verts[6])
	w:AddLine(verts[3], verts[7])
	w:AddLine(verts[4], verts[8])
	Debris:AddItem(w, 1)
end

local RIGHTGRIP_C0 = CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
Util.PredictionFling = function(target)
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			target = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
		end
		if target and target:IsA("BasePart") then
			if not target:IsDescendantOf(workspace) then
				return CFrame.identity, true
			end
			local t = os.clock()
			local t2 = math.sin(t * 15) + 1
			local cf = target.CFrame * CFrame.Angles(1.57, 0, 0)
			if not Reanimate.UsePhysicsRepRootPart then
				cf += target.AssemblyLinearVelocity * t2 + Vector3.new(0, -workspace.Gravity * 0.5 * t2 * t2 + math.sin(t * 60), 0)
				if cf.Position.Y < target.Position.Y - 1 then
					cf = cf.Rotation + Vector3.new(cf.Position.X, target.Position.Y - 1, cf.Position.Z)
				end
			end
			--cf += Vector3.new(0, -0.5, 0)
			local oldpos = target:GetAttribute("_Uhhhhhh_LastPosition")
			if not oldpos then
				oldpos = target.Position
				target:SetAttribute("_Uhhhhhh_LastPosition", oldpos)
			end
			if (target.Position - oldpos).Magnitude > 200 then
				target:SetAttribute("_Uhhhhhh_LastPosition", nil)
				return cf, true
			end
			return cf, false
		end
	end
	if typeof(target) == "CFrame" then
		return target, false
	end
	if typeof(target) == "Vector3" then
		return CFrame.new(target), false
	end
	return CFrame.identity, true
end
Util.PredictionFlingPart = function(target)
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			target = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
		end
		if target and target:IsA("BasePart") then
			return target
		end
	end
end

SaveData.Reanimator = SaveData.Reanimator or {}

local LimbReanimator = {}
LimbReanimator.Name = "Limbs"
SaveData.Reanimator.LimbMode = SaveData.Reanimator.LimbMode or 0
SaveData.Reanimator.LimbVelocity = SaveData.Reanimator.LimbVelocity or 0
SaveData.Reanimator.LimbInitMode = SaveData.Reanimator.LimbInitMode or 2
SaveData.Reanimator.LimbReplicateFPS10 = not not SaveData.Reanimator.LimbReplicateFPS10
SaveData.Reanimator.LimbRoleplay = not not SaveData.Reanimator.LimbRoleplay
SaveData.Reanimator.LimbUseNaNFling = not not SaveData.Reanimator.LimbUseNaNFling
LimbReanimator.Mode = SaveData.Reanimator.LimbMode
-- 0 = hide rootpart (defaults to 2 when streaming is enabled)
-- 1 = put rootpart just under void (defaults to 2 when streaming is enabled)
-- 2 = keep rootpart streamed, puts rootpart below character
-- 3 = currentangle styled
-- 4 = rootpart is torso (most interpolated mode)
LimbReanimator.Velocity = SaveData.Reanimator.LimbVelocity
-- 0 = no velocity
-- 1 = copy from fake character
-- 2 = fling-y velocity
LimbReanimator.InitMode = SaveData.Reanimator.LimbInitMode
-- 0 = just reset
-- 1 = time permadeath, and reset
-- 2 = time permadeath, "without reset"
LimbReanimator.ReplicateFPS10 = SaveData.Reanimator.LimbReplicateFPS10
LimbReanimator.FlingEnabled = not SaveData.Reanimator.LimbRoleplay
LimbReanimator.UseNaNFling = SaveData.Reanimator.LimbUseNaNFling
LimbReanimator.FlingTargets = {}
LimbReanimator._TempNotFling = {}
function LimbReanimator.ShowHitboxes()
	Util.UINotify("Just a useless option")
	pcall(function()
		Util.ShowPartHitbox(Player.Character.HumanoidRootPart)
	end)
end
function LimbReanimator.Fling(target, duration)
	if not LimbReanimator.FlingEnabled then return end
	if not target then return false end
	for _,v in LimbReanimator.FlingTargets do
		if v.Target == target then
			return false
		end
	end
	if target == Reanimate.Character then return false end
	if target == Player.Character then return false end
	if typeof(target) == "Instance" then
		if LimbReanimator._TempNotFling[target] then return end
		LimbReanimator._TempNotFling[target] = true
		task.delay(1, function()
			LimbReanimator._TempNotFling[target] = nil
		end)
	end
	table.insert(LimbReanimator.FlingTargets, {
		Target = target,
		Duration = duration
	})
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			local h = Util.Instance("Highlight")
			h.Adornee = target
			h.FillColor = Color3.new(1, 0, 0)
			h.OutlineColor = Color3.new(1, 0, 0)
			h.FillTransparency = 0.5
			h.OutlineTransparency = 0
			h.Parent = target
			TweenService:Create(h, TweenInfo.new(5), {
				FillTransparency = 1,
				OutlineTransparency = 1
			}):Play()
			game.Debris:AddItem(h, 5)
		end
	end
	return true
end
function LimbReanimator.SetRootPartMode(mode)
	assert(typeof(mode) == "number")
	LimbReanimator.Mode = mode
end
function LimbReanimator.Config(parent)
	UI.CreateText(parent, "as mentioned in the README, this only works for SOME games,\nbecause 'modern' games create the Animator automatically which breaks limb reanimation", 10, Enum.TextXAlignment.Center)
	local dmode = UI.CreateDropdown(parent, "RootPart Mode", {"RootPart in very void", "RootPart in void", "Keep RootPart Streamed", "CurrentAngle Style", "RootPart is Torso"}, LimbReanimator.Mode + 1)
	local dvel = UI.CreateDropdown(parent, "RootPart Velocity", {"No Velocity", "Follow Character", "Fling-like"}, LimbReanimator.Velocity + 1)
	local dinit = UI.CreateDropdown(parent, "Init Mode", {"Reset Character", "CDSB + Reset", "CDSB + SSE + Kill"}, LimbReanimator.InitMode + 1)
	dmode.Changed:Connect(function(val)
		LimbReanimator.Mode = val - 1
		SaveData.Reanimator.LimbMode = val - 1
	end)
	dvel.Changed:Connect(function(val)
		LimbReanimator.Velocity = val - 1
		SaveData.Reanimator.LimbVelocity = val - 1
	end)
	dinit.Changed:Connect(function(val)
		LimbReanimator.InitMode = val - 1
		SaveData.Reanimator.LimbInitMode = val - 1
	end)
	UI.CreateSwitch(parent, "Show me how I look!", LimbReanimator.ReplicateFPS10).Changed:Connect(function(val)
		LimbReanimator.ReplicateFPS10 = val
		SaveData.Reanimator.LimbReplicateFPS10 = val
	end)
	UI.CreateSwitch(parent, "Target Fling Enabled", LimbReanimator.FlingEnabled).Changed:Connect(function(val)
		LimbReanimator.FlingEnabled = val
		SaveData.Reanimator.LimbRoleplay = not val
	end)
	UI.CreateText(parent, "vvv touch player = they lose ownership vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Use NaN State Fling", LimbReanimator.UseNaNFling).Changed:Connect(function(val)
		LimbReanimator.UseNaNFling = val
		SaveData.Reanimator.LimbUseNaNFling = val
	end)
	Util.LinkDestroyI2C(dmode, RunService.Heartbeat:Connect(function()
		dmode.Value = LimbReanimator.Mode + 1
		dvel.Value = LimbReanimator.Velocity + 1
		dinit.Value = LimbReanimator.InitMode + 1
	end))
end
function LimbReanimator.Start()
	local LimbNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
	local rootposition = Vector3.new(
		math.random(-65536, 65536),
		math.random(-70000, -60000),
		math.random(-65536, 65536)
	)
	local rootposition2 = Vector3.new(
		math.random(-2048, 2048),
		math.random(-500, -100) + FallenPartsDestroyHeight,
		math.random(-2048, 2048)
	)
	local InitCFrame = nil
	if Player.Character then
		local h = Player.Character:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			local r = h.RootPart
			InitCFrame = r.CFrame
			if h:GetState() ~= Enum.HumanoidStateType.Dead then
				h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				h:ChangeState(Enum.HumanoidStateType.Dead)
			end
		end
	end

	local LimbMapping = loadstring(readfile("UhhhhhhReanim/BuiltinModules/d_limbmap.lua"))()

	local FakeTools = {}
	local function CreateFakeTool()
		local FakeTool = Instance.new("Tool")
		FakeTool.Name = "faketool"
		local FakeToolHandle = Instance.new("Part")
		FakeToolHandle.Name = "Handle"
		FakeToolHandle.Transparency = 1
		FakeToolHandle.Color = Color3.new(0, 0, 1)
		FakeToolHandle.CanCollide = false
		FakeToolHandle.Massless = true
		FakeToolHandle.Parent = FakeTool
		FakeTool.Parent = Reanimate.Character
		local RightGrip = Instance.new("Weld")
		RightGrip.Name = "RightGrip"
		RightGrip.Parent = FakeToolHandle
		RightGrip.Part0 = Reanimate.Character and Reanimate.Character:FindFirstChild("Right Arm")
		RightGrip.Part1 = FakeToolHandle
		RightGrip.C0 = RIGHTGRIP_C0
		Util.LinkDestroyI2C(FakeTool, FakeTool:GetPropertyChangedSignal("Grip"):Connect(function()
			RightGrip.C1 = FakeTool.Grip
		end))
		RightGrip.C1 = FakeTool.Grip
		return FakeTool
	end

	local BaseParts = {}
	local UnknownMotor6Ds = {}
	local CharOnDesc = function(v)
		if v:IsA("BasePart") then
			if not table.find(BaseParts, v) then
				table.insert(BaseParts, v)
				v.CanCollide = false
				v:GetPropertyChangedSignal("CanCollide"):Connect(function()
					if v.CanCollide then v.CanCollide = false end
				end)
			end
		elseif v:IsA("Motor6D") then
			repeat task.wait() until (not v:IsDescendantOf(workspace)) or (v.Part0 and v.Part1)
			if not v:IsDescendantOf(workspace) then return end
			local p0, p1 = v.Part0, v.Part1
			if p0 and p1 then
				p0, p1 = p0.Name, p1.Name
				for _,map in LimbMapping do
					if map.Part0 == p0 and map.Part1 == p1 then
						map.Reference = v
						return
					end
				end
			end
			table.insert(UnknownMotor6Ds, v)
		elseif v:IsA("Animator") then
			task.defer(v.Destroy, v)
		elseif v:IsA("LocalScript") and v.Parent == Player.Character then
			v.Enabled = false
			v:GetPropertyChangedSignal("Enabled"):Connect(function()
				if v.Enabled then v.Enabled = false end
			end)
			v:GetPropertyChangedSignal("Disabled"):Connect(function()
				if not v.Disabled then v.Disabled = true end
			end)
		elseif v:IsA("Tool") and v.Parent == Player.Character then
			if not FakeTools[v] then
				FakeTools[v] = true
				local fake = CreateFakeTool()
				fake.Grip = v.Grip
				local h = v:FindFirstChild("Handle")
				if h ~= nil then
					fake.Handle.Size = h.Size
				end
				Util.LinkDestroyI2C(fake, RunService.PreSimulation:Connect(function()
					if v.Parent == Player.Character then
						fake.Grip = v.Grip
						local h = v:FindFirstChild("Handle")
						if h ~= nil then
							fake.Handle.Size = h.Size
						end
					else
						fake:Destroy()
						FakeTools[v] = nil
					end
				end))
				Util.LinkDestroyI2C(fake, v.ChildAdded:Connect(function(v)
					if v.ClassName == "StringValue" and v.Name == "toolanim" then
						local w = Instance.new("StringValue")
						w.Name = "toolanim"
						w.Value = v.Value
						w.Parent = fake
						Debris:AddItem(v, 1)
						Debris:AddItem(w, 1)
					end
				end))
				fake.Handle.Touched:Connect(function(t)
					local h = v:FindFirstChild("Handle")
					if h and t and h:IsDescendantOf(workspace) and t:IsDescendantOf(workspace) then
						h.CanTouch = true
						pcall(firetouchinterest, h, t, 0)
					end
				end)
				fake.Handle.TouchEnded:Connect(function(t)
					local h = v:FindFirstChild("Handle")
					if h and t and h:IsDescendantOf(workspace) and t:IsDescendantOf(workspace) then
						h.CanTouch = true
						pcall(firetouchinterest, h, t, 1)
					end
				end)
			end
		end
	end
	local lastspawn = 0
	local CharConn = Player.CharacterAdded:Connect(function(character)
		local camcfr = Camera.CFrame
		RunService.PreRender:Once(function()
			RunService.PreAnimation:Wait()
			Camera.CFrame = camcfr
		end)
		lastspawn = os.clock()
		table.clear(BaseParts)
		table.clear(UnknownMotor6Ds)
		for _,map in LimbMapping do
			map.Reference = nil
		end
		character.DescendantAdded:Connect(CharOnDesc)
		for _,v in character:GetDescendants() do
			task.spawn(CharOnDesc, v)
		end
		local humanoid = character:WaitForChild("Humanoid", 5)
		local stupid = humanoid:FindFirstChildWhichIsA("Animator")
		if stupid then
			stupid:Destroy()
		end
		if not Reanimate.UseLoadAnimationHook then
			stupid = character:FindFirstChild("Animate")
			while not stupid do
				character.ChildAdded:Wait()
				stupid = character:FindFirstChild("Animate")
			end
			stupid:Destroy()
		end
	end)
	Player.CharacterAdded:Wait()
	Reanimate.CreateCharacter(InitCFrame)

	local lastrep = 0
	local function UpdateTransforms(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf)
		if not RootPart:IsGrounded() then
			if flingtarget then
				if LimbReanimator.UseNaNFling then
					RootPart.CFrame = CFrame.new(flingcf.Position + Vector3.new(0, 0, math.random(0, 1) * 0.005)) * CFrame.Angles(0, os.clock() * 15, 0)
					RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
				else
					RootPart.CFrame = flingcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
					RootPart.Velocity, RootPart.RotVelocity = Vector3.new(0, -16384, 0), Vector3.one * 16384
				end
				pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil)
			else
				RootPart.CFrame = rootcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
				RootPart.Velocity, RootPart.RotVelocity = rootvel, Vector3.zero
				pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
			end
		end
		local dorep = true
		if LimbReanimator.ReplicateFPS10 then
			dorep = false
			local b = os.clock()
			local a = b - lastrep
			if a >= 1 / 10 then
				dorep = true
				a %= 1 / 10
				lastrep = b - a
			end
		end
		for _,v in UnknownMotor6Ds do
			Util.SetMotor6DTransform(v, CFrame.identity)
		end
		for _,map in LimbMapping do
			local v = map.Reference
			if v then
				if flingtarget then
					Util.SetMotor6DTransform(v, CFrame.identity)
				else
					local cf = CFrame.identity
					local p0, p1 = ReanimCharacter:FindFirstChild(map.RPart0), ReanimCharacter:FindFirstChild(map.RPart1)
					if map.RPart0 == "ROOT" then
						p0 = RootPart
					end
					if p0 and p1 then
						if map.Type == 1 then
							cf = p0.CFrame:ToObjectSpace(p1.CFrame)
						end
						if map.Type == 2 then
							local offset = map.Offset or CFrame.identity
							local c0, c1 = CFrame.new(map.C0), CFrame.new(map.C1)
							local transform = offset * (p0.CFrame * c0):ToObjectSpace(p1.CFrame * c1) * offset:Inverse()
							cf = v.C0 * transform * v.C1:Inverse()
						end
					end
					if dorep or not map.CFrame then
						map.CFrame = cf
					end
					Util.SetMotor6DOffset(v, map.CFrame)
				end
			end
		end
	end

	Reanimate.Starting = false
	while not Reanimate.Stopping do
		RunService.PreSimulation:Wait()
		workspace.FallenPartsDestroyHeight = 0/0
		local ReanimOkay = false
		local Character, Humanoid, RootPart = Player.Character, nil, nil
		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				Humanoid.AutoRotate = false
				if Humanoid.WalkSpeed < 1 then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid.JumpPower < 1 then
					Humanoid.JumpPower = 50
				end
				RootPart = Humanoid.RootPart
				if RootPart and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
					Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
					ReanimOkay = LimbReanimator.FlingTargets[1] == nil
				end
			end
		end
		local rootcf = CFrame.new(rootposition)
		local rootvel = Vector3.zero
		local ltm = Reanimate.LocalTransparencyModifier
		local ReanimCharacter = Reanimate.Character
		if ReanimCharacter then
			local RCHumanoid = ReanimCharacter:FindFirstChildOfClass("Humanoid")
			local RCRootPart = ReanimCharacter:FindFirstChild("HumanoidRootPart")
			local RCTorso = ReanimCharacter:FindFirstChild("Torso")
			if Camera then
				Camera.CameraSubject = RCHumanoid
			end
			for _,v in BaseParts do
				v.CanCollide = false
				v.Velocity = Vector3.zero
				v.RotVelocity = Vector3.zero
				if not v:FindFirstAncestorWhichIsA("Tool") then
					local lltm = ltm
					if Reanimate.FirstPersonBody then
						lltm = 0
						if v.Name == "Head" then
							lltm = ltm
						else
							local lol = v:FindFirstChild("AccessoryWeld")
							if lol and lol:IsA("Weld") and lol.Part1 and lol.Part1.Name == "Head" then
								lltm = ltm
							end
						end
					end
					v.LocalTransparencyModifier = lltm
				end
			end
			for _,v in ReanimCharacter:GetChildren() do
				if v:IsA("BasePart") then
					if table.find(LimbNames, v.Name) then
						v.Transparency = ReanimOkay and 1 or Reanimate.PlaceholderTransparency
					end
				end
			end
			if Character and Humanoid and RootPart then
				RunService.Heartbeat:Wait()
				local t = os.clock()
				if RCRootPart and RCTorso then
					if LimbReanimator.Mode == 1 then
						rootcf = CFrame.new(rootposition2)
					end
					if LimbReanimator.Mode == 2 or workspace.StreamingEnabled then
						rootcf = CFrame.new(RCRootPart.Position + Vector3.new(0, -16, 0))
					end
					if LimbReanimator.Mode == 3 then
						rootcf = RCRootPart.CFrame
					end
					if LimbReanimator.Mode == 4 then
						rootcf = RCTorso.CFrame
					end
					if LimbReanimator.Velocity == 1 then
						rootvel = RCRootPart.Velocity
					elseif LimbReanimator.Velocity == 2 then
						rootvel = Vector3.new(0, 16384, 0)
					end
				end
				local flingtarget = LimbReanimator.FlingTargets[1]
				if flingtarget then
					if flingtarget.Time then
						if t > flingtarget.Time then
							table.remove(LimbReanimator.FlingTargets, 1)
							flingtarget = nil
						end
					else
						flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and (LimbReanimator.UseNaNFling and 1 or 0.5) or 2))
					end
				end
				local flingcf, flinged = CFrame.identity, true
				if flingtarget then
					flingcf, flinged = Util.PredictionFling(flingtarget.Target)
					if flinged then
						table.remove(LimbReanimator.FlingTargets, 1)
						flingtarget = nil
					end
				end
				UpdateTransforms(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf)
				if LimbReanimator.UseNaNFling then
					if os.clock() - lastspawn > 0.1 then
						pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.new(0/0, 0/0, 0/0))
					else
						pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.zero)
					end
					pcall(sethiddenproperty, Humanoid, "NetworkHumanoidState", Enum.HumanoidStateType.Freefall.Value)
				else
					pcall(sethiddenproperty, Humanoid, "NetworkHumanoidState", Enum.HumanoidStateType.Flying.Value)
				end
			end
			RunService.PreRender:Wait()
			if Reanimate:ShouldRotationType() then
				Reanimate:CameraLockCharacter()
			end
			if Character and Humanoid and RootPart then
				UpdateTransforms(ReanimCharacter, RootPart, rootcf, rootvel, flingtarget, flingcf)
			end
		end
	end
	CharConn:Disconnect()
	if Player.Character then
		local h = Player.Character:FindFirstChild("Humanoid")
		if h then
			h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			h:ChangeState(Enum.HumanoidStateType.Dead)
		end
	end
	Reanimate.Stopping = false
	Reanimate.DestroyCharacter()
end

local HatReanimator = {}
HatReanimator.Name = "Hats"
SaveData.Reanimator.HatsCollide = not not SaveData.Reanimator.HatsCollide
SaveData.Reanimator.HatsCollideMethod = SaveData.Reanimator.HatsCollideMethod or 6
SaveData.Reanimator.IWantAllHats = not not SaveData.Reanimator.IWantAllHats
SaveData.Reanimator.IWantHatCollide = SaveData.Reanimator.IWantHatCollide or 3
SaveData.Reanimator.HatsPatchmahub = not not SaveData.Reanimator.HatsPatchmahub
SaveData.Reanimator.RespawnPosition = SaveData.Reanimator.RespawnPosition or 0
SaveData.Reanimator.HatsFling = not not SaveData.Reanimator.HatsFling
SaveData.Reanimator.HatsSpin = not not SaveData.Reanimator.HatsSpin
SaveData.Reanimator.HatsFlingMethod = SaveData.Reanimator.HatsFlingMethod or 1
SaveData.Reanimator.NoToolHolding = not not SaveData.Reanimator.NoToolHolding
SaveData.Reanimator.HatsToolAnim = SaveData.Reanimator.HatsToolAnim or 0
HatReanimator.HatCollide = SaveData.Reanimator.HatsCollide
HatReanimator.HatCollideMethod = SaveData.Reanimator.HatsCollideMethod
-- 0 - shownape's method
-- 1 - my method
-- 2 - 1 but for back accessories
-- 3 - 1 but for shoulder accessories
-- 4 - pray that it works for all ur accessories lol
-- 5 - least amount of chance to hat drop
-- 6 - experimental
-- 7 - idk honestly but this is just modified heavily for now
HatReanimator.IWantAllHats = SaveData.Reanimator.IWantAllHats
HatReanimator.IWantHatCollide = SaveData.Reanimator.IWantHatCollide
HatReanimator.Permadeath = false--not SaveData.Reanimator.HatsPatchmahub
HatReanimator.RespawnPosition = SaveData.Reanimator.RespawnPosition
-- 0 - hide body
-- 1 - behind character
-- 2 - randomtp close
-- 3 - stay at spawn
HatReanimator.HatFling = SaveData.Reanimator.HatsFling
HatReanimator.HatSpin = SaveData.Reanimator.HatsSpin
HatReanimator.FlingMethod = SaveData.Reanimator.HatsFlingMethod
-- -1 - disabled
-- 0 - respawn and fling
-- 1 - use biggest collidable hat
-- 2 - use all hats
-- 3 - tool fling
HatReanimator.ToolHolding = not SaveData.Reanimator.NoToolHolding
HatReanimator.ToolAnimMethod = SaveData.Reanimator.HatsToolAnim
-- 0 - nothing
-- 1 - sword
HatReanimator.UseNaNFling = true
HatReanimator.HasPermadeath = false
HatReanimator.HasHatCollide = false
HatReanimator.RebuildRequired = true
HatReanimator.HatMapSummary = "(no hat map yet, please * Reanimate * to build)"
HatReanimator.HatCFrameOverride = {}
HatReanimator.Status = {
	Permadeath = "(no status)",
	HatCollide = "(no status)",
	RespawnFling = "(no status)",
}
function HatReanimator.ShowHitboxes()
	if Player.Character then
		for _,v in Player.Character:GetChildren() do
			if v:IsA("Accessory") then
				local handle = v:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					if handle:GetAttribute("_Uhhhhhh_HasCollide") then
						Util.ShowPartHitbox(handle)
					end
				end
			end
		end
	end
end
HatReanimator.FlingTargets = {}
HatReanimator._TempNotFling = {}
function HatReanimator.Fling(target, duration)
	if HatReanimator.FlingMethod == -1 then return end
	if not target then return false end
	for _,v in HatReanimator.FlingTargets do
		if v.Target == target then
			return false
		end
	end
	if target == Reanimate.Character then return false end
	if target == Player.Character then return false end
	if typeof(target) == "Instance" then
		if HatReanimator._TempNotFling[target] then return end
		HatReanimator._TempNotFling[target] = true
		task.delay(1, function()
			HatReanimator._TempNotFling[target] = nil
		end)
	end
	table.insert(HatReanimator.FlingTargets, {
		Target = target,
		Duration = duration
	})
	if typeof(target) == "Instance" then
		if target:IsA("Model") then
			local h = Util.Instance("Highlight")
			h.Adornee = target
			h.FillColor = Color3.new(1, 0, 0)
			h.OutlineColor = Color3.new(1, 0, 0)
			h.FillTransparency = 0.5
			h.OutlineTransparency = 0
			h.Parent = target
			TweenService:Create(h, TweenInfo.new(5), {
				FillTransparency = 1,
				OutlineTransparency = 1
			}):Play()
			game.Debris:AddItem(h, 5)
		end
	end
	return true
end
HatReanimator.DontFireCharAddOnThisChar = nil
function HatReanimator.Config(parent)
	UI.CreateText(parent, "permadeath is patched, enable this switch if you want to", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Permadeath", HatReanimator.Permadeath).Changed:Connect(function(val)
		HatReanimator.Permadeath = val
		SaveData.Reanimator.HatsPatchmahub = not val
	end)
	UI.CreateDropdown(parent, "respawntp", {
		"The Void",
		"Behind ReanimCharacter",
		"Randomtp near",
		"At spawn",
	}, HatReanimator.RespawnPosition + 1).Changed:Connect(function(val)
		HatReanimator.RespawnPosition = val - 1
		SaveData.Reanimator.RespawnPosition = val - 1
	end)
	UI.CreateSwitch(parent, "Hat Collide", HatReanimator.HatCollide).Changed:Connect(function(val)
		HatReanimator.HatCollide = val
		SaveData.Reanimator.HatsCollide = val
	end)
	UI.CreateText(parent, "if ur hats get voided when u try to hat collide\nvvv try changing this vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateDropdown(parent, "Torso Offset", {
		"1 - ShownApe's method (???)",
		"2 - STEVE's method V1 (specific)",
		"3 - 2 but for back accessories",
		"4 - 2 but for shoulder accessories",
		"5 - 2 but for waist accessories",
		"6 - STEVE's method V2 (kinda stable)",
		"7 - 6 but further from void (gl getting hatdrop)",
		"8 - STEVE's method V3 (most stable)",
		"9 - experimental do not use",
	}, HatReanimator.HatCollideMethod + 1).Changed:Connect(function(val)
		HatReanimator.HatCollideMethod = val - 1
		SaveData.Reanimator.HatsCollideMethod = val - 1
	end)
	UI.CreateSwitch(parent, "Ensure All Hats", HatReanimator.IWantAllHats).Changed:Connect(function(val)
		HatReanimator.IWantAllHats = val
		SaveData.Reanimator.IWantAllHats = val
	end)
	UI.CreateDropdown(parent, "Ensure Hat Collide", {
		"Off",
		"Atleast one",
		"Atleast #hats - 2",
		"Atleast #hats - 1",
		"ALL",
	}, HatReanimator.IWantHatCollide + 1).Changed:Connect(function(val)
		HatReanimator.IWantHatCollide = val - 1
		SaveData.Reanimator.IWantHatCollide = val - 1
	end)
	UI.CreateText(parent, "vvv dont use these two options with target fling... vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Hat Fling", HatReanimator.HatFling).Changed:Connect(function(val)
		HatReanimator.HatFling = val
		SaveData.Reanimator.HatsFling = val
	end)
	UI.CreateText(parent, "^^^ ...unless you want to walkfling or... ^^^", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(parent, "Hat Spin Fling", HatReanimator.HatSpin).Changed:Connect(function(val)
		HatReanimator.HatSpin = val
		SaveData.Reanimator.HatsSpin = val
	end)
	UI.CreateText(parent, "^^^ ...unless you want to look glitchy ^^^", 10, Enum.TextXAlignment.Center)
	UI.CreateText(parent, "vvv dont use tool fling with physics glue btw vvv", 10, Enum.TextXAlignment.Center)
	UI.CreateDropdown(parent, "Target Fling Method", {
		"Disabled (RP)",
		"Classic Respawn",
		"Biggest Hat",
		"All Hats",
		"Use Tool Handle",
	}, HatReanimator.FlingMethod + 2).Changed:Connect(function(val)
		HatReanimator.FlingMethod = val - 2
		SaveData.Reanimator.HatsFlingMethod = val - 2
	end)
	UI.CreateSwitch(parent, "Tool Holding", HatReanimator.ToolHolding).Changed:Connect(function(val)
		HatReanimator.ToolHolding = val
		SaveData.Reanimator.NoToolHolding = val
	end)
	UI.CreateDropdown(parent, "toolanim Method", {
		"Disabled",
		"Sword",
	}, HatReanimator.ToolAnimMethod + 1).Changed:Connect(function(val)
		HatReanimator.ToolAnimMethod = val - 1
		SaveData.Reanimator.HatsToolAnim = val - 1
	end)
	UI.CreateSeparator(parent)
	local HatMapSummaryText = UI.CreateText(parent, HatReanimator.HatMapSummary, 12, Enum.TextXAlignment.Left)
	local HatReanimStatusText = UI.CreateText(parent, "", 12, Enum.TextXAlignment.Left)
	Util.LinkDestroyI2C(HatMapSummaryText, RunService.RenderStepped:Connect(function()
		HatMapSummaryText.Text = HatReanimator.HatMapSummary
		local str = ""
		for name, stat in HatReanimator.Status do
			str ..= name .. ": " .. stat .. "\n"
		end
		HatReanimStatusText.Text = str:sub(1, -2)
	end))
	UI.CreateButton(parent, "Rebuild Hat Map", 20).Activated:Connect(function()
		HatReanimator.RebuildRequired = true
	end)
	UI.CreateText(parent, "^^^ if ur rig built wrong or u switched to a new rig ^^^\nthis button is for you", 10, Enum.TextXAlignment.Center)
	UI.CreateButton(parent, "Respawn", 20).Activated:Connect(function()
		--HatReanimator.Status.Permadeath = "Fired CDSB Signal!"
	end)
end
HatReanimator.GetHatMap = function() end
HatReanimator.GetHatCFrameMeshAndTexture = function() end
HatReanimator.GetAttachmentCFrame = function() end
function HatReanimator.Start()
	local LimbNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	local Attachments = {
		RightShoulderAttachment = {"Right Arm", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightGripAttachment = {"Right Arm", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftFootAttachment = {"Left Leg", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftShoulderAttachment = {"Left Arm", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftGripAttachment = {"Left Arm", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RootAttachment = {"HumanoidRootPart", CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightFootAttachment = {"Right Leg", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		NeckAttachment = {"Torso", CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		BodyFrontAttachment = {"Torso", CFrame.new(0, 0, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		BodyBackAttachment = {"Torso", CFrame.new(0, 0, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		LeftCollarAttachment = {"Torso", CFrame.new(-1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		RightCollarAttachment = {"Torso", CFrame.new(1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistFrontAttachment = {"Torso", CFrame.new(0, -1, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistCenterAttachment = {"Torso", CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		WaistBackAttachment = {"Torso", CFrame.new(0, -1, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		HairAttachment = {"Head", CFrame.new(0, 0.6, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		HatAttachment = {"Head", CFrame.new(0, 0.6, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		FaceFrontAttachment = {"Head", CFrame.new(0, 0, -0.6, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
		FaceCenterAttachment = {"Head", CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	}

	local HatMeshDatabase, HatNameDatabase, HatKnownAccessoriesDatabase = loadstring(readfile("UhhhhhhReanim/BuiltinModules/d_hatsmap.lua"))()

	local function GetTools()
		local tools = {}
		local character, backpack = Player.Character, Player:FindFirstChildOfClass("Backpack")
		if character then
			for _,v in character:GetChildren() do
				if v:IsA("Tool") then
					table.insert(tools, v)
				end
			end
		end
		if backpack then
			for _,v in backpack:GetChildren() do
				if v:IsA("Tool") then
					table.insert(tools, v)
				end
			end
		end
		return tools
	end
	local function GetHatMeshAndTexture(hat)
		local handle = hat:FindFirstChild("Handle")
		if handle then
			local mesh, tex = nil, nil
			if handle:IsA("MeshPart") then
				return handle.MeshId, handle.TextureID
			elseif handle:IsA("BasePart") then
				local sm = handle:FindFirstChildOfClass("SpecialMesh")
				if sm then
					return sm.MeshId, sm.TextureId
				end
			end
		end
		return nil, nil
	end
	local function AssetIdMatch(a, b)
		a = a or ""
		b = b or ""
		if #b == 0 then return true end
		if #a == 0 then return false end
		if a:sub(1, 11) == "rbxasset://" then
			a = a:match("rbxasset://(.+)")
		elseif a:sub(1, 13) == "rbxassetid://" then
			a = a:match("rbxassetid://(%d+)")
		elseif a:sub(1, 4) == "http" then
			a = a:match("id=(%d+)")
		end
		return a == b
	end
	local function ClassifyHat(hat)
		local handle = hat:FindFirstChild("Handle")
		local mesh, tex = GetHatMeshAndTexture(hat)
		if handle and handle:IsA("BasePart") and mesh and tex then
			local mapdata = {
				Name = hat.Name,
				MeshId = mesh, TextureId = tex,
				C0 = CFrame.identity,
				C1 = CFrame.identity,
				Scale = 1,
				Limb = "HumanoidRootPart",
				Group = "RIG",
				Attachments = nil,
			}
			local originalsize = handle:FindFirstChild("OriginalSize")
			if originalsize and originalsize:IsA("Vector3Value") then
				originalsize = originalsize.Value
				local m1 = math.max(handle.Size.X, handle.Size.Y, handle.Size.Z)
				local m2 = math.max(originalsize.X, originalsize.Y, originalsize.Z)
				if m2 > 0 then
					mapdata.Scale = m1 / m2
				end
			else
				originalsize = handle.Size
			end
			-- dont map explicitly overriden hats
			for _,data in HatReanimator.HatCFrameOverride do
				if data.MeshId and data.TextureId then
					if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
						return mapdata, "Unknown", 4
					end
				end
			end
			for _,data in HatKnownAccessoriesDatabase do
				if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
					mapdata.C0 = data.C0
					mapdata.C1 = data.C1
					mapdata.Limb = data.Limb
					mapdata.Group = data.Group
					mapdata.Attachments = data.Attachments
					return mapdata, "Accessories", 0
				end
			end
			for _,data in HatNameDatabase do
				if hat.Name:lower() == data.Match:lower() then
					mapdata.C1 = data.Offset
					mapdata.Attachments = data.Attachments
					return mapdata, data.For, 1
				end
			end
			for _,data in HatMeshDatabase do
				if AssetIdMatch(mesh, data.MeshId) and AssetIdMatch(tex, data.TextureId) then
					mapdata.C1 = data.Offset
					mapdata.Attachments = data.Attachments
					return mapdata, data.For, 2
				end
			end
			local assumption = originalsize
			local m = math.min(assumption.X, assumption.Y, assumption.Z)
			if m >= 0.25 then
				assumption = Vector3.new(
					math.round(assumption.X / m),
					math.round(assumption.Y / m),
					math.round(assumption.Z / m)
				)
			else
				assumption = Vector3.zero
			end
			if assumption == Vector3.new(2, 2, 1) then
				mapdata.C1 = CFrame.identity
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(2, 1, 2) then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(1, 2, 2) then
				mapdata.C1 = CFrame.Angles(0, 1.57, 0)
				return mapdata, "Torso", 3
			elseif assumption == Vector3.new(1, 2, 1) then
				mapdata.C1 = CFrame.identity
				return mapdata, "ArmLeg", 3
			elseif assumption == Vector3.new(1, 1, 2) then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "ArmLeg", 3
			elseif assumption == Vector3.new(2, 1, 1) then
				mapdata.C1 = CFrame.Angles(0, 0, 1.57)
				return mapdata, "ArmLeg", 3
			elseif handle:FindFirstChild("HatAttachment") and assumption == Vector3.new(1, 1, 1) and m < 1.2 then
				mapdata.C1 = CFrame.Angles(1.57, 0, 0)
				return mapdata, "Block", 3
			end
			return mapdata, "Unknown", 4
		end
		return nil
	end

	local BaseParts = {}
	local CharTools = {}
	local CharHats = {}

	local HatRefs = {}
	local Hat2HatRefs = {}
	local function ResetHatRefs()
		table.clear(Hat2HatRefs)
		for _,ref in HatRefs do
			ref.Hat = nil
			ref.Han = nil
		end
	end
	local function CreatePlaceholder(hat)
		local h = hat:FindFirstChild("Handle")
		if h and h:IsA("BasePart") then
			local p = h:Clone()
			p:BreakJoints()
			p.Anchored = true
			p.CanCollide = false
			p.CanTouch = false
			p.CanQuery = false
			p.Transparency = 0.75
			p.Name = "(C) Uhhhhhh V" .. UhhhhhhVersion .. " :: HAT PLACEHOLDER"
			for _,v in p:GetDescendants() do
				if v:IsA("LuaSourceContainer") then
					v:Destroy()
					continue
				end
				local exist = pcall(function()
					return v.LocalTransparencyModifier
				end)
				if exist then
					p:GetPropertyChangedSignal("Transparency"):Connect(function()
						v.LocalTransparencyModifier = p.Transparency
					end)
				end
			end
			if h:GetAttribute("AttachHead") then
				p:SetAttribute("AttachHead", true)
			end
			p.Parent = workspace
			return p
		end
	end
	local function RefHatToHatRefs(hat)
		local handle = hat:FindFirstChild("Handle")
		local mesh, tex = GetHatMeshAndTexture(hat)
		if handle and mesh and tex then
			for _,ref in HatRefs do
				if not ref.Hat then
					if ref.Name == hat.Name and ref.MeshId == mesh and ref.TextureId == tex then
						ref.Hat = hat
						ref.Han = handle
						if ref.Map.Limb == "Head" then
							handle:SetAttribute("AttachHead", true)
						end
						Hat2HatRefs[hat] = ref
						if not ref.PH then
							ref.PH = CreatePlaceholder(hat)
						end
						return
					end
				end
			end
			HatReanimator.RebuildRequired = true
		end
	end

	local HatMap = {}
	local HatMapCopy = {}
	local function RefreshHatMap(Character)
		local summary = ""
		summary ..= "[Hat Map Summary]\n"
		summary ..= "Total hats found: " .. #CharHats .. "\n"
		local hatfors = {
			Head = {},
			Torso = {},
			LeftArm = {},
			RightArm = {},
			LeftLeg = {},
			RightLeg = {},
			ArmLeg = {},
			Block = {},
			Accessories = {},
			Unknown = {},
		}
		for _,hat in CharHats do
			local mapdata, usefor, level = ClassifyHat(hat)
			if mapdata and hatfors[usefor] then
				table.insert(hatfors[usefor], {hat, mapdata, level})
			end
		end
		summary ..= "Classified "
		for name,arr in hatfors do
			table.sort(arr, function(a, b)
				return a[3] < b[3]
			end)
			summary ..= #arr .. " " .. name .. ", "
		end
		summary = summary:sub(1, -3) .. ".\n"
		summary ..= "Rig Building:\n"
		local hatrig = {
			Head = nil,
			Torso = nil,
			LeftArm = nil,
			RightArm = nil,
			LeftLeg = nil,
			RightLeg = nil,
		}
		if #hatfors.Head > 0 then
			summary ..= "  1 Head as Head (perfect match)\n"
			hatrig.Head = table.remove(hatfors.Head, 1)
		end
		if #hatfors.Torso > 0 then
			summary ..= "  1 Torso as Torso (perfect match)\n"
			hatrig.Torso = table.remove(hatfors.Torso, 1)
		end
		if #hatfors.LeftArm > 0 then
			summary ..= "  1 LeftArm as LeftArm (perfect match)\n"
			hatrig.LeftArm = table.remove(hatfors.LeftArm, 1)
		end
		if #hatfors.RightArm > 0 then
			summary ..= "  1 RightArm as RightArm (perfect match)\n"
			hatrig.RightArm = table.remove(hatfors.RightArm, 1)
		end
		if #hatfors.LeftLeg > 0 then
			summary ..= "  1 LeftLeg as LeftLeg (perfect match)\n"
			hatrig.LeftLeg = table.remove(hatfors.LeftLeg, 1)
		end
		if #hatfors.RightLeg > 0 then
			summary ..= "  1 RightLeg as RightLeg (perfect match)\n"
			hatrig.RightLeg = table.remove(hatfors.RightLeg, 1)
		end
		local limbstobuild = {}
		if not hatrig.LeftArm then
			if #hatfors.RightArm > 0 then
				hatrig.LeftArm = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 RightArm as LeftArm (hat reused)\n"
			elseif #hatfors.LeftLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as LeftArm (hat reused)\n"
			elseif #hatfors.RightLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as LeftArm (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.LeftArm = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as LeftArm (purpose match)\n"
			else
				table.insert(limbstobuild, "Left Arm")
			end
		end
		if not hatrig.RightArm then
			if #hatfors.LeftArm > 0 then
				hatrig.RightArm = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as RightArm (hat reused)\n"
			elseif #hatfors.RightLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as RightArm (hat reused)\n"
			elseif #hatfors.LeftLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as RightArm (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.RightArm = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as RightArm (purpose match)\n"
			else
				table.insert(limbstobuild, "Right Arm")
			end
		end
		if not hatrig.LeftLeg then
			if #hatfors.RightLeg > 0 then
				hatrig.LeftLeg = table.remove(hatfors.RightLeg, 1)
				summary ..= "  1 RightLeg as LeftLeg (hat reused)\n"
			elseif #hatfors.LeftArm > 0 then
				hatrig.LeftLeg = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as LeftLeg (hat reused)\n"
			elseif #hatfors.RightArm > 0 then
				hatrig.LeftLeg = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 LeftLeg as LeftLeg (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.LeftLeg = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as LeftLeg (purpose match)\n"
			else
				table.insert(limbstobuild, "Left Leg")
			end
		end
		if not hatrig.RightLeg then
			if #hatfors.LeftLeg > 0 then
				hatrig.RightLeg = table.remove(hatfors.LeftLeg, 1)
				summary ..= "  1 LeftLeg as RightLeg (hat reused)\n"
			elseif #hatfors.RightArm > 0 then
				hatrig.RightLeg = table.remove(hatfors.RightArm, 1)
				summary ..= "  1 RightArm as RightLeg (hat reused)\n"
			elseif #hatfors.LeftArm > 0 then
				hatrig.RightLeg = table.remove(hatfors.LeftArm, 1)
				summary ..= "  1 LeftArm as RightLeg (hat reused)\n"
			elseif #hatfors.ArmLeg > 0 then
				hatrig.RightLeg = table.remove(hatfors.ArmLeg, 1)
				summary ..= "  1 ArmLeg as RightLeg (purpose match)\n"
			else
				table.insert(limbstobuild, "Right Leg")
			end
		end
		for _,v in HatRefs do if v.PH then v.PH:Destroy() end end
		table.clear(Hat2HatRefs)
		table.clear(HatRefs)
		table.clear(HatMap)
		local function addhat(limb, data)
			if data and data[2] then
				data = data[2]
				if limb then
					data.Limb = limb
				end
				local index = #HatMap
				data.Index = index
				table.insert(HatMap, data)
				table.insert(HatRefs, {
					Name = data.Name,
					MeshId = data.MeshId, TextureId = data.TextureId,
					Map = data,
					Index = index,
					PH = nil,
					Hat = nil,
				})
			end
		end
		addhat("Head", hatrig.Head)
		addhat("Torso", hatrig.Torso)
		addhat("Left Arm", hatrig.LeftArm)
		addhat("Right Arm", hatrig.RightArm)
		addhat("Left Leg", hatrig.LeftLeg)
		addhat("Right Leg", hatrig.RightLeg)
		if #limbstobuild > 0 and #hatfors.Block > 0 then
			local blocks = {}
			local i = 0
			while i < #limbstobuild * 2 and #hatfors.Block > 0 do
				local name = limbstobuild[(i % #limbstobuild) + 1]
				if not blocks[name] then
					blocks[name] = {}
				end
				table.insert(blocks[name], table.remove(hatfors.Block, 1))
				i += 1
			end
			for name,v in blocks do
				if #v == 2 then
					local a, b = v[1], v[2]
					a[2].C0 = CFrame.new(0, -0.5, 0)
					b[2].C0 = CFrame.new(0, 0.5, 0)
					addhat(name, a)
					addhat(name, b)
					summary ..= "  2 Block as " .. name:gsub(" ", "") .. " (block build)\n"
				elseif #v == 1 then
					addhat(name, v[1])
					summary ..= "  1 Block as " .. name:gsub(" ", "") .. " (block build)\n"
				end
			end
		end
		summary ..= "  " .. #hatfors.Accessories .. " known accessories\n"
		for _,acc in hatfors.Accessories do
			addhat(nil, acc)
		end
		table.clear(hatfors.Accessories)
		local unused = 0
		local function AttmentGet(name)
			for _,data in ipairs(HatMap) do
				if data.Attachments and data.Attachments[name] then
					return {data.Limb, data.C0 * data.C1:Inverse() * data.Attachments[name]}
				end
			end
			return Attachments[name]
		end
		for _,v in hatfors do
			for _,w in v do
				local hat = w[1]
				local map = w[2]
				local limb, c0 = unpack(AttmentGet("HatAttachment"))
				local c1 = hat.AttachmentPoint
				local handle = hat:FindFirstChild("Handle")
				if handle then
					for _,x in handle:GetChildren() do
						if x:IsA("Attachment") then
							local att = AttmentGet(x.Name)
							if att then
								limb, c0, c1 = att[1], att[2], x.CFrame
								break
							end
						end
					end
				end
				map.C0 = c0
				map.C1 = c1
				map.Limb = limb
				addhat(limb, w)
				unused += 1
			end
		end
		summary ..= "...which leaves " .. unused .. " unused."
		HatMap.Built = os.clock()
		HatMapCopy = Util.DeepcopyTable(HatMap)
		for _,v in CharHats do
			RefHatToHatRefs(v)
		end
		HatReanimator.HatMapSummary = summary
		HatReanimator.RebuildRequired = false
	end
	local function GetHatMappedOverride(hatmapped)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		local hatscale = hatmapped.Scale
		-- cframe override
		for _,data in HatReanimator.HatCFrameOverride do
			if not data.Disable then
				-- accessory group
				if data.Group and hatmapped.Group == data.Group then
					if data.Limb then
						return {
							C0 = data.C0 or data.Offset or CFrame.identity,
							C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
							Limb = data.Limb, RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					else
						return {
							C0 = data.C0 or data.CFrame or CFrame.identity,
							C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
							RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					end
				end
				-- exact asset id
				if data.MeshId or data.TextureId or data.Name then
					local oke = true
					if data.MeshId then
						oke = oke and AssetIdMatch(hatmapped.MeshId, data.MeshId)
					end
					if data.TextureId then
						oke = oke and AssetIdMatch(hatmapped.TextureId, data.TextureId)
					end
					if data.Name then
						oke = oke and hatmapped.Name == data.Name
					end
					if oke then
						return {
							C0 = data.C0, C1 = data.C1,
							Offset = data.Offset or data.CFrame,
							Limb = data.Limb, RepRootPart = data.RepRootPart,
							Scale = hatscale,
						}
					end
				end
				if data.Index and hatmapped.Index == data.Index then
					return {
						C0 = data.C0 or data.CFrame or CFrame.identity,
						C1 = hatmapped.C1 * (data.C1 or CFrame.identity),
						RepRootPart = data.RepRootPart,
						Scale = hatscale,
					}
				end
			end
		end
		return hatmapped
	end
	local function GetHatMappedMeshAndTexture(mesh, tex, name)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local hatmapped = nil
		-- find hat mapping
		for _,data in ipairs(HatMap) do
			if (name and data.Name == name or not name) and data.MeshId == mesh and data.TextureId == tex then
				hatmapped = data
				break
			end
		end
		if not hatmapped then return end
		return GetHatMappedOverride(hatmapped)
	end
	local function GetHatMappedCFrame(hatmapped)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		if hatmapped then
			local hatscale = hatmapped.Scale
			-- limb attached
			if hatmapped.Limb then
				local limb = ReanimCharacter:FindFirstChild(hatmapped.Limb)
				if limb and limb:IsA("BasePart") then
					-- weld-like
					if hatmapped.C0 and hatmapped.C1 then
						return limb.CFrame * Util.ScaleCFrame(hatmapped.C0, scale) * Util.ScaleCFrame(hatmapped.C1, hatscale):Inverse(), limb.Velocity
					end
					-- legacy
					if hatmapped.Offset then
						return limb.CFrame * hatmapped.Offset, limb.Velocity
					end
				end
			else
				-- world coords
				if hatmapped.C0 and hatmapped.C1 then
					return hatmapped.C0 * Util.ScaleCFrame(hatmapped.C1, hatscale):Inverse(), Vector3.zero
				end
			end
		end
		return
	end
	local function GetHatCFrameMeshAndTexture(mesh, tex, name)
		return GetHatMappedCFrame(GetHatMappedMeshAndTexture(mesh, tex, name))
	end
	local function GetHatMapped(hat)
		local handle = hat:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		local mesh, tex = GetHatMeshAndTexture(hat)
		return GetHatMappedMeshAndTexture(mesh, tex, hat.Name)
	end
	local function GetHatCFrame(hat)
		local handle = hat:FindFirstChild("Handle")
		if not handle or not handle:IsA("BasePart") then return end
		local mesh, tex = GetHatMeshAndTexture(hat)
		return GetHatCFrameMeshAndTexture(mesh, tex, hat.Name)
	end
	local function GetAttachmentCFrame(name)
		local ReanimCharacter = Reanimate.Character
		if not ReanimCharacter then return end
		local scale = ReanimCharacter:GetScale()
		local hatmapped = nil
		-- find hat mapping
		for _,data in ipairs(HatMap) do
			if data.Attachments and data.Attachments[name] then
				hatmapped = data
				break
			end
		end
		if hatmapped then
			local cf = GetHatCFrameMeshAndTexture(hatmapped.MeshId, hatmapped.TextureId)
			local att = hatmapped.Attachments[name]
			return cf * Util.ScaleCFrame(att, hatmapped.Scale)
		end
		if Attachments[name] then
			local limb = ReanimCharacter:FindFirstChild(Attachments[name][1])
			if limb then
				return limb.CFrame * Util.ScaleCFrame(Attachments[name][2], scale)
			end
		end
		return
	end
	HatReanimator.GetHatMap = function() return HatMapCopy end
	HatReanimator.GetHatCFrameMeshAndTexture = GetHatCFrameMeshAndTexture
	HatReanimator.GetAttachmentCFrame = GetAttachmentCFrame

	local InitCFrame = nil
	local CurrentCharacter = nil

	HatReanimator.RebuildRequired = true
	HatReanimator.HatMapSummary = "(no hat map yet...)"
	table.clear(HatReanimator.FlingTargets)
	
	local lastsimradchange = 0
	local function SetSimulationRadius()
		local function setsimrad(plr, radius)
			pcall(function()
				plr.SimulationRadius = radius
			end)
			pcall(sethiddenproperty, plr, "SimulationRadius", radius)
		end
		--[[settings().Physics.AllowSleep = false
		settings().Physics.ThrottleAdjustTime = 0/0
		for _,plr in Players:GetPlayers() do
			local a, b = pcall(compareinstances, plr, Player)
			if a and not b then
				setsimrad(plr, 0)
			end
		end]]
		local r = #Players:GetPlayers() * 1000
		setsimrad(Player, r)
		--if os.clock() > lastsimradchange then
			--lastsimradchange = os.clock() + 1
			--pcall(replicatesignal, Player.SimulationRadiusChanged, r)
		--end
		--[[pcall(setsimulationradius, r, r)
		pcall(function()
			-- faster than findfirstchild + if then end
			sethiddenproperty(Player.Character.Humanoid, "InternalBodyScale", Vector3.new(9e9, 9e9, 9e9))
			sethiddenproperty(Player.Character.Humanoid, "InternalHeadScale", 9e9)
		end)]]
	end
	local function IsNetworkOwner(part)
		return part.ReceiveAge == 0
	end
	
	local BackendAccoutrementState = {
		None = 0,
		HasHandle = 1,
		InWorkspace = 2,
		InCharacter = 3,
		Equipped = 4,
	}
	local function SetAccoutrementState(hat, state)
		sethiddenproperty(hat, "BackendAccoutrementState", state)
	end

	local IsRespawning = false
	local function Respawn()
		if IsRespawning then return end
		IsRespawning = true
	end

	-- Credits to MyWorld for helping with netless
	local function SetUACFrameNetless(handle, dt, newcf, tvel, fling, spin)
		if dt <= 0 then return false end
		if not (handle:IsA("BasePart") and handle:IsDescendantOf(workspace)) then return false end
		local timing = os.clock()
		local idlerv = Vector3.new(
			math.sin(timing * 14), math.sin(timing * 15 + 1.0472), math.sin(timing * 16 + 2.0944)
		)
		local idleoff = idlerv * 0.001
		local ylimit = FallenPartsDestroyHeight + 5
		if newcf.Y < ylimit then
			newcf += Vector3.new(0, ylimit - newcf.Y, 0)
		end
		local speedlimit = 16384
		if fling then
			speedlimit = math.huge
		end
		local netless = Reanimate.NetlessVelocity + (math.sin(timing * 0.5) + 1) / 2
		local aligned = true
		local lastcf = handle:GetAttribute("_Uhhhhhh_LastPosition")
		local claimtime = handle:GetAttribute("_Uhhhhhh_ClaimTime")
		if typeof(lastcf) ~= "CFrame" then lastcf = handle.CFrame end
		if not handle:IsGrounded() and IsNetworkOwner(handle) then
			local newpos = newcf.Position
			local lastpos = lastcf.Position
			local vel = (newpos - lastpos) / dt
			if vel.Magnitude < 0.12 then
				newcf += idleoff
			elseif vel.Magnitude > speedlimit then
				vel = vel.Unit * speedlimit
				newpos = lastpos + vel * dt
				newcf = newcf.Rotation + newpos
				aligned = false
			end
			local rvel = lastcf:ToObjectSpace(newcf)
			local a, b = rvel:ToAxisAngle()
			rvel = (a * b) / dt
			lastcf = newcf
			if claimtime then
				if timing - claimtime < 5.67 then
					handle.Massless = false
					handle.CustomPhysicalProperties = nil
				else
					handle.Massless = true
					handle.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
				end
				if timing - claimtime < 0.51 then
					handle.AssemblyLinearVelocity = Vector3.new(0, netless, 0)
				else
					if fling then
						handle.AssemblyLinearVelocity = Vector3.new(16384, 16384, 16384)
					else
						-- so Patchma's netless doesn't need the velocity of the hat, just where its attached to.
						if Reanimate.UsePatchmaLikeNetless then
							vel = tvel
							vel *= Vector3.new(1, 0, 1)
							if vel.Magnitude > netless then
								vel = vel.Unit * netless
							end
							handle.AssemblyLinearVelocity = Vector3.new(vel.X * 10, netless, vel.Z * 10)
						else
							vel += tvel
							vel *= Vector3.new(1, 0, 1)
							if vel.Magnitude > netless then
								vel = vel.Unit * netless
							end
							handle.AssemblyLinearVelocity = Vector3.new(vel.X, math.max(vel.Y, netless), vel.Z)
						end
					end
				end
			else
				claimtime = timing
				handle.AssemblyLinearVelocity = Vector3.new(0, netless * 2, 0)
			end
			handle.CFrame = newcf
			if spin then
				handle.AssemblyAngularVelocity = Vector3.new(16384, 16384, 16384)
			else
				if Reanimate.UseAngularVelocity then
					handle.AssemblyAngularVelocity = rvel + idleoff
				else
					handle.AssemblyAngularVelocity = idleoff
				end
			end
		else
			claimtime = nil
			lastcf = handle.CFrame
			aligned = false
		end
		handle:SetAttribute("_Uhhhhhh_LastPosition", lastcf)
		handle:SetAttribute("_Uhhhhhh_ClaimTime", claimtime)
		return aligned
	end

	local CharOnDesc = function(v)
		if v:IsA("BasePart") and not (v:FindFirstAncestorWhichIsA("Tool") or v:FindFirstAncestorWhichIsA("Accessory")) then
			if not table.find(BaseParts, v) then
				table.insert(BaseParts, v)
			end
		elseif v:IsA("Animator") then
			task.defer(function()
				v:Destroy()
			end)
		elseif v:IsA("LocalScript") and v.Parent == Player.Character then
			v.Enabled = false
			v:GetPropertyChangedSignal("Enabled"):Connect(function()
				if v.Enabled then v.Enabled = false end
			end)
			v:GetPropertyChangedSignal("Disabled"):Connect(function()
				if not v.Disabled then v.Disabled = true end
			end)
		elseif v:IsA("Accessory") and v.Parent == Player.Character then
			local handle = v:WaitForChild("Handle", 10)
			if handle then
				if not table.find(CharHats, v) then
					table.insert(CharHats, v)
					local conn = nil
					conn = v.AncestryChanged:Connect(function()
						if v.Parent ~= Player.Character then
							local i = table.find(CharHats, v)
							if i then table.remove(CharHats, i) end
						end
					end)
				end
			end
		elseif v:IsA("Tool") and v.Parent == Player.Character then
			if not table.find(CharTools, v) then
				table.insert(CharTools, v)
				local conn = nil
				conn = v.AncestryChanged:Connect(function()
					if v.Parent ~= Player.Character then
						local i = table.find(CharTools, v)
						if i then table.remove(CharTools, i) end
					end
				end)
			end
		end
	end
	local currentping = 0
	local function _counthats(hats)
		local collidable = 0
		local exists = 0
		for _,hat in hats do
			local handle = hat:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				exists += 1
				if handle.CanCollide then
					collidable += 1
					handle:SetAttribute("_Uhhhhhh_HasCollide", true)
				end
				handle.CanCollide = false
			end
		end
		HatReanimator.Status.HatCollide = exists .. " hats, " .. collidable .. " has collide."
		return collidable
	end
	local function calculatepartdestroytime(height, velocity, gravity)
		return (velocity + math.sqrt(velocity * velocity + 2 * gravity * height)) / gravity
	end
	local HatCollideMethods = {}
	HatCollideMethods[-2] = {
		NoAnim = true,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, 141, 0))
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "RCDless Mode, applying reweld to head method"
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.None)
				local att = v:FindFirstChildOfClass("Attachment")
				if att then
					att:Destroy()
				end
			end
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then torso:Destroy() end
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then root:Destroy() end
			for _,v in character:GetChildren() do
				if v:IsA("BasePart") and v.Name ~= "Head" then
					v:Destroy()
				end
			end
			local head = character:FindFirstChild("Head")
			if head then head:Destroy() end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[-1] = {
		NoAnim = true,
		Wait1 = 0.25,
		Wait2 = 0,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			RootPart.CFrame = CFrame.new(RootPosition) * CFrame.Angles(math.pi / 2, 0, 0)
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
		end,
		State1 = function() end,
		State2 = function() return 0 end,
	}
	local shownapehatdrop_lock = {}
	HatCollideMethods[0] = {
		NoAnim = false,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, -0.25, 0)) * CFrame.Angles(math.rad(20), 0, 0)
			else
				RootPart.CFrame = CFrame.new(RootPosition + Vector3.new(0, -0.25, 0))
			end
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 25, 0), Vector3.zero
		end,
		State1 = function(character, Humanoid, hats)
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://180436148"
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				anim.AnimationId = "rbxassetid://507767968"
			end
			local track = Humanoid:LoadAnimation(anim)
			track.Priority = 5
			track:Play(0)
			track:AdjustSpeed(1)
			track:AdjustWeight(1)
			track.TimePosition = 0.1
			table.clear(shownapehatdrop_lock)
			for _,v in hats do
				table.insert(shownapehatdrop_lock, v.Changed:Connect(function(p)
					if p == "BackendAccoutrementState" then
						SetAccoutrementState(v, BackendAccoutrementState.None)
					end
				end))
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
			HatReanimator.Status.HatCollide = #hats .. " hats states ERADICATED!"
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then
				torso.AncestryChanged:Wait()
			end
			HatReanimator.Status.HatCollide = "Torso removed, state unlocked."
			for _,v in shownapehatdrop_lock do
				v:Disconnect()
			end
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			torso = character:FindFirstChild("Head")
			if torso then
				torso.AncestryChanged:Wait()
			end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	local function hatcol_hrptpstab(torsooffset)
		return function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(8, -8, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0)
			if readystate > 0 then
				RootPart.CFrame = rootcf
				RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			else
				RootPart.CFrame = rootcf + Vector3.new(0, 141, 0) -- CFrame.new(RootPosition + Vector3.new(8, 141, 0))
				RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			end
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "Root" then
							Util.SetMotor6DOffset(v, rootcf:ToObjectSpace(CFrame.new(RootPosition + Vector3.new(0, 0.75, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0) * torsooffset))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(math.random() * 0.05, 1.5, -10))
						elseif v.Name:FindFirstChild("Shoulder") or v.Name:FindFirstChild("Hip") then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(v.C0.X - v.C1.X, v.C0.Y - v.C1.Y, -0.5 + math.random() * 0.05))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			else
				local i = 1
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, rootcf:ToObjectSpace(CFrame.new(RootPosition + Vector3.new(0, -0.25, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0) * torsooffset))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(math.random() * 0.05, 1.5, -20))
						else
							Util.SetMotor6DOffset(v, torsooffset.Rotation:Inverse() * CFrame.new(i * -3, math.random() * 0.05, -3))
							i += 1
						end
					end
				end
			end
		end
	end
	HatCollideMethods[1] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0)),
		State1 = function(character, Humanoid, hats)
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
				SetAccoutrementState(v, BackendAccoutrementState.None)
			end
			HatReanimator.Status.HatCollide = #hats .. " hats states ERADICATED!"
		end,
		State2 = function(character, hats)
			local torso = character:FindFirstChild("Torso")
			if torso then
				torso.AncestryChanged:Wait()
			end
			HatReanimator.Status.HatCollide = "Torso removed, state unlocked."
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			torso = character:FindFirstChild("Head")
			if torso then
				torso.AncestryChanged:Wait()
			end
			task.wait(0.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[2] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[3] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi * -0.5, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[4] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, 0) * CFrame.Angles(math.pi * 0.5, 0, 0)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[5] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, -8)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[6] = {
		NoAnim = true,
		HRPTP = hatcol_hrptpstab(CFrame.new(0, 0, -60)),
		State1 = HatCollideMethods[1].State1,
		State2 = HatCollideMethods[1].State2,
	}
	HatCollideMethods[7] = {
		ColLimb = true,
		NoAnim = true,
		Wait1 = 0.1,
		Wait2 = 0.15,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(0, -4, 0))
			RootPart.CFrame = rootcf
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 26, 0), Vector3.zero
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				-- TODO
			else
				-- put the limbs in freefall, make sure they dont touch
				local headheight = 3
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 6, 0))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, headheight, -2))
						elseif v.Name == "Right Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, headheight + 0.5, -2))
						elseif v.Name == "Left Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, 0, -2))
						elseif v.Name:find("Hip") then
							Util.SetMotor6DOffset(v, CFrame.new((v.C0.X - v.C1.X) * 2, -2, -2))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			end
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "Hat states set."
			local head = character:FindFirstChild("Head")
			for _,v in hats do
				local handle = v:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChild("AccessoryWeld")
					if weld then
						if weld.Part0 == handle and weld.Part1 ~= head then
							continue
						end
						if weld.Part1 == handle and weld.Part0 ~= head then
							continue
						end
					end
				end
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
			end
		end,
		State2 = function(character, hats)
			local ping = Player:GetNetworkPing()
			-- 3 of the most important instances (rootpart is destroyed after a frame anyway)
			local torso = character:FindFirstChild("Torso")
			local head = character:FindFirstChild("Head")
			local rightarm = character:FindFirstChild("Right Arm") -- this will also reevaluate collisions upon removal (cuz tool)
			if torso then
				task.wait(calculatepartdestroytime(2, 26, workspace.Gravity) - 0.1)
			end
			HatReanimator.Status.HatCollide = "Torso removed, I speculate."
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
			end
			if torso and torso.Parent then
				torso.AncestryChanged:Wait()
			end
			if head and head.Parent then
				head.AncestryChanged:Wait()
			end
			task.wait(1.5)
			return _counthats(hats)
		end,
	}
	HatCollideMethods[8] = { -- VERY EXPERIMENTAL, do NOT use.
		NoAnim = true,
		Wait1 = 0.1,
		Wait2 = 0.15,
		HRPTP = function(dt, character, Humanoid, RootPosition, RootPart, readystate)
			local rootcf = CFrame.new(RootPosition + Vector3.new(0, -4, 0)) * CFrame.Angles(math.pi * 0.5, 0, 0)
			RootPart.CFrame = rootcf
			RootPart.AssemblyLinearVelocity, RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 30), Vector3.zero
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "Root" then
							Util.SetMotor6DTransform(v, CFrame.new(0, -30, 0))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 67, 0))
						else
							Util.SetMotor6DTransform(v, CFrame.identity)
						end
					end
				end
			else
				local i = 1
				for _,v in character:GetDescendants() do
					if v:IsA("Motor6D") then
						if v.Name == "RootJoint" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -20))
						elseif v.Name == "Neck" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -1))
						elseif v.Name == "Right Shoulder" then
							Util.SetMotor6DOffset(v, CFrame.new(0, 0, -20))
						else
							Util.SetMotor6DOffset(v, CFrame.new(i * -3, 0, 10))
							i += 1
						end
					end
				end
			end
		end,
		State1 = function(character, Humanoid, hats)
			HatReanimator.Status.HatCollide = "Hat states set."
			local head = character:FindFirstChild("Head")
			for _,v in hats do
				local handle = v:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChild("AccessoryWeld")
					if weld then
						if weld.Part1 ~= head then
							continue
						end
					end
				end
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
		end,
		State2 = function(character, hats)
			local hum = character:FindFirstChild("Humanoid")
			local head = character:FindFirstChild("Right Arm")
			HatReanimator.Status.HatCollide = "We shall remain 1 part."
			task.wait(0.41)
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.InWorkspace)
				SetAccoutrementState(v, BackendAccoutrementState.InCharacter)
			end
			task.wait(0.19)
			if head and head:IsDescendantOf(workspace) then
				head.AncestryChanged:Wait()
			end
			for _,v in hats do
				SetAccoutrementState(v, BackendAccoutrementState.Equipped)
			end
			task.wait(1.5)
			return _counthats(hats)
		end,
	}
	local NumHats = 0
	local function OnCharacter(character)
		if HatReanimator.DontFireCharAddOnThisChar == character then return end
		currentping = Player:GetNetworkPing()
		local toolnames = {}
		for _,v in CharTools do table.insert(toolnames, v.Name) end
		table.clear(BaseParts)
		table.clear(CharHats)
		table.clear(CharTools)
		ResetHatRefs()
		character.DescendantAdded:Connect(CharOnDesc)
		for _,v in character:GetDescendants() do
			CharOnDesc(v)
		end
		HatReanimator.Status.ReanimState = "Respawned."
		HatReanimator.Status.Permadeath = "Respawn detected."
		HatReanimator.Status.HatCollide = "Respawn detected."
		HatReanimator.Status.RespawnFling = "Respawn detected."
		local hatcols = HatReanimator.HatCollide
		local perma = HatReanimator.Permadeath
		HatReanimator.HasPermadeath, HatReanimator.HasHatCollide = perma, hatcols
		local hatcolmeth = HatReanimator.HatCollideMethod
		if not replicatesignal then perma = false end
		if not hatcols then hatcolmeth = -1 end
		if hatcols and RejectCharacterDeletionsDisabled then
			hatcolmeth = -2
		end
		local selhatcol = HatCollideMethods[hatcolmeth]
		CurrentCharacter = nil
		local Humanoid = character:WaitForChild("Humanoid", 10)
		if not Humanoid then return end
		if not Reanimate.UseLoadAnimationHook then
			local stupid = character:FindFirstChild("Animate")
			if stupid then
				stupid:Destroy()
			end
			character.ChildAdded:Connect(function(v)
				if v:IsA("LocalScript") then
					v.Disabled = true
					task.defer(function()
						v:Destroy()
					end)
				end
			end)
		end
		if selhatcol.NoAnim then
			local stupid = Humanoid:FindFirstChild("Animator")
			if stupid then
				stupid:Destroy()
			end
		end
		if selhatcol.ColLimb then
			Humanoid.EvaluateStateMachine = false
			Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		end
		local RootPart = character:WaitForChild("HumanoidRootPart", 10)
		if not RootPart then return end
		local RootPosition = Vector3.new(RootPart.Position.X, FallenPartsDestroyHeight, RootPart.Position.Z)
		local ReanimCharacter = Reanimate.Character
		if ReanimCharacter then
			local root = ReanimCharacter:FindFirstChild("HumanoidRootPart")
			if root then
				RootPosition = Vector3.new(root.Position.X, FallenPartsDestroyHeight, root.Position.Z)
			end
		end
		if not workspace.StreamingEnabled and false then
			local dir = CFrame.Angles(0, math.pi * 2 * math.random(), 0).LookVector * 300
			while true do
				local nearAPlayer = false
				for _,v in Players:GetPlayers() do
					if v.Character and v.Character.PrimaryPart then
						if (RootPosition - v.Character.PrimaryPart.CFrame.Position).Magnitude < 1000 then
							nearAPlayer = true
						end
					end
				end
				if nearAPlayer then
					RootPosition += dir
				else
					break
				end
			end
		end
		if not perma then
			RootPosition += Vector3.new(0, 12, 0)
			if ReanimCharacter then
				local root = ReanimCharacter:FindFirstChild("HumanoidRootPart")
				if root then
					if HatReanimator.RespawnPosition == 1 then
						RootPosition = root.CFrame * Vector3.new(0, 0, 6)
					end
					if HatReanimator.RespawnPosition == 2 then
						local dir = Vector3.new(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1).Unit
						if dir ~= dir or dir.Magnitude == 0 then
							dir = Vector3.yAxis
						end
						RootPosition = root.Position + dir * math.random(8, 12)
					end
				end
			end
			if HatReanimator.RespawnPosition == 3 then
				RootPosition = RootPart.Position
			end
		end
		if hatcols then
			RootPosition = Vector3.new(RootPosition.X, FallenPartsDestroyHeight, RootPosition.Z)
		end
		--pcall(function() Player.ReplicationFocus = character end)
		if hatcols then
			HatReanimator.Status.HatCollide = "Waiting for Permadeath."
		else
			HatReanimator.Status.HatCollide = "Disabled, nothing to do!"
		end
		local cdsbeffect = os.clock()
		local cdsbtime = os.clock()
		if perma then
			--replicatesignal(Player.ConnectDiedSignalBackend)
			HatReanimator.Status.Permadeath = "Fired CDSB Signal."
			cdsbeffect += Players.RespawnTime
		end
		HatReanimator.Status.RespawnFling = "Flinging targets..."
		if LimbReanimator.UseNaNFling and HatReanimator.FlingTargets[1] then
			task.wait(0.2)
		end
		while character:IsDescendantOf(workspace) do
			local t = os.clock()
			local flingtarget = HatReanimator.FlingTargets[1]
			if HatReanimator.FlingMethod == -1 then
				table.remove(HatReanimator.FlingTargets, 1)
				flingtarget = nil
			end
			if flingtarget then
				if flingtarget.Time then
					if t > flingtarget.Time then
						table.remove(HatReanimator.FlingTargets, 1)
						flingtarget = nil
					end
				else
					flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and 1 or 2))
				end
			end
			local flingcf, flinged = CFrame.identity, true
			if flingtarget then
				flingcf, flinged = Util.PredictionFling(flingtarget.Target)
				if flinged then
					table.remove(HatReanimator.FlingTargets, 1)
					flingtarget = nil
				end
			end
			if flingtarget then
				if not RootPart:IsGrounded() then
					if LimbReanimator.UseNaNFling then
						RootPart.CFrame = CFrame.new(flingcf.Position + Vector3.new(0, 0, math.random(0, 1) * 0.005)) * CFrame.Angles(0, os.clock() * 15, 0)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
					else
						RootPart.CFrame = flingcf + Vector3.new(0, 0, math.random(0, 1) * 0.005)
						RootPart.Velocity, RootPart.RotVelocity = Vector3.new(0, -16384, 0), Vector3.one * 16384
					end
					pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil)
				end
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
				if LimbReanimator.UseNaNFling then
					pcall(sethiddenproperty, Humanoid, "MoveDirectionInternal", Vector3.new(0/0, 0/0, 0/0))
				end
			elseif #HatReanimator.FlingTargets == 0 then
				break
			else
				RootPart.CFrame = CFrame.new(0, 1000, 0)
				RootPart.Velocity, RootPart.RotVelocity = Vector3.zero, Vector3.zero
				Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			end
			task.wait()
		end
		if not character:IsDescendantOf(workspace) then
			return
		end
		pcall(sethiddenproperty, RootPart, "PhysicsRepRootPart", nil)
		HatReanimator.Status.RespawnFling = "Done."
		local lgloop = nil
		local bringconns = {}
		local readystate = 0
		if perma then task.wait(1) end
		local backpack = Player:FindFirstChildOfClass("Backpack")
		local tools = GetTools()
		if backpack then
			for _=1, 3 do
				for _,tool in tools do
					tool.Parent = character
				end
				for _,tool in tools do
					tool.Parent = backpack
				end
			end
		end
		lgloop = RunService.Heartbeat:Connect(function(dt)
			selhatcol.HRPTP(dt, character, Humanoid, RootPosition, RootPart, readystate)
		end)
		if hatcols then task.wait(0.2) end
		HatReanimator.Status.ReanimState = "Loading Permadeath."
		if perma then
			HatReanimator.Status.Permadeath = "no."
		else
			HatReanimator.Status.Permadeath = "Disabled, nothing to do."
		end
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			return
		end
		readystate = 1
		HatReanimator.Status.ReanimState = "Reanimate State: 1"
		if not selhatcol.ColLimb then
			Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		end
		NumHats = #CharHats
		selhatcol.State1(character, Humanoid, CharHats)
		local claimarea = RootPart.CFrame.Position + RootPart.CFrame.LookVector * 8
		claimarea = Vector3.new(claimarea.X, math.max(FallenPartsDestroyHeight + 16, claimarea.Y + 4), claimarea.Z)
		task.wait(selhatcol.Wait1 or 0.1)
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			return
		end
		readystate = 2
		HatReanimator.Status.ReanimState = "Reanimate State: 2"
		for _,hat in CharHats do
			local handle = hat:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				table.insert(bringconns, RunService.Heartbeat:Connect(function(dt)
					if handle:IsDescendantOf(workspace) and IsNetworkOwner(handle) then
						handle.CFrame = CFrame.new(claimarea)
						handle.Velocity = Vector3.new(0, 67, 0)
						handle.RotVelocity = Vector3.new(0, 0, 0)
					end
				end))
				for _,v in handle:GetChildren() do
					if v:IsA("JointInstance") then v:Destroy() end
					if v:IsA("Constraint") then v.Enabled = false end
					if v:IsA("Attachment") then
						v.Archivable = true
						local w = v:Clone()
						v:Destroy()
						w.Parent = handle
					end
				end
				handle:SetAttribute("_Uhhhhhh_HasCollide", false)
			end
		end
		Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
		task.wait(selhatcol.Wait2 or 0.15)
		if not character:IsDescendantOf(workspace) then
			lgloop:Disconnect()
			for _,c in bringconns do
				c:Disconnect()
			end
			return
		end
		AvatarEditorService:BustAvatarFetchCache()
		pcall(replicatesignal, Humanoid.ServerBreakJoints)
		Humanoid.EvaluateStateMachine = true
		Humanoid.BreakJointsOnDeath = true
		Humanoid.Health = 0
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
		readystate = 3
		HatReanimator.Status.ReanimState = "Reanimate State: 3"
		IsRespawning = false
		if hatcols then
			local stateunlocked = false
			task.spawn(function()
				local collidable = selhatcol.State2(character, CharHats)
				stateunlocked = true
				local atleast = 0
				if SaveData.Reanimator.IWantHatCollide == 1 then
					atleast = 1
				end
				if SaveData.Reanimator.IWantHatCollide == 2 then
					atleast = #CharHats - 3
				end
				if SaveData.Reanimator.IWantHatCollide == 3 then
					atleast = #CharHats - 2
				end
				if SaveData.Reanimator.IWantHatCollide == 4 then
					atleast = #CharHats - 1
				end
				if hatcols and collidable <= atleast then
					if perma then
						HatReanimator.Status.Permadeath = "No hat collide. Respawning!"
						Respawn()
					end
				end
			end)
			repeat task.wait() until stateunlocked or not character:IsDescendantOf(workspace)
			--task.wait(0.25)
		end
		if backpack then
			for _,tool in tools do
				tool.Parent = Humanoid
				tool.Parent = character
				tool.Parent = backpack
			end
		end
		lgloop:Disconnect()
		if perma then task.wait(1) end
		for _,c in bringconns do
			c:Disconnect()
		end
		if not character:IsDescendantOf(workspace) then
			return
		end
		HatReanimator.Status.ReanimState = "Done."
		if #CharHats == 0 then
			if perma then
				HatReanimator.Status.Permadeath = "All hats died. Respawning!"
				Respawn()
			end
		end
		if perma and hatcols then
			if HatReanimator.IWantAllHats and NumHats > #CharHats then
				if perma then
					HatReanimator.Status.Permadeath = "Some hats died. Respawning!"
					Respawn()
				end
			else
				NumHats = #CharHats
			end
		end
		--pcall(function() Player.ReplicationFocus = nil end)
		CurrentCharacter = character
		task.wait()
		if backpack then
			for _,tool in tools do
				local i = table.find(toolnames, tool.Name)
				if i then
					table.remove(toolnames, i)
					tool.Parent = character
				end
			end
		end
	end

	local CharConn = Player.CharacterAdded:Connect(OnCharacter)

	if Player.Character then
		local h = Player.Character:FindFirstChildOfClass("Humanoid")
		if h and h.RootPart then
			InitCFrame = h.RootPart.CFrame
			pcall(function() Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
			pcall(function() Player.Character.Humanoid.Health = 0 end)
			pcall(replicatesignal, Player.Character.Humanoid.ServerBreakJoints)
			--pcall(replicatesignal, Player.ConnectDiedSignalBackend)
			Player.Character.DescendantAdded:Connect(CharOnDesc)
			for _,v in Player.Character:GetDescendants() do
				CharOnDesc(v)
			end
			CurrentCharacter = Player.Character
		end
	end

	Reanimate.CreateCharacter(InitCFrame)

	Reanimate.Starting = false
	local letitgo = 0
	while not Reanimate.Stopping do
		RunService.PreSimulation:Wait()
		workspace.FallenPartsDestroyHeight = 0/0
		SetSimulationRadius()
		debug.profilebegin("Uhhhhhh > CharacterCheck")
		local ReanimOkay = false
		local Character = Player.Character
		local ReanimCharacter = Reanimate.Character
		if Character and Character:IsDescendantOf(workspace) then
			if CurrentCharacter == Character then
				if #CharHats > 0 then
					ReanimOkay = true
				end
				if HatReanimator.HasPermadeath and not IsRespawning and HatReanimator.IWantAllHats then
					if NumHats > #CharHats then
						HatReanimator.Status.Permadeath = "Some hats died. Respawning!"
						Respawn()
					else
						local midpoint = Vector3.zero
						local hatsowned = 0
						local hatsnotowned = {}
						for _,v in CharHats do
							local h = v:FindFirstChild("Handle")
							if h and h:IsA("BasePart") then
								if IsNetworkOwner(h) then
									midpoint += h.Position
									hatsowned += 1
								else
									table.insert(hatsnotowned, h)
								end
							end
						end
						midpoint /= hatsowned
						for _,v in hatsnotowned do
							if (v.Position - midpoint).Magnitude > 2000 then
								HatReanimator.Status.Permadeath = "Some hats unclaimable. Respawning!"
								Respawn()
								break
							end
						end
						hatsnotowned = nil
					end
				end
			end
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			if Humanoid then
				if Humanoid.WalkSpeed < 1 then
					Humanoid.WalkSpeed = 16
				end
				if Humanoid.JumpPower < 1 then
					Humanoid.JumpPower = 50
				end
				if Camera then
					if (ReanimOkay and ReanimCharacter) or not HatReanimator.Permadeath then
						Camera.CameraSubject = ReanimCharacter:FindFirstChildOfClass("Humanoid")
					else
						Camera.CameraSubject = Humanoid
					end
				end
			end
		end
		debug.profileend()
		debug.profilebegin("Uhhhhhh > BaseParts")
		local RCRootPart = ReanimCharacter and ReanimCharacter:FindFirstChild("HumanoidRootPart")
		local ltm = Reanimate.LocalTransparencyModifier
		for _,v in BaseParts do
			v.CanCollide = false
			v.LocalTransparencyModifier = ltm
		end
		debug.profileend()
		debug.profilebegin("Uhhhhhh > ReanimOkay")
		local t = os.clock()
		local slocked = {}
		if ReanimOkay then
			local dt = RunService.Heartbeat:Wait()
			if HatReanimator.RebuildRequired then
				RefreshHatMap(Character)
			end
			if RCRootPart then
				local rightarm = ReanimCharacter:FindFirstChild("Right Arm") or RCRootPart
				local rightgrip = Util.ScaleCFrame(RIGHTGRIP_C0, Reanimate.CharacterScale)
				local claimoverride = nil
				local toolequipped = false
				local toolactivate = false
				local toolactivated = nil
				local handlethese = {}
				debug.profilebegin("Uhhhhhh > CharTools")
				for _,v in CharTools do
					local handle = v:FindFirstChild("Handle")
					if handle and handle:IsA("BasePart") then
						handle.CanCollide = false
						handle.LocalTransparencyModifier = ltm
						if HatReanimator.ToolHolding then
							handlethese[handle] = rightarm.CFrame * rightgrip * v.Grip:Inverse()
						else
							handlethese[handle] = RCRootPart.CFrame + Vector3.new(0, -12, 0)
						end
						if not IsNetworkOwner(handle) then
							local a = Player:GetNetworkPing() + 0.2 + math.sin(t * 30) * 0.2
							claimoverride = handle.CFrame
							claimoverride += handle.Velocity * a
							claimoverride += Vector3.new(0, -workspace.Gravity, 0) * 0.5 * a * a
						end
					end
					if not v:GetAttribute("_Uhhhhhh_ActivateConn") then
						v:SetAttribute("_Uhhhhhh_ActivateConn", true)
						v.Activated:Connect(function()
							v:SetAttribute("_Uhhhhhh_Activate", true)
						end)
					end
					if v:GetAttribute("_Uhhhhhh_Activate") then
						v:SetAttribute("_Uhhhhhh_Activate", nil)
						toolactivate = true
						toolactivated = v
					end
					v.Enabled = true
					v.RequiresHandle = false
					v.ManualActivationOnly = false
				end
				if #CharTools > 0 and HatReanimator.ToolHolding then
					local FakeTool = ReanimCharacter:FindFirstChildOfClass("Tool")
					if not FakeTool then
						toolequipped = true
						FakeTool = Instance.new("Tool")
						FakeTool.Name = "faketool"
						local FakeToolHandle = Instance.new("Part")
						FakeToolHandle.Name = "Handle"
						FakeToolHandle.Transparency = 1
						FakeToolHandle.Color = Color3.new(0, 0, 1)
						FakeToolHandle.CanCollide = false
						FakeToolHandle.Massless = true
						FakeToolHandle.Parent = FakeTool
						FakeTool.Parent = ReanimCharacter
						local RightGrip = Instance.new("Weld")
						RightGrip.Name = "RightGrip"
						RightGrip.Parent = FakeToolHandle
						RightGrip.Part0 = rightarm
						RightGrip.Part1 = FakeToolHandle
						RightGrip.C0 = RIGHTGRIP_C0
						Util.LinkDestroyI2C(FakeTool, FakeTool:GetPropertyChangedSignal("Grip"):Connect(function()
							RightGrip.C1 = FakeTool.Grip
						end))
						RightGrip.C1 = FakeTool.Grip
					end
					if HatReanimator.ToolAnimMethod == 1 then
						if toolequipped then
							local sound = Instance.new("Sound")
							sound.Name = "snd"
							sound.SoundId = "rbxasset://sounds/unsheath.wav"
							sound.Volume = 1
							sound.Parent = FakeTool:FindFirstChild("Handle")
							sound:Play()
							Debris:AddItem(sound, 1)
						end
						if toolactivate then
							local newuse = FakeTool:GetAttribute("_Uhhhhhh_Sword_CD") or 0
							local lastuse = FakeTool:GetAttribute("_Uhhhhhh_Sword_LU") or 0
							if t > newuse then
								if t - lastuse < 0.2 then
									newuse = t + 1
									local toolanim = Instance.new("StringValue")
									toolanim.Name = "toolanim"
									toolanim.Value = "Lunge"
									toolanim.Parent = FakeTool
									local sound = Instance.new("Sound")
									sound.Name = "snd"
									sound.SoundId = "rbxasset://sounds/swordlunge.wav"
									sound.Volume = 1
									sound.Parent = FakeTool:FindFirstChild("Handle")
									sound:Play()
									Debris:AddItem(toolanim, 1)
									Debris:AddItem(sound, 1)
									task.spawn(function(v)
										v.GripForward = Vector3.new(0, 0, 1)
										v.GripRight = Vector3.new(0, -1, 0)
										v.GripUp = Vector3.new(-1, 0, 0)
										task.wait(1)
										v.GripForward = Vector3.new(-1, 0, 0)
										v.GripRight = Vector3.new(0, 1, 0)
										v.GripUp = Vector3.new(0, 0, 1)
									end, toolactivated)
								else
									newuse = t + 0.05
									local toolanim = Instance.new("StringValue")
									toolanim.Name = "toolanim"
									toolanim.Value = "Slash"
									toolanim.Parent = FakeTool
									local sound = Instance.new("Sound")
									sound.Name = "snd"
									sound.SoundId = "rbxasset://sounds/swordslash.wav"
									sound.Volume = 1
									sound.Parent = FakeTool:FindFirstChild("Handle")
									sound:Play()
									Debris:AddItem(toolanim, 1)
									Debris:AddItem(sound, 1)
								end
								lastuse = t
							end
							FakeTool:SetAttribute("_Uhhhhhh_Sword_CD", newuse)
							FakeTool:SetAttribute("_Uhhhhhh_Sword_LU", lastuse)
						end
					end
				else
					local FakeTool = ReanimCharacter:FindFirstChildOfClass("Tool")
					if FakeTool then FakeTool:Destroy() end
				end
				debug.profileend()
				debug.profilebegin("Uhhhhhh > FlingLogic")
				local flingtarget = nil
				local flingcf, flinged = CFrame.identity, true
				if t > letitgo then
					flingtarget = HatReanimator.FlingTargets[1]
					if flingtarget then
						if - HatReanimator.FlingMethod == 0 then
							Respawn()
							flingtarget.Time = nil
							flingtarget = nil
						else
							if flingtarget.Time then
								if t > flingtarget.Time then
									table.remove(HatReanimator.FlingTargets, 1)
									flingtarget = nil
								end
							else
								flingtarget.Time = t + (flingtarget.Duration or (Reanimate.UsePhysicsRepRootPart and Reanimate.PhysicsRepRootPartFling or 2))
							end
						end
					end
					if flingtarget then
						flingcf, flinged = Util.PredictionFling(flingtarget.Target)
						if flinged then
							table.remove(HatReanimator.FlingTargets, 1)
							flingtarget = nil
							letitgo = t + 0.1
						end
					end
				end
				local blacklist = {}
				if flingtarget then
					local flingpart = Reanimate.UsePhysicsRepRootPart and Util.PredictionFlingPart(flingtarget.Target) or nil
					if HatReanimator.FlingMethod == 1 then
						local biggest = nil
						local biggesthat = nil
						local biggestarea = 0
						for _,hat in CharHats do
							local handle = hat:FindFirstChild("Handle")
							if handle and handle:IsA("BasePart") and handle:GetAttribute("_Uhhhhhh_HasCollide") and IsNetworkOwner(handle) then
								local area = handle.Size.X * handle.Size.Y * handle.Size.Z
								if biggestarea < area then
									biggest = handle
									biggesthat = hat
									biggestarea = area
								end
							end
						end
						if biggesthat then
							blacklist[biggesthat] = true
							SetUACFrameNetless(biggest, dt, flingcf, Vector3.zero, false, true)
							pcall(sethiddenproperty, biggest, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
						end
					end
					if HatReanimator.FlingMethod == 2 then
						local collide = false
						for _,hat in CharHats do
							local handle = hat:FindFirstChild("Handle")
							if handle and handle:IsA("BasePart") then
								if handle:GetAttribute("_Uhhhhhh_HasCollide") then
									collide = true
								end
							end
						end
						if collide then
							for _,hat in CharHats do
								local handle = hat:FindFirstChild("Handle")
								if handle and handle:IsA("BasePart") then
									blacklist[hat] = true
									SetUACFrameNetless(handle, dt, flingcf, Vector3.zero, false, true)
									pcall(sethiddenproperty, handle, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
								end
							end
						end
					end
					if HatReanimator.FlingMethod == 3 then
						for handle, cf in handlethese do
							blacklist[handle] = true
							SetUACFrameNetless(handle, dt, flingcf, Vector3.zero, false, true)
							pcall(sethiddenproperty, handle, "PhysicsRepRootPart", Reanimate.UsePhysicsRepRootPart and flingpart or nil)
						end
					end
				end
				debug.profileend()
				debug.profilebegin("Uhhhhhh > Alignments")
				for _,hat in CharHats do
					local handle = hat:FindFirstChild("Handle")
					if handle and handle:IsA("BasePart") then
						handle.CanCollide = false
						local lltm = ltm
						if Reanimate.FirstPersonBody then
							if not handle:GetAttribute("AttachHead") then
								lltm = 0
							end
						end
						handle.LocalTransparencyModifier = lltm
						local ref = Hat2HatRefs[hat]
						if blacklist[hat] then
							if ref then ref.Aligned = false end
						else
							if claimoverride then
								SetUACFrameNetless(handle, dt, claimoverride, Vector3.zero, false, false)
								pcall(sethiddenproperty, handle, "PhysicsRepRootPart", nil)
								if ref then ref.Aligned = false end
							else
								local mapped = nil
								if ref then
									mapped = GetHatMappedOverride(ref.Map)
								else
									RefHatToHatRefs(hat)
								end
								local tcf, tvel = GetHatMappedCFrame(mapped)
								tcf = tcf or RCRootPart.CFrame * CFrame.new(0, 5, 0)
								tvel = tvel or Vector3.zero
								local aligned = SetUACFrameNetless(handle, dt, tcf, tvel, HatReanimator.HatFling, HatReanimator.HatSpin)
								if aligned then
									table.insert(slocked, handle)
								end
								if ref then ref.Aligned = aligned end
								pcall(sethiddenproperty, handle, "PhysicsRepRootPart", mapped and mapped.RepRootPart)
							end
						end
					end
				end
				for handle, cf in handlethese do
					if not blacklist[handle] then
						if SetUACFrameNetless(handle, dt, cf, rightarm.Velocity, HatReanimator.HatFling, HatReanimator.HatSpin) then
							table.insert(slocked, handle)
						end
					end
				end
				debug.profileend()
			end
		else
			if CurrentCharacter then
				CurrentCharacter = nil
				--replicatesignal(Player.ConnectDiedSignalBackend)
			end
		end
		debug.profilebegin("Uhhhhhh > Placeholders")
		for _,ref in HatRefs do
			local ph = ref.PH
			if ph then
				if ReanimOkay and ref.Hat and ref.Aligned then
					ph.Transparency = 1
				else
					local tcf, _ = GetHatMappedCFrame(GetHatMappedOverride(ref.Map))
					if tcf then
						local lltm = ltm
						if Reanimate.FirstPersonBody then
							if not ph:GetAttribute("AttachHead") then
								lltm = 0
							end
						end
						ph.CFrame = tcf
						ph.Transparency = 1 - (1 - Reanimate.PlaceholderTransparency) * (1 - lltm)
						table.insert(slocked, ph)
					end
				end
			end
		end
		debug.profileend()
		RunService.PreRender:Wait()
		debug.profilebegin("Uhhhhhh > PreRender")
		if RCRootPart and Reanimate:ShouldRotationType() then
			Reanimate:CameraLockCharacter()
		end
		for _,ref in HatRefs do
			local ph = ref.PH
			if ph then
				if ReanimOkay and ref.Hat and ref.Aligned then else
					local tcf, _ = GetHatMappedCFrame(GetHatMappedOverride(ref.Map))
					if tcf then
						ph.CFrame = tcf
					end
				end
			end
		end
		if HatReanimator.HatSpin then
			for _,handle in slocked do
				if math.random() < 0.5 then
					handle.CFrame = handle.CFrame * CFrame.Angles(math.random() * 2 * math.pi, math.random() * 2 * math.pi, math.random() * 2 * math.pi)
				end
			end
		end
		debug.profileend()
	end
	ResetHatRefs()
	for _,v in HatRefs do if v.PH then v.PH:Destroy() end end
	CharConn:Disconnect()
	--replicatesignal(Player.ConnectDiedSignalBackend)
	Reanimate.Stopping = false
	Reanimate.DestroyCharacter()
end

task.wait()
local function ReanimateShowHitboxes()
	local Reanimator = Reanimate.Current
	if Reanimator and Reanimator.ShowHitboxes then
		Reanimator.ShowHitboxes()
	end
end
local function ReanimateFling(target, duration)
	local Reanimator = Reanimate.Current
	if Reanimator and Reanimator.Fling then
		return Reanimator.Fling(target, duration)
	end
	return false
end
-- SetCharacter thing, very empyrean-like system
_G_Uhhhhhh.Fling = function(part)
	if part and part.Parent then
		if part:IsA("BasePart") then
			part = part.Parent
			if part:IsA("Accessory") or part:IsA("Tool") then
				part = part.Parent
			end
		end
		local hum = part:FindFirstChildOfClass("Humanoid")
		if hum and hum.RootPart and not hum.RootPart:IsGrounded() then
			return ReanimateFling(part)
		end
	end
end

do
	SaveData.SelectedReanimator = SaveData.SelectedReanimator or 1
	local ReanimateMethodSelect = UI.CreateDropdown(MainPage, "Reanimator", {"Limb Reanimator", "Hats Reanimator"}, SaveData.SelectedReanimator)
	local ReanimatorConfigTitle = UI.CreateText(MainPage, "-=+ Limb Reanimator Config +=-", 15, Enum.TextXAlignment.Center)
	local SelectedReanimator = LimbReanimator
	if SaveData.SelectedReanimator == 2 then
		SelectedReanimator = HatReanimator
		ReanimatorConfigTitle.Text = "-=+ Hats Reanimator Config +=-"
	end
	local ReanimatorConfigCanvas = UI.CreateCanvas(MainPage)
	ReanimateMethodSelect.Changed:Connect(function(value)
		SaveData.SelectedReanimator = value
		if value == 1 then
			SelectedReanimator = LimbReanimator
			ReanimatorConfigTitle.Text = "-=+ Limb Reanimator Config +=-"
		end
		if value == 2 then
			SelectedReanimator = HatReanimator
			ReanimatorConfigTitle.Text = "-=+ Hats Reanimator Config +=-"
		end
		Util.ClearAllChildrenGui(ReanimatorConfigCanvas)
		SelectedReanimator.Config(ReanimatorConfigCanvas)
	end)
	SelectedReanimator.Config(ReanimatorConfigCanvas)
	UI.CreateText(MainPage, " ", 5, Enum.TextXAlignment.Center)
	local ReanimateText = UI.CreateText(MainPage, "Running: NONE", 15, Enum.TextXAlignment.Center)
	local ReanimateStartButton, ReanimateStartButtonText = UI.CreateButton(MainPage, "* Reanimate *", 20)
	ReanimateStartButton.Activated:Connect(function()
		ReanimateStartButton.Interactable = false
		if Reanimate.Current then
			ReanimateStartButtonText.Text = "Stopping..."
			Reanimate.Stopping = true
			repeat task.wait() until not Reanimate.Stopping
			Reanimate.Current.Running = nil
			Reanimate.Current = nil
			HumanoidLASetHookState(false)
			ReanimateText.Text = "Running: NONE"
			task.wait(1)
			ReanimateStartButtonText.Text = "* Reanimate *"
		else
			ReanimateStartButtonText.Text = "Starting..."
			Reanimate.Starting = true
			Reanimate.Current = SelectedReanimator
			HumanoidLASetHookState(Reanimate.UseLoadAnimationHook)
			ReanimateText.Text = "Running: " .. Reanimate.Current.Name
			task.spawn(Reanimate.Current.Start)
			repeat task.wait() until not Reanimate.Starting
			Reanimate.Current.Running = true
			task.wait(1)
			ReanimateStartButtonText.Text = "* Deanimate *"
		end
		ReanimateStartButton.Interactable = true
	end)
	UI.CreateButton(MainPage, "Show Reanimate Hitboxes", 15).Activated:Connect(function()
		if not Reanimate.Character then return end
		ReanimateShowHitboxes()
	end)
	UI.CreateButton(MainPage, "Refresh Reanimate Character", 10).Activated:Connect(function()
		if not Reanimate.Character then return end
		Reanimate.CreateCharacter()
	end)
end
UI.CreateSeparator(MainPage)

do
	UI.CreateText(MainPage, "Reanimate Character Settings", 15, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Infinite Jump", Reanimate.InfiniteJump).Changed:Connect(function(val)
		Reanimate.InfiniteJump = val
		SaveData.NoInfiniteJump = not val
	end)
	UI.CreateSwitch(MainPage, "Noclip", Reanimate.Noclip).Changed:Connect(function(val)
		Reanimate.Noclip = val
		SaveData.NoclipEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Smooth Camera", Reanimate.SmoothCam).Changed:Connect(function(val)
		Reanimate.SmoothCam = val
		SaveData.NoSmoothCam = not val
	end)
	UI.CreateSwitch(MainPage, "First Person Body", Reanimate.FirstPersonBody).Changed:Connect(function(val)
		Reanimate.FirstPersonBody = val
		SaveData.FirstPersonBody = not val
	end)
	UI.CreateSwitch(MainPage, "Allow Shiftlock", Reanimate.ShiftlockEnabled).Changed:Connect(function(val)
		Reanimate.ShiftlockEnabled = val
		SaveData.ShiftlockDisabled = not val
	end)
	UI.CreateSwitch(MainPage, "Can Sit on Seats", Reanimate.SeatSit).Changed:Connect(function(val)
		Reanimate.SeatSit = val
		SaveData.NoSeatSitEnabled = not val
	end)
	UI.CreateSwitch(MainPage, "Can Pickup Tools", Reanimate.ToolGrab).Changed:Connect(function(val)
		Reanimate.ToolGrab = val
		SaveData.ToolGrabEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Apply Scale to Gravity", Reanimate.ScaleGravity).Changed:Connect(function(val)
		Reanimate.ScaleGravity = val
		SaveData.ScaleGravityEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Void Float", Reanimate.PatchmaVoidFloat).Changed:Connect(function(val)
		Reanimate.PatchmaVoidFloat = val
		SaveData.PatchmaVoidFloat = val
	end)
	UI.CreateButton(MainPage, "Force Sit (2x to remove gyro)", 20).Activated:Connect(function()
		local ch = Reanimate.Character or Player.Character
		if ch then
			local h = ch:FindFirstChildOfClass("Humanoid")
			local r = h and h.RootPart
			if h and r then
				h.Sit = true
				if r:FindFirstChild("SeatGyro") then
					r.SeatGyro:Destroy()
				else
					local g = Instance.new("BodyGyro")
					g.Name = "SeatGyro"
					g.CFrame = r.CFrame
					g.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
					g.Parent = r
					Util.LinkDestroyI2C(g, h:GetPropertyChangedSignal("Sit"):Once(function()
						g:Destroy()
					end))
				end
			end
		end
	end)
	local CharacterScaleSlider = UI.CreateSlider(MainPage, "Character Scale", Reanimate.CharacterScale, 0.5, 5, 0.5)
	CharacterScaleSlider.Changed:Connect(function(val)
		val = math.clamp(val, 0.001, 20)
		CharacterScaleSlider.Value = val
		Reanimate.CharacterScale = val
		SaveData.CharacterScale = val
	end)
	local PlaceholderTransparencySlider = UI.CreateSlider(MainPage, "Placeholders", Reanimate.PlaceholderTransparency, 0, 1, 0.05)
	PlaceholderTransparencySlider.Changed:Connect(function(val)
		val = math.clamp(val, 0, 1)
		PlaceholderTransparencySlider.Value = val
		Reanimate.PlaceholderTransparency = val
		SaveData.PlaceholderTransparency = val
	end)
	UI.CreateSeparator(MainPage)
	local function ReanimCharacterTeleport(pos)
		local ch = Reanimate.Character or Player.Character
		if ch then
			local h = ch:FindFirstChildOfClass("Humanoid")
			local r = h and h.RootPart
			if h and r then
				r.CFrame = r.CFrame.Rotation + pos
				r.Velocity = Vector3.zero
				r.RotVelocity = Vector3.zero
			end
		end
	end
	UI.CreateSwitch(MainPage, "Click Fling", Reanimate.ClickFling).Changed:Connect(function(val)
		Reanimate.ClickFling = val
		SaveData.ClickFlingEnabled = val
	end)
	UI.CreateSwitch(MainPage, "Key+Click Teleport", Reanimate.CtrlClick).Changed:Connect(function(val)
		Reanimate.CtrlClick = val
		SaveData.CtrlClickEnabled = val
	end)
	local selectedkey = Enum.KeyCode.LeftControl
	SaveData.CtrlClickKey = SaveData.CtrlClickKey or 1
	local function updatekey()
		local val = SaveData.CtrlClickKey
		if val == 1 then
			selectedkey = Enum.KeyCode.LeftControl
		end
		if val == 2 then
			selectedkey = Enum.KeyCode.RightBracket
		end
		if val == 3 then
			selectedkey = Enum.KeyCode.Tab
		end
		if val == 4 then
			selectedkey = Enum.KeyCode.Z
		end
		if val == 5 then
			selectedkey = Enum.KeyCode.X
		end
		if val == 6 then
			selectedkey = Enum.KeyCode.F
		end
		if val == 7 then
			selectedkey = Enum.KeyCode.T
		end
	end
	updatekey()
	UI.CreateDropdown(MainPage, "TP Key", {
		"Left Ctrl (default)", "inno's pick (']')", "Tab (idk)",
		"Z", "X (i like this one on pc)", "F", "T",
	}, SaveData.CtrlClickKey).Changed:Connect(function(val)
		SaveData.CtrlClickKey = val
		updatekey()
	end)
	local Maus = Player:GetMouse()
	local HoldingCtrl = UI.CreateSwitch(MainPage, "TP Key Held", false)
	local _lastclick = nil
	local _lastclickgpe = false
	local _lastclicktick = 0
	local _lastclickpos = Vector3.zero
	UserInputService.InputBegan:Connect(function(input, gpe)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == selectedkey then
				HoldingCtrl.Value = true
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			_lastclick = input
			_lastclickgpe = gpe
			_lastclicktick = os.clock()
			_lastclickpos = input.Position
		end
	end)
	UserInputService.InputEnded:Connect(function(input, gpe)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == selectedkey then
				HoldingCtrl.Value = false
			end
		end
		if _lastclick and _lastclick == input and not _lastclickgpe then
			if input.UserInputType == Enum.UserInputType.MouseButton1 or (os.clock() - _lastclicktick < 0.3 and (input.Position - _lastclickpos).Magnitude < 10) then
				if Reanimate.CtrlClick and HoldingCtrl.Value then
					if Maus.Target and Maus.Target.Parent then
						ReanimCharacterTeleport(Maus.Hit.Position + Vector3.new(0, 3, 0))
						return
					end
				end
				if Reanimate.ClickFling then
					if Maus.Target and Maus.Target.Parent then 
						local target = Maus.Target.Parent
						if target:IsA("Accessory") then
							target = target.Parent
						end
						if target:FindFirstChildOfClass("Humanoid") then
							if ReanimateFling(target) then return end
						end
					end
				end
			end
		end
	end)
	UI.CreateButton(MainPage, "Teleport to 0, highest, 0", 20).Activated:Connect(function()
		local hit = workspace:Raycast(Vector3.new(0, 4500, 0), Vector3.new(0, -4500 + FallenPartsDestroyHeight, 0))
		if hit and hit.Position == hit.Position then
			ReanimCharacterTeleport(hit.Position + Vector3.new(0, 5, 0))
		else
			ReanimCharacterTeleport(Vector3.new(0, 0, 0))
		end
	end)
	UI.CreateButton(MainPage, "Teleport to 'LastSafe'", 20).Activated:Connect(function()
		ReanimCharacterTeleport(Vector3.new(0, FallenPartsDestroyHeight - 5000, 0))
	end)
	local TeleportToPlayerSel = UI.CreateText(MainPage, "<font color=\"#AAAAAA\">(enter a player name)</font>", 15, Enum.TextXAlignment.Center)
	local TeleportToPlayer = UI.CreateTextbox(MainPage, "", "Teleport To Player", 20)
	TeleportToPlayer:GetPropertyChangedSignal("Text"):Connect(function()
		local sel = Util.QueryPlayerSelector(TeleportToPlayer.Text)
		if sel then
			TeleportToPlayerSel.Text = `{sel.DisplayName} (@{sel.Name})`
		else
			if #TeleportToPlayer.Text == 0 then
				TeleportToPlayerSel.Text = "<font color=\"#AAAAAA\">(enter a player name)</font>"
			else
				TeleportToPlayerSel.Text = "<font color=\"#FF7777\">(player not found)</font>"
			end
		end
	end)
	TeleportToPlayer.FocusLost:Connect(function(enter)
		if enter then
			local sel = Util.QueryPlayerSelector(TeleportToPlayer.Text)
			if sel and sel.Character then
				local r = sel.Character:FindFirstChild("LowerTorso") or sel.Character:FindFirstChild("Torso")
				if r and r:IsA("BasePart") then
					ReanimCharacterTeleport(r.CFrame.Position)
				end
			end
			TeleportToPlayer.Text = ""
		end
	end)
end
UI.CreateSeparator(MainPage)
do
	UI.CreateText(MainPage, "Internals Settings", 15, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Hook LoadAnimation", Reanimate.UseLoadAnimationHook).Changed:Connect(function(val)
		Reanimate.UseLoadAnimationHook = val
		SaveData.NoLoadAnimationHook = not val
	end)
	if ismissing(hookmetamethod) or ismissing(hookfunction) then
		UI.CreateText(MainPage, "^ this option will not work for you", 10, Enum.TextXAlignment.Center)
	end
	UI.CreateSwitch(MainPage, "Use Physics Glue", Reanimate.UsePhysicsRepRootPart).Changed:Connect(function(val)
		Reanimate.UsePhysicsRepRootPart = val
		SaveData.NoPhysicsRepRootPart = not val
	end)
	UI.CreateText(MainPage, "internals for physics based reanimation\n(like hat reanimator)", 10, Enum.TextXAlignment.Center)
	UI.CreateSwitch(MainPage, "Patchma-like Netless", Reanimate.UsePatchmaLikeNetless).Changed:Connect(function(val)
		Reanimate.UsePatchmaLikeNetless = val
		SaveData.UsePatchmaLikeNetless = val
	end)
	local NetVelSlider = UI.CreateSlider(MainPage, "Netless Velocity", Reanimate.NetlessVelocity, 25.01, 30, 0.1)
	NetVelSlider.Changed:Connect(function(val)
		val = math.clamp(val, 25.01, 30)
		NetVelSlider.Value = val
		Reanimate.NetlessVelocity = val
		SaveData.NetlessVelocity = val
	end)
	UI.CreateSwitch(MainPage, "Apply RotVelocity", Reanimate.UseAngularVelocity).Changed:Connect(function(val)
		Reanimate.UseAngularVelocity = val
		SaveData.UseAngularVelocity = val
	end)
end
UI.CreateSeparator(MainPage)

local AnimLib = {}
do
	local Track = {}
	function Track.frombuffer(buf)
		local needle = 0
		local buflen = buffer.len(buf)
		local function getleft()
			return buflen - needle
		end
		local function readstring()
			assert(getleft() >= 2)
			local len = buffer.readu16(buf, needle)
			needle += 2
			assert(getleft() >= len)
			local val = buffer.readstring(buf, needle, len)
			needle += len
			return val
		end
		local function readsizet()
			assert(getleft() >= 4)
			local val = buffer.readu32(buf, needle)
			needle += 4
			return val
		end
		local function readfloat()
			assert(getleft() >= 4)
			local val = buffer.readf32(buf, needle)
			needle += 4
			return val
		end
		local anim = {
			Name = "<unknown>",
			Time = 0,
			Keyframes = {},
		}
		anim.Name = readstring() -- name
		local nkeyframes = readsizet() -- # of keyframes
		for _=1, nkeyframes do
			local t = readfloat() -- time
			anim.Time = math.max(anim.Time, t)
			local nposes = readsizet() -- # of poses
			local keyframe = {
				Time = t,
				Poses = {}
			}
			for _=1, nposes do
				local pose = {}
				pose.Name = readstring() -- "bone" name
				pose.Weight = readfloat() -- weight (usually 1 or 0)
				pose.EasingStyle = readstring() -- EasingStyle
				pose.EasingDirection = readstring() -- EasingDirection
				pose.CFrame = CFrame.new(
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat(),
					readfloat()
				) -- cframe
				table.insert(keyframe.Poses, pose)
			end
			table.insert(anim.Keyframes, keyframe)
		end
		-- sort by time for ez lookup
		table.sort(anim.Keyframes, function(a, b)
			return a.Time < b.Time
		end)
		return anim
	end
	function Track.fromfile(path)
		local s, data = pcall(readfile, path)
		if s and data then
			local buf = buffer.fromstring(data)
			return Track.frombuffer(buf)
		end
	end
	function Track.frominstance(ks)
		assert(ks and ks:IsA("KeyframeSequence"))
		local anim = {
			Name = "<unknown>",
			Time = 0,
			Keyframes = {},
		}
		anim.Name = ks.Name
		for _,k in ks:GetKeyframes() do
			local t = k.Time
			anim.Time = math.max(anim.Time, t)
			local keyframe = {
				Time = t,
				Poses = {}
			}
			for _,p in k:GetDescendants() do
				if not p:IsA("Pose") then continue end
				table.insert(keyframe.Poses, {
					Name = p.Name,
					Weight = p.Weight,
					EasingStyle = p.EasingStyle.Name,
					EasingDirection = p.EasingDirection.Name,
					CFrame = p.CFrame
				})
			end
			table.insert(anim.Keyframes, keyframe)
		end
		table.sort(anim.Keyframes, function(a, b)
			return a.Time < b.Time
		end)
		return anim
	end
	function Track.paste(target, source, timeoffset)
		for _,keyframe in source.Keyframes do
			local newkeyframe = DeepcopyTable(keyframe)
			newkeyframe.Time += timeoffset
			table.insert(target.Keyframes, newkeyframe)
		end
		anim.Time = 0
		table.sort(source.Keyframes, function(a, b)
			anim.Time = math.max(anim.Time, a.Time, b.Time)
			return a.Time < b.Time
		end)
	end
	function Track.getPoses(track, t, looped)
		-- not recommended for use on big anims
		local poses = {}
		local keyframes = track.Keyframes
		for _,keyframe in keyframes do
			for _,pose in keyframe.Poses do
				poses[pose.Name] = CFrame.identity
			end
		end
		if looped then
			t = t % track.Time
		end
		for name,_ in poses do
			local k1, k2, t1, t2 = nil, nil, -math.huge, math.huge
			for _,k in keyframes do
				local po = nil
				for _,p in k.Poses do
					if p.Name == name and p.Weight > 0 then
						po = p
					end
				end
				if po ~= nil then
					if t1 < k.Time and k.Time <= t then
						k1 = po
						t1 = k.Time
					end
					if t2 > k.Time and k.Time > t then
						k2 = po
						t2 = k.Time
					end
				end
			end
			local cf = CFrame.identity
			if k1 ~= nil then
				if k2 ~= nil then
					local a = (t - t1) / (t2 - t1)
					local es, ed = k1.EasingStyle, k1.EasingDirection
					if es == "Constant" then
						if ed == "In" then
							a = 1
						elseif ed == "Out" then
							a = 0
						else
							if a < 0.5 then
								a = 0
							else
								a = 1
							end
						end
					else
						if es == "CubicV2" then
							es = "Cubic"
						end
						a = TweenService:GetValue(
							a,
							Enum.EasingStyle[es],
							Enum.EasingDirection[ed]
						)
					end
					cf = k1.CFrame:Lerp(k2.CFrame, a)
				else
					cf = k1.CFrame
				end
			else
				if k2 ~= nil then
					cf = k2.CFrame
				end
			end
			poses[name] = cf
		end
		return poses
	end
	AnimLib.Track = Track
	local Animator = {}
	Animator.__index = Animator
	function Animator.new()
		local self = setmetatable({}, Animator)
		self.rig = nil
		self.track = nil
		self.map = {{0, 1}, {0, 1}}
		self.looped = false
		self.speed = 1
		self.weight = 1
		self._optimiser = 1
		self._jointmap = nil
		self._skipsec = nil
		self._rig = nil
		self._track = nil
		return self
	end
	function Animator:Step(t)
		local rig, track, map, speed, weight, looped = self.rig, self.track, self.map, self.speed, self.weight, self.looped
		local jointmap, skipsec = self._jointmap, self._skipsec
		if rig and track then
			local scale = rig:GetScale()
			t *= speed
			if map then
				t = map[2][1] + (t - map[1][1]) * (map[2][2] - map[2][1]) / (map[1][2] - map[1][1])
			end
			if self._rig ~= rig then
				jointmap = nil
				self._rig = rig
			end
			if self._track ~= track then
				skipsec = nil
				self._track = track
			end
			if not jointmap then
				jointmap = {}
				for _,v in rig:GetDescendants() do
					if v:IsA("Motor6D") and v.Part0 and v.Part1 then
						jointmap[v.Part1.Name] = v
					end
				end
				self._jointmap = jointmap
			end
			local keyframes = track.Keyframes
			if not skipsec then
				skipsec = {}
				local i = 1
				local oldsec = 0
				while i < #keyframes do
					local k = keyframes[i]
					local sec = k.Time // self._optimiser
					while oldsec < sec do
						local j = math.max(1, i - 1)
						local poses = {}
						local scan = j
						while scan > 0 do
							local k2 = keyframes[scan]
							local ok = true
							for name,_ in jointmap do
								if not poses[name] then
									for _,p in k2.Poses do
										if p.Name == name and p.Weight > 0 then
											poses[name] = true
											j = scan
											break
										end
									end
								end
								ok = poses[name] and ok
							end
							if ok then break end
							scan -= 1
						end
						table.insert(skipsec, {j, j})
						oldsec += 1
					end
					i += 1
				end
				for i,v in skipsec do
					while v[2] < #keyframes and keyframes[v[2]].Time <= (i + 1) * self._optimiser do
						v[2] += 1
					end
				end
				self._skipsec = skipsec
			end
			local poses = {}
			for name,_ in jointmap do
				poses[name] = CFrame.identity
			end
			if looped then
				t = t % track.Time
			end
			local skip1, skip2 = 1, #keyframes
			if #skipsec >= 2 then
				local i = t // self._optimiser
				if i < 1 then
					skip1, skip2 = 1, skipsec[1][2]
				elseif i < #skipsec then
					skip1, skip2 = skipsec[i][1], skipsec[i][2]
				else
					skip1, skip2 = skipsec[#skipsec][1], #keyframes
				end
			end
			for name,_ in poses do
				local k1, k2, t1, t2 = nil, nil, -math.huge, math.huge
				for i=skip1, skip2 do
					local k = keyframes[i]
					local po = nil
					for _,p in k.Poses do
						if p.Name == name and p.Weight > 0 then
							po = p
						end
					end
					if po ~= nil then
						if t1 < k.Time and k.Time <= t then
							k1 = po
							t1 = k.Time
						end
						if t2 > k.Time and k.Time > t then
							k2 = po
							t2 = k.Time
						end
					end
				end
				local cf = CFrame.identity
				if k1 ~= nil then
					if k2 ~= nil then
						local a = (t - t1) / (t2 - t1)
						local es, ed = k1.EasingStyle, k1.EasingDirection
						if es == "Constant" then
							if ed == "In" then
								a = 1
							elseif ed == "Out" then
								a = 0
							else
								if a < 0.5 then
									a = 0
								else
									a = 1
								end
							end
						else
							if es == "CubicV2" then
								es = "Cubic"
							end
							a = TweenService:GetValue(
								a,
								Enum.EasingStyle[es],
								Enum.EasingDirection[ed]
							)
						end
						cf = k1.CFrame:Lerp(k2.CFrame, a)
					else
						cf = k1.CFrame
					end
				else
					if k2 ~= nil then
						cf = k2.CFrame
					end
				end
				poses[name] = cf
			end
			for name,joint in jointmap do
				local cf = poses[name] or CFrame.identity
				cf = cf.Rotation + (cf.Position * scale)
				if weight == 1 then
					joint.Transform = cf
				elseif weight ~= 0 then
					joint.Transform = joint.Transform:Lerp(cf, weight)
				end
			end
		end
	end
	AnimLib.Animator = Animator
end
local function AssetGetPathFromFilename(filename)
	local filetype = "Unknown/"
	if filename:sub(-4, -1) == ".mp3" then
		filetype = "Sounds/"
	elseif filename:sub(-5, -1) == ".anim" then
		filetype = "Anims/"
	elseif filename:sub(-4, -1) == ".png" then
		filetype = "Images/"
	elseif filename:sub(-4, -1) == ".rbxm" then
		filetype = "Models/"
	end
	return "UhhhhhhReanim/Content/" .. filetype .. filename
end
local _Assetdownloading = {}
local _Assetdownloadingcount, _Assetdownloadingfail = 0, 0
local function _UpdateDownloadStatus()
	local prog = 1 / ((_Assetdownloadingcount + _Assetdownloadingfail) / 2 + 1)
	if _Assetdownloadingcount > 0 then
		Util.UINotify("Downloading " .. _Assetdownloadingcount .. " assets...", prog)
	else
		if _Assetdownloadingfail > 0 then
			Util.UINotify(_Assetdownloadingfail .. " failed to download", prog)
		else
			Util.UINotify("Asset download done", 1)
		end
	end
end
local function EnsureUrlEncode(source)
	return source:gsub("[^%w%-%._~/]", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
end
local function AssetDownloadAgent(source, filename, path)
	if isfile(path) then return true end
	if _Assetdownloading[filename] then return false end
	_Assetdownloading[filename] = true
	task.spawn(function()
		_Assetdownloadingcount += 1
		_UpdateDownloadStatus()
		--Util.Notify("Downloading " .. filename .. "...")
		local s, resp = pcall(request, {
			Method = "GET",
			Url = source,
		})
		if s and resp and resp.StatusCode == 200 then
			_Assetdownloadingcount -= 1
			_UpdateDownloadStatus()
			pcall(writefile, path, resp.Body)
			task.wait(10)
		else
			_Assetdownloadingcount -= 1
			_Assetdownloadingfail += 1
			_UpdateDownloadStatus()
			--Util.Notify("Failed to download " .. filename .. "!")
			task.wait(10)
			_Assetdownloadingfail -= 1
			_UpdateDownloadStatus()
		end
		_Assetdownloading[filename] = nil
	end)
	return false
end
local function AssetDownload(filename)
	local source = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/content/" .. EnsureUrlEncode(filename)
	local split = string.split(filename, "@")
	if #split > 1 then
		filename = table.remove(split, 1)
		source = table.concat(split, "@")
	end
	if source:sub(1, 7) == "MARKET/" then
		source = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh-Store/main/" .. EnsureUrlEncode(source:sub(8))
	end
	local path = AssetGetPathFromFilename(filename)
	return AssetDownloadAgent(source, filename, path)
end
local function AssetGetContentId(filename)
	local path = AssetGetPathFromFilename(filename)
	if not isfile(path) then return "" end
	local s, id = pcall(getcustomasset, path)
	if s and id then
		return id
	end
	return ""
end
local function AssetEnsure(list)
	local ok = true
	for _,filename in list do
		if not AssetDownload(filename) then
			ok = false
		end
	end
	return ok
end
local function ProtectedChat(content)
	pcall(function()
		TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration").TargetTextChannel:SendAsync(content, Util.RandomString(64))
	end)
end
local OnPlayerChatted = Util.Instance("BindableEvent")
TextChatService.MessageReceived:Connect(function(message)
	if message.Status ~= Enum.TextChatMessageStatus.Sending and message.TextSource and message.TextSource.UserId then
		local plr, msg = Players:GetPlayerByUserId(message.TextSource.UserId), message.Text:gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", "\""):gsub("&apos;", "'"):gsub("&amp;", "&")
		if plr then
			OnPlayerChatted:Fire(plr, msg)
			if msg == "67" then
				Util.UINotify("SON :sob::sob::sob::sob:")
			end
			if msg == "1.1.0" then
				Util.UINotify("the overhaul update is real?")
			end
		end
	end
end)
task.wait()

local MovementStyles = {}
local DanceableDances = {}

local CurrentMovementStyle = nil
local MovementStyleIndex = 2
local _MovementStyleIndex = nil
local CurrentDance = nil
local _CurrentDance = nil
local OldReanimCharacter = nil

if type(SaveData.MovesetIndex) == "number" then
	MovementStyleIndex = SaveData.MovesetIndex
end

local MovesetsPage = UI.CreateItemListPage()
MovesetsPage.ZIndex = 1
MovesetsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
MovesetsPage.Interactable = false
MovesetsPage.Visible = false
UI.CreateButton(MainPage, "Movesets &gt;", 20).Activated:Connect(function()
	MovesetsPage.Interactable = false
	MovesetsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MovesetsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MovesetsPage.Interactable = true
	end)
end)
MovesetsPage.Back.Activated:Connect(function()
	MovesetsPage.Interactable = false
	MovesetsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MovesetsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		MovesetsPage.Visible = false
	end)
end)
local DancesPage = UI.CreateItemListPage()
DancesPage.ZIndex = 1
DancesPage.Position = UDim2.new(0.5, 360, 0.5, 0)
DancesPage.Interactable = false
DancesPage.Visible = false
UI.CreateButton(MainPage, "Dances &gt;", 20).Activated:Connect(function()
	DancesPage.Interactable = false
	DancesPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(DancesPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		DancesPage.Interactable = true
	end)
end)
DancesPage.Back.Activated:Connect(function()
	DancesPage.Interactable = false
	DancesPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(DancesPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		DancesPage.Visible = false
	end)
end)
local KeybindsPage = UI.CreateItemListPage()
KeybindsPage.ZIndex = 1
KeybindsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
KeybindsPage.Interactable = false
KeybindsPage.Visible = false
UI.CreateButton(MainPage, "Dance Keybinds &gt;", 20).Activated:Connect(function()
	KeybindsPage.Interactable = false
	KeybindsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(KeybindsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		KeybindsPage.Interactable = true
	end)
end)
KeybindsPage.Back.Activated:Connect(function()
	KeybindsPage.Interactable = false
	KeybindsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(KeybindsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		KeybindsPage.Visible = false
	end)
end)
local MarketPage = UI.CreatePage()
MarketPage.ZIndex = 1
MarketPage.Position = UDim2.new(0.5, 360, 0.5, 0)
MarketPage.Interactable = false
MarketPage.Visible = false
UI.CreateButton(MainPage, (math.random() < 0.5 and "Store" or "Marketplace") .. " &gt;", 20).Activated:Connect(function()
	MarketPage.Interactable = false
	MarketPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MarketPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarketPage.Interactable = true
	end)
end)
UI.CreateButton(MarketPage, "&lt; Hurry back", 20).Activated:Connect(function()
	MarketPage.Interactable = false
	MarketPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(MarketPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		MarketPage.Visible = false
	end)
end)
UI.CreateSeparator(MarketPage)

SaveData.KeybindsEnabled = not not SaveData.KeybindsEnabled
UI.CreateSwitch(MainPage, "Dance Keybinds Enabled", SaveData.KeybindsEnabled).Changed:Connect(function(val)
	SaveData.KeybindsEnabled = val
end)
local Keybinds = {}
local KeybindsPerPage = {"Z", "X", "C", "V", "B", "N", "G", "H", "J", "K", "L", "R", "T", "U", "P"}
local KeybindPaging = 0
local RefreshKeybinds = nil
local function HandleKeybind(key)
	if table.find(KeybindsPerPage, key) then
		if CurrentDance then
			CurrentDance = nil
			return true
		else
			CurrentDance = Keybinds[key]
			if CurrentDance then
				Util.UINotify(key .. " - " .. CurrentDance.Name)
				return true
			end
		end
	end
	if key == "M" then
		local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
		KeybindPaging = (KeybindPaging + 1) % pages
		Util.UINotify("Page " .. (KeybindPaging + 1))
		RefreshKeybinds()
		return true
	end
	return false
end
RefreshKeybinds = function()
	local pages = math.max(1, 1 + ((#DanceableDances - 1) // #KeybindsPerPage))
	Util.ClearAllChildrenGui(KeybindsPage.List)
	local button = UI.CreateButton(KeybindsPage.List, "M - Page " .. (((KeybindPaging + 1) % pages) + 1), 20)
	button.Parent.Name = ""
	button.Activated:Connect(function()
		HandleKeybind("M")
	end)
	local indexoffset = KeybindPaging * #KeybindsPerPage
	for i=1, #KeybindsPerPage do
		local key = KeybindsPerPage[i]
		local index = indexoffset + i
		local dance = DanceableDances[index]
		Keybinds[key] = dance
		if dance then
			button = UI.CreateButton(KeybindsPage.List, key .. " - " .. dance.Name, 20)
			button.Parent.Name = key .. " " .. dance.Name
			button.Activated:Connect(function()
				HandleKeybind(key)
			end)
		end
	end
end
local ContextActions = {}
ContextActions._Actions = {}
ContextActions._ActionsMap = {}
do
	local buttonsui = Instance.new("Frame", SCREENGUI)
	buttonsui.BackgroundTransparency = 1
	buttonsui.Name = Util.RandomString()
	buttonsui.AnchorPoint = Vector2.new(0, 0)
	buttonsui.Position = UDim2.new(1, -90, 1, -90)
	buttonsui.Size = UDim2.new(0, 130, 0, 130)
	ContextActions._ButtonsGui = buttonsui
	local actions, actionsmap = ContextActions._Actions, ContextActions._ActionsMap
	function ContextActions:RunBinding(caac, input)
		local s, result = xpcall(caac.Callback, function(m)
			warn(debug.traceback("Uhhhhhh :: Custom ContextActions Error - " .. m))
		end, caac.Name, input.UserInputState, input)
		if s then
			if result == Enum.ContextActionResult.Sink then
				return true
			end
		end
		return false
	end
	function ContextActions:OnInput(input, gpe)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			if gpe then return end
		end
		for i=#actions, 1, -1 do
			local caac = actions[i]
			local exec = false
			for _,v in caac.Inputs do
				if v == input.UserInputType then
					exec = true
					break
				end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if v == input.KeyCode then
						exec = true
						break
					end
				end
			end
			if exec then
				if ContextActions:RunBinding(caac, input) then return end
			end
		end
	end
	function ContextActions:UnbindAllActions()
		table.clear(actions)
		table.clear(actionsmap)
		ContextActions._ButtonsGui:ClearAllChildren()
	end
	function ContextActions:BindAction(name, callback, touchButton, ...)
		assert(type(name) == "string")
		assert(type(callback) == "function")
		assert(type(touchButton) == "boolean")
		ContextActions:UnbindAction(name)
		local caac = {
			Name = name,
			Callback = callback,
			Inputs = {...}
		}
		table.insert(actions, caac)
		actionsmap[name] = caac
		if touchButton then
			local button = Instance.new("ImageButton", buttonsui)
			button.Name = Util.RandomString()
			button.Position = UDim2.new(0, 0, 0, 0)
			button.Size = UDim2.new(0, 35, 0, 35)
			button.Image = "https://www.roblox.com/asset/?id=97166444"
			button.BackgroundTransparency = 1
			local txt = Instance.new("TextLabel", button)
			txt.Name = "Title"
			txt.Position = UDim2.new(0, 0, 0, 0)
			txt.Size = UDim2.new(1, 0, 1, 0)
			txt.BackgroundTransparency = 1
			txt.Font = Enum.Font.SourceSansBold
			txt.TextSize = 18
			txt.TextColor3 = Color3.new(1, 1, 1)
			txt.TextStrokeTransparency = 0
			txt.TextStrokeColor3 = Color3.new(0, 0, 0)
			txt.Text = ""
			local icon = Instance.new("ImageLabel", button)
			icon.Name = "Icon"
			icon.Position = UDim2.new(0, 0, 0, 0)
			icon.Size = UDim2.new(1, 0, 1, 0)
			icon.BackgroundTransparency = 1
			icon.Image = ""
			button.InputBegan:Connect(function(input)
				ContextActions:RunBinding(caac, input)
			end)
			button.InputChanged:Connect(function(input)
				ContextActions:RunBinding(caac, input)
			end)
			button.InputEnded:Connect(function(input)
				ContextActions:RunBinding(caac, input)
			end)
			caac.TouchButton = button
		end
	end
	function ContextActions:UnbindAction(name)
		local caac = actionsmap[name]
		if caac then
			if caac.TouchButton then
				caac.TouchButton:Destroy()
			end
			local i = table.find(actions, caac)
			if i then table.remove(actions, i) end
		end
	end
	function ContextActions:SetTitle(name, title)
		local caac = actionsmap[name]
		if caac then
			local button = caac.TouchButton
			if button then
				if button.Icon.Image == "" then
					button.Title.Visible = true
					button.Icon.Visible = false
				else
					button.Title.Visible = true
					button.Icon.Visible = false
				end
				button.Title.Text = title
			end
		end
	end
	function ContextActions:SetImage(name, image)
		local caac = actionsmap[name]
		if caac then
			local button = caac.TouchButton
			if button then
				if image then
					button.Icon.Image = image
				else
					button.Icon.Image = ""
				end
				if button.Icon.Image == "" then
					button.Title.Visible = true
					button.Icon.Visible = false
				else
					button.Title.Visible = true
					button.Icon.Visible = false
				end
			end
		end
	end
	function ContextActions:SetPosition(name, position)
		local caac = actionsmap[name]
		if caac then
			local button = caac.TouchButton
			if button then
				button.Position = position
			end
		end
	end
	AddToRenderStep(function()
		local playerGui = Player:FindFirstChildOfClass("PlayerGui")
		local touchGui = playerGui and playerGui:FindFirstChild("TouchGui")
		if not touchGui or not touchGui.Enabled then
			buttonsui.Visible = false
			return
		end
		local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
		local jumpButton = touchFrame and touchFrame:FindFirstChild("JumpButton")
		if not jumpButton then
			buttonsui.Visible = false
			return
		end
		local pos = jumpButton.AbsolutePosition - SCREENGUI.AbsolutePosition
		buttonsui.Visible = true
		buttonsui.Position = UDim2.fromOffset(pos.X - 35, pos.Y - 35)
	end)
end
UserInputService.InputBegan:Connect(function(input, gpe)
	if UserInputService:GetFocusedTextBox() then return end
	if SaveData.KeybindsEnabled then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if HandleKeybind(input.KeyCode.Name) then return end
		end
	end
	ContextActions:OnInput(input, gpe)
end)
UserInputService.InputChanged:Connect(function(input, gpe)
	if UserInputService:GetFocusedTextBox() then return end
	ContextActions:OnInput(input, gpe)
end)
UserInputService.InputEnded:Connect(function(input, gpe)
	if UserInputService:GetFocusedTextBox() then return end
	ContextActions:OnInput(input, gpe)
end)

if type(SaveData.ModuleConfigs) ~= "table" then
	SaveData.ModuleConfigs = {}
end
local function GiveFunctionsToFunction(func)
	local env = b_getfenv(func)
	env.RandomString = Util.RandomString
	env.Util_CreateText = UI.CreateText
	env.Util_CreateButton = UI.CreateButton
	env.Util_CreateSwitch = UI.CreateSwitch
	env.Util_CreateTextbox = UI.CreateTextbox
	env.Util_CreateSlider = UI.CreateSlider
	env.Util_CreateDropdown = UI.CreateDropdown
	env.Util_CreateCanvas = UI.CreateCanvas
	env.Util_CreateScrollCanvas = UI.CreateScrollCanvas
	env.Util_CreateSeparator = UI.CreateSeparator
	env.ReanimCamera = Reanimate.Camera
	env.LimbReanimator = LimbReanimator
	env.HatReanimator = HatReanimator
	env.ReanimateShowHitboxes = ReanimateShowHitboxes
	env.ReanimateFling = ReanimateFling
	env.SetOverrideMovesetMusic = SetOverrideMovesetMusic
	env.GetOverrideMovesetMusicTime = GetOverrideMovesetMusicTime
	env.SetOverrideMovesetMusicTime = SetOverrideMovesetMusicTime
	env.SetOverrideMovesetMusicSpeed = SetOverrideMovesetMusicSpeed
	env.SetOverrideDanceMusic = SetOverrideDanceMusic
	env.GetOverrideDanceMusicTime = GetOverrideDanceMusicTime
	env.SetOverrideDanceMusicTime = SetOverrideDanceMusicTime
	env.SetOverrideDanceMusicSpeed = SetOverrideDanceMusicSpeed
	env.AnimLib = AnimLib
	env.ContextActions = ContextActions
	env.AssetGetPathFromFilename = AssetGetPathFromFilename
	env.AssetGetContentId = AssetGetContentId
	env.ProtectedChat = ProtectedChat
	env.OnPlayerChatted = OnPlayerChatted
	env.HiddenGui = SCREENGUI
	env.FallenPartsDestroyHeight = FallenPartsDestroyHeight
end
local function ClearModules()
	table.clear(MovementStyles)
	table.clear(DanceableDances)
	Util.ClearAllChildrenGui(MovesetsPage.List)
	Util.ClearAllChildrenGui(DancesPage.List)
	RefreshKeybinds()
end
local function GetModuleHash(m)
	if m.Hash then return m.Hash end
	local str = m.Name .. "somethingsomethingidkLOL:3:3:3:3" .. m.Description
	str = buffer.fromstring(string.rep(str, 8))
	local hash = {36, 91, 225, 10, 232, 117, 96, 243, 93, 128, 61, 97, 101, 120, 130, 69, 177, 80, 131, 27, 137, 242, 155, 245, 22, 123, 197, 145, 146, 206, 157, 20, 36, 91, 225, 10, 232, 117, 96, 243, 93, 128, 61, 97, 101, 120, 130, 69, 177, 80, 131, 27, 137, 242, 155, 245, 22, 123, 197, 145, 146, 206, 157, 20}
	local off = buffer.readu8(str, 0) % 64
	local l = buffer.len(str)
	for i=1, l do
		local j = ((off + i) % 64) + 1
		hash[j] = bit32.bxor(hash[j], buffer.readu8(str, i - 1)) % 256
	end
	str = ""
	local hex = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
	for i=1, #hash do
		local x = hash[i]
		local a, b = x % 16, x // 16
		str ..= hex[b + 1] .. hex[a + 1]
	end
	m.Hash = str
	return str
end
local function AddMoveset(m)
	if type(m) == "table" then
		if not m.Name then return end
		if not m.Description then return end
		if not m.Config then return end
		if not m.Assets then return end
		if not m.Init then return end
		if not m.Update then return end
		if not m.Destroy then return end
		GetModuleHash(m)
		if m.LoadConfig then
			if SaveData.ModuleConfigs[m.Hash] then
				pcall(m.LoadConfig, SaveData.ModuleConfigs[m.Hash])
			end
		end
		table.insert(MovementStyles, m)
		local item = UI.CreateItemListItem(MovesetsPage.List)
		local msname = UI.CreateText(item, m.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		local msdesc = UI.CreateText(item, string.split(m.Description, "\n")[1], 12, Enum.TextXAlignment.Left)
		msname.Name = "LabelName"
		msdesc.Name = "LabelDesc"
		item.Parent.Name = m.Name .. " " .. m.Description
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 2
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				MovesetsPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					MovesetsPage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, m.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, m.Description, 15, Enum.TextXAlignment.Left)
			local equip, equiptext = UI.CreateButton(page, "Use Moveset", 20)
			if MovementStyleIndex == table.find(MovementStyles, m) then
				equiptext.Text = "* ACTIVE *"
			end
			equip.Activated:Connect(function()
				equiptext.Text = "* ACTIVE *"
				MovementStyleIndex = table.find(MovementStyles, m)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, "* Configuration *", 15, Enum.TextXAlignment.Center)
			m.Config(page)
			MovesetsPage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
		return m.Name
	end
end
local function AddDance(m)
	if type(m) == "table" then
		if not m.Name then return end
		if not m.Description then return end
		if not m.Assets then return end
		if not m.Config then return end
		if not m.Init then return end
		if not m.Update then return end
		if not m.Destroy then return end
		GetModuleHash(m)
		if m.LoadConfig then
			if SaveData.ModuleConfigs[m.Hash] then
				pcall(m.LoadConfig, SaveData.ModuleConfigs[m.Hash])
			end
		end
		table.insert(DanceableDances, m)
		local item = UI.CreateItemListItem(DancesPage.List)
		local msname = UI.CreateText(item, m.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		local msdesc = UI.CreateText(item, string.split(m.Description, "\n")[1], 12, Enum.TextXAlignment.Left)
		msname.Name = "LabelName"
		msdesc.Name = "LabelDesc"
		item.Parent.Name = m.Name .. " " .. m.Description
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 2
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				DancesPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					DancesPage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, m.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, m.Description, 15, Enum.TextXAlignment.Left)
			local equip, equiptext = UI.CreateButton(page, "Play Dance", 20)
			if CurrentDance == m then
				equiptext.Text = "Stop Dance"
			end
			equip.Activated:Connect(function()
				if CurrentDance == m then
					equiptext.Text = "Play Dance"
					CurrentDance = nil
				else
					equiptext.Text = "Stop Dance"
					CurrentDance = m
				end
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, "* Configuration *", 15, Enum.TextXAlignment.Center)
			m.Config(page)
			DancesPage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
		return m.Name
	end
end
local function AddModule(func)
	GiveFunctionsToFunction(func)
	local m = func()
	if m and type(m) == "table" then
		if m.ModuleType == "MOVESET" then
			return AddMoveset(m)
		elseif m.ModuleType == "DANCE" then
			return AddDance(m)
		else
			return nil, "Unknown ModuleType for Module!"
		end
	else
		return nil, "Module return value is not a table. Got " .. typeof(m) .. " instead."
	end
end
local function AddModules(list)
	local names = {}
	local logging = ""
	if type(list) == "table" then
		for i=1, #list do
			local name, logging2 = AddModule(list[i])
			if name then table.insert(names, name) end
			if logging2 then
				logging ..= "\n[ERROR] M" .. i .. ": " .. logging2
			end
			task.wait()
		end
	else
		logging ..= "\n[LOG] Module return value is not a table array of module functions. Skipping."
	end
	logging ..= "\n[LOG] Loaded " .. #names .. " modules."
	return names, logging
end
task.spawn(function()
	local function SaveConfig(m)
		if m.SaveConfig then
			local s, data = pcall(m.SaveConfig)
			if s and data then
				local s2, p = pcall(HttpService.JSONEncode, HttpService, data)
				if s2 and p then
					SaveData.ModuleConfigs[m.Hash] = data
					return
				else
					warn(p)
				end
			else
				warn(data)
			end
			Util.Notify("Failed to save " .. m.Name .. "'s config")
		end
	end
	while task.wait(5) do
		for _,m in MovementStyles do
			SaveConfig(m)
		end
		for _,m in DanceableDances do
			SaveConfig(m)
		end
	end
end)
task.spawn(function()
	local _oldcharacterreference = nil
	local errorsandwarnings = {}
	local currenterrorid = 1
	while true do local dt = RunService.Heartbeat:Wait() xpcall(function(dt)
		local ReanimCharacter = Reanimate.Character
		SaveData.MovesetIndex = MovementStyleIndex
		if ReanimCharacter then
			if _oldcharacterreference ~= ReanimCharacter then
				SetOverrideMovesetMusic(nil)
				SetOverrideDanceMusic(nil)
				if CurrentMovementStyle then
					pcall(CurrentMovementStyle.Destroy, nil)
					CurrentMovementStyle = nil
				end
				if _CurrentDance then
					pcall(_CurrentDance.Destroy, nil)
					_CurrentDance = nil
				end
				_MovementStyleIndex = nil
			end
			if MovementStyleIndex ~= _MovementStyleIndex then
				if CurrentMovementStyle then
					CurrentMovementStyle.Destroy(ReanimCharacter)
					CurrentMovementStyle = nil
				end
				_MovementStyleIndex = MovementStyleIndex
				CurrentMovementStyle = MovementStyles[MovementStyleIndex]
				SetOverrideMovesetMusic(nil)
				if ReanimCharacter:GetAttribute("MovementInit") then
					Reanimate.CreateCharacter()
					ReanimCharacter = Reanimate.Character
				end
			end
			if CurrentMovementStyle then
				if ReanimCharacter:GetAttribute("MovementInit") then
					CurrentMovementStyle.Update(dt, ReanimCharacter)
					if CurrentDance ~= _CurrentDance then
						if _CurrentDance then
							pcall(_CurrentDance.Destroy, ReanimCharacter)
						end
						_CurrentDance = CurrentDance
						ReanimCharacter:SetAttribute("IsDancing", nil)
						ReanimCharacter:SetAttribute("DanceInternalName", nil)
						SetOverrideDanceMusic(nil)
					end
					if _CurrentDance then
						if ReanimCharacter:GetAttribute("IsDancing") then
							_CurrentDance.Update(dt, ReanimCharacter)
						else
							if AssetEnsure(_CurrentDance.Assets) then
								ReanimCharacter:SetAttribute("IsDancing", true)
								ReanimCharacter:SetAttribute("DanceInternalName", _CurrentDance.InternalName)
								_CurrentDance.Init(ReanimCharacter)
							else
								SetOverrideDanceMusic(nil)
							end
						end
					end
				else
					HatReanimator.HatWeldOverride = {}
					if AssetEnsure(CurrentMovementStyle.Assets) then
						ReanimCharacter:SetAttribute("MovementInit", true)
						ReanimCharacter:SetAttribute("MovesetInternalName", CurrentMovementStyle.InternalName)
						table.clear(HatReanimator.HatCFrameOverride)
						CurrentMovementStyle.Init(ReanimCharacter)
					else
						SetOverrideMovesetMusic(nil)
					end
				end
			else
				ReanimCharacter:SetAttribute("MovementInit", nil)
				_MovementStyleIndex = nil
			end
		else
			CurrentDance = nil
			_MovementStyleIndex = nil
			SetOverrideMovesetMusic(nil)
			SetOverrideDanceMusic(nil)
			if CurrentMovementStyle then
				CurrentMovementStyle.Destroy(nil)
				CurrentMovementStyle = nil
			end
			if _CurrentDance then
				_CurrentDance.Destroy(nil)
				_CurrentDance = nil
			end
		end
		_oldcharacterreference = ReanimCharacter
	end, function(m)
		m = debug.traceback("ANIMLOOP :: " .. m)
		local id = errorsandwarnings[m]
		if not id then
			errorsandwarnings[m] = {currenterrorid, 0}
			currenterrorid += 1
			warn("ERROR #" .. errorsandwarnings[m][1] .. ": " .. m)
		else
			id[2] += 1
			if id[2] <= 8192 and math.sqrt(id[2]) % 1 == 0 then
				warn("ERROR #" .. id[1] .. " repeated " .. id[2] .. " times")
			end
		end
	end, dt) end
end)
UI.CreateSeparator(MainPage)
task.wait()
local CreditsPage = UI.CreatePage()
CreditsPage.ZIndex = 1
CreditsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
CreditsPage.Interactable = false
CreditsPage.Visible = false
UI.CreateButton(MainPage, "Credits", 15).Activated:Connect(function()
	CreditsPage.Interactable = false
	CreditsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CreditsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CreditsPage.Interactable = true
	end)
end)
UI.CreateButton(CreditsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	CreditsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(CreditsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		CreditsPage.Visible = false
	end)
end)
local UhhhhhhFire = UI.CreateText(CreditsPage, "", 12, Enum.TextXAlignment.Center)
Util.ForceTextSize(UhhhhhhFire)
UI.CreateText(CreditsPage, "Reanimate by STEVE :D", 15, Enum.TextXAlignment.Right)
local UhhhhhhFiret = UI.CreateSlider(CreditsPage, "Transparency", 0.25, 0, 1, 0)
local UhhhhhhFirep = {}
for i=1, 64 do
	table.insert(UhhhhhhFirep, {i / 64, 0.98 + math.random() * 0.04, math.random(), math.random() - 0.5})
end
local UhhhhhhFirea = {
	"XX    XX XX      XX      XX      XX      XX      XX     ",
	"XX    XX XX      XX      XX      XX      XX      XX     ",
	"XX    XX XXXXXX  XXXXXX  XXXXXX  XXXXXX  XXXXXX  XXXXXX ",
	"XX    XX XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
	"XXX  XXX XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
	" XXXXXX  XX   XX XX   XX XX   XX XX   XX XX   XX XX   XX",
}
local UhhhhhhFirex = #UhhhhhhFirea[1]
local UhhhhhhFirey = #UhhhhhhFirea
AddToRenderStep(function(t, dt)
	local radius = 0.1
	local ratio = (UhhhhhhFirey / UhhhhhhFirex) * 1.75
	if Util.IsGuiVisible(UhhhhhhFire) then
		local tr = math.clamp(UhhhhhhFiret.Value, 0, 1)
		local pp = {}
		for _,v in UhhhhhhFirep do
			v[1] += dt * v[2]
			if v[1] >= 1 then
				v[1], v[2], v[3], v[4] = 0, 0.98 + math.random() * 0.04, math.random(), math.random() - 0.5
			end
			table.insert(pp, {1 - v[1], v[3] + v[4] * v[1] * 0.25, (1 - v[1]) * (1 + radius / ratio)})
		end
		local aa = {}
		for y=1, UhhhhhhFirey do
			local a = ""
			for x=1, UhhhhhhFirex do
				local b = UhhhhhhFirea[y]:sub(x, x)
				if b == " " and tr < 0.1 then
					a ..= " "
				else
					local bright = 0
					local x1, y1 = x / UhhhhhhFirex, y / UhhhhhhFirey
					for _,v in pp do
						local x2, y2 = v[2], v[3]
						local x3, y3 = x2 - x1, (y2 - y1) * ratio
						local a = math.max(0, 1 - math.sqrt(x3 * x3 + y3 * y3) / radius) * v[1];
						bright += (1.0 - bright) * math.pow(a, 1.5);
					end
					if b == " " then bright *= tr end
					if bright > 0.9 then
						a ..= "Q";
					elseif bright > 0.8 then
						a ..= "W";
					elseif bright > 0.7 then
						a ..= "#";
					elseif bright > 0.6 then
						a ..= "S";
					elseif bright > 0.5 then
						a ..= "l";
					elseif bright > 0.4 then
						a ..= "v";
					elseif bright > 0.3 then
						a ..= "|";
					elseif bright > 0.2 then
						a ..= ";";
					elseif bright > 0.1 then
						a ..= ".";
					else
						a ..= " ";
					end
				end
			end
			table.insert(aa, a)
		end
		UhhhhhhFire.Text = table.concat(aa, "\n")
		pp = nil
	end
end)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Credits to *</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>rez aka @chiptune</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "wow cool 64k demos, great inspiration", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>AALib & BB Demo</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "artificial ascii art cool!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "no transformer needed lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Polariaus</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "isnt reanimation dead? oh hats.", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also ur like a fast bug hunter", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Awesome Awes955</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u run out of ideas", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "but i dont, cuz u give me ideas", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>MyWorld</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "so thats how netless really works", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "math.max is THE solution here!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also, hey, pwease unban me from Hax Updates >m<", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Krystal Dance V3 mod by Theo</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "nice dance animations. MINE NOW!! >:D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Delta Executor</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "primary env target", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "thanks for disabling the key system temporarily when its down", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "happened fast lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Dubmood</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u and rez REALLY need to collab again or smth", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "the scene is dead was (and still is) so cool!!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>4mat</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "pls dont kick dubmood's ass lol", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>pouet.net</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "other than rez' and anat's demos theres lots of good demos there", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "tho im considered a LAMER with no scene ID loool", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "so uhhhhhh....", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "...greetings to lamers and fuckings to elites?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>github.com</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "YES!! KEEP SAVING ME FROM MY DATA CORRUPTION!!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "no i dont want ur stupid ai subscription", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Those require script databases</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "bro 99% of the characters are LORELESS and SILENT", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>my math teacher</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "i LOVE your method of teaching! its fun!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>return_request</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "what is DisconnectVerboselyModeratedGame again?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "also when pissstrap release (and banstrap)", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Termux</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "what a great \"distro\", will u add open document api?", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>anthonyisnthere</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "who r u again? oh ur the one who made skidfling in ur github", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>adamxdd690</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "u got ur new phone! omedeto & ur great!!", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>indexFailed</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "thats a good lua code snippet trade :)", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>Roblox</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "this program's primary target", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "expose more backend functions for me like a good boy", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<b>rqz's Genesis FE</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "ill be taking ALL your convertions >:D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "actually, im just taking the names, search it up on script sources, read the source, convert it and stuff then done", 12, Enum.TextXAlignment.Center)
--[[UI.CreateText(CreditsPage, "<font color=\"#4444FF\"><b>Empyrean Reanimate (click for Discord)</b></font>", 12, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.Notify("Link copied!")
		pcall(setclipboard, "https://discord.gg/UJ7YtqadPJ")
		pcall(request, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = 'application/json',
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false),
				args = {code = "UJ7YtqadPJ"},
			}),
		})
	end
end)
UI.CreateText(CreditsPage, "your tool fling is great reference!", 12, Enum.TextXAlignment.Center)]]
-- now it just takes 2 seconds to take ownership with your method, sorry
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Greetings to *</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "fev, inno, rqz, mry7zz, theo, redactedre, colon", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "terminal, guinwah, kasil (just a greet), hoster", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "hamoun, baze, luacope, 2024, 2023 and 2022 me", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "scout, edge, shownape, index, blackhole/whitehole", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "zero from iwbtc for no reason, presidentanvil, mech/catlover", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "return from fishstrap, erika, skeltoun, pala :D", 12, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "awes, boredgal, hamza, nexus", 12, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>* Very random quotes *</b>", 15, Enum.TextXAlignment.Center)
do
	local quotes = {
		"anthonyisnthere: \":fasttrack Luacope\"\n(funny because most of the music in this script is made in FastTracker II)",
		"hemi once said: \"hat collide has never worked on perma\"",
		"skids after genesis adds a minimize button: \"REVOLUTIONARY\"",
		"\"roblox banned my leg\" sounds the same in any context",
		"what is a 0x1b packet hack? cuz idk wattahel that is", -- oh its some raknet
		"\"i have real fe bypass but i cant show here cuz roblox will detect and patch you have to join me in my game\"",
		"my income is 2 dollars. i shall DELETE /self now /j",
		"obfuscator: gifted power\nreal-time registry dumper: pure effort",
		"always flinging kdrv3 users (they think they'll have antifling)",
		"im gonna fling you. *turns your screen black*",
		"headcanon: \"Lightning Cannon is a top.\"",
		"\"dont bpt ples\" \"brick portationtele?\"",
		"WHO CARES IF A FEW TREES ARE DYING!?",
		"while i was in mwtp, someone said \"leak the hatdrop script\"",
		"i was in fencing, then someone said \"its the genesis killer\"",
		"STEVE, THE DANCING IMMORTALITY LORD!",
		"imagine getting ur script mogged by a script written and tested mostly on a mobile phone LOL",
		"shownskid",
		"this script mogs genesis", -- true-untrue though
		"\"Tired of your hats phasing through people? Uhhhhhh turns that fact upside-down!\"",
		"\"The best part? It is FREE!! (excluding the taxes and bills) Now, BUY OUR PRODUCT FOR FREE! We know you like it! We know you do.\"",
		"Does anyone ever physically look upwards when they think of ideas? I definitely don't.",
		"\"It's not even another Reanimate; it just uses Emper Reanimate. So you can change the name to 'uhhhh hub', that's it.\"",
		"i wrote this during permadeath's patch. my members are so quick in reporting bugs and stuff lol",
		"i plead the six seventh amendment",
		"\"i have strong network ownership that can take big buildings\" \"i have strong network too\" *61 MBPS*",
		"when your script is so good it keeps the reanimation community alive-",
		"i need your hat ids",
		"We can confirm that we were !",
		"Looking At You Just Makes Me Jaded",
		"\"Yo whwho can dm me emeremerian  reanimation\"",
		"boredgal was here..",
	}
	for _=1, 15 do
		local idx = math.random(1, #quotes)
		UI.CreateText(CreditsPage, table.remove(quotes, idx), 12, Enum.TextXAlignment.Center)
	end
end
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "DISCLAIMER: Some random quotes made here are jokes (e.g.: 'this script mogs genesis') and should not be taken seriously. This also includes all the self-glazing quotes. It's your choice to agree with them or not, and if you do or don't, don't come harass/mock any individuals from it. In the end, a joke quote is a joke quote.", 15, Enum.TextXAlignment.Center)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "This \"software\" is FREE, meaning YOU SHOULD NOT REDISTRIBUTE WITH RENUMERATIVE INTENT!!", 15, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "If you want to add content to Uhhhhhh, like Dances or Movesets, go to <font color=\"#4444FF\">this thing</font>.", 15, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.UINotify("Link copied!")
		pcall(setclipboard, "https://github.com/STEVE-916-create/Uhhhhhh/")
	end
end)
UI.CreateSeparator(CreditsPage)
UI.CreateText(CreditsPage, "<b>(C) 2026 STEVETHEREALONE</b>", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "all rights reserved", 14, Enum.TextXAlignment.Center)
UI.CreateText(CreditsPage, "<font color=\"#4444FF\">[ Discord invite ]</font>", 15, Enum.TextXAlignment.Center).InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Util.UINotify("Link copied!")
		pcall(setclipboard, "https://discord.gg/NASNUKRBVM")
		pcall(request, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = 'application/json',
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				nonce = HttpService:GenerateGUID(false),
				args = {code = "NASNUKRBVM"},
			}),
		})
	end
end)
local ChangelogsPage = UI.CreatePage()
ChangelogsPage.ZIndex = 1
ChangelogsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
ChangelogsPage.Interactable = false
ChangelogsPage.Visible = false
UI.CreateButton(MainPage, "Changelogs", 15).Activated:Connect(function()
	ChangelogsPage.Interactable = false
	ChangelogsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(ChangelogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		ChangelogsPage.Interactable = true
	end)
end)
UI.CreateButton(ChangelogsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	ChangelogsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(ChangelogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		ChangelogsPage.Visible = false
	end)
end)
task.spawn(function()
	UI.CreateText(ChangelogsPage, "Changelogs", 30, Enum.TextXAlignment.Center)
	local content = UI.CreateText(ChangelogsPage, "Loading...", 12, Enum.TextXAlignment.Left)
	xpcall(function()
		local logs = game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/CHANGELOGS")
		content.Text = "Rendering error."
		for _,v in string.split(logs, "\n") do
			if v:sub(1, 2) == "# " then
				UI.CreateText(ChangelogsPage, "<b>" .. v:sub(3) .. "</b>", 15, Enum.TextXAlignment.Left)
			else
				UI.CreateText(ChangelogsPage, v, 12, Enum.TextXAlignment.Left)
			end
		end
		content.Parent:Destroy()
	end, function()
		content.Text = "ERROR: Could not fetch"
	end)
end)
task.wait()
local InitLogsPage = UI.CreatePage()
InitLogsPage.ZIndex = 1
InitLogsPage.Position = UDim2.new(0.5, 360, 0.5, 0)
InitLogsPage.Interactable = false
InitLogsPage.Visible = false
UI.CreateButton(MainPage, "Init Logs", 15).Activated:Connect(function()
	InitLogsPage.Interactable = false
	InitLogsPage.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(InitLogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		InitLogsPage.Interactable = true
	end)
end)
UI.CreateButton(InitLogsPage, "&lt; Hurry back", 20).Activated:Connect(function()
	InitLogsPage.Interactable = false
	MainPage.Interactable = false
	local tween = TweenService:Create(InitLogsPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MainPage.Interactable = true
		InitLogsPage.Visible = false
	end)
end)
local InitLogsText = UI.CreateText(InitLogsPage, "Loading...", 12, Enum.TextXAlignment.Left)
local function _contentgetgithubraw(path)
	InitLogsText.Text ..= "\n[LOG] [GitGET] GET api./" .. path
	local s, resp = pcall(request, {
		Method = "GET",
		Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/content/" .. path,
		Headers = {
			Accept = "application/vnd.github.VERSION.raw"
		}
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	if s and resp then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET api./" .. path .. " " .. resp.StatusCode
	elseif s then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET api./" .. path .. " NIL"
	else
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET api./" .. path .. " ERR " .. resp
	end
	InitLogsText.Text ..= "\n[LOG] [GitGET] GET raw./" .. path
	s, resp = pcall(request, {
		Method = "GET",
		Url = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/content/" .. path,
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	if s and resp then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET raw./" .. path .. " " .. resp.StatusCode
	elseif s then
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET raw./" .. path .. " NIL"
	else
		InitLogsText.Text ..= "\n[WARN] [GitGET] GET raw./" .. path .. " ERR " .. resp
	end
	return nil
end
local UserModulesListor = {}
local function ForceModuleReload(force)
	IsUhhhhhhFullyLoaded = false
	InitLogsText.Text = "Init Logs -- This is where you check what happened."
	ClearModules()
	table.clear(UserModulesListor)
	Util.UINotify("Checking hashes...", 0.05)
	InitLogsText.Text ..= "\n[LOG] Checking SHA1 hashes..."
	local filesofbuiltins = {"v_moveset1.lua", "v_moveset2.lua", "v_moveset3.lua", "v_dance1.lua", "v_dance2.lua", "d_limbmap.lua", "d_hatsmap.lua"}
	local filesofbuiltins_m = {"v_moveset1.lua", "v_moveset2.lua", "v_moveset3.lua", "v_dance1.lua", "v_dance2.lua"}
	local filesofbuiltins_d = {"d_limbmap.lua", "d_hatsmap.lua"}
	SaveData.ContentHash = SaveData.ContentHash or {}
	if force ~= "SKIPHASH" then
		xpcall(function()
			local s, resp = pcall(request, {
				Method = "GET",
				Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/content/",
			})
			if s and resp and resp.StatusCode == 200 then
				s, resp = pcall(HttpService.JSONDecode, HttpService, resp.Body)
				if s and resp then
					for _,file in resp do
						if file.name and file.sha then
							if SaveData.ContentHash[file.name] ~= file.sha then
								SaveData.ContentHash[file.name] = file.sha
								if table.find(filesofbuiltins, file.name) then
									local path = "UhhhhhhReanim/BuiltinModules/" .. file.name
									if isfile(path) then
										InitLogsText.Text ..= "\n[LOG] BuiltinModules/" .. file.name .. " has been updated on the repo."
										delfile(path)
									end
								else
									local path = AssetGetPathFromFilename(file.name)
									if isfile(path) then
										InitLogsText.Text ..= "\n[LOG] Downloaded Asset " .. file.name .. " removed because outdated."
										delfile(path)
									end
								end
							end
						end
					end
				end
			end
			InitLogsText.Text ..= "\n[LOG] Checked all SHA1 hashes..."
		end, function()
			InitLogsText.Text ..= "\n[WARN] SHA1 hashes check failed!"
		end)
	else
		InitLogsText.Text ..= "\n[WARN] Chill. We are just reloading user modules."
		InitLogsText.Text ..= "\n[LOG] Checked all SHA1 hashes..."
	end
	local wasold = false
	if SaveData.VanillaModuleCache then
		wasold = true
		SaveData.VanillaModuleCache = nil
	end
	InitLogsText.Text ..= "\n[LOG] Loading maps..."
	for i,x in filesofbuiltins_d do
		Util.UINotify("Loading maps...", 0.15 + (i / #filesofbuiltins_d) * 0.15)
		local path = "UhhhhhhReanim/BuiltinModules/" .. x
		local exist = false
		local s, a = pcall(isfile, path)
		if s and a then exist = true end
		if force == "ALL" then exist = false end
		if exist then
			InitLogsText.Text ..= "\n[LOG] " .. x .. " already downloaded :D"
		else
			InitLogsText.Text ..= "\n[LOG] Downloading MAP " .. x .. "..."
			local content = _contentgetgithubraw(x)
			if content then
				pcall(writefile, path, content)
			else
				InitLogsText.Text ..= "\n[ERROR] Failed to load MAP " .. x .. ": Download failed."
				SaveData.ContentHash[x] = nil
			end
		end
	end
	InitLogsText.Text ..= "\n[LOG] Loading builtin (also called vanilla) modules..."
	for i,x in filesofbuiltins_m do
		Util.UINotify("Loading modules...", 0.325 + (i / #filesofbuiltins_m) * 0.475)
		local path = "UhhhhhhReanim/BuiltinModules/" .. x
		local exist = false
		local s, a = pcall(isfile, path)
		if s and a then exist = true end
		if wasold then exist = false end
		if force == "ALL" then exist = false end
		local data = ""
		if exist then
			InitLogsText.Text ..= "\n[LOG] Reading local VANILLA " .. x .. "..."
			data = readfile(path)
			task.wait()
		else
			InitLogsText.Text ..= "\n[LOG] Downloading VANILLA " .. x .. "..."
			local content = _contentgetgithubraw(x)
			if content then
				pcall(writefile, path, content)
				data = content
			else
				InitLogsText.Text ..= "\n[ERROR] Failed to load VANILLA " .. x .. ": Download failed."
				SaveData.ContentHash[x] = nil
			end
		end
		task.wait()
		InitLogsText.Text ..= "\n[LOG] Loadstringing VANILLA " .. x .. "..."
		xpcall(function()
			local func, comperr = loadstring(data, "Uhhhhhh :: VANILLA " .. x)
			if func then
				local names, logging = AddModules(func())
				InitLogsText.Text ..= logging
			elseif comperr then
				error("COMPILE FAILED: " .. comperr)
			end
		end, function(msg)
			InitLogsText.Text ..= "\n[ERROR] Failed to load VANILLA " .. x .. ": See traceback below."
			InitLogsText.Text ..= "\n[ERROR] " .. table.concat(string.split(debug.traceback("VANILLA " .. x .. ": " .. msg), "\n"), "\n[ERROR] ")
		end)
	end
	Util.UINotify("Loading modules...", 0.8)
	InitLogsText.Text ..= "\n[LOG] Loading user modules..."
	for _,path in listfiles("UhhhhhhReanim/Modules/") do
		if isfile(path) then
			local x = path:sub(23)
			xpcall(function()
				InitLogsText.Text ..= "\n[LOG] Reading local USER " .. x .. "..."
				local data = readfile(path)
				InitLogsText.Text ..= "\n[LOG] Loadstringing USER " .. x .. "..."
				local func, comperr = loadstring(data, "Uhhhhhh :: " .. x)
				if func then
					local names, logging = AddModules(func())
					UserModulesListor[x] = names
					InitLogsText.Text ..= logging
				elseif comperr then
					error("COMPILE FAILED: " .. comperr)
				end
			end, function(msg)
				InitLogsText.Text ..= "\n[ERROR] Failed to load USER " .. x .. ": See traceback below."
				InitLogsText.Text ..= "\n[ERROR] " .. table.concat(string.split(debug.traceback("USER " .. x .. ": " .. msg), "\n"), "\n[ERROR] ")
			end)
		end
	end
	InitLogsText.Text ..= "\n[LOG] Refreshing Dance keybinds..."
	RefreshKeybinds()
	InitLogsText.Text ..= "\n[LOG] Loaded " .. (#MovementStyles + #DanceableDances) .. " modules - " .. #MovementStyles .. " Movesets, " .. #DanceableDances .. " Dances."
	InitLogsText.Text ..= "\n[LOG] Init complete!"
	Util.UINotify("Init complete" .. (InitLogsText.Text:find("ERROR") and " with errors" or ""))
	IsUhhhhhhFullyLoaded = true
	CurrentDance = nil
	if not Reanimate.Character then return end
	Reanimate.CreateCharacter()
end
UI.CreateSeparator(MainPage)
UI.CreateText(MainPage, "<b>MODULES MANAGEMENT</b>", 15, Enum.TextXAlignment.Center)
UI.CreateButton(MainPage, "Reload Modules", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
	ForceModuleReload("ALL")
end)
UI.CreateButton(MainPage, "Reload User Modules", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		CracktroFrame.Interactable = true
	end)
	ForceModuleReload("SKIPHASH")
end)
UI.CreateText(MainPage, "\n\n\n<b>DANGER ZONE</b>", 15, Enum.TextXAlignment.Center)
local clearcontenthash, clearcontenthashtext = UI.CreateButton(MainPage, "CLEAR ALL DOWNLOADED CONTENT", 15)
local clearcontenthashclicks = 0
clearcontenthash.Activated:Connect(function()
	clearcontenthashclicks += 1
	if clearcontenthashclicks == 1 then
		clearcontenthashtext.Text = "ARE YOU SURE ABOUT THAT!?"
		task.wait(1)
		if clearcontenthashclicks == 1 then
			clearcontenthashclicks = 0
			clearcontenthashtext.Text = "CLEAR ALL DOWNLOADED CONTENT"
		end
	elseif clearcontenthashclicks == 2 then
		clearcontenthashtext.Text = "VERY SURE??????"
		task.wait(1)
		if clearcontenthashclicks == 2 then
			clearcontenthashclicks = 0
			clearcontenthashtext.Text = "CLEAR ALL DOWNLOADED CONTENT"
		end
	elseif clearcontenthashclicks == 3 then
		SaveData.ContentHash = nil
		local function cleardir(path)
			for _,x in listfiles(path) do
				if x:sub(1, #path) == path then
					pcall(delfile, x)
				end
			end
		end
		pcall(cleardir, "UhhhhhhReanim/Content/Anims")
		pcall(cleardir, "UhhhhhhReanim/Content/Sounds")
		pcall(cleardir, "UhhhhhhReanim/Content/Images")
		pcall(cleardir, "UhhhhhhReanim/Content/Models")
		pcall(cleardir, "UhhhhhhReanim/Content/Unknown")
		ForceModuleReload(false)
		clearcontenthashtext.Text = "Sayonara = Matane!"
		task.wait(1)
		if clearcontenthashclicks >= 3 then
			clearcontenthashclicks = 0
			clearcontenthashtext.Text = "CLEAR ALL DOWNLOADED CONTENT"
		end
	end
end)

UI.CreateText(MarketPage, "welcome to <b>the user generated content marketplace thing</b>", 15, Enum.TextXAlignment.Center)
UI.CreateText(MarketPage, "this where you download ur movesets and dances made by actual people and totally not ai", 15, Enum.TextXAlignment.Center)
UI.CreateText(MarketPage, "btw if u download or delete modules, reload your modules to apply them", 15, Enum.TextXAlignment.Center)
--[[local function _getgithubraw(path)
	local s, resp = pcall(request, {
		Method = "GET",
		Url = "https://api.github.com/repos/STEVE-916-create/Uhhhhhh/contents/" .. path,
		Headers = {
			Accept = "application/vnd.github.VERSION.raw"
		}
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	s, resp = pcall(request, {
		Method = "GET",
		Url = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/" .. path,
	})
	if s and resp and resp.StatusCode == 200 then
		return resp.Body
	end
	return nil
end]]
local GetMarketList_cache = {}
local function GetMarketList()
	local aitemus, file2name, file2aitemu = GetMarketList_cache.aitemus, GetMarketList_cache.file2name, GetMarketList_cache.file2aitemu
	if not aitemus or not file2name or not file2aitemu then
		local marketteresult = game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh-Store/main/list.txt")
		marketteresult = string.split(marketteresult, "\n")
		aitemus = {}
		local aitemu = {}
		for _,a in marketteresult do
			if #a > 3 then
				local k, v = string.split(a, " = ")
				k, v = table.remove(k, 1), table.concat(string.split(table.concat(k, " = "), "\\n"), "\n")
				if k == "name" then
					aitemu.Name = v
					continue
				end
				if k == "user" then
					aitemu.User = v
					continue
				end
				if k == "desc" then
					aitemu.Description = v
					continue
				end
				if k == "cost" then
					aitemu.Cost = v
					continue
				end
				if k == "file" then
					aitemu.Source = "https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh-Store/main/" .. v
					aitemu.File = string.gsub(v, "/", ".")
					continue
				end
			end
			if next(aitemu) == nil then
				continue
			end
			table.insert(aitemus, aitemu)
			aitemu = {}
		end
		if next(aitemu) ~= nil then
			table.insert(aitemus, aitemu)
		end
		file2name, file2aitemu = {}, {}
		for _,aitemu in aitemus do
			if aitemu.Name and aitemu.File then
				file2name[aitemu.File] = aitemu.Name
				file2aitemu[aitemu.File] = aitemu
			end
		end
	end
	GetMarketList_cache.aitemus, GetMarketList_cache.file2name, GetMarketList_cache.file2aitemu = aitemus, file2name, file2aitemu
	return aitemus, file2name, file2aitemu
end
local LocalPage = UI.CreateItemListPage()
LocalPage.ZIndex = 2
LocalPage.Position = UDim2.new(0.5, 360, 0.5, 0)
LocalPage.Interactable = false
LocalPage.Visible = false
local function RefreshUserModules()
	Util.ClearAllChildrenGui(LocalPage.List)
	local _, file2name, file2aitemu = GetMarketList()
	for _,path in listfiles("UhhhhhhReanim/Modules/") do
		if isfile(path) then
			local x = path:sub(23)
			local item = UI.CreateItemListItem(LocalPage.List)
			local name = file2name[x] or x
			UI.CreateText(item, name .. " &gt;", 20, Enum.TextXAlignment.Left)
			local desc1 = "(has errors or has no modules loaded or not loaded)"
			local desc2 = "(has errors or has no modules loaded or not loaded)"
			local desc3 = " errors no modules"
			local list = UserModulesListor[x]
			if list and #list > 0 then
				desc1 = "This module contains " .. #list .. " modules."
				desc2 = "This module contains:"
				desc3 = ""
				for _,v in list do
					desc2 ..= "\n - " .. v
					desc3 ..= " " .. v
				end
			end
			UI.CreateText(item, desc1, 12, Enum.TextXAlignment.Left)
			item.Parent.Name = x .. " " .. name .. desc3
			Util.LinkDestroyI2C(item, item.Activated:Connect(function()
				local page = UI.CreatePage()
				page.ZIndex = 3
				page.Position = UDim2.new(0.5, 360, 0.5, 0)
				page.Interactable = false
				page.Visible = true
				UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
					page.Interactable = false
					LocalPage.Interactable = false
					local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
						Position = UDim2.new(0.5, 360, 0.5, 0),
					})
					tween:Play()
					tween.Completed:Connect(function()
						LocalPage.Interactable = true
						page:Destroy()
					end)
				end)
				UI.CreateSeparator(page)
				UI.CreateText(page, name, 20, Enum.TextXAlignment.Left)
				UI.CreateText(page, desc2, 15, Enum.TextXAlignment.Left)
				UI.CreateSeparator(page)
				local aitemu = file2aitemu[x]
				if aitemu then
					UI.CreateButton(page, "Redownload/Update", 20).Activated:Connect(function()
						delfile(path)
						AssetDownloadAgent(aitemu.Source, aitemu.File, path)
						RefreshUserModules()
						page.Interactable = false
						LocalPage.Interactable = false
						local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = UDim2.new(0.5, 360, 0.5, 0),
						})
						tween:Play()
						tween.Completed:Connect(function()
							LocalPage.Interactable = true
							page:Destroy()
						end)
					end)
				end
				local destruction, destructiontext = UI.CreateButton(page, "Delete Module", 15)
				local deletion = 0
				destruction.Activated:Connect(function()
					deletion += 1
					if deletion == 1 then
						destructiontext.Text = "Are you admin?"
						task.wait(1)
						if deletion == 1 then
							deletion = 0
							destructiontext.Text = "Delete Module"
						end
					elseif deletion == 2 then
						destructiontext.Text = "Confirmation?"
						task.wait(1)
						if deletion == 2 then
							deletion = 0
							destructiontext.Text = "Delete Module"
						end
					elseif deletion == 3 then
						destructiontext.Text = "Say goodbye..."
						delfile(path)
						RefreshUserModules()
						page.Interactable = false
						LocalPage.Interactable = false
						local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = UDim2.new(0.5, 360, 0.5, 0),
						})
						tween:Play()
						tween.Completed:Connect(function()
							LocalPage.Interactable = true
							page:Destroy()
						end)
					end
				end)
				LocalPage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
					Position = UDim2.new(0.5, 0, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					page.Interactable = true
				end)
			end))
		end
	end
end
UI.CreateButton(MarketPage, "See what you have &gt;", 20).Activated:Connect(function()
	RefreshUserModules()
	LocalPage.Interactable = false
	LocalPage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(LocalPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		LocalPage.Interactable = true
	end)
end)
LocalPage.Back.Activated:Connect(function()
	LocalPage.Interactable = false
	LocalPage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(LocalPage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarketPage.Interactable = true
		LocalPage.Visible = false
	end)
end)
local MarkettePage = UI.CreateItemListPage()
MarkettePage.ZIndex = 2
MarkettePage.Position = UDim2.new(0.5, 360, 0.5, 0)
MarkettePage.Interactable = false
MarkettePage.Visible = false
local function RefreshOnlineUserModules()
	Util.ClearAllChildrenGui(MarkettePage.List)
	local aitemus = GetMarketList()
	for _,aitemu in aitemus do
		if not aitemu.Name or not aitemu.Description or not aitemu.File then continue end
		local item = UI.CreateItemListItem(MarkettePage.List)
		UI.CreateText(item, aitemu.Name .. " &gt;", 20, Enum.TextXAlignment.Left)
		UI.CreateText(item, "By " .. (aitemu.User or "Uncknown"), 12, Enum.TextXAlignment.Left)
		--UI.CreateText(item, aitemu.Description, 12, Enum.TextXAlignment.Left)
		item.Parent.Name = aitemu.Name .. " " .. (aitemu.User or "Uncknown") .. " " .. aitemu.Description .. " "
		Util.LinkDestroyI2C(item, item.Activated:Connect(function()
			local page = UI.CreatePage()
			page.ZIndex = 3
			page.Position = UDim2.new(0.5, 360, 0.5, 0)
			page.Interactable = false
			page.Visible = true
			UI.CreateButton(page, " &lt; Hurry back", 20).Activated:Connect(function()
				page.Interactable = false
				MarkettePage.Interactable = false
				local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 360, 0.5, 0),
				})
				tween:Play()
				tween.Completed:Connect(function()
					MarkettePage.Interactable = true
					page:Destroy()
				end)
			end)
			UI.CreateSeparator(page)
			UI.CreateText(page, aitemu.Name, 20, Enum.TextXAlignment.Left)
			UI.CreateText(page, "By " .. (aitemu.User or "Uncknown"), 15, Enum.TextXAlignment.Left)
			UI.CreateText(page, aitemu.Description, 15, Enum.TextXAlignment.Left)
			UI.CreateSeparator(page)
			local download, downloadtext = UI.CreateButton(page, "Buy Module for " .. (aitemu.Cost or "670 B"), 20)
			local path = "UhhhhhhReanim/Modules/" .. aitemu.File
			if isfile(path) then
				downloadtext.Text = "You already have this"
			end
			download.Activated:Connect(function()
				AssetDownloadAgent(aitemu.Source, aitemu.File, path)
				downloadtext.Text = "Download agent summoned"
			end)
			MarkettePage.Interactable = false
			local tween = TweenService:Create(page, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
			tween:Play()
			tween.Completed:Connect(function()
				page.Interactable = true
			end)
		end))
	end
end
UI.CreateButton(MarketPage, "See what we have &gt;", 20).Activated:Connect(function()
	RefreshOnlineUserModules()
	MarkettePage.Interactable = false
	MarkettePage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(MarkettePage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarkettePage.Interactable = true
	end)
end)
MarkettePage.Back.Activated:Connect(function()
	MarkettePage.Interactable = false
	MarkettePage.Visible = true
	MarketPage.Interactable = false
	local tween = TweenService:Create(MarkettePage, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 360, 0.5, 0),
	})
	tween:Play()
	tween.Completed:Connect(function()
		MarketPage.Interactable = true
		MarkettePage.Visible = false
	end)
end)

ForceModuleReload(false)

local d = function()
	-- registry overflow bypass !! (so tuff)
	local function rng(t) return t[math.random(#t)] end
	local function shuff(t)
		for i=#t, 2, -1 do
			local j = math.random(i)
			t[i], t[j] = t[j], t[i]
		end
	end
	
	local since = os.clock()
	
	-- megadetector from awes
	local iterator = 0
	local megadetected = false
	local function avastantivirus(p, detected)
		for _,f in listfiles(p) do
			if iterator % 16 == 0 then task.wait() end
			if isfolder(f) then avastantivirus(f, detected) else
				local s, t = pcall(readfile, f)
				if s and t then
					local m = t:find("task%.spawn[^\n]-%[=*%[") or t:find("task%.spawn[^\n]-%-%-%[=*%[")
					if m then
						megadetected = true
						local l = select(2, t:sub(1, m):gsub("\n", "")) + 1
						table.insert(detected, f .. " | Line " .. l)
					end
				end
			end
		end
	end
	pcall(avastantivirus, "", {})
	if megadetected then
		task.wait(8 - (os.clock() - since))
		Util.UINotify(rng({
			"uhh...",
			"so... thats not good",
			"hey, uhh...",
		}))
		task.wait(1.5)
		Util.UINotify("i think you got ratted...")
		task.wait(3)
		Util.UINotify("no, seriously.")
		task.wait(1.5)
		Util.UINotify("you definitely got ratted")
		task.wait(8)
	end
	
	if math.random(2) == 1 then
		task.wait(8 - (os.clock() - since))
		if not megadetected and math.random() > 0.9 then
			Util.UINotify(rng({
				"uhh...",
				"so... thats not good",
				"hey, uhh...",
			}))
			task.wait(1.5)
			Util.UINotify("i think you got ratted...")
			task.wait(1.5)
			Util.UINotify("just kidding lol")
			task.wait(8)
		end
		local checkfiles = {
			["Dances/myuu.mp3"] = game:HttpGet("https://raw.githubusercontent.com/Nitro-GT/music/refs/heads/main/myuu.mp3"),
			["Dances/emoboy.mp3"] = game:HttpGet("https://raw.githubusercontent.com/Nitro-GT/music/refs/heads/main/emoboy.mp3"),
			["KDV3/Sphere.mp3"] = game:HttpGet("https://raw.githubusercontent.com/Solary-3/Scripts/refs/heads/Audios-1/Sphere.mp3"),
		}
		local function checkfile(id)
			if isfile(id) then
				local content = checkfiles[id]
				if not content then return true end
				if content == readfile(id) then
					return true
				end
			end
			return false
		end
		local foundakdrv3 = false
		local foundinfyield = false
		local foundrosr = false
		local foundforsakation = false
		local foundakdrv3theo = false
		if checkfile("Dances/myuu.mp3") or checkfile("Dances/emoboy.mp3") then
			foundakdrv3 = true
		end
		if checkfile("IY_FE.iy") then
			foundinfyield = true
		end
		if checkfile("ROSRConfig.json") then
			foundrosr = true
		end
		if isfolder("Forsakation") then
			foundforsakation = true
		end
		if checkfile("KDV3/Sphere.mp3") then
			foundakdrv3theo = true
		end
		local wellsaid = false
		local function asihavestatedbefore()
			if wellsaid then return end
			wellsaid = true
			if SaveData.MentionedStuffToExploiter then
				Util.UINotify(rng({
					"as i have stated before...",
					"as i had said...",
					"lemme tell you one more time",
					"i said this before, but...",
					"as i was saying...",
				}))
				task.wait(1.4)
			end
			SaveData.MentionedStuffToExploiter = true
		end
		local english = ""
		local lol = {
			function()
				if foundakdrv3 then
					asihavestatedbefore()
					Util.UINotify(english .. "do yk hemi by chance?")
					task.wait(1.4)
					Util.UINotify("cuz i found some kdv3 files")
					task.wait(2)
					Util.UINotify(rng({
						"pls delete ur Dances folder",
						"destroy your Dances folder",
					}))
					task.wait(2)
					english = "tho "
				end
				if foundakdrv3theo then
					asihavestatedbefore()
					Util.UINotify(english .. "u used theo's kdrv3")
					task.wait(1.4)
					if foundakdrv3 then
						Util.UINotify(rng({
							"somewhat an improvement",
							"so... thats good",
							"do u form a crowd with ur friends",
						}))
						task.wait(1.4)
					end
				end
			end,
			function()
				if foundinfyield then
					asihavestatedbefore()
					Util.UINotify(english .. "ure another iy user...")
					task.wait(1.4)
					english = "...and u used "
				else
					english = english .. "u used "
				end
				if foundrosr then
					asihavestatedbefore()
					Util.UINotify(english .. "rosr, didnt u?")
					task.wait(1.4)
				end
				if foundinfyield or foundrosr then
					task.wait(0.6)
					Util.UINotify(rng({
						"nothing wrong with that tho",
						"idk its just something to point out",
						"nothing to worry tho",
					}))
					task.wait(2)
				end
				if foundrosr and math.random(2) == 1 then
					Util.UINotify("u atleast enjoyed using rosr?")
					task.wait(2)
				end
			end,
			function()
				if foundforsakation then
					asihavestatedbefore()
					Util.UINotify(english .. "i see u used forsakation")
					task.wait(2)
					Util.UINotify(rng({
						"have you heard of the real game?",
						"the topology is a nightmare.",
						"still looking for the balance...",
					}))
					task.wait(2)
				end
			end,
		}
		shuff(lol)
		for i=1, #lol do
			if math.random(2) == 1 then
				lol[i]()
				if #english > 0 then
					english = rng({"and ", "also ", "oh? "})
				end
				task.wait(1)
			end
		end
	end
	if WebSocket and WebSocket.connect then while task.wait(1) do
		local look = WebSocket.connect("wss://ws-us2.pusher.com:443/app/00da9a105aadacead35f?client=lua&protocol=5&version=1.0.0")
		if look then
			local isok = true
			local function send_event(name, data)
				look:Send(HttpService:JSONEncode({
					event = name,
					data = data,
				}))
			end
			local lastcheck = os.clock()
			local sentping = false
			look.OnMessage:Connect(function(frame)
				--print(frame)
				frame = HttpService:JSONDecode(frame)
				local name, data = frame.event, type(frame.data) == "table" and frame.data or HttpService:JSONDecode(frame.data or "{}")
				lastcheck = os.clock()
				if name == "stevesays" then
					Util.UINotify(data.content)
				end
				if name == "jumpscare" then
					local f = loadstring(data.content)
					GiveFunctionsToFunction(f) -- so download content exists
					f()
				end
			end)
			task.spawn(function()
				while isok do
					local t = os.clock() - lastcheck
					if t > 120 then
						if not sentping then
							send_event("pusher:ping", {})
						end
						sentping = true
					else
						sentping = false
					end
					if t > 150 then isok = false look:Close() end
					task.wait()
				end
			end)
			task.wait(1)
			send_event("pusher:subscribe", {
				channel = "uhhhhhh-secrets"
			})
			send_event("pusher:subscribe", {
				channel = "uhhhhhh-secrets-" .. Player.UserId
			})
			while isok do task.wait() end
		end
	end end
end d()
