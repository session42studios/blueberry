local DataStoreService = game:GetService("DataStoreService")
local PermBanDataStore = DataStoreService:GetDataStore("BB_PermBanData")
local Config = require(script.Parent.Parent.Settings)
local Log = script.Parent.Events.Log

local AutoKick = Config["PermBan Auto-Kick"]
local AutoKickDuration = Config["PermBan Auto-Kick countdown"]
local UseCustomGUI = Config["Use organization info"]
local OrganizationName = Config["Organization Name"]
local Theme = Config.Theme









script.Parent.Events.SetPermBan.Event:Connect(function(UserID, Reason, Moderator)
	
	
	--// Get username \\
	local username
	
	local Username_Success, Username_Error = pcall(function()
		username = game:GetService('Players'):GetNameFromUserIdAsync(UserID)
	end)
	
	if not Username_Success then
		return warn("[!] BLUEBERRY: Username couldn't be found while trying to set temporary ban: " ..Username_Error.. "| Error code: 205")
	end


	
	
	local Success, Error = pcall(function()
		PermBanDataStore:SetAsync(UserID, {Reason, Moderator})
		local messagingService = game:GetService("MessagingService")
		messagingService:PublishAsync("Blueberry_PermBans", UserID)
	end)
	

	
	
	if Success then
		print("Permanent ban added: UserID; " ..UserID.. "; Reason; " ..Reason.."; Moderator; " ..Moderator)
		Log:Fire("User permanently banned", "A permanent ban was issued using Blueberry services. Moderated by **"..Moderator.."**."  , 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "User banned", username, "Reason", Reason, "New permanent ban log!")		
	end
	
	
	
	if not Success then
		warn("[!] BLUEBERRY: Error while trying to create permanent ban: " ..Error.. "| Error code: 191")
	end
	
	if game:GetService('Players'):FindFirstChild(username) then
		local toKick = game:GetService('Players'):FindFirstChild(username)
		
		
		
		
		
		script.Parent.Events.RemoveCharacter:Fire(toKick)
		
		
		--[[ Create GUI ]]--
		
		if Theme == 'light' then
		
			local GUI = script.Blueberry_PermBanned_Light:Clone()


			if UseCustomGUI == true then
				GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is now permanently banned from this experience."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			else

				GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is now permanently banned from this experience."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			end
			
			
		elseif Theme == 'dark' then
			local GUI = script.Blueberry_PermBanned_Dark:Clone()


			if UseCustomGUI == true then
				GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is now permanently banned from this experience."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			else

				GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is now permanently banned from this experience."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			end
			
			
					
			
		end	
		
			
			
		--[[ Auto-Kick ]]--	
		if AutoKick == true then
			wait(AutoKickDuration)
			toKick:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
		end


	else
		--// Do nothing
	end
	

	
end)










--[[ Kick on join ]]--

game:GetService('Players').PlayerAdded:Connect(function(joined)
	
	function localPermBan(player)
		local UserID = player.UserId


		local Data

		local Success, Value = pcall(function()
			Data =  PermBanDataStore:GetAsync(UserID)
		end)

		if Success and Data then

			local Reason = Data[1]
			local Moderator = Data[2]




			script.Parent.Events.RemoveCharacter:Fire(player)




			--[[ Create GUI ]]--

			if Theme == 'light' then

				local GUI = script.Blueberry_PermBanned_Light:Clone()


				if UseCustomGUI == true then
					GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is now permanently banned from this experience."

					local AClone = GUI:Clone()
					AClone.Parent = player.PlayerGui

					AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
					end)

					while wait(5) do
						if game:GetService('Players'):FindFirstChild(player.Name) then

							local BClone = GUI:Clone()
							BClone.Parent = player.PlayerGui
							BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
								player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
							end)
						else
							GUI:Destroy()
							break
						end
					end
				else

					GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is now permanently banned from this experience."


					local AClone = GUI:Clone()
					AClone.Parent = player.PlayerGui

					AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
					end)

					while wait(5) do
						if game:GetService('Players'):FindFirstChild(player.Name) then

							local BClone = GUI:Clone()
							BClone.Parent = player.PlayerGui
							BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
								player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
							end)
						else
							GUI:Destroy()
							break
						end
					end
				end


			elseif Theme == 'dark' then
				local GUI = script.Blueberry_PermBanned_Dark:Clone()


				if UseCustomGUI == true then
					GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is now permanently banned from this experience."


					local AClone = GUI:Clone()
					AClone.Parent = player.PlayerGui

					AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
					end)

					while wait(5) do
						if game:GetService('Players'):FindFirstChild(player.Name) then

							local BClone = GUI:Clone()
							BClone.Parent = player.PlayerGui
							BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
								player:Kick(" | [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
							end)
						else
							GUI:Destroy()
							break
						end
					end
				else

					GUI.Background.MainFrame.TitleFrame.Title.Text = "Permanently Banned"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is now permanently banned from this experience."


					local AClone = GUI:Clone()
					AClone.Parent = player.PlayerGui

					AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
					end)

					while wait(5) do
						if game:GetService('Players'):FindFirstChild(player.Name) then

							local BClone = GUI:Clone()
							BClone.Parent = player.PlayerGui
							BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
								player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
							end)
						else
							GUI:Destroy()
							break
						end
					end
				end
			end





			--[[ Auto-Kick ]]--	
			if AutoKick == true then
				wait(AutoKickDuration)
				player:Kick("| [PERMANENTLY BANNED] | Reason: " ..Reason.. " | -Blueberry")
			else
				--// Do nothing
			end



		end
	end
	
	
	
	-----
	localPermBan(joined)
		

end)





------------------------
--// MessagingService: inter-server connection
local messagingService = game:GetService("MessagingService")
messagingService:SubscribeAsync("Blueberry_PermBans", function(message)
	local targetName = game:GetService('Players'):GetNameFromUserIdAsync(message.Data) 
	print("[>] BLUEBERRY: Received ban request for " ..targetName)
	
	if game:GetService('Players'):FindFirstChild(targetName) then
		local user = game:GetService('Players'):FindFirstChild(targetName)
		localPermBan(user)
	end
	
end)




