local Config = require(script.Parent.Parent.Settings)
local AutoKick = Config["Kicking Auto-Kick"]
local AutoKick_Time = Config["Kicking Auto-Kick countdown"]
local Log = script.Parent.Events.Log
local Theme = Config.Theme
local UseCustomGUI = Config["Use organization info"]
local AutoKickDuration = Config["Kicking Auto-Kick"]


script.Parent.Events.SetKick.Event:Connect(function(player, Reason, moderator)
	print("[*] BLUEBERRY: got kick request for " ..player.Name.." with reason "..Reason)
	if player then
		
		script.Parent.Events.RemoveCharacter:Fire(player)

		--[[ Create GUI ]]--

		if Theme == 'light' then

			local GUI = script.Blueberry_Kicked_Light:Clone()


			GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason

			local AClone = GUI:Clone()
			AClone.Parent = player.PlayerGui

			AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
				player:Kick("| [KICKED] | You have been removed from this server, but you can join back. | Reason: " ..Reason.. " | -Blueberry")
			end)

			while wait(5) do
				if game:GetService('Players'):FindFirstChild(player.Name) then

					local BClone = GUI:Clone()
					BClone.Parent = player.PlayerGui
					BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [KICKED] | You have been removed from this server, but you can join back. | Reason: " ..Reason.. " | -Blueberry")
					end)
				else
					GUI:Destroy()
					break
				end
			end



		elseif Theme == 'dark' then
			local GUI = script.Blueberry_Kicked_Dark:Clone()


			GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason

			local AClone = GUI:Clone()
			AClone.Parent = player.PlayerGui

			AClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
				player:Kick("| [KICKED] | You have been removed from this server, but you can join back. | Reason: " ..Reason.. " | -Blueberry")
			end)

			while wait(5) do
				if game:GetService('Players'):FindFirstChild(player.Name) then

					local BClone = GUI:Clone()
					BClone.Parent = player.PlayerGui
					BClone.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
						player:Kick("| [KICKED] | You have been removed from this server, but you can join back. | Reason: " ..Reason.. " | -Blueberry")
					end)
				else
					GUI:Destroy()
					break
				end
			end
		end
		
		--[[ Auto-Kick ]]--	
		if AutoKick == true then
			wait(AutoKickDuration)
			player:Kick("| [KICKED] | You have been removed from this server, but you can join back. | Reason: " ..Reason.. " | -Blueberry")
		end
		
		
		
		----------------------------
		
		
	end
end)

