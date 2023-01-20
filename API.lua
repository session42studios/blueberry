--[[


		
    ____     __     __  __   ______   ____     ______   ____     ____  __  __
   / __ )   / /    / / / /  / ____/  / __ )   / ____/  / __ \   / __ \ \ \/ /
  / __  |  / /    / / / /  / __/    / __  |  / __/    / /_/ /  / /_/ /  \  / 
 / /_/ /  / /___ / /_/ /  / /___   / /_/ /  / /___   / _, _/  / _, _/   / /  
/_____/  /_____/ \____/  /_____/  /_____/  /_____/  /_/ |_|  /_/ |_|   /_/   
                                                                              
					 Application Programming Interface



]]


--// Variables \\
local Config = require(script.Parent.Parent:FindFirstChild("Settings"))
local Log = script.Parent.Events:FindFirstChild("Log")


--// DataStores \\
local DataStoreService = game:GetService("DataStoreService")
local WarnDataStore = DataStoreService:GetDataStore("BB_WarnData")
local PermBanDataStore = DataStoreService:GetDataStore("BB_PermBanData")
local TempBanDataStore = DataStoreService:GetDataStore("BB_TempBanDataStore")


--// Sequence initiation \\
local api = {}


--// Create warning function \\
function api.createWarning(function_data, username, reason, moderator)	
	--|| Variables ||
	
	local Data
	local UserID
	local Moderator
	local Reason

	--(( GET SUSPECT ))--
	--|| Get UserID by username ||--
	if typeof(username) == "string" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = game:GetService("Players"):GetUserIdFromNameAsync(username)
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
		--|| Get UserID by number ||--
	elseif typeof(username) == "number" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
		--|| Get UserID by player instance ||--
	elseif typeof(username) == "Instance" then
		
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username.UserId
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	end
	--(( GET SUSPECT END ))--
	

	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
		elseif typeof(moderator) == 'Instance' then
			--((NOTIFY))--
			local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
			if UserID == _G.B_GameOwner then
				Notify.notify(moderator, "Game owner", "Cannot create moderation for game owner.", "warning", 3)
				warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
				return
			end
			--(( CHARACTER LIMIT ))--
			if reason:len() >= 150 then
				warn("[!] BLUEBERRY: Reason is too long. Setting default reason.")
				reason = "Moderator reason was too long, short reason: "..Config["Default Warning Reason"]
				Notify.notify(moderator, "Reason too long", "Your reason was too long so we changed it to the default reason.", "warning", 3)
				return
			end
			--(( CHARACTER LIMIT END ))--
			local S_notify, E_notify = pcall(function()
				Notify.notify(moderator, "Warning issued", "A warning has been issued for " ..username.." ("..UserID.."). It will be added if username is valid.", "info", 3)
			end)
			if not S_notify then
				warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
				Notify.notify(moderator, "Error", E_notify, "alert", 5)
			end
			--((NOTIFY END))--
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	if reason then
		Reason = reason
	else
		Reason = Config["Default Warning Reason"]
	end

	if UserID == _G.B_GameOwner then
		warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
		return
	end
	
	script.Parent.Events.SetWarning:Fire(UserID, Reason, Moderator)
end
--[[----------------------------------------------------------------------------------------------------------]]


--// Remove warning function \\
function api.removeWarning(function_data, username, reason, moderator)
	--|| Variables ||
	
	local PostWebhook = false
	local Data
	local UserID
	local Moderator
	local Reason
	
	if reason then
		Reason = reason
	else
		Reason = "No reason provided for this warning removal."
	end

	--(( GET SUSPECT ))--
	--|| Get UserID by username ||--
	if typeof(username) == "string" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = game:GetService("Players"):GetUserIdFromNameAsync(username)
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
		--|| Get UserID by number ||--
	elseif typeof(username) == "number" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username
		end)

		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by player instance ||--
	elseif typeof(username) == "Instance" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username.UserId
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	end
	--(( GET SUSPECT END ))--
	
	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
			--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	--|| Remove DataStore entry ||
	local Success, Error = pcall(function()
		if WarnDataStore:GetAsync(UserID) then
			WarnDataStore:RemoveAsync(UserID)
			PostWebhook = true
		else
			warn("[!] BLUEBERRY: User doesn't appear to be warned. Couldn't remove warning.")
			if typeof(moderator) == 'Instance' then
				--((NOTIFY))--
				local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
				local S_notify, E_notify = pcall(function()
					Notify.notify(moderator, "Error", "The user you are trying to unwarn ("..UserID..") doesn't appear to be warned.", "warning", 3)
				end)
				if not S_notify then
					warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
					Notify.notify(moderator, "Error", E_notify, "alert", 5)
				end
				--((NOTIFY END))--
			end
			PostWebhook = false
		end
	end)

	if Success then
		if PostWebhook then
			if typeof(moderator) == 'Instance' then
				--((NOTIFY))--
				local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
				local S_notify, E_notify = pcall(function()

					Notify.notify(moderator, "Warning removed", "Warning removed for "..username.. " ("..UserID..").", "info", 3)
				end)
				if not S_notify then
					warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
					Notify.notify(moderator, "Error", E_notify, "alert", 5)
				end
				--((NOTIFY END))--
			end
			print("Warning removed: UserID; " ..UserID.. "; Reason; " ..Reason.."; Moderator; " ..Moderator)
			Log:Fire("Warning removed", "A warning was removed using Blueberry services. Warning removed by **" ..Moderator.."**.", 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "Removed from suspect", username, "Reason", Reason, "New warning log! (removed)")
		end
	else
		warn("[!] BLUEBERRY: Error while removing warning data: " ..Error)
	end
end

--[[----------------------------------------------------------------------------------------------------------]]

--// Create TempBan function \\

function api.tempBan(function_data, username, duration, reason, moderator)
	--|| Variables ||

	local Data
	local UserID
	local Moderator
	local Reason
	local TimeDuration
	
	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
		--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	if reason then
		Reason = reason
	else
		Reason = Config["Default TempBan Reason"]
	end
	if duration then
		TimeDuration = duration * 60
	else
		TimeDuration = 30
	end

	--(( GET SUSPECT ))--
	--|| Get UserID by username ||--
	if typeof(username) == "string" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = game:GetService("Players"):GetUserIdFromNameAsync(username)
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by number ||--
	elseif typeof(username) == "number" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username
		end)
		if UserID_Success then
			--// Do nothing
		else
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by player instance ||--
	elseif typeof(username) == "Instance" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username.UserId
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	end
	--(( GET SUSPECT END ))--
	
	--((GET MODERATOR))--
	--|| Get UserID by player  ||--
	if typeof(moderator) == 'Instance' then
		--((NOTIFY))--
		local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
		if UserID == _G.B_GameOwner then
			Notify.notify(moderator, "Game owner", "Cannot create moderation for game owner.")
			warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
			return
		end
		local S_notify, E_notify = pcall(function()
			Notify.notify(moderator, "Temporary banned", "Temporary ban requested for "..username.. " ("..UserID..").", "info", 3)
		end)
		if not S_notify then
			warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
			Notify.notify(moderator, "Error", E_notify, "alert", 5)
		end
		--((NOTIFY END))--
	end
	
	if UserID == _G.B_GameOwner then
		warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
		return
	end
	script.Parent.Events.SetTempBan:Fire(UserID, TimeDuration, Reason, Moderator)

end

--[[----------------------------------------------------------------------------------------------------------]]

--// Create permanent ban \\

function api.permBan(function_data, username, reason, moderator)
	--|| Variables ||

	local UserID
	local Moderator
	local Reason
	local TimeDuration

	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
			--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	if reason then
		Reason = reason
	else
		Reason = Config["Default PermBan Reason"]
	end

	--(( GET SUSPECT ))--
	--|| Get UserID by username ||--
	if typeof(username) == "string" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = game:GetService("Players"):GetUserIdFromNameAsync(username)
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by number ||--
	elseif typeof(username) == "number" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by player instance ||--
	elseif typeof(username) == "Instance" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username.UserId
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	end
	--(( GET SUSPECT END ))--

	--|| Get UserID by player instance ||--
	if typeof(moderator) == 'Instance' then
		--((NOTIFY))--
		local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
		if UserID == _G.B_GameOwner then
			Notify.notify(moderator, "Game owner", "Cannot create moderation for game owner.")
			warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
			return
		end
		local S_notify, E_notify = pcall(function()
			Notify.notify(moderator, "Permanently banned", "Permanent ban requested for "..username.. " ("..UserID..").", "info", 3)
		end)
		if not S_notify then
			warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
			Notify.notify(moderator, "Error", E_notify, "alert", 5)
		end
		--((NOTIFY END))--
	end
	if UserID == _G.B_GameOwner then
		warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
		return
	end
	script.Parent.Events.SetPermBan:Fire(UserID, Reason, Moderator)
end

--[[----------------------------------------------------------------------------------------------------------]]

--// Remove ban function \\

function api.removeBan(function_data, username, reason, moderator)

	--|| Variables ||

	local UserID
	local Moderator
	local Reason
	local PostWebhook = false

	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
			--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--
	
	if reason then
		Reason = reason
	else
		Reason = "No reason provided for this permanent ban removal."
	end

	--(( GET SUSPECT ))--
	--|| Get UserID by username ||--
	if typeof(username) == "string" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = game:GetService("Players"):GetUserIdFromNameAsync(username)
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by number ||--
	elseif typeof(username) == "number" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by player instance ||--
	elseif typeof(username) == "Instance" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username.UserId
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	end
	--(( GET SUSPECT END ))--

	--|| Remove DataStore entry ||
	local Success, Error = pcall(function()
		if PermBanDataStore:GetAsync(UserID) then
			PermBanDataStore:RemoveAsync(UserID)
			PostWebhook = true
		else
			warn("[!] BLUEBERRY: Use doesn't appear to be banned. Couldn't unban.")
			--|| Get UserID by player instance ||--
			if typeof(moderator) == 'Instance' then
				--((NOTIFY))--
				local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
				local S_notify, E_notify = pcall(function()
					Notify.notify(moderator, "Error", "The user you are trying to unban ("..UserID..") doesn't appear to be banned.", "warning", 5)
				end)
				if not S_notify then
					warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
					Notify.notify(moderator, "Error", E_notify, "alert", 5)
				end
				--((NOTIFY END))--
			end
			PostWebhook = false
		end
	end)

	if Success then
		if PostWebhook then
			print("Permanent ban removed: UserID; " ..UserID.. "; Reason; " ..Reason.."; Moderator; " ..Moderator)
			--|| Get UserID by user instance ||--
			if typeof(moderator) == 'Instance' then
				--((NOTIFY))--
				local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
				local S_notify, E_notify = pcall(function()
					Notify.notify(moderator, "Ban removed", "Permanent ban removed for "..username.. " ("..UserID..").", "info", 3)
				end)
				if not S_notify then
					warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
					Notify.notify(moderator, "Error", E_notify, "alert", 5)
				end
				--((NOTIFY END))--
			end		
			Log:Fire("Permanent ban removed", "A permanent ban was removed using Blueberry services. Warning removed by **" ..Moderator.."**.", 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "Removed from suspect", username, "Reason", Reason, "New permanent ban log! (removed)")
		end
	else
	warn("[!] BLUEBERRY: Error while removing warning data: " ..Error)
end
	
	PostWebhook = false
end

--[[----------------------------------------------------------------------------------------------------------]]

--// Server lock (slock) \\

function api.slock(function_data, reason, groupID, min_rank, moderator)

	--|| Variables ||

	local Moderator
	local Reason
	
	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
			--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	if reason then
		Reason = reason
	else
		Reason = Config["Default Slock Reason"]
	end
	
	if groupID then
		groupID = groupID
	else
		groupID = Config["Group ID"]
	end
	
	if min_rank then
		min_rank = min_rank
	else
		min_rank = Config["Bypass server lock permission"]
	end

	script.Parent.Events.SetSlock:Fire(true, groupID, min_rank, Moderator, Reason)
	
	--|| Get UserID by player instance ||--
	if typeof(moderator) == 'Instance' then
		--((NOTIFY))--
		local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
		local S_notify, E_notify = pcall(function()

			Notify.notify(moderator, "Server locked", "This server has been locked for ranks below " ..min_rank..".", "info", 3)
		end)
		if not S_notify then
			warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
			Notify.notify(moderator, "Error", E_notify, "alert", 5)
		end
		--((NOTIFY END))--
	end
	Log:Fire("Server locked", "A server has been locked (slock) using Blueberry services. Actioned by **" ..Moderator.."**.", 5814783, "https://cdn-icons-png.flaticon.com/512/159/159069.png", "Actioned by", Moderator, "Reason", Reason, "New lock log")
end

--[[----------------------------------------------------------------------------------------------------------]]

--// Server unlock (unslock) \\

function api.unslock(function_data, moderator)

	--|| Variables ||

	local Moderator
	
	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
			--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	script.Parent.Events.SetSlock:Fire(false, Moderator)
	if typeof(moderator) == 'Instance' then
		--((NOTIFY))--
		local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
		local S_notify, E_notify = pcall(function()
			Notify.notify(moderator, "Server unlocked", "This server has been unlocked for all ranks.", "info", 3)
		end)
		if not S_notify then
			warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
			Notify.notify(moderator, "Error", E_notify, "alert", 5)
		end
		--((NOTIFY END))--
	end
	Log:Fire("Server unlocked", "A server has been unlocked (unslock) using Blueberry services. Actioned by **" ..Moderator.."**.", 5814783, "https://cdn-icons-png.flaticon.com/512/158/158599.png", "Actioned by", Moderator, "Reason", "-reasons cannot be set for unslocks-", "New unlock log")
end

--[[----------------------------------------------------------------------------------------------------------]]

--// Kicking \\

function api.kick(function_data, username, reason, moderator)

	--|| Variables ||
	
	local TargetPlayer
	local Moderator
	local Reason
	
	local asuccess, aerror = pcall(function()
		TargetPlayer = game:GetService('Players'):FindFirstChild(username)
	end)
	if not asuccess then
		warn("[!] BLUEBERRY: Couldn't find target user: " ..aerror..". | Code: 404")
	end
	
	--(( GET MODERATOR ))--
	if moderator ~= nil then
		--|| Get UserID by username ||--
		if typeof(moderator) == 'string' then
			Moderator = moderator
			--|| Get UserID by player instance ||--
		elseif typeof(moderator) == 'Instance' then
			Moderator = moderator.Name
		end
	else
		Moderator = "Blueberry Core"
	end
	--(( GET MODERATOR END ))--

	if reason then
		Reason = reason
	else
		Reason = Config["Default Kick Reason"]
	end

	if TargetPlayer.UserId == _G.B_GameOwner then
		warn("[!] BLUEBERRY: Cannot create moderation action for the game owner.")
		return
	end
	script.Parent.Events.SetKick:Fire(TargetPlayer, Reason, Moderator)
	--|| Get UserID by player instance ||--
	if typeof(moderator) == 'Instance' then
		--((NOTIFY))--
		local Notify = require(game:GetService('ReplicatedStorage'):WaitForChild("Blueberry_Replicated"):WaitForChild("NotifySystem"))
		local S_notify, E_notify = pcall(function()
			Notify.notify(moderator, "Kicked", "Server removal has been requested for " ..username..".", "info", 3)
		end)
		if not S_notify then
			warn("[!] BLUEBERRY: Error while creating notification: " ..E_notify)
			Notify.notify(moderator, "Error", E_notify, "alert", 5)
		end
		--((NOTIFY END))--
	end
	Log:Fire("Player kicked", "A player has been removed from a server using Blueberry services. Kick issued by **" ..Moderator.."**.", 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "Suspect", username, "Reason", Reason, "New kicking log")
end

--[[----------------------------------------------------------------------------------------------------------]]

--// TempBan removal \\

function api.removeTempBan(function_data, username, reason)

	--|| Variables ||

	local TargetPlayer
	local Moderator
	local Reason
	local UserID

	
	--(( GET SUSPECT ))--
	--|| Get UserID by username ||--
	if typeof(username) == "string" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = game:GetService("Players"):GetUserIdFromNameAsync(username)
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by number ||--
	elseif typeof(username) == "number" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	--|| Get UserID by player instance ||--
	elseif typeof(username) == "Instance" then
		local UserID_Success, UserID_Error = pcall(function()
			UserID = username.UserId
		end)
		if not UserID_Success then
			warn("[!] BLUEBERRY: Error while getting UserID: " ..UserID_Error)
		end
	end
	--(( GET SUSPECT END ))--

	if reason then
		Reason = reason
	else
		Reason = "No reason provided."
	end
	local Rsuccess, Rerror = pcall(function()
		TempBanDataStore:RemoveAsync(UserID)
	end)
	if not Rsuccess then
		warn("[!] BLUEBERRY: Error while trying to remove temporary ban: " ..Rerror)
	end
	Log:Fire("Temporary ban removed", "A temporary ban has been removed from a a player using Blueberry services.", 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "Suspect", username, "Reason", Reason, "New unbanning log")
end



--// Return API functions \\
return api
