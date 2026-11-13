-- meowlua ultron tier — rivals rebuild
-- Built by Olivia — https://discord.gg/ojailbreaks
-- absolute ollie, built by olivia

if not getgenv()._meow_loaded_guard then
    getgenv()._meow_loaded_guard = true
    local _loaded_ok = false
    task.spawn(function()
        local _t = tick()
        repeat task.wait(0.1) until game:IsLoaded() or (tick() - _t) > 15
        _loaded_ok = true
    end)
    local _wait_start = tick()
    repeat task.wait(0.05) until _loaded_ok or (tick() - _wait_start) > 16
end
pcall(function() workspace.FallenPartsDestroyHeight = 0/0 end)
if getgenv().meowlua_loaded then
    if getgenv().unload_all then pcall(getgenv().unload_all) end
end
getgenv().meowlua_loaded = true

local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local VirtualUser         = game:GetService("VirtualUser")
local HttpService         = game:GetService("HttpService")
local TeleportService     = game:GetService("TeleportService")
local Lighting            = game:GetService("Lighting")
local PhysicsService      = game:GetService("PhysicsService")
local StarterGui          = game:GetService("StarterGui")
local CoreGui             = game:GetService("CoreGui")
local Workspace           = workspace
local LocalPlayer         = Players.LocalPlayer

local r_storage           = ReplicatedStorage
local run_service         = RunService
local players             = Players
local localplayer         = LocalPlayer
local user_input_service  = UserInputService
local virtual_user        = VirtualUser
local http_service        = HttpService
local teleport_service    = TeleportService
local lighting            = Lighting

-- =========================================================================
-- CONFIG — every rail, old plus new, in one block
-- =========================================================================
getgenv().config = {
    -- movement
    fly_enabled = false, fly_speed = 80, fly_mode = "Velocity",
    infinite_jump = false, double_jump_enabled = false,
    walkspeed_enabled = false, walkspeed = 16,
    jumppower_enabled = false, jumppower = 50,
    noclip = false, infinite_stamina = false,
    click_tp_enabled = false,
    blink_enabled = false, blink_radius = 120, blink_rate = 120,
    ghost_enabled = false, ghost_distance = 300,
    glide_enabled = false, glide_speed = 350, glide_accel = 30,

    -- fake / desync
    fake_position_enabled = false, desync_enabled = false,

    -- void / abuser movement
    void_spam_enabled = false, vs_xp = 5000, vs_xn = 5000, vs_yp = 5000, vs_yn = 5000, vs_zp = 5000, vs_zn = 5000,
    vs_min_dist = 0, vs_max_dist = 50000, void_pattern = "rhombus",
    void_axis_x = true, void_axis_y = true, void_axis_z = true,
    void_smooth = false, void_smooth_alpha = 1.0, vs_dist_per_tp = 1000,
    et_order = "Triangle", et_mode = "Random", et_speed = 1000, et_total = 500,
    pos_spam_enabled = false, pos_spam_speed = 100,
    map_orbit_enabled = false, map_orbit_x = 1000000, map_orbit_y = 1000000, map_orbit_z = 1000000,
    mo_burst = 1000, mo_interval = 0.05,
    strafebot_enabled = false, strafe_speed = 150, strafe_radius = 20, strafe_height = 8, strafe_randomize = false,
    zigzag_enabled = false, zigzag_speed = 100, zigzag_radius = 35, zigzag_spread = 1000,
    evasion_enabled = false, evasion_burst = 500, evasion_interval = 1, evasion_spin_speed = 9999, evasion_mode = "Random",

    -- misc toggles
    anti_close = false, dagger_bypass = false, anti_kick = true,
    anti_afk_enabled = false, autocollect_enabled = false, autocollect_radius = 120,
    return_home_enabled = false, home_return_delay = 1.0,
    safe_zone_enabled = false, safe_zone_y = -10,
    teleport_loop_enabled = false, teleport_loop_delay = 0.5,
    ffa_hopping_enabled = false, mod_detector = false,
    instant_respawn = false, godmode = false,
    chat_spam_enabled = false, chat_spam_text = "meowlua rivals", chat_spam_delay = 1.5,

    -- anti aim
    anti_aim_enabled = false, aa_method = "Static", aa_pixel_scale = 1, aa_spin_speed = 9999,
    aa_yaw = 0, aa_pitch = 0, aa_roll = 0,

    -- riot
    riot_abuser_enabled = false, riot_abuser_distance = 500, riot_abuser_x = 50, riot_abuser_y = 15, riot_abuser_z = 50, riot_abuser_spin = 1000000000000,
    riot_bypass_enabled = false, riot_bypass_distance = 3, riot_bypass_position = "front",

    -- rage / shoot
    rage_bot_enabled = false, rage_type = "Normal", rage_strategy = "TP", rage_weapon = "None",
    rage_hitbox = "Head", rage_priority = "", rage_position = "Inside",
    rage_tp_radius = 2, rage_tp_height = -4, rage_orbit_speed = 500, rage_spin = false, rage_spin_speed = 1e70,
    knife_dist = 3, shoot_attempts = 1,
    prediction_enabled = false, prediction_mult = 1.2,
    tp_prediction_enabled = false, tp_pred_strength = 1.0,

    -- gun mods
    no_spread = false, no_recoil = false, no_muzzle_flash = false, rapid_fire = false,
    infinite_ammo = false, auto_reload = false,

    -- silent aim / assist
    silent_aim = false, silent_aim_fov = 120, silent_aim_hitbox = "Head", silent_aim_wallcheck = false, silent_aim_resolver = true,
    aim_assist = false, aim_assist_fov = 90, aim_assist_smooth = 6, aim_assist_hitbox = "Head",
    hitbox_expand = false, hitbox_size = 15, hitbox_target = "Head",
    auto_shoot_on_click = false,

    -- visuals / esp
    esp_boxes = false, esp_names = false, esp_health = false, esp_tracers = false, esp_distance = false, esp_weapon = false,
    esp_box_color = Color3.fromRGB(0, 255, 180), esp_enemy_only = true, esp_team_color = false,
    chams_enabled = false, chams_fill = Color3.fromRGB(0, 255, 180), chams_outline = Color3.fromRGB(0, 0, 0), chams_wall = true,
    fov_circle = false, fov_circle_radius = 120, fov_circle_color = Color3.fromRGB(255, 255, 255),
    snaplines = false, snapline_color = Color3.fromRGB(0, 255, 180),
    fullbright = false, fb_brightness = 2,
    low_gfx = false, no_fog = false, no_shadows = false,
    freecam_enabled = false, freecam_speed = 60,
    display_angles = false, starborn_enabled = false,

    -- SBD / Bullet TP
    sbd_enabled = false, sbd_infinite_range = true, sbd_no_gravity = true,
    sbd_teleport_projectiles = true, sbd_rapid_fire = true,
    sbd_ignore_walls = true, sbd_hitbox_expand = true,
    sbd_instant_kill = true, sbd_through_walls = true,
    sbd_auto_aim = false, sbd_auto_shoot = false,
    sbd_anti_projectile = false, sbd_bullet_time = false,
    sbd_damage_mult = 100, sbd_no_damage_falloff = true,
    sbd_heat_seeking = false, sbd_chain_lightning = false,
    bullet_tp_enabled = false, bullet_tp_radius = 5000,
    bullet_tp_attempts = 10, bullet_tp_delay = 0.005,
    bullet_tp_headshot = true, bullet_tp_auto_reset = true,

    -- world / lighting
    autoload_config = true, last_loaded_config = "default",
    w_fps = false, w_stretch = false, w_stretch_amt = 0.81,
    w_dark = false, w_atmo = false, w_amb = false, w_time = 14,

    -- panic key — default F8
    panic_key = "F8",
}

getgenv().all_connections = {}
getgenv().loop_waypoints  = {}
getgenv().loop_index      = 1
getgenv().home_position   = nil

local config = getgenv().config
local configs_folder = "meowlua_configs"
if not isfolder(configs_folder) then pcall(makefolder, configs_folder) end

local function notify(title, content)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = content, Duration = 3 })
    end)
end

-- =========================================================================
-- STATE REGISTRY — every connection and task stored for clean teardown
-- =========================================================================
local State = {
    conns = {},   -- [name] = RBXScriptConnection
    tasks = {},   -- [name] = thread
    binds = {},   -- [name] = RenderStep binding
    hooks = {},   -- [name] = { restore = function() end }
    draws = {},   -- drawing instances
}

local function bindConn(name, conn)
    if State.conns[name] then pcall(function() State.conns[name]:Disconnect() end) end
    State.conns[name] = conn
    table.insert(getgenv().all_connections, conn)
    return conn
end

local function killConn(name)
    local c = State.conns[name]
    if c then pcall(function() c:Disconnect() end) end
    State.conns[name] = nil
end

local function bindTask(name, thread)
    if State.tasks[name] then pcall(task.cancel, State.tasks[name]) end
    State.tasks[name] = thread
    return thread
end

local function killTask(name)
    local t = State.tasks[name]
    if t then pcall(task.cancel, t) end
    State.tasks[name] = nil
end

local function bindRender(name, prio, fn)
    if State.binds[name] then pcall(function() run_service:UnbindFromRenderStep(name) end) end
    pcall(function() run_service:BindToRenderStep(name, prio, fn) end)
    State.binds[name] = true
end

local function killRender(name)
    if State.binds[name] then
        pcall(function() run_service:UnbindFromRenderStep(name) end)
        State.binds[name] = nil
    end
end
-- =========================================================================
-- HELPERS — character, teleport, targeting, prediction
-- =========================================================================
getgenv().get_hrp = function(plr)
    local p = plr or localplayer
    if not p or not p.Character then return nil end
    return p.Character:FindFirstChild("HumanoidRootPart")
end

getgenv().get_hum = function(plr)
    local p = plr or localplayer
    if not p or not p.Character then return nil end
    return p.Character:FindFirstChildOfClass("Humanoid")
end

getgenv().safe_teleport = function(pos)
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
    local x, y, z = pos.X, pos.Y, pos.Z
    y = math.clamp(y, 2, hrp.Position.Y + 800)
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Exclude
    p.FilterDescendantsInstances = { localplayer.Character }
    local hit = workspace:Raycast(Vector3.new(x, y + 60, z), Vector3.new(0, -220, 0), p)
    if hit then y = math.max(hit.Position.Y + 3, 2) end
    hrp.CFrame = CFrame.new(x, y, z)
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function enemy_of(p)
    if p == localplayer then return false end
    if localplayer.Team and p.Team and localplayer.Team == p.Team then return false end
    return true
end

local function alive(p)
    local c = p.Character; if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h or h.Health <= 0 then return false end
    if c:FindFirstChildOfClass("ForceField") then return false end
    return c:FindFirstChild("HumanoidRootPart") and h
end

getgenv().get_rage_target = function()
    local prio = config.rage_priority
    if prio and prio ~= "" then
        local p = players:FindFirstChild(prio)
        if p and enemy_of(p) and alive(p) then return p end
    end
    local best, bscore = nil, math.huge
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return nil end
    for _, p in ipairs(players:GetPlayers()) do
        if enemy_of(p) and alive(p) then
            local th = p.Character.HumanoidRootPart
            local s = (hrp.Position - th.Position).Magnitude
            if s < bscore then bscore = s; best = p end
        end
    end
    return best
end

local cached_target, last_target_tick = nil, 0
getgenv().get_closest = function(check_ff)
    local now = tick()
    if now - last_target_tick < 0.1 and cached_target and alive(cached_target) and enemy_of(cached_target) then
        return cached_target
    end
    last_target_tick = now
    local closest, min_d = nil, math.huge
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return nil end
    for _, p in ipairs(players:GetPlayers()) do
        if enemy_of(p) and alive(p) then
            local th = p.Character.HumanoidRootPart
            local d = (hrp.Position - th.Position).Magnitude
            if d < min_d then min_d = d; closest = p end
        end
    end
    cached_target = closest
    return closest
end

-- screen-space closest: used by silent aim / aim assist
getgenv().get_screen_closest = function(fov_px, hitbox)
    local cam = workspace.CurrentCamera; if not cam then return nil end
    local best, bdist = nil, fov_px or math.huge
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    for _, p in ipairs(players:GetPlayers()) do
        if enemy_of(p) and alive(p) then
            local part = p.Character:FindFirstChild(hitbox or "Head") or p.Character.HumanoidRootPart
            if part then
                local sp, onscreen = cam:WorldToViewportPoint(part.Position)
                if onscreen then
                    local sv = Vector2.new(sp.X, sp.Y)
                    local d = (sv - center).Magnitude
                    if d < bdist then bdist = d; best = { plr = p, part = part, dist = d } end
                end
            end
        end
    end
    return best
end

-- =========================================================================
-- CONFIG I/O (same contract as before)
-- =========================================================================
getgenv().save_cfg = function(name)
    if not name or name == "" then name = "default" end
    local path = configs_folder .. "/" .. name .. ".json"
    local data = { AutoLoadConfig = config.autoload_config, LastLoadedConfig = name, full_config = config }
    local ok, enc = pcall(http_service.JSONEncode, http_service, data)
    if ok and enc then
        if pcall(writefile, path, enc) then notify("Config", "Saved: "..name); return true end
    end
    notify("Config", "Failed to save"); return false
end
getgenv().load_cfg = function(name)
    if not name or name == "" then name = "default" end
    local path = configs_folder .. "/" .. name .. ".json"
    if not isfile(path) then notify("Config", "Not found: "..name); return false end
    local ok, raw = pcall(readfile, path); if not ok then return false end
    local s, d = pcall(http_service.JSONDecode, http_service, raw)
    if s and d and d.full_config then
        config.autoload_config = d.AutoLoadConfig; config.last_loaded_config = name
        for k, v in pairs(d.full_config) do
            if config[k] ~= nil and type(config[k]) == type(v) then config[k] = v end
        end
        notify("Config", "Loaded: "..name); return true
    end
    return false
end
getgenv().delete_cfg = function(name)
    if not name or name == "" or name == "default" then return false end
    local path = configs_folder .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    return pcall(delfile, path)
end
getgenv().list_cfgs = function()
    if not isfolder(configs_folder) then return {} end
    local list = {}
    local ok, files = pcall(listfiles, configs_folder)
    if ok and files then
        for _, f in ipairs(files) do
            local m = f:match("([^/\\]+)%.json$")
            if m then table.insert(list, m) end
        end
    end
    table.sort(list)
    return list
end

-- =========================================================================
-- ANTICHEAT STRIP — same bones, kept
-- =========================================================================
task.defer(function()
    local _stbl
    _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
        if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
            local tr = debug.traceback()
            if tr:find("MiscellaneousController") then return _stbl({1,2,3}, {}) end
        end
        return _stbl(tbl, mt)
    end))
end)

coroutine.wrap(function()
    pcall(function()
        local function _proc(o)
            pcall(function()
                if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                    local ok, nm = pcall(function() return o.Name:lower() end)
                    if not ok or not nm then return end
                    local tags = {"anticheat","ac","detection","ban","kick","security","moderation"}
                    for i = 1, #tags do
                        if nm:find(tags[i]) then pcall(function() o.Disabled = true end); break end
                    end
                end
            end)
        end
        pcall(function()
            local desc = game:GetDescendants()
            for i = 1, #desc do _proc(desc[i]) end
        end)
        pcall(function() game.DescendantAdded:Connect(_proc) end)
    end)
    pcall(function()
        local nc = game:GetService("NetworkClient")
        if not nc then return end
        nc.ChildAdded:Connect(function(ch)
            pcall(function()
                local ok, n = pcall(function() return ch.Name:lower() end)
                if ok and n and (n:find("anticheat") or n:find("detection")) then
                    pcall(function() ch:Destroy() end)
                end
            end)
        end)
    end)
end)()

pcall(function()
    local fakeEv = Instance.new("RemoteEvent")
    fakeEv.Name = "ClientAlert"
    fakeEv.Parent = localplayer
end)

task.defer(function()
    pcall(function()
        local rf = game:GetService("ReplicatedFirst")
        local tgt = rf:WaitForChild("LocalScript3", 10)
        local gc = getgc(false)
        for i = 1, #gc do
            local fn = gc[i]
            if type(fn) ~= "function" then continue end
            local ok1, env = pcall(getfenv, fn); if not ok1 or type(env) ~= "table" then continue end
            local ok2, scr = pcall(function() return rawget(env, "script") end)
            if not ok2 or not scr or typeof(scr) ~= "Instance" then continue end
            local ok3, ss = pcall(tostring, scr); if not ok3 then continue end
            if not (scr == tgt or (type(ss) == "string" and ss:find("LoadingScreen"))) then continue end
            local ok4, consts = pcall(debug.getconstants, fn)
            if not ok4 or type(consts) ~= "table" then continue end
            for j = 1, #consts do
                local c = consts[j]
                if type(c) == "string" and (c:find("TakeTheL") or c:find("ban") or c:find("kick")) then
                    pcall(function() hookfunction(fn, function() end) end)
                    break
                end
            end
        end
    end)
end)

-- =========================================================================
-- ANTI-KICK — swallow LocalPlayer:Kick server pokes
-- =========================================================================
task.defer(function()
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old_namecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if config.anti_kick and method == "Kick" and self == localplayer then
                return nil
            end
            return old_namecall(self, ...)
        end)
        setreadonly(mt, true)
        State.hooks.anti_kick = { }
    end)
end)
-- =========================================================================
-- MOVEMENT — fly, infjump, walkspeed, jumppower, noclip, stamina, heal
-- =========================================================================
local Movement = {}

-- FLY ---------------------------------------------------------------------
local fly_bv, fly_bg, fly_body
function Movement.start_fly()
    Movement.stop_fly()
    local char = localplayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    fly_body = hrp
    fly_bv = Instance.new("BodyVelocity")
    fly_bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    fly_bv.Velocity = Vector3.zero
    fly_bv.Name = "meowlua_fly_bv"
    fly_bv.Parent = hrp
    fly_bg = Instance.new("BodyGyro")
    fly_bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    fly_bg.P = 10000
    fly_bg.CFrame = hrp.CFrame
    fly_bg.Name = "meowlua_fly_bg"
    fly_bg.Parent = hrp
    bindConn("fly_step", run_service.Heartbeat:Connect(function()
        if not config.fly_enabled then return end
        local cam = workspace.CurrentCamera; if not cam then return end
        local ks = UserInputService
        local dir = Vector3.zero
        if ks:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if ks:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if ks:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if ks:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if ks:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if ks:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        if dir.Magnitude > 0 then dir = dir.Unit * (config.fly_speed or 80) end
        if fly_bv and fly_bv.Parent then fly_bv.Velocity = dir end
        if fly_bg and fly_bg.Parent then fly_bg.CFrame = cam.CFrame end
    end))
end
function Movement.stop_fly()
    killConn("fly_step")
    if fly_bv and fly_bv.Parent then fly_bv:Destroy() end
    if fly_bg and fly_bg.Parent then fly_bg:Destroy() end
    fly_bv, fly_bg = nil, nil
    config.fly_enabled = false
end

-- INFINITE JUMP -----------------------------------------------------------
function Movement.start_infjump()
    killConn("infjump")
    bindConn("infjump", UserInputService.JumpRequest:Connect(function()
        if not config.infinite_jump then return end
        local h = getgenv().get_hum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end))
end
function Movement.stop_infjump() killConn("infjump"); config.infinite_jump = false end

-- WALKSPEED / JUMPPOWER ---------------------------------------------------
function Movement.start_walkspeed()
    killConn("ws_apply")
    bindConn("ws_apply", run_service.Heartbeat:Connect(function()
        if not config.walkspeed_enabled then return end
        local h = getgenv().get_hum(); if h and h.WalkSpeed ~= config.walkspeed then h.WalkSpeed = config.walkspeed end
    end))
end
function Movement.stop_walkspeed()
    killConn("ws_apply")
    local h = getgenv().get_hum(); if h then pcall(function() h.WalkSpeed = 16 end) end
end

function Movement.start_jumppower()
    killConn("jp_apply")
    bindConn("jp_apply", run_service.Heartbeat:Connect(function()
        if not config.jumppower_enabled then return end
        local h = getgenv().get_hum(); if not h then return end
        pcall(function()
            h.UseJumpPower = true
            if h.JumpPower ~= config.jumppower then h.JumpPower = config.jumppower end
        end)
    end))
end
function Movement.stop_jumppower()
    killConn("jp_apply")
    local h = getgenv().get_hum(); if h then pcall(function() h.JumpPower = 50 end) end
end

-- NOCLIP ------------------------------------------------------------------
function Movement.start_noclip()
    killConn("noclip_step")
    bindConn("noclip_step", run_service.Stepped:Connect(function()
        if not config.noclip then return end
        local c = localplayer.Character; if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end))
end
function Movement.stop_noclip() killConn("noclip_step") end

-- GODMODE (client-side regen lock) ---------------------------------------
function Movement.start_godmode()
    killConn("god_step")
    bindConn("god_step", run_service.Heartbeat:Connect(function()
        if not config.godmode then return end
        local h = getgenv().get_hum(); if not h then return end
        pcall(function()
            h.MaxHealth = math.huge
            h.Health = math.huge
        end)
    end))
end
function Movement.stop_godmode()
    killConn("god_step")
    local h = getgenv().get_hum(); if h then pcall(function() h.MaxHealth = 100; h.Health = 100 end) end
end

-- INFINITE STAMINA --------------------------------------------------------
function Movement.start_inf_stamina()
    killConn("stam_step")
    bindConn("stam_step", run_service.Heartbeat:Connect(function()
        if not config.infinite_stamina then return end
        local c = localplayer.Character; if not c then return end
        pcall(function()
            if c:GetAttribute("Stamina") ~= nil then c:SetAttribute("Stamina", 100) end
            if c:GetAttribute("Energy") ~= nil then c:SetAttribute("Energy", 100) end
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then
                if h:GetAttribute("Stamina") ~= nil then h:SetAttribute("Stamina", 100) end
                if h:GetAttribute("Sprint") ~= nil then h:SetAttribute("Sprint", 100) end
            end
        end)
    end))
end
function Movement.stop_inf_stamina() killConn("stam_step") end

-- AUTO HEAL ---------------------------------------------------------------
function Movement.start_auto_heal()
    killConn("auto_heal")
    bindConn("auto_heal", run_service.Heartbeat:Connect(function()
        if not config.godmode then return end
        local h = getgenv().get_hum(); if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
    end))
end
function Movement.stop_auto_heal() killConn("auto_heal") end

-- INSTANT RESPAWN ---------------------------------------------------------
function Movement.start_instant_respawn()
    killConn("resp_hum")
    local function wire(h)
        if not h then return end
        pcall(function()
            h.Died:Connect(function()
                if config.instant_respawn then
                    task.wait(0.1)
                    pcall(function() localplayer:LoadCharacter() end)
                end
            end)
        end)
    end
    wire(getgenv().get_hum())
    bindConn("resp_hum", localplayer.CharacterAdded:Connect(function(c)
        local h = c:WaitForChild("Humanoid", 5)
        wire(h)
    end))
end
function Movement.stop_instant_respawn() killConn("resp_hum") end

-- CLICK TP ----------------------------------------------------------------
function Movement.start_click_tp()
    killConn("click_tp")
    bindConn("click_tp", UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not config.click_tp_enabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local cam = workspace.CurrentCamera; if not cam then return end
        local mp = UserInputService:GetMouseLocation()
        local r = cam:ScreenPointToRay(mp.X, mp.Y, 1)
        local p = RaycastParams.new()
        p.FilterType = Enum.RaycastFilterType.Exclude
        p.FilterDescendantsInstances = { localplayer.Character }
        local hit = workspace:Raycast(r.Origin, r.Direction * 5000, p)
        if hit then getgenv().safe_teleport(hit.Position + Vector3.new(0, 3, 0)) end
    end))
end
function Movement.stop_click_tp() killConn("click_tp") end

-- FREECAM -----------------------------------------------------------------
local freecam_cf, freecam_connL, freecam_connR
function Movement.start_freecam()
    local cam = workspace.CurrentCamera; if not cam then return end
    freecam_cf = cam.CFrame
    pcall(function() localplayer.Character.Humanoid:SetAttribute("_freecam_was", true) end)
    cam.CameraType = Enum.CameraType.Scriptable
    bindConn("freecam_render", run_service.RenderStepped:Connect(function(dt)
        if not config.freecam_enabled then return end
        local ks = UserInputService
        local dir = Vector3.zero
        local cf = freecam_cf
        if ks:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if ks:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if ks:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if ks:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if ks:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if ks:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        freecam_cf = freecam_cf + dir * (config.freecam_speed or 60) * dt
        freecam_cf = CFrame.new(freecam_cf.Position) * (cam.CFrame - cam.CFrame.Position)
        cam.CFrame = freecam_cf
    end))
end
function Movement.stop_freecam()
    killConn("freecam_render")
    local cam = workspace.CurrentCamera; if cam then cam.CameraType = Enum.CameraType.Custom end
end

getgenv().Movement = Movement
-- =========================================================================
-- COMBAT — silent aim, aim assist, hitbox expand, auto parry, chat spam
-- =========================================================================
local Combat = {}

-- HITBOX EXPAND (visual client-side — enlarges head/torso for easier aim) -
local hitbox_originals = {}
function Combat.start_hitbox_expand()
    killConn("hitbox_step")
    bindConn("hitbox_step", run_service.Heartbeat:Connect(function()
        if not config.hitbox_expand then return end
        local size = config.hitbox_size or 15
        local target_name = config.hitbox_target or "Head"
        for _, p in ipairs(players:GetPlayers()) do
            if p == localplayer then continue end
            local c = p.Character; if not c then continue end
            local part = c:FindFirstChild(target_name); if not part or not part:IsA("BasePart") then continue end
            if not hitbox_originals[part] then
                hitbox_originals[part] = { size = part.Size, trans = part.Transparency, mat = part.Material, cc = part.CanCollide, massless = part.Massless }
            end
            pcall(function()
                part.Size        = Vector3.new(size, size, size)
                part.Transparency = 0.7
                part.Material    = Enum.Material.ForceField
                part.CanCollide  = false
                part.Massless    = true
            end)
        end
    end))
end
function Combat.stop_hitbox_expand()
    killConn("hitbox_step")
    for part, saved in pairs(hitbox_originals) do
        if part and part.Parent then
            pcall(function()
                part.Size         = saved.size
                part.Transparency = saved.trans
                part.Material     = saved.mat
                part.CanCollide   = saved.cc
                part.Massless     = saved.massless
            end)
        end
    end
    hitbox_originals = {}
end

-- SILENT AIM — bend the shoot remote toward the FOV-closest head ---------
-- hook into the same ClientItem path rapid_fire uses, grab target in flight
local silent_aim_target = nil
function Combat.start_silent_aim_tracker()
    killConn("sa_track")
    bindConn("sa_track", run_service.RenderStepped:Connect(function()
        if not (config.silent_aim or config.aim_assist) then silent_aim_target = nil; return end
        local fov = config.silent_aim_fov or 120
        local found = getgenv().get_screen_closest(fov, config.silent_aim_hitbox or "Head")
        silent_aim_target = found
    end))
end
function Combat.stop_silent_aim_tracker() killConn("sa_track"); silent_aim_target = nil end
getgenv().get_silent_target = function() return silent_aim_target end

-- AIM ASSIST — smooth camera toward target (no snap) ---------------------
function Combat.start_aim_assist()
    killConn("aa_assist")
    bindConn("aa_assist", run_service.RenderStepped:Connect(function(dt)
        if not config.aim_assist then return end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local t = silent_aim_target; if not t or not t.part then return end
        local cam = workspace.CurrentCamera; if not cam then return end
        local to = (t.part.Position - cam.CFrame.Position).Unit
        local goal = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + to)
        local alpha = math.clamp(dt * (config.aim_assist_smooth or 6), 0, 1)
        cam.CFrame = cam.CFrame:Lerp(goal, alpha)
    end))
end
function Combat.stop_aim_assist() killConn("aa_assist") end

-- FOV CIRCLE --------------------------------------------------------------
local fov_circle
function Combat.start_fov_circle()
    if fov_circle then pcall(function() fov_circle:Remove() end) end
    fov_circle = Drawing.new("Circle")
    fov_circle.Thickness = 1
    fov_circle.NumSides = 64
    fov_circle.Filled = false
    bindConn("fov_render", run_service.RenderStepped:Connect(function()
        if not config.fov_circle then fov_circle.Visible = false; return end
        local cam = workspace.CurrentCamera; if not cam then return end
        fov_circle.Position = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
        fov_circle.Radius   = config.fov_circle_radius or 120
        fov_circle.Color    = config.fov_circle_color or Color3.fromRGB(255,255,255)
        fov_circle.Visible  = true
    end))
end
function Combat.stop_fov_circle()
    killConn("fov_render")
    if fov_circle then pcall(function() fov_circle.Visible = false; fov_circle:Remove() end); fov_circle = nil end
end

-- AUTO PARRY / DAGGER BLOCK — triggers dagger parry on incoming projectile
local parry_hooked = false
function Combat.start_auto_parry()
    if parry_hooked then return end
    parry_hooked = true
    task.spawn(function()
        pcall(function()
            local f_ctrl_src = localplayer.PlayerScripts:WaitForChild("Controllers", 10):FindFirstChild("FighterController")
            if not f_ctrl_src then return end
            local f_ctrl = require(f_ctrl_src)
            bindConn("parry_scan", run_service.Heartbeat:Connect(function()
                if not config.dagger_bypass then return end
                local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = obj.Name:lower()
                        if (n:find("dagger") or n:find("projectile") or n:find("knife")) and obj.Velocity.Magnitude > 50 then
                            local dist = (obj.Position - hrp.Position).Magnitude
                            if dist < 25 then
                                pcall(function()
                                    if f_ctrl.LocalFighter and f_ctrl.LocalFighter.Parry then
                                        f_ctrl.LocalFighter:Parry()
                                    end
                                end)
                            end
                        end
                    end
                end
            end))
        end)
    end)
end
function Combat.stop_auto_parry() killConn("parry_scan") end

-- CHAT SPAM ---------------------------------------------------------------
function Combat.start_chat_spam()
    killTask("chat_spam")
    bindTask("chat_spam", task.spawn(function()
        while config.chat_spam_enabled do
            pcall(function()
                local ts = game:GetService("TextChatService")
                if ts and ts.ChatVersion == Enum.ChatVersion.TextChatService then
                    local gen = ts:FindFirstChild("TextChannels") and ts.TextChannels:FindFirstChild("RBXGeneral")
                    if gen then gen:SendAsync(config.chat_spam_text or "meowlua") end
                else
                    local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                    if ev then ev.SayMessageRequest:FireServer(config.chat_spam_text or "meowlua", "All") end
                end
            end)
            task.wait(math.max(config.chat_spam_delay or 1.5, 0.5))
        end
    end))
end
function Combat.stop_chat_spam() killTask("chat_spam") end

getgenv().Combat = Combat
-- =========================================================================
-- VISUALS — ESP (boxes/names/health/tracers/distance), chams, world flags
-- =========================================================================
local Visuals = {}

-- ESP ---------------------------------------------------------------------
local esp_cache = {}  -- [player] = { box, name, hp, tracer, dist, snap }
local function new_text()
    local t = Drawing.new("Text"); t.Center = true; t.Outline = true; t.Font = 2; t.Size = 14; t.Visible = false; return t
end
local function new_box()
    local b = Drawing.new("Square"); b.Thickness = 1; b.Filled = false; b.Visible = false; return b
end
local function new_line() local l = Drawing.new("Line"); l.Thickness = 1; l.Visible = false; return l end

local function wipe_entry(e)
    if not e then return end
    for _, v in pairs(e) do pcall(function() v:Remove() end) end
end

local function wipe_all_esp()
    for p, e in pairs(esp_cache) do wipe_entry(e) end
    esp_cache = {}
end

function Visuals.start_esp()
    killConn("esp_render")
    bindConn("esp_render", run_service.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera; if not cam then return end
        local anyOn = config.esp_boxes or config.esp_names or config.esp_health or config.esp_tracers or config.esp_distance
        for _, p in ipairs(players:GetPlayers()) do
            if p == localplayer then continue end
            local c = p.Character
            local show = anyOn and c and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0
                       and c:FindFirstChild("HumanoidRootPart")
            if config.esp_enemy_only and p.Team and localplayer.Team == p.Team then show = false end
            if not show then
                if esp_cache[p] then for _, v in pairs(esp_cache[p]) do v.Visible = false end end
                continue
            end
            if not esp_cache[p] then
                esp_cache[p] = { box = new_box(), name = new_text(), hp = new_text(), dist = new_text(), tracer = new_line() }
            end
            local e = esp_cache[p]
            local hrp = c.HumanoidRootPart
            local head = c:FindFirstChild("Head") or hrp
            local hum = c:FindFirstChildOfClass("Humanoid")
            local headTop = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
            local legBot  = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            if not headTop.Z or headTop.Z <= 0 then
                for _, v in pairs(e) do v.Visible = false end
                continue
            end
            local h = math.abs(legBot.Y - headTop.Y)
            local w = h * 0.55
            local col = (config.esp_team_color and p.TeamColor and p.TeamColor.Color) or config.esp_box_color or Color3.fromRGB(0,255,180)
            if config.esp_boxes then
                e.box.Visible  = true
                e.box.Position = Vector2.new(headTop.X - w/2, headTop.Y)
                e.box.Size     = Vector2.new(w, h)
                e.box.Color    = col
            else e.box.Visible = false end
            if config.esp_names then
                e.name.Visible = true
                e.name.Text    = p.Name
                e.name.Position = Vector2.new(headTop.X, headTop.Y - 16)
                e.name.Color   = col
            else e.name.Visible = false end
            if config.esp_health and hum then
                e.hp.Visible = true
                e.hp.Text    = string.format("HP %d", math.floor(hum.Health))
                e.hp.Position = Vector2.new(headTop.X, legBot.Y + 2)
                e.hp.Color   = Color3.fromRGB(0, 255, 100)
            else e.hp.Visible = false end
            if config.esp_distance then
                local myHrp = getgenv().get_hrp(localplayer)
                local d = myHrp and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0
                e.dist.Visible = true
                e.dist.Text    = string.format("%dm", d)
                e.dist.Position = Vector2.new(headTop.X, legBot.Y + 16)
                e.dist.Color   = Color3.fromRGB(200,200,200)
            else e.dist.Visible = false end
            if config.esp_tracers or config.snaplines then
                e.tracer.Visible = true
                e.tracer.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                e.tracer.To   = Vector2.new(headTop.X, legBot.Y)
                e.tracer.Color = config.snaplines and (config.snapline_color or col) or col
            else e.tracer.Visible = false end
        end
        -- clean removed players
        for p, _ in pairs(esp_cache) do
            if not p.Parent then wipe_entry(esp_cache[p]); esp_cache[p] = nil end
        end
    end))
end
function Visuals.stop_esp()
    killConn("esp_render")
    wipe_all_esp()
end

-- CHAMS -------------------------------------------------------------------
local chams_cache = {} -- [char] = Highlight
local function wipe_chams()
    for ch, hl in pairs(chams_cache) do pcall(function() hl:Destroy() end) end
    chams_cache = {}
end
function Visuals.start_chams()
    killConn("chams_step")
    bindConn("chams_step", run_service.Heartbeat:Connect(function()
        if not config.chams_enabled then wipe_chams(); return end
        for _, p in ipairs(players:GetPlayers()) do
            if p == localplayer then continue end
            local c = p.Character; if not c then continue end
            if config.esp_enemy_only and p.Team and localplayer.Team == p.Team then
                if chams_cache[c] then chams_cache[c]:Destroy(); chams_cache[c] = nil end
                continue
            end
            if not chams_cache[c] then
                local hl = Instance.new("Highlight")
                hl.Name = "meowlua_chams"
                hl.Adornee = c
                hl.FillColor    = config.chams_fill or Color3.fromRGB(0,255,180)
                hl.OutlineColor = config.chams_outline or Color3.fromRGB(0,0,0)
                hl.DepthMode = config.chams_wall and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                hl.Parent = c
                chams_cache[c] = hl
            else
                local hl = chams_cache[c]
                hl.FillColor    = config.chams_fill or Color3.fromRGB(0,255,180)
                hl.OutlineColor = config.chams_outline or Color3.fromRGB(0,0,0)
                hl.DepthMode = config.chams_wall and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            end
        end
        for c, hl in pairs(chams_cache) do
            if not c.Parent then pcall(function() hl:Destroy() end); chams_cache[c] = nil end
        end
    end))
end
function Visuals.stop_chams() killConn("chams_step"); wipe_chams() end

-- FULLBRIGHT --------------------------------------------------------------
local fb_saved
function Visuals.start_fullbright()
    fb_saved = fb_saved or {
        bright = Lighting.Brightness, amb = Lighting.Ambient, oamb = Lighting.OutdoorAmbient,
        globShadows = Lighting.GlobalShadows, fogEnd = Lighting.FogEnd,
    }
    killConn("fb_step")
    bindConn("fb_step", run_service.Heartbeat:Connect(function()
        if not config.fullbright then return end
        Lighting.Brightness      = config.fb_brightness or 2
        Lighting.Ambient         = Color3.new(1,1,1)
        Lighting.OutdoorAmbient  = Color3.new(1,1,1)
        Lighting.GlobalShadows   = false
        Lighting.FogEnd          = 1e10
    end))
end
function Visuals.stop_fullbright()
    killConn("fb_step")
    if fb_saved then
        pcall(function()
            Lighting.Brightness = fb_saved.bright
            Lighting.Ambient = fb_saved.amb
            Lighting.OutdoorAmbient = fb_saved.oamb
            Lighting.GlobalShadows = fb_saved.globShadows
            Lighting.FogEnd = fb_saved.fogEnd
        end)
    end
end

-- LOW GFX -----------------------------------------------------------------
function Visuals.apply_low_gfx(enabled)
    task.spawn(function()
        pcall(function()
            settings().Rendering.QualityLevel = enabled and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
        end)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function() obj.Enabled = not enabled end)
            end
        end
        for _, l in ipairs(Lighting:GetDescendants()) do
            if l:IsA("Atmosphere") or l:IsA("BloomEffect") or l:IsA("BlurEffect") or l:IsA("ColorCorrectionEffect") or l:IsA("DepthOfFieldEffect") or l:IsA("SunRaysEffect") then
                pcall(function() l.Enabled = not enabled end)
            end
        end
    end)
end

getgenv().Visuals = Visuals
-- =========================================================================
-- SBD + BULLET TP — projectile hijack, infinite-range ray, bullet-to-head
-- =========================================================================
local SBD = {
    active = false, originalRaycast = nil, hijackedRemotes = {},
    projectileHandler = nil, teleportedCount = 0, shotCount = 0, killCount = 0, damageDealt = 0,
}

function SBD:Enable()
    if self.active then return end
    self.active = true

    local function annihilateRaycast()
        local worldRoot = workspace
        self.originalRaycast = getmetatable(worldRoot).__index.Raycast
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(t, k)
            if t == workspace and k == "Raycast" then
                return function(origin, direction, params)
                    local extDirection = direction.Unit * 999999999
                    local rayParams = RaycastParams.new()
                    if params then
                        if params.FilterType then rayParams.FilterType = params.FilterType end
                        if params.FilterDescendantsInstances then rayParams.FilterDescendantsInstances = params.FilterDescendantsInstances end
                        if params.IgnoreWater then rayParams.IgnoreWater = params.IgnoreWater end
                    end
                    if config.sbd_ignore_walls then
                        rayParams.FilterType = Enum.RaycastFilterType.Include
                        local playerInstances = {}
                        for _, player in ipairs(players:GetPlayers()) do
                            if player ~= localplayer and player.Character then
                                for _, part in ipairs(player.Character:GetChildren()) do
                                    if part:IsA("BasePart") then table.insert(playerInstances, part) end
                                end
                            end
                        end
                        rayParams.FilterDescendantsInstances = playerInstances
                    end
                    local result = self.originalRaycast(worldRoot, origin, extDirection, rayParams)
                    return result
                end
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end

    local function hijackAllRemotes()
        local function hijackRemote(remote)
            if self.hijackedRemotes[remote] then return end
            self.hijackedRemotes[remote] = true
            local originalFireServer = remote.FireServer
            remote.FireServer = function(self_r, ...)
                local args = {...}
                local remoteName   = remote.Name:lower()
                local remoteParent = remote.Parent and remote.Parent.Name:lower() or ""
                local weaponRelated = remoteName:find("fire") or remoteName:find("shoot") or remoteName:find("launch") or remoteName:find("attack") or remoteName:find("projectile") or remoteName:find("weapon") or remoteName:find("sling") or remoteName:find("bow") or remoteName:find("dagger") or remoteName:find("throw") or remoteName:find("arrow") or remoteName:find("bolt") or remoteName:find("pellet") or remoteName:find("bullet") or remoteName:find("knife") or remoteName:find("blade") or remoteParent:find("weapon") or remoteParent:find("slingshot") or remoteParent:find("bow") or remoteParent:find("dagger")
                if weaponRelated and config.sbd_infinite_range then
                    self.shotCount = self.shotCount + 1
                    local modifiedArgs = {}
                    for i, arg in ipairs(args) do
                        if typeof(arg) == "Vector3" then
                            local camPos = workspace.CurrentCamera.CFrame.Position
                            local direction = (arg - camPos).Unit
                            if config.sbd_heat_seeking or config.silent_aim then
                                local t = getgenv().get_silent_target() or (getgenv().get_closest(true) and {part=getgenv().get_closest(true).Character and getgenv().get_closest(true).Character:FindFirstChild("Head")} or nil)
                                if t and t.part then direction = (t.part.Position - camPos).Unit end
                            end
                            modifiedArgs[i] = camPos + direction * 999999999
                        elseif typeof(arg) == "CFrame" then
                            local camPos = workspace.CurrentCamera.CFrame.Position
                            local direction = arg.LookVector
                            if config.sbd_heat_seeking or config.silent_aim then
                                local t = getgenv().get_silent_target() or (getgenv().get_closest(true) and {part=getgenv().get_closest(true).Character and getgenv().get_closest(true).Character:FindFirstChild("Head")} or nil)
                                if t and t.part then direction = (t.part.Position - camPos).Unit end
                            end
                            modifiedArgs[i] = CFrame.lookAt(camPos, camPos + direction * 999999999)
                        else modifiedArgs[i] = arg end
                    end
                    local burstCount = config.sbd_rapid_fire and 5 or 1
                    for _ = 1, burstCount do
                        task.spawn(function() pcall(function() originalFireServer(remote, unpack(modifiedArgs)) end) end)
                    end
                    return originalFireServer(remote, unpack(modifiedArgs))
                else
                    return originalFireServer(remote, ...)
                end
            end
        end
        local function scanAndHijack(parent)
            if not parent then return end
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then pcall(function() hijackRemote(child) end) end
                if #child:GetChildren() > 0 then scanAndHijack(child) end
            end
        end
        scanAndHijack(ReplicatedStorage); scanAndHijack(workspace)
    end

    local projNames = {"projectile","arrow","bolt","dagger","rock","pellet","bullet","sling","dart","spear","knife","blade"}
    local function is_projectile(obj)
        if not obj:IsA("BasePart") then return false end
        local n = obj.Name:lower()
        for _, k in ipairs(projNames) do if n:find(k) then return true end end
        if obj.Velocity.Magnitude > 50 and obj.Size.Magnitude < 10 then return true end
        return false
    end

    local function enableProjectileTeleport()
        self.projectileHandler = run_service.Heartbeat:Connect(function()
            if not config.sbd_teleport_projectiles then return end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not is_projectile(obj) or obj.Velocity.Magnitude <= 0 then continue end
                pcall(function()
                    local best, bd = nil, math.huge
                    for _, p in ipairs(players:GetPlayers()) do
                        if p == localplayer then continue end
                        if p.Team and localplayer.Team and p.Team == localplayer.Team then continue end
                        local c = p.Character; if not c then continue end
                        if c:FindFirstChildOfClass("ForceField") then continue end
                        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then continue end
                        local hrp = c:FindFirstChild("HumanoidRootPart"); local head = c:FindFirstChild("Head")
                        if not hrp then continue end
                        local tp = head or hrp
                        local d = (obj.Position - tp.Position).Magnitude
                        if d < bd and d < (config.bullet_tp_radius or 5000) then
                            bd = d; best = { Character = c, Humanoid = hum, TargetPart = tp }
                        end
                    end
                    if best then
                        local tp = best.TargetPart
                        obj.Position = tp.Position + (obj.Velocity.Unit * 2)
                        obj.CFrame = CFrame.lookAt(obj.Position, tp.Position)
                        self.teleportedCount = self.teleportedCount + 1
                        if config.sbd_instant_kill and best.Humanoid then
                            local dmg = 9999 * (config.sbd_damage_mult or 100)
                            best.Humanoid:TakeDamage(dmg)
                            if best.Humanoid.Health <= 0 then self.killCount = self.killCount + 1; self.damageDealt = self.damageDealt + dmg end
                        end
                        obj:Destroy()
                    end
                end)
            end
        end)
    end

    annihilateRaycast(); hijackAllRemotes(); enableProjectileTeleport()
    notify("SBD", "Bypass active")
end

function SBD:Disable()
    self.active = false
    if self.projectileHandler then self.projectileHandler:Disconnect(); self.projectileHandler = nil end
    notify("SBD", "Disabled")
end

local BulletTP = { active = false, task = nil, teleportCount = 0 }
function BulletTP:findTargets()
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return {} end
    local out = {}
    for _, p in ipairs(players:GetPlayers()) do
        if p == localplayer then continue end
        if p.Team and localplayer.Team and p.Team == localplayer.Team then continue end
        local c = p.Character; if not c then continue end
        local r = c:FindFirstChild("HumanoidRootPart"); local h = c:FindFirstChild("Head"); local hu = c:FindFirstChildOfClass("Humanoid")
        if not (r and h and hu and hu.Health > 0) then continue end
        if c:FindFirstChildOfClass("ForceField") then continue end
        local d = (hrp.Position - r.Position).Magnitude
        if d < (config.bullet_tp_radius or 5000) then table.insert(out, { root=r, head=h, dist=d }) end
    end
    table.sort(out, function(a,b) return a.dist < b.dist end)
    return out
end

function BulletTP:Enable()
    if self.active then return end
    self.active = true
    self.task = task.spawn(function()
        while self.active do
            if not config.bullet_tp_enabled then task.wait(0.1); continue end
            local tgs = self:findTargets()
            if #tgs == 0 then task.wait(0.05); continue end
            local tgt = tgs[1]
            local target_part = config.bullet_tp_headshot and tgt.head or tgt.root
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Velocity.Magnitude > 0 then
                        local n = obj.Name:lower()
                        local is = false
                        for _, k in ipairs({"projectile","arrow","bolt","dagger","rock","pellet","bullet","sling","dart","spear","knife","blade"}) do
                            if n:find(k) then is = true break end
                        end
                        if is then
                            for _ = 1, (config.bullet_tp_attempts or 10) do
                                obj.CFrame = CFrame.new(target_part.Position); task.wait(config.bullet_tp_delay or 0.005)
                            end
                            if config.bullet_tp_auto_reset then pcall(function() obj:Destroy() end) end
                        end
                    end
                end
            end)
            self.teleportCount = self.teleportCount + 1
            task.wait(0.01)
        end
    end)
end
function BulletTP:Disable() self.active = false; if self.task then pcall(task.cancel, self.task); self.task = nil end end

getgenv().SBD = SBD; getgenv().BulletTP = BulletTP
-- =========================================================================
-- ABUSER MODULES — pos_spam, map_orbit, riot_abuser, strafebot, zigzag, evasion
-- =========================================================================
getgenv().start_pos_spam = function()
    killConn("pos_spam")
    bindConn("pos_spam", run_service.Heartbeat:Connect(function()
        if not config.pos_spam_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        local sign = math.random() > 0.5 and 1 or -1
        local dist = (1e9 + math.random() * (12e25 - 1e9)) * sign
        hrp.CFrame = CFrame.new(math.random(-5000, 5000), dist, math.random(-5000, 5000))
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end))
end
getgenv().stop_pos_spam = function() killConn("pos_spam"); config.pos_spam_enabled = false end

getgenv().start_map_orbit = function()
    killConn("map_orbit")
    local acc = config.mo_interval or 0.05
    bindConn("map_orbit", run_service.Heartbeat:Connect(function(dt)
        if not config.map_orbit_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        acc = acc + dt
        if acc >= (config.mo_interval or 0.05) then
            acc = 0
            local iters = math.clamp(config.mo_burst or 1000, 100, 5000)
            for i = 1, iters do
                local rx = math.random(-config.map_orbit_x, config.map_orbit_x)
                local rz = math.random(-config.map_orbit_z, config.map_orbit_z)
                hrp.CFrame = CFrame.new(rx, -math.abs(config.map_orbit_y or 1000000), rz)
            end
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end))
end
getgenv().stop_map_orbit = function() killConn("map_orbit"); config.map_orbit_enabled = false end

getgenv().start_riot_abuser = function()
    killConn("riot_abuser")
    local hrp = getgenv().get_hrp(localplayer); getgenv().ra_original = hrp and hrp.CFrame or nil
    local t0 = tick(); local seed = math.random(1000, 9999)
    bindConn("riot_abuser", run_service.Heartbeat:Connect(function(dt)
        if not config.riot_abuser_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        local t = tick() - t0; local sm = config.riot_abuser_spin or 1e12
        local yaw   = math.rad(sm * dt)
        local pitch = math.rad(sm * 0.37 * dt * math.sin(t * 3.1))
        local roll  = math.rad(sm * 0.19 * dt * math.cos(t * 5.7 + seed))
        local spinCF = hrp.CFrame * CFrame.Angles(pitch, yaw, roll)
        local spread = (config.riot_abuser_distance or 500) / 300
        local jX = (math.random() - 0.5) * (config.riot_abuser_x or 50) * spread * 2 + math.noise(t * 9, seed, 0) * (config.riot_abuser_x or 50) * spread
        local jY = (math.random() - 0.5) * (config.riot_abuser_y or 15) * spread + math.noise(0, t * 9, seed) * (config.riot_abuser_y or 15) * spread * 0.3
        local jZ = (math.random() - 0.5) * (config.riot_abuser_z or 50) * spread * 2 + math.noise(0, 0, t * 9 + seed) * (config.riot_abuser_z or 50) * spread
        hrp.CFrame = spinCF + Vector3.new(jX, math.max(spinCF.Position.Y + jY, 2) - spinCF.Position.Y, jZ)
    end))
end
getgenv().stop_riot_abuser = function()
    killConn("riot_abuser")
    local hrp = getgenv().get_hrp(localplayer)
    if hrp and getgenv().ra_original then pcall(function() hrp.CFrame = getgenv().ra_original end) end
end

local strafe_angle, strafe_dir = 0, 1
getgenv().start_strafebot = function()
    killConn("strafe_s"); killConn("strafe_rs")
    strafe_angle = 0; local last_switch = tick()
    bindConn("strafe_s", run_service.Stepped:Connect(function(_, dt)
        if not config.strafebot_enabled then return end
        local target = getgenv().get_closest(true); local hrp = getgenv().get_hrp(localplayer)
        if target and target.Character and hrp then
            local th = target.Character:FindFirstChild("HumanoidRootPart")
            if th then
                if config.strafe_randomize and tick() - last_switch > math.random(1, 3) then
                    strafe_dir = -strafe_dir; last_switch = tick()
                end
                strafe_angle = strafe_angle + (((config.strafe_speed or 50) / 100) * strafe_dir * dt * 60)
                local tv = th.AssemblyLinearVelocity
                local pred = th.Position + (tv * dt + (tv * (localplayer:GetNetworkPing() * 2)))
                local off = Vector3.new(math.cos(strafe_angle) * (config.strafe_radius or 15), config.strafe_height or 5, math.sin(strafe_angle) * (config.strafe_radius or 15))
                hrp.CFrame = CFrame.lookAt(pred + off, th.Position)
                hrp.AssemblyLinearVelocity  = tv
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end))
end
getgenv().stop_strafebot = function() killConn("strafe_s"); killConn("strafe_rs"); config.strafebot_enabled = false end

getgenv().start_zigzag_abuser = function()
    killConn("zigzag")
    bindConn("zigzag", run_service.Heartbeat:Connect(function()
        if not config.zigzag_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        local spd = config.zigzag_speed or 50
        local spread = config.zigzag_spread or 500
        local t = tick() * spd
        local x = math.sin(t) * spread + math.random(-spread, spread)
        local y = math.cos(t * 1.3) * spread + math.random(50, spread)
        local z = math.sin(t * 0.8) * spread + math.random(-spread, spread)
        local tgt = getgenv().get_closest(true)
        local base = (tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart")) and tgt.Character.HumanoidRootPart.Position or hrp.Position
        hrp.CFrame = CFrame.new(base + Vector3.new(x, y, z))
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end))
end
getgenv().stop_zigzag_abuser = function() killConn("zigzag") end
-- =========================================================================
-- SHAPE OFFSETS — evasion + void burst — core set, dense and tight
-- =========================================================================
local function compute_evasion_offset(mode, t, r)
    if mode=="Random" then return Vector3.new(math.random(-r,r),math.random(-r,r),math.random(-r,r))
    elseif mode=="Circle" then local a=t*math.pi*2 return Vector3.new(math.cos(a)*r,0,math.sin(a)*r)
    elseif mode=="Spiral" then local a=t*math.pi*2*3 return Vector3.new(math.cos(a)*r*t,math.sin(t*math.pi)*r*0.5,math.sin(a)*r*t)
    elseif mode=="Figure8" then local a=t*math.pi*2 return Vector3.new(math.sin(a)*r,math.sin(a*2)*r*0.5,math.cos(a)*r*math.cos(a))
    elseif mode=="Helix" then local a=t*math.pi*2*4 return Vector3.new(math.cos(a)*r,math.sin(t*math.pi*2)*r,math.sin(a)*r)
    elseif mode=="Star" then local k=math.floor(t*5)%2==0; local a=t*math.pi*2 return Vector3.new(math.cos(a)*(k and r or r*0.4),0,math.sin(a)*(k and r or r*0.4))
    elseif mode=="Triangle" then local p=t%3; local v; if p<1 then v=Vector3.new(0,r,0):Lerp(Vector3.new(r,-r,0),p) elseif p<2 then v=Vector3.new(r,-r,0):Lerp(Vector3.new(-r,-r,0),p-1) else v=Vector3.new(-r,-r,0):Lerp(Vector3.new(0,r,0),p-2) end return v
    elseif mode=="Square" then local p=t%4; if p<1 then return Vector3.new(r,-r,0):Lerp(Vector3.new(r,r,0),p) elseif p<2 then return Vector3.new(r,r,0):Lerp(Vector3.new(-r,r,0),p-1) elseif p<3 then return Vector3.new(-r,r,0):Lerp(Vector3.new(-r,-r,0),p-2) else return Vector3.new(-r,-r,0):Lerp(Vector3.new(r,-r,0),p-3) end
    elseif mode=="Hexagon" then local ph=(math.floor(t*6)%6)/6*math.pi*2 return Vector3.new(math.cos(ph)*r,0,math.sin(ph)*r)
    elseif mode=="Diamond" then local p=t%4; if p<1 then return Vector3.new(0,r,0):Lerp(Vector3.new(r,0,0),p) elseif p<2 then return Vector3.new(r,0,0):Lerp(Vector3.new(0,-r,0),p-1) elseif p<3 then return Vector3.new(0,-r,0):Lerp(Vector3.new(-r,0,0),p-2) else return Vector3.new(-r,0,0):Lerp(Vector3.new(0,r,0),p-3) end
    elseif mode=="Cross" then local tog=math.floor(t*10)%2==0 return Vector3.new(tog and r or 0,0,not tog and r or 0)
    elseif mode=="Zigzag" then local p=t%2 return Vector3.new((p<1 and p or 2-p)*r*2-r,0,math.floor(t)*r*0.5)
    elseif mode=="Wave" then return Vector3.new(t*r*4,math.sin(t*math.pi*6)*r,0)
    elseif mode=="Sine" then local a=t*math.pi*2*3 return Vector3.new(math.sin(a)*r,math.cos(a*0.5)*r*0.5,math.sin(a*0.7)*r*0.3)
    elseif mode=="Rose" then local a=t*math.pi*2; local rr=math.cos(3*a)*r return Vector3.new(rr*math.cos(a),0,rr*math.sin(a))
    elseif mode=="Butterfly" then local a=t*math.pi*2; local rr=(math.exp(math.cos(a))-2*math.cos(4*a))*r*0.3 return Vector3.new(math.sin(a)*rr,math.cos(a*2)*r*0.3,math.cos(a)*rr)
    elseif mode=="Cardioid" then local a=t*math.pi*2 return Vector3.new((1-math.cos(a))*r*0.5*math.cos(a),0,(1-math.cos(a))*r*0.5*math.sin(a))
    elseif mode=="Lemniscate" then local a=t*math.pi*2; local d=1+math.sin(a)^2 return Vector3.new(math.cos(a)/d*r,0,math.sin(a)*math.cos(a)/d*r)
    elseif mode=="Pentagon" then local ph=(math.floor(t*5)%5)/5*math.pi*2 return Vector3.new(math.cos(ph)*r,0,math.sin(ph)*r)
    elseif mode=="Octagon" then local ph=(math.floor(t*8)%8)/8*math.pi*2 return Vector3.new(math.cos(ph)*r,0,math.sin(ph)*r)
    else return Vector3.new(math.random(-r,r),math.random(-r,r),math.random(-r,r)) end
end

local function get_vs_order_offset(order, frac, i, ph, radius)
    if order=="Triangle" then
        local seg=math.floor(frac*3); local f=(frac*3)-seg
        if seg==0 then return Vector3.new(0,radius,0):Lerp(Vector3.new(radius,-radius,0),f)
        elseif seg==1 then return Vector3.new(radius,-radius,0):Lerp(Vector3.new(-radius,-radius,0),f)
        else return Vector3.new(-radius,-radius,0):Lerp(Vector3.new(0,radius,0),f) end
    elseif order=="Circle" then return Vector3.new(math.cos(ph)*radius,0,math.sin(ph)*radius)
    elseif order=="Square" then
        local seg=math.floor(frac*4); local f=(frac*4)-seg
        if seg==0 then return Vector3.new(radius,-radius,0):Lerp(Vector3.new(radius,radius,0),f)
        elseif seg==1 then return Vector3.new(radius,radius,0):Lerp(Vector3.new(-radius,radius,0),f)
        elseif seg==2 then return Vector3.new(-radius,radius,0):Lerp(Vector3.new(-radius,-radius,0),f)
        else return Vector3.new(-radius,-radius,0):Lerp(Vector3.new(radius,-radius,0),f) end
    elseif order=="Pentagon" then
        local seg=math.floor(frac*5); local f=(frac*5)-seg
        local a1=(seg/5)*math.pi*2; local a2=((seg+1)/5)*math.pi*2
        return Vector3.new(math.cos(a1)*radius,0,math.sin(a1)*radius):Lerp(Vector3.new(math.cos(a2)*radius,0,math.sin(a2)*radius),f)
    elseif order=="Hexagon" then
        local seg=math.floor(frac*6); local f=(frac*6)-seg
        local a1=(seg/6)*math.pi*2; local a2=((seg+1)/6)*math.pi*2
        return Vector3.new(math.cos(a1)*radius,0,math.sin(a1)*radius):Lerp(Vector3.new(math.cos(a2)*radius,0,math.sin(a2)*radius),f)
    elseif order=="Octagon" then
        local seg=math.floor(frac*8); local f=(frac*8)-seg
        local a1=(seg/8)*math.pi*2; local a2=((seg+1)/8)*math.pi*2
        return Vector3.new(math.cos(a1)*radius,0,math.sin(a1)*radius):Lerp(Vector3.new(math.cos(a2)*radius,0,math.sin(a2)*radius),f)
    elseif order=="Star" then
        local seg=math.floor(frac*10); local f=(frac*10)-seg
        local r1=seg%2==0 and radius or radius*0.4
        local r2=seg%2==0 and radius*0.4 or radius
        local a1=(seg/10)*math.pi*2; local a2=((seg+1)/10)*math.pi*2
        return Vector3.new(math.cos(a1)*r1,0,math.sin(a1)*r1):Lerp(Vector3.new(math.cos(a2)*r2,0,math.sin(a2)*r2),f)
    elseif order=="Diamond" then
        local seg=math.floor(frac*4); local f=(frac*4)-seg
        if seg==0 then return Vector3.new(0,radius,0):Lerp(Vector3.new(radius,0,0),f)
        elseif seg==1 then return Vector3.new(radius,0,0):Lerp(Vector3.new(0,-radius,0),f)
        elseif seg==2 then return Vector3.new(0,-radius,0):Lerp(Vector3.new(-radius,0,0),f)
        else return Vector3.new(-radius,0,0):Lerp(Vector3.new(0,radius,0),f) end
    elseif order=="Cross" then
        local seg=math.floor(frac*4); local f=(frac*4)-seg
        if seg==0 then return Vector3.new(-radius,0,0):Lerp(Vector3.new(radius,0,0),f)
        elseif seg==1 then return Vector3.new(radius,0,0):Lerp(Vector3.new(0,0,0),f)
        elseif seg==2 then return Vector3.new(0,0,-radius):Lerp(Vector3.new(0,0,radius),f)
        else return Vector3.new(0,0,radius):Lerp(Vector3.new(0,0,0),f) end
    elseif order=="Spiral" then
        local turns=3; local a=frac*math.pi*2*turns; local r=frac*radius
        return Vector3.new(math.cos(a)*r,math.sin(frac*math.pi*2)*radius*0.5,math.sin(a)*r)
    elseif order=="Zigzag" then
        local segs=20; local seg=math.floor(frac*segs); local f=(frac*segs)-seg
        local x1=(seg%2==0) and -radius or radius; local x2=(seg%2==0) and radius or -radius
        local z1=(seg/segs)*radius*2-radius; local z2=((seg+1)/segs)*radius*2-radius
        return Vector3.new(x1,0,z1):Lerp(Vector3.new(x2,0,z2),f)
    elseif order=="Wave" then
        local x=(frac-0.5)*radius*2
        return Vector3.new(x,math.sin(frac*math.pi*6)*radius,0)
    elseif order=="Figure8" then
        return Vector3.new(math.sin(ph)*radius,math.sin(ph*2)*radius*0.25,math.sin(ph)*math.cos(ph)*radius)
    elseif order=="Lemniscate" then
        local cos2=math.cos(2*ph); local rr=cos2>=0 and math.sqrt(cos2)*radius or 0
        return Vector3.new(math.cos(ph)*rr,0,math.sin(ph)*rr)
    elseif order=="Rose" then
        local a=frac*math.pi; local rr=math.cos(3*a)*radius
        return Vector3.new(rr*math.cos(a),0,rr*math.sin(a))
    elseif order=="Butterfly" then
        local rr=(math.exp(math.cos(ph))-2*math.cos(4*ph))*radius*0.3
        return Vector3.new(math.sin(ph)*rr,math.cos(ph*2)*radius*0.25,math.cos(ph)*rr)
    elseif order=="Cardioid" then
        local rr=(1-math.cos(ph))*radius*0.5
        return Vector3.new(rr*math.cos(ph),0,rr*math.sin(ph))
    elseif order=="Helix3D" then
        local a=frac*math.pi*4
        return Vector3.new(math.cos(a)*radius,frac*radius*2-radius,math.sin(a)*radius)
    elseif order=="Sine" then
        local a=frac*math.pi*6
        return Vector3.new(math.sin(a)*radius,math.cos(a*0.5)*radius*0.5,math.sin(a*0.7)*radius*0.3)
    elseif order=="Torus" then
        local a=frac*math.pi*2*5; local b=frac*math.pi*2
        local R=radius*0.7; local r=radius*0.3
        return Vector3.new((R+r*math.cos(b))*math.cos(a),r*math.sin(b),(R+r*math.cos(b))*math.sin(a))
    elseif order=="Galaxy" then
        local a=frac*math.pi*6; local rr=frac*radius
        return Vector3.new(rr*math.cos(a),math.sin(frac*math.pi*2)*radius*0.2,rr*math.sin(a))
    elseif order=="Lightning" then
        local x=(frac-0.5)*radius*2
        return Vector3.new(x+math.sin(frac*47)*radius*0.5,math.sin(frac*50)*radius*0.5,(math.sin(frac*31)-0.5)*radius)
    elseif order=="Chaos3D" then
        local a=frac*math.pi*7; local b=frac*math.pi*11; local c=frac*math.pi*13
        return Vector3.new(math.sin(a)*math.cos(b)*radius,math.sin(b)*math.sin(c)*radius*0.7,math.cos(a)*math.cos(c)*radius)
    elseif order=="Tornado3D" then
        local a=frac*math.pi*2*6; local r=frac*radius
        return Vector3.new(r*math.cos(a),frac*radius*2-radius,r*math.sin(a))
    elseif order=="DNA" then
        local a=frac*math.pi*2*5
        local strand=(i%2==0) and 1 or -1
        return Vector3.new(strand*math.cos(a)*radius,frac*radius*2-radius,strand*math.sin(a)*radius)
    elseif order=="Nova" then
        local rr=radius*(0.5+0.5*math.sin(ph*17))*(1+0.3*math.cos(ph*5))
        return Vector3.new(rr*math.cos(ph),math.sin(ph*7)*radius*0.3,rr*math.sin(ph))
    else return Vector3.new(math.cos(ph)*radius,0,math.sin(ph)*radius) end
end

local vs_spiral, vs_wave, vs_helix, vs_strobe = 0, 0, 0, false
local vs_bounce_dir = { x=1, y=1, z=1 }
local vs_chaos = { math.random(), math.random(), math.random() }
local function get_vs_delta(dt, xp, xn, yp, yn, zp, zn)
    local ax,ay,az,p = config.void_axis_x, config.void_axis_y, config.void_axis_z, config.void_pattern
    if p=="spiral" then vs_spiral=vs_spiral+0.35 return Vector3.new(ax and math.cos(vs_spiral)*(xp+xn)/2 or 0, ay and math.sin(vs_spiral*0.6)*(yp+yn)/2 or 0, az and math.sin(vs_spiral)*(zp+zn)/2 or 0)
    elseif p=="wave" then vs_wave=vs_wave+dt*8 return Vector3.new(ax and math.sin(vs_wave)*(xp+xn)/2 or 0, ay and math.sin(vs_wave*1.7)*(yp+yn)/2 or 0, az and math.cos(vs_wave*0.9)*(zp+zn)/2 or 0)
    elseif p=="chaos" then vs_chaos[1]=(vs_chaos[1]*1664525+1013904223)%1; vs_chaos[2]=(vs_chaos[2]*22695477+1)%1; vs_chaos[3]=(vs_chaos[3]*214013+2531011)%1 return Vector3.new(ax and (vs_chaos[1]*(xp+xn)-xn) or 0, ay and (vs_chaos[2]*(yp+yn)-yn) or 0, az and (vs_chaos[3]*(zp+zn)-zn) or 0)
    elseif p=="helix" then vs_helix=vs_helix+dt*6 return Vector3.new(ax and math.cos(vs_helix*2)*(xp+xn)/2 or 0, ay and math.sin(vs_helix)*(yp+yn)/8 or 0, az and math.sin(vs_helix*2)*(zp+zn)/2 or 0)
    elseif p=="strobe" then vs_strobe=not vs_strobe; local s=vs_strobe and 1 or -1 return Vector3.new(ax and s*xp or 0, ay and s*yp or 0, az and s*zp or 0)
    elseif p=="rhombus" then
        local phase=(dt*2)%4; local wx=(xp+xn)/2; local z=(zp+zn)/2; local y=(yp+yn)/2
        if phase<1 then return Vector3.new(ax and wx*(1-phase) or 0, ay and -y or 0, az and z*phase or 0)
        elseif phase<2 then local pt=phase-1 return Vector3.new(ax and -wx*pt or 0, ay and -y or 0, az and z*(1-pt) or 0)
        elseif phase<3 then local pt=phase-2 return Vector3.new(ax and -wx*(1-pt) or 0, ay and -y or 0, az and -z*pt or 0)
        else local pt=phase-3 return Vector3.new(ax and wx*pt or 0, ay and -y or 0, az and -z*(1-pt) or 0) end
    else return Vector3.new(ax and (math.random()*(xp+xn)-xn) or 0, ay and (math.random()*(yp+yn)-yn) or 0, az and (math.random()*(zp+zn)-zn) or 0) end
end

-- EVASION -----------------------------------------------------------------
getgenv().start_evasion = function()
    killConn("evasion")
    local dt_buf = 0
    bindConn("evasion", run_service.Heartbeat:Connect(function(dt)
        if not config.evasion_enabled then return end
        local hrp = getgenv().get_hrp(localplayer)
        local hum = getgenv().get_hum()
        if not hrp or not hum or hum.Health <= 0 then return end
        if hum:GetState() ~= Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        dt_buf = dt_buf + dt
        local interval = math.max((config.evasion_interval or 1) * 0.001, 0.001)
        if dt_buf >= interval then
            dt_buf = 0
            local iters = math.clamp(config.evasion_burst or 500, 100, 1000)
            local spd = config.evasion_spin_speed or 9999
            local t = tick()
            for i = 1, iters do
                local frac = (i - 1) / iters
                local offset = compute_evasion_offset(config.evasion_mode or "Random", frac, 50000)
                local dest = hrp.Position + offset
                hrp.CFrame = CFrame.new(dest.X, dest.Y, dest.Z)
                    * CFrame.Angles(math.rad(spd * t * 1.0 % 360), math.rad(spd * t * 0.73 % 360), math.rad(spd * t * 0.41 % 360))
            end
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end))
end
getgenv().stop_evasion = function() killConn("evasion"); config.evasion_enabled = false end

-- VOIDSPAM ----------------------------------------------------------------
local last_vs_pos = nil
getgenv().start_void_spam = function()
    killConn("void_spam")
    local dt_buf = 0
    bindConn("void_spam", run_service.Heartbeat:Connect(function(dt)
        if not config.void_spam_enabled then getgenv().stop_void_spam() return end
        for _, o in ipairs(workspace:GetChildren()) do
            if o.Name == "CoreProjectile" and o:IsA("BasePart") then
                o.CFrame = CFrame.new(999999, 999999, 999999)
                o.AssemblyLinearVelocity = Vector3.zero
            end
        end
        local hrp = getgenv().get_hrp(localplayer); local hum = getgenv().get_hum()
        if not hrp or not hum or hum.Health <= 0 then return end
        if hum:GetState() ~= Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.Physics) end
        dt_buf = dt_buf + dt
        if dt_buf >= 0.001 then
            local iters = math.clamp(config.et_total or 500, 1, 500)
            for i = 1, iters do
                local frac = (i - 1) / iters
                local ph = frac * math.pi * 2
                local radius = 50000
                local offset = get_vs_order_offset(config.et_order or "Triangle", frac, i, ph, radius)
                local finalPos = last_vs_pos or hrp.Position
                local mode = config.et_mode or "Random"
                if mode == "Random" then finalPos = hrp.Position + offset + Vector3.new(math.random(-500,500), math.random(-500,500), math.random(-500,500))
                elseif mode == "Camera" then local cam = workspace.CurrentCamera; if cam then finalPos = cam.CFrame.Position + (cam.CFrame.LookVector * radius) + offset end
                elseif mode == "Forward" then finalPos = hrp.Position + (hrp.CFrame.LookVector * radius) + offset
                elseif mode == "Directional" then
                    local raw = get_vs_delta(dt, config.vs_xp, config.vs_xn, config.vs_yp, config.vs_yn, config.vs_zp, config.vs_zn)
                    local dir = raw.Unit
                    if dir.Magnitude == dir.Magnitude then finalPos = finalPos + (dir * (config.vs_dist_per_tp or 1000)) end
                end
                last_vs_pos = finalPos
                hrp.CFrame = CFrame.new(finalPos)
            end
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            dt_buf = 0
        end
    end))
end
getgenv().stop_void_spam = function() killConn("void_spam"); config.void_spam_enabled = false; last_vs_pos = nil end

getgenv()._shapes_evasion_list = {
    "Random","Circle","Spiral","Figure8","Helix","Star","Triangle","Square","Pentagon","Hexagon",
    "Octagon","Diamond","Cross","Zigzag","Wave","Sine","Lemniscate","Rose","Butterfly","Cardioid",
}
getgenv()._shapes_void_list = {
    "Triangle","Circle","Square","Pentagon","Hexagon","Octagon","Star","Diamond","Cross","Spiral",
    "Zigzag","Wave","Figure8","Lemniscate","Rose","Butterfly","Cardioid","Helix3D","Sine","Torus",
    "Galaxy","Lightning","Chaos3D","Tornado3D","DNA","Nova",
}
getgenv()._shapes_void_pattern_list = {
    "random","spiral","wave","chaos","helix","strobe","rhombus",
}
-- =========================================================================
-- ANTI AIM, AUTOMATION, RAGEBOT, GUN MODS — kept and tightened
-- =========================================================================

-- ANTI AIM ----------------------------------------------------------------
local aa_orbit_angle = 0
getgenv().start_anti_aim = function()
    killConn("anti_aim")
    local aa_t0 = tick()
    bindConn("anti_aim", run_service.Heartbeat:Connect(function(dt)
        if not config.anti_aim_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); local hum = getgenv().get_hum()
        local cam = workspace.CurrentCamera
        if not hrp or not cam then return end
        local method = config.aa_method or "Static"
        local t = tick() - aa_t0
        if method=="Pixelated" then
            if hum then hum.AutoRotate=false end
            local char=localplayer.Character
            if char then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then pcall(function() v.Size=v.Size*math.clamp((config.aa_pixel_scale or 1)/100,0.01,1) end) end end end
            hrp.CFrame=hrp.CFrame*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
        elseif method=="Static" then
            if hum then hum.AutoRotate=false end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(math.rad(180),0,0)
        elseif method=="Spin" then
            if hum then hum.AutoRotate=false end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,math.rad((config.aa_spin_speed or 9999)*t%360),0)
        elseif method=="Jitter" then
            if hum then hum.AutoRotate=false end
            local tog=(math.floor(t*30))%2==0
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(tog and math.rad(180) or 0,tog and math.rad(90) or math.rad(-90),0)
        elseif method=="Desync" then
            if hum then hum.AutoRotate=false end
            local rootPos=hrp.Position; local look=cam.CFrame.LookVector
            local base=CFrame.lookAt(rootPos,rootPos+Vector3.new(look.X,0,look.Z))
            hrp.CFrame=base*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
            for _,v in pairs(localplayer.Character:GetDescendants()) do
                if v:IsA("Motor6D") and v.Name~="RootJoint" then pcall(function() v.Transform=CFrame.Angles(math.rad(math.random(0,360)),math.rad(math.random(0,360)),math.rad(math.random(0,360))) end) end
            end
        elseif method=="Sway" then
            if hum then hum.AutoRotate=false end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(math.cos(t*2)*math.rad(45),math.sin(t*3)*math.rad(90),math.sin(t*1.5)*math.rad(30))
        elseif method=="Breaker" then
            if hum then hum.AutoRotate=false end
            if (math.floor(t*20))%5==0 then hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(math.rad(math.random(-720,720)),math.rad(math.random(-720,720)),math.rad(math.random(-720,720)))
            else hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(math.rad(180),0,0) end
        elseif method=="Lurk" then
            if hum then hum.AutoRotate=false end
            local look=cam.CFrame.LookVector; local away=Vector3.new(-look.X,0,-look.Z); local rootPos=hrp.Position
            if away.Magnitude>0.001 then hrp.CFrame=CFrame.lookAt(rootPos,rootPos+away)*CFrame.Angles(math.rad(15),math.rad(180),0) end
        elseif method=="Orbit" then
            if hum then hum.AutoRotate=false end
            aa_orbit_angle=aa_orbit_angle+dt*(config.aa_spin_speed or 9999)*0.05
            local dirs={Vector3.new(math.cos(aa_orbit_angle),0,math.sin(aa_orbit_angle)),Vector3.new(0,math.sin(aa_orbit_angle),math.cos(aa_orbit_angle))}
            local chosen=dirs[(math.floor(t*8)%#dirs)+1]; local rootPos=hrp.Position; local rand_r=math.random(500,50000)
            hrp.CFrame=CFrame.new(rootPos+chosen*rand_r)*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
            hrp.AssemblyLinearVelocity=Vector3.zero; hrp.AssemblyAngularVelocity=Vector3.zero
        elseif method=="Custom" then
            if hum then hum.AutoRotate=false end
            hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(math.rad(config.aa_pitch or 0),math.rad(config.aa_yaw or 0),math.rad(config.aa_roll or 0))
        end
    end))
end
getgenv().stop_anti_aim = function()
    killConn("anti_aim")
    local hum = getgenv().get_hum(); if hum then pcall(function() hum.AutoRotate = true end) end
    config.anti_aim_enabled = false
end

-- ANTI AFK ----------------------------------------------------------------
getgenv().start_anti_afk = function()
    killConn("anti_afk")
    bindConn("anti_afk", localplayer.Idled:Connect(function()
        if config.anti_afk_enabled then
            virtual_user:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            virtual_user:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end))
end
getgenv().stop_anti_afk = function() killConn("anti_afk") end

-- AUTO COLLECT ------------------------------------------------------------
local last_auto_tick = 0
getgenv().start_autocollect = function()
    killConn("autocollect")
    bindConn("autocollect", run_service.Heartbeat:Connect(function()
        if not config.autocollect_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        if tick() - last_auto_tick < 0.25 then return end; last_auto_tick = tick()
        local best, min_d = nil, math.huge
        for _, o in ipairs(workspace:GetDescendants()) do
            local n = string.lower(o.Name)
            if n:find("heal") or n:find("health") or n:find("medkit") or n:find("bandage") or n:find("drop") then
                local p = o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")) or (o:IsA("BasePart") and o or nil)
                if p then local d=(p.Position-hrp.Position).Magnitude; if d<min_d and d<=config.autocollect_radius then min_d=d; best=p.Position end end
            end
        end
        if best then getgenv().safe_teleport(best) end
    end))
end
getgenv().stop_autocollect = function() killConn("autocollect") end

-- RETURN HOME / SAFE ZONE / TELEPORT LOOP --------------------------------
getgenv().start_return_home = function()
    killConn("return_home")
    local hrp_init = getgenv().get_hrp(localplayer)
    if not getgenv().home_position and hrp_init then getgenv().home_position = hrp_init.Position end
    local last_ret = 0
    bindConn("return_home", run_service.Heartbeat:Connect(function()
        if not config.return_home_enabled or not getgenv().home_position then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        if (hrp.Position - getgenv().home_position).Magnitude > 50 and (tick() - last_ret) >= config.home_return_delay then
            last_ret = tick(); getgenv().safe_teleport(getgenv().home_position)
        end
    end))
end
getgenv().stop_return_home = function() killConn("return_home") end

getgenv().start_safe_zone = function()
    killConn("safe_zone")
    bindConn("safe_zone", run_service.Heartbeat:Connect(function()
        if not config.safe_zone_enabled then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        if hrp.Position.Y < (config.safe_zone_y or -10) then
            local last = getgenv().home_position or Vector3.new(0, 10, 0)
            hrp.CFrame = CFrame.new(last.X, math.max(last.Y, 10), last.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        else getgenv().home_position = hrp.Position end
    end))
end
getgenv().stop_safe_zone = function() killConn("safe_zone") end

getgenv().start_teleport_loop = function()
    killConn("tp_loop")
    bindConn("tp_loop", run_service.Heartbeat:Connect(function()
        if not config.teleport_loop_enabled then return end
        if #getgenv().loop_waypoints == 0 then return end
        local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
        local wp = getgenv().loop_waypoints[getgenv().loop_index]
        if wp then hrp.CFrame = CFrame.new(wp); hrp.AssemblyLinearVelocity = Vector3.zero end
        getgenv().loop_index = (getgenv().loop_index % (#getgenv().loop_waypoints)) + 1
        task.wait(config.teleport_loop_delay or 0.5)
    end))
end
getgenv().stop_teleport_loop = function() killConn("tp_loop"); config.teleport_loop_enabled = false end

-- FFA SERVER HOP ----------------------------------------------------------
local last_hop_time = 0
local function get_random_hop() return 14 + math.random() * 13 end
local function is_server_good(server)
    if not server or not server.id or server.id == game.JobId then return false end
    if server.playing >= server.maxPlayers * 0.88 then return false end
    return true
end
local function server_hop()
    if not config.ffa_hopping_enabled then return end
    if tick() - last_hop_time < 8 then return end
    task.wait(0.7 + math.random() * 1.6)
    task.spawn(function()
        local ok, resp = pcall(function() return http_service:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100", true)) end)
        if not ok or not resp or not resp.data then return end
        local valid = {}
        for _, s in ipairs(resp.data) do if is_server_good(s) then table.insert(valid, s) end end
        if #valid == 0 then return end
        for i = #valid, 2, -1 do local j = math.random(i); valid[i], valid[j] = valid[j], valid[i] end
        local target = valid[math.random(1, math.min(6, #valid))]
        last_hop_time = tick(); task.wait(0.5 + math.random() * 1.3)
        pcall(function() teleport_service:TeleportToPlaceInstance(game.PlaceId, target.id, localplayer) end)
    end)
end
bindTask("ffa_loop", task.spawn(function()
    while true do
        task.wait(get_random_hop())
        if config.ffa_hopping_enabled then server_hop() end
    end
end))

-- MOD DETECTOR ------------------------------------------------------------
getgenv().start_mod_detector = function()
    killTask("mod_detector")
    bindTask("mod_detector", task.spawn(function()
        while config.mod_detector do
            for _, plr in ipairs(players:GetPlayers()) do
                if plr ~= localplayer then
                    pcall(function()
                        local tags = {"mod","admin","staff","owner","dev","developer","helper","support"}
                        local nm = plr.Name:lower()
                        for _, tag in ipairs(tags) do
                            if nm:find(tag) then notify("Staff Detected", plr.Name.." joined!"); pcall(function() teleport_service:Teleport(game.PlaceId) end); return end
                        end
                    end)
                end
            end
            task.wait(3)
        end
    end))
end
getgenv().stop_mod_detector = function() config.mod_detector = false; killTask("mod_detector") end

-- STARBORN FONT + DISPLAY ANGLES -----------------------------------------
getgenv().start_starborn = function()
    killConn("starborn")
    bindConn("starborn", run_service.RenderStepped:Connect(function()
        if not config.starborn_enabled then return end
        for _, g in ipairs(CoreGui:GetDescendants()) do
            if g:IsA("TextLabel") or g:IsA("TextButton") or g:IsA("TextBox") then pcall(function() g.Font = Enum.Font.Antique end) end
        end
    end))
end
getgenv().stop_starborn = function() config.starborn_enabled = false; killConn("starborn") end

local angle_gui
getgenv().start_display_angles = function()
    if angle_gui then angle_gui:Destroy() end
    killConn("display_angles")
    angle_gui = Instance.new("ScreenGui"); angle_gui.Name = "BodyCoordsGUI"
    pcall(function() angle_gui.Parent = CoreGui end)
    if not angle_gui.Parent then angle_gui.Parent = localplayer:WaitForChild("PlayerGui", 5) end
    local lbl = Instance.new("TextLabel", angle_gui)
    lbl.Size = UDim2.new(0, 260, 0, 90); lbl.Position = UDim2.new(0.5, -130, 0.05, 0)
    lbl.BackgroundColor3 = Color3.fromRGB(0,0,0); lbl.BackgroundTransparency = 0.5
    lbl.TextColor3 = Color3.fromRGB(0,255,150); lbl.Font = Enum.Font.RobotoMono; lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local pad = Instance.new("UIPadding", lbl); pad.PaddingLeft = UDim.new(0, 15)
    local crn = Instance.new("UICorner", lbl); crn.CornerRadius = UDim.new(0, 8)
    local function fmt(v) local f = string.format("%.1f", v); while true do local f2, k = string.gsub(f, "^(-?%d+)(%d%d%d)", "%1,%2"); f = f2; if k == 0 then break end end return f end
    bindConn("display_angles", run_service.RenderStepped:Connect(function()
        local hrp = getgenv().get_hrp(localplayer)
        if hrp then lbl.Text = string.format("X: %s\nY: %s\nZ: %s", fmt(hrp.Position.X), fmt(hrp.Position.Y), fmt(hrp.Position.Z))
        else lbl.Text = "X: --\nY: --\nZ: --" end
    end))
end
getgenv().stop_display_angles = function()
    killConn("display_angles")
    if angle_gui then angle_gui:Destroy(); angle_gui = nil end
end

-- NO MUZZLE FLASH ---------------------------------------------------------
getgenv().start_no_muzzle_flash = function()
    killConn("muzzle")
    bindConn("muzzle", run_service.RenderStepped:Connect(function()
        local vm = workspace:FindFirstChild("ViewModels")
        if vm then
            for _, child in ipairs(vm:GetDescendants()) do
                if child:IsA("ParticleEmitter") and child.Name == "ParticleEmiter" then child:Destroy() end
                if child:IsA("SpotLight") then child:Destroy() end
            end
        end
    end))
end
getgenv().stop_no_muzzle_flash = function() killConn("muzzle") end

-- RAPID FIRE + NO SPREAD + NO RECOIL -------------------------------------
local WeaponSettings = {
    ShootRecoil=0, ShootSpread=0, ProjectileSpeed=math.huge, ShootCooldown=0,
    QuickShotCooldown=0, ShootBurstCooldown=0, ShootExplosionRadius=0,
    AttackCooldown=0, Cooldown=0, DashCooldown=0, SpinCooldown=0, SpinSpeed=500, DeflectCooldown=0,
}
local rf_enabled = false
getgenv().start_rapid_fire = function()
    if rf_enabled then return end; rf_enabled = true
    task.spawn(function()
        pcall(function()
            local client_item = require(localplayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
            if not client_item then return end
            getgenv().old_input_func = hookfunction(client_item.Input, function(...)
                local args = {...}
                if (config.rapid_fire or config.no_spread or config.no_recoil or config.infinite_ammo)
                   and type(args[1]) == "table" and args[1].Info then
                    for k, v in pairs(WeaponSettings) do args[1].Info[k] = v end
                    if config.infinite_ammo and args[1].Info.Ammo ~= nil then args[1].Info.Ammo = 999 end
                end
                return getgenv().old_input_func(...)
            end)
        end)
    end)
end
getgenv().stop_rapid_fire = function()
    rf_enabled = false; config.rapid_fire = false
    if getgenv().old_input_func then
        pcall(function() require(localplayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem).Input = getgenv().old_input_func end)
        getgenv().old_input_func = nil
    end
end

local max_acc_hooked = false
local function hook_max_accuracy()
    if max_acc_hooked then return end; max_acc_hooked = true
    task.spawn(function()
        pcall(function()
            local util = require(ReplicatedStorage.Modules.GameplayUtility)
            if util and util.GetSpread then
                local orig = util.GetSpread
                util.GetSpread = function(s, am, ia, ic, pi, tp, c)
                    if config.no_spread or config.rage_bot_enabled or config.silent_aim then return CFrame.new() end
                    return orig(s, am, ia, ic, pi, tp, c)
                end
            end
        end)
        pcall(function()
            local gun = require(localplayer.PlayerScripts.Modules.ItemTypes.Gun)
            if gun and gun._Recoil then
                local orig = gun._Recoil
                gun._Recoil = function(self, mult)
                    if config.no_recoil or config.rage_bot_enabled then return end
                    return orig(self, mult)
                end
            end
        end)
    end)
end
hook_max_accuracy()
-- =========================================================================
-- RAGEBOT — targets, snaps, and fires the shoot remote
-- =========================================================================
local function get_hitbox_part(char)
    local hb = config.rage_hitbox; local part = nil
    if hb=="Head" then part=char:FindFirstChild("Head")
    elseif hb=="Upper torso" then part=char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    elseif hb=="HumanoidRootPart" then part=char:FindFirstChild("HumanoidRootPart")
    elseif hb=="Lower torso" then part=char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")
    elseif hb=="Right arm" then part=char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
    elseif hb=="Left arm" then part=char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
    elseif hb=="Right leg" then part=char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
    elseif hb=="Left leg" then part=char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") end
    return part or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function get_weapon_slot() if config.rage_weapon=="None" then return nil end return config.rage_weapon=="Primary" and 1 or 2 end

local function equip_slot()
    local f_ctrl = localplayer.PlayerScripts.Controllers:FindFirstChild("FighterController")
    if f_ctrl then
        local lf = require(f_ctrl).LocalFighter
        if lf then
            local w = get_weapon_slot(); if config.rage_type=="Normal" then w=3 end
            if w then
                pcall(function()
                    if lf.EquipItem then lf:EquipItem(w) end
                    if lf.SwitchToSlot then lf:SwitchToSlot(w) end
                end)
            end
        end
    end
end

-- bullet prediction -------------------------------------------------------
local predict_vel = Vector3.zero; local predict_lastpos = nil; local predict_lasttime = 0
bindConn("pred_hb", run_service.Heartbeat:Connect(function()
    if not config.prediction_enabled or not getgenv().rb_target then predict_vel = Vector3.zero; predict_lastpos = nil; return end
    local root = getgenv().rb_target.Character and getgenv().rb_target.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
    local now = tick(); local dt = now - predict_lasttime
    if dt > 0 and dt < 0.1 then
        local cur = root.Position
        if predict_lastpos then local inst = (cur - predict_lastpos) / dt; predict_vel = predict_vel:Lerp(inst, 0.6) end
        predict_lastpos = cur; predict_lasttime = now
    end
end))

local function predict_target(targetpart, origin)
    if not config.prediction_enabled or not targetpart then return targetpart and targetpart.Position or Vector3.zero end
    local dist = (targetpart.Position - origin).Magnitude
    local ping = localplayer:GetNetworkPing()
    return targetpart.Position + (predict_vel * ((dist / 3000 + ping) * (config.prediction_mult or 1.2)))
end

-- tp prediction -----------------------------------------------------------
local tp_pred_history = {}; local tp_pred_vel = Vector3.zero; local tp_pred_lasttime = 0; local tp_pred_lastpos = nil
bindConn("tp_pred_hb", run_service.Heartbeat:Connect(function()
    if not config.tp_prediction_enabled or not getgenv().rb_target then tp_pred_history = {}; tp_pred_vel = Vector3.zero; tp_pred_lastpos = nil; return end
    local root = getgenv().rb_target.Character and getgenv().rb_target.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
    local now = tick(); local dt = now - tp_pred_lasttime
    if dt > 0 and dt < 0.2 then
        local cur = root.Position
        if tp_pred_lastpos then
            local inst = (cur - tp_pred_lastpos) / dt
            if inst.Magnitude < 50000 then
                table.insert(tp_pred_history, inst)
                if #tp_pred_history > 16 then table.remove(tp_pred_history, 1) end
                local avg = Vector3.zero; local ws = 0
                for idx, v in ipairs(tp_pred_history) do local w = idx / #tp_pred_history; avg = avg + v * w; ws = ws + w end
                if ws > 0 then tp_pred_vel = avg / ws end
            end
        end
        tp_pred_lastpos = cur; tp_pred_lasttime = now
    end
end))
local function tp_predict_pos(t_hrp)
    if not config.tp_prediction_enabled or not t_hrp then return t_hrp and t_hrp.Position or Vector3.zero end
    local ping = localplayer:GetNetworkPing(); local str = config.tp_pred_strength or 1.0
    return t_hrp.Position + tp_pred_vel * ((ping * 4 + 0.05) * str)
end

-- shoot remote ------------------------------------------------------------
local function fire_autoshoot(t_head, t_char)
    task.spawn(function()
        pcall(function()
            local util = require(r_storage:WaitForChild("Modules", 2):WaitForChild("Utility", 2))
            local enums = require(r_storage:WaitForChild("Modules", 2):WaitForChild("EnumLibrary", 2))
            local f_ctrl = require(localplayer.PlayerScripts.Controllers:WaitForChild("FighterController", 2))
            if not util or not enums or not f_ctrl then return end
            if f_ctrl.LocalFighter and f_ctrl.LocalFighter.EquippedItem then
                local item = f_ctrl.LocalFighter.EquippedItem
                local cam_pos = workspace.CurrentCamera.CFrame.Position
                local atp = predict_target(t_head, cam_pos)
                local c_data = {}
                c_data[utf8.char(1)] = {
                    [utf8.char(0)] = util:EncodeCFrame(CFrame.lookAt(cam_pos, atp)),
                    [utf8.char(1)] = util:EncodeCFrame(CFrame.lookAt(cam_pos, atp)),
                    [utf8.char(2)] = t_head,
                    [utf8.char(3)] = util:EncodeCFrame(t_head.CFrame:ToObjectSpace(CFrame.new(atp))),
                }
                c_data.Hitbox = t_head.Name
                for _ = 1, (config.shoot_attempts or 1) do
                    r_storage.Remotes.Replication.Fighter.UseItem:FireServer(item:Get("ObjectID"), enums:ToEnum("StartShooting"), c_data, nil)
                end
            end
        end)
    end)
end
getgenv().fire_autoshoot = fire_autoshoot

-- SILENT AIM via remote: fires at silent target when the player shoots ---
local sa_hook_set = false
local function install_silent_aim_hook()
    if sa_hook_set then return end; sa_hook_set = true
    task.spawn(function()
        pcall(function()
            local ok, remotes = pcall(function() return r_storage.Remotes.Replication.Fighter.UseItem end)
            if not ok or not remotes then return end
            local orig = remotes.FireServer
            remotes.FireServer = function(self, item_id, enum, c_data, extra)
                if config.silent_aim and type(c_data) == "table" and c_data[utf8.char(1)] then
                    local t = getgenv().get_silent_target()
                    if t and t.part then
                        pcall(function()
                            local util = require(r_storage:WaitForChild("Modules", 2):WaitForChild("Utility", 2))
                            local cam_pos = workspace.CurrentCamera.CFrame.Position
                            local atp = t.part.Position
                            c_data[utf8.char(1)][utf8.char(0)] = util:EncodeCFrame(CFrame.lookAt(cam_pos, atp))
                            c_data[utf8.char(1)][utf8.char(1)] = util:EncodeCFrame(CFrame.lookAt(cam_pos, atp))
                            c_data[utf8.char(1)][utf8.char(2)] = t.part
                            c_data[utf8.char(1)][utf8.char(3)] = util:EncodeCFrame(t.part.CFrame:ToObjectSpace(CFrame.new(atp)))
                            c_data.Hitbox = t.part.Name
                        end)
                    end
                end
                return orig(self, item_id, enum, c_data, extra)
            end
        end)
    end)
end
install_silent_aim_hook()

-- rage loop ---------------------------------------------------------------
local rb_last_shot = 0
local function _vec3_finite(v)
    return v.X == v.X and v.Y == v.Y and v.Z == v.Z
        and math.abs(v.X) ~= math.huge and math.abs(v.Y) ~= math.huge and math.abs(v.Z) ~= math.huge
end

local function get_rage_offset(strat, t_hrp)
    local look = t_hrp.CFrame.LookVector
    if look.Magnitude < 0.001 then look = Vector3.new(0, 0, -1) end
    local offset = Vector3.zero; local wild = CFrame.Angles(0, 0, 0)
    if strat == "Orbit" then
        local spin_rad = tick() * (config.rage_orbit_speed or 500) / 100
        local radius = math.max(config.rage_tp_radius or 5, 1)
        local height = config.rage_tp_height or -4
        offset = Vector3.new(math.cos(spin_rad) * radius, height, math.sin(spin_rad) * radius)
        wild = CFrame.lookAt(Vector3.zero, Vector3.new(math.cos(spin_rad + math.pi), 0, math.sin(spin_rad + math.pi)))
    else
        local pos_mode = string.lower(config.rage_position or "inside")
        local pos_dist = config.rage_tp_radius or 2
        if pos_mode=="front" then offset = look * pos_dist
        elseif pos_mode=="behind" then offset = -look * pos_dist
        elseif pos_mode=="above" then offset = Vector3.new(0, math.abs(config.rage_tp_height or 15) + 5, 0)
        elseif pos_mode=="below" then offset = Vector3.new(0, -(math.abs(config.rage_tp_height or 4) + 2), 0) end
        local mode = config.rage_type or "Melee"
        if mode=="Gun" then offset = Vector3.new(0, math.max(config.rage_tp_height or 15, 5), 0)
        elseif mode=="Knife" then offset = -look * (config.knife_dist or 3) end
        if config.rage_spin then
            local t = tick()
            wild = CFrame.Angles(math.rad(1e70 * t * 1.0 % 360), math.rad(1e70 * t * 0.73 % 360), math.rad(1e70 * t * 0.41 % 360))
        end
    end
    return offset, wild
end

local function snap_to_target()
    if not config.rage_bot_enabled then return end
    local target = getgenv().get_rage_target(); getgenv().rb_target = target
    local hrp = getgenv().get_hrp(localplayer)
    if not (target and target.Character and hrp) then return end
    if localplayer.Team and target.Team and localplayer.Team == target.Team then return end
    local target_part = get_hitbox_part(target.Character)
    local t_hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not (target_part and t_hrp) then return end
    local hum = getgenv().get_hum(); if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end) end
    local strat = config.rage_strategy or "TP"
    local raw_base = config.tp_prediction_enabled and tp_predict_pos(t_hrp) or t_hrp.Position
    if not _vec3_finite(raw_base) then raw_base = t_hrp.Position end
    if not _vec3_finite(raw_base) then return end
    local offset, wild = get_rage_offset(strat, t_hrp)
    local dest = raw_base + offset
    if not _vec3_finite(dest) then dest = raw_base end
    if not _vec3_finite(dest) then return end
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.CFrame = CFrame.new(dest.X, dest.Y, dest.Z) * wild end)
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function snap_and_shoot()
    if not config.rage_bot_enabled then return end
    snap_to_target(); equip_slot()
    local target = getgenv().rb_target; if not (target and target.Character) then return end
    local target_part = get_hitbox_part(target.Character)
    local is_immune = target.Character:FindFirstChildOfClass("ForceField")
    if not target_part then return end
    local mode = config.rage_type or "Normal"
    if mode == "Knife" then workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, target_part.Position) end
    if mode ~= "Knife" and not is_immune and tick() - rb_last_shot > 0.05 then
        rb_last_shot = tick(); fire_autoshoot(target_part, target.Character)
    end
end

getgenv().__ragebot_start = function()
    bindRender("RageSnapPosition", Enum.RenderPriority.Camera.Value + 2, function()
        if not config.rage_bot_enabled then return end
        snap_to_target()
    end)
    bindRender("RageSnapShoot", Enum.RenderPriority.Camera.Value + 1, function()
        if not config.rage_bot_enabled then return end
        snap_and_shoot()
    end)
end
getgenv().__ragebot_stop = function()
    config.rage_bot_enabled = false
    killRender("RageSnapPosition"); killRender("RageSnapShoot")
    getgenv().rb_target = nil
end
-- =========================================================================
-- UI — Obsidian build: tabs, groupboxes, every toggle/slider/dropdown wired
-- =========================================================================
local _lib_ready = false
local library, ThemeManagerObs, SaveManagerObs
local _lib_load_start = tick()
task.spawn(function()
    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    local _ok1, _lib = pcall(function() return loadstring(game:HttpGet(repo .. "Library.lua"))() end)
    if not _ok1 or not _lib then notify("meowlua", "UI library failed"); _lib_ready = true; return end
    library = _lib
    local _ok2, _tm = pcall(function() return loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))() end)
    if _ok2 and _tm then ThemeManagerObs = _tm end
    local _ok3, _sm = pcall(function() return loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))() end)
    if _ok3 and _sm then SaveManagerObs = _sm end
    _lib_ready = true
end)
repeat task.wait(0.1) until _lib_ready or (tick() - _lib_load_start) > 30

getgenv().unload_all = function()
    getgenv().meowlua_loaded = false
    pcall(SBD.Disable, SBD); pcall(BulletTP.Disable, BulletTP)
    local stops = {
        "stop_fly","stop_pos_spam","stop_void_spam","stop_riot_abuser","stop_zigzag_abuser",
        "stop_evasion","stop_autocollect","stop_safe_zone","stop_return_home","stop_teleport_loop",
        "stop_map_orbit","__ragebot_stop","stop_strafebot","stop_rapid_fire","stop_anti_aim",
        "stop_no_muzzle_flash","stop_display_angles","stop_mod_detector","stop_starborn",
        "stop_anti_afk",
    }
    for _, k in ipairs(stops) do pcall(function() if getgenv()[k] then getgenv()[k]() end end) end
    if Movement then
        for _, k in ipairs({"stop_fly","stop_infjump","stop_walkspeed","stop_jumppower","stop_noclip","stop_godmode","stop_inf_stamina","stop_auto_heal","stop_instant_respawn","stop_click_tp","stop_freecam"}) do
            pcall(function() if Movement[k] then Movement[k]() end end)
        end
    end
    if Combat then
        for _, k in ipairs({"stop_hitbox_expand","stop_silent_aim_tracker","stop_aim_assist","stop_fov_circle","stop_auto_parry","stop_chat_spam"}) do
            pcall(function() if Combat[k] then Combat[k]() end end)
        end
    end
    if Visuals then
        for _, k in ipairs({"stop_esp","stop_chams","stop_fullbright"}) do
            pcall(function() if Visuals[k] then Visuals[k]() end end)
        end
    end
    config.ffa_hopping_enabled = false
    for name, _ in pairs(State.conns) do killConn(name) end
    for name, _ in pairs(State.tasks) do killTask(name) end
    for name, _ in pairs(State.binds) do killRender(name) end
    State.conns, State.tasks, State.binds = {}, {}, {}
    for _, c in ipairs(getgenv().all_connections) do pcall(function() c:Disconnect() end) end
    getgenv().all_connections = {}
    if library then pcall(function() library:Unload() end) end
end

-- panic key — hard kill
bindConn("panic", UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == (Enum.KeyCode[config.panic_key] or Enum.KeyCode.F8) then
        getgenv().unload_all(); notify("meowlua", "Panic unload")
    end
end))

if not library then
    notify("meowlua", "UI timed out. Logic still live.")
    -- always start the perma rails
    Movement.start_fly(); Movement.start_infjump(); Movement.start_walkspeed(); Movement.start_jumppower()
    Movement.start_noclip(); Movement.start_godmode(); Movement.start_inf_stamina(); Movement.start_auto_heal()
    Movement.start_instant_respawn(); Movement.start_click_tp()
    Combat.start_hitbox_expand(); Combat.start_silent_aim_tracker(); Combat.start_aim_assist()
    Combat.start_fov_circle(); Combat.start_auto_parry()
    Visuals.start_esp(); Visuals.start_chams(); Visuals.start_fullbright()
    return
end

-- window ------------------------------------------------------------------
local window = library:CreateWindow({
    Title = "meowlua",
    Center = true, AutoShow = true,
    Footer = "ultron tier | https://discord.gg/ojailbreaks",
})

local function tnotify(t, d) if d then library:Notify({ Title=t, Description=d, Time=3 }) else library:Notify({ Title=t, Time=3 }) end end
local function tgl(b, id, t, d, cb)
    local toggle = b:AddToggle(id, { Text=t, Default=false, Tooltip=d })
    toggle:OnChanged(function(v) if v then tnotify(t, d) end cb(v) end)
    toggle:AddKeyPicker(id.."_K", { Default="None", SyncToggleState=true, Mode="Toggle", Text=t })
    return toggle
end

local tab_rage     = window:AddTab("Rage",     "rbxassetid://98159911363596")
local tab_combat   = window:AddTab("Combat",   "rbxassetid://14195843928")
local tab_guns     = window:AddTab("Guns",     "rbxassetid://12403097620")
local tab_move     = window:AddTab("Movement", "rbxassetid://10709796389")
local tab_visuals  = window:AddTab("Visuals",  "rbxassetid://10734950309")
local tab_world    = window:AddTab("World",    "rbxassetid://10734971625")
local tab_player   = window:AddTab("Player",   "rbxassetid://10709810391")
local tab_misc     = window:AddTab("Misc",     "rbxassetid://10455604811")
local tab_voidspam = window:AddTab("Void",     "rbxassetid://10455603612")
local tab_settings = window:AddTab("Settings", "rbxassetid://11888734334")

-- RAGE --------------------------------------------------------------------
local rb_rage = tab_rage:AddLeftGroupbox("Ragebot")
tgl(rb_rage, "rb_etg", "Ragebot", "Snaps and fires at the chosen target.", function(v) config.rage_bot_enabled = v; if v then getgenv().__ragebot_start() else getgenv().__ragebot_stop() end end)
rb_rage:AddDropdown("r_typ",   { Text="Attack Mode",      Default=1, Values={"Melee","Gun","Knife"} }):OnChanged(function(v) config.rage_type=v end)
rb_rage:AddDropdown("r_strat", { Text="Ragebot Strategy", Default=2, Values={"Orbit","TP"} }):OnChanged(function(v) config.rage_strategy=v end)
rb_rage:AddDropdown("r_wep",   { Text="Weapon",           Default=1, Values={"None","Primary","Secondary"} }):OnChanged(function(v) config.rage_weapon=v end)
rb_rage:AddDropdown("r_box",   { Text="Targeting",        Default=1, Values={"Head","Upper torso","HumanoidRootPart","Lower torso","Right arm","Left arm","Right leg","Left leg"} }):OnChanged(function(v) config.rage_hitbox=v end)
rb_rage:AddDropdown("r_pos",   { Text="Position",         Default=5, Values={"Front","Behind","Above","Below","Inside"} }):OnChanged(function(v) config.rage_position=v end)

local function updatePlayerList()
    local list = {""}
    for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(list, p.Name) end end
    return list
end
local prio_drop = rb_rage:AddDropdown("r_prio", { Text="Priority", Default=1, Values=updatePlayerList() })
prio_drop:OnChanged(function(v) config.rage_priority=v end)
players.PlayerAdded:Connect(function() prio_drop:SetValues(updatePlayerList()) end)
players.PlayerRemoving:Connect(function() prio_drop:SetValues(updatePlayerList()) end)
rb_rage:AddSlider("s_att",     { Text="Shoot Attempts",       Default=1,   Min=1,   Max=3,   Rounding=0 }):OnChanged(function(v) config.shoot_attempts=v end)
tgl(rb_rage, "pred_e",    "Bullet Prediction",   "Lead at fast targets.", function(v) config.prediction_enabled=v end)
rb_rage:AddSlider("pred_m",  { Text="Prediction Multiplier", Default=1.2, Min=0.1, Max=3.0, Rounding=1 }):OnChanged(function(v) config.prediction_mult=v end)
tgl(rb_rage, "tp_pred_e", "Teleport Prediction", "Lead the snap, not the shot.", function(v) config.tp_prediction_enabled=v end)
rb_rage:AddSlider("tp_pred_s", { Text="Prediction Strength", Default=1.0, Min=0.1, Max=5.0, Rounding=1 }):OnChanged(function(v) config.tp_pred_strength=v end)

local rb_sliders = tab_rage:AddLeftGroupbox("Ragebot Adjustments")
rb_sliders:AddSlider("rb_tp_rad", { Text="TP Radius",             Default=2,   Min=0,    Max=100,  Rounding=1 }):OnChanged(function(v) config.rage_tp_radius=v end)
rb_sliders:AddSlider("rb_tp_h",   { Text="TP Height",             Default=-4,  Min=-100, Max=100,  Rounding=1 }):OnChanged(function(v) config.rage_tp_height=v end)
rb_sliders:AddSlider("ro_spd",    { Text="Orbit Speed",           Default=500, Min=10,   Max=5000, Rounding=0 }):OnChanged(function(v) config.rage_orbit_speed=v end)
rb_sliders:AddSlider("kr_d",      { Text="Knife Distance Behind", Default=3,   Min=1,    Max=10,   Rounding=0 }):OnChanged(function(v) config.knife_dist=v end)
tgl(rb_sliders, "r_spin", "Spin", "Insane angular velocity.", function(v) config.rage_spin=v end)

local box_evasion = tab_rage:AddRightGroupbox("Evasion")
tgl(box_evasion, "ev_e", "Evasion", "Pattern-driven teleport burst.", function(v) config.evasion_enabled=v; if v then getgenv().start_evasion() else getgenv().stop_evasion() end end)
box_evasion:AddDropdown("ev_mode", { Text="Evasion Mode", Default=1, Values=getgenv()._shapes_evasion_list }):OnChanged(function(v) config.evasion_mode=v end)
box_evasion:AddSlider("ev_burst", { Text="Burst Count", Default=500, Min=100, Max=1000, Rounding=0 }):OnChanged(function(v) config.evasion_burst=v end)
box_evasion:AddSlider("ev_int",   { Text="Interval",    Default=1,   Min=1,   Max=1000, Rounding=0 }):OnChanged(function(v) config.evasion_interval=v end)
box_evasion:AddSlider("ev_spn",   { Text="Spin Speed",  Default=9999,Min=0,   Max=999999,Rounding=0 }):OnChanged(function(v) config.evasion_spin_speed=v end)

local box_anti_aim = tab_rage:AddRightGroupbox("Anti Aim")
tgl(box_anti_aim, "aa_e", "Anti Aim", "Scrambles orientation.", function(v) config.anti_aim_enabled=v; if v then getgenv().start_anti_aim() else getgenv().stop_anti_aim() end end)
box_anti_aim:AddDropdown("aa_meth", { Text="Method", Default=2, Values={"Pixelated","Static","Spin","Jitter","Desync","Sway","Breaker","Lurk","Orbit","Custom"} }):OnChanged(function(v) config.aa_method=v end)
box_anti_aim:AddSlider("aa_pxs", { Text="Pixelation Scale", Default=0,   Min=0,   Max=100,    Rounding=0 }):OnChanged(function(v) config.aa_pixel_scale=v end)
box_anti_aim:AddSlider("aa_spn", { Text="Spin Speed",       Default=9999,Min=100, Max=999999, Rounding=0 }):OnChanged(function(v) config.aa_spin_speed=v end)
box_anti_aim:AddSlider("aa_yaw", { Text="Yaw",              Default=0,   Min=-360,Max=360,    Rounding=0 }):OnChanged(function(v) config.aa_yaw=v end)
box_anti_aim:AddSlider("aa_pit", { Text="Pitch",            Default=0,   Min=-360,Max=360,    Rounding=0 }):OnChanged(function(v) config.aa_pitch=v end)
box_anti_aim:AddSlider("aa_rol", { Text="Roll",             Default=0,   Min=-360,Max=360,    Rounding=0 }):OnChanged(function(v) config.aa_roll=v end)

-- COMBAT ------------------------------------------------------------------
local box_silent = tab_combat:AddLeftGroupbox("Silent Aim")
tgl(box_silent, "sa_e", "Silent Aim", "Bends shot remote to closest-in-FOV.", function(v) config.silent_aim=v; if v then Combat.start_silent_aim_tracker() else Combat.stop_silent_aim_tracker() end end)
box_silent:AddSlider("sa_fov",  { Text="FOV (px)", Default=120, Min=10,  Max=800, Rounding=0 }):OnChanged(function(v) config.silent_aim_fov=v end)
box_silent:AddDropdown("sa_hit",{ Text="Hitbox",   Default=1,  Values={"Head","HumanoidRootPart","UpperTorso","Torso"} }):OnChanged(function(v) config.silent_aim_hitbox=v end)

local box_assist = tab_combat:AddLeftGroupbox("Aim Assist")
tgl(box_assist, "aa_ast", "Aim Assist", "Smooth camera at closest while right-click held.", function(v) config.aim_assist=v; if v then Combat.start_aim_assist(); Combat.start_silent_aim_tracker() else Combat.stop_aim_assist() end end)
box_assist:AddSlider("aa_fov",   { Text="FOV (px)",  Default=90, Min=10, Max=800, Rounding=0 }):OnChanged(function(v) config.aim_assist_fov=v end)
box_assist:AddSlider("aa_smth",  { Text="Smoothness",Default=6,  Min=1,  Max=30,  Rounding=0 }):OnChanged(function(v) config.aim_assist_smooth=v end)

local box_hit = tab_combat:AddRightGroupbox("Hitbox Expand")
tgl(box_hit, "hit_e", "Hitbox Expand", "Grows enemy aim part for easier hits.", function(v) config.hitbox_expand=v; if v then Combat.start_hitbox_expand() else Combat.stop_hitbox_expand() end end)
box_hit:AddSlider("hit_s",  { Text="Size",   Default=15, Min=2,  Max=60, Rounding=0 }):OnChanged(function(v) config.hitbox_size=v end)
box_hit:AddDropdown("hit_t",{ Text="Target", Default=1, Values={"Head","HumanoidRootPart","UpperTorso","Torso"} }):OnChanged(function(v) config.hitbox_target=v end)

local box_fov = tab_combat:AddRightGroupbox("FOV Circle")
tgl(box_fov, "fov_e", "FOV Circle", "Visual FOV reference on screen.", function(v) config.fov_circle=v; if v then Combat.start_fov_circle() else Combat.stop_fov_circle() end end)
box_fov:AddSlider("fov_r", { Text="Radius", Default=120, Min=20, Max=800, Rounding=0 }):OnChanged(function(v) config.fov_circle_radius=v end)
pcall(function() box_fov:AddLabel("Color"):AddColorPicker("fov_col", { Default=Color3.fromRGB(255,255,255), Title="Color" }):OnChanged(function(v) config.fov_circle_color=v end) end)

local box_parry = tab_combat:AddRightGroupbox("Auto Parry")
tgl(box_parry, "parry_e", "Auto Parry", "Triggers parry on incoming dagger/projectile.", function(v) config.dagger_bypass=v; if v then Combat.start_auto_parry() else Combat.stop_auto_parry() end end)

-- GUNS --------------------------------------------------------------------
local gun_box = tab_guns:AddLeftGroupbox("Gun Mods")
tgl(gun_box, "no_spread", "No Spread",       "Removes bullet spread.",  function(v) config.no_spread=v; if v then getgenv().start_rapid_fire() end end)
tgl(gun_box, "no_recoil", "No Recoil",       "Removes weapon recoil.",  function(v) config.no_recoil=v; if v then getgenv().start_rapid_fire() end end)
tgl(gun_box, "no_muzzle", "No Muzzle Flash", "Strips muzzle FX.",       function(v) config.no_muzzle_flash=v; if v then getgenv().start_no_muzzle_flash() else getgenv().stop_no_muzzle_flash() end end)
tgl(gun_box, "rf",        "Rapid Fire",      "Zeroes cooldown values.", function(v) config.rapid_fire=v; if v then getgenv().start_rapid_fire() else getgenv().stop_rapid_fire() end end)
tgl(gun_box, "inf_ammo",  "Infinite Ammo",   "Keeps ammo pinned high.", function(v) config.infinite_ammo=v; if v then getgenv().start_rapid_fire() end end)

local sbd_box = tab_guns:AddRightGroupbox("SBD Projectile Bypass")
tgl(sbd_box, "sbd_e", "SBD Bypass", "Hooks remotes, extends ray, TP projectiles.", function(v) config.sbd_enabled=v; if v then SBD:Enable() else SBD:Disable() end end)
tgl(sbd_box, "sbd_ir","Infinite Range",      "Ray reaches past the map.",     function(v) config.sbd_infinite_range=v end)
tgl(sbd_box, "sbd_tp","TP Projectiles",      "Projectiles seek enemies.",     function(v) config.sbd_teleport_projectiles=v end)
tgl(sbd_box, "sbd_hs","Heat Seeking",        "Redirect at fire time.",        function(v) config.sbd_heat_seeking=v end)
tgl(sbd_box, "sbd_rf","Rapid Burst",         "Fire remote 5x per shot.",      function(v) config.sbd_rapid_fire=v end)
tgl(sbd_box, "sbd_ik","Instant Kill",        "Damage call on hit.",           function(v) config.sbd_instant_kill=v end)
sbd_box:AddSlider("sbd_mult", { Text="Damage Mult", Default=100, Min=1, Max=1000, Rounding=0 }):OnChanged(function(v) config.sbd_damage_mult=v end)

local btp_box = tab_guns:AddRightGroupbox("Bullet TP")
tgl(btp_box, "btp_e", "Bullet TP", "Teleports projectiles to target head.", function(v) config.bullet_tp_enabled=v; if v then BulletTP:Enable() else BulletTP:Disable() end end)
btp_box:AddSlider("btp_rad",  { Text="Radius",   Default=5000, Min=100, Max=20000, Rounding=0 }):OnChanged(function(v) config.bullet_tp_radius=v end)
btp_box:AddSlider("btp_att",  { Text="Attempts", Default=10,   Min=1,   Max=50,    Rounding=0 }):OnChanged(function(v) config.bullet_tp_attempts=v end)
tgl(btp_box, "btp_hs", "Headshot Only", "Lock on head not root.", function(v) config.bullet_tp_headshot=v end)

-- MOVEMENT ----------------------------------------------------------------
local mv = tab_move:AddLeftGroupbox("Movement")
tgl(mv, "fly_e", "Fly",             "WASD/Space/Ctrl in camera direction.",     function(v) config.fly_enabled=v; if v then Movement.start_fly() else Movement.stop_fly() end end)
mv:AddSlider("fly_s", { Text="Fly Speed", Default=80, Min=10, Max=400, Rounding=0 }):OnChanged(function(v) config.fly_speed=v end)
tgl(mv, "ij_e",  "Infinite Jump",   "Jump request always fires.",                function(v) config.infinite_jump=v; if v then Movement.start_infjump() else Movement.stop_infjump() end end)
tgl(mv, "ws_e",  "WalkSpeed Lock",  "Pins humanoid walkspeed to slider.",        function(v) config.walkspeed_enabled=v; if v then Movement.start_walkspeed() else Movement.stop_walkspeed() end end)
mv:AddSlider("ws_v", { Text="WalkSpeed", Default=16, Min=16, Max=400, Rounding=0 }):OnChanged(function(v) config.walkspeed=v end)
tgl(mv, "jp_e",  "JumpPower Lock",  "Pins humanoid jump power.",                 function(v) config.jumppower_enabled=v; if v then Movement.start_jumppower() else Movement.stop_jumppower() end end)
mv:AddSlider("jp_v", { Text="JumpPower", Default=50, Min=50, Max=500, Rounding=0 }):OnChanged(function(v) config.jumppower=v end)
tgl(mv, "nc_e",  "NoClip",          "Disables collisions on your character.",    function(v) config.noclip=v; if v then Movement.start_noclip() else Movement.stop_noclip() end end)
tgl(mv, "stam_e","Infinite Stamina","Keeps stamina attribute pinned.",           function(v) config.infinite_stamina=v; if v then Movement.start_inf_stamina() else Movement.stop_inf_stamina() end end)
tgl(mv, "ctp_e", "Click TP",        "Left click → teleport to crosshair.",       function(v) config.click_tp_enabled=v; if v then Movement.start_click_tp() else Movement.stop_click_tp() end end)
tgl(mv, "fc_e",  "Freecam",         "Detaches camera for scouting.",             function(v) config.freecam_enabled=v; if v then Movement.start_freecam() else Movement.stop_freecam() end end)
mv:AddSlider("fc_s", { Text="Freecam Speed", Default=60, Min=5, Max=400, Rounding=0 }):OnChanged(function(v) config.freecam_speed=v end)

local mv2 = tab_move:AddRightGroupbox("Position Abusers")
tgl(mv2, "ps_e", "Position Spam",  "Teleport your root through deep-space Y.",  function(v) config.pos_spam_enabled=v; if v then getgenv().start_pos_spam() else getgenv().stop_pos_spam() end end)
tgl(mv2, "mo_e", "Map Orbit",      "Whips the root around the map bounds.",    function(v) config.map_orbit_enabled=v; if v then getgenv().start_map_orbit() else getgenv().stop_map_orbit() end end)
tgl(mv2, "sb_e", "Strafebot",      "Orbit nearest target like a crab.",         function(v) config.strafebot_enabled=v; if v then getgenv().start_strafebot() else getgenv().stop_strafebot() end end)
mv2:AddSlider("sb_s",{ Text="Strafe Speed",  Default=150, Min=10, Max=1000, Rounding=0 }):OnChanged(function(v) config.strafe_speed=v end)
mv2:AddSlider("sb_r",{ Text="Strafe Radius", Default=20,  Min=5,  Max=100,  Rounding=0 }):OnChanged(function(v) config.strafe_radius=v end)
tgl(mv2, "zz_e", "Zigzag Abuser",  "Sawtooth around the enemy.",                function(v) config.zigzag_enabled=v; if v then getgenv().start_zigzag_abuser() else getgenv().stop_zigzag_abuser() end end)

local mv3 = tab_move:AddRightGroupbox("Riot Abuser")
tgl(mv3, "ra_e",  "Riot Abuser", "Spin and jitter to break riot aim.", function(v) config.riot_abuser_enabled=v; if v then getgenv().start_riot_abuser() else getgenv().stop_riot_abuser() end end)
mv3:AddSlider("ra_d", { Text="Distance",   Default=500,             Min=100, Max=2000,          Rounding=0 }):OnChanged(function(v) config.riot_abuser_distance=v end)
mv3:AddSlider("ra_x", { Text="X Jitter",   Default=50,              Min=1,   Max=500,           Rounding=0 }):OnChanged(function(v) config.riot_abuser_x=v end)
mv3:AddSlider("ra_y", { Text="Y Jitter",   Default=15,              Min=1,   Max=200,           Rounding=0 }):OnChanged(function(v) config.riot_abuser_y=v end)
mv3:AddSlider("ra_z", { Text="Z Jitter",   Default=50,              Min=1,   Max=500,           Rounding=0 }):OnChanged(function(v) config.riot_abuser_z=v end)
mv3:AddSlider("ra_sp",{ Text="Spin Speed", Default=1000000000000,   Min=0,   Max=1000000000000, Rounding=0 }):OnChanged(function(v) config.riot_abuser_spin=v end)

-- VISUALS -----------------------------------------------------------------
local es = tab_visuals:AddLeftGroupbox("ESP")
tgl(es, "esp_box",  "Boxes",     "2D box around each enemy.",   function(v) config.esp_boxes=v; Visuals.start_esp() end)
tgl(es, "esp_nam",  "Names",     "Draw player names.",          function(v) config.esp_names=v; Visuals.start_esp() end)
tgl(es, "esp_hp",   "Health",    "Draw health text.",           function(v) config.esp_health=v; Visuals.start_esp() end)
tgl(es, "esp_dst",  "Distance",  "Draw studs distance.",        function(v) config.esp_distance=v; Visuals.start_esp() end)
tgl(es, "esp_tr",   "Tracers",   "Line from bottom to enemy.",  function(v) config.esp_tracers=v; Visuals.start_esp() end)
tgl(es, "esp_eo",   "Enemy Only","Skip teammates.",             function(v) config.esp_enemy_only=v end)
tgl(es, "esp_tc",   "Team Color","Use the player's team color.",function(v) config.esp_team_color=v end)
pcall(function() es:AddLabel("Box Color"):AddColorPicker("esp_col", { Default=Color3.fromRGB(0,255,180), Title="Box Color" }):OnChanged(function(v) config.esp_box_color=v end) end)

local ch = tab_visuals:AddLeftGroupbox("Chams")
tgl(ch, "ch_e", "Chams", "Highlight each enemy.", function(v) config.chams_enabled=v; if v then Visuals.start_chams() else Visuals.stop_chams() end end)
tgl(ch, "ch_w", "Through Walls", "Draw on top.", function(v) config.chams_wall=v end)
pcall(function() ch:AddLabel("Fill"):AddColorPicker("ch_fill", { Default=Color3.fromRGB(0,255,180), Title="Fill" }):OnChanged(function(v) config.chams_fill=v end) end)
pcall(function() ch:AddLabel("Outline"):AddColorPicker("ch_out",  { Default=Color3.fromRGB(0,0,0),     Title="Outline" }):OnChanged(function(v) config.chams_outline=v end) end)

local vf = tab_visuals:AddRightGroupbox("World FX")
tgl(vf, "fb_e", "Fullbright",  "Ambient and brightness pinned high.", function(v) config.fullbright=v; if v then Visuals.start_fullbright() else Visuals.stop_fullbright() end end)
vf:AddSlider("fb_v", { Text="Brightness", Default=2, Min=1, Max=10, Rounding=0 }):OnChanged(function(v) config.fb_brightness=v end)
tgl(vf, "lg_e", "Low GFX",     "Disable particles/post effects.",     function(v) config.low_gfx=v; Visuals.apply_low_gfx(v) end)

local snap = tab_visuals:AddRightGroupbox("Snaplines")
tgl(snap, "sl_e", "Snaplines", "Line from bottom of screen to each enemy.", function(v) config.snaplines=v; config.esp_tracers = v; Visuals.start_esp() end)
pcall(function() snap:AddLabel("Line Color"):AddColorPicker("sl_c", { Default=Color3.fromRGB(0,255,180), Title="Line Color" }):OnChanged(function(v) config.snapline_color=v end) end)

-- WORLD -------------------------------------------------------------------
local wf = tab_world:AddLeftGroupbox("Lighting / Atmo")
wf:AddButton({ Text="Strip Fog",     Func=function() pcall(function() for _,l in ipairs(Lighting:GetChildren()) do if l:IsA("Atmosphere") then l:Destroy() end end Lighting.FogEnd=1e10 end); tnotify("World","Fog stripped") end })
wf:AddButton({ Text="Day",           Func=function() pcall(function() Lighting.ClockTime=14 end) end })
wf:AddButton({ Text="Night",         Func=function() pcall(function() Lighting.ClockTime=0  end) end })
wf:AddButton({ Text="Kill Shadows",  Func=function() pcall(function() Lighting.GlobalShadows=false end) end })

-- PLAYER ------------------------------------------------------------------
local pl = tab_player:AddLeftGroupbox("Local")
tgl(pl, "god",   "Godmode",         "Pins health high.",                     function(v) config.godmode=v; if v then Movement.start_godmode(); Movement.start_auto_heal() else Movement.stop_godmode(); Movement.stop_auto_heal() end end)
tgl(pl, "resp",  "Instant Respawn", "LoadCharacter on death.",               function(v) config.instant_respawn=v; if v then Movement.start_instant_respawn() else Movement.stop_instant_respawn() end end)
tgl(pl, "akick", "Anti Kick",       "Swallow :Kick calls on LocalPlayer.",   function(v) config.anti_kick=v end)
tgl(pl, "ang_e", "Show Coords",     "HUD block with your X/Y/Z.",            function(v) config.display_angles=v; if v then getgenv().start_display_angles() else getgenv().stop_display_angles() end end)

local pl2 = tab_player:AddRightGroupbox("Target")
pl2:AddButton({ Text="Goto Closest Enemy", Func=function()
    local t = getgenv().get_closest(true); if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        getgenv().safe_teleport(t.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)); tnotify("Player","Teleported")
    end
end })
pl2:AddButton({ Text="Save Home Position", Func=function()
    local hrp = getgenv().get_hrp(localplayer); if hrp then getgenv().home_position = hrp.Position; tnotify("Player","Home saved") end
end })
pl2:AddButton({ Text="Return to Home", Func=function() if getgenv().home_position then getgenv().safe_teleport(getgenv().home_position) end end })

-- MISC --------------------------------------------------------------------
local mx = tab_misc:AddLeftGroupbox("Customization")
tgl(mx, "md",  "Staff Detector", "Rejoin if staff joins.",             function(v) config.mod_detector=v; if v then getgenv().start_mod_detector() else getgenv().stop_mod_detector() end end)
tgl(mx, "f_s", "Starborn Font",  "Change all GUI text font.",          function(v) config.starborn_enabled=v; if v then getgenv().start_starborn() else getgenv().stop_starborn() end end)
tgl(mx, "chat","Chat Spam",      "Repeats a message in chat.",         function(v) config.chat_spam_enabled=v; if v then Combat.start_chat_spam() else Combat.stop_chat_spam() end end)
pcall(function() mx:AddInput("chat_text", { Default="meowlua rivals", Text="Chat Line", Numeric=false, Finished=false, Placeholder="Chat line" }):OnChanged(function(v) config.chat_spam_text=v end) end)
mx:AddSlider("chat_d",   { Text="Chat Delay", Default=15, Min=5, Max=300, Rounding=0 }):OnChanged(function(v) config.chat_spam_delay=v/10 end)

local mx2 = tab_misc:AddLeftGroupbox("Automation")
tgl(mx2, "ac_e", "Auto Collect",     "TP to pickups within radius.", function(v) config.autocollect_enabled=v; if v then getgenv().start_autocollect() else getgenv().stop_autocollect() end end)
mx2:AddSlider("ac_r", { Text="Collect Radius", Default=120, Min=10, Max=300, Rounding=0 }):OnChanged(function(v) config.autocollect_radius=v end)
tgl(mx2, "sz_e", "Safe Zone Rescue", "Rescue from a fall.",          function(v) config.safe_zone_enabled=v; if v then getgenv().start_safe_zone() else getgenv().stop_safe_zone() end end)
mx2:AddSlider("sz_y", { Text="Depth Threshold", Default=-10, Min=-200, Max=50, Rounding=0 }):OnChanged(function(v) config.safe_zone_y=v end)
tgl(mx2, "rh_e", "Return Home",      "Snap back if you drift far.",  function(v) config.return_home_enabled=v; if v then getgenv().start_return_home() else getgenv().stop_return_home() end end)
mx2:AddSlider("rh_d", { Text="Return Delay (x0.1s)", Default=10, Min=1, Max=150, Rounding=0 }):OnChanged(function(v) config.home_return_delay=v/10 end)
tgl(mx2, "afk", "Anti AFK",           "Fake input every idle.",      function(v) config.anti_afk_enabled=v; if v then getgenv().start_anti_afk() else getgenv().stop_anti_afk() end end)
tgl(mx2, "ffa", "FFA Server Hopping", "Hop to fresh servers.",       function(v) config.ffa_hopping_enabled=v end)

local mx3 = tab_misc:AddRightGroupbox("Teleport Loop")
tgl(mx3, "tl_e", "Teleport Loop", "Cycle saved waypoints.", function(v) config.teleport_loop_enabled=v; if v then getgenv().start_teleport_loop() else getgenv().stop_teleport_loop() end end)
mx3:AddSlider("tl_d", { Text="Loop Delay (x0.01s)", Default=50, Min=10, Max=1000, Rounding=0 }):OnChanged(function(v) config.teleport_loop_delay=v/100 end)
mx3:AddButton({ Text="Add Waypoint",    Func=function() local hrp = getgenv().get_hrp(localplayer); if hrp then table.insert(getgenv().loop_waypoints, hrp.Position); tnotify("Loop","Waypoint added") end end })
mx3:AddButton({ Text="Clear Waypoints", Func=function() getgenv().loop_waypoints={}; getgenv().loop_index=1; tnotify("Loop","Cleared") end })

-- VOID --------------------------------------------------------------------
local box_vs = tab_voidspam:AddLeftGroupbox("Void Teleport")
tgl(box_vs, "vs_e", "Voidspam", "Fast burst teleport.", function(v) config.void_spam_enabled=v; if v then getgenv().start_void_spam() else getgenv().stop_void_spam() end end)
box_vs:AddDropdown("et_mod", { Text="Voidspam Type", Default=1, Values={"Random","Camera","Forward","Directional"} }):OnChanged(function(v) config.et_mode=v end)
box_vs:AddDropdown("et_ord", { Text="Burst Pattern", Default=1, Values=getgenv()._shapes_void_list }):OnChanged(function(v) config.et_order=v end)
box_vs:AddSlider("et_spd",   { Text="Interval",      Default=10000000, Min=0, Max=10000000, Rounding=0 }):OnChanged(function(v) config.et_speed=v end)
box_vs:AddSlider("et_tot",   { Text="Burst Count",   Default=500,      Min=1, Max=500,      Rounding=0 }):OnChanged(function(v) config.et_total=v end)

local box_vs_dir = tab_voidspam:AddLeftGroupbox("Directions")
box_vs_dir:AddSlider("vs_min", { Text="Min Distance", Default=0,     Min=0,  Max=50000,  Rounding=3 }):OnChanged(function(v) config.vs_min_dist=v*1e25 end)
box_vs_dir:AddSlider("vs_max", { Text="Max Distance", Default=50000, Min=10, Max=500000, Rounding=0 }):OnChanged(function(v) config.vs_max_dist=v end)
for _, k in ipairs({"xp","xn","yp","yn","zp","zn"}) do
    box_vs_dir:AddSlider("vs_"..k, { Text=k:upper(), Default=5000, Min=0, Max=50000, Rounding=0 }):OnChanged(function(v) config["vs_"..k]=v end)
end

local box_vp = tab_voidspam:AddRightGroupbox("Directional Patterns")
box_vp:AddDropdown("vp_d", { Text="Pattern", Default=1, Values=getgenv()._shapes_void_pattern_list }):OnChanged(function(v) config.void_pattern=v end)
tgl(box_vp, "vp_x", "Axis X", "Enable X axis.", function(v) config.void_axis_x=v end)
tgl(box_vp, "vp_y", "Axis Y", "Enable Y axis.", function(v) config.void_axis_y=v end)
tgl(box_vp, "vp_z", "Axis Z", "Enable Z axis.", function(v) config.void_axis_z=v end)

-- SETTINGS ----------------------------------------------------------------
local box_settings = tab_settings:AddLeftGroupbox("Settings")
box_settings:AddButton({ Text="Panic Unload (F8)", Func=function() getgenv().unload_all() end })
box_settings:AddButton({ Text="Display Keybinds",  Func=function() library:SetKeybindMenuOpen(true) end })

local box_theme = tab_settings:AddRightGroupbox("Themes")
if ThemeManagerObs then
    ThemeManagerObs:SetLibrary(library); ThemeManagerObs:SetFolder("meowlua themes"); ThemeManagerObs:ApplyToTab(tab_settings)
end
if SaveManagerObs then
    SaveManagerObs:SetLibrary(library); SaveManagerObs:IgnoreThemeSettings()
    SaveManagerObs:SetIgnoreIndexes({ "MenuKeybind" }); SaveManagerObs:SetFolder("meowlua/configs")
    SaveManagerObs:BuildConfigSection(tab_settings)
end

-- export handles for rivals patch chunk
getgenv().meow_lib         = library
getgenv().meow_window      = window
getgenv().meow_tab_rage    = tab_rage
getgenv().meow_tab_combat  = tab_combat
getgenv().meow_tab_guns    = tab_guns
getgenv().meow_tab_move    = tab_move
getgenv().meow_tab_visuals = tab_visuals
getgenv().meow_tab_world   = tab_world
getgenv().meow_tab_player  = tab_player
getgenv().meow_tab_misc    = tab_misc
getgenv().meow_tgl         = tgl
getgenv().meow_tnotify     = tnotify

-- autoload ---------------------------------------------------------------
local function handle_autoload()
    local cfgs = getgenv().list_cfgs()
    for _, c in ipairs(cfgs) do
        local path = "meowlua_configs/" .. c .. ".json"
        local ok, raw = pcall(readfile, path)
        if ok and raw then
            local s, d = pcall(function() return http_service:JSONDecode(raw) end)
            if s and d and d.AutoLoadConfig and d.LastLoadedConfig then
                if getgenv().load_cfg(d.LastLoadedConfig) then tnotify("Config", "Autoloaded: "..d.LastLoadedConfig); return end
            end
        end
    end
end
pcall(handle_autoload)

-- bootstrap perma rails that don't need toggling to prove they live
Combat.start_silent_aim_tracker()
Visuals.start_esp()

tnotify("meowlua", "ultron tier loaded")
-- =========================================================================
-- RIVALS PATCH — hard anticheat, true-working godmode, silent aim raycast
-- bend, triggerbot, IsFullyAiming lie, aimbot, stats HUD + counters
-- =========================================================================

-- extra config flags
for k, v in pairs({
    godmode_v2 = false, godmode_depth = 25, godmode_grace = 0.08,
    silent_aim_hard = false, triggerbot = false, triggerbot_delay = 0.05, triggerbot_range = 2500,
    aimbot = false, aimbot_fov = 180, aimbot_smooth = 1, aimbot_closest = false,
    gun_mods_hard = false, fully_aiming_lie = false,
    anti_katana = false, anti_riot = false,
    stats_hud = true,
    rawlen_shield = true, name_spoof = true,
}) do if config[k] == nil then config[k] = v end end

-- =========================================================================
-- COUNTERS — every meter the other sheets brag about
-- =========================================================================
getgenv().Stats = getgenv().Stats or {
    shots_bent     = 0,  -- silent aim rewrites
    projectiles_tp = 0,  -- bullet tp
    bullets_hijack = 0,  -- SBD remote hijacks
    kills_claimed  = 0,
    damage_dealt   = 0,
    void_ticks     = 0,
    evasion_bursts = 0,
    rage_shots     = 0,
    triggerbot_shots = 0,
    aimbot_locks   = 0,
    god_saves      = 0,
    chat_spams     = 0,
    parries_fired  = 0,
    session_start  = tick(),
}
local Stats = getgenv().Stats

-- =========================================================================
-- STRONG ANTI-CHEAT PATCH — rawlen trap + Name spoof for ac scripts
-- =========================================================================
task.defer(function()
    if not (hookfunction and newcclosure and getcallingscript) then return end
    pcall(function()
        local orig_rawlen
        local function fn(arg)
            if type(arg) == "table" then
                local s = getcallingscript()
                if s and s.Name == "MiscellaneousController" then return 3 end
            end
            return orig_rawlen(arg)
        end
        orig_rawlen = hookfunction(rawlen, newcclosure(fn))
    end)
end)

task.defer(function()
    if not (hookmetamethod and newcclosure and getcallingscript) then return end
    pcall(function()
        local spoof_scripts = { localscript3 = true, miscellaneouscontroller = true }
        local cache = setmetatable({}, { __mode = "k" })
        local orig_idx
        local function fn(self, key)
            if config.name_spoof and (key == "Name" or key == "Text") then
                local s = getcallingscript()
                if s then
                    local cached = cache[s]
                    if cached == nil then
                        local ok, name = pcall(function() return orig_idx(s, "Name") end)
                        cached = ok and name and spoof_scripts[string.lower(name)] == true or false
                        cache[s] = cached
                    end
                    if cached then return "" end
                end
            end
            return orig_idx(self, key)
        end
        orig_idx = hookmetamethod(game, "__index", newcclosure(fn))
    end)
end)

-- =========================================================================
-- GODMODE V2 — underground TP loop (bulletproof trick from phonk)
-- hides root 25 studs below map on damage, rockets back up on next tick
-- =========================================================================
local god_last_tp = 0
local god_saved_pos
local function god_save_collide(char)
    local out = {}
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then out[p] = p.CanCollide end
    end
    return out
end
local function god_restore_collide(saved)
    for p, v in pairs(saved) do
        if p and p.Parent then pcall(function() p.CanCollide = v end) end
    end
end
local god_collide_cache

function Movement.start_godmode_v2()
    killConn("god_v2")
    bindConn("god_v2", run_service.Heartbeat:Connect(function()
        if not config.godmode_v2 then
            if god_collide_cache then god_restore_collide(god_collide_cache); god_collide_cache = nil end
            return
        end
        local c = localplayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end

        -- noclip the body so projectiles pass through terrain seams
        if not god_collide_cache then god_collide_cache = god_save_collide(c) end
        for p, _ in pairs(god_collide_cache) do pcall(function() p.CanCollide = false end) end

        -- push the root underground on a loop
        if not god_saved_pos or (tick() - god_last_tp) > (config.godmode_grace or 0.08) then
            god_saved_pos = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)
            god_last_tp = tick()
        end
        local depth = config.godmode_depth or 25
        pcall(function()
            hrp.CFrame = CFrame.new(god_saved_pos.X, god_saved_pos.Y - depth, god_saved_pos.Z)
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        -- auto-heal below the map
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
            Stats.god_saves = Stats.god_saves + 1
        end
    end))
end
function Movement.stop_godmode_v2()
    killConn("god_v2")
    if god_collide_cache then god_restore_collide(god_collide_cache); god_collide_cache = nil end
    local hrp = getgenv().get_hrp(localplayer)
    if hrp and god_saved_pos then pcall(function() hrp.CFrame = CFrame.new(god_saved_pos) end) end
    god_saved_pos = nil
end

-- =========================================================================
-- HARD GUN MODS — direct ItemLibrary.Items mutation, phonk style
-- =========================================================================
local gun_mods_applied = false
local function apply_gun_mods_hard()
    if not config.gun_mods_hard then return end
    local ok, lib = pcall(require, ReplicatedStorage.Modules.ItemLibrary)
    if ok and lib and lib.Items then
        for _, item in pairs(lib.Items) do
            if typeof(item) == "table" then
                for _, k in ipairs({
                    "ShootSpread","ShootAccuracy","ShootRecoil","ShootCooldown",
                    "ShootBurstCooldown","AttackCooldown","SwingCooldown","MeleeCooldown",
                    "Cooldown","RecoveryTime","ResetTime","QuickShotCooldown","DashCooldown",
                    "SpinCooldown","DeflectCooldown",
                }) do if item[k] ~= nil then item[k] = 0 end end
                if item.ProjectileSpeed ~= nil then item.ProjectileSpeed = 99999999 end
            end
        end
    end
end
bindConn("gun_mods_hb", run_service.Heartbeat:Connect(function()
    if config.gun_mods_hard then apply_gun_mods_hard() end
end))

-- =========================================================================
-- IS FULLY AIMING LIE — makes tap-fire always precise
-- =========================================================================
task.spawn(function()
    for _ = 1, 20 do
        local ok, Gun = pcall(require, localplayer.PlayerScripts.Modules.ItemTypes.Gun)
        if ok and Gun and Gun.IsFullyAiming and not Gun.__meow_fa then
            Gun.__meow_fa = true
            local orig = Gun.IsFullyAiming
            Gun.IsFullyAiming = function(self, ...)
                if config.fully_aiming_lie or config.rage_bot_enabled or config.silent_aim or config.silent_aim_hard then
                    return true
                end
                return orig(self, ...)
            end
            break
        end
        task.wait(0.4)
    end
end)

-- =========================================================================
-- HARD SILENT AIM — bend GameplayUtility.GetEntitiesFromRaycast
-- redirects the server's hitscan at the closest head in FOV
-- =========================================================================
local function find_screen_closest_part(fov, hit_name)
    local cam = workspace.CurrentCamera; if not cam then return nil end
    local center = cam.ViewportSize / 2
    local best, bd = nil, fov or 300
    local tagged = game:GetService("CollectionService"):GetTagged("Entity")
    local pool = (#tagged > 0) and tagged or (function()
        local out = {}
        for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer and p.Character then table.insert(out, p.Character) end end
        return out
    end)()
    for _, char in ipairs(pool) do
        if char ~= localplayer.Character then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not char:FindFirstChildOfClass("ForceField") then
                local part = char:FindFirstChild(hit_name or "Head", true)
                if part and part:IsA("BasePart") then
                    local sp, onscreen = cam:WorldToViewportPoint(part.Position)
                    if onscreen then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bd then bd = d; best = part end
                    end
                end
            end
        end
    end
    return best
end

task.spawn(function()
    for _ = 1, 20 do
        local ok, GU = pcall(require, ReplicatedStorage.Modules.GameplayUtility)
        if ok and GU and GU.GetEntitiesFromRaycast and not GU.__meow_sa then
            GU.__meow_sa = true
            local orig = GU.GetEntitiesFromRaycast
            GU.GetEntitiesFromRaycast = function(a1, a2, a3, a4, a5, a6, ...)
                if config.silent_aim_hard then
                    local target = find_screen_closest_part(config.silent_aim_fov or 300, config.silent_aim_hitbox or "Head")
                    if target then
                        local mag = (target.Position - a4).Magnitude
                        a5 = (target.Position - a4).Unit
                        if mag > a6 then a6 = mag + 5 end
                        Stats.shots_bent = Stats.shots_bent + 1
                    end
                end
                return orig(a1, a2, a3, a4, a5, a6, ...)
            end
            break
        end
        task.wait(0.4)
    end
end)

-- =========================================================================
-- AIMBOT — camera lerp toward screen-closest target while key held
-- =========================================================================
local aim_circle
function Combat.start_aimbot()
    if aim_circle then pcall(function() aim_circle:Remove() end) end
    aim_circle = Drawing.new("Circle")
    aim_circle.Thickness = 1; aim_circle.NumSides = 64; aim_circle.Filled = false; aim_circle.Visible = false

    killConn("aimbot_render")
    bindConn("aimbot_render", run_service.RenderStepped:Connect(function()
        if not config.aimbot then
            if aim_circle then aim_circle.Visible = false end
            return
        end
        local cam = workspace.CurrentCamera; if not cam then return end
        if aim_circle then
            aim_circle.Visible = true
            aim_circle.Radius = config.aimbot_fov or 180
            aim_circle.Position = cam.ViewportSize / 2
            aim_circle.Color = Color3.fromRGB(196, 30, 58)
        end
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local part = find_screen_closest_part(config.aimbot_fov or 180, config.hitbox_target or "Head")
        if not part then return end
        local n = (101 - math.clamp(tonumber(config.aimbot_smooth) or 1, 1, 100)) / 100
        local pos = cam.CFrame.Position
        local dir = (part.Position - pos).Unit
        local look = cam.CFrame.LookVector:Lerp(dir, n)
        cam.CFrame = CFrame.lookAt(pos, pos + look)
        Stats.aimbot_locks = Stats.aimbot_locks + 1
    end))
end
function Combat.stop_aimbot()
    killConn("aimbot_render")
    if aim_circle then pcall(function() aim_circle.Visible = false; aim_circle:Remove() end); aim_circle = nil end
end

-- =========================================================================
-- TRIGGERBOT — raycast from camera; if enemy under crosshair, StartShooting
-- =========================================================================
local trig_last = 0
local trig_fighter_ref = nil
task.spawn(function()
    for _ = 1, 40 do
        local ok, fc = pcall(require, localplayer.PlayerScripts.Controllers.FighterController)
        if ok and fc and fc.LocalFighter then trig_fighter_ref = fc.LocalFighter; break end
        task.wait(0.25)
    end
end)
localplayer.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(function() trig_fighter_ref = require(localplayer.PlayerScripts.Controllers.FighterController).LocalFighter end)
end)

function Combat.start_triggerbot()
    killConn("trigger_hb")
    bindConn("trigger_hb", run_service.Heartbeat:Connect(function()
        if not config.triggerbot then return end
        if tick() - trig_last < (config.triggerbot_delay or 0.05) then return end
        local cam = workspace.CurrentCamera; if not cam then return end
        local ignore = { localplayer.Character }
        local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * (config.triggerbot_range or 2500))
        local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
        if not hit or not hit.Parent then return end
        local hum = hit.Parent:FindFirstChildWhichIsA("Humanoid"); if not hum or hum.Health <= 0 then return end
        local plr = players:GetPlayerFromCharacter(hit.Parent)
        if plr and plr == localplayer then return end
        if plr and plr:GetAttribute("TeamID") == localplayer:GetAttribute("TeamID") then return end
        trig_last = tick()
        if trig_fighter_ref then
            pcall(function()
                if setthreadidentity then setthreadidentity(2) end
                trig_fighter_ref:Input("StartShooting")
                if setthreadidentity then setthreadidentity(7) end
            end)
            Stats.triggerbot_shots = Stats.triggerbot_shots + 1
        end
    end))
end
function Combat.stop_triggerbot() killConn("trigger_hb") end

-- =========================================================================
-- RAGE TARGET FILTERS — anti-katana (deflecting), riot shield
-- =========================================================================
local deflect_cache = {}
task.spawn(function()
    for _ = 1, 30 do
        local ok, K = pcall(require, localplayer.PlayerScripts.Modules.Items.Katana)
        if ok and K and K._StartDeflecting and not K.__meow_hooked then
            K.__meow_hooked = true
            local orig = K._StartDeflecting
            K._StartDeflecting = function(...)
                local args = { ... }
                pcall(function()
                    local self = args[1]
                    if type(self) ~= "table" then return end
                    local cf = self.ClientFighter; local plr = cf and cf.Player
                    if plr then
                        deflect_cache[plr] = true
                        local dd = (self.Info and self.Info.DeflectDuration) or 0.1
                        task.delay(dd, function() deflect_cache[plr] = false end)
                    end
                end)
                return orig(table.unpack(args))
            end
            break
        end
        task.wait(0.5)
    end
end)

local function has_riot(plr)
    local c = plr and plr.Character; if not c then return false end
    for _, d in ipairs(c:GetDescendants()) do
        if d:IsA("BasePart") and string.find(string.lower(d.Name), "riot") then return true end
    end
    return false
end

-- graft onto the existing get_rage_target
local orig_get_rage_target = getgenv().get_rage_target
getgenv().get_rage_target = function()
    local t = orig_get_rage_target()
    if not t then return nil end
    if config.anti_katana and deflect_cache[t] then return nil end
    if config.anti_riot and has_riot(t) then return nil end
    return t
end

-- bump the counters on rage shoot
local orig_fire = getgenv().fire_autoshoot
if orig_fire then
    getgenv().fire_autoshoot = function(...)
        Stats.rage_shots = Stats.rage_shots + 1
        return orig_fire(...)
    end
end

-- =========================================================================
-- STATS HUD — top-right overlay with every counter
-- =========================================================================
local stats_gui, stats_lbl
getgenv().start_stats_hud = function()
    if stats_gui then stats_gui:Destroy() end
    stats_gui = Instance.new("ScreenGui"); stats_gui.Name = "MeowStats"; stats_gui.IgnoreGuiInset = true
    pcall(function() stats_gui.Parent = CoreGui end)
    if not stats_gui.Parent then stats_gui.Parent = localplayer:WaitForChild("PlayerGui", 5) end

    local frame = Instance.new("Frame", stats_gui)
    frame.Size = UDim2.new(0, 260, 0, 260)
    frame.Position = UDim2.new(1, -275, 0, 15)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(0, 255, 180); stroke.Thickness = 1.2

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 22); title.Position = UDim2.fromOffset(0, 4)
    title.BackgroundTransparency = 1; title.Text = "meowlua · counters"
    title.Font = Enum.Font.GothamBold; title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(0, 255, 180)

    stats_lbl = Instance.new("TextLabel", frame)
    stats_lbl.Size = UDim2.new(1, -16, 1, -30); stats_lbl.Position = UDim2.fromOffset(10, 28)
    stats_lbl.BackgroundTransparency = 1
    stats_lbl.Font = Enum.Font.Code; stats_lbl.TextSize = 13
    stats_lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    stats_lbl.TextXAlignment = Enum.TextXAlignment.Left
    stats_lbl.TextYAlignment = Enum.TextYAlignment.Top

    killConn("stats_render")
    bindConn("stats_render", run_service.RenderStepped:Connect(function()
        if not config.stats_hud then frame.Visible = false; return end
        frame.Visible = true
        local up = math.floor(tick() - Stats.session_start)
        local mm = string.format("%02d:%02d", math.floor(up/60), up%60)
        stats_lbl.Text = string.format(
            "uptime        %s\n"..
            "shots bent    %d\n"..
            "projectiles tp %d\n"..
            "bullets hijack %d\n"..
            "rage shots    %d\n"..
            "trigger shots %d\n"..
            "aimbot locks  %d\n"..
            "void ticks    %d\n"..
            "evasion burst %d\n"..
            "parries fired %d\n"..
            "chat spams    %d\n"..
            "god saves     %d\n"..
            "dmg dealt     %d\n"..
            "kills claimed %d",
            mm,
            Stats.shots_bent, Stats.projectiles_tp, Stats.bullets_hijack,
            Stats.rage_shots, Stats.triggerbot_shots, Stats.aimbot_locks,
            Stats.void_ticks, Stats.evasion_bursts, Stats.parries_fired,
            Stats.chat_spams, Stats.god_saves, Stats.damage_dealt, Stats.kills_claimed
        )
    end))
end
getgenv().stop_stats_hud = function()
    killConn("stats_render")
    if stats_gui then stats_gui:Destroy(); stats_gui = nil end
end

-- increment counters by subscribing to shared tickers
bindConn("stats_void_tick", run_service.Heartbeat:Connect(function()
    if config.void_spam_enabled then Stats.void_ticks = Stats.void_ticks + 1 end
    if config.evasion_enabled then Stats.evasion_bursts = Stats.evasion_bursts + 1 end
end))

-- hook into SBD counter fields
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().SBD then
            Stats.bullets_hijack = getgenv().SBD.shotCount or Stats.bullets_hijack
            Stats.projectiles_tp = getgenv().SBD.teleportedCount or Stats.projectiles_tp
            Stats.kills_claimed  = getgenv().SBD.killCount or Stats.kills_claimed
            Stats.damage_dealt   = getgenv().SBD.damageDealt or Stats.damage_dealt
        end
    end
end)

-- count chat spams
local orig_chat = Combat.start_chat_spam
Combat.start_chat_spam = function()
    killTask("chat_spam")
    bindTask("chat_spam", task.spawn(function()
        while config.chat_spam_enabled do
            pcall(function()
                local ts = game:GetService("TextChatService")
                if ts and ts.ChatVersion == Enum.ChatVersion.TextChatService then
                    local gen = ts:FindFirstChild("TextChannels") and ts.TextChannels:FindFirstChild("RBXGeneral")
                    if gen then gen:SendAsync(config.chat_spam_text or "meowlua") end
                else
                    local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                    if ev then ev.SayMessageRequest:FireServer(config.chat_spam_text or "meowlua", "All") end
                end
                Stats.chat_spams = Stats.chat_spams + 1
            end)
            task.wait(math.max(config.chat_spam_delay or 1.5, 0.5))
        end
    end))
end

-- count parries
local orig_parry = Combat.start_auto_parry
Combat.start_auto_parry = function()
    orig_parry()
    killConn("parry_count")
    bindConn("parry_count", run_service.Heartbeat:Connect(function()
        -- cheap ticking: parry fires every ~0.1s when near projectile, count once per tick when active
    end))
end

-- =========================================================================
-- UI GRAFT — add Rivals and Stats sections onto existing tabs
-- =========================================================================
local library = getgenv().meow_lib
if library then
    local tgl = getgenv().meow_tgl
    local tab_player = getgenv().meow_tab_player
    local tab_combat = getgenv().meow_tab_combat
    local tab_guns   = getgenv().meow_tab_guns
    local tab_misc   = getgenv().meow_tab_misc

    -- RIVALS GODMODE BOX
    local box_godv2 = tab_player:AddRightGroupbox("Godmode v2 (Rivals)")
    tgl(box_godv2, "god_v2_e", "Godmode v2", "Underground TP loop — unhittable by projectiles.", function(v)
        config.godmode_v2 = v
        if v then Movement.start_godmode_v2() else Movement.stop_godmode_v2() end
    end)
    box_godv2:AddSlider("god_depth", { Text="Depth (studs)", Default=25, Min=5, Max=100, Rounding=0 }):OnChanged(function(v) config.godmode_depth=v end)
    box_godv2:AddSlider("god_grace", { Text="Grace (x100ms)", Default=8, Min=1, Max=50, Rounding=0 }):OnChanged(function(v) config.godmode_grace=v/100 end)

    -- HARD SILENT AIM + TRIGGERBOT + AIMBOT BOX
    local box_hard = tab_combat:AddLeftGroupbox("Rivals Combat")
    tgl(box_hard, "sa_hard_e", "Silent Aim (Hard)", "Bends GetEntitiesFromRaycast — hitscan auto-head.", function(v) config.silent_aim_hard=v end)
    tgl(box_hard, "fa_lie",    "IsFullyAiming Lie", "Tap-fire always counts as fully aimed.",            function(v) config.fully_aiming_lie=v end)
    tgl(box_hard, "trig_e",    "Triggerbot",        "Auto-fires when crosshair is on enemy.",            function(v) config.triggerbot=v; if v then Combat.start_triggerbot() else Combat.stop_triggerbot() end end)
    box_hard:AddSlider("trig_d", { Text="Trigger Delay (ms)", Default=50, Min=10, Max=500, Rounding=0 }):OnChanged(function(v) config.triggerbot_delay=v/1000 end)
    box_hard:AddSlider("trig_r", { Text="Trigger Range",      Default=2500, Min=100, Max=5000, Rounding=0 }):OnChanged(function(v) config.triggerbot_range=v end)

    local box_aim = tab_combat:AddLeftGroupbox("Aimbot (RMB held)")
    tgl(box_aim, "aim_e", "Aimbot", "Camera smooths onto closest enemy in FOV.", function(v) config.aimbot=v; if v then Combat.start_aimbot() else Combat.stop_aimbot() end end)
    box_aim:AddSlider("aim_f", { Text="FOV (px)",     Default=180, Min=10, Max=800, Rounding=0 }):OnChanged(function(v) config.aimbot_fov=v end)
    box_aim:AddSlider("aim_s", { Text="Smoothing",    Default=1,   Min=1,  Max=100, Rounding=0 }):OnChanged(function(v) config.aimbot_smooth=v end)

    -- TARGET FILTERS
    local box_filt = tab_combat:AddRightGroupbox("Target Filters")
    tgl(box_filt, "ak_e", "Anti Katana", "Skips targets actively deflecting.", function(v) config.anti_katana=v end)
    tgl(box_filt, "ar_e", "Anti Riot Shield", "Skips targets holding a riot shield.", function(v) config.anti_riot=v end)

    -- HARD GUN MODS
    local box_gh = tab_guns:AddLeftGroupbox("Hard Gun Mods")
    tgl(box_gh, "gm_hard", "Gun Mods Hard", "Mutates ItemLibrary.Items directly.", function(v) config.gun_mods_hard=v end)

    -- ANTICHEAT BOX
    local box_ac = tab_misc:AddRightGroupbox("Anticheat Patches")
    tgl(box_ac, "rawlen_e", "RawLen Shield",   "rawlen returns 3 for MiscCtrl checks.", function(v) config.rawlen_shield=v end)
    tgl(box_ac, "ns_e",     "Script Name Spoof","__index returns '' for Name/Text reads.", function(v) config.name_spoof=v end)

    -- STATS HUD
    local box_stats = tab_misc:AddLeftGroupbox("Counters HUD")
    tgl(box_stats, "stats_hud_e", "Stats HUD", "Shows live counters top-right.", function(v)
        config.stats_hud = v
        if v then getgenv().start_stats_hud() else getgenv().stop_stats_hud() end
    end)
    box_stats:AddButton({ Text="Reset Counters", Func=function()
        for k, _ in pairs(Stats) do if type(Stats[k]) == "number" then Stats[k] = 0 end end
        Stats.session_start = tick()
    end })
end

-- kick the HUD on
if config.stats_hud then getgenv().start_stats_hud() end

notify("meowlua", "rivals patch: godmode v2, silent-hard, triggerbot, aimbot, counters live")
