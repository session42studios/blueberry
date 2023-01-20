local Config = require(script.Parent.Parent.Settings)
local HttpService = game:GetService("HttpService")






Wehbook = Config["Discord Webhook URL"]




script.Parent.Events.Log.Event:Connect(function(title, description, color_code, image_link, field1title, field1value, field2title, field2value, content)
	

	if Config["Use Discord Logging"] == false then
		
	elseif Config["Use Discord Logging"] == true then
		
				
		
		
		
		
		local data = 
			{
				["content"] = content; -- Content: Message above the title.
				["embeds"] = {{
					["title"] = title; -- The title of the message.
					["description"] = description; -- Description of the message, under the title.
					["color"] = color_code; -- Hex color code, currently set to red.
					["tts"] = false; -- Can someone use the discord feature: text to speach with your message.
					["url"] = ""; -- Same as with author's url, but this one only connects to the title of the whole message.
					["thumbnail"] = {
						["url"] = image_link;
					};
					["footer"] = { -- Again, has to be stored as a table.
						["text"] = "· BLUEBERRY";
						["icon_url"] = "https://media.discordapp.net/attachments/897089045316919347/945395566538534942/icon_2.png?width=551&height=551"; -- The image icon you want your footer to have
					};
					["timestamp"] = DateTime.now():ToIsoDate(); -- Will add the date, and the time to the message, not regular to discord.
					["fields"] = { -- Make a table
						{ -- now make a new one for each field you wish to add
							["name"] = field1title;
							["value"] = field1value; -- The text,value or information under the title of the field aka name.
							["inline"] = false; -- means that its either inline with others, from left to right or if it is set to false, from up to down.
						},
						{ -- now make a new one for each field you wish to add
							["name"] = field2title;
							["value"] = field2value; -- The text,value or information under the title of the field aka name.
							["inline"] = false; -- means that its either inline with others, from left to right or if it is set to false, from up to down.
						}
					}
				}}
			}
		
		
		local HTTP_success, HTTP_error = pcall(function()
			
			local finaldata = HttpService:JSONEncode(data) -- JSONEncode the whole table you just made, make sure it's not "JSONDeCode"

			HttpService:PostAsync(Wehbook, finaldata) -- Finally, post the message when its fitting for you, for me its everytime that the script runs which is when i click play. Firstly, add the webhook or the webhook variable, then the finaldata.
			
		end)
		
		if not HTTP_success then
			warn("[!] BLUEBERRY: There was an erro while trying to post the webhook. Make sure HTTP requests are enabled in game settings. Error: " ..HTTP_error.. "| Error code: 102")
		end
		
		

		
		
		
	else
		
		
		
		
		
	end
	
	
	
	

end)
