local ChatService = require(game:GetService("ServerScriptService"):WaitForChild("ChatServiceRunner").ChatService)
local channel = ChatService:GetChannel("ALL")


script.Parent.Events.RemoveCharacter.Event:Connect(function(player)
	print('[*] BLUEBERRY: Trying to find character for ' ..player.Name.. '...')
	local Character = player.Character or player.CharacterAdded:Wait()
	print('[*] BLUEBERRY: Found character for ' ..player.Name.. '. Destroying in 2 seconds...')
	wait(2)

	local success, issue = pcall(function()
		Character:Destroy()

		-- somewhere else in your code
		channel:MuteSpeaker(player.Name)
	end)
	if success then
		print('[*] BLUEBERRY: Success! Suspect character destroyed. Player has been muted.')
		
		local loop_success, loop_error = pcall(function()
			while wait(3) do
				if Character then
					Character:Destroy()
				else
					--Character doesn't exist/it is deleted already.
				end
			end
		end)
	else
		warn('[!] BLUEBERRY: Error occured while trying to destroy and mute player and its character. Re-triggering event... Error: ' ..issue.. "| Error code: 160")
		script.Parent.Events.RemoveCharacter:Fire(player)
	end
	
end)







