--[[ Variables ]]--
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId
local Config = require(script.Parent.Parent.Settings)
local API = require(script.Parent.API)








--[[ Auto Set-Up ]]--

local Folder = script.Parent.Parent

if Folder.Parent ~= game:GetService("ServerScriptService") then
	print("[-] BLUEBERRY: Parent isn't ServerScriptService. Attempting to move folder.")

	repeat Folder.Parent = game:GetService("ServerScriptService") until
	Folder.Parent == game:GetService("ServerScriptService")

	if Folder.Parent == game:GetService("ServerScriptService") then
		print("[-] BLUEBERRY: Changed parent successfully.")
	end
end

local Replicated = script.Blueberry_Replicated
Replicated.Parent = game:GetService("ReplicatedStorage")

local Client = script.Blueberry_Client
Client.Parent = game:GetService('StarterGui')



game:GetService('Players').PlayerAdded:Connect(function(player)
	local Character_1 = player.Character or player.CharacterAdded:Wait()
	
	-- Functions
	local function CreateButton()
		script.Panel_Button:Clone().Parent = player.PlayerGui:WaitForChild('Blueberry_Client')
		print('[-] BLUEBERRY: Created button for ' ..player.Name.. ".")	
	end
	local function CreatePanel()
		script.Blueberry_Panel:Clone().Parent = player.PlayerGui:WaitForChild('Blueberry_Client') --wait(0.1) until player2.PlayerGui:FindFirstChild('Blueberry_Client'):FindFirstChild("Blueberry_Panel")
		print('[-] BLUEBERRY: Created panel for ' ..player.Name.. ".")	
	end
	

	local Humanoid = Character_1:FindFirstChild("Humanoid")
	player.CharacterAdded:Connect(function(Character_2)
		task.wait(0.5)
		print("Character added")
		if Config["Use panel"] == true then
			if player:GetRankInGroup(Config["Group ID"]) >= Config["View panel permission"] then
				CreatePanel()
				wait(0.5)
				CreateButton()
			end
		end
	end)
	
	-- Action
	if Config["Use panel"] == true then
		
		if player:GetRankInGroup(Config["Group ID"]) >= Config["View panel permission"] then
			
			CreatePanel()			
			if Config["Screen button"] == true then
				
				CreateButton()
				
				
				
				
			end
			
			if Config["Auto-open on start-up"] == true then
				wait(2)
				game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Events"):WaitForChild("OpenUI"):FireClient(player)
			end
			
		end
		
	end
end)





--[[ Get game owner ]]--
local PlaceId = game.PlaceId
local PlaceInfo = game:GetService("MarketplaceService"):GetProductInfo(PlaceId)
local gameOwner = nil
if game.CreatorType == Enum.CreatorType.Group then
	gameOwner = game:GetService("GroupService"):GetGroupInfoAsync(PlaceInfo.Creator.CreatorTargetId).Owner.Id
else
	gameOwner = game.CreatorId
end
_G.B_GameOwner = gameOwner




--[[ Get version ]]--
local version = 1.11
print("[-] BLUEBERRY is running on version "..version)

--// Disabled due to downtime issues.








--[[ Kick player on request ]]--


game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Events"):WaitForChild("Trigger").OnServerEvent:Connect(function(player, reason)
	player:Kick(reason)
end)







--[[ Replicated API ]]--
local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
local function getPlayerRank(requester, playerID)
	local TargetURL = "http://groups.roproxy.com/v2/users/"..playerID.."/groups/roles"
	local Response
	local GetSuccess, GetError = pcall(function()
		Response = HttpService:GetAsync(TargetURL)
	end)
	if not GetSuccess then
		warn("[!] BLUEBERRY: Error while getting offline player rank in group. HTTP service might be unoperational. Error: "..GetError)
		Notify.notify(requester, "Error", "Error while getting offline player rank in group. HTTP service might be unoperational.", "warning", 4)
		return false
	end
	if Response then
		local ReturnedNumber = 0
		Response = HttpService:JSONDecode(Response)
		for i, v in pairs(Response["data"]) do
			if v["group"]["id"] == Config["Group ID"] then
				ReturnedNumber = v["role"]["rank"]
			end
		end
		return ReturnedNumber
	else
		Notify.notify(requester, "Error", "Error while fetching offline player rank in group. Response was invalid.", "warning", 4)
		warn("[!] BLUEBERRY: HTTP response couldn't be fetched.")
	end
end

local function getPlayerID(username)
	return game:GetService("Players"):GetUserIdFromNameAsync(username)
end

if Config["Use Replicated API"] == true then
	
	local Folder = game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("Replicated_API")

	
	local GroupID = Config["Group ID"]
	local CanWarn = Config["Create warnings permission"]
	local CanUnWarn = Config["Remove warnings permission"]
	local CanBan = Config["Create permanent bans permission"]
	local CanUnBan = Config["Remove permanent bans permission"]
	local CanTempBan = Config["Create temporary bans permission"]
	local CanSlock = Config["Slock permission"]
	local CanKick = Config["Kick players permission"]
	
	-- Create warnings
	Folder.createWarning.OnServerEvent:Connect(function(requester, player_to_warn, reason, moderator)
		if requester:GetRankInGroup(GroupID) >= CanWarn then
			if player_to_warn then
				-- Rank check
				local pun_target = player_to_warn
				if tonumber(pun_target) == nil then
					print("[-] BLUEBERRY: Requested by username for "..pun_target)
					local TargetRank = getPlayerRank(requester, getPlayerID(pun_target))
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				elseif tonumber(pun_target) ~= nil then
					pun_target = tonumber(pun_target)
					print("[-] BLUEBERRY: Requested by ID for "..pun_target)
					local TargetRank = getPlayerRank(requester, pun_target)
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				end
				-- Rank check end
				
				API:createWarning(player_to_warn, reason, requester)
			else
				warn("[-] BLUEBERRY: Got warn request, but target username was empty. Requested by " ..requester.Name.. "| Error code: 203")
			end
		end
	end)

	-- Remove warnings
	Folder.removeWarning.OnServerEvent:Connect(function(requester, player_to_remove, reason, moderator)
		if requester:GetRankInGroup(GroupID) >= CanUnWarn then
			if player_to_remove then
				API:removeWarning(player_to_remove, reason, requester)
			else
				warn("[-] BLUEBERRY: Got unwarn request, but target username was empty. Requested by " ..requester.Name.. "| Error code: 203")
			end
		end
	end)

	-- Create temporary bans
	Folder.tempBan.OnServerEvent:Connect(function(requester, player_to_ban, duration, reason, moderator)
		if requester:GetRankInGroup(GroupID) >= CanTempBan then
			if player_to_ban then
				-- Rank check
				local pun_target = player_to_ban
				if tonumber(pun_target) == nil then
					print("[-] BLUEBERRY: Requested by username for "..pun_target)
					local TargetRank = getPlayerRank(requester, getPlayerID(pun_target))
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				elseif tonumber(pun_target) ~= nil then
					pun_target = tonumber(pun_target)
					print("[-] BLUEBERRY: Requested by ID for "..pun_target)
					local TargetRank = getPlayerRank(requester, pun_target)
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				end
				-- Rank check end
				API:tempBan(player_to_ban, duration, reason, requester)
			else
				warn("[-] BLUEBERRY: Got temporary ban request, but target username was empty. Requested by " ..requester.Name.. "| Error code: 203")
			end
		end
	end)

	-- Create permanent bans
	Folder.permBan.OnServerEvent:Connect(function(requester, player_to_ban, reason, moderator)
		if requester:GetRankInGroup(GroupID) >= CanBan then
			if player_to_ban then
				-- Rank check
				local pun_target = player_to_ban
				if tonumber(pun_target) == nil then
					print("[-] BLUEBERRY: Requested by username for "..pun_target)
					local TargetRank = getPlayerRank(requester, getPlayerID(pun_target))
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				elseif tonumber(pun_target) ~= nil then
					pun_target = tonumber(pun_target)
					print("[-] BLUEBERRY: Requested by ID for "..pun_target)
					local TargetRank = getPlayerRank(requester, pun_target)
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				end
				-- Rank check end
				API:permBan(player_to_ban, reason, requester)
			else
				warn("[-] BLUEBERRY: Got permanent ban request, but target username was empty. Requested by " ..requester.Name.. "| Error code: 203")
			end
		end
	end)
	
	-- Create kicks
	Folder.kick.OnServerEvent:Connect(function(requester, player_to_kick, reason, moderator)
		if requester:GetRankInGroup(GroupID) >= CanKick then
			if player_to_kick then
				-- Rank check
				local pun_target = player_to_kick
				if tonumber(pun_target) == nil then
					print("[-] BLUEBERRY: Requested by username for "..pun_target)
					local TargetRank = getPlayerRank(requester, getPlayerID(pun_target))
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				elseif tonumber(pun_target) ~= nil then
					pun_target = tonumber(pun_target)
					print("[-] BLUEBERRY: Requested by ID for "..pun_target)
					local TargetRank = getPlayerRank(requester, pun_target)
					local RequesterRank = requester:GetRankInGroup(Config["Group ID"])
					--print("[*] BLUEBERRY: Requester rank ID: "..RequesterRank.."; target rank ID: "..TargetRank)
					if TargetRank == false then
						Notify.notify(requester, "Error", "Punishment fetch failed. Couldn't get permission.", "warning", 4)
					else
						if TargetRank >= RequesterRank then
							Notify.notify(requester, "Rank incompatibility", "Punishment fetch failed. Your rank is too low.", "warning", 4)
							return
						else
							--// Continue
						end
					end
				end
				-- Rank check end
				API:kick(player_to_kick, reason, requester)
			else
				warn("[-] BLUEBERRY: Got kicking request, but target username was empty. Requested by " ..requester.Name.. "| Error code: 203")
			end
		end
	end)

	-- Remove temporary bans
	Folder.removeBan.OnServerEvent:Connect(function(requester, player_to_remove, reason, moderator)
		if requester:GetRankInGroup(GroupID) >= CanUnBan then
			if player_to_remove then
				API:removeBan(player_to_remove, reason, requester)
			else
				warn("[-] BLUEBERRY: Got unban request, but target username was empty. Requested by " ..requester.Name.. "| Error code: 203")
			end
		end
	end)
	
	-- Slock
	Folder.slock.OnServerEvent:Connect(function(requester, reason, groupID, min_rank)
		if requester:GetRankInGroup(GroupID) >= CanSlock then
			if groupID then
				if min_rank then
					API:slock(reason, groupID, min_rank, requester)
				else
					API:slock(reason, groupID, Config["Bypass server lock permission"], requester)
				end
			else
				API:slock(reason, GroupID, Config["Bypass server lock permission"], requester)
			end
		end
	end)
	
	-- Unslock
	Folder.unslock.OnServerEvent:Connect(function(requester)
		if requester:GetRankInGroup(GroupID) >= CanSlock then
			API:unslock(requester)
		end
	end)
	
	
	
	--|| Set replicated values ||--
	
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("GroupID").Value = Config["Group ID"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("WarningPermission").Value = Config["Create warnings permission"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("UnwarnPermission").Value = Config["Remove warnings permission"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("TempBanPermission").Value = Config["Create temporary bans permission"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("PermBanPermission").Value = Config["Create permanent bans permission"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("UnbanPermission").Value = Config["Remove permanent bans permission"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("UnbanPermission").Value = Config["Slock permission"]
	game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("UnbanPermission").Value = Config["Kick players permission"]	
else
	
	--// Replicated API is off
	
	
end






--[[ Keyblind ]]--

game:GetService("ReplicatedStorage"):WaitForChild("Blueberry_Replicated"):WaitForChild("Values"):WaitForChild("KeyblindValue").Value = Config["Open keybind"]




