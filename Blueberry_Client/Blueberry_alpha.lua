

game:GetService('Players').LocalPlayer.PlayerGui.ChildRemoved:Connect(function(child)
	if child.Name == 'Blueberry_PermBanned_Dark' or child.Name == 'Blueberry_PermBanned_Light' or child.Name == 'Blueberry_TempBanned_Dark' or child.Name == 'Blueberry_TempBanned_Light' then  
		print('Detected. Terminating session for local player.')
		local success, serror = pcall(function()
			local EventsFolder = game:GetService('ReplicatedStorage'):FindFirstChild('Blueberry_Replicated'):FindFirstChild('Events')
			EventsFolder:FindFirstChild('Trigger'):FireServer('| [SECURITY KICK] | Session terminated: | You were detected trying to remove your punishment UI. For security reasons, you were removed from this server. | -Blueberry')
		end)
		
		if not success then
			game:GetService('Players').LocalPlayer:Kick('[SECURITY KICK] | Session terminated: | You were detected trying to remove your punishment UI. For security reasons, you were removed from this server. | -Blueberry')
		end
	end
end)
