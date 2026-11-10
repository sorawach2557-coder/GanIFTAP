-- ============================================
-- TIMER
-- ============================================
local _startTime = tick()

-- ============================================
-- THEME
-- ============================================
local MatrixRed = {
	TextColor = Color3.fromRGB(138, 12, 12),
	Background = Color3.fromRGB(0, 0, 0),
	Topbar = Color3.fromRGB(0, 0, 0),
	Shadow = Color3.fromRGB(255, 0, 0),
	TabBackground = Color3.fromRGB(0, 0, 0),
	TabStroke = Color3.fromRGB(255, 0, 0),
	TabBackgroundSelected = Color3.fromRGB(255, 0, 0),
	TabTextColor = Color3.fromRGB(255, 0, 0),
	SelectedTabTextColor = Color3.fromRGB(0, 0, 0),
	ElementBackground = Color3.fromRGB(0, 0, 0),
	ElementBackgroundHover = Color3.fromRGB(50, 0, 0),
	SecondaryElementBackground = Color3.fromRGB(0, 0, 0),
	ElementStroke = Color3.fromRGB(255, 0, 0),
	SecondaryElementStroke = Color3.fromRGB(255, 0, 0),
	SliderBackground = Color3.fromRGB(0, 0, 0),
	SliderProgress = Color3.fromRGB(0, 0, 0),
	SliderStroke = Color3.fromRGB(255, 0, 0),
	ToggleBackground = Color3.fromRGB(40, 0, 0),
	ToggleEnabled = Color3.fromRGB(205, 0, 0),
	ToggleDisabled = Color3.fromRGB(23, 0, 0),
	ToggleEnabledStroke = Color3.fromRGB(0, 0, 0),
	ToggleDisabledStroke = Color3.fromRGB(0, 0, 0),
	ToggleEnabledOuterStroke = Color3.fromRGB(255, 0, 0),
	ToggleDisabledOuterStroke = Color3.fromRGB(100, 0, 0),
	DropdownSelected = Color3.fromRGB(50, 0, 0),
	DropdownUnselected = Color3.fromRGB(20, 0, 0),
	InputBackground = Color3.fromRGB(0, 0, 0),
	InputStroke = Color3.fromRGB(255, 0, 0),
	PlaceholderColor = Color3.fromRGB(255, 0, 0),
}

-- ============================================
-- SERVICES
-- ============================================
local Workspace        = game:GetService("Workspace")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris           = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

-- ============================================
-- TPWALK
-- ============================================
local function UpdateTPWalk()
	if TPWalk_Conn then
		TPWalk_Conn:Disconnect()
		TPWalk_Conn = nil
	end
	if not TPWalk_Enabled then return end

	TPWalk_Conn = RunService.Heartbeat:Connect(function(dt)
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if hum.MoveDirection.Magnitude <= 0 then return end

		local step = TPWalk_Studs * (dt * 60)
		hrp.CFrame = hrp.CFrame + hum.MoveDirection * step
	end)
end

-- ============================================
-- GRAVITY
-- ============================================
local function applyGravity()
	if GravityEnabled then
		Workspace.Gravity = GravityValue
	else
		Workspace.Gravity = GravityDefault
	end
end

task.defer(function()
	task.wait(0.2)
	GravityDefault = Workspace.Gravity
	GravityValue   = GravityDefault
end)

-- ============================================
-- FOV CAMERA
-- ============================================
local function applyFov()
	if FovCameraEnabled then
		Camera.FieldOfView = FovCameraValue
	else
		Camera.FieldOfView = FovCameraDefault
	end
end

local function startFovLock()
	if FovCameraConn then return end
	FovCameraConn = RunService.RenderStepped:Connect(function()
		if not FovCameraEnabled then return end
		if Camera.FieldOfView ~= FovCameraValue then
			Camera.FieldOfView = FovCameraValue
		end
	end)
end

local function stopFovLock()
	if FovCameraConn then
		FovCameraConn:Disconnect()
		FovCameraConn = nil
	end
end

task.defer(function()
	task.wait(0.2)
	FovCameraDefault = Camera.FieldOfView
	FovCameraValue   = FovCameraDefault
end)

-- ============================================
-- RAYFIELD
-- ============================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Gan v 1.0.9 I FTAP",
	Icon = "box",
	LoadingTitle = "Loading library",
	LoadingSubtitle = "by NotPerson",
	ShowText = "Rayfield",
	Theme = MatrixRed,
	ToggleUIKeybind = "K",
	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "GanFolder",
		FileName = "GanFile"
	},
	Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },
	KeySystem = false,
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided",
		FileName = "Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"Hello"}
	}
})

Rayfield:Notify({ Title = "Gan I Loaded", Content = "Script Loaded", Duration = 6.5, Image = "check" })
local _loadTime = string.format("%.2fs", tick() - _startTime)
Rayfield:Notify({ Title = "Gan I Loaded", Content = "Script Loaded In " .. _loadTime, Duration = 6.5, Image = "timer" })

-- ============================================
-- TABS
-- ============================================

-- ============================================
-- STATE
-- ============================================
local _isReady = false

-- TPWalk
local TPWalk_Enabled = false
local TPWalk_Studs   = 1.0
local TPWalk_Conn    = nil

-- Inf Jump
local InfJumpEnabled      = false
local InfJumpCurrentMode  = "Hold Jump"
local InfJumpModeOptions  = {"Hold Jump", "Jump Once"}

-- Noclip
local NoclipEnabled    = false
local NoclipConnection = nil

-- Fly
local FlyEnabled = false
local FlySpeed   = 16
local bodyGyro, bodyVelocity
local flyConnection = nil

-- Walk Water
local WaterWalkEnabled = false
local WaterWalkConn    = nil
local OceanModel       = nil
local WaterWalkPlat    = nil

-- Gravity
local GravityEnabled = false
local GravityValue   = 196.2
local GravityDefault = 196.2

-- FOV Camera
local FovCameraEnabled = false
local FovCameraValue   = 70
local FovCameraDefault = 70
local FovCameraConn    = nil

-- Third Person
local ThirdPersonEnabled     = false
local ThirdPersonMaxZoom     = 99999
local ThirdPersonDefaultMax  = 0.5
local ThirdPersonDefaultMode = Enum.CameraMode.LockFirstPerson
local ThirdPersonConn        = nil

-- Climb Wall
local ClimbWallEnabled     = false
local ClimbWallOptions     = {"Auto Climb", "Jump Wall", "Monkey Climb Wall"}
local ClimbWallCurrentMode = "Auto Climb"
local ClimbWallConn        = nil
local ClimbWallJumpConn    = nil
local CLIMB_SPEED          = 40
local JUMP_WALL_FORCE      = 60
local MONKEY_STACK_HEIGHT  = 5
local MONKEY_TOP_BOOST     = 60
local MonkeyClimbStuck     = false
local MonkeyWallNormal     = Vector3.zero

      -- Tab Name                        - Icon https://lucide.dev/icons/
local PlayerTab      = Window:CreateTab("Player", "user-2")
local AntiTab        = Window:CreateTab("Defense", "shield")
local CombatTab     = Window:CreateTab("Combat", "swords")

PlayerTab:CreateDivider()
PlayerTab:CreateSection("Movement")

-- ---------- Walkspeed ----------
PlayerTab:CreateToggle({
	Name = "Walkspeed",
	CurrentValue = false,
	Flag = "Walkspeed_Toggle",
	IgnoreLoad = true,
	Callback = function(Value)
		TPWalk_Enabled = Value
		UpdateTPWalk()
	end,
})

PlayerTab:CreateSlider({
	Name = "Setting Walkspeed",
	Range = {0.1, 10},
	Increment = 0.1,
	Suffix = "speed",
	CurrentValue = 1,
	Flag = "SliderWalkspeed",
	IgnoreLoad = true,
	Callback = function(Value) TPWalk_Studs = Value end,
})

PlayerTab:CreateParagraph({ Title = "Walkspeed Guide", Content = "0.1 = 1 per Tpwalk" })

-- ---------- Noclip ----------
local function SetNoclip(character)
	if not character then return end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end

PlayerTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "NoclipToggle",
	Callback = function(Value)
		NoclipEnabled = Value
		if NoclipEnabled then
			if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end
			NoclipConnection = RunService.Stepped:Connect(function()
				if NoclipEnabled and LocalPlayer.Character then
					SetNoclip(LocalPlayer.Character)
				end
			end)
		else
			if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end
		end
	end,
})

-- ============================================
-- INF JUMP
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode ~= Enum.KeyCode.Space then return end
    if not InfJumpEnabled then return end
    if InfJumpCurrentMode ~= "Jump Once" then return end

    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

RunService.RenderStepped:Connect(function()
    if not InfJumpEnabled then return end
    if InfJumpCurrentMode ~= "Hold Jump" then return end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

PlayerTab:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value) InfJumpEnabled = Value end,
})

PlayerTab:CreateDropdown({
    Name = "Select Mode Inf Jump",
    Options = InfJumpModeOptions,
    CurrentOption = InfJumpCurrentMode,
    MultipleOptions = false,
    Flag = "InfJumpMode",
    Callback = function(Mode)
        if type(Mode) == "table" then
            InfJumpCurrentMode = Mode.Value or Mode[1] or "Jump Once"
        else
            InfJumpCurrentMode = tostring(Mode)
        end
        if not _isReady then return end
        Rayfield:Notify({ Title = "Gan Notify I Player Infjump", Content = "Select " .. InfJumpCurrentMode, Duration = 6.5, Image = "mouse-pointer-2-off" })
    end,
})

-- ---------- Fly ----------
local function UpdateFlyState(enabled)
	local character = LocalPlayer.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoidRootPart or not humanoid then return end

	if enabled then
		humanoid.PlatformStand = true

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = humanoidRootPart.CFrame
		bodyGyro.Parent = humanoidRootPart

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = humanoidRootPart

		if flyConnection then flyConnection:Disconnect(); flyConnection = nil end

		flyConnection = RunService.RenderStepped:Connect(function()
			if not FlyEnabled or not character.Parent then return end
			local camCF = Camera.CFrame
			local moveDir = Vector3.zero

			if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then moveDir = moveDir + camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then moveDir = moveDir - camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then moveDir = moveDir - camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then moveDir = moveDir + camCF.RightVector end

			bodyGyro.CFrame = camCF
			if moveDir.Magnitude > 0 then
				bodyVelocity.Velocity = moveDir.Unit * FlySpeed
			else
				bodyVelocity.Velocity = Vector3.zero
			end
		end)
	else
		humanoid.PlatformStand = false
		if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
		if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
		if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	FlyEnabled = false
	UpdateFlyState(false)
end)

PlayerTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(Value)
		FlyEnabled = Value
		UpdateFlyState(FlyEnabled)
	end,
})

PlayerTab:CreateSlider({
	Name = "Custom Fly speed",
	Range = {16, 300},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Flag = "FlyCustomSpeed",
	Callback = function(Value) FlySpeed = Value end,
})

PlayerTab:CreateSection("Advanced Movement")

-- ============================================
-- WALK WATER
-- ============================================
local function refreshOceanRef()
	local map = Workspace:FindFirstChild("Map")
	if not map then return nil end
	local always = map:FindFirstChild("AlwaysHereTweenedObjects")
	if not always then return nil end
	return always:FindFirstChild("Ocean")
end

local function getOceanSurfaceY(hrp)
	OceanModel = refreshOceanRef()
	if not OceanModel then return nil end

	if OceanModel:IsA("BasePart") then
		local rel = OceanModel.CFrame:PointToObjectSpace(hrp.Position)
		if math.abs(rel.X) <= OceanModel.Size.X * 0.5 + 6
		and math.abs(rel.Z) <= OceanModel.Size.Z * 0.5 + 6 then
			return OceanModel.Position.Y + OceanModel.Size.Y * 0.5
		end
		return nil
	end

	local bestY = nil
	for _, v in ipairs(OceanModel:GetDescendants()) do
		if v:IsA("BasePart") then
			local rel = v.CFrame:PointToObjectSpace(hrp.Position)
			if math.abs(rel.X) <= v.Size.X * 0.5 + 6 and math.abs(rel.Z) <= v.Size.Z * 0.5 + 6 then
				local topY = v.Position.Y + v.Size.Y * 0.5
				if hrp.Position.Y >= topY - 10 then
					if not bestY or topY > bestY then bestY = topY end
				end
			end
		end
	end
	return bestY
end

local function destroyWaterPlatform()
	if WaterWalkPlat then WaterWalkPlat:Destroy(); WaterWalkPlat = nil end
end

local function createWaterPlatform()
	if WaterWalkPlat and WaterWalkPlat.Parent then return WaterWalkPlat end
	local part = Instance.new("Part")
	part.Name = "WaterWalkPlatform"
	part.Size = Vector3.new(10, 2, 10)
	part.Anchored = true
	part.CanCollide = true
	part.CanQuery = false
	part.CanTouch = false
	part.Transparency = 1
	part.Material = Enum.Material.SmoothPlastic
	part.Parent = Workspace
	WaterWalkPlat = part
	return part
end

local function stopWaterWalk()
	if WaterWalkConn then WaterWalkConn:Disconnect(); WaterWalkConn = nil end
	destroyWaterPlatform()
end

local function startWaterWalk()
	stopWaterWalk()
	WaterWalkConn = RunService.Stepped:Connect(function()
		if not WaterWalkEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not humanoid then return end

		local surfaceY = getOceanSurfaceY(hrp)
		if not surfaceY then destroyWaterPlatform(); return end

		local platform = createWaterPlatform()
		local targetY = surfaceY - 1
		local curY = platform.Position.Y
		local smoothY = curY + (targetY - curY) * 0.5
		platform.CFrame = CFrame.new(hrp.Position.X, smoothY, hrp.Position.Z)

		if hrp.Position.Y < surfaceY + 2 then
			hrp.CFrame = CFrame.new(hrp.Position.X, surfaceY + 3, hrp.Position.Z) * (hrp.CFrame - hrp.Position)
			hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
		end

		if humanoid:GetState() == Enum.HumanoidStateType.Swimming then
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end)
end

PlayerTab:CreateToggle({
	Name = "Walk Water",
	CurrentValue = false,
	Flag = "WalkWaterToggle",
	Callback = function(Value)
		WaterWalkEnabled = Value
		if Value then startWaterWalk() else stopWaterWalk() end
	end,
})

LocalPlayer.CharacterAdded:Connect(function(character)
	destroyWaterPlatform()
	if not WaterWalkEnabled then return end
	character:WaitForChild("HumanoidRootPart", 5)
	task.wait(0.1)
	if WaterWalkEnabled then startWaterWalk() end
end)

-- ============================================
-- GRAVITY UI
-- ============================================
PlayerTab:CreateToggle({
	Name = "Gravity",
	CurrentValue = false,
	Flag = "GravityToggle",
	Callback = function(Value)
		GravityEnabled = Value
		applyGravity()
		if not _isReady then return end
		Rayfield:Notify({
			Title = "Gan Notify I Gravity",
			Content = Value and ("Enabled (" .. GravityValue .. ")") or "Disabled",
			Duration = 5,
			Image = "move-vertical",
		})
	end,
})

PlayerTab:CreateSlider({
	Name = "Gravity Custom",
	Range = {0, 1000},
	Increment = 10,
	Suffix = "Force",
	CurrentValue = 196.2,
	Flag = "GravityCustomSlider",
	Callback = function(Value)
		GravityValue = Value
		if GravityEnabled then Workspace.Gravity = GravityValue end
	end,
})

-- ============================================
-- CLIMB WALL
-- ============================================
local function getWallAhead(hrp)
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.IgnoreWater = true
	local dir = hrp.CFrame.LookVector * 2.5
	local result = Workspace:Raycast(hrp.Position, dir, rayParams)
	if result and result.Instance:IsA("BasePart") and result.Instance.CanCollide then
		return result
	end
	return nil
end

local function stopClimbWall()
	if ClimbWallConn then ClimbWallConn:Disconnect(); ClimbWallConn = nil end
	if ClimbWallJumpConn then ClimbWallJumpConn:Disconnect(); ClimbWallJumpConn = nil end
	MonkeyClimbStuck = false
end

local function startClimbWall()
	stopClimbWall()

	ClimbWallConn = RunService.Heartbeat:Connect(function()
		if not ClimbWallEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not humanoid then return end

		if ClimbWallCurrentMode == "Auto Climb" then
			if humanoid.MoveDirection.Magnitude <= 0 then return end
			local wall = getWallAhead(hrp)
			if not wall then return end
			hrp.Velocity = Vector3.new(hrp.Velocity.X, CLIMB_SPEED, hrp.Velocity.Z)
			if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end

		elseif ClimbWallCurrentMode == "Monkey Climb Wall" then
			if MonkeyClimbStuck then
				local rayParams = RaycastParams.new()
				rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
				rayParams.FilterType = Enum.RaycastFilterType.Exclude
				rayParams.IgnoreWater = true
				local hit = Workspace:Raycast(hrp.Position, -MonkeyWallNormal * 3, rayParams)
				if hit and hit.Instance:IsA("BasePart") and hit.Instance.CanCollide then
					hrp.Velocity = Vector3.new(-MonkeyWallNormal.X * 2, math.max(hrp.Velocity.Y, -2), -MonkeyWallNormal.Z * 2)
				else
					MonkeyClimbStuck = false
				end
			end
		end
	end)

	ClimbWallJumpConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if not ClimbWallEnabled then return end
		if input.KeyCode ~= Enum.KeyCode.Space then return end

		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not humanoid then return end

		if ClimbWallCurrentMode == "Jump Wall" then
			local wall = getWallAhead(hrp)
			if not wall then return end
			hrp.Velocity = Vector3.new(hrp.Velocity.X, JUMP_WALL_FORCE, hrp.Velocity.Z)
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

		elseif ClimbWallCurrentMode == "Monkey Climb Wall" then
			if not MonkeyClimbStuck then
				local wall = getWallAhead(hrp)
				if wall then
					MonkeyClimbStuck = true
					MonkeyWallNormal = wall.Normal
					hrp.Velocity = Vector3.zero
				end
			else
				local jumpUp   = MONKEY_STACK_HEIGHT * 4
				local intoWall = 15
				hrp.Velocity = Vector3.new(-MonkeyWallNormal.X * intoWall, jumpUp, -MonkeyWallNormal.Z * intoWall)
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)
end

PlayerTab:CreateToggle({
	Name = "Climb Wall",
	CurrentValue = false,
	Flag = "ClimbWallToggle",
	Callback = function(Value)
		ClimbWallEnabled = Value
		if Value then startClimbWall() else stopClimbWall() end
	end,
})

PlayerTab:CreateDropdown({
	Name = "Select Mode Climb Wall",
	Options = ClimbWallOptions,
	CurrentOption = ClimbWallCurrentMode,
	MultipleOptions = false,
	Flag = "ClimbWallOptions",
	Callback = function(Mode)
		if type(Mode) == "table" then
			ClimbWallCurrentMode = Mode.Value or Mode[1] or "Auto Climb"
		else
			ClimbWallCurrentMode = tostring(Mode)
		end
		MonkeyClimbStuck = false
		if ClimbWallEnabled then startClimbWall() end
		if not _isReady then return end
		Rayfield:Notify({ Title = "Gan Notify I Player Climb Wall", Content = "Select Mode Climb Wall " .. ClimbWallCurrentMode, Duration = 6.5, Image = "check" })
	end,
})

PlayerTab:CreateSlider({
	Name = "Climb Wall Speed (Auto)",
	Range = {5, 200},
	Increment = 5,
	Suffix = "studs/s",
	CurrentValue = 40,
	Flag = "ClimbWallSpeedSlider",
	Callback = function(Value) CLIMB_SPEED = Value end,
})

PlayerTab:CreateSlider({
	Name = "Climb Wall Jump Force (Jump)",
	Range = {10, 300},
	Increment = 5,
	Suffix = "Force",
	CurrentValue = 60,
	Flag = "ClimbWallJumpForceSlider",
	Callback = function(Value) JUMP_WALL_FORCE = Value end,
})

PlayerTab:CreateSlider({
	Name = "Monkey Climb Stack Height",
	Range = {2, 15},
	Increment = 1,
	Suffix = "studs",
	CurrentValue = 5,
	Flag = "MonkeyClimbStackSlider",
	Callback = function(Value) MONKEY_STACK_HEIGHT = Value end,
})

PlayerTab:CreateSlider({
	Name = "Monkey Climb Top Boost",
	Range = {20, 200},
	Increment = 5,
	Suffix = "Force",
	CurrentValue = 60,
	Flag = "MonkeyClimbTopBoostSlider",
	Callback = function(Value) MONKEY_TOP_BOOST = Value end,
})

-- ============================================
-- CAMERA SECTION
-- ============================================
PlayerTab:CreateSection("Camera")

PlayerTab:CreateToggle({
	Name = "Fov Camera",
	CurrentValue = false,
	Flag = "FovCameraToggle",
	Callback = function(Value)
		FovCameraEnabled = Value
		if Value then startFovLock(); applyFov() else stopFovLock(); applyFov() end
	end,
})

PlayerTab:CreateSlider({
	Name = "Fov Camera Custom",
	Range = {50, 120},
	Increment = 1,
	Suffix = "FOV",
	CurrentValue = 70,
	Flag = "FovCameraSlider",
	Callback = function(Value)
		FovCameraValue = Value
		if FovCameraEnabled then Camera.FieldOfView = Value end
	end,
})

local function applyThirdPerson()
	pcall(function()
		if ThirdPersonEnabled then
			LocalPlayer.CameraMaxZoomDistance = ThirdPersonMaxZoom
			LocalPlayer.CameraMode = Enum.CameraMode.Classic
		else
			LocalPlayer.CameraMaxZoomDistance = ThirdPersonDefaultMax
			LocalPlayer.CameraMode = ThirdPersonDefaultMode
		end
	end)
end

local function startThirdPersonLock()
	if ThirdPersonConn then return end
	ThirdPersonConn = RunService.RenderStepped:Connect(function()
		if not ThirdPersonEnabled then return end
		pcall(function()
			if LocalPlayer.CameraMaxZoomDistance ~= ThirdPersonMaxZoom then
				LocalPlayer.CameraMaxZoomDistance = ThirdPersonMaxZoom
			end
			if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
				LocalPlayer.CameraMode = Enum.CameraMode.Classic
			end
		end)
	end)
end

local function stopThirdPersonLock()
	if ThirdPersonConn then ThirdPersonConn:Disconnect(); ThirdPersonConn = nil end
end

PlayerTab:CreateToggle({
	Name = "Third Person",
	CurrentValue = false,
	Flag = "ThirdPersonToggle",
	Callback = function(Value)
		ThirdPersonEnabled = Value
		if Value then applyThirdPerson(); startThirdPersonLock() else stopThirdPersonLock(); applyThirdPerson() end
	end,
})

-- ============================================
-- READY FLAG
-- ============================================
task.defer(function()
	task.wait(0.5)
	_isReady = true
end)

-- ============================================
-- DEFENSE / ANTI SECTION
-- (ใช้ local ที่ประกาศบนสุด ไม่ประกาศซ้ำ)
-- ============================================
local Player = LocalPlayer
local R = RunService
local Inventory = Workspace:WaitForChild(Player.Name .. "SpawnedInToys", 10)

local CE = ReplicatedStorage:WaitForChild("CharacterEvents", 10)
local BeingHeld = Player:WaitForChild("IsHeld", 10)
local StruggleEvent = CE and CE:WaitForChild("Struggle")

local antiGucciConnection = nil
local safePosition = nil
local restoreFrames = 0

-- ---- helper: get toys folder แบบปลอดภัย ----
local function getMyToysFolder()
	return Workspace:FindFirstChild(Player.Name .. "SpawnedInToys")
end

-- ---- spawnBlobman ----
local function spawnBlobman()
	pcall(function()
		ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
			"CreatureBlobman",
			CFrame.new(0, 5000000, 0),
			Vector3.new(0, 60, 0)
		)
	end)
	local folder = Workspace:WaitForChild(Player.Name .. "SpawnedInToys", 5)
	if folder then
		local blob = folder:FindFirstChild("CreatureBlobman")
		if blob then
			local head = blob:FindFirstChild("Head")
			if head then
				head.CFrame = CFrame.new(0, 50000, 0)
				head.Anchored = true
			end
		end
	end
end

-- ---- findBlobman ----
local function findBlobman()
	local folder = getMyToysFolder()
	return folder and folder:FindFirstChild("CreatureBlobman")
end

-- ---- startAntiGucci ----
local function startAntiGucci()
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	safePosition = rootPart.Position

	local folder = getMyToysFolder()
	local blob = folder and folder:FindFirstChild("CreatureBlobman")
	local seat = blob and blob:FindFirstChild("VehicleSeat")

	if not blob then
		spawnBlobman()
		task.wait(0.5)
		folder = getMyToysFolder()
		blob = folder and folder:FindFirstChild("CreatureBlobman")
		seat = blob and blob:FindFirstChild("VehicleSeat")
	end

	if seat and seat:IsA("VehicleSeat") then
		rootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
		seat:Sit(humanoid)
	end

	humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if humanoid.Jump and humanoid.Sit then
			restoreFrames = 15
			safePosition = rootPart.Position
		end
	end)

	if antiGucciConnection then antiGucciConnection:Disconnect() end
	antiGucciConnection = R.Heartbeat:Connect(function()
		if not rootPart or not humanoid then return end
		pcall(function()
			ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(rootPart, 0)
		end)
		if restoreFrames > 0 then
			rootPart.CFrame = CFrame.new(safePosition)
			restoreFrames = restoreFrames - 1
		end
	end)

	task.spawn(function()
		while humanoid.Sit do task.wait(0.5) end
		task.wait(0.1)
		rootPart.CFrame = CFrame.new(safePosition)
	end)
end

local function stopAntiGucci()
	if antiGucciConnection then
		antiGucciConnection:Disconnect()
		antiGucciConnection = nil
	end
	local folder = getMyToysFolder()
	if folder then
		local blob = folder:FindFirstChild("CreatureBlobman")
		if blob then pcall(function() blob:Destroy() end) end
	end
end

local autoGucciActive = false

AntiTab:CreateToggle({
    Name = "Gucci anti (if you can't grab just turn off toggle :p)",
    CurrentValue = false,
    Flag = "GuciiiToggle",
    Callback = function(Value)
        autoGucciActive = Value
        if Value then
            startAntiGucci()
            task.spawn(function()
                while autoGucciActive do
                    local toysFolder = getMyToysFolder()
                    local blobExists = toysFolder and toysFolder:FindFirstChild("CreatureBlobman")
                    if not blobExists then
                        stopAntiGucci()
                        spawnBlobman()
                        local retries = 0
                        repeat
                            task.wait(0.1)
                            retries = retries + 1
                            toysFolder = getMyToysFolder()
                        until (toysFolder and toysFolder:FindFirstChild("CreatureBlobman")) or retries > 25 or not autoGucciActive
                        if autoGucciActive and toysFolder and toysFolder:FindFirstChild("CreatureBlobman") then
                            startAntiGucci()
                        end
                    end
                    task.wait(0.3)
                end
            end)
        else
            autoGucciActive = false
            stopAntiGucci()
        end
    end
})

AntiTab:CreateButton({
    Name = "Spawn Blobman",
    Callback = function() spawnBlobman() end
})

AntiTab:CreateButton({
    Name = "Sit on Blobman(to fix desyncs)",
    Callback = function()
        local blob = findBlobman()
        if blob then
            local seat = blob:FindFirstChild("VehicleSeat")
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if seat and humanoid then seat:Sit(humanoid) end
        end
    end
})

-- ---- Anti pcld ----
local function HookedPCLDBreak()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local killedAfterRespawn = false
    local savedCFrame = hrp.CFrame
    hrp.CFrame = CFrame.new(hrp.Position.X, 50000, hrp.Position.Z)
    task.wait(0.05)
    hum.Health = 0

    LocalPlayer.CharacterAdded:Once(function(newChar)
        local newHrp = newChar:WaitForChild("HumanoidRootPart", 5)
        local newHum = newChar:WaitForChild("Humanoid", 5)
        if newHrp and newHum then
            task.wait(0.1)
            newHrp.CFrame = savedCFrame
            if not killedAfterRespawn then
                killedAfterRespawn = true
                task.wait(0.05)
                newHum.Health = 0
            end
        end
    end)
end

AntiTab:CreateButton({ Name = "Anti pcld", Callback = HookedPCLDBreak })

-- ---- Anti Paint ----
local paintPartsBackup = {}
local paintConnections = {}

local function deleteAllPaintParts()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
            local clone = obj:Clone()
            clone.Archivable = true
            paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent }
            obj:Destroy()
        end
    end
end

local function restorePaintParts()
    for _, data in pairs(paintPartsBackup) do
        if data.clone and data.parent then data.clone.Parent = data.parent end
    end
    paintPartsBackup = {}
end

local function watchNewPaintParts()
    table.insert(paintConnections, Workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") and obj.Name == "PaintPlayerPart" then
            task.defer(function()
                if obj and obj.Parent then
                    local clone = obj:Clone()
                    clone.Archivable = true
                    paintPartsBackup[obj:GetDebugId()] = { clone = clone, parent = obj.Parent }
                    obj:Destroy()
                end
            end)
        end
    end))
end

local function disconnectWatchers()
    for _, conn in ipairs(paintConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    paintConnections = {}
end

local function setTouchQuery(state)
    local char = Workspace:FindFirstChild(Player.Name)
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanTouch = state
            v.CanQuery = state
        end
    end
end

AntiTab:CreateToggle({
    Name = "Anti Paint",
    CurrentValue = false,
    Flag = "AntiPaintToggle1",
    Callback = function(state)
        if state then
            deleteAllPaintParts()
            watchNewPaintParts()
            setTouchQuery(false)
        else
            restorePaintParts()
            disconnectWatchers()
            setTouchQuery(true)
        end
    end
})

-- ---- Anti void ----
local antiVoidConn = nil
local VOID_THRESHOLD = -50
local SAFE_HEIGHT = 100

AntiTab:CreateToggle({
    Name = "Anti void",
    CurrentValue = false,
    Flag = "AntiVoidToggle",
    Callback = function(on)
        if on then
            if antiVoidConn then antiVoidConn:Disconnect() end
            antiVoidConn = R.Heartbeat:Connect(function()
                local char = Player.Character
                if char and char.PrimaryPart then
                    local pos = char.PrimaryPart.Position
                    if pos.Y < VOID_THRESHOLD then
                        local safePos = Vector3.new(pos.X, pos.Y + SAFE_HEIGHT, pos.Z)
                        pcall(function()
                            char:PivotTo(CFrame.new(safePos))
                            char.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                        end)
                    end
                end
            end)
        else
            if antiVoidConn then antiVoidConn:Disconnect(); antiVoidConn = nil end
        end
    end
})

-- ---- Anti Explosion ----
local antiExplodeT = false
local antiExplodeConn = nil

local function antiExplodeF()
    antiExplodeT = true
    local char = Player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")

    if antiExplodeConn then antiExplodeConn:Disconnect() end
    antiExplodeConn = Workspace.ChildAdded:Connect(function(model)
        if model.Name == "Part" and antiExplodeT then
            local ok, mag = pcall(function()
                return (model.Position - hrp.Position).Magnitude
            end)
            if ok and mag <= 20 then
                pcall(function()
                    hrp.Anchored = true
                    task.wait(0.001)
                    local rightArm = char:FindFirstChild("Right Arm")
                    local ragdollPart = rightArm and rightArm:FindFirstChild("RagdollLimbPart")
                    if ragdollPart then
                        local timeout = 0
                        while ragdollPart.CanCollide and timeout < 100 do
                            task.wait(0.0001)
                            timeout = timeout + 1
                        end
                    end
                    hrp.Anchored = false
                end)
            end
        end
    end)
end

AntiTab:CreateToggle({
    Name = "Anti Explosion",
    CurrentValue = false,
    Flag = "AntiExToggle",
    Callback = function(on)
        if on then
            antiExplodeF()
        else
            antiExplodeT = false
            if antiExplodeConn then antiExplodeConn:Disconnect(); antiExplodeConn = nil end
        end
    end
})

-- ---- Anti Burn ----
local anti_burn_enabled = false
local antiBurnConn = nil

local function spawnOrGetFireExtinguisher(cframe)
    local toysFolder = getMyToysFolder()
    if toysFolder then
        local tool = toysFolder:FindFirstChild("FireExtinguisher")
        if tool then return tool end
    end
    pcall(function()
        ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("FireExtinguisher", cframe, Vector3.new())
    end)
end

local function destroyToySafe(toy)
    if not toy then return end
    pcall(function() ReplicatedStorage.MenuToys.DestroyToy:FireServer(toy) end)
end

local function antiBurnLoop()
    while anti_burn_enabled do
        pcall(function()
            local character = Player.Character
            if not character then return end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("FireParticleEmitter") then
                local toysFolder = getMyToysFolder()
                local fireExtinguisher = toysFolder and toysFolder:FindFirstChild("FireExtinguisher")
                    or spawnOrGetFireExtinguisher(hrp.CFrame * CFrame.new(0, 100, 0))
                if fireExtinguisher and fireExtinguisher:FindFirstChild("ExtinguishPart") then
                    local extinguishPart = fireExtinguisher.ExtinguishPart
                    while hrp and hrp:FindFirstChild("FireParticleEmitter") do
                        extinguishPart.Position = hrp.Position
                        extinguishPart.Size = Vector3.new(100, 100, 100)
                        RunService.Heartbeat:Wait()
                        extinguishPart.Position = Vector3.new(-1000, 0, 0)
                        RunService.Heartbeat:Wait()
                    end
                    destroyToySafe(fireExtinguisher)
                    task.wait(0.001)
                end
            end
        end)
        task.wait(0.001)
    end
end

AntiTab:CreateToggle({
    Name = "Anti Burn",
    CurrentValue = false,
    Flag = "AntiBurnToggle",
    Callback = function(Value)
        anti_burn_enabled = Value
        if Value then task.spawn(antiBurnLoop) end
    end
})

-- ---- Delete void (FallenPartsDestroyHeight) ----
AntiTab:CreateToggle({
    Name = "Delete void",
    CurrentValue = false,
    Flag = "DeleteVoidToggle",
    Callback = function(Value)
        if Value then
            pcall(function() Workspace.FallenPartsDestroyHeight = 0/0 end)
            Rayfield:Notify({ Title = "Void has been disabled", Content = "Anti-Void", Duration = 6.5, Image = 4483362458 })
        else
            pcall(function() Workspace.FallenPartsDestroyHeight = -100 end)
            Rayfield:Notify({ Title = "Void has been enabled", Content = "Anti-Void", Duration = 6.5, Image = 4483362458 })
        end
    end,
})

AntiTab:CreateSection("Anti blob")

-- ---- Input Lag coconut ----
local coconutEnabled = false
local hbCoconutConn = nil
local coco = nil
local holdRemote = nil
local dropRemote = nil

local function spawnCoconut()
    local toysFolder = getMyToysFolder()
    if not toysFolder then return false end

    pcall(function()
        ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
            "FoodCoconut",
            CFrame.new(-72.93, -5.97, -265.54),
            Vector3.new(0, 90, 0)
        )
    end)

    coco = toysFolder:WaitForChild("FoodCoconut", 2)
    if not coco then return false end
    local holdPart = coco:WaitForChild("HoldPart", 1)
    if not holdPart then return false end
    holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction")
    dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction")
    return holdRemote and dropRemote
end

local function destroyCoconut()
    if coco and coco.Parent then
        pcall(function()
            if ReplicatedStorage.MenuToys.DestroyToy then
                ReplicatedStorage.MenuToys.DestroyToy:FireServer(coco)
            end
        end)
    end
end

local function startCoconutLoop()
    hbCoconutConn = RunService.Heartbeat:Connect(function()
        if not coconutEnabled then return end
        local character = Player.Character
        local head = character and character:FindFirstChild("Head")

        if not coco or not coco.Parent then
            spawnCoconut()
            return
        end
        if not holdRemote or not dropRemote or not head then return end

        pcall(function()
            holdRemote:InvokeServer(coco, character)
            dropRemote:InvokeServer(coco, CFrame.new(head.Position + Vector3.new(0, 10, 0)), Vector3.zero)
        end)
    end)
end

AntiTab:CreateToggle({
    Name = "Input Lag coconut",
    CurrentValue = false,
    Flag = "InputLagCoconut",
    Callback = function(state)
        coconutEnabled = state
        if state then
            startCoconutLoop()
        else
            if hbCoconutConn then hbCoconutConn:Disconnect(); hbCoconutConn = nil end
            destroyCoconut()
            coco = nil; holdRemote = nil; dropRemote = nil
        end
    end
})

-- ---- Anti Blob (kick from blob) ----
AntiTab:CreateToggle({
    Name = "Anti Blob",
    CurrentValue = false,
    Flag = "AntiBlobKick",
    Callback = function(Value)
        local antiblob = Value
        if antiblob and Player.Character and not Player.Character:FindFirstChild("TruePositionPart") then
            local truePosPart = Instance.new("Part")
            truePosPart.Parent = Player.Character
            truePosPart.Name = "TruePositionPart"
            truePosPart.Anchored = true
            truePosPart.Transparency = 1
            truePosPart.CanCollide = false
            truePosPart.Size = Vector3.new(0.1, 0.1, 0.1)
            truePosPart.CFrame = CFrame.new(0, -10000, 0)
        end

        while antiblob and task.wait() do
            if Player.Character then
                local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                local truePosPart = Player.Character:FindFirstChild("TruePositionPart")
                if hrp and truePosPart then
                    local rootAttachment = hrp:FindFirstChild("RootAttachment")
                    if rootAttachment and rootAttachment.Parent == hrp then
                        rootAttachment.Parent = truePosPart
                    end

                    pcall(function()
                        local plotItems = Workspace:FindFirstChild("PlotItems")
                        if plotItems then
                            for _, plot in pairs(plotItems:GetChildren()) do
                                if plot.Name ~= "PlayersInPlots" then
                                    for _, item in pairs(plot:GetChildren()) do
                                        if item.Name == "CreatureBlobman" then
                                            local blobScript = item:FindFirstChild("BlobmanSeatAndOwnerScript")
                                            local rightDetector = item:FindFirstChild("RightDetector")
                                            local leftDetector = item:FindFirstChild("LeftDetector")
                                            if blobScript and rightDetector and leftDetector then
                                                local dropEvent = blobScript:FindFirstChild("CreatureDrop")
                                                local rightWeld = rightDetector:FindFirstChild("RightWeld")
                                                local leftWeld = leftDetector:FindFirstChild("LeftWeld")
                                                if dropEvent and rightWeld and hrp then dropEvent:FireServer(rightWeld, hrp) end
                                                if dropEvent and leftWeld and hrp then dropEvent:FireServer(leftWeld, hrp) end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        local ch = ReplicatedStorage:FindFirstChild("CharacterEvents")
                        local struggleEvent = ch and ch:FindFirstChild("Struggle")
                        if struggleEvent then struggleEvent:FireServer(Player) end
                    end)
                end
            end
        end

        if not antiblob and Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            local truePosPart = Player.Character:FindFirstChild("TruePositionPart")
            if hrp and truePosPart then
                local rootAttachment = truePosPart:FindFirstChild("RootAttachment")
                if rootAttachment then rootAttachment.Parent = hrp end
                truePosPart:Destroy()
            end
        end
    end,
})

-- ---- Anti blobman aura grab ----
local antiBlobmanGrabEnabled = false

AntiTab:CreateToggle({
    Name = "Anti blobman aura grab",
    CurrentValue = false,
    Flag = "antiblobmanaura_toggle",
    Callback = function(enabled)
        antiBlobmanGrabEnabled = enabled
        task.spawn(function()
            while antiBlobmanGrabEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    local pChar = player.Character
                    if player.Name ~= LocalPlayer.Name and pChar then
                        local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                        local pHum = pChar:FindFirstChild("Humanoid")
                        local myChar = LocalPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if pRoot and myRoot and pHum and pHum.SeatPart
                        and pHum.SeatPart.Parent and pHum.SeatPart.Parent.Name == "CreatureBlobman"
                        and (pRoot.Position - myRoot.Position).Magnitude <= 19 then
                            pcall(function()
                                ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(pRoot, pRoot.CFrame)
                            end)
                            task.wait(0.01)
                        end
                    end
                end
                task.wait(0.01)
            end
        end)
    end
})

-- ---- Anti Lag ----
local antilaggg = false
local antilagggauto = false

AntiTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Flag = "AntiLag",
    Callback = function(Value)
        antilaggg = Value
        pcall(function()
            LocalPlayer.PlayerScripts.CharacterAndBeamMove.Disabled = Value
        end)
    end
})

AntiTab:CreateToggle({
    Name = "Auto anti lag",
    CurrentValue = false,
    Flag = "AntiLagAuto",
    Callback = function(Value)
        antilagggauto = Value
    end
})

local grabpersec = 0
local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
local DestroyGrabLineRemote = GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine")

Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant.Name == "GrabParts" then
        grabpersec = grabpersec + 1
    end
    if grabpersec <= 25 or (not antilagggauto or antilaggg) then
        task.delay(1, function()
            if grabpersec ~= 0 then grabpersec = grabpersec - 1 end
        end)
    else
        grabpersec = 0
        pcall(function()
            LocalPlayer.PlayerScripts.CharacterAndBeamMove.Disabled = true
        end)
        if antilagggauto then
            task.delay(60, function()
                if not antilaggg then
                    pcall(function()
                        LocalPlayer.PlayerScripts.CharacterAndBeamMove.Disabled = false
                    end)
                end
            end)
        end
    end
end)

-- ---- Anti Kick ----
AntiTab:CreateSection("Anti Kick's")

AntiTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = false,
    Flag = "AntiKickToggle",
    Callback = function(Value)
        getgenv().AntiKickEnabled = Value
        if not Value then return end

        task.spawn(function()
            local plr = LocalPlayer
            local inv = getMyToysFolder()
            if not inv then return end

            local setOwner = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
            local stickyEvent = ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
            local destroyrem = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
            local canSpawn = plr:WaitForChild("CanSpawnToy", 10)

            local function getHRP()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    return plr.Character.HumanoidRootPart
                end
                local character = plr.CharacterAdded:Wait()
                return character:WaitForChild("HumanoidRootPart")
            end

            local function CheckForHome()
                local PlotItems = Workspace:FindFirstChild("PlotItems")
                local Plots = Workspace:FindFirstChild("Plots")
                if not PlotItems or not Plots then return false end
                local PlayersInPlots = PlotItems:FindFirstChild("PlayersInPlots")
                if not PlayersInPlots or not PlayersInPlots:FindFirstChild(plr.Name) then return false end
                local ToyFolder
                for _, v in pairs(Plots:GetChildren()) do
                    local sign = v:FindFirstChild("PlotSign")
                    local owners = sign and sign:FindFirstChild("ThisPlotsOwners")
                    if owners then
                        for _, b in pairs(owners:GetChildren()) do
                            if b:IsA("StringValue") and b.Value == plr.Name then
                                ToyFolder = PlotItems:FindFirstChild(v.Name)
                            end
                        end
                    end
                end
                if ToyFolder then return true, ToyFolder else return false end
            end

            local function StickKunai(kunai)
                if not kunai or not kunai:FindFirstChild("StickyPart") then return end
                local currentHRP = getHRP()
                local soundPart = kunai:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= plr.Name then
                        pcall(function() setOwner:FireServer(soundPart, soundPart.CFrame) end)
                    end
                end
                pcall(function()
                    local firePart = currentHRP:FindFirstChild("FirePlayerPart")
                    if firePart then
                        stickyEvent:FireServer(kunai.StickyPart, firePart, CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(90), math.rad(90)))
                    end
                end)
                for _, obj in pairs(kunai:GetChildren()) do
                    if obj:IsA("BasePart") then
                        obj.CanTouch = false
                        obj.CanCollide = false
                        obj.CanQuery = false
                    end
                end
            end

            local function ClearKunai()
                if not inv then return end
                for _, v in pairs(inv:GetChildren()) do
                    if v.Name == "AntiKick" then
                        pcall(function() destroyrem:FireServer(v) end)
                    end
                end
            end

            local function SpawnToy(name)
                if not canSpawn then return nil end
                while not canSpawn.Value do canSpawn.Changed:Wait() end
                local currentHRP = getHRP()
                pcall(function()
                    ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                        name, currentHRP.CFrame * CFrame.new(0, 12, 20), Vector3.new(0, 0, 0))
                end)
                local boolik, house = CheckForHome()
                if boolik then return house:WaitForChild(name, 2) end
                return inv:WaitForChild(name, 2)
            end

            while getgenv().AntiKickEnabled do
                task.wait(0.005)
                if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then
                    continue
                end
                if not inv or not inv.Parent then
                    inv = getMyToysFolder()
                    if not inv then task.wait(0.5); continue end
                end
                local kunai = inv:FindFirstChild("NinjaShuriken")
                if not kunai then
                    kunai = SpawnToy("NinjaShuriken")
                    if kunai then kunai.Name = "AntiKick" end
                end
                if kunai and kunai:FindFirstChild("StickyPart") then
                    StickKunai(kunai)
                    kunai.Name = "AntiKick"
                end
                task.wait(0.3)
            end
        end)
    end,
})

-- ---- Pencil Anti-Kick ----
AntiTab:CreateToggle({
    Name = "Pencil Anti-Kick",
    CurrentValue = false,
    Flag = "PencilAntiKick",
    Callback = function(Value)
        local COCK = Value
        task.spawn(function()
            while COCK do
                local folder = getMyToysFolder()
                if folder and not folder:FindFirstChild("ToolPencil") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                                "ToolPencil",
                                CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position) + Vector3.new(0, 0, 15),
                                Vector3.new(0, 0, 0)
                            )
                        end)
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})

-- ---- Anti grab ----
AntiTab:CreateSection("Anti grab")

local antiTpActive = false
local tpThreshold = 10

local function getPlotInfo(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local ownersFolder = sign and sign:FindFirstChild("ThisPlotsOwners")
    local valueObj = ownersFolder and ownersFolder:FindFirstChild("Value")
    local grabPart = plot:FindFirstChild("PlusGrabPart", true)
    return valueObj, grabPart
end

local function ultraFastClaimPlot()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (char and root) then return false end
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return false end
    for i = 1, 10 do
        local p = plots:FindFirstChild("Plot" .. i)
        if p then
            local owner, grab = getPlotInfo(p)
            if owner and owner.Value == LocalPlayer.Name and grab then
                root.CFrame = grab.CFrame
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                return true
            end
        end
    end
    return false
end

AntiTab:CreateToggle({
    Name = "Tp to house if getting loopkill",
    CurrentValue = false,
    Flag = "TpToHouse",
    Callback = function(Value)
        antiTpActive = Value
        if Value then
            task.spawn(function()
                local lastPos = nil
                local isHandling = false
                while antiTpActive do
                    if not isHandling then
                        local char = LocalPlayer.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local currentPos = root.Position
                            if lastPos then
                                local distance = (currentPos - lastPos).Magnitude
                                if distance > tpThreshold then
                                    isHandling = true
                                    ultraFastClaimPlot()
                                    task.wait(0.05)
                                    isHandling = false
                                end
                            end
                            lastPos = root.Position
                        else
                            lastPos = nil
                        end
                    end
                    task.wait(0)
                end
            end)
        end
    end
})

AntiTab:CreateSlider({
    Name = "Sensibility",
    Range = {1, 1000},
    Increment = 5,
    CurrentValue = tpThreshold,
    Flag = "SensibilitySlider",
    Callback = function(Value) tpThreshold = Value end
})

-- ---- Anti Loop ----
AntiTab:CreateToggle({
    Name = "Anti Loop",
    CurrentValue = false,
    Flag = "AntiLoopToggle",
    Callback = function(Value)
        if Value then
            getgenv().teleportLocations = {
                Vector3.new(518.52, 834.62, -362.38),
                Vector3.new(566.16, 124.33, -93.13),
                Vector3.new(80.63, 346.19, 338.40),
                Vector3.new(288.70, 447.54, 481.17),
                Vector3.new(-331.23, 81.64, 340.15),
                Vector3.new(-566.02, -6.35, 84.20),
                Vector3.new(-514.05, -6.35, -160.63),
                Vector3.new(-215.14, 60.76, -304.82),
                Vector3.new(-338.28, 22.11, 484.03)
            }

            getgenv().ultraFastLoopTP = function()
                while getgenv().AntiLoopEnabled do
                    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    for _, location in ipairs(getgenv().teleportLocations) do
                        if hrp and getgenv().AntiLoopEnabled then
                            hrp.CFrame = CFrame.new(location)
                        end
                        task.wait(0.08)
                    end
                end
            end

            getgenv().AntiLoopEnabled = true
            task.spawn(getgenv().ultraFastLoopTP)
            LocalPlayer.CharacterAdded:Connect(function()
                task.wait(0.08)
                if getgenv().AntiLoopEnabled then
                    task.spawn(getgenv().ultraFastLoopTP)
                end
            end)
        else
            getgenv().AntiLoopEnabled = false
        end
    end
})

-- ---- Anti Grab ----
local Remotes = {}
for _, Remote in ReplicatedStorage:GetDescendants() do
    if Remote.ClassName:find("Remote") then
        Remotes[Remote.Name] = Remote
    end
end

local IsHeld = LocalPlayer:WaitForChild("IsHeld", 10)
local Character = nil
local Root = nil
local Humanoid = nil
local Head = nil
local AntiGrabEnabled = false
local HeldConnection = nil
local SitThread = nil

local function GetLimbs(Char)
    if not Char then return {} end
    local Limbs = {}
    for _, Name in pairs({"Right Arm", "Left Arm", "Right Leg", "Left Leg"}) do
        Limbs[Name] = Char:FindFirstChild(Name)
    end
    return Limbs
end

local function GetRagdollLimbs(Char)
    if not Char then return {} end
    local RagdollLimbs = {}
    for _, Limb in pairs(GetLimbs(Char)) do
        if Limb then
            local RagdollLimb = Limb:FindFirstChild("RagdollLimbPart")
            if RagdollLimb then
                local Socket = RagdollLimb:FindFirstChildWhichIsA("BallSocketConstraint")
                if Socket then
                    RagdollLimbs[RagdollLimb] = Socket
                end
            end
        end
    end
    return RagdollLimbs
end

local function UpdateCharacter(NewCharacterModel)
    if not (NewCharacterModel and NewCharacterModel:IsDescendantOf(Workspace)) then return end
    Character = NewCharacterModel
    Root = NewCharacterModel:WaitForChild("HumanoidRootPart", 5)
    Humanoid = NewCharacterModel:WaitForChild("Humanoid", 5)
    Head = NewCharacterModel:WaitForChild("Head", 5)
end

UpdateCharacter(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

local function ForceSit()
    if SitThread then task.cancel(SitThread); SitThread = nil end
    SitThread = task.spawn(function()
        while AntiGrabEnabled and IsHeld and IsHeld.Value do
            pcall(function()
                if Humanoid and Root then
                    Humanoid.Sit = true
                    Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                    Root.AssemblyLinearVelocity = Vector3.zero
                    Root.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            task.wait(0.1)
        end
        if Humanoid then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            Humanoid.Sit = false
        end
    end)
end

local function StartAntiGrab()
    if HeldConnection then HeldConnection:Disconnect(); HeldConnection = nil end
    if not IsHeld then return end

    HeldConnection = IsHeld:GetPropertyChangedSignal("Value"):Connect(function()
        if not AntiGrabEnabled or not IsHeld.Value then return end
        ForceSit()
        local RagdollLimbs = GetRagdollLimbs(Character)

        task.spawn(function()
            while AntiGrabEnabled and IsHeld.Value do
                pcall(function()
                    if Remotes.Struggle then Remotes.Struggle:FireServer() end
                    if Remotes.RagdollRemote and Root then Remotes.RagdollRemote:FireServer(Root, 0) end
                end)
                task.wait()
            end
        end)

        task.spawn(function()
            while AntiGrabEnabled and IsHeld.Value do
                if Humanoid and Root then
                    pcall(function()
                        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                        Root.Anchored = true
                        Root.AssemblyLinearVelocity = Vector3.zero
                        Root.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
                task.wait()
            end
            if Root then Root.Anchored = false end
        end)

        task.spawn(function()
            while AntiGrabEnabled and Root and Root.Anchored do
                pcall(function()
                    if Head then
                        Head.CanCollide = false
                        Head.AssemblyLinearVelocity = Vector3.zero
                        Head.AssemblyAngularVelocity = Vector3.zero
                    end
                    for RagdollLimb, Socket in pairs(RagdollLimbs) do
                        if RagdollLimb and Socket and Root then
                            Socket.Enabled = false
                            RagdollLimb.CFrame = Root.CFrame
                            RagdollLimb.CanCollide = false
                            RagdollLimb.AssemblyLinearVelocity = Vector3.zero
                            RagdollLimb.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end)
                task.wait()
            end
        end)
    end)
end

local function StopAntiGrab()
    AntiGrabEnabled = false
    if HeldConnection then HeldConnection:Disconnect(); HeldConnection = nil end
    if SitThread then task.cancel(SitThread); SitThread = nil end
    if Root then Root.Anchored = false end
    if Humanoid then
        Humanoid.Sit = false
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    end
end

AntiTab:CreateToggle({
    Name = "Anti Grab",
    CurrentValue = false,
    Flag = "AntiGrabToggle",
    Callback = function(Value)
        AntiGrabEnabled = Value
        if Value then StartAntiGrab() else StopAntiGrab() end
    end
})

-- ---- Anti setown kick ----
local tpland = {
    Spawn = Vector3.new(0, -7.35, 0),
    SpawnCave = Vector3.new(-90, 14.6, -314.3),
    GreenHouse = Vector3.new(-538, -7, 74),
    PinkHouse = Vector3.new(-478, -7, -147),
    Barn = Vector3.new(-228, 82, -318),
    BlueHouse = Vector3.new(496, 83, -350),
    ChineseHouse = Vector3.new(542, 123, -93),
    PurpleHouse = Vector3.new(270, -7, 448),
    Factory = Vector3.new(134, 347, 352),
    OtherGreenHouse = Vector3.new(-359, 98, 357),
    BigCave = Vector3.new(-245, 80, 485),
    GoodPrison = Vector3.new(569.6, -7, 176.3),
    Prison = Vector3.new(195, -7, -561),
}

local SL = tpland["Spawn"]
local antiok = false

AntiTab:CreateToggle({
    Name = "Anti setown kick",
    CurrentValue = false,
    Flag = "AntiSetownToggle",
    Callback = function(Value)
        antiok = Value
        if not Value then return end

        task.spawn(function()
            local lastSafePosition = nil
            local positionHistory = {}
            local maxHistory = 10
            local heldChangeTimes = {}
            local heldSpamThreshold = 8
            local lastHeldValue = false
            local struggling = false
            local lastStruggleTime = 0
            local struggleCooldown = 0.5
            local isHeldSpamDetected = false

            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                lastSafePosition = char.HumanoidRootPart.Position
                for i = 1, maxHistory do table.insert(positionHistory, lastSafePosition) end
            end
            if IsHeld then lastHeldValue = IsHeld.Value end

            while antiok and task.wait(0.05) do
                char = LocalPlayer.Character
                if not char then continue end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end

                local currentPos = hrp.Position
                local currentTime = tick()

                local isHeld = IsHeld and IsHeld.Value or false
                if isHeld ~= lastHeldValue then
                    table.insert(heldChangeTimes, currentTime)
                    lastHeldValue = isHeld
                    for i = #heldChangeTimes, 1, -1 do
                        if currentTime - heldChangeTimes[i] > 2 then
                            table.remove(heldChangeTimes, i)
                        end
                    end
                    if #heldChangeTimes >= heldSpamThreshold then
                        isHeldSpamDetected = true
                    end
                end

                if isHeld and not struggling and (currentTime - lastStruggleTime > struggleCooldown) then
                    struggling = true
                    lastStruggleTime = currentTime
                    task.spawn(function()
                        for i = 1, 5 do
                            pcall(function()
                                ReplicatedStorage.CharacterEvents.Struggle:FireServer(LocalPlayer)
                            end)
                            task.wait(0.05)
                        end
                        struggling = false
                    end)
                end

                table.insert(positionHistory, 1, currentPos)
                if #positionHistory > maxHistory then
                    table.remove(positionHistory, maxHistory + 1)
                end

                local avgDistance = 0
                if #positionHistory >= 2 then
                    for i = 2, #positionHistory do
                        avgDistance = avgDistance + (positionHistory[i - 1] - positionHistory[i]).Magnitude
                    end
                    avgDistance = avgDistance / (#positionHistory - 1)
                end

                local velocity = hrp.AssemblyLinearVelocity.Magnitude
                local movedDistance = lastSafePosition and (currentPos - lastSafePosition).Magnitude or 0

                local abnormalTeleport = false
                if isHeldSpamDetected then
                    abnormalTeleport = true
                elseif currentPos.Magnitude > 1000000 then
                    abnormalTeleport = true
                elseif movedDistance > 100 and velocity < 50 and avgDistance < 10 then
                    abnormalTeleport = true
                elseif currentPos.Y > 10000 or currentPos.Y < -1000 then
                    abnormalTeleport = true
                elseif velocity > 500 then
                    abnormalTeleport = true
                end

                if abnormalTeleport then
                    isHeldSpamDetected = false
                    heldChangeTimes = {}

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    for i = 1, 3 do
                        pcall(function()
                            ReplicatedStorage.CharacterEvents.Struggle:FireServer(LocalPlayer)
                        end)
                        task.wait(0.05)
                    end

                    if SL then
                        hrp.CFrame = CFrame.new(SL)
                    else
                        local plots = Workspace:FindFirstChild("Plots")
                        local foundSafe = false
                        if plots then
                            for i = 1, 5 do
                                local plot = plots:FindFirstChild("Plot" .. i)
                                if plot then
                                    local sign = plot:FindFirstChild("PlotSign")
                                    local ownersFolder = sign and sign:FindFirstChild("ThisPlotsOwners")
                                    local valueObj = ownersFolder and ownersFolder:FindFirstChild("Value")
                                    if valueObj and valueObj.Value == LocalPlayer.Name then
                                        local grabPart = plot:FindFirstChild("PlusGrabPart", true)
                                        if grabPart then
                                            hrp.CFrame = grabPart.CFrame
                                            foundSafe = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        if not foundSafe then
                            hrp.CFrame = CFrame.new(tpland["Spawn"])
                        end
                    end

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                        humanoid.Sit = false
                    end

                    task.wait(0.2)
                    lastSafePosition = hrp.Position
                    positionHistory = {}
                    for i = 1, maxHistory do table.insert(positionHistory, lastSafePosition) end
                else
                    if movedDistance < 50 then
                        lastSafePosition = currentPos
                    end
                end
            end
        end)
    end
})

-- ---- Anti banana ----
AntiTab:CreateSection("Anti annoy")

local myToysFolder = Workspace:WaitForChild(LocalPlayer.Name .. "SpawnedInToys", 10)

local function spawnToy(toyName, cframe)
    if not LocalPlayer:GetAttribute("CanSpawnToy") and LocalPlayer.CanSpawnToy then
        task.spawn(function()
            local ok = pcall(function()
                ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                    toyName, cframe * CFrame.new(0, 10, 20), Vector3.new(0, 0, 0))
            end)
            if not ok then return end
            local tries = 0
            repeat task.wait() tries = tries + 1
            until myToysFolder:FindFirstChild(toyName) or tries > 100
            task.wait(0.01)
        end)
    end
end

local function antiBananaDeleteLegs()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    task.spawn(function()
        pcall(function()
            ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(hrp, 1)
        end)
    end)
    task.wait(0.1)

    local rightLeg = char:FindFirstChild("Right Leg")
    local leftLeg = char:FindFirstChild("Left Leg")
    if not (rightLeg and leftLeg) then return end

    local clonedLeg = rightLeg:Clone()
    clonedLeg.Parent = char
    local bsc = clonedLeg:FindFirstChild("BallSocketConstraint")
    if bsc then bsc:Destroy() end

    task.wait(0.1)
    rightLeg.CFrame = CFrame.new(0, -59999, 0)
    leftLeg.CFrame = CFrame.new(0, -59999, 0)
    task.wait()

    spawnToy("CupMugBrown", hrp.CFrame)
    local cup = myToysFolder and myToysFolder:WaitForChild("CupMugBrown", 5)
    if cup and cup:FindFirstChild("Hitbox") then
        pcall(function()
            ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(hrp, CFrame.new(cup.Hitbox.Position))
        end)
        task.wait()
        pcall(function()
            ReplicatedStorage.MenuToys.DestroyToy:FireServer(cup)
        end)
    end

    clonedLeg.CFrame = CFrame.new(0, 9999999, 0)
    clonedLeg.Massless = true
end

AntiTab:CreateButton({
    Name = "Anti banana - delete legs",
    Callback = antiBananaDeleteLegs
})

-- ---- Anti snowball ----
local RagdollRemote = ReplicatedStorage:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote", 10)
local AntiRagBlob = false
local RagdolledSit = false
local Cons = {}

local function Disc(name)
    if Cons[name] then Cons[name]:Disconnect(); Cons[name] = nil end
end

AntiTab:CreateToggle({
    Name = "Anti snowball",
    CurrentValue = false,
    Flag = "AntiRagdoll",
    Callback = function(Value)
        AntiRagBlob = Value
        RagdolledSit = false

        if AntiRagBlob then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hum = char and char:FindFirstChild("Humanoid")
            local HRP = char and char:FindFirstChild("HumanoidRootPart")
            if not (hum and HRP) then return end

            local function bindSeat(h, hRoot)
                Cons["ARSeat"] = h:GetPropertyChangedSignal("SeatPart"):Connect(function()
                    if h.SeatPart and h.SeatPart.Parent and h.SeatPart.Parent.Name == "CreatureBlobman" and not RagdolledSit then
                        RagdolledSit = true
                        local Seat = h.SeatPart
                        task.wait(0.1)
                        pcall(function() RagdollRemote:FireServer(hRoot, 3) end)
                        task.wait(0.4)
                        h.Sit = false
                        Seat:Sit(h)
                        task.delay(0.25, function()
                            while h and h.SeatPart do
                                pcall(function() RagdollRemote:FireServer(LocalPlayer.Character.HumanoidRootPart, 1) end)
                                task.wait(0.05)
                            end
                            RagdolledSit = false
                        end)
                    end
                end)
            end

            bindSeat(hum, HRP)

            Cons["ARChar"] = LocalPlayer.CharacterAdded:Connect(function(newChar)
                local newHum = newChar:WaitForChild("Humanoid")
                local newHRP = newChar:WaitForChild("HumanoidRootPart")
                bindSeat(newHum, newHRP)
            end)
        else
            Disc("ARSeat")
            Disc("ARChar")
        end
    end,
})

-- ---- Delete holdables ----
local GrabData = {
    toggle = false,
    dropPos = CFrame.new(-238.98, -256.01, -123.97)
}

local function GrabItem(item)
    local hold = item:FindFirstChild("HoldPart")
    if not hold then return end
    local grab = hold:FindFirstChild("HoldItemRemoteFunction")
    local drop = hold:FindFirstChild("DropItemRemoteFunction")
    if grab and drop then
        pcall(function() grab:InvokeServer(item, LocalPlayer.Character) end)
        pcall(function() drop:InvokeServer(item, GrabData.dropPos, Vector3.new()) end)
    end
end

local function LoopGrab()
    while GrabData.toggle do
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder:IsA("Folder") and folder.Name:find("SpawnedInToys") then
                for _, obj in ipairs(folder:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("HoldPart") then
                        GrabItem(obj)
                    end
                end
            end
        end
        local plotItems = Workspace:FindFirstChild("PlotItems")
        if plotItems then
            for _, plot in pairs(plotItems:GetChildren()) do
                if plot.Name ~= "PlayersInPlots" then
                    for _, model in pairs(plot:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("HoldPart") then
                            GrabItem(model)
                        end
                    end
                end
            end
        end
        task.wait(0.001)
    end
end

AntiTab:CreateToggle({
    Name = "Delete holdables",
    CurrentValue = false,
    Flag = "DeleteHoldables",
    Callback = function(state)
        GrabData.toggle = state
        if state then task.spawn(LoopGrab) end
    end
})

AntiTab:CreateSection("Holdparts (food and instruments)")

-- ---- Grab holdables ----
local holdItemLoop = nil

AntiTab:CreateToggle({
    Name = "Grab holdables",
    CurrentValue = false,
    Flag = "HoldItemToggle",
    Callback = function(enabled)
        if enabled then
            if not holdItemLoop then
                holdItemLoop = coroutine.create(function()
                    while true do
                        for _, item in pairs(Workspace:GetDescendants()) do
                            if item:IsA("Model") and item:FindFirstChild("HoldPart") then
                                local char = LocalPlayer.Character
                                if char then
                                    local holdFunction = item.HoldPart:FindFirstChild("HoldItemRemoteFunction")
                                    if holdFunction then
                                        pcall(function() holdFunction:InvokeServer(item, char) end)
                                    end
                                end
                            end
                        end
                        task.wait(0.01)
                    end
                end)
                coroutine.resume(holdItemLoop)
            end
        else
            if holdItemLoop then
                coroutine.close(holdItemLoop)
                holdItemLoop = nil
            end
        end
    end,
})

AntiTab:CreateButton({
    Name = "Use holdables",
    Callback = function()
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Model") and item:FindFirstChild("HoldPart") then
                local useFunction = ReplicatedStorage:FindFirstChild("HoldEvents")
                useFunction = useFunction and useFunction:FindFirstChild("Use")
                if useFunction then
                    pcall(function() useFunction:FireServer(item) end)
                end
            end
        end
    end,
})

AntiTab:CreateButton({
    Name = "Drop Holdables",
    Callback = function()
        local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Char:WaitForChild("HumanoidRootPart")
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Model") and item:FindFirstChild("HoldPart") then
                local dropFunction = item.HoldPart:FindFirstChild("DropItemRemoteFunction")
                if dropFunction then
                    pcall(function()
                        dropFunction:InvokeServer(item, HRP.CFrame, Vector3.new(0, 0, 0))
                    end)
                end
            end
        end
    end,
})

-- ---- Auto Attacker ----
AntiTab:CreateSection("Auto Attacker")

local defenseEnabled = false
local defenseConnection = nil
local defenseMode = "Fling"

local GrabEventsAT = ReplicatedStorage:WaitForChild("GrabEvents", 10)
local SetNetworkOwnerAT = GrabEventsAT and GrabEventsAT:WaitForChild("SetNetworkOwner", 5)
local DestroyGrabLineAT = GrabEventsAT and GrabEventsAT:FindFirstChild("DestroyGrabLine")
local CreateGrabLineAT = GrabEventsAT and GrabEventsAT:FindFirstChild("CreateGrabLine")

local function getAttacker()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    local owner = char.Head:FindFirstChild("PartOwner")
    if not owner or not owner:IsA("StringValue") then return end
    return Players:FindFirstChild(owner.Value)
end

local function safeAttack(fn)
    local attacker = getAttacker()
    if not attacker or not attacker.Character then return end
    local root = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    pcall(function()
        SetNetworkOwnerAT:FireServer(root, root.CFrame)
        if DestroyGrabLineAT then DestroyGrabLineAT:FireServer(root) end
        fn(attacker, root)
    end)
end

local function addFling(root, velocity, name)
    local bv = Instance.new("BodyVelocity")
    bv.Name = name or "RinneganFling"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = velocity
    bv.P = 12500
    bv.Parent = root
    Debris:AddItem(bv, 0.01)
end

local function performFling()
    safeAttack(function(attacker, root)
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local away = (root.Position - myRoot.Position).Unit
        away = Vector3.new(away.X, 0, away.Z) * 90000
        addFling(root, away)
    end)
end

local function performKill()
    safeAttack(function(attacker, root)
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local away = (root.Position - myRoot.Position).Unit
        away = Vector3.new(away.X, 0, away.Z) * 99999999999999
        addFling(root, away)
    end)
end

local function performHeaven()
    safeAttack(function(attacker, root)
        root.CFrame = CFrame.new(0, 200, 0)
        local bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganHeaven"
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, 200, 0)
        bv.P = 12500
        bv.Parent = root
        Debris:AddItem(bv, 0.01)
    end)
end

local function performKick()
    safeAttack(function(attacker, root)
        root.CFrame = CFrame.new(0, 999999999999, 0)
        addFling(root, Vector3.new(0, 99999999999999, 0), "RinneganHeaven")
    end)
end

local function performRagdoll()
    safeAttack(function(attacker, root)
        addFling(root, Vector3.new(0, -20, 0), "RinneganSpy")
    end)
end

local function performChina()
    safeAttack(function(attacker, root)
        root.CFrame = CFrame.new(591, 153, -101)
    end)
end

local function performHell()
    safeAttack(function(attacker, root)
        for _, part in ipairs(attacker.Character:GetDescendants()) do
            if part:IsA("BasePart") and not part.Anchored then
                part.CanCollide = false
            end
        end
        addFling(root, Vector3.new(0, -100000000, 0), "RinneganSpy")
    end)
end

local function performSpamGrabLines()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local owner = head:FindFirstChild("PartOwner")
    if not owner or not owner:IsA("StringValue") then return end
    local attacker = Players:FindFirstChild(owner.Value)
    if not (attacker and attacker.Character and CreateGrabLineAT) then return end
    local aHead = attacker.Character:FindFirstChild("Head")
    local aRoot = attacker.Character:FindFirstChild("HumanoidRootPart")
    if not (aHead and aRoot) then return end
    for i = 1, 10 do
        pcall(function() CreateGrabLineAT:FireServer(aHead, aHead.CFrame) end)
        pcall(function() CreateGrabLineAT:FireServer(aRoot, aRoot.CFrame) end)
    end
end

local function startDefense()
    if defenseConnection then return end
    defenseConnection = RunService.Heartbeat:Connect(function()
        if not defenseEnabled then return end
        if not getAttacker() then return end
        if defenseMode == "Fling" then performFling()
        elseif defenseMode == "Kill" then performKill()
        elseif defenseMode == "Send to Heaven" then performHeaven()
        elseif defenseMode == "Kick" then performKick()
        elseif defenseMode == "Ragdoll" then performRagdoll()
        elseif defenseMode == "Hell" then performHell()
        elseif defenseMode == "China" then performChina()
        elseif defenseMode == "GrabLine" then performSpamGrabLines()
        end
    end)
end

local function stopDefense()
    if defenseConnection then defenseConnection:Disconnect(); defenseConnection = nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BodyVelocity") and (obj.Name == "RinneganFling" or obj.Name == "RinneganHeaven" or obj.Name == "RinneganSpy") then
                    obj:Destroy()
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if defenseEnabled then
        task.wait(1)
        startDefense()
    end
end)

AntiTab:CreateToggle({
    Name = 'Auto-Attack',
    CurrentValue = false,
    Flag = "RinneganDefenseToggle",
    Callback = function(enabled)
        defenseEnabled = enabled
        if enabled then startDefense() else stopDefense() end
    end
})

AntiTab:CreateDropdown({
    Name = "Mode",
    Options = { "Fling", "Kill", "Send to Heaven", "Kick", "Ragdoll", "Hell", "China", "GrabLine" },
    CurrentOption = "Fling",
    Flag = "RinneganMode",
    Callback = function(mode)
        if typeof(mode) == "table" then mode = mode[1] end
        defenseMode = mode
    end
})

CombatTab:CreateSection("Super Throw")

-------======= STAGE COMBAT =====--------

local SuperThrowEnabled     = false
local SuperThrowPower       = 850
local SuperThrowActive      = false
local SuperThrowModeOptions = {"Right Click", "Grab & Release"}
local SuperThrowCurrentMode = "Right Click"

local function enableSuperThrow()
	if SuperThrowActive then return end
	SuperThrowActive = true

	local activeGrab = nil  -- {model, weld, part, velocity}

	-- ===== GRAB & RELEASE (ปล่อยแล้วปิ่ว) =====
	Workspace.ChildAdded:Connect(function(model)
		if not SuperThrowActive then return end
		if model.Name ~= "GrabParts" then return end

		local partInfo = model:FindFirstChild("GrabPart")
		if not partInfo then return end

		local weld = partInfo:FindFirstChild("WeldConstraint")
		if not weld or not weld.Part1 then return end

		local part = weld.Part1
		local velocity = Instance.new("BodyVelocity")
		velocity.MaxForce = Vector3.zero
		velocity.Parent = part

		local grabData = {model = model, weld = weld, part = part, velocity = velocity}
		activeGrab = grabData

		model:GetPropertyChangedSignal("Parent"):Connect(function()
			if not model.Parent then
				if SuperThrowEnabled and SuperThrowCurrentMode == "Grab & Release" then
					velocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
					velocity.Velocity = Workspace.CurrentCamera.CFrame.LookVector * SuperThrowPower
				end
				Debris:AddItem(velocity, 1)
				if activeGrab == grabData then activeGrab = nil end
			end
		end)
	end)

	-- ===== RIGHT CLICK (คลิกขวา → ปิ่วทันที) =====
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		-- ไม่เช็ค gameProcessed เพราะเกมใช้ Right Click grab
		if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
		if not SuperThrowEnabled then return end
		if SuperThrowCurrentMode ~= "Right Click" then return end
		if not activeGrab or not activeGrab.model.Parent then return end

		local v = activeGrab.velocity
		local w = activeGrab.weld

		-- ใส่แรงก่อน แล้วตัด weld → วัตถุหลุดแล้วปิ่ว
		v.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		v.Velocity = Workspace.CurrentCamera.CFrame.LookVector * SuperThrowPower
		w:Destroy()

		Debris:AddItem(v, 1)
		activeGrab = nil
	end)
end

-- Toggle
CombatTab:CreateToggle({
	Name = "Super Throw",
	CurrentValue = false,
	Flag = "SuperThrowToggle",
	Callback = function(Value)
		SuperThrowEnabled = Value
		if Value and not SuperThrowActive then
			enableSuperThrow()
		end
	end,
})

-- Dropdown
CombatTab:CreateDropdown({
	Name = "Select Mode Super Throw",
	Options = SuperThrowModeOptions,
	CurrentOption = SuperThrowCurrentMode,
	MultipleOptions = false,
	Flag = "SuperThrowMode",
	Callback = function(Mode)
		if type(Mode) == "table" then
			SuperThrowCurrentMode = Mode.Value or Mode[1] or "Right Click"
		else
			SuperThrowCurrentMode = tostring(Mode)
		end

		Rayfield:Notify({
			Title = "Gan Notify I Combat Super Throw Mode",
			Content = "Select Throw Mode " .. SuperThrowCurrentMode,
			Duration = 6.5,
			Image = "rewind",
		})
	end,
})

-- Slider
CombatTab:CreateSlider({
	Name = "Super Throw Custom",
	Range = {50, 9000},
	Increment = 10,
	Suffix = "Power",
	CurrentValue = 850,
	Flag = "SuperThrowCustom",
	Callback = function(Value)
		SuperThrowPower = Value
	end,
})
