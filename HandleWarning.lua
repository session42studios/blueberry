--[[ Variables ]]--

local Config = require(script.Parent.Parent:FindFirstChild("Settings"))
local API = require(script.Parent.API)
local Log = script.Parent.Events:FindFirstChild("Log")

local DataStoreService = game:GetService("DataStoreService")
local WarnDataStore = DataStoreService:GetDataStore("BB_WarnData")


local UseCustomGUI = Config["Use organization info"]
local OrganizationName = Config["Organization Name"]
local Theme = Config.Theme



--[[ Handler ]]--


script.Parent.Events.SetWarning.Event:Connect(function(UserID, Reason, Moderator)
	local Data
	
	
	--|| Set DataStore entry ||
	local Success, Error = pcall(function()
		Data = WarnDataStore:SetAsync(UserID, {Reason, Moderator})	
	end)
	
	
	local username = game:GetService('Players'):GetNameFromUserIdAsync(UserID)
	
	
	if Success then
		

		
		
		print("New warning set: UserID; " ..UserID.. "; Reason; " ..Reason.."; Moderator; " ..Moderator)
		Log:Fire("New warning issued", "A new warning was issued using Blueberry services. Warning issued by **" ..Moderator.."**.", 5814783, "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&username=" ..username, "Issued to", username, "Reason", Reason, "New warning log!")
	else
		warn("[!] BLUEBERRY: Error while saving warning data: " ..Error.. "| Error code: 191")
	end
	
	
	
	
	
	
	if Success then
		
		if game:GetService('Players'):FindFirstChild(username) then
			
			local player = game:GetService('Players'):FindFirstChild(username)
			
			
			if Theme == 'light' then

				local GUI = script.Blueberry_Warned_Light:Clone()


				if UseCustomGUI == true then
					GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..Config["Organization Name"].. " has been unproper. Your account was moderated and has received a warning."

					GUI.Parent = player.PlayerGui

					GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()

						API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
						GUI:Destroy()

					end)
				else

					GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and has received a warning."

					GUI.Parent = player.PlayerGui

					GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()

						API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
						GUI:Destroy()

					end)
				end


			elseif Theme == 'dark' then
				local GUI = script.Blueberry_Warned_Dark:Clone()


				if UseCustomGUI == true then
					GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..Config["Organization Name"].. " has been unproper. Your account was moderated and has received a warning."

					GUI.Parent = player.PlayerGui

					GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()

						API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
						GUI:Destroy()

					end)
				else

					GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
					GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
					GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and has received a warning."

					GUI.Parent = player.PlayerGui

					GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()

						API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
						GUI:Destroy()

					end)
				end


			end	


		end
	
		end

	
end)






--[[ Get on player join ]]--

game:GetService('Players').PlayerAdded:Connect(function(player)
	
	local UserID = player.UserId
	local Data
	local Success, Error = pcall(function()
		Data = WarnDataStore:GetAsync(player.UserId)
	end)
	
	
	
	
	if not Success then
		warn("[!] BLUEBERRY: Error while getting database info: " ..Error.. "| Error code: 191")
	end
	
	
	if Success and Data then
		
		
		local Reason = Data[1]
		local Moderator = Data[2]
		
		

		--[[ Create GUI ]]--


		if Theme == 'light' then

			local GUI = script.Blueberry_Warned_Light:Clone()


			if UseCustomGUI == true then
				GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..Config["Organization Name"].. " has been unproper. Your account was moderated and has received a warning."

				GUI.Parent = player.PlayerGui

				GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()

					API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
					GUI:Destroy()

				end)
			else

				GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and has received a warning."

				GUI.Parent = player.PlayerGui

				GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					
					API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
					GUI:Destroy()
					
				end)
			end


		elseif Theme == 'dark' then
			local GUI = script.Blueberry_Warned_Dark:Clone()


			if UseCustomGUI == true then
				GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..Config["Organization Name"].. " has been unproper. Your account was moderated and has received a warning."

				GUI.Parent = player.PlayerGui

				GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					
					API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
					GUI:Destroy()
					
				end)
			else

				GUI.Background.MainFrame.TitleFrame.Title.Text = "Account Warning"
				GUI.Background.MainFrame.ReasonCase.ReasonText.Text = Reason
				GUI.Background.MainFrame.Description.Text = "Our moderation team has determined that your behaviour at " ..game.Name.. " has been unproper. Your account was moderated and has received a warning."

				GUI.Parent = player.PlayerGui

				GUI.Background.MainFrame.LogOutButton.ClickButton.MouseButton1Click:Connect(function()
					
					API:removeWarning(player.Name, "Automatic warning removal: user accepted", "Blueberry Core")
					GUI:Destroy()
					
				end)
			end
			
			
		end	
		
		
		
		
		
	end
	
end)
