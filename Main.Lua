-- meowlua PRO — full kill-and-shield rails, one throttled loop, zero bloat.
-- Built by Olivia — https://discord.gg/ojailbreaks
-- absolute ollie, built by olivia

if getgenv()._meow_pro_loaded then return end
getgenv()._meow_pro_loaded = true

local run_service = game:GetService("RunService")
local rs          = game:GetService("ReplicatedStorage")
local uis         = game:GetService("UserInputService")
local players     = game:GetService("Players")
local cs_svc      = game:GetService("CollectionService")
local lighting    = game:GetService("Lighting")
local lp          = players.LocalPlayer
local cam         = workspace.CurrentCamera

-- ============ CONFIG ======================================================
local C = {
    -- movement
    fly = false, fly_speed = 140,
    walkspeed = false, walkspeed_v = 60,
    jumppower = false, jumppower_v = 90,
    infjump = false, bhop = false,
    noclip = false, airwalk = false,
    jump_height = false, jump_height_v = 7.2,
    gravity_override = false, gravity_v = 60,
    -- aim
    silent_aim = false, silent_part = "Head",
    aim_assist = false, aim_assist_s = 0.4, aim_fov = 250,
    triggerbot = false, triggerbot_cursor = 20,
    auto_headshot = true,
    kill_aura = false, kill_aura_r = 60, kill_aura_d = 999,
    multi_kill_aura = false,
    backtrack = false, backtrack_ticks = 10,
    damage_mult = false, damage_mult_v = 10,
    melee_combo = false,
    perfect_deflect = false,
    no_spread = false, no_recoil = false,
    -- invuln
    godmode = false,
    hp_lock = false,
    raycast_blind = false,
    hp_newindex_trap = false,
    remote_reject = false,
    namecall_block = false,
    -- counters (single dispatch pass)
    counter_all = false,
    counter_elisium = false,
    counter_phonk = false,
    counter_ue = false,
    counter_sleepy = false,
    counter_kicia = false,
    counter_yokai = false,
    counter_azlat = false,
    -- visuals
    esp_enemies = false,
    chams = false, chams_color_r = 255, chams_color_g = 60, chams_color_b = 60,
    hp_hud = false,
    fullbright = false,
    watermark = false,
    crosshair = false, crosshair_size = 10, crosshair_gap = 4, crosshair_thick = 2,
    low_hp_highlight = false, low_hp_t = 30,
    -- misc
    anti_afk = true,
    no_fall_dmg = false,
    inf_ammo = false,
    pickup_magnet = false, pickup_r = 25,
    auto_heal_consume = false, auto_heal_hp = 50,
    server_info = false,
    rank_spoof = false, rank_spoof_text = "ULTRON",
    votekick_immune = true,
    anti_kick = true,
    -- perf
    throttle_ms = 80,
    render_throttle_ms = 16,
}

-- ============ STATE =======================================================
local State = { conns = {}, renders = {}, draws = {}, backtrack_ring = {} }
local function bindConn(name, c)
    if State.conns[name] then pcall(function() State.conns[name]:Disconnect() end) end
    State.conns[name] = c
end
local function bindRender(name, fn)
    if State.renders[name] then pcall(run_service.UnbindFromRenderStep, run_service, "meow_" .. name) end
    State.renders[name] = fn
    run_service:BindToRenderStep("meow_" .. name, 1, fn)
end
local function new_draw(kind, name)
    local d = Drawing.new(kind); State.draws[name] = d; d.Visible = false; return d
end

-- ============ HELPERS =====================================================
local function get_hrp(p) local c = (p or lp).Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function get_hum(p) local c = (p or lp).Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function get_head(ch) return ch and (ch:FindFirstChild("Head") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("HumanoidRootPart")) end
local function alive(p)
    if not p or not p.Character then return false end
    local h = p.Character:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
local function dist2d(v, m) local sp, on = cam:WorldToViewportPoint(v); return on, on and (Vector2.new(sp.X, sp.Y) - m).Magnitude or math.huge, sp end

local function closest_to_cursor()
    local best, best_s = nil, math.huge
    local mouse = uis:GetMouseLocation()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and alive(p) then
            local h = p.Character:FindFirstChild(C.silent_part) or get_head(p.Character)
            if h then
                local on, d = dist2d(h.Position, mouse)
                if on and d < C.aim_fov and d < best_s then best_s = d; best = h end
            end
        end
    end
    return best
end
local function closest_in_world()
    local me = get_hrp(lp); if not me then return nil end
    local best, best_s = nil, math.huge
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and alive(p) then
            local php = get_hrp(p)
            if php then
                local d = (php.Position - me.Position).Magnitude
                if d < best_s then best_s = d; best = p end
            end
        end
    end
    return best
end

-- notify shim
local function notify(t, d)
    pcall(function()
        if getgenv().meow_lib then
            if d then getgenv().meow_lib:Notify({ Title = t, Description = d, Time = 3 })
            else getgenv().meow_lib:Notify({ Title = t, Time = 3 }) end
        end
    end)
end

-- ============ FLY =========================================================
local fly_bv, fly_bg
bindConn("fly", run_service.Heartbeat:Connect(function()
    if not C.fly then
        if fly_bv then pcall(function() fly_bv:Destroy() end); fly_bv = nil end
        if fly_bg then pcall(function() fly_bg:Destroy() end); fly_bg = nil end
        return
    end
    local hrp = get_hrp(lp); if not hrp then return end
    if not fly_bv or not fly_bv.Parent then
        fly_bv = Instance.new("BodyVelocity"); fly_bv.MaxForce = Vector3.new(1e9,1e9,1e9); fly_bv.Velocity = Vector3.zero; fly_bv.Parent = hrp
        fly_bg = Instance.new("BodyGyro"); fly_bg.MaxTorque = Vector3.new(1e9,1e9,1e9); fly_bg.P = 9000; fly_bg.Parent = hrp
    end
    local d = Vector3.zero
    if uis:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
    if uis:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
    if uis:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
    if uis:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
    if uis:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
    if uis:IsKeyDown(Enum.KeyCode.LeftControl) then d = d - Vector3.new(0,1,0) end
    if d.Magnitude > 0 then d = d.Unit end
    fly_bv.Velocity = d * C.fly_speed
    fly_bg.CFrame = cam.CFrame
end))

-- ============ INF JUMP / BHOP ============================================
bindConn("jumpreq", uis.JumpRequest:Connect(function()
    if C.infjump or C.bhop then
        local h = get_hum(); if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    end
end))

-- ============ MAIN THROTTLED DISPATCHER ==================================
local disp_last = 0
bindConn("dispatch", run_service.Heartbeat:Connect(function()
    if tick() - disp_last < (C.throttle_ms / 1000) then return end
    disp_last = tick()

    local c = lp.Character; local hum = c and c:FindFirstChildOfClass("Humanoid"); local hrp = c and c:FindFirstChild("HumanoidRootPart")

    -- MOVEMENT APPLY
    if hum then
        if C.walkspeed then pcall(function() hum.WalkSpeed = C.walkspeed_v end) end
        if C.jumppower then pcall(function() hum.UseJumpPower = true; hum.JumpPower = C.jumppower_v end) end
        if C.jump_height then pcall(function() hum.UseJumpPower = false; hum.JumpHeight = C.jump_height_v end) end
        if C.godmode then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum.BreakJointsOnDeath = false
                hum.MaxHealth = 1e9; hum.Health = 1e9
            end)
        end
        if C.hp_lock and hum.Health < 1e8 then pcall(function() hum.Health = 1e9 end) end
    end

    -- GRAVITY
    if C.gravity_override then pcall(function() workspace.Gravity = C.gravity_v end) end

    -- NOCLIP
    if C.noclip and c then
        for _, p in ipairs(c:GetChildren()) do
            if p:IsA("BasePart") and p.CanCollide then pcall(function() p.CanCollide = false end) end
        end
    end

    -- COUNTERS (single pass)
    if c then
        if C.counter_elisium or C.counter_all then
            if not c:FindFirstChild("MeowFakeFF") then
                local ff = Instance.new("ForceField"); ff.Name = "MeowFakeFF"; ff.Visible = false; ff.Parent = c
            end
        end
        if C.counter_yokai or C.counter_all then
            if not c:FindFirstChild("MeowRiotShield_riot") then
                local p = Instance.new("Part"); p.Name = "MeowRiotShield_riot"; p.Size = Vector3.new(0.05,0.05,0.05)
                p.Transparency = 1; p.CanCollide = false; p.Massless = true; p.Parent = c
                if hrp then local w = Instance.new("WeldConstraint"); w.Part0 = p; w.Part1 = hrp; w.Parent = p end
            end
        end
        if C.counter_phonk or C.counter_all then pcall(function() c:SetAttribute("Deflecting", true) end) end
        if C.counter_sleepy or C.counter_all then
            pcall(function() if cs_svc:HasTag(c, "Entity") then cs_svc:RemoveTag(c, "Entity") end end)
            local head = c:FindFirstChild("Head")
            if head and head:IsA("BasePart") then pcall(function() head.Size = Vector3.new(0.1,0.1,0.1) end) end
        end
        if C.counter_kicia or C.counter_all then
            if hrp then pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end) end
        end
        if C.counter_ue or C.counter_all then
            local head = c:FindFirstChild("Head"); local decoy = c:FindFirstChild("LeftFoot") or c:FindFirstChild("RightFoot")
            if head and decoy then
                pcall(function() head.Name = "NotHead_" .. math.random(100,999); decoy.Name = "Head"
                    task.delay(0.05, function() pcall(function() if head and head.Parent then head.Name = "Head"; decoy.Name = "LeftFoot" end end) end)
                end)
            end
        end
        if C.counter_azlat or C.counter_all then pcall(function() c:SetAttribute("Rank", "guest") end) end
    end

    if C.perfect_deflect and c then pcall(function() c:SetAttribute("Deflecting", true) end) end
    if C.rank_spoof then pcall(function() lp:SetAttribute("Rank", C.rank_spoof_text) end) end

    -- KILL AURA / MULTI KILL AURA
    if (C.kill_aura or C.multi_kill_aura) and hrp then
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and alive(p) then
                local php = get_hrp(p); local phum = get_hum(p)
                if phum and php and (php.Position - hrp.Position).Magnitude < C.kill_aura_r then
                    pcall(function() phum:TakeDamage(C.kill_aura_d) end)
                    if C.multi_kill_aura then
                        for i = 1, 3 do pcall(function() phum:TakeDamage(C.kill_aura_d) end) end
                    end
                end
            end
        end
    end

    -- BACKTRACK ring
    if C.backtrack then
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and p.Character then
                local php = get_hrp(p)
                if php then
                    State.backtrack_ring[p] = State.backtrack_ring[p] or {}
                    local r = State.backtrack_ring[p]
                    table.insert(r, 1, php.Position)
                    while #r > C.backtrack_ticks do table.remove(r) end
                end
            end
        end
    end

    -- LOW HP HIGHLIGHT
    if C.low_hp_highlight then
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and p.Character then
                local phum = get_hum(p)
                if phum and phum.Health > 0 and phum.Health < C.low_hp_t then
                    if not p.Character:FindFirstChild("MeowLowHP") then
                        local hl = Instance.new("Highlight"); hl.Name = "MeowLowHP"
                        hl.FillColor = Color3.fromRGB(255,30,30); hl.FillTransparency = 0.3; hl.Parent = p.Character
                    end
                else
                    local hl = p.Character and p.Character:FindFirstChild("MeowLowHP")
                    if hl then hl:Destroy() end
                end
            end
        end
    end

    -- PICKUP MAGNET
    if C.pickup_magnet and hrp then
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("BasePart") and (item.Name:lower():find("pickup") or item.Name:lower():find("ammo") or item.Name:lower():find("drop")) then
                if (item.Position - hrp.Position).Magnitude < C.pickup_r then
                    pcall(function() item.CFrame = hrp.CFrame end)
                end
            end
        end
    end

    -- INF AMMO
    if C.inf_ammo then
        pcall(function()
            local fc = rs:FindFirstChild("FighterController")
            if fc then
                local ok, mod = pcall(require, fc)
                if ok and mod and mod.LocalFighter and mod.LocalFighter.Hand and mod.LocalFighter.Hand.MaxAmmo then
                    mod.LocalFighter.Hand.Ammo = mod.LocalFighter.Hand.MaxAmmo
                end
            end
        end)
    end

    -- AUTO HEAL CONSUME
    if C.auto_heal_consume and hum and hum.Health < C.auto_heal_hp then
        pcall(function()
            local fc = rs:FindFirstChild("FighterController")
            if fc then
                local ok, mod = pcall(require, fc)
                if ok and mod and mod.LocalFighter then
                    mod.LocalFighter:EquipSlot(4)
                    mod.LocalFighter:Input("UseItem")
                end
            end
        end)
    end

    -- NO FALL DAMAGE
    if C.no_fall_dmg and hrp and hrp.AssemblyLinearVelocity.Y < -80 then
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -10, hrp.AssemblyLinearVelocity.Z) end)
    end

    -- AIRWALK
    if C.airwalk and hrp and hum then
        if hum:GetState() == Enum.HumanoidStateType.Freefall then
            local pad = c:FindFirstChild("MeowAirPad")
            if not pad then
                pad = Instance.new("Part"); pad.Name = "MeowAirPad"
                pad.Size = Vector3.new(4,0.2,4); pad.Transparency = 1; pad.Anchored = true; pad.CanCollide = true
                pad.Parent = c
            end
            pcall(function() pad.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3, 0)) end)
        else
            local pad = c:FindFirstChild("MeowAirPad"); if pad then pad:Destroy() end
        end
    end
end))

-- ============ AIM ASSIST (RenderStepped, light) ==========================
bindConn("aim_assist", run_service.RenderStepped:Connect(function()
    if not C.aim_assist then return end
    local t = closest_to_cursor(); if not t then return end
    local cur = cam.CFrame
    cam.CFrame = cur:Lerp(CFrame.new(cur.Position, t.Position), math.clamp(C.aim_assist_s, 0.01, 1))
end))

-- ============ TRIGGERBOT =================================================
local tb_last = 0
bindConn("triggerbot", run_service.Heartbeat:Connect(function()
    if not C.triggerbot then return end
    if tick() - tb_last < 0.08 then return end
    tb_last = tick()
    local t = closest_to_cursor(); if not t then return end
    local mouse = uis:GetMouseLocation()
    local on, d = dist2d(t.Position, mouse)
    if on and d < C.triggerbot_cursor then
        pcall(function()
            local fc = rs:FindFirstChild("FighterController")
            if fc then
                local ok, mod = pcall(require, fc)
                if ok and mod and mod.LocalFighter then
                    mod.LocalFighter:Input("StartShooting")
                    task.wait(0.03)
                    mod.LocalFighter:Input("StopShooting")
                end
            end
        end)
    end
end))

-- ============ MELEE COMBO =================================================
local mc_last = 0
bindConn("melee_combo", run_service.Heartbeat:Connect(function()
    if not C.melee_combo then return end
    if tick() - mc_last < 0.1 then return end
    mc_last = tick()
    pcall(function()
        local fc = rs:FindFirstChild("FighterController")
        if fc then
            local ok, mod = pcall(require, fc)
            if ok and mod and mod.LocalFighter then
                mod.LocalFighter:Input("StartShooting")
                task.wait(0.02)
                mod.LocalFighter:Input("StopShooting")
            end
        end
    end)
end))

-- ============ ESP (throttled 1Hz, highlight-based) =======================
local esp_last = 0
bindConn("esp", run_service.Heartbeat:Connect(function()
    if not C.esp_enemies and not C.chams then
        if esp_last > 0 then
            for _, p in ipairs(players:GetPlayers()) do
                if p.Character then
                    local hl = p.Character:FindFirstChild("MeowESP"); if hl then hl:Destroy() end
                end
            end
            esp_last = 0
        end
        return
    end
    if tick() - esp_last < 0.5 then return end
    esp_last = tick()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("MeowESP")
            if not hl then
                hl = Instance.new("Highlight"); hl.Name = "MeowESP"
                hl.OutlineColor = Color3.fromRGB(255,255,255); hl.Parent = p.Character
            end
            hl.FillColor = Color3.fromRGB(C.chams_color_r, C.chams_color_g, C.chams_color_b)
            hl.FillTransparency = C.chams and 0.3 or 1
            hl.OutlineTransparency = C.esp_enemies and 0 or 1
        end
    end
end))

-- ============ FULLBRIGHT =================================================
bindConn("fullbright", run_service.Heartbeat:Connect(function()
    if not C.fullbright then return end
    pcall(function()
        lighting.Ambient = Color3.new(1,1,1)
        lighting.FogEnd = 1e9
        lighting.Brightness = 2
    end)
end))

-- ============ HP HUD (Drawing text) ======================================
local hp_texts = {}
bindRender("hp_hud", function()
    if not C.hp_hud then
        for _, t in pairs(hp_texts) do t.Visible = false end; return
    end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local head = p.Character:FindFirstChild("Head"); local hum = get_hum(p)
            if head and hum then
                hp_texts[p] = hp_texts[p] or new_draw("Text", "hp_"..p.Name)
                local t = hp_texts[p]
                t.Size = 14; t.Color = Color3.fromRGB(255,80,80); t.Outline = true; t.Center = true
                local sp, on = cam:WorldToViewportPoint(head.Position + Vector3.new(0,2.5,0))
                if on then t.Position = Vector2.new(sp.X, sp.Y); t.Text = math.floor(hum.Health); t.Visible = true else t.Visible = false end
            end
        end
    end
end)

-- ============ CROSSHAIR ==================================================
local xh = { up=new_draw("Line","xh_u"), down=new_draw("Line","xh_d"), left=new_draw("Line","xh_l"), right=new_draw("Line","xh_r") }
for _, l in pairs(xh) do l.Thickness = 1; l.Color = Color3.fromRGB(0,255,0) end
bindRender("crosshair", function()
    local on = C.crosshair; for _, l in pairs(xh) do l.Visible = on end
    if not on then return end
    local cx, cy = cam.ViewportSize.X/2, cam.ViewportSize.Y/2
    local s, g, th = C.crosshair_size, C.crosshair_gap, C.crosshair_thick
    for _, l in pairs(xh) do l.Thickness = th end
    xh.up.From    = Vector2.new(cx, cy - g); xh.up.To    = Vector2.new(cx, cy - g - s)
    xh.down.From  = Vector2.new(cx, cy + g); xh.down.To  = Vector2.new(cx, cy + g + s)
    xh.left.From  = Vector2.new(cx - g, cy); xh.left.To  = Vector2.new(cx - g - s, cy)
    xh.right.From = Vector2.new(cx + g, cy); xh.right.To = Vector2.new(cx + g + s, cy)
end)

-- ============ WATERMARK + SERVER INFO HUD ================================
local wm_text = new_draw("Text", "wm"); wm_text.Size = 14; wm_text.Color = Color3.fromRGB(255,255,255); wm_text.Outline = true
local si_text = new_draw("Text", "si"); si_text.Size = 14; si_text.Color = Color3.fromRGB(180,255,180); si_text.Outline = true
bindRender("hud_text", function()
    wm_text.Visible = C.watermark; si_text.Visible = C.server_info
    if C.watermark then
        wm_text.Position = Vector2.new(10, 10)
        wm_text.Text = string.format("meowlua | %d fps | %s", math.floor(1/math.max(run_service.Heartbeat:Wait(),0.001)), lp.Name)
    end
    if C.server_info then
        si_text.Position = Vector2.new(10, cam.ViewportSize.Y - 30)
        si_text.Text = string.format("players: %d | job: %s", #players:GetPlayers(), tostring(game.JobId):sub(1,8))
    end
end)

-- ============ ANTI AFK ===================================================
pcall(function()
    local vu = game:GetService("VirtualUser")
    lp.Idled:Connect(function()
        if not C.anti_afk then return end
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1); vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ============ NAMECALL HOOK CHAIN (single install) =======================
local _hook_installed = false
local function install_hooks()
    if _hook_installed then return end
    _hook_installed = true
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local m = getnamecallmethod()
        local tp = typeof(self)

        -- SILENT AIM: bend Vector3 args of shoot remotes
        if C.silent_aim and tp == "Instance" and (m == "FireServer" or m == "InvokeServer") then
            local n = tostring(self.Name):lower()
            if n:find("shoot") or n:find("fire") or n:find("useitem") or n:find("hit") or n:find("item") or n:find("fighter") then
                local target = closest_to_cursor()
                if target then
                    local args = { ... }
                    for i, a in ipairs(args) do
                        if typeof(a) == "Vector3" then args[i] = target.Position
                        elseif typeof(a) == "CFrame" then args[i] = CFrame.new(target.Position) end
                    end
                    return old(self, table.unpack(args))
                end
            end
        end

        -- RAYCAST BLIND: inject our character into untrusted raycasts
        if C.raycast_blind and tp == "Instance" and m == "Raycast" and self:IsA("WorldRoot") then
            local caller = (getcallingscript and pcall(getcallingscript)) and getcallingscript() or nil
            if caller and caller ~= script then
                local args = { ... }
                local c = lp.Character
                if c and typeof(args[3]) == "RaycastParams" then
                    local new = RaycastParams.new()
                    new.FilterType = Enum.RaycastFilterType.Exclude
                    local merged = {}
                    for _, inst in ipairs(args[3].FilterDescendantsInstances or {}) do merged[#merged+1] = inst end
                    merged[#merged+1] = c
                    new.FilterDescendantsInstances = merged
                    return old(self, args[1], args[2], new)
                end
            end
        end

        -- NAMECALL BLOCK: swallow TakeDamage/Kill on our Humanoid from untrusted
        if C.namecall_block and tp == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character then
                local caller = (getcallingscript and pcall(getcallingscript)) and getcallingscript() or nil
                if caller and caller ~= script then
                    if m == "TakeDamage" or m == "Kill" or m == "BreakJoints" then return 0 end
                    if m == "ChangeState" then local s = ...; if s == Enum.HumanoidStateType.Dead then return end end
                end
            end
        end

        -- REMOTE REJECT: swallow damage/hit/kill FireServer from untrusted scripts if target is us
        if C.remote_reject and tp == "Instance" and m == "FireServer" and self:IsA("RemoteEvent") then
            local caller = (getcallingscript and pcall(getcallingscript)) and getcallingscript() or nil
            if caller and caller ~= script then
                local n = tostring(self.Name):lower()
                if n:find("damage") or n:find("kill") or n:find("hit") or n:find("die") or n:find("void") then
                    for _, a in ipairs({ ... }) do
                        if typeof(a) == "Instance" then
                            if a == lp or a == lp.Character or (lp.Character and a:IsDescendantOf(lp.Character)) then return end
                        end
                    end
                end
            end
        end

        -- ANTI KICK
        if C.anti_kick and tp == "Instance" and m == "Kick" and self == lp then return end

        return old(self, ...)
    end))

    -- __newindex trap for Humanoid.Health from untrusted
    local old_ni
    old_ni = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if C.hp_newindex_trap and typeof(self) == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character and (key == "Health" or key == "MaxHealth") then
                local caller = (getcallingscript and pcall(getcallingscript)) and getcallingscript() or nil
                if caller and caller ~= script and key == "Health" and typeof(value) == "number" and value < self.MaxHealth then
                    return
                end
            end
        end
        return old_ni(self, key, value)
    end))
end

-- ============ OBSIDIAN UI ================================================
local lib_ok, library = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))() end)
if not lib_ok or not library then
    warn("meowlua pro: UI library failed to load. Core logic active.")
    install_hooks()
    return
end
getgenv().meow_lib = library

install_hooks()

local window = library:CreateWindow({ Title = "meowlua PRO", Center = true, AutoShow = true, Footer = "absolute ollie | discord.gg/ojailbreaks" })
local tabs = {
    rage = window:AddTab("Rage"),
    aim  = window:AddTab("Aim"),
    move = window:AddTab("Movement"),
    god  = window:AddTab("Invuln"),
    vis  = window:AddTab("Visuals"),
    misc = window:AddTab("Misc"),
}

local function T(b, id, t, d, cb, def)
    local tg = b:AddToggle(id, { Text = t, Default = def or false, Tooltip = d })
    tg:OnChanged(function() cb(tg.Value) end)
    return tg
end

-- RAGE tab
local rb = tabs.rage:AddLeftGroupbox("Kill")
T(rb,"ka","Kill Aura","Damage all enemies in radius.",function(v) C.kill_aura = v end)
T(rb,"mka","Multi Kill Aura","4x damage ticks per pass.",function(v) C.multi_kill_aura = v end)
rb:AddSlider("kar",{Text="Aura Radius",Default=60,Min=10,Max=300,Rounding=0}):OnChanged(function(v) C.kill_aura_r = v end)
rb:AddSlider("kad",{Text="Aura Damage",Default=999,Min=10,Max=9999,Rounding=0}):OnChanged(function(v) C.kill_aura_d = v end)
T(rb,"bt","Backtrack","Keep ring buffer of enemy positions.",function(v) C.backtrack = v end)
rb:AddSlider("btt",{Text="Backtrack Ticks",Default=10,Min=2,Max=30,Rounding=0}):OnChanged(function(v) C.backtrack_ticks = v end)
T(rb,"mc","Melee Combo","Auto StartShooting burst for katana.",function(v) C.melee_combo = v end)
T(rb,"pd","Perfect Deflect","Keeps Deflecting=true on your character.",function(v) C.perfect_deflect = v end)
T(rb,"ns","No Spread","Fake hook flag.",function(v) C.no_spread = v end)
T(rb,"nr","No Recoil","Fake hook flag.",function(v) C.no_recoil = v end)

local rc = tabs.rage:AddRightGroupbox("Counter Rivals")
T(rc,"c_all","Counter ALL","Every rival defense on.",function(v) C.counter_all = v end)
T(rc,"c_el","Counter Elisium","Fake invisible ForceField.",function(v) C.counter_elisium = v end)
T(rc,"c_ph","Counter Phonk Ware","Deflecting attr.",function(v) C.counter_phonk = v end)
T(rc,"c_ue","Counter UE","Head rename swap.",function(v) C.counter_ue = v end)
T(rc,"c_sl","Counter Sleepy","Remove Entity tag + shrink head.",function(v) C.counter_sleepy = v end)
T(rc,"c_ki","Counter Kicia","Zero velocity.",function(v) C.counter_kicia = v end)
T(rc,"c_yk","Counter Yokai","Fake riot-shield part.",function(v) C.counter_yokai = v end)
T(rc,"c_az","Counter Azlat","Rank attribute spoof.",function(v) C.counter_azlat = v end)

-- AIM tab
local aim = tabs.aim:AddLeftGroupbox("Aim")
T(aim,"sa","Silent Aim","Bend shoot-remote Vector3 args to cursor-closest.",function(v) C.silent_aim = v end)
aim:AddDropdown("sp",{Text="Silent Part",Default="Head",Values={"Head","UpperTorso","Torso","HumanoidRootPart"}}):OnChanged(function(v) C.silent_part = v end)
T(aim,"aa","Aim Assist","Camera lerps toward closest.",function(v) C.aim_assist = v end)
aim:AddSlider("aas",{Text="Smooth",Default=0.4,Min=0.05,Max=1,Rounding=2}):OnChanged(function(v) C.aim_assist_s = v end)
aim:AddSlider("fov",{Text="FOV",Default=250,Min=30,Max=1000,Rounding=0}):OnChanged(function(v) C.aim_fov = v end)
T(aim,"tb","Triggerbot","Fire when cursor on target.",function(v) C.triggerbot = v end)
aim:AddSlider("tbc",{Text="Trigger Px Radius",Default=20,Min=2,Max=200,Rounding=0}):OnChanged(function(v) C.triggerbot_cursor = v end)
T(aim,"ah","Auto Headshot","Always target Head.",function(v) C.auto_headshot = v end, true)

-- MOVEMENT tab
local mv = tabs.move:AddLeftGroupbox("Movement")
T(mv,"fly","Fly","WASD + Space/LCtrl.",function(v) C.fly = v end)
mv:AddSlider("fs",{Text="Fly Speed",Default=140,Min=20,Max=500,Rounding=0}):OnChanged(function(v) C.fly_speed = v end)
T(mv,"ws","Walkspeed","Hard-set humanoid speed.",function(v) C.walkspeed = v end)
mv:AddSlider("wsv",{Text="Walkspeed",Default=60,Min=16,Max=500,Rounding=0}):OnChanged(function(v) C.walkspeed_v = v end)
T(mv,"jp","JumpPower","Hard-set jump power.",function(v) C.jumppower = v end)
mv:AddSlider("jpv",{Text="JumpPower",Default=90,Min=20,Max=1000,Rounding=0}):OnChanged(function(v) C.jumppower_v = v end)
T(mv,"jh","Jump Height","Alt jump via JumpHeight.",function(v) C.jump_height = v end)
mv:AddSlider("jhv",{Text="Jump Height",Default=7.2,Min=1,Max=50,Rounding=1}):OnChanged(function(v) C.jump_height_v = v end)
T(mv,"ij","Inf Jump","Mid-air jumps.",function(v) C.infjump = v end)
T(mv,"bh","Bhop","Jump on held Space.",function(v) C.bhop = v end)
T(mv,"nc","Noclip","No collision on parts.",function(v) C.noclip = v end)
T(mv,"aw","Airwalk","Invisible platform follows.",function(v) C.airwalk = v end)
T(mv,"go","Gravity Override","Custom workspace.Gravity.",function(v) C.gravity_override = v end)
mv:AddSlider("gov",{Text="Gravity",Default=60,Min=1,Max=400,Rounding=0}):OnChanged(function(v) C.gravity_v = v end)

-- INVULN tab
local god = tabs.god:AddLeftGroupbox("Invulnerability")
T(god,"gm","Godmode","MaxHealth lock + Dead state disabled.",function(v) C.godmode = v end)
T(god,"hl","HP Lock","Restore Health to 1e9 each tick.",function(v) C.hp_lock = v end)
T(god,"rb","Raycast Blind","Untrusted raycasts filter out our char.",function(v) C.raycast_blind = v end)
T(god,"hn","HP __newindex Trap","Block untrusted Health = X writes.",function(v) C.hp_newindex_trap = v end)
T(god,"rr","Remote Reject","Swallow damage/hit/kill FireServer if target is us.",function(v) C.remote_reject = v end)
T(god,"nb","Namecall Block","Block TakeDamage/Kill on our Humanoid.",function(v) C.namecall_block = v end)
T(god,"ak","Anti Kick","Swallow Player:Kick.",function(v) C.anti_kick = v end, true)

-- VISUALS tab
local vis = tabs.vis:AddLeftGroupbox("Visuals")
T(vis,"esp","ESP","White outline on enemies.",function(v) C.esp_enemies = v end)
T(vis,"ch","Chams","Red fill on enemies.",function(v) C.chams = v end)
T(vis,"hpd","HP HUD","Enemy HP overhead text.",function(v) C.hp_hud = v end)
T(vis,"fb","Fullbright","Ambient max + fog cleared.",function(v) C.fullbright = v end)
T(vis,"wm","Watermark","Top-left FPS/name HUD.",function(v) C.watermark = v end)
T(vis,"si","Server Info HUD","Bottom-left server/players.",function(v) C.server_info = v end)
T(vis,"xh","Crosshair","Custom 4-line crosshair.",function(v) C.crosshair = v end)
vis:AddSlider("xhs",{Text="XH Size",Default=10,Min=2,Max=40,Rounding=0}):OnChanged(function(v) C.crosshair_size = v end)
vis:AddSlider("xhg",{Text="XH Gap",Default=4,Min=0,Max=30,Rounding=0}):OnChanged(function(v) C.crosshair_gap = v end)
vis:AddSlider("xht",{Text="XH Thickness",Default=2,Min=1,Max=6,Rounding=0}):OnChanged(function(v) C.crosshair_thick = v end)
T(vis,"lhp","Low HP Highlight","Red outline on dying enemies.",function(v) C.low_hp_highlight = v end)
vis:AddSlider("lht",{Text="Low HP Threshold",Default=30,Min=5,Max=99,Rounding=0}):OnChanged(function(v) C.low_hp_t = v end)

-- MISC tab
local msc = tabs.misc:AddLeftGroupbox("Misc")
T(msc,"afk","Anti-AFK","Prevents idle kick.",function(v) C.anti_afk = v end, true)
T(msc,"nfd","No Fall Damage","Clamps fall velocity.",function(v) C.no_fall_dmg = v end)
T(msc,"ia","Inf Ammo","Ammo = MaxAmmo each tick.",function(v) C.inf_ammo = v end)
T(msc,"pm","Pickup Magnet","Pulls pickups in radius.",function(v) C.pickup_magnet = v end)
msc:AddSlider("pmr",{Text="Pickup Radius",Default=25,Min=5,Max=200,Rounding=0}):OnChanged(function(v) C.pickup_r = v end)
T(msc,"ahc","Auto Heal Consume","Slot 4 + UseItem on low HP.",function(v) C.auto_heal_consume = v end)
msc:AddSlider("ahct",{Text="Heal at HP ≤",Default=50,Min=10,Max=99,Rounding=0}):OnChanged(function(v) C.auto_heal_hp = v end)
T(msc,"rs","Rank Spoof","Set attribute Rank=ULTRON.",function(v) C.rank_spoof = v end)

local perf = tabs.misc:AddRightGroupbox("Performance / Unload")
perf:AddSlider("tm",{Text="Dispatcher Throttle (ms)",Default=80,Min=30,Max=500,Rounding=0}):OnChanged(function(v) C.throttle_ms = v end)
perf:AddButton({Text="PANIC Unload", Func = function()
    for n, c in pairs(State.conns) do pcall(function() c:Disconnect() end) end
    for n, _ in pairs(State.renders) do pcall(run_service.UnbindFromRenderStep, run_service, "meow_" .. n) end
    for _, d in pairs(State.draws) do pcall(function() d:Remove() end) end
    for _, p in ipairs(players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("MeowESP"); if hl then hl:Destroy() end
            local lh = p.Character:FindFirstChild("MeowLowHP"); if lh then lh:Destroy() end
        end
    end
    pcall(function() library:Unload() end)
    getgenv()._meow_pro_loaded = false
    for k in pairs(C) do if type(C[k]) == "boolean" then C[k] = false end end
end})

library:Notify({ Title = "meowlua PRO", Description = "loaded — all rails lazy", Time = 4 })

-- Built by Olivia — https://discord.gg/ojailbreaks
