-- Grow a Garden --
local _Ws = game:GetService("Workspace")
local _Plrs = game:GetService("Players")
local _Rls = game:GetService("ReplicatedStorage")
local _Rs = game:GetService("RunService")
local _CG = game:GetService("CoreGui")
local _Db = game:GetService("Debris")
local _If = _Ws:WaitForChild("Farm")
local _plr = _Plrs.LocalPlayer
local _camsb = _Ws.CurrentCamera
local _rstepped = _Rs.RenderStepped
local _GameEvents = _Rls.GameEvents

local _SG = Instance.new("ScreenGui", _CG)
local _QHarvest = Instance.new("TextButton", _SG)
local _Data, _Important, _PhysicalFolder, _Farm, _Mid
local _v3_Inf = Vector3.new(math.huge, math.huge, math.huge)
local _v3_Zero = Vector3.new(0, 0, 0)
local _Fruits = {}
local Prefix, Debounce, _dp, IsOn

Prefix = "+"
Debounce = 0.25
_dp = true
IsOn = false

function _GetFarm()
    for a, b in pairs(_If:GetDescendants()) do
        if b:IsA("StringValue") and b.Name == "Owner" and b.Value == _plr.Name then
            return b
        end
    end
end

function _pr(str)
    if _dp or _dp == true then
        print(str)
    end
end

function _OnChattedCMDS(str)
    local Zero = string.split(str, " ")
    if Zero[1] == Prefix .. "prefix" and Zero[2] then
        Prefix = Zero[2]
        _pr("[prefix-changed]: to " .. Zero[2])
    elseif Zero[1] == Prefix .. "delay" or Zero[1] == Prefix .. "debounce" and Zero[2] then
        Debounce = tonumber(Zero[2]) or Zero[2]
        _pr("[harvest-d-changed]: to " .. Zero[2])
    elseif Zero[1] == Prefix .. "debug-_pr" or Zero[1] == Prefix .. "dp" then
        if not _dp then
            _dp = true
        else
            _dp = false
        end
    else
        _pr("[ngl]: i dunno what are u saying...")
    end
end

function _AddUIC(Target, Radius)
    local NewUIC = Instance.new("UICorner", Target)
    NewUIC.CornerRadius = UDim.new(Radius, 0)
end

function _MB1C(N, script)
    N.MouseButton1Click:Connect(function()
        local s, err = pcall(script)
        if s then
            _pr("[ngl]: no error!")
        else
            _pr("[error-ngl]: " .. err)
        end
    end)
end

_SG.Name = "ShadowGarden"
_QHarvest.Name = "QuickHarvest"
_Data = _GetFarm().Parent
_Important = _Data.Parent
_PhysicalFolder = _Important:WaitForChild("Plants_Physical")
_Farm = _Important.Parent
_Mid = _Farm:FindFirstChild("Center_Point")

_QHarvest.BackgroundColor3 = Color3.new(0, 0, 0)
_QHarvest.BackgroundTransparency = 0.5
_QHarvest.Position = UDim2.new(0.3, 0, 0.6, 0)
_QHarvest.Size = UDim2.new(0.05, 0, 0.1, 0)
_QHarvest.TextScaled = true
_QHarvest.TextColor3 = Color3.new(1, 1, 1)
_QHarvest.Font = Enum.Font.Code
_QHarvest.Text = "Harvest"
_QHarvest.Visible = true
_AddUIC(_QHarvest, 0.2)

function _AddFruits()
    for a, b in pairs(_PhysicalFolder:GetDescendants()) do
        if b:IsA("Part") then -- and b.Name == "2"
            for c, d in pairs(b:GetChildren()) do
                if d:IsA("ProximityPrompt") then
                    table.insert(_Fruits, b)
                end
            end
        end
    end
end

function _Harvest(w)
    _AddFruits()
    for i = 1, #_Fruits do
        local _IFruits = _Fruits[i]
        if _IFruits:IsA("Part") then
            if _IFruits:FindFirstChild("ProximityPrompt") then
                local _Proximity = _IFruits:FindFirstChild("ProximityPrompt")
                _plr.Character:SetPrimaryPartCFrame(_IFruits.CFrame)
                task.wait(w)
                if (_plr.Character.HumanoidRootPart.Position - _IFruits.Position).magnitude <= 5 then
                    fireproximityprompt(_Proximity)
                else
                    _pr("[ngl]: you're not closed to the fruit...")
                end
            else
                _pr("[ngl]: its missing pp, normaly this message will be not shown =)).")
            end
        else
            _pr("[ngl]: found smth weird!")
        end
    end
    Blox = false
    _Fruits = {}
end

function _ClipThrough(_s)
    for a, b in pairs(_plr.Character:GetDescendants()) do
        if b:IsA("BasePart") then
            if _s == "y" then
                b.CanCollide = false
            elseif _s == "n" then
                b.CanCollide = true
            end
        end
    end
end

function _BVelocity(_s)
    if _s == "y" then
        if _plr.Character and _plr.Character:FindFirstChild("HumanoidRootPart") then
            if not _plr.Character.HumanoidRootPart:FindFirstChild("_Float") then
                local _PrHRP = _plr.Character.HumanoidRootPart
                local _Bv = Instance.new("BodyVelocity", _PrHRP)
                _Bv.Name = "_Float"
                _Bv.MaxForce = _v3_Inf
                _Bv.Velocity = _v3_Zero
            else
                _pr("[ngl]: already exist a _Bv.")
            end
        else
            _pr("[ngl]: no hrp!")
        end
    elseif _s == "n" then
        if _plr.Character and _plr.Character:FindFirstChild("HumanoidRootPart") then
            if _plr.Character.HumanoidRootPart:FindFirstChild("_Float") then
                local _DbItem = _plr.Character.HumanoidRootPart:FindFirstChild("_Float")
                _Db:AddItem(_DbItem, 0.01)
            else
                _pr("[ngl]: im not founded a _Bv.")
            end
        else
            _pr("[ngl]: no hrp")
        end
    end
end

--_Harvest(0.2)
_MB1C(_QHarvest, function()
    if IsOn then
        IsOn = false
        IsRun = false
        Blox = false
        _Fruits = {}
        _ClipThrough("n")
        _BVelocity("n")
        _camsb.CameraSubject = _plr.Character:FindFirstChild("Humanoid")
        _QHarvest.Text = "Harvest"
        _QHarvest.TextColor3 = Color3.new(1, 1, 1)
        _plr.Character:SetPrimaryPartCFrame(CFrame.new(87, 3, 0))
        task.wait(Debounce)
        _GameEvents.Sell_Inventory:FireServer()
    else
        IsOn = true
        _ClipThrough("y")
        _BVelocity("y")
        _QHarvest.TextColor3 = Color3.new(0, 1, 0)
        _camsb.CameraSubject = _Mid
        _Harvest(Debounce)
        _QHarvest.Text = "Sell"
        _QHarvest.TextColor3 = Color3.new(1, 0, 0)
    end
end)

_plr.Chatted:Connect(_OnChattedCMDS)
