-- ============================================
-- TIMER (เริ่มจับเวลาตั้งแต่บรรทัดแรก)
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

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

--- ตัวแปร

local _isReady = false

-- TPWalk
local TPWalk_Enabled = false
local TPWalk_Studs   = 1.0
local TPWalk_Conn    = nil

-- Inf Jump
local InfJumpEnabled      = false
local InfJumpCurrentMode  = "Hold Jump"
local InfJumpModeOptions  = {"Hold Jump", "Jump Once"}
local canJump             = true

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

--- T h r i d  p e r s o n

local ThirdPersonEnabled     = false
local ThirdPersonMaxZoom     = 99999
local ThirdPersonDefaultMax  = 0.5                            -- default ของ first person
local ThirdPersonDefaultMode = Enum.CameraMode.LockFirstPerson -- first person
local ThirdPersonConn        = nil

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

-- อ่าน gravity ของเกมจริงหลังโหลดเสร็จ (กันบางเกมตั้งไม่ใช่ 196.2)
task.defer(function()
	task.wait(0.2)
	GravityDefault = Workspace.Gravity
	GravityValue   = GravityDefault
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

	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},

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

Rayfield:Notify({
	Title = "Gan I Loaded",
	Content = "Script Loaded",
	Duration = 6.5,
	Image = "check",
})

local _loadTime = string.format("%.2fs", tick() - _startTime)

Rayfield:Notify({
	Title = "Gan I Loaded",
	Content = "Script Loaded In " .. _loadTime,
	Duration = 6.5,
	Image = "timer",
})

-- ============================================
-- TAB: PLAYER
-- ============================================
local PlayerTab = Window:CreateTab("Player", "user-2")

PlayerTab:CreateDivider()
PlayerTab:CreateSection("Movement")

-- ---------- Walkspeed (TPWalk) ----------
PlayerTab:CreateToggle({
	Name = "Walkspeed",
	CurrentValue = false,
	Flag = "Walkspeed_Toggle",
	IgnoreLoad = true,
	Callback = function(Value)
		if not _isReady then return end
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
	Callback = function(Value)
		if not _isReady then return end
		TPWalk_Studs = Value
	end,
})

PlayerTab:CreateParagraph({
	Title = "Walkspeed Guide",
	Content = "0.1 = 1 per Tpwalk"
})

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
			if NoclipConnection then
				NoclipConnection:Disconnect()
				NoclipConnection = nil
			end
			NoclipConnection = RunService.Stepped:Connect(function()
				if NoclipEnabled and LocalPlayer.Character then
					SetNoclip(LocalPlayer.Character)
				end
			end)
		else
			if NoclipConnection then
				NoclipConnection:Disconnect()
				NoclipConnection = nil
			end
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
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

PlayerTab:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        InfJumpEnabled = Value
    end,
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

        Rayfield:Notify({
            Title = "Gan I Player Infjump",
            Content = "Select " .. InfJumpCurrentMode,
            Duration = 6.5,
            Image = "mouse-pointer-2-off",
        })
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

		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end

		flyConnection = RunService.RenderStepped:Connect(function()
			if not FlyEnabled or not character.Parent then return end

			local camCF = Camera.CFrame
			local moveDir = Vector3.zero

			if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
				moveDir = moveDir + camCF.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
				moveDir = moveDir - camCF.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
				moveDir = moveDir - camCF.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
				moveDir = moveDir + camCF.RightVector
			end

			bodyGyro.CFrame = camCF

			if moveDir.Magnitude > 0 then
				bodyVelocity.Velocity = moveDir.Unit * FlySpeed
			else
				bodyVelocity.Velocity = Vector3.zero
			end
		end)
	else
		humanoid.PlatformStand = false

		if flyConnection then
			flyConnection:Disconnect()
			flyConnection = nil
		end
		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
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
	Callback = function(Value)
		FlySpeed = Value
	end,
})

-- ============================================
-- หลัง UI สร้างเสร็จ ให้ guard เปิดใช้งาน
-- ============================================
task.defer(function()
	task.wait(0.5)
	_isReady = true
	TPWalk_Enabled = false
	TPWalk_Studs = 1.0
end)

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

-- หา Y ผิวน้ำของ Ocean ใต้ตำแหน่ง HRP
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
			if math.abs(rel.X) <= v.Size.X * 0.5 + 6
			and math.abs(rel.Z) <= v.Size.Z * 0.5 + 6 then
				local topY = v.Position.Y + v.Size.Y * 0.5
				if hrp.Position.Y >= topY - 10 then
					if not bestY or topY > bestY then
						bestY = topY
					end
				end
			end
		end
	end
	return bestY
end

local function destroyWaterPlatform()
	if WaterWalkPlat then
		WaterWalkPlat:Destroy()
		WaterWalkPlat = nil
	end
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
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = Workspace
	WaterWalkPlat = part
	return part
end

local function stopWaterWalk()
	if WaterWalkConn then
		WaterWalkConn:Disconnect()
		WaterWalkConn = nil
	end
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
		if not surfaceY then
			destroyWaterPlatform()
			return
		end

		local platform = createWaterPlatform()
		local targetY = surfaceY - 1

		local curY = platform.Position.Y
		local smoothY = curY + (targetY - curY) * 0.5

		platform.CFrame = CFrame.new(hrp.Position.X, smoothY, hrp.Position.Z)

		if hrp.Position.Y < surfaceY + 2 then
			hrp.CFrame = CFrame.new(hrp.Position.X, surfaceY + 3, hrp.Position.Z)
				* (hrp.CFrame - hrp.Position)
			hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
		end

		if humanoid:GetState() == Enum.HumanoidStateType.Swimming then
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	end)
end

-- Toggle Walk Water
PlayerTab:CreateToggle({
	Name = "Walk Water",
	CurrentValue = false,
	Flag = "WalkWaterToggle",
	Callback = function(Value)
		WaterWalkEnabled = Value
		if Value then
			startWaterWalk()
		else
			stopWaterWalk()
		end
	end,
})

LocalPlayer.CharacterAdded:Connect(function(character)
	destroyWaterPlatform()
	if not WaterWalkEnabled then return end
	character:WaitForChild("HumanoidRootPart", 5)
	task.wait(0.1)
	if WaterWalkEnabled then
		startWaterWalk()
	end
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

		Rayfield:Notify({
			Title = "Gan I Gravity",
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
		if GravityEnabled then
			Workspace.Gravity = GravityValue
		end
	end,
})

PlayerTab:CreateSection("Camera")

PlayerTab:CreateToggle({
	Name = "Fov Camera",
	CurrentValue = false,
	Flag = "FovCameraToggle",
	Callback = function(Value)
		FovCameraEnabled = Value
		if Value then
			startFovLock()
			applyFov()
		else
			stopFovLock()
			applyFov()
		end
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
		if FovCameraEnabled then
			Camera.FieldOfView = Value
		end
	end,
})

local function applyThirdPerson()
	pcall(function()
		if ThirdPersonEnabled then
			LocalPlayer.CameraMaxZoomDistance = ThirdPersonMaxZoom
			LocalPlayer.CameraMode = Enum.CameraMode.Classic
		else
			-- คืนค่าเป็น first person
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
	if ThirdPersonConn then
		ThirdPersonConn:Disconnect()
		ThirdPersonConn = nil
	end
end

PlayerTab:CreateToggle({
	Name = "Third Person",
	CurrentValue = false,
	Flag = "ThirdPersonToggle",
	Callback = function(Value)
		ThirdPersonEnabled = Value
		if Value then
			applyThirdPerson()
			startThirdPersonLock()
		else
			stopThirdPersonLock()
			applyThirdPerson()
		end
	end,
})
