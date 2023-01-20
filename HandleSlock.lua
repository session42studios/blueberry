local Config = require(script.Parent.Parent.Settings)
local AutoKick = Config["Slock Auto-Kick"]
local AutoKick_Time = Config["Slock Auto-Kick countdown"]
local Log = script.Parent.Events.Log
local Theme = Config.Theme
local UseCustomGUI = Config["Use organization info"]
local AutoKickDuration = Config["Slock Auto-Kick countdown"]

local IS_LOCKED = false
local Group_ID
local Min_Rank
local Moderator
local Reason


script.Parent.Events.SetSlock.Event:Connect(function(value, groupID, min_rank, moderator, reason)
	
	if value == true then
		-------------------------------
		
		IS_LOCKED = true
		Group_ID = groupID
		Min_Rank = min_rank
		Moderator = moderator
		Reason = reason
		print("[*] BLUEBERRY: Server locked for players with the rank below " ..Min_Rank.." with reason: " ..Reason)

		-------------------------------
	elseif value == false then
		-------------------------------

		IS_LOCKED = false
		Group_ID = nil
		Min_Rank = nil
		Moderator = nil
		Reason = nil
		print("[*] BLUEBERRY: Server unlocked")

		-------------------------------
	end
	
end)

game:GetService('Players').PlayerAdded:Connect(function(player)
	if IS_LOCKED == true then
		------------
		if player:GetRankInGroup(Group_ID) >= Min_Rank then
			--// Player can join
		elseif player:GetRankInGroup(Group_ID) < Min_Rank then
			
			
			script.Parent.Events.RemoveCharacter:Fire(player)
			
			--[[ Create GUI ]]--

			if Theme == 'light' then

				local GUI = script.Blueberry_Slocked_Light:Clone()


					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason

					local AClone = GUI:Clone()
					AClone.Parent = player.PlayerGui

					AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [SERVER LOCKED] | Reason: " ..Reason.. " | -Blueberry")
					end)

					while wait(5) do
					if game:GetService('Players'):FindFirstChild(player.Name) then

							local BClone = GUI:Clone()
							BClone.Parent = player.PlayerGui
							BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
								player:Kick("| [SERVER LOCKED] | Reason: " ..Reason.. " | -Blueberry")
							end)
						else
							GUI:Destroy()
							break
						end
					end



			elseif Theme == 'dark' then
				local GUI = script.Blueberry_Slocked_Dark:Clone()


					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason

					local AClone = GUI:Clone()
					AClone.Parent = player.PlayerGui

					AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [SERVER LOCKED] | Reason: " ..Reason.. " | -Blueberry")
					end)

					while wait(5) do
					if game:GetService('Players'):FindFirstChild(player.Name) then

							local BClone = GUI:Clone()
							BClone.Parent = player.PlayerGui
							BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
								player:Kick("| [SERVER LOCKED] | Reason: " ..Reason.. " | -Blueberry")
							end)
						else
							GUI:Destroy()
							break
						end
					end
----------------------
			end	
			
			
			
			--[[ Auto-Kick ]]--	
			if AutoKick == true then
				wait(AutoKickDuration)
				player:Kick("| [SERVER LOCKED] | Reason: " ..Reason.. " | -Blueberry")
			end
			
			
			
			
			
			
			
			
			
			
			
		end
		------------
	else
		--// Server not locked
	end

end)
