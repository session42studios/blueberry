local DataStoreService = game:GetService("DataStoreService")
local BanStore = DataStoreService:GetDataStore("BB_TempBanDataStore")
local Config = require(script.Parent.Parent.Settings)
local Log = script.Parent.Events.Log

local AutoKick = Config["TempBan Auto-Kick"]
local AutoKickDuration = Config["TempBan Auto-Kick countdown"]
local UseCustomGUI = Config["Use organization info"]
local OrganizationName = Config["Organization Name"]
local Theme = Config.Theme







script.Parent.Events.SetTempBan.Event:Connect(function(UserID, Duration, Reason, Moderator)
	
	
	--// Get username \\
	local username
	
	local Username_Success, Username_Error = pcall(function()
		username = game:GetService('Players'):GetNameFromUserIdAsync(UserID)
	end)
	
	if not Username_Success then
		return warn("[!] BLUEBERRY: Username couldn't be found while trying to set temporary ban: " ..Username_Error.. "| Error code: 205")
	end


	
	

	
	local CurrentTime = os.time()
	local EndTime = CurrentTime + Duration
	
	
	local Success, Error = pcall(function()
		BanStore:SetAsync(UserID, {EndTime, Reason, Moderator})
		local messagingService = game:GetService("MessagingService")
		messagingService:PublishAsync("Blueberry_TempBans", UserID)
	end)
	
	
	local SecondsLeft = EndTime - os.time()
	local TimeLeft = math.floor((SecondsLeft/60) + 0.5)
	
	
	if Success then
		print("Temporary ban added: UserID; " ..UserID.. "; Reason; " ..Reason.."; Moderator; " ..Moderator.. "; Duration; ~" ..TimeLeft.." minutes")
		Log:Fire("User temporary banned", "A temporary ban was issued using Blueberry services. Duration of ban: `~"..TimeLeft.." minutes`. Moderated by **"..Moderator.."**."  , 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "User banned", username, "Reason", Reason, "New temporary ban log!")		
	end
	
	
	
	if not Success then
		warn("[!] BLUEBERRY: Error while trying to create temporary ban: " ..Error.. "| Error code: 191")
	end
	
	if game:GetService('Players'):FindFirstChild(username) then
		local toKick = game:GetService('Players'):FindFirstChild(username)
		
		
		
		
		
		script.Parent.Events.RemoveCharacter:Fire(toKick)
		
		
		--[[ Create GUI ]]--
		
		if Theme == 'light' then
		
			local GUI = script.Blueberry_TempBanned_Light:Clone()


			if UseCustomGUI == true then
				GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is temporary suspended."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			else

				GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is temporary suspended."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			end
			
			
		elseif Theme == 'dark' then
			local GUI = script.Blueberry_TempBanned_Dark:Clone()


			if UseCustomGUI == true then
				GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is temporary suspended."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)
					else
						GUI:Destroy()
						break
					end
				end
			else

				GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is temporary suspended."

				local AClone = GUI:Clone()
				AClone.Parent = toKick.PlayerGui

				AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
				end)

				while wait(5) do
					if game:GetService('Players'):FindFirstChild(toKick.Name) then

						local BClone = GUI:Clone()
						BClone.Parent = toKick.PlayerGui
						BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
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
			toKick:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | - Blueberry")
		end


	else
		--// Do nothing
	end
	

	
end)










--[[ Kick on join ]]--

game:GetService('Players').PlayerAdded:Connect(function(joined)
	
	function localTempBan(player)
	
		local UserID = player.UserId
		
		
		local Data
		
		local Success, Value = pcall(function()
			Data =  BanStore:GetAsync(UserID)
		end)
		
		if Success and Data then
			
			local EndTime = Data[1]
			local Reason = Data[2]
			
			
			
			if EndTime > os.time() then
				
				local SecondsLeft = EndTime - os.time()
				local TimeLeft = math.floor((SecondsLeft/60) + 0.5)
				
				
				
				--[[ Destroy Character ]] --
				script.Parent.Events.RemoveCharacter:Fire(player)
				
				
				
				--[[ Create GUI ]]--
				if Theme == 'light'  then

					local GUI = script.Blueberry_TempBanned_Light:Clone()


					if UseCustomGUI == true then
						GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
						GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
						GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is temporary suspended."

						local AClone = GUI:Clone()
						AClone.Parent = player.PlayerGui

						AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)

						while wait(5) do
							if game:GetService('Players'):FindFirstChild(player.Name) then

								local BClone = GUI:Clone()
								BClone.Parent = player.PlayerGui
								BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
									player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
								end)
							else
								GUI:Destroy()
								break
							end
						end
					else

						GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
						GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
						GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is temporary suspended."

						local AClone = GUI:Clone()
						AClone.Parent = player.PlayerGui

						AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)

						while wait(5) do
							if game:GetService('Players'):FindFirstChild(player.Name) then

								local BClone = GUI:Clone()
								BClone.Parent = player.PlayerGui
								BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
									player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
								end)
							else
								GUI:Destroy()
								break
							end
						end
					end


					
					
					
				else
					
					local GUI = script.Blueberry_TempBanned_Light:Clone()


					if UseCustomGUI == true then
						GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
						GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
						GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..OrganizationName.. " has been unproper. Your account was moderated and is temporary suspended."

						local AClone = GUI:Clone()
						AClone.Parent = player.PlayerGui

						AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)

						while wait(5) do
							if game:GetService('Players'):FindFirstChild(player.Name) then

								local BClone = GUI:Clone()
								BClone.Parent = player.PlayerGui
								BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
									player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
								end)
							else
								GUI:Destroy()
								break
							end
						end
					else

						GUI.Background.MainFrame.TitleFrame.Title.Text = "Banned for ~" ..TimeLeft.. " minutes"
						GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
						GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and is temporary suspended."

						local AClone = GUI:Clone()
						AClone.Parent = player.PlayerGui

						AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
							player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
						end)

						while wait(5) do
							if game:GetService('Players'):FindFirstChild(player.Name) then

								local BClone = GUI:Clone()
								BClone.Parent = player.PlayerGui
								BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
									player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason.. " | -Blueberry")
								end)
							else
								GUI:Destroy()
								break
							end
						end
					end
					
					
				end	
				
				
				
				
				--[[ Auto-Kick ]]
				
				if AutoKick == true then
					wait(AutoKickDuration)
					player:Kick("| [TEMPORARY BANNED] | Time left: ~ " ..TimeLeft.. " minutes | Reason: " ..Reason)
				end

				
			elseif EndTime <= os.time() then
				
				--// Duration ended
				BanStore:RemoveAsync(UserID)
			end
			
		end
	end
	
	
	-----
	localTempBan(joined)
end)




------------------------
--// MessagingService: inter-server connection
local messagingService = game:GetService("MessagingService")
messagingService:SubscribeAsync("Blueberry_TempBans", function(message)
	local targetName = game:GetService('Players'):GetNameFromUserIdAsync(message.Data) 
	print("[>] BLUEBERRY: Received temporary ban request for " ..targetName)

	if game:GetService('Players'):FindFirstChild(targetName) then
		local user = game:GetService('Players'):FindFirstChild(targetName)
		localTempBan(user)
	end

end)

