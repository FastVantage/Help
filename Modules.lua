local module = {}

--sci proximity

function module.enable(loc)
	if loc == nil then
		for _,v in pairs(workspace.selfCheckIns:GetChildren()) do
			v.sciAssets.ProximityPrompt.ProximityPrompt.Enabled = true
		end
	else
		loc.Enabled = true
	end
end

function module.disable(loc)
	if loc == nil then
		for _,v in pairs(workspace.selfCheckIns:GetChildren()) do
			v.sciAssets.ProximityPrompt.ProximityPrompt.Enabled = false
		end
	else
		loc.Enabled = false
	end
end

-- dep boards

local GatesFolder = game.Workspace:WaitForChild('Gates')

local Screens = game.Workspace:WaitForChild('Screens')
local Core = game.ReplicatedStorage:WaitForChild('C')
local Settings = require(Core.Settings)
local Colour = {
	['Green'] = Color3.fromRGB(55, 255, 0),
	['Red'] = Color3.fromRGB(255, 0, 4),
}


local EasyJet_dests = {"Amsterdam", "Alicante", "Athens", "Barcelona", "Belfast", "Edinburgh", "Geneva", "Malaga", "Nice", "Paris", "Rome", "Tenerife"}
local KLM_dests = {"Amsterdam"}
local TUI_dests = {"Antalya", "Corfu", "Lanzarote", "Majorca", "Rhodes", "Skiathos"}
local Ryanair_dests = {"Dublin", "Krakow", "Lisbon", "Milan", "Porto", "Valencia"}
local Jet2_dests = {"Faro", "Funchal", "Heraklion", "Ibiza", "Paphos", "Verona"}

local IATA = {"EZY", "KL", "TOM", "FR", "LS"}
local Logos = {
	"http://www.roblox.com/asset/?id=79245674947074",
	"http://www.roblox.com/asset/?id=77735095106142",
	"http://www.roblox.com/asset/?id=126580300092401",
	"http://www.roblox.com/asset/?id=108235369069423",
	"http://www.roblox.com/asset/?id=133031643081958"
}
local Checkins = {"1-15", "16-17", "25-32", "33-37", "39-48"}

local Colour = {
	["Green"] = Color3.fromRGB(55, 255, 0),
	["Red"] = Color3.fromRGB(255, 0, 4),
}

local LASTTIME = 0

local function getRandomDestinationForAirline(airline)
	if airline == "EZY" then
		return EasyJet_dests[math.random(#EasyJet_dests)]
	elseif airline == "KL" then
		return KLM_dests[math.random(#KLM_dests)]
	elseif airline == "TOM" then
		return TUI_dests[math.random(#TUI_dests)]
	elseif airline == "FR" then
		return Ryanair_dests[math.random(#Ryanair_dests)]
	elseif airline == "LS" then
		return Jet2_dests[math.random(#Jet2_dests)]
	end
end

--EasyJet 1-15
--KLM 16-17
--TUI 25-32
--Ryanair 33-37
--Jet2 39-48

local function display(Num)
	-- Airline selection with adjusted weightings
	local AL = math.random(1, 100) -- Scale of 1-100

	if AL <= 70 then
		AL = 1 -- EasyJet: 70%
	elseif AL <= 90 then
		AL = 4 -- Ryanair: 20%
	elseif AL <= 95 then
		AL = 5 -- Jet2: 5%
	elseif AL <= 99 then
		AL = 3 -- TUI: 4%
	else
		AL = 2 -- KLM: 1%
	end

	local CI = math.random(1, 5)
	local one = math.random(0, 2)
	local two = math.random(0, 9)
	local three = math.random(0, 9)
	local four = math.random(0, 9)

	local airlineIATA = IATA[AL]
	local destination = getRandomDestinationForAirline(airlineIATA)

	-- Parse LASTTIME and increment by 5 minutes
	local part1 = tonumber(string.sub(LASTTIME, 1, 2)) or 0
	local part2 = tonumber(string.sub(LASTTIME, 4, 5)) or 0

	-- Ensure the time is snapped to the nearest 5 minutes
	part2 = math.floor(part2 / 5) * 5
	part2 = part2 + 5
	if part2 >= 60 then
		part2 = 0
		part1 = part1 + 1
	end
	if part1 >= 24 then
		part1 = 0
	end

	-- Update LASTTIME for the next call
	LASTTIME = string.format("%02d:%02d", part1, part2)
	local STD = LASTTIME

	-- Calculate "Gate info at" time (1 hour and 10 minutes before STD)
	local gateInfoHour = part1 - 1
	local gateInfoMinute = part2 - 10
	if gateInfoMinute < 0 then
		gateInfoMinute = gateInfoMinute + 60
		gateInfoHour = gateInfoHour - 1
	end
	if gateInfoHour < 0 then
		gateInfoHour = gateInfoHour + 24
	end

	-- Snap "Gate info at" time to the nearest 5 minutes
	gateInfoMinute = math.floor(gateInfoMinute / 5) * 5
	local gateInfoTime = string.format("%02d:%02d", gateInfoHour, gateInfoMinute)

	-- Status and color logic
	local Status = ""
	local bgColour = Color3.fromRGB(40, 57, 148)
	local Gate = ""
	local st = math.random(1, 8) -- Likelihood of "Go to gate"
	local randomgate = math.random(1, 34)

	if Num <= st then
		Status = "Go to gate " .. randomgate
		bgColour = Color3.fromRGB(0, 101, 25)
	end

	local delay = math.random(1, 100)
	if delay >= 70 then
		Status = "Delayed"
		bgColour = Color3.fromRGB(255, 90, 0)
	end
	if delay >= 85 and Num <= 25 then
		Status = "Gate Closed"
		bgColour = Color3.fromRGB(161, 28, 27)
	end

	-- Handle empty string logic
	if Status == "" then
		if Num < 5 then
			Status = "Departed"
		elseif Num <= 25 then
			Status = "Gate Info Shortly"
		else
			Status = "Gate Info at " .. gateInfoTime
		end
	end

	-- Update screens
	for _, v in pairs(Screens.Departure:GetDescendants()) do
		if v.Name == "_" .. Num then
			v.AIRLINE.Image = Logos[AL]
			v.TO.Text = destination
			v.FLIGHT.Text = airlineIATA .. one .. two .. three .. four
			v.STD.Text = STD
			v.REMARKS.Text = Status
			v.REMARKS.Parent.BackgroundColor3 = bgColour
		end
	end

	for _, v in pairs(Screens.CheckIn:GetDescendants()) do
		if v.Name == "_" .. Num then
			v.CHKN.Text = Checkins[CI]
			v.TO.Text = destination
			v.FLIGHT.Text = airlineIATA .. one .. two .. three .. four
			v.STD.Text = STD
			v.REMARKS.Text = Status

			-- Correct condition for replacing remarks
			if v.REMARKS.Text == "Gate Info Shortly" or v.REMARKS.Text:find("Gate info at") then
				v.REMARKS.Text = ""
			end

			v.REMARKS.Parent.BackgroundColor3 = bgColour
			if bgColour == Color3.fromRGB(0, 101, 25) then
				v.REMARKS.Parent.BackgroundColor3 = Color3.fromRGB(40, 57, 148)
			end
		end
	end
end


function module.Start()
	for _,v in pairs(Screens.Adverts:GetChildren()) do
		v.Screen.SurfaceGui.Frame.A.Image = Settings.Ad1ID
		v.Screen.SurfaceGui.Frame.B.Image = Settings.Ad2ID
		v.Screen.SurfaceGui.Frame.C.Image = Settings.Ad3ID
	end
	task.spawn(function()
		while true do
			for _,v in pairs(Screens.Adverts:GetDescendants()) do
				if v:IsA("Frame") then
					v:TweenPosition(UDim2.new(0, 0, -1, 0), "Out", "Sine", 2)
				end
			end
			task.wait(15)
			for _,v in pairs(Screens.Adverts:GetDescendants()) do
				if v:IsA("Frame") then
					v:TweenPosition(UDim2.new(0, 0, -2, 0), "Out", "Sine", 2)
				end
			end
			task.wait(15)
			for _,v in pairs(Screens.Adverts:GetDescendants()) do
				if v:IsA("Frame") then
					v:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Sine", 2)
				end
			end
			task.wait(15)
		end
	end)
end

function module.UpdateBoard(Table)
	LASTTIME = Table['Time']
	for i = 2,34 do
		task.wait(0.0001)
		display(i)
	end
	for i = 35,69 do
		task.wait(0.0001)
		display(i)
	end
	for _,v in pairs(Screens.Departure:GetDescendants()) do
		if v:IsA("Frame") then
			if v.Name == "mainFlight" then
				v.AIRLINE.Image = Logos[5]
				v.TO.Text = Table['Destination']
				v.FLIGHT.Text = Table['FlightNum']
				v.REMARKS.Text = "Gate info at shortly"
				v.REMARKS.TextColor3 = Color3.fromRGB(255, 255, 255)
				v.STD.Text = Table['Time']
			end
		elseif v:IsA("SurfaceGui")then
			v.boot.Visible = false
			v.main.Visible = true
		end
	end
	game.ReplicatedStorage.CallToGate.OnServerEvent:Connect(function(player, gate)
    -- Check if the event is fired and a valid gate is provided
    if gate then
        -- Iterate through the descendants of the "Departure" screen
        for _, v in pairs(Screens.Departure:GetDescendants()) do
            if v:IsA("Frame") and v.Name == "mainFlight" then
                -- Update the remarks text
                v.REMARKS.Text = "Go to Gate " .. gate
            end
        end
    end
end)

	for _,v in pairs(Screens.CheckIn:GetDescendants()) do
		if v:IsA("Frame")then
			if v.Name == "mainFlight" then
				v.TO.Text = Table['Destination']
				v.FLIGHT.Text =Table['FlightNum']
				v.REMARKS.Text = " "
				v.REMARKS.TextColor3 = Color3.fromRGB(255,255,255)
				v.STD.Text = Table['Time']
			end
		elseif v:IsA("SurfaceGui")then
			v.boot.Visible = false
			v.main.Visible = true
		end
	end
	local Gate = GatesFolder[Table['Gate']]
	for _,v in pairs(Gate.Screens:GetChildren()) do
		v.Main.SurfaceGui.Main.Destination.Text = Table['Destination']
		v.Main.SurfaceGui.Main.FlightNum.Text = Table['FlightNum']
		v.Main.SurfaceGui.Main.Time.Text = Table['Time']
		v.Main.Other.Main.Destination.Text = Table['Destination']
		v.Main.Other.Main.FlightNum.Text = Table['FlightNum']
		v.Main.Other.Main.Time.Text = Table['Time']
		v.Main.Other.Main.Status.Text = 'Take a seat'
		v.Main.SurfaceGui.Main.Status.Text = 'Take a seat'
		v.Main.SurfaceGui.Main.Status.TextColor3 = Color3.fromRGB(255,255,255)
		v.Main.Other.Main.Status.TextColor3 = Color3.fromRGB(255,255,255)
		v.Main.SurfaceGui.Main.Visible = true 
		v.Main.SurfaceGui.Boot.Visible = false 
		v.Main.SurfaceGui.Closed.Visible = false 
		v.Main.Other.Main.Visible = true 
		v.Main.Other.Boot.Visible = false 
		v.Main.Other.Closed.Visible = false 
	end

	for _,v in pairs(GatesFolder:GetChildren()) do
		if v.Name ~= tostring(Table["Gate"]) then
			for _, j in pairs(v.Screens:GetChildren()) do
				j.Main.SurfaceGui.Main.Visible = false 
				j.Main.SurfaceGui.Boot.Visible = false 
				j.Main.SurfaceGui.Closed.Visible = true 
				j.Main.Other.Main.Visible = false 
				j.Main.Other.Boot.Visible = false 
				j.Main.Other.Closed.Visible = true 
			end	
		end
	end
	Core.Info.Value = true
end

-- gates

function module.gateupdate(gate,standard,priority)
	local Gate = GatesFolder[gate]
	Gate.Priority.Value = priority
	Gate.Standard.Value = standard
	print(Gate.Priority.Value)
	print(Gate.Standard.Value)
	if priority and standard then
		for _,v in pairs(Gate.Screens:GetChildren()) do
			v.Main.Other.Main.Status.Text = 'Boarding: All'
			v.Main.SurfaceGui.Main.Status.Text = 'Boarding: All'
			v.Main.SurfaceGui.Main.Status.TextColor3 = Colour["Green"]
			v.Main.Other.Main.Status.TextColor3 = Colour["Green"]
		end
	elseif priority then
		for _,v in pairs(Gate.Screens:GetChildren()) do
			v.Main.Other.Main.Status.Text = 'Boarding: Priority'
			v.Main.SurfaceGui.Main.Status.Text = 'Boarding: Priority'
			v.Main.SurfaceGui.Main.Status.TextColor3 = Colour["Green"]
			v.Main.Other.Main.Status.TextColor3 = Colour["Green"]
		end
	elseif standard then
		for _,v in pairs(Gate.Screens:GetChildren()) do
			v.Main.Other.Main.Status.Text = 'Boarding: Standard'
			v.Main.SurfaceGui.Main.Status.Text = 'Boarding: Standard'
			v.Main.SurfaceGui.Main.Status.TextColor3 = Colour["Green"]
			v.Main.Other.Main.Status.TextColor3 = Colour["Green"]
		end
	else
		for _,v in pairs(Gate.Screens:GetChildren()) do
			v.Main.Other.Main.Status.Text = 'Closed'
			v.Main.SurfaceGui.Main.Status.Text = 'Closed'
			v.Main.SurfaceGui.Main.Status.TextColor3 = Colour["Red"]
			v.Main.Other.Main.Status.TextColor3 = Colour["Red"]
		end
	end
end

-- stansted delete

local Moving = false
local counter = 0
function module.stan()
	if Moving then return end 
	Moving = true
	if  game.Workspace.STANSTED:FindFirstChild('DETECTPARTDONOTDELETE') then
		game.Workspace.STANSTED.DETECTPARTDONOTDELETE.Parent = game.ServerStorage.Stansted
		for _,v in  pairs(game.Workspace.STANSTED:GetChildren()) do
			if counter == 1000 then task.wait(0.1) counter = 0 end
			v.Parent = game.ServerStorage.Stansted
			counter += 1
		end
	else
		game.ServerStorage.Stansted.DETECTPARTDONOTDELETE.Parent = game.Workspace.STANSTED
		for _,v in  pairs(game.ServerStorage.Stansted:GetDescendants()) do
			if counter == 1000 then task.wait(0.1) counter = 0 end
			v.Parent = game.Workspace.STANSTED
			counter += 1
		end
	end
	Moving = false
end

return module