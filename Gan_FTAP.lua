-- ============================================
-- TIMER (เริ่มจับเวลาตั้งแต่บรรทัดแรก)
-- ============================================
local _startTime = tick()

-- ============================================
-- THEME
-- ============================================
MatrixRed = {
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
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Guard flag: กัน callback ยิงตอน Rayfield โหลด config
local _isReady = false

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

-- ⬇️ คำนวณเวลาจริงที่ใช้โหลด (วินาที)
local _loadTime = string.format("%.2fs", tick() - _startTime)

Rayfield:Notify({
   Title = "Gan I Loaded",
   Content = "Script Loaded In " .. _loadTime,
   Duration = 6.5,
   Image = "timer",
})

local PlayerTab = Window:CreateTab("Player", "user-2")

TPWalk_Enabled = false
TPWalk_Studs   = 1.0
TPWalk_Conn    = nil
InfJumpEnabled = false
NoclipEnabled = false
InfJumpEnabled = false
InfJumpModeOptions = {"Hold Jump", "Jump Once"}
InfjumpCurrentOptions = "Hold Jump"
FlyEnabled

PlayerTab:CreateDivider()
PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
    Name = "Walkspeed",
    CurrentValue = false,
    Flag = "Walkspeed_Toggle",
    IgnoreLoad = true,   -- ไม่ auto-fire ตอนโหลด config
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
    IgnoreLoad = true,   -- ค่า slider ก็ไม่โหลดคืน
    Callback = function(Value)
        if not _isReady then return end
        TPWalk_Studs = Value
    end,
})

-- ============================================
-- หลัง UI สร้างเสร็จ ให้ guard เปิดใช้งาน
-- ============================================
task.defer(function()
    task.wait(0.5)   -- รอ Rayfield โหลด config เสร็จ
    _isReady = true
    TPWalk_Enabled = false
    TPWalk_Studs = 1.0
end)

PlayerTab:CreateParagraph({
    Title = "Walkspeed Guide",
    Content = "0.1 = 1 per Tpwalk"
})

local NoclipEnabled = false
local NoclipConnection = nil

-- ฟังก์ชันปิดการชน (CanCollide = false) สำหรับทุกชิ้นส่วนในตัวละคร
local function SetNoclip(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- สร้าง UI Toggle พร้อมระบบ Stepped Connection
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipEnabled = Value

        if NoclipEnabled then
            -- เริ่มลูป Noclip ทุกๆ physics step เพื่อป้องกันตัวละครกลับมาแข็ง
            NoclipConnection = RunService.Stepped:Connect(function()
                if NoclipEnabled and LocalPlayer.Character then
                    SetNoclip(LocalPlayer.Character)
                end
            end)
        else
            -- ยกเลิกลูปเมื่อปิดใช้งาน
            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end
        end
    end,
})

local canJump = true

-- ฟังชันก์ตรวจจับการกดกระโดด
UserInputService.JumpRequest:Connect(function()
    if not InfJumpEnabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if InfJumpCurrentMode == "Jump Once" then
        -- โหมด Jump Once: ต้องปล่อยปุ่มกระโดดก่อนถึงจะกดกระโดดกลางอากาศครั้งถัดไปได้
        if canJump then
            canJump = false
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    elseif InfJumpCurrentMode == "Hold Jump" then
        -- โหมด Hold Jump: สามารถกระโดดรัวๆ ได้ทันทีเมื่อกดค้าง
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- รีเซ็ตสถานะการกระโดดเมื่อแตะพื้น (เฉพาะโหมด Jump Once)
local function SetupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            canJump = true
        end
    end)
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)

-- UI Toggle สำหรับเปิด-ปิด Infinite Jump
PlayerTab:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        InfJumpEnabled = Value
    end,
})

-- UI Dropdown สำหรับเลือกโหมดการกระโดด
PlayerTab:CreateDropdown({
    Name = "Select Mode Inf Jump",
    Options = InfJumpModeOptions,
    CurrentOption = InfJumpCurrentMode,
    MultipleOptions = false,
    Flag = "InfJumpMode",
    Callback = function(Mode)
        -- รองรับทั้งกรณีที่ Callback ส่งมาเป็น Table หรือ String
        if type(Mode) == "table" then
            InfJumpCurrentMode = Mode[1] or "Jump Once"
        else
            InfJumpCurrentMode = Mode
        end
    end,
})

local FlyEnabled = false
local FlySpeed = 16

local bodyGyro, bodyVelocity
local flyConnection = nil

-- ฟังก์ชันสำหรับเปิด/ปิด และควบคุมการบิน
local function UpdateFlyState(enabled)
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end

    if enabled then
        humanoid.PlatformStand = true

        -- สร้าง BodyGyro และ BodyVelocity สำหรับควบคุมทิศทางและความเร็วในการบิน
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = humanoidRootPart

        flyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled or not character.Parent then return end
            
            local camCF = Camera.CFrame
            local moveDir = Vector3.zero

            -- ตรวจสอบการกดปุ่มเคลื่อนไหว (WASD / Arrow Keys)
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
            bodyVelocity.Velocity = moveDir.Unit * FlySpeed
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

-- รีเซ็ตสถานะการบินเมื่อตัวละครเกิดใหม่
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    FlyEnabled = false
    UpdateFlyState(false)
end)

-- UI Toggle สำหรับเปิด-ปิดการบิน
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        FlyEnabled = Value
        UpdateFlyState(FlyEnabled)
    end,
})

-- UI Slider สำหรับปรับความเร็วในการบิน
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
