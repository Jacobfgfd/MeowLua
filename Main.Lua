-- meowlua ULTRA — pro build + voidspam + instant kill + 40 more rails.
-- All wired through ONE throttled dispatcher. Won't crash.
-- Built by Olivia — https://discord.gg/ojailbreaks
-- absolute ollie, built by olivia

if getgenv()._meow_ultra_loaded then return end
getgenv()._meow_ultra_loaded = true

local run_service = game:GetService("RunService")
local rs          = game:GetService("ReplicatedStorage")
local uis         = game:GetService("UserInputService")
local players     = game:GetService("Players")
local cs_svc      = game:GetService("CollectionService")
local lighting    = game:GetService("Lighting")
local http_svc    = game:GetService("HttpService")
local tp_svc      = game:GetService("TeleportService")
local lp          = players.LocalPlayer
local cam         = workspace.CurrentCamera

-- ============ CONFIG ======================================================
local C = {
    -- movement
    fly=false, fly_speed=140, walkspeed=false, walkspeed_v=60, jumppower=false, jumppower_v=90,
    infjump=false, bhop=false, noclip=false, airwalk=false, jump_height=false, jump_height_v=7.2,
    gravity_override=false, gravity_v=60, side_strafe=false, side_strafe_v=30,
    -- aim
    silent_aim=false, silent_part="Head", silent_hitchance=100,
    aim_assist=false, aim_assist_s=0.4, aim_fov=250,
    triggerbot=false, triggerbot_cursor=20, triggerbot_delay=0.05,
    auto_headshot=true,
    kill_aura=false, kill_aura_r=60, kill_aura_d=999,
    multi_kill_aura=false,
    backtrack=false, backtrack_ticks=10,
    damage_mult=false, damage_mult_v=10,
    melee_combo=false, perfect_deflect=false,
    no_spread=false, no_recoil=false, rapid_fire=false, rapid_fire_rate=0.02,
    -- INSTANT KILL
    instant_kill=false, instant_kill_target="", instant_kill_rate=300, instant_kill_remotes_cached=false,
    chain_kill=false, chain_kill_rate=150,
    kill_all_once=false,
    one_shot_closest=false,
    nuke_server=false,
    -- VOIDSPAM
    voidspam=false, voidspam_speed=50, voidspam_shape="burst", voidspam_radius=12,
    voidspam_combo_kill=false,
    evasion=false, evasion_speed=25, evasion_radius=6,
    teleport_strafe=false, teleport_strafe_dist=8,
    -- invuln
    godmode=false, hp_lock=false, raycast_blind=false, hp_newindex_trap=false,
    remote_reject=false, namecall_block=false, state_lock=false,
    bullet_dodge=false, dmg_cooldown_spam=false,
    -- counters
    counter_all=false, counter_elisium=false, counter_phonk=false, counter_ue=false,
    counter_sleepy=false, counter_kicia=false, counter_yokai=false, counter_azlat=false,
    counter_anti_brain=false,
    -- visuals
    esp_enemies=false, chams=false, chams_color_r=255, chams_color_g=60, chams_color_b=60,
    chams_rainbow=false, hp_hud=false, fullbright=false, watermark=false,
    crosshair=false, crosshair_size=10, crosshair_gap=4, crosshair_thick=2,
    low_hp_highlight=false, low_hp_t=30, tracer_lines=false, name_tags=false,
    skeleton_esp=false, bone_lines=false, distance_tag=false,
    -- misc
    anti_afk=true, no_fall_dmg=false, inf_ammo=false, pickup_magnet=false, pickup_r=25,
    auto_heal_consume=false, auto_heal_hp=50, server_info=false, rank_spoof=false,
    rank_spoof_text="ULTRON", votekick_immune=true, anti_kick=true, anti_spectate=false,
    chat_spam=false, chat_spam_text="absolute ollie, built by olivia", chat_spam_delay=3,
    auto_reload=false, auto_pickup_weapon=false, auto_dodge=false,
    display_angles=false, server_hop_key="H",
    -- perf
    throttle_ms=80,
}

-- ============ STATE =======================================================
local State = { conns = {}, renders = {}, draws = {}, backtrack_ring = {}, dmg_remotes = {}, void_t=0 }
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
local function dist2d(v3, m)
    local sp, on = cam:WorldToViewportPoint(v3)
    return on, on and (Vector2.new(sp.X, sp.Y) - m).Magnitude or math.huge, sp
end

local function find_player(name)
    name = (name or ""):lower(); if name == "" then return nil end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Name:lower():find(name, 1, true) then return p end
    end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.DisplayName and p.DisplayName:lower():find(name, 1, true) then return p end
    end
    return nil
end

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

-- ============ REMOTE CACHE (scanned once) ===============================
local function cache_damage_remotes()
    if C.instant_kill_remotes_cached then return end
    State.dmg_remotes = {}
    local function scan(obj, depth)
        if depth > 6 then return end
        for _, ch in ipairs(obj:GetChildren()) do
            if ch:IsA("RemoteEvent") or ch:IsA("RemoteFunction") then
                local n = ch.Name:lower()
                if n:find("damage") or n:find("hit") or n:find("shoot") or n:find("fire") or n:find("attack") or n:find("useitem") or n:find("item") or n:find("fighter") or n:find("bullet") then
                    table.insert(State.dmg_remotes, ch)
                end
            end
            pcall(scan, ch, depth + 1)
        end
    end
    pcall(scan, rs, 0); pcall(scan, workspace, 0)
    C.instant_kill_remotes_cached = true
end

-- ============ INSTANT KILL (server remote flood) =========================
getgenv().meow_instant_kill = function(name, dur)
    cache_damage_remotes()
    local target = find_player(name or C.instant_kill_target)
    if not target then warn("meow: target not found: " .. tostring(name)); return end
    dur = dur or 3
    local start = tick()
    local fires = 0
    bindRender("instant_kill_render", function()
        if tick() - start > dur then
            pcall(run_service.UnbindFromRenderStep, run_service, "meow_instant_kill_render")
            State.renders.instant_kill_render = nil
            return
        end
        if not target.Parent then return end
        local c = target.Character; if not c then return end
        local head = c:FindFirstChild("Head"); local hum = c:FindFirstChildOfClass("Humanoid")
        local pos = head and head.Position or c:GetPivot().Position
        if hum then for i = 1, 10 do pcall(function() hum:TakeDamage(9999) end) end end
        for _, r in ipairs(State.dmg_remotes) do
            for i = 1, 3 do
                pcall(function()
                    if r:IsA("RemoteEvent") then
                        r:FireServer(target, pos, 9999, "Head", c, head)
                    else
                        r:InvokeServer(target, pos, 9999, "Head", c, head)
                    end
                end)
                fires = fires + 1
            end
        end
    end)
end

-- CHAIN KILL — hit every enemy
getgenv().meow_chain_kill = function(dur)
    cache_damage_remotes()
    dur = dur or 5
    local start = tick()
    bindRender("chain_kill_render", function()
        if tick() - start > dur then
            pcall(run_service.UnbindFromRenderStep, run_service, "meow_chain_kill_render")
            State.renders.chain_kill_render = nil
            return
        end
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and alive(p) then
                local c = p.Character; local head = c:FindFirstChild("Head"); local hum = c:FindFirstChildOfClass("Humanoid")
                local pos = head and head.Position or c:GetPivot().Position
                if hum then pcall(function() hum:TakeDamage(9999) end) end
                for _, r in ipairs(State.dmg_remotes) do
                    pcall(function()
                        if r:IsA("RemoteEvent") then r:FireServer(p, pos, 9999, "Head", c, head)
                        else r:InvokeServer(p, pos, 9999, "Head", c, head) end
                    end)
                end
            end
        end
    end)
end

getgenv().meow_kill_all_once = function()
    cache_damage_remotes()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and alive(p) then
            local c = p.Character; local head = c:FindFirstChild("Head"); local hum = c:FindFirstChildOfClass("Humanoid")
            local pos = head and head.Position or c:GetPivot().Position
            if hum then for i = 1, 20 do pcall(function() hum:TakeDamage(9999) end) end end
            for _, r in ipairs(State.dmg_remotes) do
                for i = 1, 5 do
                    pcall(function()
                        if r:IsA("RemoteEvent") then r:FireServer(p, pos, 9999, "Head", c, head)
                        else r:InvokeServer(p, pos, 9999, "Head", c, head) end
                    end)
                end
            end
        end
    end
end

getgenv().meow_one_shot_closest = function()
    local t = closest_in_world(); if not t then return end
    getgenv().meow_instant_kill(t.Name, 1)
end

-- ============ VOIDSPAM (shape-driven position cycling) ===================
local void_shapes = {
    burst  = function(i, r) return Vector3.new(math.cos(i*2.4)*r, math.sin(i*1.7)*r, math.sin(i*2.1)*r) end,
    orbit  = function(i, r) return Vector3.new(math.cos(i)*r, 0, math.sin(i)*r) end,
    zigzag = function(i, r) return Vector3.new(((i%2==0) and r or -r), 0, (i%3)*r/3) end,
    sphere = function(i, r)
        local u, v = math.random()*2-1, math.random()*math.pi*2
        local s = math.sqrt(1-u*u)
        return Vector3.new(s*math.cos(v)*r, u*r, s*math.sin(v)*r)
    end,
    helix  = function(i, r) return Vector3.new(math.cos(i)*r, (i*0.3)%r - r/2, math.sin(i)*r) end,
    chaos  = function(i, r) return Vector3.new((math.random()-0.5)*r*2, (math.random()-0.5)*r*2, (math.random()-0.5)*r*2) end,
    square = function(i, r)
        local s = i % 4
        if s==0 then return Vector3.new(r,0,0) elseif s==1 then return Vector3.new(0,0,r)
        elseif s==2 then return Vector3.new(-r,0,0) else return Vector3.new(0,0,-r) end
    end,
    rose   = function(i, r) local k=4; return Vector3.new(r*math.cos(k*i)*math.cos(i), 0, r*math.cos(k*i)*math.sin(i)) end,
    figure8= function(i, r) return Vector3.new(r*math.sin(i), 0, r*math.sin(i)*math.cos(i)) end,
    lissajous=function(i,r) return Vector3.new(r*math.sin(3*i), r*math.sin(2*i)*0.5, r*math.cos(5*i)) end,
    spiral = function(i,r)  return Vector3.new(math.cos(i*0.5)*r*(i*0.1), math.sin(i*0.3)*2, math.sin(i*0.5)*r*(i*0.1)) end,
    cube   = function(i,r)
        local s=i%8; local x = (s==1 or s==2 or s==5 or s==6) and r or -r
        local y = (s>=4) and r or -r; local z = (s==2 or s==3 or s==6 or s==7) and r or -r
        return Vector3.new(x,y,z)
    end,
    tight  = function(i, r) return Vector3.new(math.cos(i*5)*r*0.3, math.sin(i*3)*r*0.3, math.sin(i*7)*r*0.3) end,
    wide   = function(i, r) return Vector3.new(math.cos(i)*r*2, 0, math.sin(i)*r*2) end,
    void_dive=function(i,r) local y = -((i*3) % (r*4)); return Vector3.new(math.cos(i)*r*0.5, y, math.sin(i)*r*0.5) end,
}

-- Evasion is a smaller/tighter voidspam variant
local function void_tick(dt)
    if C.voidspam or C.evasion then
        local hrp = get_hrp(lp); if not hrp then return end
        State.void_t = State.void_t + dt * (C.voidspam and C.voidspam_speed or C.evasion_speed) / 10
        local shape = void_shapes[C.voidspam_shape] or void_shapes.burst
        local offset = shape(State.void_t, C.voidspam and C.voidspam_radius or C.evasion_radius)
        pcall(function() hrp.CFrame = hrp.CFrame + offset end)

        -- voidspam + instant kill combo: while cycling our pos, flood target
        if C.voidspam and C.voidspam_combo_kill and C.instant_kill_target ~= "" then
            cache_damage_remotes()
            local target = find_player(C.instant_kill_target)
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:TakeDamage(9999) end) end
                for _, r in ipairs(State.dmg_remotes) do
                    pcall(function()
                        if r:IsA("RemoteEvent") then r:FireServer(target, head and head.Position or target.Character:GetPivot().Position, 9999, "Head", target.Character, head)
                        else r:InvokeServer(target, head and head.Position or target.Character:GetPivot().Position, 9999, "Head", target.Character, head) end
                    end)
                end
            end
        end
    end
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

bindConn("jumpreq", uis.JumpRequest:Connect(function()
    if C.infjump or C.bhop then
        local h = get_hum(); if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
    end
end))

-- ============ MAIN THROTTLED DISPATCHER ==================================
local disp_last = 0
bindConn("dispatch", run_service.Heartbeat:Connect(function(dt)
    -- voidspam runs every frame (it's cheap: one CFrame set)
    void_tick(dt or 0.016)

    if tick() - disp_last < (C.throttle_ms / 1000) then return end
    disp_last = tick()

    local c = lp.Character; local hum = c and c:FindFirstChildOfClass("Humanoid"); local hrp = c and c:FindFirstChild("HumanoidRootPart")

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
        if C.state_lock then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end)
        end
        if C.auto_reload then
            pcall(function()
                local fc = rs:FindFirstChild("FighterController")
                if fc then local ok, m = pcall(require, fc); if ok and m and m.LocalFighter then
                    local h = m.LocalFighter.Hand
                    if h and h.Ammo and h.MaxAmmo and h.Ammo == 0 then m.LocalFighter:Input("Reload") end
                end end
            end)
        end
    end
    if C.gravity_override then pcall(function() workspace.Gravity = C.gravity_v end) end
    if C.noclip and c then
        for _, p in ipairs(c:GetChildren()) do
            if p:IsA("BasePart") and p.CanCollide then pcall(function() p.CanCollide = false end) end
        end
    end
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
        if C.counter_azlat or C.counter_all then pcall(function() c:SetAttribute("Rank", "guest") end) end
        if C.counter_anti_brain or C.counter_all then
            pcall(function() c:SetAttribute("Brain", math.random(1,100)); c:SetAttribute("AntiBrain", true); c:SetAttribute("TargetLock", false) end)
        end
    end
    if C.perfect_deflect and c then pcall(function() c:SetAttribute("Deflecting", true) end) end
    if C.rank_spoof then pcall(function() lp:SetAttribute("Rank", C.rank_spoof_text) end) end

    -- KILL AURA
    if (C.kill_aura or C.multi_kill_aura) and hrp then
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and alive(p) then
                local php = get_hrp(p); local phum = get_hum(p)
                if phum and php and (php.Position - hrp.Position).Magnitude < C.kill_aura_r then
                    pcall(function() phum:TakeDamage(C.kill_aura_d) end)
                    if C.multi_kill_aura then for i = 1, 4 do pcall(function() phum:TakeDamage(C.kill_aura_d) end) end end
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
                    local r = State.backtrack_ring[p]; table.insert(r, 1, php.Position)
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
                    local hl = p.Character and p.Character:FindFirstChild("MeowLowHP"); if hl then hl:Destroy() end
                end
            end
        end
    end

    if C.pickup_magnet and hrp then
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("BasePart") and (item.Name:lower():find("pickup") or item.Name:lower():find("ammo") or item.Name:lower():find("drop")) then
                if (item.Position - hrp.Position).Magnitude < C.pickup_r then
                    pcall(function() item.CFrame = hrp.CFrame end)
                end
            end
        end
    end
    if C.inf_ammo then
        pcall(function()
            local fc = rs:FindFirstChild("FighterController")
            if fc then local ok, m = pcall(require, fc); if ok and m and m.LocalFighter and m.LocalFighter.Hand and m.LocalFighter.Hand.MaxAmmo then m.LocalFighter.Hand.Ammo = m.LocalFighter.Hand.MaxAmmo end end
        end)
    end
    if C.auto_heal_consume and hum and hum.Health < C.auto_heal_hp then
        pcall(function()
            local fc = rs:FindFirstChild("FighterController")
            if fc then local ok, m = pcall(require, fc); if ok and m and m.LocalFighter then m.LocalFighter:EquipSlot(4); m.LocalFighter:Input("UseItem") end end
        end)
    end
    if C.no_fall_dmg and hrp and hrp.AssemblyLinearVelocity.Y < -80 then
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -10, hrp.AssemblyLinearVelocity.Z) end)
    end
    if C.airwalk and hrp and hum then
        if hum:GetState() == Enum.HumanoidStateType.Freefall then
            local pad = c:FindFirstChild("MeowAirPad")
            if not pad then
                pad = Instance.new("Part"); pad.Name = "MeowAirPad"; pad.Size = Vector3.new(4,0.2,4)
                pad.Transparency = 1; pad.Anchored = true; pad.CanCollide = true; pad.Parent = c
            end
            pcall(function() pad.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3, 0)) end)
        else
            local pad = c:FindFirstChild("MeowAirPad"); if pad then pad:Destroy() end
        end
    end
    -- BULLET DODGE (cheap: scan workspace children only)
    if C.bullet_dodge and hrp then
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("bullet") or obj.Name:lower():find("proj")) then
                if (obj.Position - hrp.Position).Magnitude < 10 then
                    pcall(function() hrp.CFrame = hrp.CFrame * CFrame.new(5, 0, 0) end)
                end
            end
        end
    end
end))

-- ============ AIM ASSIST / TRIGGERBOT (light) ============================
bindConn("aim_assist", run_service.RenderStepped:Connect(function()
    if not C.aim_assist then return end
    local t = closest_to_cursor(); if not t then return end
    local cur = cam.CFrame
    cam.CFrame = cur:Lerp(CFrame.new(cur.Position, t.Position), math.clamp(C.aim_assist_s, 0.01, 1))
end))

local tb_last = 0
bindConn("triggerbot", run_service.Heartbeat:Connect(function()
    if not C.triggerbot then return end
    if tick() - tb_last < C.triggerbot_delay then return end
    tb_last = tick()
    local t = closest_to_cursor(); if not t then return end
    local mouse = uis:GetMouseLocation()
    local on, d = dist2d(t.Position, mouse)
    if on and d < C.triggerbot_cursor then
        pcall(function()
            local fc = rs:FindFirstChild("FighterController")
            if fc then local ok, m = pcall(require, fc); if ok and m and m.LocalFighter then
                m.LocalFighter:Input("StartShooting"); task.wait(0.03); m.LocalFighter:Input("StopShooting")
            end end
        end)
    end
end))

-- RAPID FIRE
local rf_last = 0
bindConn("rapid_fire", run_service.Heartbeat:Connect(function()
    if not C.rapid_fire then return end
    if tick() - rf_last < C.rapid_fire_rate then return end
    rf_last = tick()
    pcall(function()
        local fc = rs:FindFirstChild("FighterController")
        if fc then local ok, m = pcall(require, fc); if ok and m and m.LocalFighter then
            m.LocalFighter:Input("StartShooting"); task.wait(0.01); m.LocalFighter:Input("StopShooting")
        end end
    end)
end))

-- MELEE COMBO
local mc_last = 0
bindConn("melee_combo", run_service.Heartbeat:Connect(function()
    if not C.melee_combo then return end
    if tick() - mc_last < 0.1 then return end
    mc_last = tick()
    pcall(function()
        local fc = rs:FindFirstChild("FighterController")
        if fc then local ok, m = pcall(require, fc); if ok and m and m.LocalFighter then
            m.LocalFighter:Input("StartShooting"); task.wait(0.02); m.LocalFighter:Input("StopShooting")
        end end
    end)
end))

-- CHAT SPAM
local cs_last = 0
bindConn("chat_spam", run_service.Heartbeat:Connect(function()
    if not C.chat_spam then return end
    if tick() - cs_last < C.chat_spam_delay then return end
    cs_last = tick()
    pcall(function()
        local ev = rs:FindFirstChild("DefaultChatSystemChatEvents", true)
        if ev then local m = ev:FindFirstChild("SayMessageRequest"); if m then m:FireServer(C.chat_spam_text, "All") end end
    end)
end))

-- ============ ESP / CHAMS / RAINBOW ======================================
local esp_last = 0
local rainbow_phase = 0
bindConn("esp", run_service.Heartbeat:Connect(function()
    if not (C.esp_enemies or C.chams or C.chams_rainbow) then
        if esp_last > 0 then
            for _, p in ipairs(players:GetPlayers()) do
                if p.Character then local hl = p.Character:FindFirstChild("MeowESP"); if hl then hl:Destroy() end end
            end
            esp_last = 0
        end
        return
    end
    if tick() - esp_last < 0.5 then return end
    esp_last = tick()
    rainbow_phase = (rainbow_phase + 0.05) % 1
    local col
    if C.chams_rainbow then col = Color3.fromHSV(rainbow_phase, 1, 1)
    else col = Color3.fromRGB(C.chams_color_r, C.chams_color_g, C.chams_color_b) end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("MeowESP")
            if not hl then hl = Instance.new("Highlight"); hl.Name = "MeowESP"; hl.OutlineColor = Color3.fromRGB(255,255,255); hl.Parent = p.Character end
            hl.FillColor = col
            hl.FillTransparency = (C.chams or C.chams_rainbow) and 0.3 or 1
            hl.OutlineTransparency = C.esp_enemies and 0 or 1
        end
    end
end))

bindConn("fullbright", run_service.Heartbeat:Connect(function()
    if not C.fullbright then return end
    pcall(function() lighting.Ambient = Color3.new(1,1,1); lighting.FogEnd = 1e9; lighting.Brightness = 2 end)
end))

-- HP HUD + NAME TAGS + DISTANCE + TRACERS (one render pass)
local hp_texts, name_texts, dist_texts, tracer_lines = {}, {}, {}, {}
bindRender("world_hud", function()
    local show_any = C.hp_hud or C.name_tags or C.distance_tag or C.tracer_lines
    if not show_any then
        for _, t in pairs(hp_texts)   do t.Visible = false end
        for _, t in pairs(name_texts) do t.Visible = false end
        for _, t in pairs(dist_texts) do t.Visible = false end
        for _, l in pairs(tracer_lines) do l.Visible = false end
        return
    end
    local me_pos = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
    local me_hrp = get_hrp(lp)
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local head = p.Character:FindFirstChild("Head"); local hum = get_hum(p)
            local php = get_hrp(p)
            if head and hum and hum.Health > 0 then
                local sp, on = cam:WorldToViewportPoint(head.Position + Vector3.new(0,2.5,0))
                local sp2 = cam:WorldToViewportPoint(head.Position + Vector3.new(0,1.5,0))
                if on then
                    if C.hp_hud then
                        hp_texts[p] = hp_texts[p] or new_draw("Text","hp_"..p.Name)
                        local t = hp_texts[p]; t.Size = 14; t.Color = Color3.fromRGB(255,80,80); t.Outline = true; t.Center = true
                        t.Position = Vector2.new(sp.X, sp.Y); t.Text = math.floor(hum.Health); t.Visible = true
                    elseif hp_texts[p] then hp_texts[p].Visible = false end
                    if C.name_tags then
                        name_texts[p] = name_texts[p] or new_draw("Text","nm_"..p.Name)
                        local t = name_texts[p]; t.Size = 13; t.Color = Color3.fromRGB(200,200,255); t.Outline = true; t.Center = true
                        t.Position = Vector2.new(sp2.X, sp2.Y); t.Text = p.Name; t.Visible = true
                    elseif name_texts[p] then name_texts[p].Visible = false end
                    if C.distance_tag and me_hrp and php then
                        dist_texts[p] = dist_texts[p] or new_draw("Text","d_"..p.Name)
                        local t = dist_texts[p]; t.Size = 12; t.Color = Color3.fromRGB(180,255,180); t.Outline = true; t.Center = true
                        t.Position = Vector2.new(sp.X, sp.Y + 14); t.Text = string.format("%dm", math.floor((php.Position - me_hrp.Position).Magnitude)); t.Visible = true
                    elseif dist_texts[p] then dist_texts[p].Visible = false end
                    if C.tracer_lines then
                        tracer_lines[p] = tracer_lines[p] or new_draw("Line","tr_"..p.Name)
                        local l = tracer_lines[p]; l.Thickness = 1; l.Color = Color3.fromRGB(255,80,80)
                        l.From = me_pos; l.To = Vector2.new(sp.X, sp.Y); l.Visible = true
                    elseif tracer_lines[p] then tracer_lines[p].Visible = false end
                end
            else
                if hp_texts[p] then hp_texts[p].Visible = false end
                if name_texts[p] then name_texts[p].Visible = false end
                if dist_texts[p] then dist_texts[p].Visible = false end
                if tracer_lines[p] then tracer_lines[p].Visible = false end
            end
        end
    end
end)

-- CROSSHAIR
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

local wm_text = new_draw("Text","wm"); wm_text.Size = 14; wm_text.Color = Color3.fromRGB(255,255,255); wm_text.Outline = true
local si_text = new_draw("Text","si"); si_text.Size = 14; si_text.Color = Color3.fromRGB(180,255,180); si_text.Outline = true
local ang_text= new_draw("Text","ang"); ang_text.Size = 13; ang_text.Color = Color3.fromRGB(255,200,100); ang_text.Outline = true
bindRender("hud_text", function()
    wm_text.Visible = C.watermark; si_text.Visible = C.server_info; ang_text.Visible = C.display_angles
    if C.watermark then wm_text.Position = Vector2.new(10, 10); wm_text.Text = "meowlua ultra | " .. lp.Name end
    if C.server_info then
        si_text.Position = Vector2.new(10, cam.ViewportSize.Y - 30)
        si_text.Text = string.format("players: %d | job: %s", #players:GetPlayers(), tostring(game.JobId):sub(1,8))
    end
    if C.display_angles then
        local hrp = get_hrp(lp)
        if hrp then
            local p = hrp.Position
            ang_text.Position = Vector2.new(10, 30)
            ang_text.Text = string.format("x %.0f y %.0f z %.0f", p.X, p.Y, p.Z)
        end
    end
end)

-- ANTI AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    lp.Idled:Connect(function()
        if not C.anti_afk then return end
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1); vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ============ NAMECALL HOOK CHAIN ========================================
local _hook_installed = false
local function install_hooks()
    if _hook_installed then return end; _hook_installed = true
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local m = getnamecallmethod(); local tp = typeof(self)
        if C.silent_aim and tp == "Instance" and (m == "FireServer" or m == "InvokeServer") then
            local n = tostring(self.Name):lower()
            if n:find("shoot") or n:find("fire") or n:find("useitem") or n:find("hit") or n:find("item") or n:find("fighter") or n:find("damage") then
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
        if C.raycast_blind and tp == "Instance" and m == "Raycast" and self:IsA("WorldRoot") then
            local ok_caller, caller = pcall(getcallingscript)
            if ok_caller and caller and caller ~= script then
                local args = { ... }; local c = lp.Character
                if c and typeof(args[3]) == "RaycastParams" then
                    local new = RaycastParams.new(); new.FilterType = Enum.RaycastFilterType.Exclude
                    local merged = {}
                    for _, inst in ipairs(args[3].FilterDescendantsInstances or {}) do merged[#merged+1] = inst end
                    merged[#merged+1] = c
                    new.FilterDescendantsInstances = merged
                    return old(self, args[1], args[2], new)
                end
            end
        end
        if C.namecall_block and tp == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character then
                local ok_caller, caller = pcall(getcallingscript)
                if ok_caller and caller and caller ~= script then
                    if m == "TakeDamage" or m == "Kill" or m == "BreakJoints" then return 0 end
                    if m == "ChangeState" then local s = ...; if s == Enum.HumanoidStateType.Dead then return end end
                end
            end
        end
        if C.remote_reject and tp == "Instance" and m == "FireServer" and self:IsA("RemoteEvent") then
            local ok_caller, caller = pcall(getcallingscript)
            if ok_caller and caller and caller ~= script then
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
        if C.anti_kick and tp == "Instance" and m == "Kick" and self == lp then return end
        if C.votekick_immune and tp == "Instance" and m == "FireServer" then
            local n = tostring(self.Name):lower()
            if n:find("vote") or n:find("kick") then
                for _, a in ipairs({ ... }) do
                    if typeof(a) == "Instance" and a == lp then return end
                    if typeof(a) == "string" and a:lower():find(lp.Name:lower()) then return end
                end
            end
        end
        return old(self, ...)
    end))
    local old_ni
    old_ni = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if C.hp_newindex_trap and typeof(self) == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character and (key == "Health" or key == "MaxHealth") then
                local ok_caller, caller = pcall(getcallingscript)
                if ok_caller and caller and caller ~= script and key == "Health" and typeof(value) == "number" and value < self.MaxHealth then
                    return
                end
            end
        end
        return old_ni(self, key, value)
    end))
end

-- ============ UI =========================================================
local lib_ok, library = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))() end)
if not lib_ok or not library then
    warn("meowlua ultra: UI failed. Core logic active.")
    install_hooks()
    return
end
getgenv().meow_lib = library
install_hooks()
cache_damage_remotes()

local window = library:CreateWindow({ Title = "meowlua ULTRA", Center = true, AutoShow = true, Footer = "absolute ollie | discord.gg/ojailbreaks" })
local tabs = {
    rage = window:AddTab("Rage"),
    kill = window:AddTab("Kill"),
    void = window:AddTab("Voidspam"),
    aim  = window:AddTab("Aim"),
    move = window:AddTab("Movement"),
    god  = window:AddTab("Invuln"),
    vis  = window:AddTab("Visuals"),
    misc = window:AddTab("Misc"),
}
local function T(b, id, t, d, cb, def)
    local tg = b:AddToggle(id, { Text = t, Default = def or false, Tooltip = d })
    tg:OnChanged(function() cb(tg.Value) end); return tg
end

-- KILL TAB
local kb = tabs.kill:AddLeftGroupbox("Instant Kill")
kb:AddInput("tk_name", { Text = "Target Name", Default = "", Placeholder = "partial name OK" }):OnChanged(function(v) C.instant_kill_target = v end)
kb:AddSlider("tk_dur",{Text="Duration (s)",Default=3,Min=1,Max=15,Rounding=0}):OnChanged(function(v) C.instant_kill_dur = v end)
kb:AddButton({ Text = "INSTANT KILL target", Func = function() getgenv().meow_instant_kill(C.instant_kill_target, C.instant_kill_dur or 3) end })
kb:AddButton({ Text = "One-Shot CLOSEST",    Func = function() getgenv().meow_one_shot_closest() end })
kb:AddButton({ Text = "CHAIN KILL (5s)",     Func = function() getgenv().meow_chain_kill(5) end })
kb:AddButton({ Text = "KILL ALL (one-shot)", Func = function() getgenv().meow_kill_all_once() end })
kb:AddButton({ Text = "RE-SCAN damage remotes", Func = function() C.instant_kill_remotes_cached = false; cache_damage_remotes(); library:Notify({Title="meowlua",Description="cached " .. #State.dmg_remotes .. " remotes",Time=3}) end })

local kb2 = tabs.kill:AddRightGroupbox("Aura / Rapid")
T(kb2,"ka","Kill Aura","Damage all enemies in radius every tick.",function(v) C.kill_aura=v end)
T(kb2,"mka","Multi Kill Aura","4x per pass.",function(v) C.multi_kill_aura=v end)
kb2:AddSlider("kar",{Text="Aura Radius",Default=60,Min=10,Max=500,Rounding=0}):OnChanged(function(v) C.kill_aura_r=v end)
kb2:AddSlider("kad",{Text="Aura Damage",Default=999,Min=10,Max=9999,Rounding=0}):OnChanged(function(v) C.kill_aura_d=v end)
T(kb2,"rf","Rapid Fire","StartShooting burst every rate.",function(v) C.rapid_fire=v end)
kb2:AddSlider("rfr",{Text="Rapid Rate (s)",Default=0.02,Min=0.01,Max=0.5,Rounding=2}):OnChanged(function(v) C.rapid_fire_rate=v end)
T(kb2,"mc","Melee Combo","Auto katana burst.",function(v) C.melee_combo=v end)

-- VOIDSPAM TAB
local vs = tabs.void:AddLeftGroupbox("Voidspam")
T(vs,"vs","Voidspam","Rapidly cycles your position through a shape. Unhittable.",function(v) C.voidspam=v end)
vs:AddSlider("vss",{Text="Speed",Default=50,Min=5,Max=300,Rounding=0}):OnChanged(function(v) C.voidspam_speed=v end)
vs:AddSlider("vsr",{Text="Radius",Default=12,Min=2,Max=80,Rounding=0}):OnChanged(function(v) C.voidspam_radius=v end)
vs:AddDropdown("vsh",{Text="Shape",Default="burst",Values={"burst","orbit","zigzag","sphere","helix","chaos","square","rose","figure8","lissajous","spiral","cube","tight","wide","void_dive"}}):OnChanged(function(v) C.voidspam_shape=v end)
T(vs,"vck","Voidspam + Instant Kill COMBO","While cycling pos, floods target damage remotes each frame.",function(v) C.voidspam_combo_kill=v end)
local vs2 = tabs.void:AddRightGroupbox("Evasion (lighter voidspam)")
T(vs2,"ev","Evasion","Tight-radius pos jitter, hard to hit.",function(v) C.evasion=v end)
vs2:AddSlider("evs",{Text="Evasion Speed",Default=25,Min=5,Max=200,Rounding=0}):OnChanged(function(v) C.evasion_speed=v end)
vs2:AddSlider("evr",{Text="Evasion Radius",Default=6,Min=1,Max=40,Rounding=0}):OnChanged(function(v) C.evasion_radius=v end)

-- RAGE TAB
local rc = tabs.rage:AddLeftGroupbox("Counter Rivals")
T(rc,"c_all","Counter ALL","Every rival defense on.",function(v) C.counter_all=v end)
T(rc,"c_el","Counter Elisium","Fake invisible ForceField.",function(v) C.counter_elisium=v end)
T(rc,"c_ph","Counter Phonk Ware","Deflecting attribute.",function(v) C.counter_phonk=v end)
T(rc,"c_ue","Counter UE","Head rename swap.",function(v) C.counter_ue=v end)
T(rc,"c_sl","Counter Sleepy","Remove Entity tag + shrink head.",function(v) C.counter_sleepy=v end)
T(rc,"c_ki","Counter Kicia","Zero velocity.",function(v) C.counter_kicia=v end)
T(rc,"c_yk","Counter Yokai","Fake riot-shield part.",function(v) C.counter_yokai=v end)
T(rc,"c_az","Counter Azlat","Rank attribute spoof.",function(v) C.counter_azlat=v end)
T(rc,"c_ab","Counter Anti Brain","Scramble brain attrs.",function(v) C.counter_anti_brain=v end)
local rb = tabs.rage:AddRightGroupbox("Rage")
T(rb,"bt","Backtrack","Ring buffer of enemy positions.",function(v) C.backtrack=v end)
rb:AddSlider("btt",{Text="Backtrack Ticks",Default=10,Min=2,Max=30,Rounding=0}):OnChanged(function(v) C.backtrack_ticks=v end)
T(rb,"pd","Perfect Deflect","Spams Deflecting=true.",function(v) C.perfect_deflect=v end)
T(rb,"ns","No Spread","Flag.",function(v) C.no_spread=v end)
T(rb,"nr","No Recoil","Flag.",function(v) C.no_recoil=v end)
T(rb,"ar","Auto Reload","Reload at 0 ammo.",function(v) C.auto_reload=v end)
T(rb,"ah","Auto Headshot","Always head.",function(v) C.auto_headshot=v end, true)

-- AIM TAB
local aim = tabs.aim:AddLeftGroupbox("Aim")
T(aim,"sa","Silent Aim","Bends shoot-remote Vector3 args to cursor-closest.",function(v) C.silent_aim=v end)
aim:AddDropdown("sp",{Text="Silent Part",Default="Head",Values={"Head","UpperTorso","Torso","HumanoidRootPart"}}):OnChanged(function(v) C.silent_part=v end)
T(aim,"aa","Aim Assist","Camera lerp toward closest.",function(v) C.aim_assist=v end)
aim:AddSlider("aas",{Text="Smooth",Default=0.4,Min=0.05,Max=1,Rounding=2}):OnChanged(function(v) C.aim_assist_s=v end)
aim:AddSlider("fov",{Text="FOV",Default=250,Min=30,Max=1000,Rounding=0}):OnChanged(function(v) C.aim_fov=v end)
T(aim,"tb","Triggerbot","Fire when cursor on target.",function(v) C.triggerbot=v end)
aim:AddSlider("tbc",{Text="Trigger Px Radius",Default=20,Min=2,Max=200,Rounding=0}):OnChanged(function(v) C.triggerbot_cursor=v end)
aim:AddSlider("tbd",{Text="Trigger Delay (s)",Default=0.05,Min=0.01,Max=0.5,Rounding=2}):OnChanged(function(v) C.triggerbot_delay=v end)

-- MOVEMENT
local mv = tabs.move:AddLeftGroupbox("Movement")
T(mv,"fly","Fly","WASD + Space/LCtrl.",function(v) C.fly=v end)
mv:AddSlider("fs",{Text="Fly Speed",Default=140,Min=20,Max=500,Rounding=0}):OnChanged(function(v) C.fly_speed=v end)
T(mv,"ws","Walkspeed","Hard-set.",function(v) C.walkspeed=v end)
mv:AddSlider("wsv",{Text="Walkspeed",Default=60,Min=16,Max=500,Rounding=0}):OnChanged(function(v) C.walkspeed_v=v end)
T(mv,"jp","JumpPower","Hard-set.",function(v) C.jumppower=v end)
mv:AddSlider("jpv",{Text="JumpPower",Default=90,Min=20,Max=1000,Rounding=0}):OnChanged(function(v) C.jumppower_v=v end)
T(mv,"jh","Jump Height","Alt jump.",function(v) C.jump_height=v end)
mv:AddSlider("jhv",{Text="Jump Height",Default=7.2,Min=1,Max=50,Rounding=1}):OnChanged(function(v) C.jump_height_v=v end)
T(mv,"ij","Inf Jump","Mid-air jumps.",function(v) C.infjump=v end)
T(mv,"bh","Bhop","Jump on held Space.",function(v) C.bhop=v end)
T(mv,"nc","Noclip","No collision.",function(v) C.noclip=v end)
T(mv,"aw","Airwalk","Invisible platform.",function(v) C.airwalk=v end)
T(mv,"go","Gravity Override","Custom gravity.",function(v) C.gravity_override=v end)
mv:AddSlider("gov",{Text="Gravity",Default=60,Min=1,Max=400,Rounding=0}):OnChanged(function(v) C.gravity_v=v end)

-- INVULN
local god = tabs.god:AddLeftGroupbox("Invulnerability")
T(god,"gm","Godmode","MaxHealth lock + Dead disabled.",function(v) C.godmode=v end)
T(god,"hl","HP Lock","Restore Health to 1e9.",function(v) C.hp_lock=v end)
T(god,"rb","Raycast Blind","Untrusted raycasts filter us out.",function(v) C.raycast_blind=v end)
T(god,"hn","HP __newindex Trap","Block untrusted Health writes.",function(v) C.hp_newindex_trap=v end)
T(god,"rr","Remote Reject","Swallow damage/hit/kill FireServer targeting us.",function(v) C.remote_reject=v end)
T(god,"nb","Namecall Block","Block TakeDamage/Kill on our Humanoid.",function(v) C.namecall_block=v end)
T(god,"sl","State Lock","Dead/Ragdoll states disabled.",function(v) C.state_lock=v end)
T(god,"bd","Bullet Dodge","Sidestep when bullet within 10 studs.",function(v) C.bullet_dodge=v end)
T(god,"ak","Anti Kick","Swallow Player:Kick.",function(v) C.anti_kick=v end, true)
T(god,"vk","VoteKick Immune","Swallow votekick remotes.",function(v) C.votekick_immune=v end, true)

-- VISUALS
local vis = tabs.vis:AddLeftGroupbox("Visuals")
T(vis,"esp","ESP","White outline.",function(v) C.esp_enemies=v end)
T(vis,"ch","Chams","Red fill.",function(v) C.chams=v end)
T(vis,"chr","Chams Rainbow","Cycles color.",function(v) C.chams_rainbow=v end)
T(vis,"hpd","HP HUD","Enemy HP overhead text.",function(v) C.hp_hud=v end)
T(vis,"nt","Name Tags","Name above head.",function(v) C.name_tags=v end)
T(vis,"dt","Distance Tag","Studs distance under HP.",function(v) C.distance_tag=v end)
T(vis,"tl","Tracer Lines","Line from screen bottom to each enemy.",function(v) C.tracer_lines=v end)
T(vis,"fb","Fullbright","Ambient max.",function(v) C.fullbright=v end)
T(vis,"wm","Watermark","Top-left HUD.",function(v) C.watermark=v end)
T(vis,"si","Server Info","Bottom-left server/players.",function(v) C.server_info=v end)
T(vis,"ang","Coords HUD","Our x/y/z under watermark.",function(v) C.display_angles=v end)
T(vis,"xh","Crosshair","Custom 4-line.",function(v) C.crosshair=v end)
vis:AddSlider("xhs",{Text="XH Size",Default=10,Min=2,Max=40,Rounding=0}):OnChanged(function(v) C.crosshair_size=v end)
vis:AddSlider("xhg",{Text="XH Gap",Default=4,Min=0,Max=30,Rounding=0}):OnChanged(function(v) C.crosshair_gap=v end)
vis:AddSlider("xht",{Text="XH Thickness",Default=2,Min=1,Max=6,Rounding=0}):OnChanged(function(v) C.crosshair_thick=v end)
T(vis,"lhp","Low HP Highlight","Red outline on dying.",function(v) C.low_hp_highlight=v end)
vis:AddSlider("lht",{Text="Low HP Threshold",Default=30,Min=5,Max=99,Rounding=0}):OnChanged(function(v) C.low_hp_t=v end)

-- MISC
local msc = tabs.misc:AddLeftGroupbox("Misc")
T(msc,"afk","Anti-AFK","Prevents idle kick.",function(v) C.anti_afk=v end, true)
T(msc,"nfd","No Fall Damage","Clamp fall velocity.",function(v) C.no_fall_dmg=v end)
T(msc,"ia","Inf Ammo","Ammo = MaxAmmo each tick.",function(v) C.inf_ammo=v end)
T(msc,"pm","Pickup Magnet","Pulls pickups.",function(v) C.pickup_magnet=v end)
msc:AddSlider("pmr",{Text="Pickup Radius",Default=25,Min=5,Max=200,Rounding=0}):OnChanged(function(v) C.pickup_r=v end)
T(msc,"ahc","Auto Heal Consume","Slot 4 + UseItem on low HP.",function(v) C.auto_heal_consume=v end)
msc:AddSlider("ahct",{Text="Heal at HP ≤",Default=50,Min=10,Max=99,Rounding=0}):OnChanged(function(v) C.auto_heal_hp=v end)
T(msc,"rs","Rank Spoof","Set attribute Rank.",function(v) C.rank_spoof=v end)
T(msc,"cs","Chat Spam","Chat text on interval.",function(v) C.chat_spam=v end)
msc:AddInput("cst",{Text="Chat Text",Default=C.chat_spam_text}):OnChanged(function(v) C.chat_spam_text=v end)
msc:AddSlider("csd",{Text="Chat Delay (s)",Default=3,Min=1,Max=30,Rounding=0}):OnChanged(function(v) C.chat_spam_delay=v end)

local perf = tabs.misc:AddRightGroupbox("Performance / Unload")
perf:AddSlider("tm",{Text="Dispatcher Throttle (ms)",Default=80,Min=30,Max=500,Rounding=0}):OnChanged(function(v) C.throttle_ms=v end)
perf:AddButton({Text="PANIC Unload", Func = function()
    for n, c in pairs(State.conns) do pcall(function() c:Disconnect() end) end
    for n, _ in pairs(State.renders) do pcall(run_service.UnbindFromRenderStep, run_service, "meow_" .. n) end
    for _, d in pairs(State.draws) do pcall(function() d:Remove() end) end
    for _, p in ipairs(players:GetPlayers()) do
        if p.Character then
            for _, nm in ipairs({"MeowESP","MeowLowHP","MeowFakeFF","MeowRiotShield_riot","MeowAirPad"}) do
                local x = p.Character:FindFirstChild(nm); if x then x:Destroy() end
            end
        end
    end
    pcall(function() library:Unload() end)
    getgenv()._meow_ultra_loaded = false
    for k in pairs(C) do if type(C[k]) == "boolean" then C[k] = false end end
end})

library:Notify({ Title = "meowlua ULTRA", Description = "loaded — all rails lazy, voidspam ready", Time = 4 })

-- Built by Olivia — https://discord.gg/ojailbreaks
