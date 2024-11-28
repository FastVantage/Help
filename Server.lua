--V2.3.2
-- LOCALS --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CallToGate = ReplicatedStorage:WaitForChild("CallToGate")
local ProximityPromptService = game:GetService("ProximityPromptService")
local modules = require(script.Modules)
local core = game.ReplicatedStorage.C
local settings = require(core:WaitForChild("Settings"))
local CollectionService = game:GetService("CollectionService")
local Reserved = {}
local plane
local flightinfo = {["Plane"] = "NA", ["FlightNum"] = "NA", ["Gate"] = "NA", ["Destination"] = "NA", ["Time"] = "NA"}

local PlaneConfigs = {
	['737'] ={
		['_1A'] = false,['_1B'] = false,['_1C'] = false,
		['_2A'] = false,['_2B'] = false,['_2C'] = false,['_2D'] = false,['_2E'] = false,['_2F'] = false,
		['_3A'] = false,['_3B'] = false,['_3C'] = false,['_3D'] = false,['_3E'] = false,['_3F'] = false,
		['_4A'] = false,['_4B'] = false,['_4C'] = false,['_4D'] = false,['_4E'] = false,['_4F'] = false,
		['_5A'] = false,['_5B'] = false,['_5C'] = false,['_5D'] = false,['_5E'] = false,['_5F'] = false,
		['_6A'] = false,['_6B'] = false,['_6C'] = false,['_6D'] = false,['_6E'] = false,['_6F'] = false,
		['_7A'] = false,['_7B'] = false,['_7C'] = false,['_7D'] = false,['_7E'] = false,['_7F'] = false,
		['_8A'] = false,['_8B'] = false,['_8C'] = false,['_8D'] = false,['_8E'] = false,['_8F'] = false,
		['_9A'] = false,['_9B'] = false,['_9C'] = false,['_9D'] = false,['_9E'] = false,['_9F'] = false,
		['_10A'] = false,['_10B'] = false,['_10C'] = false,['_10D'] = false,['_10E'] = false,['_10F'] = false,
		['_11A'] = false,['_11B'] = false,['_11C'] = false,['_11D'] = false,['_11E'] = false,['_11F'] = false,
		['_12A'] = false,['_12B'] = false,['_12C'] = false,['_12D'] = false,['_12E'] = false,['_12F'] = false,
		['_13A'] = false,['_13B'] = false,['_13C'] = false,['_13D'] = false,['_13E'] = false,['_13F'] = false,
		['_14A'] = false,['_14B'] = false,['_14C'] = false,['_14D'] = false,['_14E'] = false,['_14F'] = false,
		['_15A'] = false,['_15B'] = false,['_15C'] = false,['_15D'] = false,['_15E'] = false,['_15F'] = false,
		['_16A'] = false,['_16B'] = false,['_16C'] = false,['_16D'] = false,['_16E'] = false,['_16F'] = false,
		['_17A'] = false,['_17B'] = false,['_17C'] = false,['_17D'] = false,['_17E'] = false,['_17F'] = false,
		['_18A'] = false,['_18B'] = false,['_18C'] = false,['_18D'] = false,['_18E'] = false,['_18F'] = false,
		['_19A'] = false,['_19B'] = false,['_19C'] = false,['_19D'] = false,['_19E'] = false,['_19F'] = false,
		['_20A'] = false,['_20B'] = false,['_20C'] = false,['_20D'] = false,['_20E'] = false,['_20F'] = false,
		['_21A'] = false,['_21B'] = false,['_21C'] = false,['_21D'] = false,['_21E'] = false,['_21F'] = false,
		['_22A'] = false,['_22B'] = false,['_22C'] = false,['_22D'] = false,['_22E'] = false,['_22F'] = false,
		['_23A'] = false,['_23B'] = false,['_23C'] = false,['_23D'] = false,['_23E'] = false,['_23F'] = false,
		['_24A'] = false,['_24B'] = false,['_24C'] = false,['_24D'] = false,['_24E'] = false,['_24F'] = false,
		['_25A'] = false,['_25B'] = false,['_25C'] = false,['_25D'] = false,['_25E'] = false,['_25F'] = false,
	},
	['321'] ={
		['_1A'] = false,['_1B'] = false,['_1C'] = false,
		['_2A'] = false,['_2B'] = false,['_2C'] = false,['_2D'] = false,['_2E'] = false,['_2F'] = false,
		['_3A'] = false,['_3B'] = false,['_3C'] = false,['_3D'] = false,['_3E'] = false,['_3F'] = false,
		['_4A'] = false,['_4B'] = false,['_4C'] = false,['_4D'] = false,['_4E'] = false,['_4F'] = false,
		['_5A'] = false,['_5B'] = false,['_5C'] = false,['_5D'] = false,['_5E'] = false,['_5F'] = false,
		['_6A'] = false,['_6B'] = false,['_6C'] = false,['_6D'] = false,['_6E'] = false,['_6F'] = false,
		['_7A'] = false,['_7B'] = false,['_7C'] = false,['_7D'] = false,['_7E'] = false,['_7F'] = false,
		['_8A'] = false,['_8B'] = false,['_8C'] = false,['_8D'] = false,['_8E'] = false,['_8F'] = false,
		['_9B'] = false,['_9C'] = false,['_9D'] = false,['_9E'] = false,
		['_10A'] = false,['_10B'] = false,['_10C'] = false,['_10D'] = false,['_10E'] = false,['_10F'] = false,
		['_11A'] = false,['_11B'] = false,['_11C'] = false,['_11D'] = false,['_11E'] = false,['_11F'] = false,
		['_12A'] = false,['_12B'] = false,['_12C'] = false,['_12D'] = false,['_12E'] = false,['_12F'] = false,
		['_13A'] = false,['_13B'] = false,['_13C'] = false,['_13D'] = false,['_13E'] = false,['_13F'] = false,
		['_14A'] = false,['_14B'] = false,['_14C'] = false,['_14D'] = false,['_14E'] = false,['_14F'] = false,
		['_15A'] = false,['_15B'] = false,['_15C'] = false,['_15D'] = false,['_15E'] = false,['_15F'] = false,
		['_16A'] = false,['_16B'] = false,['_16C'] = false,['_16D'] = false,['_16E'] = false,['_16F'] = false,
		['_17A'] = false,['_17B'] = false,['_17C'] = false,['_17D'] = false,['_17E'] = false,['_17F'] = false,
		['_18A'] = false,['_18B'] = false,['_18C'] = false,['_18D'] = false,['_18E'] = false,['_18F'] = false,
		['_19A'] = false,['_19B'] = false,['_19C'] = false,['_19D'] = false,['_19E'] = false,['_19F'] = false,
		['_20B'] = false,['_20C'] = false,['_20D'] = false,['_20E'] = false,
		['_21A'] = false,['_21B'] = false,['_21C'] = false,['_21D'] = false,['_21E'] = false,['_21F'] = false,
		['_22A'] = false,['_22B'] = false,['_22C'] = false,['_22D'] = false,['_22E'] = false,['_22F'] = false,
		['_23A'] = false,['_23B'] = false,['_23C'] = false,['_23D'] = false,['_23E'] = false,['_23F'] = false,
		['_24A'] = false,['_24B'] = false,['_24C'] = false,['_24D'] = false,['_24E'] = false,['_24F'] = false,
		['_25A'] = false,['_25B'] = false,['_25C'] = false,['_25D'] = false,['_25E'] = false,['_25F'] = false,
		['_26A'] = false,['_26B'] = false,['_26C'] = false,['_26D'] = false,['_26E'] = false,['_26F'] = false,
		['_27A'] = false,['_27B'] = false,['_27C'] = false,['_27D'] = false,['_27E'] = false,['_27F'] = false,
		['_28A'] = false,['_28B'] = false,['_28C'] = false,['_28D'] = false,['_28E'] = false,['_28F'] = false,
		['_29A'] = false,['_29B'] = false,['_29C'] = false,['_29D'] = false,['_29E'] = false,['_29F'] = false,
		['_30A'] = false,['_30B'] = false,['_30C'] = false,['_30D'] = false,['_30E'] = false,['_30F'] = false,
		['_31A'] = false,['_31B'] = false,['_31C'] = false,['_31D'] = false,['_31E'] = false,['_31F'] = false,
	}
}


-- INIT --


for _,v in pairs(workspace.selfCheckIns:GetChildren()) do
	local Pp = script.ProximityPrompt:Clone()
	Pp.Parent = v.sciAssets.ProximityPrompt
end

-- FUNCTIONS --

function onPromptTriggered(promptObject, player)
	if not player.Checked.Value then
		--modules.disable(promptObject)
		core.To:FireClient(player, "SCI", promptObject)
	end
end

local function sendinfo()
	return flightinfo
end

function seatbook(Player,Seat)
	if PlaneConfigs[flightinfo["Plane"]][Seat] == false then
		PlaneConfigs[flightinfo["Plane"]][Seat] = true
		Reserved[Player] = Seat
		print(Player.Name..Reserved[Player])
		core.SCI:FireAllClients("Status",Player,Seat, "ON")
	else
		core.SCI:FireClient(Player,"SeatInUse",Seat)
	end
end
function seatcancel(Player,Seat)
	PlaneConfigs[flightinfo["Plane"]][Seat] = false
	Reserved[Player] = nil
	core.SCI:FireAllClients("Status",Player,Seat, "OFF")
end

local function checkseat()
	return PlaneConfigs[flightinfo["Plane"]]
end

local function planeadded(object)
	plane = object
	core.To:FireAllClients("NewPlane")
end

local function returnplane()
	return plane
end


-- MAIN --

modules.Start()

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)

core.Load.OnServerInvoke = sendinfo

core.Check.OnServerInvoke = checkseat

core.SCI.OnServerEvent:Connect(function(Plr,func,...)
	if func == "SeatBooked" then
		local args = {...}
		seatbook(Plr,args[1])
	elseif func == "SeatCancelled" then
		local args = {...}
		seatcancel(Plr,args[1])
	elseif func == "CheckIn" then
		local args = {...}
		--modules.enable(args[1].Parent.ProximityPrompt.ProximityPrompt)
		if args[2] == "Priority" then
			local tool = core.Priority:Clone()
			tool.Parent = Plr.Backpack
			Plr.Checked.Value = true
		elseif args[2] == "Standard" then
			local tool = core.Standard:Clone()
			tool.Parent = Plr.Backpack
			Plr.Checked.Value = true
		end
		Plr.Character.HumanoidRootPart.Anchored = false 
	elseif func == "SeatRemoved" then
		local args = {...}
		seatcancel(args[1],args[2])
	elseif func == "SeatCreated" then
		local args = {...}
		seatbook(args[1],args[2])
	end
end)

game.Players.PlayerRemoving:Connect(function(Plr)
	if Reserved[Plr] ~= nil then
		seatcancel(Plr, Reserved[Plr])
	end
end)

core.From.OnServerEvent:Connect(function(Plr, Task, ...)
	if Plr:GetRankInGroup(settings.GroupID) >= settings.StaffID then
		if Task == "Info" then
			local args = {...}
			if PlaneConfigs[args[1]] == nil then return end
			flightinfo["Plane"] = args[1]
			flightinfo["FlightNum"] = args[2]
			flightinfo["Gate"] = args[3]
			flightinfo["Destination"] = args[4]
			flightinfo["Time"] = args[5]
			modules.UpdateBoard(flightinfo)
			core.To:FireAllClients("PlaneSelected", flightinfo["Plane"])
		elseif Task == "Boarding" then

			local args = {...}
			modules.gateupdate(flightinfo["Gate"],args[2],args[3])
			if args[3] then
				local rev = {}
				for i,v in ipairs(Reserved) do
					print(i,v)
					rev[v] = i
				end
				for _,k in pairs(rev) do
					if game.Players[k] == nil then
						PlaneConfigs[flightinfo["Plane"]][Reserved[k]] = false 
						Reserved[k] = nil
					end
				end
				for _,v in pairs(game.Players:GetChildren()) do
					if Reserved[v] ~= nil then
						core.To:FireClient(v,"SeatLoad", plane, Reserved[v])
						print("Fired Load: "..v.Name..Reserved[v])
					else
						core.To:FireClient(v,"SeatAny", plane, PlaneConfigs[flightinfo["Plane"]])
						print("Fired Any: "..v.Name)
					end
				end
			end
		elseif Task == "stan" then
			modules.stan()
		elseif Task == "scion" then
			modules.enable()
		elseif Task == "scioff" then
			modules.disable()
		elseif Task == "unlock" then
			core.To:FireAllClients("Unlock", plane)
		end
	end
	if Task == "Uni" and Plr:GetRankInGroup(settings.GroupID) >= 65 then
		local args = {...}
		local foundShirt = Plr.Character:FindFirstChild("Shirt") -- Tries to find Shirt
		if not foundShirt then -- if there is no shirt
			local newShirt = Instance.new("Shirt",Plr.Character)
			newShirt.Name = "Shirt"
		elseif foundShirt then -- if there is a shirt
			Plr.Character.Shirt:remove()
			local newShirt = Instance.new("Shirt",Plr.Character)
			newShirt.Name = "Shirt"
		end
		local foundPants = Plr.Character:FindFirstChild("Pants") -- Tries to find Pants
		if not foundPants then -- if there are no pants
			local newPants = Instance.new("Pants",Plr.Character)
			newPants.Name = "Pants"
		elseif foundPants then -- if there are pants
			Plr.Character.Pants:remove()
			local newPants = Instance.new("Pants",Plr.Character)
			newPants.Name = "Pants"
		end

		if args[1] == "GC" then
			Plr.Character.Shirt.ShirtTemplate = "rbxassetid://5138642781"
			Plr.Character.Pants.PantsTemplate = "rbxassetid://5138644855"
		elseif args[1] == "Cap" then
			Plr.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=4985122559"
			Plr.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=4985118060"
		elseif args[1] == "FO" then
			Plr.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=4985126537"
			Plr.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=4985131778"
		elseif args[1] == "CCM" then
			Plr.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=4949253847"
			Plr.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=4985533670"
		elseif args[1] == "CCF" then
			Plr.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=4949253847"
			Plr.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=4949297050"
		elseif args[1] == "ASM" then
			Plr.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=4985145124"
			Plr.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=4985140581"
		elseif args[1] == "ASF" then
			Plr.Character.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=4985152386"
			Plr.Character.Pants.PantsTemplate = "http://www.roblox.com/asset/?id=4985157396"
		end
	end
	if Task == "SCILOADED" then
		local args = {...}
		Plr.Character.HumanoidRootPart.CFrame = args[1].Parent.Parent.PlrCFrame.CFrame
		Plr.Character.HumanoidRootPart.Anchored = true 
	end
end)



CollectionService:GetInstanceAddedSignal("Plane"):Connect(planeadded)

core.Plane.OnServerInvoke = returnplane


