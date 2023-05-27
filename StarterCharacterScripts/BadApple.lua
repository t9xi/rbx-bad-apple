local data = require(game.ReplicatedStorage.data)

print('finished loading data')

local iris = require(game.ReplicatedStorage.Iris).Init(game.Players.LocalPlayer.PlayerGui)

local WIDTH = 28
local HEIGHT = 36

local prt = game.ReplicatedStorage.Part

function render(frameNum)
    local object = data[frameNum]
    for x = 1,WIDTH do
        local frameData = object[x]
        for y = 1,HEIGHT do
            local frame = frameData[y]
            local part = prt:Clone()
            part.Color = frame == 1 and Color3.new(1,1,1) or Color3.new(0,0,0)
            part.Position = Vector3.new(-y,-x + HEIGHT,0)
            part.Parent = workspace.Folder
        end
    end
end

local frameNum = 1
local fps = 12

iris:Connect(function()
    iris.Window({"Debug"})
    iris.Text({"Current frame: "..frameNum})
    iris.End()
end)

while true do
    render(frameNum)
    task.wait(1/12)
    frameNum += 1
end
