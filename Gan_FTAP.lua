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
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============================================
-- TP WALK STATE
-- ============================================
local TPWalk_Enabled = false
local TPWalk_Studs   = 1.0
local TPWalk_Conn    = nil

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

-- ============================================
-- UI: MOVEMENT
-- ============================================
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
