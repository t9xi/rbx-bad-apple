-- Services
local RunS = game:GetService("RunService")

-- Iris library requires
local iris = require(game.ReplicatedStorage.Iris).Init(game.Players.LocalPlayer.PlayerGui)

-- Property for the frame data itself
local data

-- Render properties
local WIDTH = 28
local HEIGHT = 36
local SCALE = 0.25

-- FPS properties
local FPS = 30

-- Properties for part & the array of parts used for visualization
local prt = game.ReplicatedStorage.Part
local prtArray = {};

-- Properties for current frame & frametime
local frameNum = 1
local frameTime = 0

-- Function to round number to certain amount of decimals
function roundNum(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- Update the parts
function render(frameNum)
	-- Object data based on frame
	local object = data[frameNum]
	
	-- Go through the width
	for x = 1,WIDTH do
		-- Get frame data
		local frameData = object[x]
		
		-- Go through the height
		for y = 1,HEIGHT do
			-- Get frame & part 
			local frame = frameData[y]
			local part = prtArray[((x - 1) * HEIGHT) + y]
			
			-- Update the color
			part.Color = Color3.new(frame,frame,frame)
		end
	end
end

-- Generate the parts
function generateParts()
	-- Part count & object data
	local count = 0
	local object = data[1]
	
	-- Go through the width
	for x = 1,WIDTH do
		-- Get frame data
		local frameData = object[x]
		
		-- Go through the height
		for y = 1,HEIGHT do
			-- Get frame & create part 
			local frame = frameData[y]
			local part = prt:Clone()

			-- Set part properties
			part.Color = Color3.new(frame,frame,frame)
			part.Position = Vector3.new(-y * SCALE,(-x + HEIGHT) * SCALE,0)
			part.Size = Vector3.new(1 * SCALE, 1 * SCALE, 1 * SCALE)
			part.Parent = workspace.Folder
			
			-- Set part to a specific point in array
			prtArray[((x - 1) * HEIGHT) + y] = part
			
			-- Slow down the creation in case of performance issues
			count += 1
			if (count % 50 == 0) then
				task.wait()
			end
        end
    end
end

-- Create a window and update it
iris:Connect(function()
    iris.Window({"Debug"})
	iris.Text({"Current frame: "..frameNum})
	iris.Text({"Current frametime: "..roundNum(frameTime, 3)})
	iris.Text({"Current FPS: "..roundNum(1 / frameTime, 3)})
    iris.End()
end)

-- Get the data
data = require(game.ReplicatedStorage.data)

-- Wait for the data to actually load
repeat 
	task.wait(.1)
until data ~= nil

-- Generate the parts before actually starting the Bad Apple
generateParts();

-- Get current starting tick
local t = os.clock()
local waitTime = 1/FPS

task.spawn(function()
	while true do
		-- Wait until next frame
		task.wait(waitTime + (waitTime - frameTime))
		
		-- Render frame based on current frame
		render(frameNum)

		-- Go to next frame
		frameNum += 1
		if (frameNum >= #data) then
			frameNum = 1
		end
		
		-- Get frametime & update tick
		frameTime = os.clock() - t
		t = os.clock()
	end
end)
