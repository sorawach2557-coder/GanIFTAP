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

-- ============================================
-- STATE (ประกาศครั้งเดียว, มี local ทั้งหมด)
-- ============================================
local _isReady = false          -- guard: กัน callback ยิงตอน Rayfield โหลด config

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

		-- คงสูตรเดิมไว้ (normalize เป็น 60fps)
		local step = TPWalk_Studs * (dt * 60)
		hrp.CFrame = hrp.CFrame + hum.MoveDirection * step
	end)
end

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
			-- กัน connection ซ้ำ
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
-- INF JUMP - Jump Once (กด Spacebar 1 ครั้ง = ลอยขึ้นไปเรื่อยๆ ไม่หยุด)
-- ============================================
InfJumpActive = false   -- toggle: กด Space 1 ครั้ง = เปิด/ปิดการลอยขึ้น

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode ~= Enum.KeyCode.Space then return end
    if not InfJumpEnabled then return end
    if InfJumpCurrentMode ~= "Jump Once" then return end

    -- กด 1 ครั้ง → สลับสถานะ เปิด/ปิด
    InfJumpActive = not InfJumpActive
end)

-- ลูปดันตัวขึ้นเรื่อยๆ (ไม่ต้องกดอะไรอีก)
RunService.Heartbeat:Connect(function(dt)
    if not InfJumpEnabled then return end
    if InfJumpCurrentMode ~= "Jump Once" then return end
    if not InfJumpActive then return end

    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- ดัน HumanoidRootPart ขึ้นทุกเฟรม (ความเร็วคงที่)
    hrp.CFrame = hrp.CFrame + Vector3.new(0, 2 * (dt * 60), 0)
end)

-- 2. โหมด Hold Jump: เช็คว่าถ้าปุ่ม Spacebar/Jump ค้างไว้อยู่ ให้กระโดดรัวๆ ทุกเฟรม physics
RunService.RenderStepped:Connect(function()
    if not InfJumpEnabled then return end
    if InfJumpCurrentMode ~= "Hold Jump" then return end
    
    -- เช็คว่าผู้เล่นกำลังกดปุ่ม Spacebar ค้างไว้หรือไม่
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

-- UI Toggle
PlayerTab:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        InfJumpEnabled = Value
    end,
})

-- UI Dropdown
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

			-- *** แก้บั๊ก NaN: ต้องเช็ค magnitude ก่อนใช้ .Unit ***
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
