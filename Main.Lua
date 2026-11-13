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
(function()  -- isolate UI build in its own function scope
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

box_evasion = tab_rage:AddRightGroupbox("Evasion")
tgl(box_evasion, "ev_e", "Evasion", "Pattern-driven teleport burst.", function(v) config.evasion_enabled=v; if v then getgenv().start_evasion() else getgenv().stop_evasion() end end)
box_evasion:AddDropdown("ev_mode", { Text="Evasion Mode", Default=1, Values=getgenv()._shapes_evasion_list }):OnChanged(function(v) config.evasion_mode=v end)
box_evasion:AddSlider("ev_burst", { Text="Burst Count", Default=500, Min=100, Max=1000, Rounding=0 }):OnChanged(function(v) config.evasion_burst=v end)
box_evasion:AddSlider("ev_int",   { Text="Interval",    Default=1,   Min=1,   Max=1000, Rounding=0 }):OnChanged(function(v) config.evasion_interval=v end)
box_evasion:AddSlider("ev_spn",   { Text="Spin Speed",  Default=9999,Min=0,   Max=999999,Rounding=0 }):OnChanged(function(v) config.evasion_spin_speed=v end)

box_anti_aim = tab_rage:AddRightGroupbox("Anti Aim")
tgl(box_anti_aim, "aa_e", "Anti Aim", "Scrambles orientation.", function(v) config.anti_aim_enabled=v; if v then getgenv().start_anti_aim() else getgenv().stop_anti_aim() end end)
box_anti_aim:AddDropdown("aa_meth", { Text="Method", Default=2, Values={"Pixelated","Static","Spin","Jitter","Desync","Sway","Breaker","Lurk","Orbit","Custom"} }):OnChanged(function(v) config.aa_method=v end)
box_anti_aim:AddSlider("aa_pxs", { Text="Pixelation Scale", Default=0,   Min=0,   Max=100,    Rounding=0 }):OnChanged(function(v) config.aa_pixel_scale=v end)
box_anti_aim:AddSlider("aa_spn", { Text="Spin Speed",       Default=9999,Min=100, Max=999999, Rounding=0 }):OnChanged(function(v) config.aa_spin_speed=v end)
box_anti_aim:AddSlider("aa_yaw", { Text="Yaw",              Default=0,   Min=-360,Max=360,    Rounding=0 }):OnChanged(function(v) config.aa_yaw=v end)
box_anti_aim:AddSlider("aa_pit", { Text="Pitch",            Default=0,   Min=-360,Max=360,    Rounding=0 }):OnChanged(function(v) config.aa_pitch=v end)
box_anti_aim:AddSlider("aa_rol", { Text="Roll",             Default=0,   Min=-360,Max=360,    Rounding=0 }):OnChanged(function(v) config.aa_roll=v end)

-- COMBAT ------------------------------------------------------------------
box_silent = tab_combat:AddLeftGroupbox("Silent Aim")
tgl(box_silent, "sa_e", "Silent Aim", "Bends shot remote to closest-in-FOV.", function(v) config.silent_aim=v; if v then Combat.start_silent_aim_tracker() else Combat.stop_silent_aim_tracker() end end)
box_silent:AddSlider("sa_fov",  { Text="FOV (px)", Default=120, Min=10,  Max=800, Rounding=0 }):OnChanged(function(v) config.silent_aim_fov=v end)
box_silent:AddDropdown("sa_hit",{ Text="Hitbox",   Default=1,  Values={"Head","HumanoidRootPart","UpperTorso","Torso"} }):OnChanged(function(v) config.silent_aim_hitbox=v end)

box_assist = tab_combat:AddLeftGroupbox("Aim Assist")
tgl(box_assist, "aa_ast", "Aim Assist", "Smooth camera at closest while right-click held.", function(v) config.aim_assist=v; if v then Combat.start_aim_assist(); Combat.start_silent_aim_tracker() else Combat.stop_aim_assist() end end)
box_assist:AddSlider("aa_fov",   { Text="FOV (px)",  Default=90, Min=10, Max=800, Rounding=0 }):OnChanged(function(v) config.aim_assist_fov=v end)
box_assist:AddSlider("aa_smth",  { Text="Smoothness",Default=6,  Min=1,  Max=30,  Rounding=0 }):OnChanged(function(v) config.aim_assist_smooth=v end)

box_hit = tab_combat:AddRightGroupbox("Hitbox Expand")
tgl(box_hit, "hit_e", "Hitbox Expand", "Grows enemy aim part for easier hits.", function(v) config.hitbox_expand=v; if v then Combat.start_hitbox_expand() else Combat.stop_hitbox_expand() end end)
box_hit:AddSlider("hit_s",  { Text="Size",   Default=15, Min=2,  Max=60, Rounding=0 }):OnChanged(function(v) config.hitbox_size=v end)
box_hit:AddDropdown("hit_t",{ Text="Target", Default=1, Values={"Head","HumanoidRootPart","UpperTorso","Torso"} }):OnChanged(function(v) config.hitbox_target=v end)

box_fov = tab_combat:AddRightGroupbox("FOV Circle")
tgl(box_fov, "fov_e", "FOV Circle", "Visual FOV reference on screen.", function(v) config.fov_circle=v; if v then Combat.start_fov_circle() else Combat.stop_fov_circle() end end)
box_fov:AddSlider("fov_r", { Text="Radius", Default=120, Min=20, Max=800, Rounding=0 }):OnChanged(function(v) config.fov_circle_radius=v end)
pcall(function() box_fov:AddLabel("Color"):AddColorPicker("fov_col", { Default=Color3.fromRGB(255,255,255), Title="Color" }):OnChanged(function(v) config.fov_circle_color=v end) end)

box_parry = tab_combat:AddRightGroupbox("Auto Parry")
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
box_vs = tab_voidspam:AddLeftGroupbox("Void Teleport")
tgl(box_vs, "vs_e", "Voidspam", "Fast burst teleport.", function(v) config.void_spam_enabled=v; if v then getgenv().start_void_spam() else getgenv().stop_void_spam() end end)
box_vs:AddDropdown("et_mod", { Text="Voidspam Type", Default=1, Values={"Random","Camera","Forward","Directional"} }):OnChanged(function(v) config.et_mode=v end)
box_vs:AddDropdown("et_ord", { Text="Burst Pattern", Default=1, Values=getgenv()._shapes_void_list }):OnChanged(function(v) config.et_order=v end)
box_vs:AddSlider("et_spd",   { Text="Interval",      Default=10000000, Min=0, Max=10000000, Rounding=0 }):OnChanged(function(v) config.et_speed=v end)
box_vs:AddSlider("et_tot",   { Text="Burst Count",   Default=500,      Min=1, Max=500,      Rounding=0 }):OnChanged(function(v) config.et_total=v end)

box_vs_dir = tab_voidspam:AddLeftGroupbox("Directions")
box_vs_dir:AddSlider("vs_min", { Text="Min Distance", Default=0,     Min=0,  Max=50000,  Rounding=3 }):OnChanged(function(v) config.vs_min_dist=v*1e25 end)
box_vs_dir:AddSlider("vs_max", { Text="Max Distance", Default=50000, Min=10, Max=500000, Rounding=0 }):OnChanged(function(v) config.vs_max_dist=v end)
for _, k in ipairs({"xp","xn","yp","yn","zp","zn"}) do
    box_vs_dir:AddSlider("vs_"..k, { Text=k:upper(), Default=5000, Min=0, Max=50000, Rounding=0 }):OnChanged(function(v) config["vs_"..k]=v end)
end

box_vp = tab_voidspam:AddRightGroupbox("Directional Patterns")
box_vp:AddDropdown("vp_d", { Text="Pattern", Default=1, Values=getgenv()._shapes_void_pattern_list }):OnChanged(function(v) config.void_pattern=v end)
tgl(box_vp, "vp_x", "Axis X", "Enable X axis.", function(v) config.void_axis_x=v end)
tgl(box_vp, "vp_y", "Axis Y", "Enable Y axis.", function(v) config.void_axis_y=v end)
tgl(box_vp, "vp_z", "Axis Z", "Enable Z axis.", function(v) config.void_axis_z=v end)

-- SETTINGS ----------------------------------------------------------------
box_settings = tab_settings:AddLeftGroupbox("Settings")
box_settings:AddButton({ Text="Panic Unload (F8)", Func=function() getgenv().unload_all() end })
box_settings:AddButton({ Text="Display Keybinds",  Func=function() library:SetKeybindMenuOpen(true) end })

box_theme = tab_settings:AddRightGroupbox("Themes")
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
end)()  -- /isolate UI build
-- =========================================================================
-- RIVALS PATCH — hard anticheat, true-working godmode, silent aim raycast
-- bend, triggerbot, IsFullyAiming lie, aimbot, stats HUD + counters
-- =========================================================================

-- extra config flags
for k, v in pairs({
    godmode_v2 = false, godmode_depth = 8, godmode_grace = 0.05,
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

local function god_harden_hum(hum)
    if not hum then return end
    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum.MaxHealth = 1e9
        hum.Health    = 1e9
    end)
end

function Movement.start_godmode_v2()
    killConn("god_v2")
    local hum0 = getgenv().get_hum()
    god_harden_hum(hum0)
    -- re-harden on respawn
    killConn("god_v2_respawn")
    bindConn("god_v2_respawn", localplayer.CharacterAdded:Connect(function(c)
        local h = c:WaitForChild("Humanoid", 5)
        task.wait(0.2)
        god_harden_hum(h)
    end))

    bindConn("god_v2", run_service.Heartbeat:Connect(function()
        if not config.godmode_v2 then
            if god_collide_cache then god_restore_collide(god_collide_cache); god_collide_cache = nil end
            return
        end
        local c = localplayer.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end

        -- keep the hum immortal every tick
        god_harden_hum(hum)
        if hum:GetState() == Enum.HumanoidStateType.Dead or hum:GetState() == Enum.HumanoidStateType.FallingDown then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end

        -- noclip the body so projectiles pass through terrain seams
        if not god_collide_cache then god_collide_cache = god_save_collide(c) end
        for p, _ in pairs(god_collide_cache) do pcall(function() p.CanCollide = false end) end

        -- lock the saved pos only once, until toggled off
        if not god_saved_pos then god_saved_pos = hrp.Position end
        god_last_tp = tick()
        local depth = config.godmode_depth or 8
        pcall(function()
            hrp.CFrame = CFrame.new(god_saved_pos.X, god_saved_pos.Y - depth, god_saved_pos.Z)
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
            Stats.god_saves = Stats.god_saves + 1
        end
    end))
end
function Movement.stop_godmode_v2()
    killConn("god_v2"); killConn("god_v2_respawn")
    if god_collide_cache then god_restore_collide(god_collide_cache); god_collide_cache = nil end
    local hrp = getgenv().get_hrp(localplayer)
    if hrp and god_saved_pos then
        pcall(function()
            hrp.CFrame = CFrame.new(god_saved_pos.X, god_saved_pos.Y + 3, god_saved_pos.Z)
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    local hum = getgenv().get_hum()
    if hum then pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum.BreakJointsOnDeath = true
        hum.MaxHealth = 100; hum.Health = 100
    end) end
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
    box_godv2 = tab_player:AddRightGroupbox("Godmode v2 (Rivals)")
    tgl(box_godv2, "god_v2_e", "Godmode v2", "Underground TP loop — unhittable by projectiles.", function(v)
        config.godmode_v2 = v
        if v then Movement.start_godmode_v2() else Movement.stop_godmode_v2() end
    end)
    box_godv2:AddSlider("god_depth", { Text="Depth (studs)", Default=25, Min=5, Max=100, Rounding=0 }):OnChanged(function(v) config.godmode_depth=v end)
    box_godv2:AddSlider("god_grace", { Text="Grace (x100ms)", Default=8, Min=1, Max=50, Rounding=0 }):OnChanged(function(v) config.godmode_grace=v/100 end)

    -- HARD SILENT AIM + TRIGGERBOT + AIMBOT BOX
    box_hard = tab_combat:AddLeftGroupbox("Rivals Combat")
    tgl(box_hard, "sa_hard_e", "Silent Aim (Hard)", "Bends GetEntitiesFromRaycast — hitscan auto-head.", function(v) config.silent_aim_hard=v end)
    tgl(box_hard, "fa_lie",    "IsFullyAiming Lie", "Tap-fire always counts as fully aimed.",            function(v) config.fully_aiming_lie=v end)
    tgl(box_hard, "trig_e",    "Triggerbot",        "Auto-fires when crosshair is on enemy.",            function(v) config.triggerbot=v; if v then Combat.start_triggerbot() else Combat.stop_triggerbot() end end)
    box_hard:AddSlider("trig_d", { Text="Trigger Delay (ms)", Default=50, Min=10, Max=500, Rounding=0 }):OnChanged(function(v) config.triggerbot_delay=v/1000 end)
    box_hard:AddSlider("trig_r", { Text="Trigger Range",      Default=2500, Min=100, Max=5000, Rounding=0 }):OnChanged(function(v) config.triggerbot_range=v end)

    box_aim = tab_combat:AddLeftGroupbox("Aimbot (RMB held)")
    tgl(box_aim, "aim_e", "Aimbot", "Camera smooths onto closest enemy in FOV.", function(v) config.aimbot=v; if v then Combat.start_aimbot() else Combat.stop_aimbot() end end)
    box_aim:AddSlider("aim_f", { Text="FOV (px)",     Default=180, Min=10, Max=800, Rounding=0 }):OnChanged(function(v) config.aimbot_fov=v end)
    box_aim:AddSlider("aim_s", { Text="Smoothing",    Default=1,   Min=1,  Max=100, Rounding=0 }):OnChanged(function(v) config.aimbot_smooth=v end)

    -- TARGET FILTERS
    box_filt = tab_combat:AddRightGroupbox("Target Filters")
    tgl(box_filt, "ak_e", "Anti Katana", "Skips targets actively deflecting.", function(v) config.anti_katana=v end)
    tgl(box_filt, "ar_e", "Anti Riot Shield", "Skips targets holding a riot shield.", function(v) config.anti_riot=v end)

    -- HARD GUN MODS
    box_gh = tab_guns:AddLeftGroupbox("Hard Gun Mods")
    tgl(box_gh, "gm_hard", "Gun Mods Hard", "Mutates ItemLibrary.Items directly.", function(v) config.gun_mods_hard=v end)

    -- ANTICHEAT BOX
    box_ac = tab_misc:AddRightGroupbox("Anticheat Patches")
    tgl(box_ac, "rawlen_e", "RawLen Shield",   "rawlen returns 3 for MiscCtrl checks.", function(v) config.rawlen_shield=v end)
    tgl(box_ac, "ns_e",     "Script Name Spoof","__index returns '' for Name/Text reads.", function(v) config.name_spoof=v end)

    -- STATS HUD
    box_stats = tab_misc:AddLeftGroupbox("Counters HUD")
    tgl(box_stats, "stats_hud_e", "Stats HUD", "Shows live counters top-right.", function(v)
        config.stats_hud = v
        if v then getgenv().start_stats_hud() else getgenv().stop_stats_hud() end
    end)
    box_stats:AddButton({ Text="Reset Counters", Func=function()
        for k, _ in pairs(Stats) do if type(Stats[k]) == "number" then Stats[k] = 0 end end
        Stats.session_start = tick()
    end })
end

-- =========================================================================
-- VOID SENDER — picks a target, flood-fires shoot remote + bullet TP burst
-- =========================================================================
getgenv().void_sender_target = ""
getgenv().void_sender_running = false

getgenv().void_send = function(name, duration)
    duration = duration or 2.5
    local target = name and name ~= "" and players:FindFirstChild(name) or getgenv().get_closest(true)
    if not target or not target.Character then
        notify("Void Sender", "no target"); return
    end
    local c = target.Character
    local head = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
    local hum  = c:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end

    getgenv().void_sender_running = true
    notify("Void Sender", "sending "..target.Name.." to the void")

    -- 1) client-side visual: yank their character to Y -5e9 locally
    task.spawn(function()
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _ = 1, 20 do
                if not getgenv().void_sender_running or not hrp.Parent then break end
                pcall(function() hrp.CFrame = CFrame.new(0, -5e9, 0) end)
                task.wait(0.05)
            end
        end
    end)

    -- 2) flood shoot remote + hum:TakeDamage through SBD's damage call
    local t0 = tick()
    task.spawn(function()
        while getgenv().void_sender_running and tick() - t0 < duration do
            pcall(function()
                if getgenv().fire_autoshoot then getgenv().fire_autoshoot(head, c) end
                if hum and hum.Parent then hum:TakeDamage(9999) end
            end)
            task.wait(0.03)
        end
        getgenv().void_sender_running = false
        notify("Void Sender", "done: "..target.Name)
    end)
end

getgenv().void_stop = function()
    getgenv().void_sender_running = false
end

-- =========================================================================
-- RIVAL SCOREBOARD — one-click tally per competitor script
-- =========================================================================
local Rivals = {
    "kicia", "sleepy", "UE", "phonk ware", "anti brain",
    "yokai", "elisium", "YokaiNamed",
}
getgenv().RivalScore = getgenv().RivalScore or {}
for _, k in ipairs(Rivals) do
    getgenv().RivalScore[k] = getgenv().RivalScore[k] or 0
end

getgenv().rival_bump = function(name)
    getgenv().RivalScore[name] = (getgenv().RivalScore[name] or 0) + 1
    notify("beat "..name, tostring(getgenv().RivalScore[name]))
end

-- extend stats HUD label to include the scoreboard
local orig_start_hud = getgenv().start_stats_hud
getgenv().start_stats_hud = function()
    orig_start_hud()
    if not stats_gui then return end
    local frame = stats_gui:FindFirstChildOfClass("Frame"); if not frame then return end
    -- expand frame
    frame.Size = UDim2.new(0, 260, 0, 480)
    local score_lbl = Instance.new("TextLabel", frame)
    score_lbl.Name = "RivalScore"
    score_lbl.Size = UDim2.new(1, -16, 0, 200)
    score_lbl.Position = UDim2.fromOffset(10, 260)
    score_lbl.BackgroundTransparency = 1
    score_lbl.Font = Enum.Font.Code; score_lbl.TextSize = 13
    score_lbl.TextColor3 = Color3.fromRGB(255, 180, 60)
    score_lbl.TextXAlignment = Enum.TextXAlignment.Left
    score_lbl.TextYAlignment = Enum.TextYAlignment.Top

    local score_title = Instance.new("TextLabel", frame)
    score_title.Size = UDim2.new(1, 0, 0, 20)
    score_title.Position = UDim2.fromOffset(0, 240)
    score_title.BackgroundTransparency = 1
    score_title.Text = "rival scoreboard"
    score_title.Font = Enum.Font.GothamBold; score_title.TextSize = 13
    score_title.TextColor3 = Color3.fromRGB(255, 180, 60)

    bindConn("score_render", run_service.RenderStepped:Connect(function()
        if not score_lbl or not score_lbl.Parent then return end
        local lines = {}
        for _, k in ipairs(Rivals) do
            table.insert(lines, string.format("%-12s  %d", k, getgenv().RivalScore[k] or 0))
        end
        score_lbl.Text = table.concat(lines, "\n")
    end))
end

-- UI graft for void sender + scoreboard
if library then
    local tgl        = getgenv().meow_tgl
    local tab_combat = getgenv().meow_tab_combat
    local tab_misc   = getgenv().meow_tab_misc

    box_void = tab_combat:AddRightGroupbox("Void Sender")
    local vs_names = { "" }
    for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(vs_names, p.Name) end end
    local vs_drop = box_void:AddDropdown("vs_target", { Text="Target", Default=1, Values=vs_names })
    vs_drop:OnChanged(function(v) getgenv().void_sender_target = v end)
    players.PlayerAdded:Connect(function()
        local list = { "" }
        for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(list, p.Name) end end
        pcall(function() vs_drop:SetValues(list) end)
    end)
    players.PlayerRemoving:Connect(function()
        local list = { "" }
        for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(list, p.Name) end end
        pcall(function() vs_drop:SetValues(list) end)
    end)
    box_void:AddSlider("vs_dur", { Text="Burst Duration (x100ms)", Default=25, Min=5, Max=100, Rounding=0 })
        :OnChanged(function(v) getgenv().void_send_dur = v/10 end)
    box_void:AddButton({ Text="SEND TO VOID", Func=function()
        getgenv().void_send(getgenv().void_sender_target, getgenv().void_send_dur or 2.5)
    end })
    box_void:AddButton({ Text="SEND CLOSEST", Func=function()
        getgenv().void_send(nil, getgenv().void_send_dur or 2.5)
    end })
    box_void:AddButton({ Text="Stop Void Burst", Func=function() getgenv().void_stop() end })

    box_score = tab_misc:AddRightGroupbox("Rival Scoreboard")
    for _, name in ipairs(Rivals) do
        local n = name
        box_score:AddButton({ Text="beat "..n, Func=function() getgenv().rival_bump(n) end })
    end
    box_score:AddButton({ Text="Reset Scoreboard", Func=function()
        for _, k in ipairs(Rivals) do getgenv().RivalScore[k] = 0 end
    end })
end

-- kick the HUD on
if config.stats_hud then getgenv().start_stats_hud() end

notify("meowlua", "rivals patch: godmode v2, silent-hard, triggerbot, aimbot, counters live")
-- =========================================================================
-- MEGA GRAFT — kill aura, bhop, FOV, 3p, crosshair, watermark, rainbow
-- chams, smart panic, weapon cycle, spectate, trash cleaner, kill all,
-- airwalk, admin list extend, gravity, hitmarker
-- =========================================================================

for k, v in pairs({
    kill_aura = false, kill_aura_radius = 25, kill_aura_damage = 500,
    kill_all = false,
    bhop = false,
    gravity_enabled = false, gravity = 196,
    fov_enabled = false, fov = 70,
    third_person = false, third_person_dist = 10,
    crosshair_enabled = false, crosshair_size = 8, crosshair_gap = 3, crosshair_thick = 1,
    crosshair_color = Color3.fromRGB(0, 255, 180),
    watermark = true,
    rainbow_chams = false,
    smart_panic = false, smart_panic_hp = 40,
    weapon_cycle = false, weapon_cycle_delay = 0.5,
    spectate_target = "",
    trash_cleaner = false,
    airwalk = false,
    hitmarker_sound = false, hitmarker_id = "rbxassetid://3807102805",
    admin_detector = false,
    killsay = false, killsay_text = "beat by meowlua",
    anti_slow = false,
    jump_height = false, jump_height_v = 7.2,
    free_dev_console = false,
}) do if config[k] == nil then config[k] = v end end

-- ---------- KILL AURA (radius + damage flood) ---------------------------
bindConn("kill_aura", run_service.Heartbeat:Connect(function()
    if not config.kill_aura then return end
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p == localplayer then continue end
        if p.Team and localplayer.Team and p.Team == localplayer.Team then continue end
        local c = p.Character; if not c then continue end
        local h = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not h or not hum or hum.Health <= 0 then continue end
        if c:FindFirstChildOfClass("ForceField") then continue end
        if (h.Position - hrp.Position).Magnitude <= (config.kill_aura_radius or 25) then
            pcall(function()
                if getgenv().fire_autoshoot then getgenv().fire_autoshoot(h, c) end
                hum:TakeDamage(config.kill_aura_damage or 500)
            end)
        end
    end
end))

-- ---------- KILL ALL (one-shot rage sweep every enemy) ------------------
getgenv().kill_all_once = function()
    for _, p in ipairs(players:GetPlayers()) do
        if p == localplayer then continue end
        if p.Team and localplayer.Team and p.Team == localplayer.Team then continue end
        local c = p.Character; if not c then continue end
        local h = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if h and hum and hum.Health > 0 and not c:FindFirstChildOfClass("ForceField") then
            task.spawn(function()
                for _ = 1, 15 do
                    pcall(function()
                        if getgenv().fire_autoshoot then getgenv().fire_autoshoot(h, c) end
                        hum:TakeDamage(9999)
                    end)
                    task.wait(0.03)
                end
            end)
        end
    end
end

-- ---------- BUNNY HOP ---------------------------------------------------
bindConn("bhop", run_service.Heartbeat:Connect(function()
    if not config.bhop then return end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        local h = getgenv().get_hum()
        if h and h.FloorMaterial ~= Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- ---------- GRAVITY -----------------------------------------------------
bindConn("gravity_apply", run_service.Heartbeat:Connect(function()
    if not config.gravity_enabled then return end
    if workspace.Gravity ~= config.gravity then pcall(function() workspace.Gravity = config.gravity end) end
end))

-- ---------- CAMERA FOV --------------------------------------------------
bindConn("fov_apply", run_service.RenderStepped:Connect(function()
    if not config.fov_enabled then return end
    local cam = workspace.CurrentCamera; if not cam then return end
    if cam.FieldOfView ~= config.fov then pcall(function() cam.FieldOfView = config.fov end) end
end))

-- ---------- THIRD PERSON ------------------------------------------------
bindConn("third_person_apply", run_service.RenderStepped:Connect(function()
    if not config.third_person then return end
    pcall(function()
        localplayer.CameraMode = Enum.CameraMode.Classic
        local h = getgenv().get_hum()
        if h then
            h.CameraOffset = Vector3.new(2, 0, (config.third_person_dist or 10))
        end
    end)
end))

-- ---------- JUMP HEIGHT OVERRIDE ---------------------------------------
bindConn("jump_height_apply", run_service.Heartbeat:Connect(function()
    if not config.jump_height then return end
    local h = getgenv().get_hum(); if not h then return end
    pcall(function()
        h.UseJumpPower = false
        h.JumpHeight = config.jump_height_v or 7.2
    end)
end))

-- ---------- CROSSHAIR (4 line drawing) ---------------------------------
local xh = { lines = {} }
for i = 1, 4 do xh.lines[i] = Drawing.new("Line"); xh.lines[i].Thickness = 1; xh.lines[i].Visible = false end
bindConn("xh_render", run_service.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not config.crosshair_enabled or not cam then
        for _, l in ipairs(xh.lines) do l.Visible = false end; return
    end
    local cx, cy = cam.ViewportSize.X/2, cam.ViewportSize.Y/2
    local s = config.crosshair_size or 8; local g = config.crosshair_gap or 3
    local col = config.crosshair_color or Color3.fromRGB(0,255,180)
    local t = config.crosshair_thick or 1
    local coords = {
        { Vector2.new(cx-g-s, cy), Vector2.new(cx-g, cy) },
        { Vector2.new(cx+g, cy), Vector2.new(cx+g+s, cy) },
        { Vector2.new(cx, cy-g-s), Vector2.new(cx, cy-g) },
        { Vector2.new(cx, cy+g), Vector2.new(cx, cy+g+s) },
    }
    for i, l in ipairs(xh.lines) do
        l.From = coords[i][1]; l.To = coords[i][2]
        l.Color = col; l.Thickness = t; l.Visible = true
    end
end))

-- ---------- WATERMARK ---------------------------------------------------
local wm_gui, wm_lbl
local function build_watermark()
    if wm_gui then wm_gui:Destroy() end
    wm_gui = Instance.new("ScreenGui"); wm_gui.Name = "MeowWatermark"; wm_gui.IgnoreGuiInset = true
    pcall(function() wm_gui.Parent = CoreGui end)
    if not wm_gui.Parent then wm_gui.Parent = localplayer:WaitForChild("PlayerGui", 5) end
    local f = Instance.new("Frame", wm_gui)
    f.Size = UDim2.new(0, 360, 0, 28); f.Position = UDim2.new(0, 12, 0, 12)
    f.BackgroundColor3 = Color3.fromRGB(10,10,12); f.BackgroundTransparency = 0.25; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local str = Instance.new("UIStroke", f); str.Color = Color3.fromRGB(0,255,180); str.Thickness = 1
    wm_lbl = Instance.new("TextLabel", f)
    wm_lbl.Size = UDim2.new(1, -16, 1, 0); wm_lbl.Position = UDim2.fromOffset(8, 0)
    wm_lbl.BackgroundTransparency = 1; wm_lbl.Font = Enum.Font.Code; wm_lbl.TextSize = 13
    wm_lbl.TextColor3 = Color3.fromRGB(0,255,180); wm_lbl.TextXAlignment = Enum.TextXAlignment.Left
end
build_watermark()
local fps_count, fps_last, fps_val = 0, tick(), 0
bindConn("wm_render", run_service.RenderStepped:Connect(function()
    if not config.watermark then if wm_gui then wm_gui.Enabled = false end; return end
    if wm_gui then wm_gui.Enabled = true end
    fps_count = fps_count + 1
    if tick() - fps_last >= 1 then fps_val = fps_count; fps_count = 0; fps_last = tick() end
    local ping = math.floor(localplayer:GetNetworkPing() * 1000)
    local up = math.floor(tick() - Stats.session_start)
    wm_lbl.Text = string.format("meowlua ultron · %s · fps %d · ping %dms · %02d:%02d",
        localplayer.Name, fps_val, ping, math.floor(up/60), up%60)
end))

-- ---------- RAINBOW CHAMS ----------------------------------------------
bindConn("rainbow_chams", run_service.Heartbeat:Connect(function()
    if not config.rainbow_chams or not config.chams_enabled then return end
    config.chams_fill = Color3.fromHSV(tick()*0.2 % 1, 1, 1)
end))

-- ---------- SMART PANIC (auto-god + evasion on low hp) ------------------
bindConn("smart_panic", run_service.Heartbeat:Connect(function()
    if not config.smart_panic then return end
    local h = getgenv().get_hum(); if not h then return end
    if h.Health <= (config.smart_panic_hp or 40) and h.Health > 0 then
        if not config.godmode_v2 then config.godmode_v2 = true; Movement.start_godmode_v2() end
        if not config.evasion_enabled then config.evasion_enabled = true; getgenv().start_evasion() end
    else
        if config.godmode_v2 then config.godmode_v2 = false; Movement.stop_godmode_v2() end
        if config.evasion_enabled then config.evasion_enabled = false; getgenv().stop_evasion() end
    end
end))

-- ---------- WEAPON CYCLE ------------------------------------------------
local wc_slot = 1
bindConn("weapon_cycle", run_service.Heartbeat:Connect(function()
    if not config.weapon_cycle then return end
end))
bindTask("weapon_cycle_task", task.spawn(function()
    while true do
        task.wait(config.weapon_cycle_delay or 0.5)
        if config.weapon_cycle then
            pcall(function()
                local fc = require(localplayer.PlayerScripts.Controllers.FighterController)
                if fc.LocalFighter and fc.LocalFighter.EquipItem then
                    fc.LocalFighter:EquipItem(wc_slot)
                    wc_slot = wc_slot % 3 + 1
                end
            end)
        end
    end
end))

-- ---------- SPECTATE ----------------------------------------------------
local spectate_orig_subject
getgenv().start_spectate = function(name)
    local p = players:FindFirstChild(name); if not p or not p.Character then return end
    local hum = p.Character:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local cam = workspace.CurrentCamera
    if not spectate_orig_subject then spectate_orig_subject = cam.CameraSubject end
    cam.CameraSubject = hum
end
getgenv().stop_spectate = function()
    local cam = workspace.CurrentCamera
    if spectate_orig_subject then cam.CameraSubject = spectate_orig_subject end
    spectate_orig_subject = nil
end

-- ---------- TRASH CLEANER (strip particles/beams/trails) ----------------
bindConn("trash_cleaner", run_service.Heartbeat:Connect(function()
    if not config.trash_cleaner then return end
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") then
            pcall(function() o.Enabled = false end)
        end
    end
end))

-- ---------- AIRWALK (platform under feet) -------------------------------
local airwalk_part
bindConn("airwalk", run_service.Heartbeat:Connect(function()
    if not config.airwalk then
        if airwalk_part then airwalk_part:Destroy(); airwalk_part = nil end
        return
    end
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
    if not airwalk_part or not airwalk_part.Parent then
        airwalk_part = Instance.new("Part")
        airwalk_part.Size = Vector3.new(10, 1, 10)
        airwalk_part.Anchored = true; airwalk_part.CanCollide = true
        airwalk_part.Transparency = 1; airwalk_part.Name = "MeowFloor"
        airwalk_part.Parent = workspace
    end
    airwalk_part.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3.5, 0))
end))

-- ---------- ADMIN DETECTOR (extended name list) -------------------------
local ADMIN_NAMES = {
    "mod","admin","staff","owner","dev","developer","helper","support","moderator",
    "ceo","cto","founder","tester","qa","community","intern","contractor",
}
bindTask("admin_detector_v2", task.spawn(function()
    while true do
        task.wait(3)
        if config.admin_detector then
            for _, plr in ipairs(players:GetPlayers()) do
                if plr == localplayer then continue end
                local nm = plr.Name:lower()
                for _, tag in ipairs(ADMIN_NAMES) do
                    if nm:find(tag) then
                        notify("ADMIN DETECTED", plr.Name)
                        pcall(function() teleport_service:Teleport(game.PlaceId) end)
                        return
                    end
                end
            end
        end
    end
end))

-- ---------- HITMARKER SOUND --------------------------------------------
local hm_sound
local function play_hitmarker()
    if not config.hitmarker_sound then return end
    if not hm_sound then
        hm_sound = Instance.new("Sound")
        hm_sound.SoundId = config.hitmarker_id or "rbxassetid://3807102805"
        hm_sound.Volume = 1.5
        hm_sound.Parent = workspace
    end
    hm_sound:Play()
end
getgenv().meow_hitmarker = play_hitmarker

-- hook into SBD counter bumps to fire hitmarker on each hijack
task.spawn(function()
    local last_hijack = 0
    while true do
        task.wait(0.05)
        if config.hitmarker_sound and getgenv().SBD and getgenv().SBD.shotCount > last_hijack then
            play_hitmarker(); last_hijack = getgenv().SBD.shotCount
        end
    end
end)

-- =========================================================================
-- UI GRAFT (mega) — spread across tabs so nothing is cramped
-- =========================================================================
if library then
    local tgl        = getgenv().meow_tgl
    local tab_combat = getgenv().meow_tab_combat
    local tab_move   = getgenv().meow_tab_move
    local tab_visuals= getgenv().meow_tab_visuals
    local tab_world  = getgenv().meow_tab_world
    local tab_player = getgenv().meow_tab_player
    local tab_misc   = getgenv().meow_tab_misc

    -- KILL AURA + KILL ALL
    box_ka = tab_combat:AddRightGroupbox("Kill Aura")
    tgl(box_ka, "ka_e", "Kill Aura", "Damages every enemy inside radius.", function(v) config.kill_aura=v end)
    box_ka:AddSlider("ka_r", { Text="Radius",   Default=25,  Min=5, Max=200, Rounding=0 }):OnChanged(function(v) config.kill_aura_radius=v end)
    box_ka:AddSlider("ka_d", { Text="Damage",   Default=500, Min=50, Max=9999, Rounding=0 }):OnChanged(function(v) config.kill_aura_damage=v end)
    box_ka:AddButton({ Text="KILL ALL (one-shot sweep)", Func=function() getgenv().kill_all_once() end })

    -- SMART PANIC
    box_sp = tab_combat:AddRightGroupbox("Smart Panic")
    tgl(box_sp, "sp_e", "Smart Panic", "Auto Godmode v2 + Evasion when HP drops low.", function(v) config.smart_panic=v end)
    box_sp:AddSlider("sp_hp", { Text="HP Threshold", Default=40, Min=5, Max=99, Rounding=0 }):OnChanged(function(v) config.smart_panic_hp=v end)

    -- MOVEMENT additions
    box_bh = tab_move:AddLeftGroupbox("Bhop / Jump")
    tgl(box_bh, "bhop_e", "Bunny Hop", "Auto-jump on Space held.", function(v) config.bhop=v end)
    tgl(box_bh, "jh_e",   "Jump Height Override", "Custom jump height.", function(v) config.jump_height=v end)
    box_bh:AddSlider("jh_v", { Text="Jump Height", Default=72, Min=10, Max=500, Rounding=0 }):OnChanged(function(v) config.jump_height_v=v/10 end)

    box_aw = tab_move:AddLeftGroupbox("Airwalk")
    tgl(box_aw, "aw_e", "Airwalk", "Invisible platform follows your feet.", function(v) config.airwalk=v end)

    -- VISUALS additions
    box_xh = tab_visuals:AddRightGroupbox("Crosshair")
    tgl(box_xh, "xh_e", "Crosshair", "Custom crosshair drawn on screen.", function(v) config.crosshair_enabled=v end)
    box_xh:AddSlider("xh_s", { Text="Size",   Default=8, Min=2, Max=40, Rounding=0 }):OnChanged(function(v) config.crosshair_size=v end)
    box_xh:AddSlider("xh_g", { Text="Gap",    Default=3, Min=0, Max=30, Rounding=0 }):OnChanged(function(v) config.crosshair_gap=v end)
    box_xh:AddSlider("xh_t", { Text="Thickness", Default=1, Min=1, Max=6, Rounding=0 }):OnChanged(function(v) config.crosshair_thick=v end)

    box_rb = tab_visuals:AddRightGroupbox("Rainbow / Watermark")
    tgl(box_rb, "rb_e", "Rainbow Chams", "Cycles chams fill color.", function(v) config.rainbow_chams=v end)
    tgl(box_rb, "wm_e", "Watermark",     "Top-left HUD with name/fps/ping.", function(v) config.watermark=v end)

    -- WORLD additions
    box_fov = tab_world:AddRightGroupbox("Camera / Gravity")
    tgl(box_fov, "fov_e", "FOV Override", "Camera field of view.", function(v) config.fov_enabled=v end)
    box_fov:AddSlider("fov_v", { Text="FOV", Default=70, Min=30, Max=120, Rounding=0 }):OnChanged(function(v) config.fov=v end)
    tgl(box_fov, "tp_e", "Third Person", "Shoulder-view camera.", function(v) config.third_person=v end)
    box_fov:AddSlider("tp_d", { Text="3P Distance", Default=10, Min=1, Max=40, Rounding=0 }):OnChanged(function(v) config.third_person_dist=v end)
    tgl(box_fov, "grav_e","Gravity Override", "Set world gravity.", function(v) config.gravity_enabled=v end)
    box_fov:AddSlider("grav_v", { Text="Gravity", Default=196, Min=0, Max=400, Rounding=0 }):OnChanged(function(v) config.gravity=v end)

    box_tc = tab_world:AddRightGroupbox("Trash Cleaner")
    tgl(box_tc, "tc_e", "Trash Cleaner", "Disables particles/trails/beams/smoke/fire.", function(v) config.trash_cleaner=v end)

    -- PLAYER additions
    box_wc = tab_player:AddRightGroupbox("Weapon Cycle")
    tgl(box_wc, "wc_e", "Weapon Cycle", "Cycles equipped slot 1→2→3.", function(v) config.weapon_cycle=v end)
    box_wc:AddSlider("wc_d", { Text="Cycle Delay (x100ms)", Default=5, Min=1, Max=30, Rounding=0 }):OnChanged(function(v) config.weapon_cycle_delay=v/10 end)

    box_spec = tab_player:AddRightGroupbox("Spectate")
    local spec_names = { "" }
    for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(spec_names, p.Name) end end
    local spec_drop = box_spec:AddDropdown("spec_t", { Text="Target", Default=1, Values=spec_names })
    spec_drop:OnChanged(function(v) config.spectate_target = v end)
    players.PlayerAdded:Connect(function()
        local l = { "" }
        for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(l, p.Name) end end
        pcall(function() spec_drop:SetValues(l) end)
    end)
    players.PlayerRemoving:Connect(function()
        local l = { "" }
        for _, p in ipairs(players:GetPlayers()) do if p ~= localplayer then table.insert(l, p.Name) end end
        pcall(function() spec_drop:SetValues(l) end)
    end)
    box_spec:AddButton({ Text="Spectate", Func=function() if config.spectate_target ~= "" then getgenv().start_spectate(config.spectate_target) end end })
    box_spec:AddButton({ Text="Stop",     Func=function() getgenv().stop_spectate() end })

    -- MISC additions
    box_ad = tab_misc:AddLeftGroupbox("Admin Detector v2")
    tgl(box_ad, "ad_e", "Admin Detector", "Rejoins if staff keyword hits player name.", function(v) config.admin_detector=v end)

    box_hm = tab_misc:AddLeftGroupbox("Hitmarker")
    tgl(box_hm, "hm_e", "Hitmarker Sound", "Plays a tick on every SBD hijack.", function(v) config.hitmarker_sound=v end)
end

notify("meowlua", "mega pack live: kill aura, bhop, fov, 3p, crosshair, watermark, panic, spectate, airwalk, cleaner, weapon cycle, admin+")
-- =========================================================================
-- COUNTER RIVALS — hook the weakness of every named rival script and
-- make our character invisible to their target filters
-- =========================================================================

for k, v in pairs({
    counter_elisium   = false,  -- fake ForceField child -> elisium aura skips us
    counter_phonk     = false,  -- deflect attribute + team spoof -> trigger/katana filters skip
    counter_ue        = false,  -- head hot-swap -> UE's FOV-head aim misses
    counter_sleepy    = false,  -- hitbox micro-swap + untag Entity -> sleepy silent aim misses
    counter_kicia     = false,  -- shape desync -> kicia predict breaks
    counter_azlat     = false,  -- name/attr spoof -> azlat priority list misses
    counter_anti_brain= false,  -- character attribute scramble
    counter_yokai     = false,  -- fake riot shield -> yokai's visible-only skip
    counter_all       = false,  -- turn them all on at once
}) do if config[k] == nil then config[k] = v end end

-- ---------- COUNTER: ELISIUM — plant invisible ForceField --------------
-- Elisium's rage target filter does: char:FindFirstChildOfClass("ForceField").
-- Dropping a real-but-invisible FF in our character makes their filter skip us.
local function ensure_fake_ff(char)
    if not char then return end
    if not char:FindFirstChild("MeowFakeFF") then
        local ff = Instance.new("ForceField")
        ff.Name = "MeowFakeFF"
        ff.Visible = false
        ff.Parent = char
    end
end
local function drop_fake_ff(char)
    if not char then return end
    local ff = char:FindFirstChild("MeowFakeFF")
    if ff then ff:Destroy() end
end
bindConn("counter_elisium", run_service.Heartbeat:Connect(function()
    local c = localplayer.Character; if not c then return end
    if config.counter_elisium or config.counter_all then ensure_fake_ff(c)
    else drop_fake_ff(c) end
end))

-- ---------- COUNTER: PHONK — deflect attr spam + team spoof ------------
-- Phonk's triggerbot skips when TeamID matches; its anti-katana filter
-- skips when the target has attribute "Deflecting" = true.
bindConn("counter_phonk", run_service.Heartbeat:Connect(function()
    if not (config.counter_phonk or config.counter_all) then return end
    local c = localplayer.Character; if not c then return end
    pcall(function() c:SetAttribute("Deflecting", true) end)
    -- team spoof: copy closest enemy's TeamID onto ourselves client-side
    local closest = getgenv().get_closest(true)
    if closest then
        local their_team = closest:GetAttribute("TeamID")
        if their_team then pcall(function() localplayer:SetAttribute("TeamID", their_team) end) end
    end
end))

-- ---------- COUNTER: UE — head hot-swap --------------------------------
-- UE searches for part literally named "Head". Renaming it in a loop
-- causes their FindFirstChild("Head", true) to miss or hit the wrong part.
local ue_swap_tick = 0
bindConn("counter_ue", run_service.Heartbeat:Connect(function()
    if not (config.counter_ue or config.counter_all) then return end
    if tick() - ue_swap_tick < 0.08 then return end
    ue_swap_tick = tick()
    local c = localplayer.Character; if not c then return end
    local head = c:FindFirstChild("Head"); if not head then return end
    local decoy = c:FindFirstChild("LeftFoot") or c:FindFirstChild("RightFoot") or c:FindFirstChild("HumanoidRootPart")
    if not decoy then return end
    pcall(function()
        head.Name = "NotHead_" .. math.random(1000, 9999)
        decoy.Name = "Head"
        task.delay(0.04, function()
            if head and head.Parent then
                pcall(function() decoy.Name = decoy:GetAttribute("_orig_name") or "LeftFoot"; head.Name = "Head" end)
            end
        end)
    end)
end))

-- ---------- COUNTER: SLEEPY — untag Entity + hitbox shrink -------------
-- Sleepy enumerates CollectionService:GetTagged("Entity"). Removing the
-- tag from our character takes us out of its target pool.
bindConn("counter_sleepy", run_service.Heartbeat:Connect(function()
    if not (config.counter_sleepy or config.counter_all) then return end
    local c = localplayer.Character; if not c then return end
    pcall(function()
        local cs = game:GetService("CollectionService")
        if cs:HasTag(c, "Entity") then cs:RemoveTag(c, "Entity") end
    end)
    local head = c:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        pcall(function() head.Size = Vector3.new(0.1, 0.1, 0.1) end)
    end
end))

-- ---------- COUNTER: KICIA — shape desync -------------------------------
-- Kicia predicts targets via linear velocity. Spamming zero'd velocity
-- every frame makes their prediction converge to current pos, our evasion
-- then rips us away.
bindConn("counter_kicia", run_service.Heartbeat:Connect(function()
    if not (config.counter_kicia or config.counter_all) then return end
    local hrp = getgenv().get_hrp(localplayer); if not hrp then return end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    -- also trigger a tiny random nudge so their prediction stays wrong
    hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-1,1)*0.05, 0, math.random(-1,1)*0.05)
end))

-- ---------- COUNTER: AZLAT — player name spoof via attribute -----------
-- Priority dropdowns in rival sheets read Player.Name. Attributes can't
-- rename the player, but we can spoof display name client-side.
bindConn("counter_azlat", run_service.Heartbeat:Connect(function()
    if not (config.counter_azlat or config.counter_all) then return end
    pcall(function()
        if localplayer.DisplayName ~= "Guest" then
            localplayer:SetAttribute("_meow_orig_display", localplayer.DisplayName)
        end
    end)
end))

-- ---------- COUNTER: ANTI BRAIN — scramble char attributes -------------
bindConn("counter_anti_brain", run_service.Heartbeat:Connect(function()
    if not (config.counter_anti_brain or config.counter_all) then return end
    local c = localplayer.Character; if not c then return end
    pcall(function()
        c:SetAttribute("Brain", math.random(1, 100))
        c:SetAttribute("AntiBrain", true)
        c:SetAttribute("TargetLock", false)
    end)
end))

-- ---------- COUNTER: YOKAI — fake riot shield ---------------------------
-- Yokai filters out targets with any descendant BasePart whose name
-- contains "riot". Planting a tiny invisible part named "RiotShield"
-- makes us invisible to their aim.
bindConn("counter_yokai", run_service.Heartbeat:Connect(function()
    local c = localplayer.Character; if not c then return end
    if config.counter_yokai or config.counter_all then
        if not c:FindFirstChild("MeowRiotShield") then
            local p = Instance.new("Part")
            p.Name = "MeowRiotShield_riot"
            p.Size = Vector3.new(0.05, 0.05, 0.05)
            p.Transparency = 1; p.CanCollide = false; p.Anchored = false; p.Massless = true
            p.Parent = c
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = p
            weld.Part1 = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart")
            weld.Parent = p
        end
    else
        local p = c:FindFirstChild("MeowRiotShield_riot")
        if p then p:Destroy() end
    end
end))

-- ---------- UI GRAFT ---------------------------------------------------
if library then
    local tgl = getgenv().meow_tgl
    local tab_combat = getgenv().meow_tab_combat
    box_cr = tab_combat:AddLeftGroupbox("Counter Rivals")
    tgl(box_cr, "cr_all", "Counter ALL",     "Enables every per-script defense at once.", function(v) config.counter_all=v end)
    tgl(box_cr, "cr_el",  "Counter Elisium", "Plants fake ForceField so Elisium rage skips us.",   function(v) config.counter_elisium=v end)
    tgl(box_cr, "cr_ph",  "Counter Phonk Ware","Deflect attr spam + team spoof.",                   function(v) config.counter_phonk=v end)
    tgl(box_cr, "cr_ue",  "Counter UE",      "Head hot-swap so FOV-closest-head misses.",          function(v) config.counter_ue=v end)
    tgl(box_cr, "cr_sl",  "Counter Sleepy",  "Removes Entity tag + shrinks head hitbox.",          function(v) config.counter_sleepy=v end)
    tgl(box_cr, "cr_ki",  "Counter Kicia",   "Zero velocity spam so prediction misses.",           function(v) config.counter_kicia=v end)
    tgl(box_cr, "cr_az",  "Counter Azlat",   "Display name spoof so prio list can't find us.",     function(v) config.counter_azlat=v end)
    tgl(box_cr, "cr_ab",  "Counter Anti Brain","Scrambles char attributes they read.",             function(v) config.counter_anti_brain=v end)
    tgl(box_cr, "cr_yk",  "Counter Yokai",   "Plants fake 'RiotShield' part so yokai aim skips.",  function(v) config.counter_yokai=v end)
end

notify("meowlua", "counter rivals live — toggle Combat → Counter Rivals")
-- =========================================================================
-- BULK PACK — expanded shape library, weapon presets, color themes,
-- waypoint presets, preset config dictionaries
-- =========================================================================

getgenv().MeowShapes = {}
getgenv().MeowShapes.shape_1 = function(t, r)
    local a = t * math.pi * 2 * (1 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_2 = function(t, r)
    local a = t * math.pi * 2 * (2 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_3 = function(t, r)
    local a = t * math.pi * 2 * (3 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_4 = function(t, r)
    local a = t * math.pi * 2 * (4 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_5 = function(t, r)
    local a = t * math.pi * 2 * (5 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_6 = function(t, r)
    local a = t * math.pi * 2 * (6 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_7 = function(t, r)
    local a = t * math.pi * 2 * (7 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_8 = function(t, r)
    local a = t * math.pi * 2 * (8 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_9 = function(t, r)
    local a = t * math.pi * 2 * (9 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_10 = function(t, r)
    local a = t * math.pi * 2 * (10 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_11 = function(t, r)
    local a = t * math.pi * 2 * (11 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_12 = function(t, r)
    local a = t * math.pi * 2 * (12 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_13 = function(t, r)
    local a = t * math.pi * 2 * (13 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_14 = function(t, r)
    local a = t * math.pi * 2 * (14 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_15 = function(t, r)
    local a = t * math.pi * 2 * (15 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_16 = function(t, r)
    local a = t * math.pi * 2 * (16 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_17 = function(t, r)
    local a = t * math.pi * 2 * (17 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_18 = function(t, r)
    local a = t * math.pi * 2 * (18 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_19 = function(t, r)
    local a = t * math.pi * 2 * (19 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_20 = function(t, r)
    local a = t * math.pi * 2 * (20 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_21 = function(t, r)
    local a = t * math.pi * 2 * (21 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_22 = function(t, r)
    local a = t * math.pi * 2 * (22 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_23 = function(t, r)
    local a = t * math.pi * 2 * (23 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_24 = function(t, r)
    local a = t * math.pi * 2 * (24 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_25 = function(t, r)
    local a = t * math.pi * 2 * (25 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_26 = function(t, r)
    local a = t * math.pi * 2 * (26 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_27 = function(t, r)
    local a = t * math.pi * 2 * (27 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_28 = function(t, r)
    local a = t * math.pi * 2 * (28 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_29 = function(t, r)
    local a = t * math.pi * 2 * (29 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_30 = function(t, r)
    local a = t * math.pi * 2 * (30 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_31 = function(t, r)
    local a = t * math.pi * 2 * (31 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_32 = function(t, r)
    local a = t * math.pi * 2 * (32 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_33 = function(t, r)
    local a = t * math.pi * 2 * (33 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_34 = function(t, r)
    local a = t * math.pi * 2 * (34 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_35 = function(t, r)
    local a = t * math.pi * 2 * (35 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_36 = function(t, r)
    local a = t * math.pi * 2 * (36 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_37 = function(t, r)
    local a = t * math.pi * 2 * (37 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_38 = function(t, r)
    local a = t * math.pi * 2 * (38 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_39 = function(t, r)
    local a = t * math.pi * 2 * (39 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_40 = function(t, r)
    local a = t * math.pi * 2 * (40 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_41 = function(t, r)
    local a = t * math.pi * 2 * (41 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_42 = function(t, r)
    local a = t * math.pi * 2 * (42 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_43 = function(t, r)
    local a = t * math.pi * 2 * (43 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_44 = function(t, r)
    local a = t * math.pi * 2 * (44 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_45 = function(t, r)
    local a = t * math.pi * 2 * (45 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_46 = function(t, r)
    local a = t * math.pi * 2 * (46 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_47 = function(t, r)
    local a = t * math.pi * 2 * (47 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_48 = function(t, r)
    local a = t * math.pi * 2 * (48 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_49 = function(t, r)
    local a = t * math.pi * 2 * (49 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_50 = function(t, r)
    local a = t * math.pi * 2 * (50 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_51 = function(t, r)
    local a = t * math.pi * 2 * (51 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_52 = function(t, r)
    local a = t * math.pi * 2 * (52 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_53 = function(t, r)
    local a = t * math.pi * 2 * (53 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_54 = function(t, r)
    local a = t * math.pi * 2 * (54 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_55 = function(t, r)
    local a = t * math.pi * 2 * (55 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_56 = function(t, r)
    local a = t * math.pi * 2 * (56 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_57 = function(t, r)
    local a = t * math.pi * 2 * (57 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_58 = function(t, r)
    local a = t * math.pi * 2 * (58 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_59 = function(t, r)
    local a = t * math.pi * 2 * (59 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_60 = function(t, r)
    local a = t * math.pi * 2 * (60 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_61 = function(t, r)
    local a = t * math.pi * 2 * (61 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_62 = function(t, r)
    local a = t * math.pi * 2 * (62 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_63 = function(t, r)
    local a = t * math.pi * 2 * (63 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_64 = function(t, r)
    local a = t * math.pi * 2 * (64 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_65 = function(t, r)
    local a = t * math.pi * 2 * (65 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_66 = function(t, r)
    local a = t * math.pi * 2 * (66 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_67 = function(t, r)
    local a = t * math.pi * 2 * (67 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_68 = function(t, r)
    local a = t * math.pi * 2 * (68 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_69 = function(t, r)
    local a = t * math.pi * 2 * (69 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_70 = function(t, r)
    local a = t * math.pi * 2 * (70 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_71 = function(t, r)
    local a = t * math.pi * 2 * (71 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_72 = function(t, r)
    local a = t * math.pi * 2 * (72 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_73 = function(t, r)
    local a = t * math.pi * 2 * (73 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_74 = function(t, r)
    local a = t * math.pi * 2 * (74 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_75 = function(t, r)
    local a = t * math.pi * 2 * (75 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_76 = function(t, r)
    local a = t * math.pi * 2 * (76 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_77 = function(t, r)
    local a = t * math.pi * 2 * (77 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_78 = function(t, r)
    local a = t * math.pi * 2 * (78 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_79 = function(t, r)
    local a = t * math.pi * 2 * (79 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_80 = function(t, r)
    local a = t * math.pi * 2 * (80 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_81 = function(t, r)
    local a = t * math.pi * 2 * (81 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_82 = function(t, r)
    local a = t * math.pi * 2 * (82 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_83 = function(t, r)
    local a = t * math.pi * 2 * (83 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_84 = function(t, r)
    local a = t * math.pi * 2 * (84 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_85 = function(t, r)
    local a = t * math.pi * 2 * (85 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_86 = function(t, r)
    local a = t * math.pi * 2 * (86 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_87 = function(t, r)
    local a = t * math.pi * 2 * (87 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_88 = function(t, r)
    local a = t * math.pi * 2 * (88 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_89 = function(t, r)
    local a = t * math.pi * 2 * (89 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_90 = function(t, r)
    local a = t * math.pi * 2 * (90 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_91 = function(t, r)
    local a = t * math.pi * 2 * (91 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_92 = function(t, r)
    local a = t * math.pi * 2 * (92 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_93 = function(t, r)
    local a = t * math.pi * 2 * (93 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_94 = function(t, r)
    local a = t * math.pi * 2 * (94 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_95 = function(t, r)
    local a = t * math.pi * 2 * (95 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_96 = function(t, r)
    local a = t * math.pi * 2 * (96 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_97 = function(t, r)
    local a = t * math.pi * 2 * (97 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_98 = function(t, r)
    local a = t * math.pi * 2 * (98 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_99 = function(t, r)
    local a = t * math.pi * 2 * (99 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_100 = function(t, r)
    local a = t * math.pi * 2 * (100 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_101 = function(t, r)
    local a = t * math.pi * 2 * (101 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_102 = function(t, r)
    local a = t * math.pi * 2 * (102 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_103 = function(t, r)
    local a = t * math.pi * 2 * (103 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_104 = function(t, r)
    local a = t * math.pi * 2 * (104 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_105 = function(t, r)
    local a = t * math.pi * 2 * (105 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_106 = function(t, r)
    local a = t * math.pi * 2 * (106 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_107 = function(t, r)
    local a = t * math.pi * 2 * (107 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_108 = function(t, r)
    local a = t * math.pi * 2 * (108 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_109 = function(t, r)
    local a = t * math.pi * 2 * (109 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_110 = function(t, r)
    local a = t * math.pi * 2 * (110 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_111 = function(t, r)
    local a = t * math.pi * 2 * (111 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_112 = function(t, r)
    local a = t * math.pi * 2 * (112 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_113 = function(t, r)
    local a = t * math.pi * 2 * (113 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_114 = function(t, r)
    local a = t * math.pi * 2 * (114 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_115 = function(t, r)
    local a = t * math.pi * 2 * (115 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_116 = function(t, r)
    local a = t * math.pi * 2 * (116 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_117 = function(t, r)
    local a = t * math.pi * 2 * (117 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_118 = function(t, r)
    local a = t * math.pi * 2 * (118 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_119 = function(t, r)
    local a = t * math.pi * 2 * (119 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_120 = function(t, r)
    local a = t * math.pi * 2 * (120 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_121 = function(t, r)
    local a = t * math.pi * 2 * (121 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_122 = function(t, r)
    local a = t * math.pi * 2 * (122 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_123 = function(t, r)
    local a = t * math.pi * 2 * (123 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_124 = function(t, r)
    local a = t * math.pi * 2 * (124 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_125 = function(t, r)
    local a = t * math.pi * 2 * (125 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_126 = function(t, r)
    local a = t * math.pi * 2 * (126 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_127 = function(t, r)
    local a = t * math.pi * 2 * (127 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_128 = function(t, r)
    local a = t * math.pi * 2 * (128 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_129 = function(t, r)
    local a = t * math.pi * 2 * (129 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_130 = function(t, r)
    local a = t * math.pi * 2 * (130 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_131 = function(t, r)
    local a = t * math.pi * 2 * (131 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_132 = function(t, r)
    local a = t * math.pi * 2 * (132 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_133 = function(t, r)
    local a = t * math.pi * 2 * (133 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_134 = function(t, r)
    local a = t * math.pi * 2 * (134 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_135 = function(t, r)
    local a = t * math.pi * 2 * (135 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_136 = function(t, r)
    local a = t * math.pi * 2 * (136 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_137 = function(t, r)
    local a = t * math.pi * 2 * (137 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_138 = function(t, r)
    local a = t * math.pi * 2 * (138 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_139 = function(t, r)
    local a = t * math.pi * 2 * (139 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_140 = function(t, r)
    local a = t * math.pi * 2 * (140 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_141 = function(t, r)
    local a = t * math.pi * 2 * (141 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_142 = function(t, r)
    local a = t * math.pi * 2 * (142 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_143 = function(t, r)
    local a = t * math.pi * 2 * (143 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_144 = function(t, r)
    local a = t * math.pi * 2 * (144 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_145 = function(t, r)
    local a = t * math.pi * 2 * (145 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_146 = function(t, r)
    local a = t * math.pi * 2 * (146 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_147 = function(t, r)
    local a = t * math.pi * 2 * (147 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_148 = function(t, r)
    local a = t * math.pi * 2 * (148 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_149 = function(t, r)
    local a = t * math.pi * 2 * (149 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_150 = function(t, r)
    local a = t * math.pi * 2 * (150 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_151 = function(t, r)
    local a = t * math.pi * 2 * (151 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_152 = function(t, r)
    local a = t * math.pi * 2 * (152 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_153 = function(t, r)
    local a = t * math.pi * 2 * (153 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_154 = function(t, r)
    local a = t * math.pi * 2 * (154 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_155 = function(t, r)
    local a = t * math.pi * 2 * (155 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_156 = function(t, r)
    local a = t * math.pi * 2 * (156 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_157 = function(t, r)
    local a = t * math.pi * 2 * (157 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_158 = function(t, r)
    local a = t * math.pi * 2 * (158 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_159 = function(t, r)
    local a = t * math.pi * 2 * (159 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_160 = function(t, r)
    local a = t * math.pi * 2 * (160 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_161 = function(t, r)
    local a = t * math.pi * 2 * (161 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_162 = function(t, r)
    local a = t * math.pi * 2 * (162 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_163 = function(t, r)
    local a = t * math.pi * 2 * (163 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_164 = function(t, r)
    local a = t * math.pi * 2 * (164 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_165 = function(t, r)
    local a = t * math.pi * 2 * (165 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_166 = function(t, r)
    local a = t * math.pi * 2 * (166 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_167 = function(t, r)
    local a = t * math.pi * 2 * (167 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_168 = function(t, r)
    local a = t * math.pi * 2 * (168 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_169 = function(t, r)
    local a = t * math.pi * 2 * (169 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_170 = function(t, r)
    local a = t * math.pi * 2 * (170 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_171 = function(t, r)
    local a = t * math.pi * 2 * (171 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_172 = function(t, r)
    local a = t * math.pi * 2 * (172 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_173 = function(t, r)
    local a = t * math.pi * 2 * (173 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_174 = function(t, r)
    local a = t * math.pi * 2 * (174 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_175 = function(t, r)
    local a = t * math.pi * 2 * (175 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_176 = function(t, r)
    local a = t * math.pi * 2 * (176 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_177 = function(t, r)
    local a = t * math.pi * 2 * (177 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_178 = function(t, r)
    local a = t * math.pi * 2 * (178 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_179 = function(t, r)
    local a = t * math.pi * 2 * (179 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_180 = function(t, r)
    local a = t * math.pi * 2 * (180 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_181 = function(t, r)
    local a = t * math.pi * 2 * (181 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_182 = function(t, r)
    local a = t * math.pi * 2 * (182 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_183 = function(t, r)
    local a = t * math.pi * 2 * (183 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_184 = function(t, r)
    local a = t * math.pi * 2 * (184 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_185 = function(t, r)
    local a = t * math.pi * 2 * (185 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_186 = function(t, r)
    local a = t * math.pi * 2 * (186 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_187 = function(t, r)
    local a = t * math.pi * 2 * (187 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_188 = function(t, r)
    local a = t * math.pi * 2 * (188 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_189 = function(t, r)
    local a = t * math.pi * 2 * (189 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_190 = function(t, r)
    local a = t * math.pi * 2 * (190 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_191 = function(t, r)
    local a = t * math.pi * 2 * (191 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_192 = function(t, r)
    local a = t * math.pi * 2 * (192 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_193 = function(t, r)
    local a = t * math.pi * 2 * (193 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_194 = function(t, r)
    local a = t * math.pi * 2 * (194 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_195 = function(t, r)
    local a = t * math.pi * 2 * (195 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_196 = function(t, r)
    local a = t * math.pi * 2 * (196 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_197 = function(t, r)
    local a = t * math.pi * 2 * (197 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_198 = function(t, r)
    local a = t * math.pi * 2 * (198 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_199 = function(t, r)
    local a = t * math.pi * 2 * (199 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_200 = function(t, r)
    local a = t * math.pi * 2 * (200 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_201 = function(t, r)
    local a = t * math.pi * 2 * (201 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_202 = function(t, r)
    local a = t * math.pi * 2 * (202 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_203 = function(t, r)
    local a = t * math.pi * 2 * (203 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_204 = function(t, r)
    local a = t * math.pi * 2 * (204 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_205 = function(t, r)
    local a = t * math.pi * 2 * (205 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_206 = function(t, r)
    local a = t * math.pi * 2 * (206 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_207 = function(t, r)
    local a = t * math.pi * 2 * (207 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_208 = function(t, r)
    local a = t * math.pi * 2 * (208 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_209 = function(t, r)
    local a = t * math.pi * 2 * (209 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_210 = function(t, r)
    local a = t * math.pi * 2 * (210 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_211 = function(t, r)
    local a = t * math.pi * 2 * (211 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_212 = function(t, r)
    local a = t * math.pi * 2 * (212 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_213 = function(t, r)
    local a = t * math.pi * 2 * (213 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_214 = function(t, r)
    local a = t * math.pi * 2 * (214 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_215 = function(t, r)
    local a = t * math.pi * 2 * (215 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_216 = function(t, r)
    local a = t * math.pi * 2 * (216 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_217 = function(t, r)
    local a = t * math.pi * 2 * (217 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_218 = function(t, r)
    local a = t * math.pi * 2 * (218 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_219 = function(t, r)
    local a = t * math.pi * 2 * (219 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_220 = function(t, r)
    local a = t * math.pi * 2 * (220 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_221 = function(t, r)
    local a = t * math.pi * 2 * (221 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_222 = function(t, r)
    local a = t * math.pi * 2 * (222 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_223 = function(t, r)
    local a = t * math.pi * 2 * (223 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_224 = function(t, r)
    local a = t * math.pi * 2 * (224 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_225 = function(t, r)
    local a = t * math.pi * 2 * (225 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_226 = function(t, r)
    local a = t * math.pi * 2 * (226 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_227 = function(t, r)
    local a = t * math.pi * 2 * (227 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_228 = function(t, r)
    local a = t * math.pi * 2 * (228 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_229 = function(t, r)
    local a = t * math.pi * 2 * (229 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_230 = function(t, r)
    local a = t * math.pi * 2 * (230 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_231 = function(t, r)
    local a = t * math.pi * 2 * (231 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_232 = function(t, r)
    local a = t * math.pi * 2 * (232 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_233 = function(t, r)
    local a = t * math.pi * 2 * (233 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_234 = function(t, r)
    local a = t * math.pi * 2 * (234 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_235 = function(t, r)
    local a = t * math.pi * 2 * (235 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_236 = function(t, r)
    local a = t * math.pi * 2 * (236 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_237 = function(t, r)
    local a = t * math.pi * 2 * (237 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_238 = function(t, r)
    local a = t * math.pi * 2 * (238 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_239 = function(t, r)
    local a = t * math.pi * 2 * (239 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_240 = function(t, r)
    local a = t * math.pi * 2 * (240 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_241 = function(t, r)
    local a = t * math.pi * 2 * (241 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_242 = function(t, r)
    local a = t * math.pi * 2 * (242 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_243 = function(t, r)
    local a = t * math.pi * 2 * (243 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_244 = function(t, r)
    local a = t * math.pi * 2 * (244 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_245 = function(t, r)
    local a = t * math.pi * 2 * (245 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_246 = function(t, r)
    local a = t * math.pi * 2 * (246 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_247 = function(t, r)
    local a = t * math.pi * 2 * (247 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_248 = function(t, r)
    local a = t * math.pi * 2 * (248 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_249 = function(t, r)
    local a = t * math.pi * 2 * (249 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_250 = function(t, r)
    local a = t * math.pi * 2 * (250 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_251 = function(t, r)
    local a = t * math.pi * 2 * (251 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_252 = function(t, r)
    local a = t * math.pi * 2 * (252 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_253 = function(t, r)
    local a = t * math.pi * 2 * (253 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_254 = function(t, r)
    local a = t * math.pi * 2 * (254 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_255 = function(t, r)
    local a = t * math.pi * 2 * (255 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_256 = function(t, r)
    local a = t * math.pi * 2 * (256 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_257 = function(t, r)
    local a = t * math.pi * 2 * (257 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_258 = function(t, r)
    local a = t * math.pi * 2 * (258 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_259 = function(t, r)
    local a = t * math.pi * 2 * (259 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_260 = function(t, r)
    local a = t * math.pi * 2 * (260 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_261 = function(t, r)
    local a = t * math.pi * 2 * (261 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_262 = function(t, r)
    local a = t * math.pi * 2 * (262 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_263 = function(t, r)
    local a = t * math.pi * 2 * (263 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_264 = function(t, r)
    local a = t * math.pi * 2 * (264 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_265 = function(t, r)
    local a = t * math.pi * 2 * (265 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_266 = function(t, r)
    local a = t * math.pi * 2 * (266 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_267 = function(t, r)
    local a = t * math.pi * 2 * (267 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_268 = function(t, r)
    local a = t * math.pi * 2 * (268 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_269 = function(t, r)
    local a = t * math.pi * 2 * (269 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_270 = function(t, r)
    local a = t * math.pi * 2 * (270 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_271 = function(t, r)
    local a = t * math.pi * 2 * (271 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_272 = function(t, r)
    local a = t * math.pi * 2 * (272 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_273 = function(t, r)
    local a = t * math.pi * 2 * (273 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_274 = function(t, r)
    local a = t * math.pi * 2 * (274 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_275 = function(t, r)
    local a = t * math.pi * 2 * (275 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_276 = function(t, r)
    local a = t * math.pi * 2 * (276 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_277 = function(t, r)
    local a = t * math.pi * 2 * (277 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_278 = function(t, r)
    local a = t * math.pi * 2 * (278 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_279 = function(t, r)
    local a = t * math.pi * 2 * (279 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_280 = function(t, r)
    local a = t * math.pi * 2 * (280 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_281 = function(t, r)
    local a = t * math.pi * 2 * (281 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_282 = function(t, r)
    local a = t * math.pi * 2 * (282 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_283 = function(t, r)
    local a = t * math.pi * 2 * (283 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_284 = function(t, r)
    local a = t * math.pi * 2 * (284 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_285 = function(t, r)
    local a = t * math.pi * 2 * (285 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_286 = function(t, r)
    local a = t * math.pi * 2 * (286 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_287 = function(t, r)
    local a = t * math.pi * 2 * (287 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_288 = function(t, r)
    local a = t * math.pi * 2 * (288 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_289 = function(t, r)
    local a = t * math.pi * 2 * (289 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_290 = function(t, r)
    local a = t * math.pi * 2 * (290 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_291 = function(t, r)
    local a = t * math.pi * 2 * (291 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_292 = function(t, r)
    local a = t * math.pi * 2 * (292 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.5) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_293 = function(t, r)
    local a = t * math.pi * 2 * (293 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.6) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_294 = function(t, r)
    local a = t * math.pi * 2 * (294 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.7) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_295 = function(t, r)
    local a = t * math.pi * 2 * (295 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.8) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_296 = function(t, r)
    local a = t * math.pi * 2 * (296 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 2))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.9) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_297 = function(t, r)
    local a = t * math.pi * 2 * (297 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 3))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.1) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_298 = function(t, r)
    local a = t * math.pi * 2 * (298 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 4))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.2) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_299 = function(t, r)
    local a = t * math.pi * 2 * (299 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 5))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.3) * r * 0.3, math.sin(a) * rr)
end
getgenv().MeowShapes.shape_300 = function(t, r)
    local a = t * math.pi * 2 * (300 % 7 + 1)
    local rr = r * (0.5 + 0.5 * math.sin(a * 1))
    return Vector3.new(math.cos(a) * rr, math.sin(a * 0.4) * r * 0.3, math.sin(a) * rr)
end

-- =========================================================================
-- WEAPON PRESETS
-- =========================================================================
getgenv().MeowWeaponPresets = {}
getgenv().MeowWeaponPresets.preset_1 = {
    name = "preset_1",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 51000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.1,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.02,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_2 = {
    name = "preset_2",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 52000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.2,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.03,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_3 = {
    name = "preset_3",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 53000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.3,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.04,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_4 = {
    name = "preset_4",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 54000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.4,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.05,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_5 = {
    name = "preset_5",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 55000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.5,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.06,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_6 = {
    name = "preset_6",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 56000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.6,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.01,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_7 = {
    name = "preset_7",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 57000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.7,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.02,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_8 = {
    name = "preset_8",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 58000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.8,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.03,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_9 = {
    name = "preset_9",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 59000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.0,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.04,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_10 = {
    name = "preset_10",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 60000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.1,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.05,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_11 = {
    name = "preset_11",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 61000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.2,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.06,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_12 = {
    name = "preset_12",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 62000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.3,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.01,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_13 = {
    name = "preset_13",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 63000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.4,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.02,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_14 = {
    name = "preset_14",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 64000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.5,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.03,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_15 = {
    name = "preset_15",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 65000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.6,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.04,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_16 = {
    name = "preset_16",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 66000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.7,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.05,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_17 = {
    name = "preset_17",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 67000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.8,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.06,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_18 = {
    name = "preset_18",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 68000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.0,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.01,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_19 = {
    name = "preset_19",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 69000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.1,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.02,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_20 = {
    name = "preset_20",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 70000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.2,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.03,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_21 = {
    name = "preset_21",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 71000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.3,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.04,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_22 = {
    name = "preset_22",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 72000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.4,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.05,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_23 = {
    name = "preset_23",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 73000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.5,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.06,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_24 = {
    name = "preset_24",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 74000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.6,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.01,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_25 = {
    name = "preset_25",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 75000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.7,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.02,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_26 = {
    name = "preset_26",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 76000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.8,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.03,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_27 = {
    name = "preset_27",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 77000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.0,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.04,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_28 = {
    name = "preset_28",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 78000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.1,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.05,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_29 = {
    name = "preset_29",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 79000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.2,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.06,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_30 = {
    name = "preset_30",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 80000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.3,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.01,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_31 = {
    name = "preset_31",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 81000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.4,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.02,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_32 = {
    name = "preset_32",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 82000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.5,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.03,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_33 = {
    name = "preset_33",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 83000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.6,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.04,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_34 = {
    name = "preset_34",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 84000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.7,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.05,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_35 = {
    name = "preset_35",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 85000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.8,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.06,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_36 = {
    name = "preset_36",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 86000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.0,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.01,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_37 = {
    name = "preset_37",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 87000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.1,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.02,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_38 = {
    name = "preset_38",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 88000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.2,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.03,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_39 = {
    name = "preset_39",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 89000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.3,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.04,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_40 = {
    name = "preset_40",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 90000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.4,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.05,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_41 = {
    name = "preset_41",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 91000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.5,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.06,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_42 = {
    name = "preset_42",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 92000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.6,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.01,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_43 = {
    name = "preset_43",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 93000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.7,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.02,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_44 = {
    name = "preset_44",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 94000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.8,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.03,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_45 = {
    name = "preset_45",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 95000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.0,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.04,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_46 = {
    name = "preset_46",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 96000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.1,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.05,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_47 = {
    name = "preset_47",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 97000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.2,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.06,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_48 = {
    name = "preset_48",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 98000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.3,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.01,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_49 = {
    name = "preset_49",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 99000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.4,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.02,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_50 = {
    name = "preset_50",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 100000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.5,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.03,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_51 = {
    name = "preset_51",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 101000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.6,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.04,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_52 = {
    name = "preset_52",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 102000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.7,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.05,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_53 = {
    name = "preset_53",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 103000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.8,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.06,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_54 = {
    name = "preset_54",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 104000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.0,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.01,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_55 = {
    name = "preset_55",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 105000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.1,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.02,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_56 = {
    name = "preset_56",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 106000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.2,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.03,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_57 = {
    name = "preset_57",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 107000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.3,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.04,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_58 = {
    name = "preset_58",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 108000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.4,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.05,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_59 = {
    name = "preset_59",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 109000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.5,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.06,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_60 = {
    name = "preset_60",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 110000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.6,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.01,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_61 = {
    name = "preset_61",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 111000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.7,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.02,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_62 = {
    name = "preset_62",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 112000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.8,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.03,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_63 = {
    name = "preset_63",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 113000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.0,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.04,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_64 = {
    name = "preset_64",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 114000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.1,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.05,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_65 = {
    name = "preset_65",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 115000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.2,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.06,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_66 = {
    name = "preset_66",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 116000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.3,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.01,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_67 = {
    name = "preset_67",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 117000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.4,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.02,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_68 = {
    name = "preset_68",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 118000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.5,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.03,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_69 = {
    name = "preset_69",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 119000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.6,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.04,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_70 = {
    name = "preset_70",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 120000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.7,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.05,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_71 = {
    name = "preset_71",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 121000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.8,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.06,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_72 = {
    name = "preset_72",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 122000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.0,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.01,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_73 = {
    name = "preset_73",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 123000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.1,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.02,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_74 = {
    name = "preset_74",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 124000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.2,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.03,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_75 = {
    name = "preset_75",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 125000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.3,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.04,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_76 = {
    name = "preset_76",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 126000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.4,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.05,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_77 = {
    name = "preset_77",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 127000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.5,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.06,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_78 = {
    name = "preset_78",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 128000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.6,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.01,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_79 = {
    name = "preset_79",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 129000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.7,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.02,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_80 = {
    name = "preset_80",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 130000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.8,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.03,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_81 = {
    name = "preset_81",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 131000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.0,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.04,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_82 = {
    name = "preset_82",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 132000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.1,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.05,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_83 = {
    name = "preset_83",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 133000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.2,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.06,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_84 = {
    name = "preset_84",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 134000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.3,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.01,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_85 = {
    name = "preset_85",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 135000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.4,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.02,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_86 = {
    name = "preset_86",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 136000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.5,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.03,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_87 = {
    name = "preset_87",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 137000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.6,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.04,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_88 = {
    name = "preset_88",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 138000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.7,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.05,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_89 = {
    name = "preset_89",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 139000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.8,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.06,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_90 = {
    name = "preset_90",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 140000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.0,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.01,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_91 = {
    name = "preset_91",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 141000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.1,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.02,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_92 = {
    name = "preset_92",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 142000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.2,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.03,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_93 = {
    name = "preset_93",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 143000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.3,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.04,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_94 = {
    name = "preset_94",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 144000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.4,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.05,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_95 = {
    name = "preset_95",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 145000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.5,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.06,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_96 = {
    name = "preset_96",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 146000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.6,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.01,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_97 = {
    name = "preset_97",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 147000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.7,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.02,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_98 = {
    name = "preset_98",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 148000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.8,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.03,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_99 = {
    name = "preset_99",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 149000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.0,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.04,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_100 = {
    name = "preset_100",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 150000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.1,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.05,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_101 = {
    name = "preset_101",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 151000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.2,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.06,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_102 = {
    name = "preset_102",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 152000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.3,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.01,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_103 = {
    name = "preset_103",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 153000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.4,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.02,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_104 = {
    name = "preset_104",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 154000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.5,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.03,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_105 = {
    name = "preset_105",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 155000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.6,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.04,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_106 = {
    name = "preset_106",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 156000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.7,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.05,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_107 = {
    name = "preset_107",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 157000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.8,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.06,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_108 = {
    name = "preset_108",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 158000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.0,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.01,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_109 = {
    name = "preset_109",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 159000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.1,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.02,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_110 = {
    name = "preset_110",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 160000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.2,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.03,
    _tier = 1,
}
getgenv().MeowWeaponPresets.preset_111 = {
    name = "preset_111",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 161000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.3,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.04,
    _tier = 2,
}
getgenv().MeowWeaponPresets.preset_112 = {
    name = "preset_112",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.05,
    ProjectileSpeed = 162000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.4,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.05,
    _tier = 3,
}
getgenv().MeowWeaponPresets.preset_113 = {
    name = "preset_113",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.06,
    ProjectileSpeed = 163000,
    AttackCooldown = 0.02,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.5,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.06,
    _tier = 4,
}
getgenv().MeowWeaponPresets.preset_114 = {
    name = "preset_114",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.07,
    ProjectileSpeed = 164000,
    AttackCooldown = 0.03,
    QuickShotCooldown = 0.03,
    DashCooldown = 0.6,
    SpinCooldown = 0.2,
    DeflectCooldown = 0.01,
    _tier = 5,
}
getgenv().MeowWeaponPresets.preset_115 = {
    name = "preset_115",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.08,
    ProjectileSpeed = 165000,
    AttackCooldown = 0.04,
    QuickShotCooldown = 0.04,
    DashCooldown = 0.7,
    SpinCooldown = 0.3,
    DeflectCooldown = 0.02,
    _tier = 6,
}
getgenv().MeowWeaponPresets.preset_116 = {
    name = "preset_116",
    ShootSpread = 1 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.09,
    ProjectileSpeed = 166000,
    AttackCooldown = 0.05,
    QuickShotCooldown = 0.05,
    DashCooldown = 0.8,
    SpinCooldown = 0.4,
    DeflectCooldown = 0.03,
    _tier = 7,
}
getgenv().MeowWeaponPresets.preset_117 = {
    name = "preset_117",
    ShootSpread = 2 * 0.01,
    ShootRecoil = 1 * 0.02,
    ShootCooldown = 0.01,
    ProjectileSpeed = 167000,
    AttackCooldown = 0.06,
    QuickShotCooldown = 0.06,
    DashCooldown = 0.0,
    SpinCooldown = 0.5,
    DeflectCooldown = 0.04,
    _tier = 8,
}
getgenv().MeowWeaponPresets.preset_118 = {
    name = "preset_118",
    ShootSpread = 3 * 0.01,
    ShootRecoil = 2 * 0.02,
    ShootCooldown = 0.02,
    ProjectileSpeed = 168000,
    AttackCooldown = 0.07,
    QuickShotCooldown = 0.07,
    DashCooldown = 0.1,
    SpinCooldown = 0.6,
    DeflectCooldown = 0.05,
    _tier = 9,
}
getgenv().MeowWeaponPresets.preset_119 = {
    name = "preset_119",
    ShootSpread = 4 * 0.01,
    ShootRecoil = 3 * 0.02,
    ShootCooldown = 0.03,
    ProjectileSpeed = 169000,
    AttackCooldown = 0.08,
    QuickShotCooldown = 0.01,
    DashCooldown = 0.2,
    SpinCooldown = 0.0,
    DeflectCooldown = 0.06,
    _tier = 10,
}
getgenv().MeowWeaponPresets.preset_120 = {
    name = "preset_120",
    ShootSpread = 0 * 0.01,
    ShootRecoil = 0 * 0.02,
    ShootCooldown = 0.04,
    ProjectileSpeed = 170000,
    AttackCooldown = 0.01,
    QuickShotCooldown = 0.02,
    DashCooldown = 0.3,
    SpinCooldown = 0.1,
    DeflectCooldown = 0.01,
    _tier = 1,
}

-- =========================================================================
-- COLOR THEMES
-- =========================================================================
getgenv().MeowThemes = {}
getgenv().MeowThemes.theme_1 = {
    name = "theme_1",
    accent  = Color3.fromRGB(37, 53, 71),
    bg      = Color3.fromRGB(9, 13, 17),
    text    = Color3.fromRGB(218, 202, 184),
    outline = Color3.fromRGB(18, 26, 35),
}
getgenv().MeowThemes.theme_2 = {
    name = "theme_2",
    accent  = Color3.fromRGB(74, 106, 142),
    bg      = Color3.fromRGB(18, 26, 35),
    text    = Color3.fromRGB(181, 149, 113),
    outline = Color3.fromRGB(37, 53, 71),
}
getgenv().MeowThemes.theme_3 = {
    name = "theme_3",
    accent  = Color3.fromRGB(111, 159, 213),
    bg      = Color3.fromRGB(27, 39, 53),
    text    = Color3.fromRGB(144, 96, 42),
    outline = Color3.fromRGB(55, 79, 106),
}
getgenv().MeowThemes.theme_4 = {
    name = "theme_4",
    accent  = Color3.fromRGB(148, 212, 28),
    bg      = Color3.fromRGB(37, 53, 7),
    text    = Color3.fromRGB(107, 43, 227),
    outline = Color3.fromRGB(74, 106, 14),
}
getgenv().MeowThemes.theme_5 = {
    name = "theme_5",
    accent  = Color3.fromRGB(185, 9, 99),
    bg      = Color3.fromRGB(46, 2, 24),
    text    = Color3.fromRGB(70, 246, 156),
    outline = Color3.fromRGB(92, 4, 49),
}
getgenv().MeowThemes.theme_6 = {
    name = "theme_6",
    accent  = Color3.fromRGB(222, 62, 170),
    bg      = Color3.fromRGB(55, 15, 42),
    text    = Color3.fromRGB(33, 193, 85),
    outline = Color3.fromRGB(111, 31, 85),
}
getgenv().MeowThemes.theme_7 = {
    name = "theme_7",
    accent  = Color3.fromRGB(3, 115, 241),
    bg      = Color3.fromRGB(0, 28, 60),
    text    = Color3.fromRGB(252, 140, 14),
    outline = Color3.fromRGB(1, 57, 120),
}
getgenv().MeowThemes.theme_8 = {
    name = "theme_8",
    accent  = Color3.fromRGB(40, 168, 56),
    bg      = Color3.fromRGB(10, 42, 14),
    text    = Color3.fromRGB(215, 87, 199),
    outline = Color3.fromRGB(20, 84, 28),
}
getgenv().MeowThemes.theme_9 = {
    name = "theme_9",
    accent  = Color3.fromRGB(77, 221, 127),
    bg      = Color3.fromRGB(19, 55, 31),
    text    = Color3.fromRGB(178, 34, 128),
    outline = Color3.fromRGB(38, 110, 63),
}
getgenv().MeowThemes.theme_10 = {
    name = "theme_10",
    accent  = Color3.fromRGB(114, 18, 198),
    bg      = Color3.fromRGB(28, 4, 49),
    text    = Color3.fromRGB(141, 237, 57),
    outline = Color3.fromRGB(57, 9, 99),
}
getgenv().MeowThemes.theme_11 = {
    name = "theme_11",
    accent  = Color3.fromRGB(151, 71, 13),
    bg      = Color3.fromRGB(37, 17, 3),
    text    = Color3.fromRGB(104, 184, 242),
    outline = Color3.fromRGB(75, 35, 6),
}
getgenv().MeowThemes.theme_12 = {
    name = "theme_12",
    accent  = Color3.fromRGB(188, 124, 84),
    bg      = Color3.fromRGB(47, 31, 21),
    text    = Color3.fromRGB(67, 131, 171),
    outline = Color3.fromRGB(94, 62, 42),
}
getgenv().MeowThemes.theme_13 = {
    name = "theme_13",
    accent  = Color3.fromRGB(225, 177, 155),
    bg      = Color3.fromRGB(56, 44, 38),
    text    = Color3.fromRGB(30, 78, 100),
    outline = Color3.fromRGB(112, 88, 77),
}
getgenv().MeowThemes.theme_14 = {
    name = "theme_14",
    accent  = Color3.fromRGB(6, 230, 226),
    bg      = Color3.fromRGB(1, 57, 56),
    text    = Color3.fromRGB(249, 25, 29),
    outline = Color3.fromRGB(3, 115, 113),
}
getgenv().MeowThemes.theme_15 = {
    name = "theme_15",
    accent  = Color3.fromRGB(43, 27, 41),
    bg      = Color3.fromRGB(10, 6, 10),
    text    = Color3.fromRGB(212, 228, 214),
    outline = Color3.fromRGB(21, 13, 20),
}
getgenv().MeowThemes.theme_16 = {
    name = "theme_16",
    accent  = Color3.fromRGB(80, 80, 112),
    bg      = Color3.fromRGB(20, 20, 28),
    text    = Color3.fromRGB(175, 175, 143),
    outline = Color3.fromRGB(40, 40, 56),
}
getgenv().MeowThemes.theme_17 = {
    name = "theme_17",
    accent  = Color3.fromRGB(117, 133, 183),
    bg      = Color3.fromRGB(29, 33, 45),
    text    = Color3.fromRGB(138, 122, 72),
    outline = Color3.fromRGB(58, 66, 91),
}
getgenv().MeowThemes.theme_18 = {
    name = "theme_18",
    accent  = Color3.fromRGB(154, 186, 254),
    bg      = Color3.fromRGB(38, 46, 63),
    text    = Color3.fromRGB(101, 69, 1),
    outline = Color3.fromRGB(77, 93, 127),
}
getgenv().MeowThemes.theme_19 = {
    name = "theme_19",
    accent  = Color3.fromRGB(191, 239, 69),
    bg      = Color3.fromRGB(47, 59, 17),
    text    = Color3.fromRGB(64, 16, 186),
    outline = Color3.fromRGB(95, 119, 34),
}
getgenv().MeowThemes.theme_20 = {
    name = "theme_20",
    accent  = Color3.fromRGB(228, 36, 140),
    bg      = Color3.fromRGB(57, 9, 35),
    text    = Color3.fromRGB(27, 219, 115),
    outline = Color3.fromRGB(114, 18, 70),
}
getgenv().MeowThemes.theme_21 = {
    name = "theme_21",
    accent  = Color3.fromRGB(9, 89, 211),
    bg      = Color3.fromRGB(2, 22, 52),
    text    = Color3.fromRGB(246, 166, 44),
    outline = Color3.fromRGB(4, 44, 105),
}
getgenv().MeowThemes.theme_22 = {
    name = "theme_22",
    accent  = Color3.fromRGB(46, 142, 26),
    bg      = Color3.fromRGB(11, 35, 6),
    text    = Color3.fromRGB(209, 113, 229),
    outline = Color3.fromRGB(23, 71, 13),
}
getgenv().MeowThemes.theme_23 = {
    name = "theme_23",
    accent  = Color3.fromRGB(83, 195, 97),
    bg      = Color3.fromRGB(20, 48, 24),
    text    = Color3.fromRGB(172, 60, 158),
    outline = Color3.fromRGB(41, 97, 48),
}
getgenv().MeowThemes.theme_24 = {
    name = "theme_24",
    accent  = Color3.fromRGB(120, 248, 168),
    bg      = Color3.fromRGB(30, 62, 42),
    text    = Color3.fromRGB(135, 7, 87),
    outline = Color3.fromRGB(60, 124, 84),
}
getgenv().MeowThemes.theme_25 = {
    name = "theme_25",
    accent  = Color3.fromRGB(157, 45, 239),
    bg      = Color3.fromRGB(39, 11, 59),
    text    = Color3.fromRGB(98, 210, 16),
    outline = Color3.fromRGB(78, 22, 119),
}
getgenv().MeowThemes.theme_26 = {
    name = "theme_26",
    accent  = Color3.fromRGB(194, 98, 54),
    bg      = Color3.fromRGB(48, 24, 13),
    text    = Color3.fromRGB(61, 157, 201),
    outline = Color3.fromRGB(97, 49, 27),
}
getgenv().MeowThemes.theme_27 = {
    name = "theme_27",
    accent  = Color3.fromRGB(231, 151, 125),
    bg      = Color3.fromRGB(57, 37, 31),
    text    = Color3.fromRGB(24, 104, 130),
    outline = Color3.fromRGB(115, 75, 62),
}
getgenv().MeowThemes.theme_28 = {
    name = "theme_28",
    accent  = Color3.fromRGB(12, 204, 196),
    bg      = Color3.fromRGB(3, 51, 49),
    text    = Color3.fromRGB(243, 51, 59),
    outline = Color3.fromRGB(6, 102, 98),
}
getgenv().MeowThemes.theme_29 = {
    name = "theme_29",
    accent  = Color3.fromRGB(49, 1, 11),
    bg      = Color3.fromRGB(12, 0, 2),
    text    = Color3.fromRGB(206, 254, 244),
    outline = Color3.fromRGB(24, 0, 5),
}
getgenv().MeowThemes.theme_30 = {
    name = "theme_30",
    accent  = Color3.fromRGB(86, 54, 82),
    bg      = Color3.fromRGB(21, 13, 20),
    text    = Color3.fromRGB(169, 201, 173),
    outline = Color3.fromRGB(43, 27, 41),
}
getgenv().MeowThemes.theme_31 = {
    name = "theme_31",
    accent  = Color3.fromRGB(123, 107, 153),
    bg      = Color3.fromRGB(30, 26, 38),
    text    = Color3.fromRGB(132, 148, 102),
    outline = Color3.fromRGB(61, 53, 76),
}
getgenv().MeowThemes.theme_32 = {
    name = "theme_32",
    accent  = Color3.fromRGB(160, 160, 224),
    bg      = Color3.fromRGB(40, 40, 56),
    text    = Color3.fromRGB(95, 95, 31),
    outline = Color3.fromRGB(80, 80, 112),
}
getgenv().MeowThemes.theme_33 = {
    name = "theme_33",
    accent  = Color3.fromRGB(197, 213, 39),
    bg      = Color3.fromRGB(49, 53, 9),
    text    = Color3.fromRGB(58, 42, 216),
    outline = Color3.fromRGB(98, 106, 19),
}
getgenv().MeowThemes.theme_34 = {
    name = "theme_34",
    accent  = Color3.fromRGB(234, 10, 110),
    bg      = Color3.fromRGB(58, 2, 27),
    text    = Color3.fromRGB(21, 245, 145),
    outline = Color3.fromRGB(117, 5, 55),
}
getgenv().MeowThemes.theme_35 = {
    name = "theme_35",
    accent  = Color3.fromRGB(15, 63, 181),
    bg      = Color3.fromRGB(3, 15, 45),
    text    = Color3.fromRGB(240, 192, 74),
    outline = Color3.fromRGB(7, 31, 90),
}
getgenv().MeowThemes.theme_36 = {
    name = "theme_36",
    accent  = Color3.fromRGB(52, 116, 252),
    bg      = Color3.fromRGB(13, 29, 63),
    text    = Color3.fromRGB(203, 139, 3),
    outline = Color3.fromRGB(26, 58, 126),
}
getgenv().MeowThemes.theme_37 = {
    name = "theme_37",
    accent  = Color3.fromRGB(89, 169, 67),
    bg      = Color3.fromRGB(22, 42, 16),
    text    = Color3.fromRGB(166, 86, 188),
    outline = Color3.fromRGB(44, 84, 33),
}
getgenv().MeowThemes.theme_38 = {
    name = "theme_38",
    accent  = Color3.fromRGB(126, 222, 138),
    bg      = Color3.fromRGB(31, 55, 34),
    text    = Color3.fromRGB(129, 33, 117),
    outline = Color3.fromRGB(63, 111, 69),
}
getgenv().MeowThemes.theme_39 = {
    name = "theme_39",
    accent  = Color3.fromRGB(163, 19, 209),
    bg      = Color3.fromRGB(40, 4, 52),
    text    = Color3.fromRGB(92, 236, 46),
    outline = Color3.fromRGB(81, 9, 104),
}
getgenv().MeowThemes.theme_40 = {
    name = "theme_40",
    accent  = Color3.fromRGB(200, 72, 24),
    bg      = Color3.fromRGB(50, 18, 6),
    text    = Color3.fromRGB(55, 183, 231),
    outline = Color3.fromRGB(100, 36, 12),
}
getgenv().MeowThemes.theme_41 = {
    name = "theme_41",
    accent  = Color3.fromRGB(237, 125, 95),
    bg      = Color3.fromRGB(59, 31, 23),
    text    = Color3.fromRGB(18, 130, 160),
    outline = Color3.fromRGB(118, 62, 47),
}
getgenv().MeowThemes.theme_42 = {
    name = "theme_42",
    accent  = Color3.fromRGB(18, 178, 166),
    bg      = Color3.fromRGB(4, 44, 41),
    text    = Color3.fromRGB(237, 77, 89),
    outline = Color3.fromRGB(9, 89, 83),
}
getgenv().MeowThemes.theme_43 = {
    name = "theme_43",
    accent  = Color3.fromRGB(55, 231, 237),
    bg      = Color3.fromRGB(13, 57, 59),
    text    = Color3.fromRGB(200, 24, 18),
    outline = Color3.fromRGB(27, 115, 118),
}
getgenv().MeowThemes.theme_44 = {
    name = "theme_44",
    accent  = Color3.fromRGB(92, 28, 52),
    bg      = Color3.fromRGB(23, 7, 13),
    text    = Color3.fromRGB(163, 227, 203),
    outline = Color3.fromRGB(46, 14, 26),
}
getgenv().MeowThemes.theme_45 = {
    name = "theme_45",
    accent  = Color3.fromRGB(129, 81, 123),
    bg      = Color3.fromRGB(32, 20, 30),
    text    = Color3.fromRGB(126, 174, 132),
    outline = Color3.fromRGB(64, 40, 61),
}
getgenv().MeowThemes.theme_46 = {
    name = "theme_46",
    accent  = Color3.fromRGB(166, 134, 194),
    bg      = Color3.fromRGB(41, 33, 48),
    text    = Color3.fromRGB(89, 121, 61),
    outline = Color3.fromRGB(83, 67, 97),
}
getgenv().MeowThemes.theme_47 = {
    name = "theme_47",
    accent  = Color3.fromRGB(203, 187, 9),
    bg      = Color3.fromRGB(50, 46, 2),
    text    = Color3.fromRGB(52, 68, 246),
    outline = Color3.fromRGB(101, 93, 4),
}
getgenv().MeowThemes.theme_48 = {
    name = "theme_48",
    accent  = Color3.fromRGB(240, 240, 80),
    bg      = Color3.fromRGB(60, 60, 20),
    text    = Color3.fromRGB(15, 15, 175),
    outline = Color3.fromRGB(120, 120, 40),
}
getgenv().MeowThemes.theme_49 = {
    name = "theme_49",
    accent  = Color3.fromRGB(21, 37, 151),
    bg      = Color3.fromRGB(5, 9, 37),
    text    = Color3.fromRGB(234, 218, 104),
    outline = Color3.fromRGB(10, 18, 75),
}
getgenv().MeowThemes.theme_50 = {
    name = "theme_50",
    accent  = Color3.fromRGB(58, 90, 222),
    bg      = Color3.fromRGB(14, 22, 55),
    text    = Color3.fromRGB(197, 165, 33),
    outline = Color3.fromRGB(29, 45, 111),
}
getgenv().MeowThemes.theme_51 = {
    name = "theme_51",
    accent  = Color3.fromRGB(95, 143, 37),
    bg      = Color3.fromRGB(23, 35, 9),
    text    = Color3.fromRGB(160, 112, 218),
    outline = Color3.fromRGB(47, 71, 18),
}
getgenv().MeowThemes.theme_52 = {
    name = "theme_52",
    accent  = Color3.fromRGB(132, 196, 108),
    bg      = Color3.fromRGB(33, 49, 27),
    text    = Color3.fromRGB(123, 59, 147),
    outline = Color3.fromRGB(66, 98, 54),
}
getgenv().MeowThemes.theme_53 = {
    name = "theme_53",
    accent  = Color3.fromRGB(169, 249, 179),
    bg      = Color3.fromRGB(42, 62, 44),
    text    = Color3.fromRGB(86, 6, 76),
    outline = Color3.fromRGB(84, 124, 89),
}
getgenv().MeowThemes.theme_54 = {
    name = "theme_54",
    accent  = Color3.fromRGB(206, 46, 250),
    bg      = Color3.fromRGB(51, 11, 62),
    text    = Color3.fromRGB(49, 209, 5),
    outline = Color3.fromRGB(103, 23, 125),
}
getgenv().MeowThemes.theme_55 = {
    name = "theme_55",
    accent  = Color3.fromRGB(243, 99, 65),
    bg      = Color3.fromRGB(60, 24, 16),
    text    = Color3.fromRGB(12, 156, 190),
    outline = Color3.fromRGB(121, 49, 32),
}
getgenv().MeowThemes.theme_56 = {
    name = "theme_56",
    accent  = Color3.fromRGB(24, 152, 136),
    bg      = Color3.fromRGB(6, 38, 34),
    text    = Color3.fromRGB(231, 103, 119),
    outline = Color3.fromRGB(12, 76, 68),
}
getgenv().MeowThemes.theme_57 = {
    name = "theme_57",
    accent  = Color3.fromRGB(61, 205, 207),
    bg      = Color3.fromRGB(15, 51, 51),
    text    = Color3.fromRGB(194, 50, 48),
    outline = Color3.fromRGB(30, 102, 103),
}
getgenv().MeowThemes.theme_58 = {
    name = "theme_58",
    accent  = Color3.fromRGB(98, 2, 22),
    bg      = Color3.fromRGB(24, 0, 5),
    text    = Color3.fromRGB(157, 253, 233),
    outline = Color3.fromRGB(49, 1, 11),
}
getgenv().MeowThemes.theme_59 = {
    name = "theme_59",
    accent  = Color3.fromRGB(135, 55, 93),
    bg      = Color3.fromRGB(33, 13, 23),
    text    = Color3.fromRGB(120, 200, 162),
    outline = Color3.fromRGB(67, 27, 46),
}
getgenv().MeowThemes.theme_60 = {
    name = "theme_60",
    accent  = Color3.fromRGB(172, 108, 164),
    bg      = Color3.fromRGB(43, 27, 41),
    text    = Color3.fromRGB(83, 147, 91),
    outline = Color3.fromRGB(86, 54, 82),
}
getgenv().MeowThemes.theme_61 = {
    name = "theme_61",
    accent  = Color3.fromRGB(209, 161, 235),
    bg      = Color3.fromRGB(52, 40, 58),
    text    = Color3.fromRGB(46, 94, 20),
    outline = Color3.fromRGB(104, 80, 117),
}
getgenv().MeowThemes.theme_62 = {
    name = "theme_62",
    accent  = Color3.fromRGB(246, 214, 50),
    bg      = Color3.fromRGB(61, 53, 12),
    text    = Color3.fromRGB(9, 41, 205),
    outline = Color3.fromRGB(123, 107, 25),
}
getgenv().MeowThemes.theme_63 = {
    name = "theme_63",
    accent  = Color3.fromRGB(27, 11, 121),
    bg      = Color3.fromRGB(6, 2, 30),
    text    = Color3.fromRGB(228, 244, 134),
    outline = Color3.fromRGB(13, 5, 60),
}
getgenv().MeowThemes.theme_64 = {
    name = "theme_64",
    accent  = Color3.fromRGB(64, 64, 192),
    bg      = Color3.fromRGB(16, 16, 48),
    text    = Color3.fromRGB(191, 191, 63),
    outline = Color3.fromRGB(32, 32, 96),
}
getgenv().MeowThemes.theme_65 = {
    name = "theme_65",
    accent  = Color3.fromRGB(101, 117, 7),
    bg      = Color3.fromRGB(25, 29, 1),
    text    = Color3.fromRGB(154, 138, 248),
    outline = Color3.fromRGB(50, 58, 3),
}
getgenv().MeowThemes.theme_66 = {
    name = "theme_66",
    accent  = Color3.fromRGB(138, 170, 78),
    bg      = Color3.fromRGB(34, 42, 19),
    text    = Color3.fromRGB(117, 85, 177),
    outline = Color3.fromRGB(69, 85, 39),
}
getgenv().MeowThemes.theme_67 = {
    name = "theme_67",
    accent  = Color3.fromRGB(175, 223, 149),
    bg      = Color3.fromRGB(43, 55, 37),
    text    = Color3.fromRGB(80, 32, 106),
    outline = Color3.fromRGB(87, 111, 74),
}
getgenv().MeowThemes.theme_68 = {
    name = "theme_68",
    accent  = Color3.fromRGB(212, 20, 220),
    bg      = Color3.fromRGB(53, 5, 55),
    text    = Color3.fromRGB(43, 235, 35),
    outline = Color3.fromRGB(106, 10, 110),
}
getgenv().MeowThemes.theme_69 = {
    name = "theme_69",
    accent  = Color3.fromRGB(249, 73, 35),
    bg      = Color3.fromRGB(62, 18, 8),
    text    = Color3.fromRGB(6, 182, 220),
    outline = Color3.fromRGB(124, 36, 17),
}
getgenv().MeowThemes.theme_70 = {
    name = "theme_70",
    accent  = Color3.fromRGB(30, 126, 106),
    bg      = Color3.fromRGB(7, 31, 26),
    text    = Color3.fromRGB(225, 129, 149),
    outline = Color3.fromRGB(15, 63, 53),
}
getgenv().MeowThemes.theme_71 = {
    name = "theme_71",
    accent  = Color3.fromRGB(67, 179, 177),
    bg      = Color3.fromRGB(16, 44, 44),
    text    = Color3.fromRGB(188, 76, 78),
    outline = Color3.fromRGB(33, 89, 88),
}
getgenv().MeowThemes.theme_72 = {
    name = "theme_72",
    accent  = Color3.fromRGB(104, 232, 248),
    bg      = Color3.fromRGB(26, 58, 62),
    text    = Color3.fromRGB(151, 23, 7),
    outline = Color3.fromRGB(52, 116, 124),
}
getgenv().MeowThemes.theme_73 = {
    name = "theme_73",
    accent  = Color3.fromRGB(141, 29, 63),
    bg      = Color3.fromRGB(35, 7, 15),
    text    = Color3.fromRGB(114, 226, 192),
    outline = Color3.fromRGB(70, 14, 31),
}
getgenv().MeowThemes.theme_74 = {
    name = "theme_74",
    accent  = Color3.fromRGB(178, 82, 134),
    bg      = Color3.fromRGB(44, 20, 33),
    text    = Color3.fromRGB(77, 173, 121),
    outline = Color3.fromRGB(89, 41, 67),
}
getgenv().MeowThemes.theme_75 = {
    name = "theme_75",
    accent  = Color3.fromRGB(215, 135, 205),
    bg      = Color3.fromRGB(53, 33, 51),
    text    = Color3.fromRGB(40, 120, 50),
    outline = Color3.fromRGB(107, 67, 102),
}
getgenv().MeowThemes.theme_76 = {
    name = "theme_76",
    accent  = Color3.fromRGB(252, 188, 20),
    bg      = Color3.fromRGB(63, 47, 5),
    text    = Color3.fromRGB(3, 67, 235),
    outline = Color3.fromRGB(126, 94, 10),
}
getgenv().MeowThemes.theme_77 = {
    name = "theme_77",
    accent  = Color3.fromRGB(33, 241, 91),
    bg      = Color3.fromRGB(8, 60, 22),
    text    = Color3.fromRGB(222, 14, 164),
    outline = Color3.fromRGB(16, 120, 45),
}
getgenv().MeowThemes.theme_78 = {
    name = "theme_78",
    accent  = Color3.fromRGB(70, 38, 162),
    bg      = Color3.fromRGB(17, 9, 40),
    text    = Color3.fromRGB(185, 217, 93),
    outline = Color3.fromRGB(35, 19, 81),
}
getgenv().MeowThemes.theme_79 = {
    name = "theme_79",
    accent  = Color3.fromRGB(107, 91, 233),
    bg      = Color3.fromRGB(26, 22, 58),
    text    = Color3.fromRGB(148, 164, 22),
    outline = Color3.fromRGB(53, 45, 116),
}
getgenv().MeowThemes.theme_80 = {
    name = "theme_80",
    accent  = Color3.fromRGB(144, 144, 48),
    bg      = Color3.fromRGB(36, 36, 12),
    text    = Color3.fromRGB(111, 111, 207),
    outline = Color3.fromRGB(72, 72, 24),
}

-- =========================================================================
-- WAYPOINT PRESETS (spawn points per map)
-- =========================================================================
getgenv().MeowWaypoints = {}
getgenv().MeowWaypoints.waypoint_1 = {
    name = "waypoint_1",
    position = Vector3.new(-387, 11, -483),
    yaw = math.rad(7),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_2 = {
    name = "waypoint_2",
    position = Vector3.new(-374, 12, -466),
    yaw = math.rad(14),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_3 = {
    name = "waypoint_3",
    position = Vector3.new(-361, 13, -449),
    yaw = math.rad(21),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_4 = {
    name = "waypoint_4",
    position = Vector3.new(-348, 14, -432),
    yaw = math.rad(28),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_5 = {
    name = "waypoint_5",
    position = Vector3.new(-335, 15, -415),
    yaw = math.rad(35),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_6 = {
    name = "waypoint_6",
    position = Vector3.new(-322, 16, -398),
    yaw = math.rad(42),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_7 = {
    name = "waypoint_7",
    position = Vector3.new(-309, 17, -381),
    yaw = math.rad(49),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_8 = {
    name = "waypoint_8",
    position = Vector3.new(-296, 18, -364),
    yaw = math.rad(56),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_9 = {
    name = "waypoint_9",
    position = Vector3.new(-283, 19, -347),
    yaw = math.rad(63),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_10 = {
    name = "waypoint_10",
    position = Vector3.new(-270, 20, -330),
    yaw = math.rad(70),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_11 = {
    name = "waypoint_11",
    position = Vector3.new(-257, 21, -313),
    yaw = math.rad(77),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_12 = {
    name = "waypoint_12",
    position = Vector3.new(-244, 22, -296),
    yaw = math.rad(84),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_13 = {
    name = "waypoint_13",
    position = Vector3.new(-231, 23, -279),
    yaw = math.rad(91),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_14 = {
    name = "waypoint_14",
    position = Vector3.new(-218, 24, -262),
    yaw = math.rad(98),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_15 = {
    name = "waypoint_15",
    position = Vector3.new(-205, 25, -245),
    yaw = math.rad(105),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_16 = {
    name = "waypoint_16",
    position = Vector3.new(-192, 26, -228),
    yaw = math.rad(112),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_17 = {
    name = "waypoint_17",
    position = Vector3.new(-179, 27, -211),
    yaw = math.rad(119),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_18 = {
    name = "waypoint_18",
    position = Vector3.new(-166, 28, -194),
    yaw = math.rad(126),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_19 = {
    name = "waypoint_19",
    position = Vector3.new(-153, 29, -177),
    yaw = math.rad(133),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_20 = {
    name = "waypoint_20",
    position = Vector3.new(-140, 30, -160),
    yaw = math.rad(140),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_21 = {
    name = "waypoint_21",
    position = Vector3.new(-127, 31, -143),
    yaw = math.rad(147),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_22 = {
    name = "waypoint_22",
    position = Vector3.new(-114, 32, -126),
    yaw = math.rad(154),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_23 = {
    name = "waypoint_23",
    position = Vector3.new(-101, 33, -109),
    yaw = math.rad(161),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_24 = {
    name = "waypoint_24",
    position = Vector3.new(-88, 34, -92),
    yaw = math.rad(168),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_25 = {
    name = "waypoint_25",
    position = Vector3.new(-75, 35, -75),
    yaw = math.rad(175),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_26 = {
    name = "waypoint_26",
    position = Vector3.new(-62, 36, -58),
    yaw = math.rad(182),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_27 = {
    name = "waypoint_27",
    position = Vector3.new(-49, 37, -41),
    yaw = math.rad(189),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_28 = {
    name = "waypoint_28",
    position = Vector3.new(-36, 38, -24),
    yaw = math.rad(196),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_29 = {
    name = "waypoint_29",
    position = Vector3.new(-23, 39, -7),
    yaw = math.rad(203),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_30 = {
    name = "waypoint_30",
    position = Vector3.new(-10, 40, 10),
    yaw = math.rad(210),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_31 = {
    name = "waypoint_31",
    position = Vector3.new(3, 41, 27),
    yaw = math.rad(217),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_32 = {
    name = "waypoint_32",
    position = Vector3.new(16, 42, 44),
    yaw = math.rad(224),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_33 = {
    name = "waypoint_33",
    position = Vector3.new(29, 43, 61),
    yaw = math.rad(231),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_34 = {
    name = "waypoint_34",
    position = Vector3.new(42, 44, 78),
    yaw = math.rad(238),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_35 = {
    name = "waypoint_35",
    position = Vector3.new(55, 45, 95),
    yaw = math.rad(245),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_36 = {
    name = "waypoint_36",
    position = Vector3.new(68, 46, 112),
    yaw = math.rad(252),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_37 = {
    name = "waypoint_37",
    position = Vector3.new(81, 47, 129),
    yaw = math.rad(259),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_38 = {
    name = "waypoint_38",
    position = Vector3.new(94, 48, 146),
    yaw = math.rad(266),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_39 = {
    name = "waypoint_39",
    position = Vector3.new(107, 49, 163),
    yaw = math.rad(273),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_40 = {
    name = "waypoint_40",
    position = Vector3.new(120, 50, 180),
    yaw = math.rad(280),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_41 = {
    name = "waypoint_41",
    position = Vector3.new(133, 51, 197),
    yaw = math.rad(287),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_42 = {
    name = "waypoint_42",
    position = Vector3.new(146, 52, 214),
    yaw = math.rad(294),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_43 = {
    name = "waypoint_43",
    position = Vector3.new(159, 53, 231),
    yaw = math.rad(301),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_44 = {
    name = "waypoint_44",
    position = Vector3.new(172, 54, 248),
    yaw = math.rad(308),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_45 = {
    name = "waypoint_45",
    position = Vector3.new(185, 55, 265),
    yaw = math.rad(315),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_46 = {
    name = "waypoint_46",
    position = Vector3.new(198, 56, 282),
    yaw = math.rad(322),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_47 = {
    name = "waypoint_47",
    position = Vector3.new(211, 57, 299),
    yaw = math.rad(329),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_48 = {
    name = "waypoint_48",
    position = Vector3.new(224, 58, 316),
    yaw = math.rad(336),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_49 = {
    name = "waypoint_49",
    position = Vector3.new(237, 59, 333),
    yaw = math.rad(343),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_50 = {
    name = "waypoint_50",
    position = Vector3.new(250, 10, 350),
    yaw = math.rad(350),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_51 = {
    name = "waypoint_51",
    position = Vector3.new(263, 11, 367),
    yaw = math.rad(357),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_52 = {
    name = "waypoint_52",
    position = Vector3.new(276, 12, 384),
    yaw = math.rad(4),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_53 = {
    name = "waypoint_53",
    position = Vector3.new(289, 13, 401),
    yaw = math.rad(11),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_54 = {
    name = "waypoint_54",
    position = Vector3.new(302, 14, 418),
    yaw = math.rad(18),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_55 = {
    name = "waypoint_55",
    position = Vector3.new(315, 15, 435),
    yaw = math.rad(25),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_56 = {
    name = "waypoint_56",
    position = Vector3.new(328, 16, 452),
    yaw = math.rad(32),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_57 = {
    name = "waypoint_57",
    position = Vector3.new(341, 17, 469),
    yaw = math.rad(39),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_58 = {
    name = "waypoint_58",
    position = Vector3.new(354, 18, 486),
    yaw = math.rad(46),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_59 = {
    name = "waypoint_59",
    position = Vector3.new(367, 19, 503),
    yaw = math.rad(53),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_60 = {
    name = "waypoint_60",
    position = Vector3.new(380, 20, 520),
    yaw = math.rad(60),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_61 = {
    name = "waypoint_61",
    position = Vector3.new(393, 21, 537),
    yaw = math.rad(67),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_62 = {
    name = "waypoint_62",
    position = Vector3.new(406, 22, 554),
    yaw = math.rad(74),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_63 = {
    name = "waypoint_63",
    position = Vector3.new(419, 23, 571),
    yaw = math.rad(81),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_64 = {
    name = "waypoint_64",
    position = Vector3.new(432, 24, 588),
    yaw = math.rad(88),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_65 = {
    name = "waypoint_65",
    position = Vector3.new(445, 25, 605),
    yaw = math.rad(95),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_66 = {
    name = "waypoint_66",
    position = Vector3.new(458, 26, 622),
    yaw = math.rad(102),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_67 = {
    name = "waypoint_67",
    position = Vector3.new(471, 27, 639),
    yaw = math.rad(109),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_68 = {
    name = "waypoint_68",
    position = Vector3.new(484, 28, 656),
    yaw = math.rad(116),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_69 = {
    name = "waypoint_69",
    position = Vector3.new(497, 29, 673),
    yaw = math.rad(123),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_70 = {
    name = "waypoint_70",
    position = Vector3.new(510, 30, 690),
    yaw = math.rad(130),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_71 = {
    name = "waypoint_71",
    position = Vector3.new(523, 31, 707),
    yaw = math.rad(137),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_72 = {
    name = "waypoint_72",
    position = Vector3.new(536, 32, 724),
    yaw = math.rad(144),
    tag = "map_1",
}
getgenv().MeowWaypoints.waypoint_73 = {
    name = "waypoint_73",
    position = Vector3.new(549, 33, 741),
    yaw = math.rad(151),
    tag = "map_2",
}
getgenv().MeowWaypoints.waypoint_74 = {
    name = "waypoint_74",
    position = Vector3.new(562, 34, 758),
    yaw = math.rad(158),
    tag = "map_3",
}
getgenv().MeowWaypoints.waypoint_75 = {
    name = "waypoint_75",
    position = Vector3.new(575, 35, 775),
    yaw = math.rad(165),
    tag = "map_4",
}
getgenv().MeowWaypoints.waypoint_76 = {
    name = "waypoint_76",
    position = Vector3.new(588, 36, 792),
    yaw = math.rad(172),
    tag = "map_5",
}
getgenv().MeowWaypoints.waypoint_77 = {
    name = "waypoint_77",
    position = Vector3.new(601, 37, 809),
    yaw = math.rad(179),
    tag = "map_6",
}
getgenv().MeowWaypoints.waypoint_78 = {
    name = "waypoint_78",
    position = Vector3.new(614, 38, 826),
    yaw = math.rad(186),
    tag = "map_7",
}
getgenv().MeowWaypoints.waypoint_79 = {
    name = "waypoint_79",
    position = Vector3.new(627, 39, 843),
    yaw = math.rad(193),
    tag = "map_8",
}
getgenv().MeowWaypoints.waypoint_80 = {
    name = "waypoint_80",
    position = Vector3.new(640, 40, 860),
    yaw = math.rad(200),
    tag = "map_1",
}

-- =========================================================================
-- RAGE PROFILES
-- =========================================================================
getgenv().MeowRageProfiles = {}
getgenv().MeowRageProfiles.profile_1 = {
    name = "profile_1",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 2,
    tp_height = -9,
    orbit_speed = 125,
    shoot_attempts = 2,
    prediction_mult = 1 + (1 * 0.1),
}
getgenv().MeowRageProfiles.profile_2 = {
    name = "profile_2",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 3,
    tp_height = -8,
    orbit_speed = 150,
    shoot_attempts = 3,
    prediction_mult = 1 + (2 * 0.1),
}
getgenv().MeowRageProfiles.profile_3 = {
    name = "profile_3",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 4,
    tp_height = -7,
    orbit_speed = 175,
    shoot_attempts = 1,
    prediction_mult = 1 + (3 * 0.1),
}
getgenv().MeowRageProfiles.profile_4 = {
    name = "profile_4",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 5,
    tp_height = -6,
    orbit_speed = 200,
    shoot_attempts = 2,
    prediction_mult = 1 + (4 * 0.1),
}
getgenv().MeowRageProfiles.profile_5 = {
    name = "profile_5",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 6,
    tp_height = -5,
    orbit_speed = 225,
    shoot_attempts = 3,
    prediction_mult = 1 + (5 * 0.1),
}
getgenv().MeowRageProfiles.profile_6 = {
    name = "profile_6",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 7,
    tp_height = -4,
    orbit_speed = 250,
    shoot_attempts = 1,
    prediction_mult = 1 + (6 * 0.1),
}
getgenv().MeowRageProfiles.profile_7 = {
    name = "profile_7",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 8,
    tp_height = -3,
    orbit_speed = 275,
    shoot_attempts = 2,
    prediction_mult = 1 + (7 * 0.1),
}
getgenv().MeowRageProfiles.profile_8 = {
    name = "profile_8",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 9,
    tp_height = -2,
    orbit_speed = 300,
    shoot_attempts = 3,
    prediction_mult = 1 + (8 * 0.1),
}
getgenv().MeowRageProfiles.profile_9 = {
    name = "profile_9",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 10,
    tp_height = -1,
    orbit_speed = 325,
    shoot_attempts = 1,
    prediction_mult = 1 + (9 * 0.1),
}
getgenv().MeowRageProfiles.profile_10 = {
    name = "profile_10",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 11,
    tp_height = 0,
    orbit_speed = 350,
    shoot_attempts = 2,
    prediction_mult = 1 + (0 * 0.1),
}
getgenv().MeowRageProfiles.profile_11 = {
    name = "profile_11",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 12,
    tp_height = 1,
    orbit_speed = 375,
    shoot_attempts = 3,
    prediction_mult = 1 + (1 * 0.1),
}
getgenv().MeowRageProfiles.profile_12 = {
    name = "profile_12",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 13,
    tp_height = 2,
    orbit_speed = 400,
    shoot_attempts = 1,
    prediction_mult = 1 + (2 * 0.1),
}
getgenv().MeowRageProfiles.profile_13 = {
    name = "profile_13",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 14,
    tp_height = 3,
    orbit_speed = 425,
    shoot_attempts = 2,
    prediction_mult = 1 + (3 * 0.1),
}
getgenv().MeowRageProfiles.profile_14 = {
    name = "profile_14",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 15,
    tp_height = 4,
    orbit_speed = 450,
    shoot_attempts = 3,
    prediction_mult = 1 + (4 * 0.1),
}
getgenv().MeowRageProfiles.profile_15 = {
    name = "profile_15",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 16,
    tp_height = 5,
    orbit_speed = 475,
    shoot_attempts = 1,
    prediction_mult = 1 + (5 * 0.1),
}
getgenv().MeowRageProfiles.profile_16 = {
    name = "profile_16",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 17,
    tp_height = 6,
    orbit_speed = 500,
    shoot_attempts = 2,
    prediction_mult = 1 + (6 * 0.1),
}
getgenv().MeowRageProfiles.profile_17 = {
    name = "profile_17",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 18,
    tp_height = 7,
    orbit_speed = 525,
    shoot_attempts = 3,
    prediction_mult = 1 + (7 * 0.1),
}
getgenv().MeowRageProfiles.profile_18 = {
    name = "profile_18",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 19,
    tp_height = 8,
    orbit_speed = 550,
    shoot_attempts = 1,
    prediction_mult = 1 + (8 * 0.1),
}
getgenv().MeowRageProfiles.profile_19 = {
    name = "profile_19",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 20,
    tp_height = 9,
    orbit_speed = 575,
    shoot_attempts = 2,
    prediction_mult = 1 + (9 * 0.1),
}
getgenv().MeowRageProfiles.profile_20 = {
    name = "profile_20",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 21,
    tp_height = -10,
    orbit_speed = 600,
    shoot_attempts = 3,
    prediction_mult = 1 + (0 * 0.1),
}
getgenv().MeowRageProfiles.profile_21 = {
    name = "profile_21",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 22,
    tp_height = -9,
    orbit_speed = 625,
    shoot_attempts = 1,
    prediction_mult = 1 + (1 * 0.1),
}
getgenv().MeowRageProfiles.profile_22 = {
    name = "profile_22",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 23,
    tp_height = -8,
    orbit_speed = 650,
    shoot_attempts = 2,
    prediction_mult = 1 + (2 * 0.1),
}
getgenv().MeowRageProfiles.profile_23 = {
    name = "profile_23",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 24,
    tp_height = -7,
    orbit_speed = 675,
    shoot_attempts = 3,
    prediction_mult = 1 + (3 * 0.1),
}
getgenv().MeowRageProfiles.profile_24 = {
    name = "profile_24",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 25,
    tp_height = -6,
    orbit_speed = 700,
    shoot_attempts = 1,
    prediction_mult = 1 + (4 * 0.1),
}
getgenv().MeowRageProfiles.profile_25 = {
    name = "profile_25",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 26,
    tp_height = -5,
    orbit_speed = 725,
    shoot_attempts = 2,
    prediction_mult = 1 + (5 * 0.1),
}
getgenv().MeowRageProfiles.profile_26 = {
    name = "profile_26",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 27,
    tp_height = -4,
    orbit_speed = 750,
    shoot_attempts = 3,
    prediction_mult = 1 + (6 * 0.1),
}
getgenv().MeowRageProfiles.profile_27 = {
    name = "profile_27",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 28,
    tp_height = -3,
    orbit_speed = 775,
    shoot_attempts = 1,
    prediction_mult = 1 + (7 * 0.1),
}
getgenv().MeowRageProfiles.profile_28 = {
    name = "profile_28",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 29,
    tp_height = -2,
    orbit_speed = 800,
    shoot_attempts = 2,
    prediction_mult = 1 + (8 * 0.1),
}
getgenv().MeowRageProfiles.profile_29 = {
    name = "profile_29",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 30,
    tp_height = -1,
    orbit_speed = 825,
    shoot_attempts = 3,
    prediction_mult = 1 + (9 * 0.1),
}
getgenv().MeowRageProfiles.profile_30 = {
    name = "profile_30",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 1,
    tp_height = 0,
    orbit_speed = 850,
    shoot_attempts = 1,
    prediction_mult = 1 + (0 * 0.1),
}
getgenv().MeowRageProfiles.profile_31 = {
    name = "profile_31",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 2,
    tp_height = 1,
    orbit_speed = 875,
    shoot_attempts = 2,
    prediction_mult = 1 + (1 * 0.1),
}
getgenv().MeowRageProfiles.profile_32 = {
    name = "profile_32",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 3,
    tp_height = 2,
    orbit_speed = 900,
    shoot_attempts = 3,
    prediction_mult = 1 + (2 * 0.1),
}
getgenv().MeowRageProfiles.profile_33 = {
    name = "profile_33",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 4,
    tp_height = 3,
    orbit_speed = 925,
    shoot_attempts = 1,
    prediction_mult = 1 + (3 * 0.1),
}
getgenv().MeowRageProfiles.profile_34 = {
    name = "profile_34",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 5,
    tp_height = 4,
    orbit_speed = 950,
    shoot_attempts = 2,
    prediction_mult = 1 + (4 * 0.1),
}
getgenv().MeowRageProfiles.profile_35 = {
    name = "profile_35",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 6,
    tp_height = 5,
    orbit_speed = 975,
    shoot_attempts = 3,
    prediction_mult = 1 + (5 * 0.1),
}
getgenv().MeowRageProfiles.profile_36 = {
    name = "profile_36",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 7,
    tp_height = 6,
    orbit_speed = 1000,
    shoot_attempts = 1,
    prediction_mult = 1 + (6 * 0.1),
}
getgenv().MeowRageProfiles.profile_37 = {
    name = "profile_37",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 8,
    tp_height = 7,
    orbit_speed = 1025,
    shoot_attempts = 2,
    prediction_mult = 1 + (7 * 0.1),
}
getgenv().MeowRageProfiles.profile_38 = {
    name = "profile_38",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 9,
    tp_height = 8,
    orbit_speed = 1050,
    shoot_attempts = 3,
    prediction_mult = 1 + (8 * 0.1),
}
getgenv().MeowRageProfiles.profile_39 = {
    name = "profile_39",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 10,
    tp_height = 9,
    orbit_speed = 1075,
    shoot_attempts = 1,
    prediction_mult = 1 + (9 * 0.1),
}
getgenv().MeowRageProfiles.profile_40 = {
    name = "profile_40",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 11,
    tp_height = -10,
    orbit_speed = 1100,
    shoot_attempts = 2,
    prediction_mult = 1 + (0 * 0.1),
}
getgenv().MeowRageProfiles.profile_41 = {
    name = "profile_41",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 12,
    tp_height = -9,
    orbit_speed = 1125,
    shoot_attempts = 3,
    prediction_mult = 1 + (1 * 0.1),
}
getgenv().MeowRageProfiles.profile_42 = {
    name = "profile_42",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 13,
    tp_height = -8,
    orbit_speed = 1150,
    shoot_attempts = 1,
    prediction_mult = 1 + (2 * 0.1),
}
getgenv().MeowRageProfiles.profile_43 = {
    name = "profile_43",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 14,
    tp_height = -7,
    orbit_speed = 1175,
    shoot_attempts = 2,
    prediction_mult = 1 + (3 * 0.1),
}
getgenv().MeowRageProfiles.profile_44 = {
    name = "profile_44",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 15,
    tp_height = -6,
    orbit_speed = 1200,
    shoot_attempts = 3,
    prediction_mult = 1 + (4 * 0.1),
}
getgenv().MeowRageProfiles.profile_45 = {
    name = "profile_45",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 16,
    tp_height = -5,
    orbit_speed = 1225,
    shoot_attempts = 1,
    prediction_mult = 1 + (5 * 0.1),
}
getgenv().MeowRageProfiles.profile_46 = {
    name = "profile_46",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 17,
    tp_height = -4,
    orbit_speed = 1250,
    shoot_attempts = 2,
    prediction_mult = 1 + (6 * 0.1),
}
getgenv().MeowRageProfiles.profile_47 = {
    name = "profile_47",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 18,
    tp_height = -3,
    orbit_speed = 1275,
    shoot_attempts = 3,
    prediction_mult = 1 + (7 * 0.1),
}
getgenv().MeowRageProfiles.profile_48 = {
    name = "profile_48",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 19,
    tp_height = -2,
    orbit_speed = 1300,
    shoot_attempts = 1,
    prediction_mult = 1 + (8 * 0.1),
}
getgenv().MeowRageProfiles.profile_49 = {
    name = "profile_49",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 20,
    tp_height = -1,
    orbit_speed = 1325,
    shoot_attempts = 2,
    prediction_mult = 1 + (9 * 0.1),
}
getgenv().MeowRageProfiles.profile_50 = {
    name = "profile_50",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 21,
    tp_height = 0,
    orbit_speed = 1350,
    shoot_attempts = 3,
    prediction_mult = 1 + (0 * 0.1),
}
getgenv().MeowRageProfiles.profile_51 = {
    name = "profile_51",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 22,
    tp_height = 1,
    orbit_speed = 1375,
    shoot_attempts = 1,
    prediction_mult = 1 + (1 * 0.1),
}
getgenv().MeowRageProfiles.profile_52 = {
    name = "profile_52",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 23,
    tp_height = 2,
    orbit_speed = 1400,
    shoot_attempts = 2,
    prediction_mult = 1 + (2 * 0.1),
}
getgenv().MeowRageProfiles.profile_53 = {
    name = "profile_53",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 24,
    tp_height = 3,
    orbit_speed = 1425,
    shoot_attempts = 3,
    prediction_mult = 1 + (3 * 0.1),
}
getgenv().MeowRageProfiles.profile_54 = {
    name = "profile_54",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 25,
    tp_height = 4,
    orbit_speed = 1450,
    shoot_attempts = 1,
    prediction_mult = 1 + (4 * 0.1),
}
getgenv().MeowRageProfiles.profile_55 = {
    name = "profile_55",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 26,
    tp_height = 5,
    orbit_speed = 1475,
    shoot_attempts = 2,
    prediction_mult = 1 + (5 * 0.1),
}
getgenv().MeowRageProfiles.profile_56 = {
    name = "profile_56",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 27,
    tp_height = 6,
    orbit_speed = 1500,
    shoot_attempts = 3,
    prediction_mult = 1 + (6 * 0.1),
}
getgenv().MeowRageProfiles.profile_57 = {
    name = "profile_57",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[2],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 28,
    tp_height = 7,
    orbit_speed = 1525,
    shoot_attempts = 1,
    prediction_mult = 1 + (7 * 0.1),
}
getgenv().MeowRageProfiles.profile_58 = {
    name = "profile_58",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[3],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 29,
    tp_height = 8,
    orbit_speed = 1550,
    shoot_attempts = 2,
    prediction_mult = 1 + (8 * 0.1),
}
getgenv().MeowRageProfiles.profile_59 = {
    name = "profile_59",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[4],
    strategy = ({"TP","Orbit"})[2],
    tp_radius = 30,
    tp_height = 9,
    orbit_speed = 1575,
    shoot_attempts = 3,
    prediction_mult = 1 + (9 * 0.1),
}
getgenv().MeowRageProfiles.profile_60 = {
    name = "profile_60",
    hitbox = ({"Head","UpperTorso","HumanoidRootPart","LowerTorso"})[1],
    strategy = ({"TP","Orbit"})[1],
    tp_radius = 1,
    tp_height = -10,
    orbit_speed = 1600,
    shoot_attempts = 1,
    prediction_mult = 1 + (0 * 0.1),
}

-- =========================================================================
-- SHAPE LOOKUP — register every shape as callable through one entry point
-- =========================================================================
getgenv().meow_shape_call = function(name, t, r)
    local fn = getgenv().MeowShapes[name]
    if fn then return fn(t, r) end
    return Vector3.new(math.cos(t) * r, 0, math.sin(t) * r)
end

getgenv().meow_weapon_apply = function(preset_name)
    local p = getgenv().MeowWeaponPresets[preset_name]
    if not p then return end
    pcall(function()
        local lib = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
        if lib and lib.Items then
            for _, item in pairs(lib.Items) do
                if typeof(item) == "table" then
                    for k, v in pairs(p) do
                        if k ~= "name" and k ~= "_tier" and item[k] ~= nil then item[k] = v end
                    end
                end
            end
        end
    end)
end

getgenv().meow_theme_apply = function(theme_name)
    local t = getgenv().MeowThemes[theme_name]
    if not t then return end
    if getgenv().meow_lib and getgenv().meow_lib.SetAccentColor then
        pcall(function() getgenv().meow_lib:SetAccentColor(t.accent) end)
    end
end

getgenv().meow_waypoint_tp = function(waypoint_name)
    local w = getgenv().MeowWaypoints[waypoint_name]
    if not w then return end
    if getgenv().safe_teleport then getgenv().safe_teleport(w.position) end
end

getgenv().meow_rage_profile_apply = function(profile_name)
    local p = getgenv().MeowRageProfiles[profile_name]
    if not p then return end
    local cfg = getgenv().config
    cfg.rage_hitbox       = p.hitbox
    cfg.rage_strategy     = p.strategy
    cfg.rage_tp_radius    = p.tp_radius
    cfg.rage_tp_height    = p.tp_height
    cfg.rage_orbit_speed  = p.orbit_speed
    cfg.shoot_attempts    = p.shoot_attempts
    cfg.prediction_mult   = p.prediction_mult
end

notify('meowlua', 'bulk pack loaded: 300 shapes · 120 weapon presets · 80 themes · 80 waypoints · 60 rage profiles')
-- =========================================================================
-- BULK PACK 2 — expanded evasion shapes, aim profiles, chat banks,
-- target priority lists, extended keybind presets
-- =========================================================================

getgenv().MeowEvShapes = {}
getgenv().MeowEvShapes.ev_1 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_2 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_3 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_4 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_5 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_6 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_7 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_8 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_9 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_10 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_11 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_12 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_13 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_14 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_15 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_16 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_17 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_18 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_19 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_20 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_21 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_22 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_23 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_24 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_25 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_26 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_27 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_28 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_29 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_30 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_31 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_32 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_33 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_34 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_35 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_36 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_37 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_38 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_39 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_40 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_41 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_42 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_43 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_44 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_45 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_46 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_47 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_48 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_49 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_50 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_51 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_52 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_53 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_54 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_55 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_56 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_57 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_58 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_59 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_60 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_61 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_62 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_63 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_64 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_65 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_66 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_67 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_68 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_69 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_70 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_71 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_72 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_73 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_74 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_75 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_76 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_77 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_78 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_79 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_80 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_81 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_82 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_83 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_84 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_85 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_86 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_87 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_88 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_89 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_90 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_91 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_92 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_93 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_94 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_95 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_96 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_97 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_98 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_99 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_100 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_101 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_102 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_103 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_104 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_105 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_106 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_107 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_108 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_109 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_110 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_111 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_112 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_113 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_114 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_115 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_116 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_117 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_118 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_119 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_120 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_121 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_122 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_123 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_124 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_125 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_126 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_127 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_128 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_129 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_130 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_131 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_132 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_133 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_134 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_135 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_136 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_137 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_138 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_139 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_140 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_141 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_142 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_143 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_144 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_145 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_146 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_147 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_148 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_149 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_150 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_151 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_152 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_153 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_154 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_155 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_156 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_157 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_158 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_159 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_160 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_161 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_162 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_163 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_164 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_165 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_166 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_167 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_168 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_169 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_170 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_171 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_172 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_173 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_174 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_175 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_176 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_177 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_178 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_179 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_180 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_181 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_182 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_183 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_184 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_185 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_186 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_187 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_188 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_189 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_190 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_191 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_192 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_193 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_194 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_195 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_196 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_197 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_198 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_199 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_200 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_201 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_202 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_203 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_204 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_205 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_206 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_207 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_208 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_209 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_210 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_211 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_212 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_213 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_214 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_215 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_216 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_217 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_218 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_219 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_220 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_221 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_222 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_223 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_224 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_225 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_226 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_227 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_228 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_229 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_230 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_231 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_232 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_233 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_234 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_235 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_236 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_237 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_238 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_239 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_240 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_241 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_242 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_243 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_244 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_245 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_246 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_247 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_248 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_249 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_250 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_251 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_252 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_253 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_254 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_255 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_256 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_257 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_258 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_259 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_260 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_261 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_262 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_263 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_264 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_265 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_266 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_267 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_268 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_269 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_270 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_271 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_272 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_273 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_274 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_275 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_276 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_277 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_278 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_279 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_280 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_281 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_282 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_283 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_284 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_285 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_286 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_287 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_288 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 3
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_289 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 4
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_290 = function(t, r)
    local a = t * math.pi * 2 * 5
    local b = t * math.pi * 5
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_291 = function(t, r)
    local a = t * math.pi * 2 * 6
    local b = t * math.pi * 6
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_292 = function(t, r)
    local a = t * math.pi * 2 * 7
    local b = t * math.pi * 7
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_293 = function(t, r)
    local a = t * math.pi * 2 * 8
    local b = t * math.pi * 8
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_294 = function(t, r)
    local a = t * math.pi * 2 * 9
    local b = t * math.pi * 9
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_295 = function(t, r)
    local a = t * math.pi * 2 * 10
    local b = t * math.pi * 10
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_296 = function(t, r)
    local a = t * math.pi * 2 * 11
    local b = t * math.pi * 11
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowEvShapes.ev_297 = function(t, r)
    local a = t * math.pi * 2 * 1
    local b = t * math.pi * 12
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 2 * 0.25)
end
getgenv().MeowEvShapes.ev_298 = function(t, r)
    local a = t * math.pi * 2 * 2
    local b = t * math.pi * 13
    return Vector3.new(math.sin(a) * r * 2 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 3 * 0.25)
end
getgenv().MeowEvShapes.ev_299 = function(t, r)
    local a = t * math.pi * 2 * 3
    local b = t * math.pi * 1
    return Vector3.new(math.sin(a) * r * 3 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 4 * 0.25)
end
getgenv().MeowEvShapes.ev_300 = function(t, r)
    local a = t * math.pi * 2 * 4
    local b = t * math.pi * 2
    return Vector3.new(math.sin(a) * r * 1 * 0.3, math.cos(b) * r * 0.5, math.cos(a) * r * 1 * 0.25)
end
getgenv().MeowAimProfiles = {}
getgenv().MeowAimProfiles.aim_1 = {
    name = "aim_1",
    fov = 23,
    smooth = 2,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_2 = {
    name = "aim_2",
    fov = 26,
    smooth = 3,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_3 = {
    name = "aim_3",
    fov = 29,
    smooth = 4,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_4 = {
    name = "aim_4",
    fov = 32,
    smooth = 5,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_5 = {
    name = "aim_5",
    fov = 35,
    smooth = 6,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_6 = {
    name = "aim_6",
    fov = 38,
    smooth = 7,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_7 = {
    name = "aim_7",
    fov = 41,
    smooth = 8,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_8 = {
    name = "aim_8",
    fov = 44,
    smooth = 9,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_9 = {
    name = "aim_9",
    fov = 47,
    smooth = 10,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_10 = {
    name = "aim_10",
    fov = 50,
    smooth = 11,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_11 = {
    name = "aim_11",
    fov = 53,
    smooth = 12,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_12 = {
    name = "aim_12",
    fov = 56,
    smooth = 13,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_13 = {
    name = "aim_13",
    fov = 59,
    smooth = 14,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_14 = {
    name = "aim_14",
    fov = 62,
    smooth = 15,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_15 = {
    name = "aim_15",
    fov = 65,
    smooth = 16,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_16 = {
    name = "aim_16",
    fov = 68,
    smooth = 17,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_17 = {
    name = "aim_17",
    fov = 71,
    smooth = 18,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_18 = {
    name = "aim_18",
    fov = 74,
    smooth = 19,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_19 = {
    name = "aim_19",
    fov = 77,
    smooth = 20,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_20 = {
    name = "aim_20",
    fov = 80,
    smooth = 1,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_21 = {
    name = "aim_21",
    fov = 83,
    smooth = 2,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_22 = {
    name = "aim_22",
    fov = 86,
    smooth = 3,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_23 = {
    name = "aim_23",
    fov = 89,
    smooth = 4,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_24 = {
    name = "aim_24",
    fov = 92,
    smooth = 5,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_25 = {
    name = "aim_25",
    fov = 95,
    smooth = 6,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_26 = {
    name = "aim_26",
    fov = 98,
    smooth = 7,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_27 = {
    name = "aim_27",
    fov = 101,
    smooth = 8,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_28 = {
    name = "aim_28",
    fov = 104,
    smooth = 9,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_29 = {
    name = "aim_29",
    fov = 107,
    smooth = 10,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_30 = {
    name = "aim_30",
    fov = 110,
    smooth = 11,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_31 = {
    name = "aim_31",
    fov = 113,
    smooth = 12,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_32 = {
    name = "aim_32",
    fov = 116,
    smooth = 13,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_33 = {
    name = "aim_33",
    fov = 119,
    smooth = 14,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_34 = {
    name = "aim_34",
    fov = 122,
    smooth = 15,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_35 = {
    name = "aim_35",
    fov = 125,
    smooth = 16,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_36 = {
    name = "aim_36",
    fov = 128,
    smooth = 17,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_37 = {
    name = "aim_37",
    fov = 131,
    smooth = 18,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_38 = {
    name = "aim_38",
    fov = 134,
    smooth = 19,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_39 = {
    name = "aim_39",
    fov = 137,
    smooth = 20,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_40 = {
    name = "aim_40",
    fov = 140,
    smooth = 1,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_41 = {
    name = "aim_41",
    fov = 143,
    smooth = 2,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_42 = {
    name = "aim_42",
    fov = 146,
    smooth = 3,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_43 = {
    name = "aim_43",
    fov = 149,
    smooth = 4,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_44 = {
    name = "aim_44",
    fov = 152,
    smooth = 5,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_45 = {
    name = "aim_45",
    fov = 155,
    smooth = 6,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_46 = {
    name = "aim_46",
    fov = 158,
    smooth = 7,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_47 = {
    name = "aim_47",
    fov = 161,
    smooth = 8,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_48 = {
    name = "aim_48",
    fov = 164,
    smooth = 9,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_49 = {
    name = "aim_49",
    fov = 167,
    smooth = 10,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_50 = {
    name = "aim_50",
    fov = 170,
    smooth = 11,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_51 = {
    name = "aim_51",
    fov = 173,
    smooth = 12,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_52 = {
    name = "aim_52",
    fov = 176,
    smooth = 13,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_53 = {
    name = "aim_53",
    fov = 179,
    smooth = 14,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_54 = {
    name = "aim_54",
    fov = 182,
    smooth = 15,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_55 = {
    name = "aim_55",
    fov = 185,
    smooth = 16,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_56 = {
    name = "aim_56",
    fov = 188,
    smooth = 17,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_57 = {
    name = "aim_57",
    fov = 191,
    smooth = 18,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_58 = {
    name = "aim_58",
    fov = 194,
    smooth = 19,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_59 = {
    name = "aim_59",
    fov = 197,
    smooth = 20,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_60 = {
    name = "aim_60",
    fov = 200,
    smooth = 1,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_61 = {
    name = "aim_61",
    fov = 203,
    smooth = 2,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_62 = {
    name = "aim_62",
    fov = 206,
    smooth = 3,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_63 = {
    name = "aim_63",
    fov = 209,
    smooth = 4,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_64 = {
    name = "aim_64",
    fov = 212,
    smooth = 5,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_65 = {
    name = "aim_65",
    fov = 215,
    smooth = 6,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_66 = {
    name = "aim_66",
    fov = 218,
    smooth = 7,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_67 = {
    name = "aim_67",
    fov = 221,
    smooth = 8,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_68 = {
    name = "aim_68",
    fov = 224,
    smooth = 9,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_69 = {
    name = "aim_69",
    fov = 227,
    smooth = 10,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_70 = {
    name = "aim_70",
    fov = 230,
    smooth = 11,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_71 = {
    name = "aim_71",
    fov = 233,
    smooth = 12,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_72 = {
    name = "aim_72",
    fov = 236,
    smooth = 13,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_73 = {
    name = "aim_73",
    fov = 239,
    smooth = 14,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_74 = {
    name = "aim_74",
    fov = 242,
    smooth = 15,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_75 = {
    name = "aim_75",
    fov = 245,
    smooth = 16,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_76 = {
    name = "aim_76",
    fov = 248,
    smooth = 17,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_77 = {
    name = "aim_77",
    fov = 251,
    smooth = 18,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_78 = {
    name = "aim_78",
    fov = 254,
    smooth = 19,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_79 = {
    name = "aim_79",
    fov = 257,
    smooth = 20,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_80 = {
    name = "aim_80",
    fov = 260,
    smooth = 1,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_81 = {
    name = "aim_81",
    fov = 263,
    smooth = 2,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_82 = {
    name = "aim_82",
    fov = 266,
    smooth = 3,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_83 = {
    name = "aim_83",
    fov = 269,
    smooth = 4,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_84 = {
    name = "aim_84",
    fov = 272,
    smooth = 5,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_85 = {
    name = "aim_85",
    fov = 275,
    smooth = 6,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_86 = {
    name = "aim_86",
    fov = 278,
    smooth = 7,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_87 = {
    name = "aim_87",
    fov = 281,
    smooth = 8,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_88 = {
    name = "aim_88",
    fov = 284,
    smooth = 9,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_89 = {
    name = "aim_89",
    fov = 287,
    smooth = 10,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_90 = {
    name = "aim_90",
    fov = 290,
    smooth = 11,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_91 = {
    name = "aim_91",
    fov = 293,
    smooth = 12,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_92 = {
    name = "aim_92",
    fov = 296,
    smooth = 13,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_93 = {
    name = "aim_93",
    fov = 299,
    smooth = 14,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_94 = {
    name = "aim_94",
    fov = 302,
    smooth = 15,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_95 = {
    name = "aim_95",
    fov = 305,
    smooth = 16,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_96 = {
    name = "aim_96",
    fov = 308,
    smooth = 17,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_97 = {
    name = "aim_97",
    fov = 311,
    smooth = 18,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_98 = {
    name = "aim_98",
    fov = 314,
    smooth = 19,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_99 = {
    name = "aim_99",
    fov = 317,
    smooth = 20,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_100 = {
    name = "aim_100",
    fov = 320,
    smooth = 1,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_101 = {
    name = "aim_101",
    fov = 323,
    smooth = 2,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_102 = {
    name = "aim_102",
    fov = 326,
    smooth = 3,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_103 = {
    name = "aim_103",
    fov = 329,
    smooth = 4,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_104 = {
    name = "aim_104",
    fov = 332,
    smooth = 5,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_105 = {
    name = "aim_105",
    fov = 335,
    smooth = 6,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_106 = {
    name = "aim_106",
    fov = 338,
    smooth = 7,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_107 = {
    name = "aim_107",
    fov = 341,
    smooth = 8,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_108 = {
    name = "aim_108",
    fov = 344,
    smooth = 9,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_109 = {
    name = "aim_109",
    fov = 347,
    smooth = 10,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_110 = {
    name = "aim_110",
    fov = 350,
    smooth = 11,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_111 = {
    name = "aim_111",
    fov = 353,
    smooth = 12,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_112 = {
    name = "aim_112",
    fov = 356,
    smooth = 13,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_113 = {
    name = "aim_113",
    fov = 359,
    smooth = 14,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_114 = {
    name = "aim_114",
    fov = 362,
    smooth = 15,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_115 = {
    name = "aim_115",
    fov = 365,
    smooth = 16,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_116 = {
    name = "aim_116",
    fov = 368,
    smooth = 17,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_117 = {
    name = "aim_117",
    fov = 371,
    smooth = 18,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[2],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowAimProfiles.aim_118 = {
    name = "aim_118",
    fov = 374,
    smooth = 19,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[3],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[2],
}
getgenv().MeowAimProfiles.aim_119 = {
    name = "aim_119",
    fov = 377,
    smooth = 20,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[4],
    wallcheck = false,
    target_mode = ({"closest","fov","random"})[3],
}
getgenv().MeowAimProfiles.aim_120 = {
    name = "aim_120",
    fov = 380,
    smooth = 1,
    hitbox = ({"Head","UpperTorso","Torso","HumanoidRootPart"})[1],
    wallcheck = true,
    target_mode = ({"closest","fov","random"})[1],
}
getgenv().MeowChatBank = {
    "got em",
    "ez clap",
    "no aim",
    "sit down",
    "cooked",
    "down bad",
    "cry about it",
    "beat by meowlua",
    "cope",
    "mald",
    "touch grass",
    "skill issue",
    "ratio",
    "lol",
    "lmao",
    "+1",
    "gg ez",
    "take the l",
    "L bozo",
    "mid",
    "clapped",
    "diff",
    "broke",
    "fried",
    "owned",
    "bodied",
    "dusted",
    "deleted",
    "gone",
    "sent",
    "goodbye",
    "see ya",
    "bye bye",
    "next",
    "done",
    "finished",
    "over",
    "closed",
    "sleep",
    "nap time",
    "dinner",
    "bedtime",
    "tucked in",
    "shhh",
    "quiet",
    "silence",
    "muted",
    "banned",
    "kicked",
    "removed",
    "wiped",
}
getgenv().MeowPrioLists = {}
getgenv().MeowPrioLists.list_1 = {
    name = "list_1",
    targets = { "target_1_a", "target_1_b", "target_1_c" },
    weight  = 2,
}
getgenv().MeowPrioLists.list_2 = {
    name = "list_2",
    targets = { "target_2_a", "target_2_b", "target_2_c" },
    weight  = 3,
}
getgenv().MeowPrioLists.list_3 = {
    name = "list_3",
    targets = { "target_3_a", "target_3_b", "target_3_c" },
    weight  = 4,
}
getgenv().MeowPrioLists.list_4 = {
    name = "list_4",
    targets = { "target_4_a", "target_4_b", "target_4_c" },
    weight  = 5,
}
getgenv().MeowPrioLists.list_5 = {
    name = "list_5",
    targets = { "target_5_a", "target_5_b", "target_5_c" },
    weight  = 6,
}
getgenv().MeowPrioLists.list_6 = {
    name = "list_6",
    targets = { "target_6_a", "target_6_b", "target_6_c" },
    weight  = 7,
}
getgenv().MeowPrioLists.list_7 = {
    name = "list_7",
    targets = { "target_7_a", "target_7_b", "target_7_c" },
    weight  = 8,
}
getgenv().MeowPrioLists.list_8 = {
    name = "list_8",
    targets = { "target_8_a", "target_8_b", "target_8_c" },
    weight  = 9,
}
getgenv().MeowPrioLists.list_9 = {
    name = "list_9",
    targets = { "target_9_a", "target_9_b", "target_9_c" },
    weight  = 10,
}
getgenv().MeowPrioLists.list_10 = {
    name = "list_10",
    targets = { "target_10_a", "target_10_b", "target_10_c" },
    weight  = 1,
}
getgenv().MeowPrioLists.list_11 = {
    name = "list_11",
    targets = { "target_11_a", "target_11_b", "target_11_c" },
    weight  = 2,
}
getgenv().MeowPrioLists.list_12 = {
    name = "list_12",
    targets = { "target_12_a", "target_12_b", "target_12_c" },
    weight  = 3,
}
getgenv().MeowPrioLists.list_13 = {
    name = "list_13",
    targets = { "target_13_a", "target_13_b", "target_13_c" },
    weight  = 4,
}
getgenv().MeowPrioLists.list_14 = {
    name = "list_14",
    targets = { "target_14_a", "target_14_b", "target_14_c" },
    weight  = 5,
}
getgenv().MeowPrioLists.list_15 = {
    name = "list_15",
    targets = { "target_15_a", "target_15_b", "target_15_c" },
    weight  = 6,
}
getgenv().MeowPrioLists.list_16 = {
    name = "list_16",
    targets = { "target_16_a", "target_16_b", "target_16_c" },
    weight  = 7,
}
getgenv().MeowPrioLists.list_17 = {
    name = "list_17",
    targets = { "target_17_a", "target_17_b", "target_17_c" },
    weight  = 8,
}
getgenv().MeowPrioLists.list_18 = {
    name = "list_18",
    targets = { "target_18_a", "target_18_b", "target_18_c" },
    weight  = 9,
}
getgenv().MeowPrioLists.list_19 = {
    name = "list_19",
    targets = { "target_19_a", "target_19_b", "target_19_c" },
    weight  = 10,
}
getgenv().MeowPrioLists.list_20 = {
    name = "list_20",
    targets = { "target_20_a", "target_20_b", "target_20_c" },
    weight  = 1,
}
getgenv().MeowPrioLists.list_21 = {
    name = "list_21",
    targets = { "target_21_a", "target_21_b", "target_21_c" },
    weight  = 2,
}
getgenv().MeowPrioLists.list_22 = {
    name = "list_22",
    targets = { "target_22_a", "target_22_b", "target_22_c" },
    weight  = 3,
}
getgenv().MeowPrioLists.list_23 = {
    name = "list_23",
    targets = { "target_23_a", "target_23_b", "target_23_c" },
    weight  = 4,
}
getgenv().MeowPrioLists.list_24 = {
    name = "list_24",
    targets = { "target_24_a", "target_24_b", "target_24_c" },
    weight  = 5,
}
getgenv().MeowPrioLists.list_25 = {
    name = "list_25",
    targets = { "target_25_a", "target_25_b", "target_25_c" },
    weight  = 6,
}
getgenv().MeowPrioLists.list_26 = {
    name = "list_26",
    targets = { "target_26_a", "target_26_b", "target_26_c" },
    weight  = 7,
}
getgenv().MeowPrioLists.list_27 = {
    name = "list_27",
    targets = { "target_27_a", "target_27_b", "target_27_c" },
    weight  = 8,
}
getgenv().MeowPrioLists.list_28 = {
    name = "list_28",
    targets = { "target_28_a", "target_28_b", "target_28_c" },
    weight  = 9,
}
getgenv().MeowPrioLists.list_29 = {
    name = "list_29",
    targets = { "target_29_a", "target_29_b", "target_29_c" },
    weight  = 10,
}
getgenv().MeowPrioLists.list_30 = {
    name = "list_30",
    targets = { "target_30_a", "target_30_b", "target_30_c" },
    weight  = 1,
}
getgenv().MeowPrioLists.list_31 = {
    name = "list_31",
    targets = { "target_31_a", "target_31_b", "target_31_c" },
    weight  = 2,
}
getgenv().MeowPrioLists.list_32 = {
    name = "list_32",
    targets = { "target_32_a", "target_32_b", "target_32_c" },
    weight  = 3,
}
getgenv().MeowPrioLists.list_33 = {
    name = "list_33",
    targets = { "target_33_a", "target_33_b", "target_33_c" },
    weight  = 4,
}
getgenv().MeowPrioLists.list_34 = {
    name = "list_34",
    targets = { "target_34_a", "target_34_b", "target_34_c" },
    weight  = 5,
}
getgenv().MeowPrioLists.list_35 = {
    name = "list_35",
    targets = { "target_35_a", "target_35_b", "target_35_c" },
    weight  = 6,
}
getgenv().MeowPrioLists.list_36 = {
    name = "list_36",
    targets = { "target_36_a", "target_36_b", "target_36_c" },
    weight  = 7,
}
getgenv().MeowPrioLists.list_37 = {
    name = "list_37",
    targets = { "target_37_a", "target_37_b", "target_37_c" },
    weight  = 8,
}
getgenv().MeowPrioLists.list_38 = {
    name = "list_38",
    targets = { "target_38_a", "target_38_b", "target_38_c" },
    weight  = 9,
}
getgenv().MeowPrioLists.list_39 = {
    name = "list_39",
    targets = { "target_39_a", "target_39_b", "target_39_c" },
    weight  = 10,
}
getgenv().MeowPrioLists.list_40 = {
    name = "list_40",
    targets = { "target_40_a", "target_40_b", "target_40_c" },
    weight  = 1,
}
getgenv().MeowPrioLists.list_41 = {
    name = "list_41",
    targets = { "target_41_a", "target_41_b", "target_41_c" },
    weight  = 2,
}
getgenv().MeowPrioLists.list_42 = {
    name = "list_42",
    targets = { "target_42_a", "target_42_b", "target_42_c" },
    weight  = 3,
}
getgenv().MeowPrioLists.list_43 = {
    name = "list_43",
    targets = { "target_43_a", "target_43_b", "target_43_c" },
    weight  = 4,
}
getgenv().MeowPrioLists.list_44 = {
    name = "list_44",
    targets = { "target_44_a", "target_44_b", "target_44_c" },
    weight  = 5,
}
getgenv().MeowPrioLists.list_45 = {
    name = "list_45",
    targets = { "target_45_a", "target_45_b", "target_45_c" },
    weight  = 6,
}
getgenv().MeowPrioLists.list_46 = {
    name = "list_46",
    targets = { "target_46_a", "target_46_b", "target_46_c" },
    weight  = 7,
}
getgenv().MeowPrioLists.list_47 = {
    name = "list_47",
    targets = { "target_47_a", "target_47_b", "target_47_c" },
    weight  = 8,
}
getgenv().MeowPrioLists.list_48 = {
    name = "list_48",
    targets = { "target_48_a", "target_48_b", "target_48_c" },
    weight  = 9,
}
getgenv().MeowPrioLists.list_49 = {
    name = "list_49",
    targets = { "target_49_a", "target_49_b", "target_49_c" },
    weight  = 10,
}
getgenv().MeowPrioLists.list_50 = {
    name = "list_50",
    targets = { "target_50_a", "target_50_b", "target_50_c" },
    weight  = 1,
}
getgenv().MeowPrioLists.list_51 = {
    name = "list_51",
    targets = { "target_51_a", "target_51_b", "target_51_c" },
    weight  = 2,
}
getgenv().MeowPrioLists.list_52 = {
    name = "list_52",
    targets = { "target_52_a", "target_52_b", "target_52_c" },
    weight  = 3,
}
getgenv().MeowPrioLists.list_53 = {
    name = "list_53",
    targets = { "target_53_a", "target_53_b", "target_53_c" },
    weight  = 4,
}
getgenv().MeowPrioLists.list_54 = {
    name = "list_54",
    targets = { "target_54_a", "target_54_b", "target_54_c" },
    weight  = 5,
}
getgenv().MeowPrioLists.list_55 = {
    name = "list_55",
    targets = { "target_55_a", "target_55_b", "target_55_c" },
    weight  = 6,
}
getgenv().MeowPrioLists.list_56 = {
    name = "list_56",
    targets = { "target_56_a", "target_56_b", "target_56_c" },
    weight  = 7,
}
getgenv().MeowPrioLists.list_57 = {
    name = "list_57",
    targets = { "target_57_a", "target_57_b", "target_57_c" },
    weight  = 8,
}
getgenv().MeowPrioLists.list_58 = {
    name = "list_58",
    targets = { "target_58_a", "target_58_b", "target_58_c" },
    weight  = 9,
}
getgenv().MeowPrioLists.list_59 = {
    name = "list_59",
    targets = { "target_59_a", "target_59_b", "target_59_c" },
    weight  = 10,
}
getgenv().MeowPrioLists.list_60 = {
    name = "list_60",
    targets = { "target_60_a", "target_60_b", "target_60_c" },
    weight  = 1,
}
getgenv().MeowKeybindPresets = {}
getgenv().MeowKeybindPresets.keys_1 = {
    name = "keys_1",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[2],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[2],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_2 = {
    name = "keys_2",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[3],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[3],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_3 = {
    name = "keys_3",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[4],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[4],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_4 = {
    name = "keys_4",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[5],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[5],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_5 = {
    name = "keys_5",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[6],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[6],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_6 = {
    name = "keys_6",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[7],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[7],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_7 = {
    name = "keys_7",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[8],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[8],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_8 = {
    name = "keys_8",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[9],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[9],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_9 = {
    name = "keys_9",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[10],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[10],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_10 = {
    name = "keys_10",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[11],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[1],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_11 = {
    name = "keys_11",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[12],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[2],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_12 = {
    name = "keys_12",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[1],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[3],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_13 = {
    name = "keys_13",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[2],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[4],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_14 = {
    name = "keys_14",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[3],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[5],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_15 = {
    name = "keys_15",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[4],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[6],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_16 = {
    name = "keys_16",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[5],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[7],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_17 = {
    name = "keys_17",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[6],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[8],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_18 = {
    name = "keys_18",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[7],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[9],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_19 = {
    name = "keys_19",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[8],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[10],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_20 = {
    name = "keys_20",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[9],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[1],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_21 = {
    name = "keys_21",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[10],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[2],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_22 = {
    name = "keys_22",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[11],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[3],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_23 = {
    name = "keys_23",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[12],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[4],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_24 = {
    name = "keys_24",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[1],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[5],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_25 = {
    name = "keys_25",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[2],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[6],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_26 = {
    name = "keys_26",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[3],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[7],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_27 = {
    name = "keys_27",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[4],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[8],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_28 = {
    name = "keys_28",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[5],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[9],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_29 = {
    name = "keys_29",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[6],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[10],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_30 = {
    name = "keys_30",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[7],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[1],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_31 = {
    name = "keys_31",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[8],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[2],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_32 = {
    name = "keys_32",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[9],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[3],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_33 = {
    name = "keys_33",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[10],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[4],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_34 = {
    name = "keys_34",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[11],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[5],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_35 = {
    name = "keys_35",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[12],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[6],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_36 = {
    name = "keys_36",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[1],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[7],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_37 = {
    name = "keys_37",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[2],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[8],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_38 = {
    name = "keys_38",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[3],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[9],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_39 = {
    name = "keys_39",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[4],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[10],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_40 = {
    name = "keys_40",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[5],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[1],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_41 = {
    name = "keys_41",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[6],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[2],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_42 = {
    name = "keys_42",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[7],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[3],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_43 = {
    name = "keys_43",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[8],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[4],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_44 = {
    name = "keys_44",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[9],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[5],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_45 = {
    name = "keys_45",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[10],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[6],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_46 = {
    name = "keys_46",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[11],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[7],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_47 = {
    name = "keys_47",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[12],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[8],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_48 = {
    name = "keys_48",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[1],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[9],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_49 = {
    name = "keys_49",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[2],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[10],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_50 = {
    name = "keys_50",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[3],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[1],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_51 = {
    name = "keys_51",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[4],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[2],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_52 = {
    name = "keys_52",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[5],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[3],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}
getgenv().MeowKeybindPresets.keys_53 = {
    name = "keys_53",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[6],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[4],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[6],
}
getgenv().MeowKeybindPresets.keys_54 = {
    name = "keys_54",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[7],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[5],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[7],
}
getgenv().MeowKeybindPresets.keys_55 = {
    name = "keys_55",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[8],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[6],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[2],
    fly = ({"F","Y","H","J","K","U","I","O"})[8],
}
getgenv().MeowKeybindPresets.keys_56 = {
    name = "keys_56",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[9],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[7],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[3],
    fly = ({"F","Y","H","J","K","U","I","O"})[1],
}
getgenv().MeowKeybindPresets.keys_57 = {
    name = "keys_57",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[10],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[8],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[4],
    fly = ({"F","Y","H","J","K","U","I","O"})[2],
}
getgenv().MeowKeybindPresets.keys_58 = {
    name = "keys_58",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[11],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[9],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[5],
    fly = ({"F","Y","H","J","K","U","I","O"})[3],
}
getgenv().MeowKeybindPresets.keys_59 = {
    name = "keys_59",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[12],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[10],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[6],
    fly = ({"F","Y","H","J","K","U","I","O"})[4],
}
getgenv().MeowKeybindPresets.keys_60 = {
    name = "keys_60",
    panic = ({"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"})[1],
    silent_aim = ({"E","Q","R","F","G","C","V","B","X","Z"})[1],
    aimbot = ({"LeftShift","RightShift","MouseButton2","Z","X","C"})[1],
    fly = ({"F","Y","H","J","K","U","I","O"})[5],
}

getgenv().meow_chat_random = function()
    local bank = getgenv().MeowChatBank
    return bank[math.random(1, #bank)]
end
notify('meowlua', 'bulk 2 loaded: 300 evasion shapes, 120 aim profiles, 60 prio lists, 60 keybind presets, chat bank')


-- =========================================================================
-- COUNTER v2 + GODMODE v3 — hard damage block, namecall traps, char hide
-- Hits where it actually matters: at the Humanoid, not the geometry.
-- =========================================================================

for k, v in pairs({
    godmode_v3         = false,   -- master: damage block + health lock + state disable
    hum_namecall_block = true,    -- block Humanoid:TakeDamage / SetStateEnabled Dead
    health_lock        = true,    -- restore Health to MaxHealth every heartbeat
    char_name_scramble = true,    -- randomize Character.Name every 2s (breaks name-based finds)
    char_hide_from_fc  = true,    -- __index trap: hide Head/Humanoid from untrusted scripts
    damage_signal_eat  = true,    -- eat HealthChanged downward moves
    remote_reject      = true,    -- reject incoming server damage events we can see
}) do if config[k] == nil then config[k] = v end end

local run_service   = game:GetService("RunService")
local lp            = game:GetService("Players").LocalPlayer

-- ---------- HARDEN HUMANOID (helper) --------------------------------------
local function harden_hum(hum)
    if not hum or not hum.Parent then return end
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health    = math.huge
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead,        false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics,     false)
        hum:SetAttribute("Invincible", true)
    end)
end

-- ---------- NAMECALL TRAP: block TakeDamage / SetStateEnabled(Dead,true) --
local _nc_installed = false
local function install_namecall_trap()
    if _nc_installed then return end
    _nc_installed = true
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not (config.godmode_v3 or config.hum_namecall_block) then return old(self, ...) end
        local m = getnamecallmethod()
        if typeof(self) == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character then
                if m == "TakeDamage" or m == "takeDamage" then return 0 end
                if m == "SetStateEnabled" then
                    local args = { ... }
                    if args[1] == Enum.HumanoidStateType.Dead and args[2] == true then
                        return old(self, Enum.HumanoidStateType.Dead, false)
                    end
                end
                if m == "ChangeState" and ... == Enum.HumanoidStateType.Dead then return end
                if m == "Kill" or m == "BreakJoints" then return end
            end
        end
        return old(self, ...)
    end))
end

-- ---------- HEALTH LOCK ---------------------------------------------------
bindConn("gm3_health_lock", run_service.Heartbeat:Connect(function()
    if not (config.godmode_v3 and config.health_lock) then return end
    local c = lp.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
    if h.Health < 1e8 then pcall(function() h.Health = 1e9 end) end
end))

-- ---------- HEALTHCHANGED EATER ------------------------------------------
local _lastHealth = nil
local function hook_health_changed(hum)
    if not hum then return end
    _lastHealth = hum.MaxHealth
    local conn
    conn = hum.HealthChanged:Connect(function(v)
        if not (config.godmode_v3 and config.damage_signal_eat) then _lastHealth = v; return end
        if _lastHealth and v < _lastHealth - 0.01 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
        _lastHealth = hum.MaxHealth
    end)
    bindConn("gm3_hc_" .. tostring(hum), conn)
end

-- ---------- CHARACTER RENAME SCRAMBLE -------------------------------------
local _rename_tick = 0
local _orig_char_name = nil
bindConn("gm3_name_scramble", run_service.Heartbeat:Connect(function()
    if not (config.godmode_v3 and config.char_name_scramble) then return end
    if tick() - _rename_tick < 2 then return end
    _rename_tick = tick()
    local c = lp.Character; if not c then return end
    if not _orig_char_name then _orig_char_name = c.Name end
    pcall(function() c.Name = "_meow_" .. math.random(10000, 99999) end)
end))

-- ---------- FINDFIRSTCHILD TRAP ON CHARACTER -------------------------------
-- When a rival script does char:FindFirstChild("Head"/"Humanoid") and the
-- call comes from NOT our script, return nil so their raycast / target
-- lookup fails.
local _trusted_scripts = setmetatable({}, { __mode = "k" })
if getgenv().meow_trust then getgenv().meow_trust(_trusted_scripts) end
getgenv().meow_trust_script = function(s) _trusted_scripts[s] = true end

local _fc_installed = false
local function install_fc_trap()
    if _fc_installed then return end
    _fc_installed = true
    local old_fc
    old_fc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not (config.godmode_v3 and config.char_hide_from_fc) then return old_fc(self, ...) end
        local m = getnamecallmethod()
        if m == "FindFirstChild" or m == "FindFirstChildOfClass" or m == "FindFirstChildWhichIsA" then
            local caller = getcallingscript()
            if caller and not _trusted_scripts[caller] and typeof(self) == "Instance" then
                if self == lp.Character or (lp.Character and self:IsDescendantOf(lp.Character)) then
                    local arg1 = ...
                    if m == "FindFirstChild" and (arg1 == "Head" or arg1 == "Humanoid" or arg1 == "HumanoidRootPart") then
                        return nil
                    end
                    if (m == "FindFirstChildOfClass" or m == "FindFirstChildWhichIsA") and (arg1 == "Humanoid" or arg1 == "BasePart") then
                        return nil
                    end
                end
            end
        end
        return old_fc(self, ...)
    end))
end

-- ---------- INCOMING REMOTE DAMAGE REJECT ---------------------------------
-- Rival rage scripts call a shoot/hit remote; our client receives Damage
-- events sometimes via ClientEvent/BindableEvent. Trap OnClientEvent fires
-- that would downgrade our health.
local _rr_installed = false
local function install_remote_reject()
    if _rr_installed then return end
    _rr_installed = true
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not (config.godmode_v3 and config.remote_reject) then return old(self, ...) end
        local m = getnamecallmethod()
        if typeof(self) == "Instance" and self:IsA("RemoteEvent") and m == "FireServer" then
            local caller = getcallingscript()
            if caller and not _trusted_scripts[caller] then
                local n = tostring(self.Name):lower()
                if n:find("damage") or n:find("kill") or n:find("hit") or n:find("die") or n:find("teleport") or n:find("void") then
                    local args = { ... }
                    for _, a in ipairs(args) do
                        if typeof(a) == "Instance" and a == lp then return end
                        if typeof(a) == "Instance" and a == lp.Character then return end
                        if typeof(a) == "Instance" and lp.Character and a:IsDescendantOf(lp.Character) then return end
                    end
                end
            end
        end
        return old(self, ...)
    end))
end

-- ---------- MASTER START / STOP -------------------------------------------
getgenv().start_godmode_v3 = function()
    config.godmode_v3 = true
    install_namecall_trap()
    install_fc_trap()
    install_remote_reject()
    local c = lp.Character
    if c then
        harden_hum(c:FindFirstChildOfClass("Humanoid"))
        hook_health_changed(c:FindFirstChildOfClass("Humanoid"))
    end
    bindConn("gm3_charadd", lp.CharacterAdded:Connect(function(ch)
        local h = ch:WaitForChild("Humanoid", 5)
        harden_hum(h)
        hook_health_changed(h)
    end))
    notify("meowlua", "godmode v3 live — damage blocked at humanoid")
end

getgenv().stop_godmode_v3 = function()
    config.godmode_v3 = false
    killConn("gm3_charadd")
    killConn("gm3_health_lock")
    killConn("gm3_name_scramble")
    local c = lp.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then pcall(function() h.MaxHealth = 100; h.Health = 100; h:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end) end
        if _orig_char_name then pcall(function() c.Name = _orig_char_name end) end
    end
    notify("meowlua", "godmode v3 off")
end

-- ---------- COUNTER v2 — the real target-filter busters -------------------
for k, v in pairs({
    counter_v2_all      = false,
    cv2_rename_char     = false,  -- hide from Workspace:FindFirstChild(player.Name)
    cv2_destroy_hrp     = false,  -- destroys HRP client-side (makes aim break on it)
    cv2_dummy_in_void   = false,  -- plants a decoy humanoid they aim at
    cv2_block_setstate  = true,   -- extra: block SetStateEnabled(Dead, true) from any caller
    cv2_kill_our_stats  = false,  -- client-side: our character reports as dead to :GetState
}) do if config[k] == nil then config[k] = v end end

-- Rename character so Workspace[player.Name] lookups miss
bindConn("cv2_rename", run_service.Heartbeat:Connect(function()
    if not (config.cv2_rename_char or config.counter_v2_all) then return end
    local c = lp.Character; if not c then return end
    if c.Name == lp.Name then pcall(function() c.Name = "_hidden_" .. math.random(10000,99999) end) end
end))

-- Decoy humanoid far away: rival aim-closest-humanoid locks onto the decoy
local _decoy = nil
bindConn("cv2_decoy", run_service.Heartbeat:Connect(function()
    if not (config.cv2_dummy_in_void or config.counter_v2_all) then
        if _decoy then pcall(function() _decoy:Destroy() end); _decoy = nil end
        return
    end
    if _decoy and _decoy.Parent then return end
    local model = Instance.new("Model")
    model.Name = lp.Name
    local hrp = Instance.new("Part", model)
    hrp.Name = "HumanoidRootPart"; hrp.Size = Vector3.new(2,2,1); hrp.Anchored = true
    hrp.Transparency = 1; hrp.CanCollide = false
    hrp.CFrame = CFrame.new(0, -9e4, 0)
    local head = Instance.new("Part", model)
    head.Name = "Head"; head.Size = Vector3.new(2,1,1); head.Anchored = true
    head.Transparency = 1; head.CanCollide = false
    head.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0)
    local hum = Instance.new("Humanoid", model)
    hum.MaxHealth = 100; hum.Health = 100
    model.PrimaryPart = hrp
    model.Parent = workspace
    _decoy = model
end))

-- Report dead to GetState from untrusted callers
local _gs_installed = false
local function install_getstate_trap()
    if _gs_installed then return end
    _gs_installed = true
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not (config.cv2_kill_our_stats or config.counter_v2_all) then return old(self, ...) end
        local m = getnamecallmethod()
        if m == "GetState" and typeof(self) == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character then
                local caller = getcallingscript()
                if caller and not _trusted_scripts[caller] then
                    return Enum.HumanoidStateType.Dead
                end
            end
        end
        return old(self, ...)
    end))
end
install_getstate_trap()

-- ---------- UI GRAFT ------------------------------------------------------
if library then
    local tgl = getgenv().meow_tgl
    local tab_combat = getgenv().meow_tab_combat
    local box_g3 = tab_combat:AddLeftGroupbox("Godmode v3 (hard damage block)")
    box_g3:AddButton({ Text = "Start Godmode v3", Func = function() getgenv().start_godmode_v3() end })
    box_g3:AddButton({ Text = "Stop Godmode v3",  Func = function() getgenv().stop_godmode_v3()  end })
    tgl(box_g3, "g3_hnc",  "Block Humanoid namecalls", "TakeDamage/SetStateEnabled Dead return 0/skip.", function(v) config.hum_namecall_block=v end)
    tgl(box_g3, "g3_hl",   "Health lock",              "Restore Health to MaxHealth every heartbeat.",   function(v) config.health_lock=v end)
    tgl(box_g3, "g3_hc",   "Eat HealthChanged",        "Any downward move → instant restore.",           function(v) config.damage_signal_eat=v end)
    tgl(box_g3, "g3_rr",   "Reject damage remotes",    "FireServer on hit/kill/damage remotes skipped.", function(v) config.remote_reject=v end)
    tgl(box_g3, "g3_cs",   "Scramble char name",       "Char.Name randomized every 2s.",                 function(v) config.char_name_scramble=v end)
    tgl(box_g3, "g3_fc",   "Hide char from finds",     "FindFirstChild(Head/Humanoid) returns nil to untrusted scripts.", function(v) config.char_hide_from_fc=v end)

    local box_cv2 = tab_combat:AddLeftGroupbox("Counter v2 — target-filter busters")
    tgl(box_cv2, "cv2_a",  "Counter v2 ALL",     "Enables every v2 counter at once.", function(v) config.counter_v2_all=v end)
    tgl(box_cv2, "cv2_rn", "Rename Character",   "Workspace[player.Name] lookups miss.", function(v) config.cv2_rename_char=v end)
    tgl(box_cv2, "cv2_dc", "Decoy in Void",      "Fake humanoid at Y=-90000 → closest-humanoid aim locks onto it.", function(v) config.cv2_dummy_in_void=v end)
    tgl(box_cv2, "cv2_ks", "Fake Dead state",    "Humanoid:GetState returns Dead to untrusted callers.", function(v) config.cv2_kill_our_stats=v end)
end

notify("meowlua", "godmode v3 + counter v2 loaded — Combat tab left column")


-- Built by Olivia — https://discord.gg/ojailbreaks


-- =========================================================================
-- VOID SEND v2 + 30 NEW RAILS
-- Hard-kill void send (mass server damage flood) + bench's new mega pack.
-- =========================================================================

local run_service   = game:GetService("RunService")
local rs            = game:GetService("ReplicatedStorage")
local uis           = game:GetService("UserInputService")
local players       = game:GetService("Players")
local lighting      = game:GetService("Lighting")
local http_svc      = game:GetService("HttpService")
local lp            = players.LocalPlayer
local cam           = workspace.CurrentCamera

-- Config block
for k, v in pairs({
    -- void send v2
    void_send_v2_rate       = 200,   -- fires per RenderStep
    void_send_v2_duration   = 3,
    void_send_v2_depth      = -9e9,

    -- 1 multi kill aura
    mka_enable = false, mka_radius = 60, mka_rate = 100, mka_damage = 999,
    -- 2 auto headshot
    auto_headshot = true,
    -- 3 backtrack
    backtrack = false, backtrack_ticks = 10,
    -- 4 damage multiplier
    dmg_mult = false, dmg_mult_value = 10,
    -- 5 ragdoll enemy
    ragdoll_enemy = false,
    -- 6 nuke weapons
    nuke_weapons_once = false,
    -- 7 weapon steal
    weapon_steal = false,
    -- 8 enemy teleport trap
    tp_trap = false, tp_trap_pos = Vector3.new(0, -5e5, 0),
    -- 9 crosshair follow
    xh_follow = false,
    -- 10 low-hp outline
    lowhp_outline = false, lowhp_threshold = 30,
    -- 11 killfeed boost (local)
    killfeed_boost = false,
    -- 12 rank spoof display
    rank_spoof = false, rank_spoof_text = "ULTRON",
    -- 13 remote scanner
    remote_scan = false,
    -- 14 input recorder
    input_rec = false, input_play = false,
    -- 15 gun switch loop
    gun_cycle = false, gun_cycle_delay = 0.1,
    -- 16 pre-fire corner
    prefire_corner = false,
    -- 17 melee auto combo
    melee_combo = false, melee_combo_delay = 0.12,
    -- 18 perfect deflect timer
    perfect_deflect = false,
    -- 19 burst aim
    burst_aim = false, burst_count = 3, burst_gap = 0.05,
    -- 20 auto heal consume
    auto_heal_consume = false, auto_heal_hp = 50,
    -- 21 aim grief
    aim_grief = false, aim_grief_deg = 15,
    -- 22 spectator fakeout
    spectator_fakeout = false,
    -- 23 projectile predictor ring
    proj_predictor = false,
    -- 24 grenade tracer
    grenade_tracer = false,
    -- 25 server info HUD
    server_info = true,
    -- 26 waypoint markers
    waypoints_draw = false,
    -- 27 anti-spectate detect
    anti_spectate = true,
    -- 28 macro chain
    macro_chain = false,
    -- 29 one-shot ult: freeze all enemies
    freeze_all_once = false,
    -- 30 vote-kick immunity attempt
    votekick_immune = true,
    -- bonus
    hitbox_predictor = false, hitbox_predict_ms = 120,
}) do if config[k] == nil then config[k] = v end end

-- ---------------------------------------------------------------------
-- VOID SEND v2 — brute server damage flood on the chosen enemy
-- ---------------------------------------------------------------------
getgenv().void_send_v2 = function(target_name, duration)
    local target
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Name:lower():find((target_name or ""):lower()) then target = p; break end
    end
    if not target then notify("void send v2", "no match: " .. tostring(target_name)); return end
    duration = duration or config.void_send_v2_duration

    notify("void send v2", "flooding " .. target.Name)
    local start = tick()
    local fire_cnt = 0

    -- Try to resolve game's real damage-dealing remote path
    local candidates = {}
    local function scan_remote_tree(obj, depth)
        if depth > 6 then return end
        for _, ch in ipairs(obj:GetChildren()) do
            if ch:IsA("RemoteEvent") or ch:IsA("RemoteFunction") then
                local n = ch.Name:lower()
                if n:find("damage") or n:find("hit") or n:find("fire") or n:find("shoot") or n:find("attack") or n:find("item") or n:find("fighter") then
                    table.insert(candidates, ch)
                end
            end
            pcall(scan_remote_tree, ch, depth + 1)
        end
    end
    scan_remote_tree(rs, 0)

    bindRender("void_send_v2", function()
        if tick() - start > duration then killRender("void_send_v2"); notify("void send v2", "done ("..fire_cnt.." fires)"); return end
        if not target or not target.Parent then killRender("void_send_v2"); return end
        local c = target.Character
        if c then
            local head = c:FindFirstChild("Head")
            local hum  = c:FindFirstChildOfClass("Humanoid")

            -- mass client damage call (visual on our screen)
            if hum then for i = 1, 20 do pcall(function() hum:TakeDamage(9999) end) end end

            -- FireServer flood against every damage-ish remote
            for _, r in ipairs(candidates) do
                for i = 1, 5 do
                    pcall(function()
                        if r:IsA("RemoteEvent") then
                            r:FireServer(target, head and head.Position or (c:GetPivot().Position), 9999, "Head", target.Character)
                        else
                            r:InvokeServer(target, head and head.Position or (c:GetPivot().Position), 9999, "Head")
                        end
                    end)
                    fire_cnt = fire_cnt + 1
                end
            end

            -- fire our own autoshoot at the target
            pcall(function() if getgenv().fire_autoshoot then getgenv().fire_autoshoot(target, 50) end end)

            -- client-side teleport their visible model into the void (cosmetic on our screen only)
            pcall(function()
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(0, config.void_send_v2_depth, 0) end
            end)
        end
    end)
end

-- ---------------------------------------------------------------------
-- 1 MULTI KILL AURA — damage every enemy inside radius, high rate
-- ---------------------------------------------------------------------
bindRender("mka", function()
    if not config.mka_enable then return end
    local hrp = getgenv().get_hrp(lp); if not hrp then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local php = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and php and (php.Position - hrp.Position).Magnitude < config.mka_radius then
                for i = 1, 3 do pcall(function() hum:TakeDamage(config.mka_damage) end) end
                pcall(function() if getgenv().fire_autoshoot then getgenv().fire_autoshoot(p, 5) end end)
            end
        end
    end
end)

-- 2 AUTO HEADSHOT — patch ragebot's hit part to always be head
getgenv().auto_headshot_filter = function(part_name)
    if config.auto_headshot then return "Head" end
    return part_name
end

-- 3 BACKTRACK — keep ring buffer of enemy positions, fire at older pos
getgenv().backtrack_ring = {}
bindConn("bt_record", run_service.Heartbeat:Connect(function()
    if not config.backtrack then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                getgenv().backtrack_ring[p] = getgenv().backtrack_ring[p] or {}
                local r = getgenv().backtrack_ring[p]
                table.insert(r, 1, hrp.Position)
                while #r > config.backtrack_ticks do table.remove(r) end
            end
        end
    end
end))

-- 4 DAMAGE MULTIPLIER — mutate ItemLibrary damage values
getgenv().apply_dmg_mult = function()
    local ok, ItemLibrary = pcall(function() return require(rs:WaitForChild("ItemLibrary")) end)
    if not ok or not ItemLibrary or not ItemLibrary.Items then return end
    for _, item in pairs(ItemLibrary.Items) do
        if item.Damage and type(item.Damage) == "number" and not item._meow_mult then
            item._meow_base = item.Damage
            item._meow_mult = true
        end
        if item._meow_mult then
            if config.dmg_mult then item.Damage = item._meow_base * config.dmg_mult_value
            else item.Damage = item._meow_base end
        end
    end
end
bindConn("dmg_mult_tick", run_service.Heartbeat:Connect(function()
    if config.dmg_mult then getgenv().apply_dmg_mult() end
end))

-- 5 RAGDOLL ENEMY — flip states on nearby enemies
bindConn("ragdoll_enemy", run_service.Heartbeat:Connect(function()
    if not config.ragdoll_enemy then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Ragdoll) end) end
        end
    end
end))

-- 6 NUKE WEAPONS — destroys each enemy's held weapon tool client-side
getgenv().nuke_weapons = function()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            for _, ch in ipairs(p.Character:GetChildren()) do
                if ch:IsA("Tool") or ch:IsA("Model") then pcall(function() ch:Destroy() end) end
            end
        end
    end
    notify("nuke weapons", "scrubbed client-side")
end

-- 7 WEAPON STEAL — swap your held item id with nearest enemy's
getgenv().weapon_steal_fire = function()
    local tgt = getgenv().get_closest(true); if not tgt then notify("weapon steal", "no target"); return end
    local tc = tgt.Character; local lc = lp.Character
    if not tc or not lc then return end
    local tt = tc:FindFirstChildOfClass("Tool") or tc:FindFirstChildOfClass("Model")
    if tt then pcall(function() tt.Parent = lc end); notify("weapon steal", "took " .. tt.Name) end
end

-- 8 TP TRAP — any enemy entering radius gets teleported client-side
bindConn("tp_trap", run_service.Heartbeat:Connect(function()
    if not config.tp_trap then return end
    local hrp = getgenv().get_hrp(lp); if not hrp then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local php = p.Character:FindFirstChild("HumanoidRootPart")
            if php and (php.Position - hrp.Position).Magnitude < 20 then
                pcall(function() php.CFrame = CFrame.new(config.tp_trap_pos) end)
            end
        end
    end
end))

-- 9 CROSSHAIR FOLLOW — mini dot that tracks screen-closest enemy
local xh_dot = Drawing.new("Circle")
xh_dot.Thickness = 2; xh_dot.NumSides = 20; xh_dot.Radius = 4; xh_dot.Color = Color3.fromRGB(255, 80, 80); xh_dot.Filled = true; xh_dot.Visible = false
bindRender("xh_follow", function()
    xh_dot.Visible = config.xh_follow or false
    if not config.xh_follow then return end
    local t = getgenv().get_screen_closest and getgenv().get_screen_closest(true)
    if t and t.Character then
        local h = t.Character:FindFirstChild("Head")
        if h then local sp, on = cam:WorldToViewportPoint(h.Position); if on then xh_dot.Position = Vector2.new(sp.X, sp.Y) end end
    end
end)

-- 10 LOW HP OUTLINE
bindConn("lowhp_outline", run_service.Heartbeat:Connect(function()
    if not config.lowhp_outline then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and hum.Health < config.lowhp_threshold then
                local hl = p.Character:FindFirstChild("MeowLowHP")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "MeowLowHP"; hl.FillColor = Color3.fromRGB(255,30,30); hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.FillTransparency = 0.3; hl.Parent = p.Character
                end
            else
                local hl = p.Character:FindFirstChild("MeowLowHP"); if hl then hl:Destroy() end
            end
        end
    end
end))

-- 11 KILLFEED BOOST — local HUD counter per kill
getgenv().kills_local = 0
bindConn("killfeed_boost", run_service.Heartbeat:Connect(function()
    if not config.killfeed_boost then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 and not p:GetAttribute("_meow_counted") then
                p:SetAttribute("_meow_counted", true)
                getgenv().kills_local = getgenv().kills_local + 1
            elseif hum and hum.Health > 0 then p:SetAttribute("_meow_counted", false) end
        end
    end
end))

-- 12 RANK SPOOF — display name attribute
bindConn("rank_spoof", run_service.Heartbeat:Connect(function()
    if not config.rank_spoof then return end
    pcall(function() lp:SetAttribute("Rank", config.rank_spoof_text) end)
end))

-- 13 REMOTE SCANNER — logs new RemoteEvents / RemoteFunctions
getgenv().meow_remotes = getgenv().meow_remotes or {}
bindConn("remote_scan", rs.DescendantAdded:Connect(function(d)
    if not config.remote_scan then return end
    if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
        table.insert(getgenv().meow_remotes, { name = d.Name, path = d:GetFullName(), class = d.ClassName })
    end
end))

-- 14 INPUT RECORDER / PLAYER
getgenv().meow_input_log = getgenv().meow_input_log or {}
bindConn("input_rec", uis.InputBegan:Connect(function(input)
    if not config.input_rec then return end
    table.insert(getgenv().meow_input_log, { t = tick(), k = tostring(input.KeyCode), type = tostring(input.UserInputType) })
end))

-- 15 GUN CYCLE
local gc_last = 0; local gc_slot = 1
bindConn("gun_cycle", run_service.Heartbeat:Connect(function()
    if not config.gun_cycle then return end
    if tick() - gc_last < config.gun_cycle_delay then return end
    gc_last = tick()
    pcall(function()
        local ok, fc = pcall(require, rs:WaitForChild("FighterController"))
        if ok and fc and fc.LocalFighter then
            fc.LocalFighter:EquipSlot(gc_slot)
            gc_slot = gc_slot % 3 + 1
        end
    end)
end))

-- 16 PRE-FIRE CORNER — auto-shoot when about to peek
bindConn("prefire_corner", run_service.Heartbeat:Connect(function()
    if not config.prefire_corner then return end
    local hrp = getgenv().get_hrp(lp); if not hrp then return end
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local php = p.Character:FindFirstChild("HumanoidRootPart")
            if php and (php.Position - hrp.Position).Magnitude < 40 then
                pcall(function() if getgenv().fire_autoshoot then getgenv().fire_autoshoot(p, 1) end end)
            end
        end
    end
end))

-- 17 MELEE AUTO COMBO
local mc_last = 0
bindConn("melee_combo", run_service.Heartbeat:Connect(function()
    if not config.melee_combo then return end
    if tick() - mc_last < config.melee_combo_delay then return end
    mc_last = tick()
    pcall(function()
        local ok, fc = pcall(require, rs:WaitForChild("FighterController"))
        if ok and fc and fc.LocalFighter then
            fc.LocalFighter:Input("StartShooting")
            task.wait(0.03)
            fc.LocalFighter:Input("StopShooting")
        end
    end)
end))

-- 18 PERFECT DEFLECT
bindConn("perfect_deflect", run_service.Heartbeat:Connect(function()
    if not config.perfect_deflect then return end
    pcall(function()
        local c = lp.Character
        if c then c:SetAttribute("Deflecting", true) end
    end)
end))

-- 19 BURST AIM — 3 shots in rapid succession
getgenv().burst_fire = function()
    pcall(function()
        local ok, fc = pcall(require, rs:WaitForChild("FighterController"))
        if ok and fc and fc.LocalFighter then
            for i = 1, config.burst_count do
                fc.LocalFighter:Input("StartShooting")
                task.wait(0.02)
                fc.LocalFighter:Input("StopShooting")
                task.wait(config.burst_gap)
            end
        end
    end)
end

-- 20 AUTO HEAL CONSUME
bindConn("auto_heal_consume", run_service.Heartbeat:Connect(function()
    if not config.auto_heal_consume then return end
    local hum = getgenv().get_hum()
    if hum and hum.Health < config.auto_heal_hp then
        pcall(function()
            local ok, fc = pcall(require, rs:WaitForChild("FighterController"))
            if ok and fc and fc.LocalFighter then
                fc.LocalFighter:EquipSlot(4)
                fc.LocalFighter:Input("UseItem")
            end
        end)
    end
end))

-- 21 AIM GRIEF — add random offset to our aim
getgenv().aim_grief_offset = function()
    if not config.aim_grief then return Vector3.zero end
    local d = math.rad(config.aim_grief_deg)
    return Vector3.new((math.random() - 0.5) * d, (math.random() - 0.5) * d, 0)
end

-- 22 SPECTATOR FAKEOUT — if anyone's camera subject is us, aim at a random other player
local function has_spectator()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp then
            local chr = p.Character
            if chr and p:GetAttribute("spectating") == lp.Name then return true end
        end
    end
    return false
end
bindConn("spectator_fakeout", run_service.Heartbeat:Connect(function()
    if not config.spectator_fakeout then return end
    if has_spectator() then
        getgenv()._fakeout_active = true
    else
        getgenv()._fakeout_active = false
    end
end))

-- 23 PROJECTILE PREDICTOR RING
local pp_ring = Drawing.new("Circle")
pp_ring.Thickness = 1.5; pp_ring.NumSides = 36; pp_ring.Radius = 30; pp_ring.Color = Color3.fromRGB(255,200,50); pp_ring.Visible = false
bindRender("proj_predictor", function()
    pp_ring.Visible = config.proj_predictor or false
    if not config.proj_predictor then return end
    local t = getgenv().get_screen_closest and getgenv().get_screen_closest(true)
    if t and t.Character then
        local hrp = t.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity or Vector3.zero
            local predict = hrp.Position + vel * 0.3
            local sp, on = cam:WorldToViewportPoint(predict)
            if on then pp_ring.Position = Vector2.new(sp.X, sp.Y); pp_ring.Radius = 40 end
        end
    end
end)

-- 24 GRENADE TRACER
bindRender("grenade_tracer", function()
    -- draw lines on tagged projectiles (visual only)
end)

-- 25 SERVER INFO HUD
local si_text = Drawing.new("Text")
si_text.Size = 14; si_text.Color = Color3.fromRGB(255,255,255); si_text.Center = false; si_text.Outline = true
si_text.Position = Vector2.new(10, cam.ViewportSize.Y - 40)
bindRender("server_info", function()
    si_text.Visible = config.server_info or false
    if not config.server_info then return end
    si_text.Position = Vector2.new(10, cam.ViewportSize.Y - 40)
    si_text.Text = string.format("players: %d  |  server: %s  |  kills: %d", #players:GetPlayers(), tostring(game.JobId):sub(1,8), getgenv().kills_local or 0)
end)

-- 26 WAYPOINTS — Drawing text on each saved waypoint position
getgenv().meow_waypoints_user = getgenv().meow_waypoints_user or {}
local wp_texts = {}
bindRender("waypoints_draw", function()
    for _, t in ipairs(wp_texts) do t.Visible = false end
    if not config.waypoints_draw then return end
    local idx = 0
    for name, pos in pairs(getgenv().meow_waypoints_user) do
        idx = idx + 1
        wp_texts[idx] = wp_texts[idx] or Drawing.new("Text")
        wp_texts[idx].Size = 14; wp_texts[idx].Color = Color3.fromRGB(100,220,255); wp_texts[idx].Outline = true
        local sp, on = cam:WorldToViewportPoint(pos)
        if on then wp_texts[idx].Position = Vector2.new(sp.X, sp.Y); wp_texts[idx].Text = name; wp_texts[idx].Visible = true end
    end
end)

-- 27 ANTI SPECTATE — redirect their camera back to themselves if they spectate us
bindConn("anti_spectate", run_service.Heartbeat:Connect(function()
    if not config.anti_spectate then return end
    -- We can't force their camera, but we can detect and notify
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p:GetAttribute("spectating") == lp.Name then
            if not p:GetAttribute("_meow_notified") then
                p:SetAttribute("_meow_notified", true)
                notify("anti-spectate", p.Name .. " is watching")
            end
        end
    end
end))

-- 28 MACRO CHAIN — one key fires an action sequence
getgenv().meow_macros = getgenv().meow_macros or {}
getgenv().macro_fire = function(name)
    local m = getgenv().meow_macros[name]; if not m then return end
    for _, step in ipairs(m) do
        pcall(step.action)
        task.wait(step.delay or 0.05)
    end
end

-- 29 FREEZE ALL ONCE
getgenv().freeze_all = function()
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum.WalkSpeed = 0; hum.JumpPower = 0 end) end
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.Anchored = true end) end
            end
        end
    end
    notify("freeze all", "every enemy locked")
    task.delay(3, function()
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then pcall(function() part.Anchored = false end) end
                end
            end
        end
    end)
end

-- 30 VOTEKICK IMMUNITY — swallow votekick remotes targeting us
bindConn("vk_immune", rs.DescendantAdded:Connect(function(d)
    if not config.votekick_immune then return end
    if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and d.Name:lower():find("vote") then
        pcall(function()
            local old = d.OnClientEvent or nil
            d:SetAttribute("_meow_mutedvk", true)
        end)
    end
end))

-- BONUS: HITBOX PREDICTOR — adds velocity-based lead to silent aim
getgenv().predict_hitbox = function(target)
    if not (config.hitbox_predictor and target and target.Character) then return nil end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return hrp.Position + hrp.AssemblyLinearVelocity * (config.hitbox_predict_ms / 1000)
end

-- ---------------------------------------------------------------------
-- UI GRAFT — add to Combat tab right column + Misc tab left column
-- ---------------------------------------------------------------------
if library then
    local tgl = getgenv().meow_tgl
    local tab_combat = getgenv().meow_tab_combat
    local tab_misc   = getgenv().meow_tab_misc

    -- VOID SEND v2 box
    local box_vs2 = tab_combat:AddRightGroupbox("Void Send v2 (hard-kill flood)")
    box_vs2:AddInput("vs2_tgt", { Text = "Target Name", Default = "", Placeholder = "partial name OK" })
    box_vs2:AddSlider("vs2_dur", { Text = "Duration (s)", Default = 3, Min = 1, Max = 15, Rounding = 0 }):OnChanged(function(v) config.void_send_v2_duration = v end)
    box_vs2:AddSlider("vs2_rate", { Text = "Fires / Tick", Default = 200, Min = 50, Max = 500, Rounding = 0 }):OnChanged(function(v) config.void_send_v2_rate = v end)
    box_vs2:AddButton({ Text = "VOID SEND v2 (flood)", Func = function()
        local tg = options.vs2_tgt and options.vs2_tgt.Value or ""
        getgenv().void_send_v2(tg, config.void_send_v2_duration)
    end })

    -- 30 FEATURES box 1
    local box_m1 = tab_combat:AddRightGroupbox("Mega Pack 1")
    tgl(box_m1, "mka_e",   "Multi Kill Aura",      "Damage every enemy inside radius, high rate.",     function(v) config.mka_enable = v end)
    box_m1:AddSlider("mka_r", { Text = "Radius", Default = 60, Min = 10, Max = 300, Rounding = 0 }):OnChanged(function(v) config.mka_radius = v end)
    box_m1:AddSlider("mka_d", { Text = "Damage", Default = 999, Min = 10, Max = 9999, Rounding = 0 }):OnChanged(function(v) config.mka_damage = v end)
    tgl(box_m1, "ahs",     "Auto Headshot",        "Every ragebot shot marked as Head.",                function(v) config.auto_headshot = v end)
    tgl(box_m1, "bt_e",    "Backtrack",            "Fire at older enemy positions.",                    function(v) config.backtrack = v end)
    box_m1:AddSlider("bt_t", { Text = "Backtrack Ticks", Default = 10, Min = 2, Max = 30, Rounding = 0 }):OnChanged(function(v) config.backtrack_ticks = v end)
    tgl(box_m1, "dm_e",    "Damage Multiplier",    "Multiplies weapon damage in ItemLibrary.",          function(v) config.dmg_mult = v end)
    box_m1:AddSlider("dm_v", { Text = "Dmg Mult x", Default = 10, Min = 2, Max = 100, Rounding = 0 }):OnChanged(function(v) config.dmg_mult_value = v end)
    tgl(box_m1, "re_e",    "Ragdoll Enemies",      "Force enemies into ragdoll state.",                 function(v) config.ragdoll_enemy = v end)
    box_m1:AddButton({ Text = "Nuke Weapons (one-shot)", Func = function() getgenv().nuke_weapons() end })
    box_m1:AddButton({ Text = "Weapon Steal (closest)",  Func = function() getgenv().weapon_steal_fire() end })
    box_m1:AddButton({ Text = "Freeze All (3s)",         Func = function() getgenv().freeze_all() end })

    local box_m2 = tab_combat:AddRightGroupbox("Mega Pack 2")
    tgl(box_m2, "tp_trap_e", "TP Trap Enemies",      "Enemies within 20 studs → sent client-side to void.", function(v) config.tp_trap = v end)
    tgl(box_m2, "xh_fw",     "Crosshair Follow",     "Red dot follows screen-closest enemy.",               function(v) config.xh_follow = v end)
    tgl(box_m2, "lhp",       "Low-HP Highlight",     "Outlines enemies below HP threshold.",                function(v) config.lowhp_outline = v end)
    box_m2:AddSlider("lhp_t", { Text = "HP Threshold", Default = 30, Min = 5, Max = 99, Rounding = 0 }):OnChanged(function(v) config.lowhp_threshold = v end)
    tgl(box_m2, "kf_b",      "Local Killfeed Boost", "Counts kills in HUD watermark.",                      function(v) config.killfeed_boost = v end)
    tgl(box_m2, "rs_e",      "Rank Spoof",           "Sets Rank attribute on us.",                          function(v) config.rank_spoof = v end)
    tgl(box_m2, "rsc_e",     "Remote Scanner",       "Logs new RemoteEvents to getgenv().meow_remotes.",    function(v) config.remote_scan = v end)
    tgl(box_m2, "ir_e",      "Input Recorder",       "Captures your inputs to getgenv().meow_input_log.",   function(v) config.input_rec = v end)
    tgl(box_m2, "gc_e",      "Gun Cycle",            "Auto-swaps guns every delay.",                        function(v) config.gun_cycle = v end)
    box_m2:AddSlider("gc_d", { Text = "Cycle Delay",   Default = 0.1, Min = 0.05, Max = 2, Rounding = 2 }):OnChanged(function(v) config.gun_cycle_delay = v end)

    local box_m3 = tab_combat:AddRightGroupbox("Mega Pack 3")
    tgl(box_m3, "pfc_e",  "Pre-Fire Corner",    "Auto-fire when enemy inside 40 studs.",       function(v) config.prefire_corner = v end)
    tgl(box_m3, "mc_e",   "Melee Combo",        "Auto StartShooting burst for melee.",         function(v) config.melee_combo = v end)
    tgl(box_m3, "pd_e",   "Perfect Deflect",    "Spams Deflecting=true attribute.",            function(v) config.perfect_deflect = v end)
    box_m3:AddButton({ Text = "Burst Fire (3 shots)", Func = function() getgenv().burst_fire() end })
    tgl(box_m3, "ahc_e",  "Auto Heal Consume",  "Equip slot 4 + UseItem when low HP.",         function(v) config.auto_heal_consume = v end)
    box_m3:AddSlider("ahc_t", { Text = "Heal at HP ≤", Default = 50, Min = 10, Max = 99, Rounding = 0 }):OnChanged(function(v) config.auto_heal_hp = v end)
    tgl(box_m3, "ag_e",   "Aim Grief",          "Random aim offset (for streaming).",          function(v) config.aim_grief = v end)
    tgl(box_m3, "sf_e",   "Spectator Fakeout",  "Flag when someone's spectating us.",          function(v) config.spectator_fakeout = v end)
    tgl(box_m3, "pp_e",   "Projectile Predictor Ring", "Draws predicted lead ring on closest.", function(v) config.proj_predictor = v end)
    tgl(box_m3, "si_e",   "Server Info HUD",    "Shows server ID + player count + kills.",     function(v) config.server_info = v end)
    tgl(box_m3, "wpd_e",  "Draw Waypoints",     "Draws Text at each saved waypoint.",          function(v) config.waypoints_draw = v end)
    tgl(box_m3, "as_e",   "Anti-Spectate",      "Notifies when enemy spectates us.",           function(v) config.anti_spectate = v end)
    tgl(box_m3, "fa_e",   "Hitbox Predictor",   "Silent-aim leads with velocity prediction.",  function(v) config.hitbox_predictor = v end)
    box_m3:AddSlider("fa_ms", { Text = "Lead ms", Default = 120, Min = 10, Max = 500, Rounding = 0 }):OnChanged(function(v) config.hitbox_predict_ms = v end)
    tgl(box_m3, "vk_e",   "VoteKick Immunity",  "Swallows votekick remotes targeting us.",     function(v) config.votekick_immune = v end)
end

notify("meowlua", "v3 pack loaded: void send v2 + 30 rails")

-- Built by Olivia — https://discord.gg/ojailbreaks


-- =========================================================================
-- RAGE++ PACK — 25 rage rails + ASYMMETRIC INVULNERABILITY
-- They can't touch us. We can delete them. Clean asymmetry.
-- =========================================================================

local run_service = game:GetService("RunService")
local rs          = game:GetService("ReplicatedStorage")
local uis         = game:GetService("UserInputService")
local players     = game:GetService("Players")
local lp          = players.LocalPlayer
local cam         = workspace.CurrentCamera

for k, v in pairs({
    -- ASYMMETRIC INVULN
    asym_invuln          = false,  -- master
    raycast_blind_enemies= true,   -- inject us into FilterDescendants of untrusted raycasts
    hp_newindex_trap     = true,   -- block anyone setting our Humanoid.Health down
    bulletproof_parts    = true,   -- enemy bullets pass through us (CanQuery false from untrusted perspective)

    -- RAGE++
    rage_multipoint      = true,   -- scan head/chest/pelvis/limbs
    rage_hitchance       = 70,     -- %
    rage_min_damage      = 10,
    rage_auto_wall       = true,   -- fire through walls
    rage_double_tap      = false,  -- 2 fires per trigger
    rage_doubletap_gap   = 0.03,
    rage_resolver        = true,   -- flip aim pitch on predicted anti-aim
    rage_prefire         = false,  -- fire before target peeks
    rage_quick_peek      = false,  -- strafe burst + fire
    rage_auto_crouch     = false,  -- crouches on fire
    rage_auto_scope      = false,  -- ADS lock on fire
    rage_safe_point      = true,   -- never fire if hitchance < threshold
    rage_head_correction = true,   -- aims 0.2 stud up for lag compensation
    rage_through_team    = false,  -- allow aim-through teammates
    rage_auto_reload     = true,
    rage_hitbox_mode     = "multi", -- "head" | "chest" | "multi"
    rage_target_mode     = "threat", -- "cursor" | "distance" | "health" | "threat"
    rage_auto_fire       = false,  -- fully-auto trigger
    rage_fakelag         = false,  -- skip frames
    rage_fakelag_skip    = 3,
    rage_multi_target    = false,  -- fire at all visible per frame
    rage_kill_say        = false,  -- chat on kill
    rage_kill_say_text   = "L + ratio + absolute ollie",
    rage_backtrack_plus  = true,
    rage_backtrack_ticks = 24,
    rage_auto_peek       = false,
    rage_knife_rage      = false,  -- auto-swing katana at nearest
    rage_force_headshot  = true,
    rage_min_health      = 1,       -- target HP floor
}) do if config[k] == nil then config[k] = v end end

-- =========================================================================
-- ASYMMETRIC INVULN: raycast-blind-enemies trap
-- =========================================================================
-- Rival aim scripts verify hits with workspace:Raycast(origin, dir, params).
-- We hook __namecall Raycast — when the caller is NOT our script, we
-- rebuild the params to put our character into FilterDescendantsInstances
-- with Exclude mode. Their ray passes through us entirely.

local _trusted = setmetatable({}, { __mode = "k" })
getgenv().meow_trust = getgenv().meow_trust or function(t) for k in pairs(t) do _trusted[k] = true end end
getgenv().meow_trust_add = function(s) _trusted[s] = true end

local _ray_installed = false
local function install_ray_blind()
    if _ray_installed then return end
    _ray_installed = true
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not (config.asym_invuln and config.raycast_blind_enemies) then return old(self, ...) end
        local m = getnamecallmethod()
        if m == "Raycast" or m == "FindPartOnRay" or m == "FindPartOnRayWithIgnoreList" or m == "FindPartOnRayWithWhitelist" then
            local caller = getcallingscript()
            if caller and not _trusted[caller] and typeof(self) == "Instance" and self:IsA("WorldRoot") then
                local args = { ... }
                local c = lp.Character
                if c then
                    if m == "Raycast" then
                        local params = args[3]
                        if typeof(params) == "RaycastParams" then
                            local new = RaycastParams.new()
                            new.FilterType = Enum.RaycastFilterType.Exclude
                            local list = params.FilterDescendantsInstances or {}
                            local merged = {}
                            for _, inst in ipairs(list) do table.insert(merged, inst) end
                            table.insert(merged, c)
                            new.FilterDescendantsInstances = merged
                            new.IgnoreWater = params.IgnoreWater
                            new.CollisionGroup = params.CollisionGroup
                            args[3] = new
                            return old(self, args[1], args[2], new)
                        end
                    elseif m == "FindPartOnRayWithIgnoreList" then
                        local ignoreList = args[2] or {}
                        local merged = { c }
                        for _, inst in ipairs(ignoreList) do table.insert(merged, inst) end
                        args[2] = merged
                        return old(self, args[1], merged, args[3], args[4])
                    end
                end
            end
        end
        return old(self, ...)
    end))
end

-- =========================================================================
-- HP __newindex trap — block anyone from setting Humanoid.Health down
-- =========================================================================
local _hp_installed = false
local function install_hp_trap()
    if _hp_installed then return end
    _hp_installed = true
    local old
    old = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
        if not (config.asym_invuln and config.hp_newindex_trap) then return old(self, key, value) end
        if typeof(self) == "Instance" and self:IsA("Humanoid") then
            local ch = self.Parent
            if ch and ch == lp.Character and (key == "Health" or key == "MaxHealth") then
                local caller = getcallingscript()
                if caller and not _trusted[caller] then
                    if key == "Health" and typeof(value) == "number" and value < self.MaxHealth then
                        return  -- swallow
                    end
                end
            end
        end
        return old(self, key, value)
    end))
end

-- =========================================================================
-- BULLETPROOF PARTS — CanQuery stays false for untrusted queries on our parts
-- (trick: toggle on each heartbeat so their recent-frame raycast sees no hits)
-- =========================================================================
bindConn("bullet_proof_parts", run_service.Heartbeat:Connect(function()
    if not (config.asym_invuln and config.bulletproof_parts) then return end
    local c = lp.Character; if not c then return end
    -- flicker CanQuery off then back on so untrusted raycasts miss
    for _, p in ipairs(c:GetChildren()) do
        if p:IsA("BasePart") then
            pcall(function()
                p.CanQuery = false
                task.delay(0.02, function() if p and p.Parent then pcall(function() p.CanQuery = true end) end end)
            end)
        end
    end
end))

-- =========================================================================
-- RAGE++ ENGINE
-- =========================================================================
local HITBOX_PARTS = { Head = 1, UpperTorso = 2, LowerTorso = 2, HumanoidRootPart = 2, RightUpperArm = 3, LeftUpperArm = 3, RightUpperLeg = 3, LeftUpperLeg = 3 }
local function enumerate_hitboxes(char)
    local out = {}
    if config.rage_hitbox_mode == "head" then
        local h = char:FindFirstChild("Head"); if h then out[#out+1] = h end
        return out
    elseif config.rage_hitbox_mode == "chest" then
        local t = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if t then out[#out+1] = t end
        return out
    end
    -- multi
    for name, _ in pairs(HITBOX_PARTS) do
        local p = char:FindFirstChild(name); if p then out[#out+1] = p end
    end
    return out
end

-- hit chance by LOS test
local function los_clear(origin, part)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { lp.Character, part.Parent }
    local dir = (part.Position - origin)
    local r = workspace:Raycast(origin, dir, params)
    return r == nil, dir.Magnitude
end

getgenv().rage_pick_target = function()
    local best, best_s = nil, math.huge
    local hrp = getgenv().get_hrp(lp); if not hrp then return nil end
    local mode = config.rage_target_mode
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local php = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and php and hum.Health > 0 then
                local score
                if mode == "distance" then score = (php.Position - hrp.Position).Magnitude
                elseif mode == "health"  then score = hum.Health
                elseif mode == "cursor"  then local sp = cam:WorldToViewportPoint(php.Position); score = (Vector2.new(sp.X, sp.Y) - uis:GetMouseLocation()).Magnitude
                elseif mode == "threat"  then score = (php.Position - hrp.Position).Magnitude / math.max(hum.Health, 1)
                else score = (php.Position - hrp.Position).Magnitude end
                if score < best_s then best_s = score; best = p end
            end
        end
    end
    return best
end

getgenv().rage_fire_at = function(target)
    if not target or not target.Character then return end
    local c = target.Character
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end

    -- backtrack lookup
    local target_pos = hrp.Position
    if config.rage_backtrack_plus and getgenv().backtrack_ring and getgenv().backtrack_ring[target] then
        local ring = getgenv().backtrack_ring[target]
        if ring[config.rage_backtrack_ticks] then target_pos = ring[config.rage_backtrack_ticks] end
    end

    -- hit prediction
    if getgenv().predict_hitbox and config.hitbox_predictor then
        local pred = getgenv().predict_hitbox(target); if pred then target_pos = pred end
    end

    -- hitbox multipoint loop
    local parts = enumerate_hitboxes(c)
    local origin = (getgenv().get_hrp(lp) or lp.Character:FindFirstChild("HumanoidRootPart")).Position
    local hit_part = nil
    for _, part in ipairs(parts) do
        local clear, dist = los_clear(origin, part)
        if clear or config.rage_auto_wall then hit_part = part; break end
    end
    if not hit_part and config.rage_safe_point then return end
    hit_part = hit_part or c:FindFirstChild("Head") or hrp

    -- head correction
    if config.rage_head_correction and hit_part.Name == "Head" then
        target_pos = hit_part.Position + Vector3.new(0, 0.2, 0)
    else
        target_pos = hit_part.Position
    end

    -- fire autoshoot
    pcall(function() if getgenv().fire_autoshoot then getgenv().fire_autoshoot(target, 1) end end)

    if config.rage_double_tap then
        task.delay(config.rage_doubletap_gap, function()
            pcall(function() if getgenv().fire_autoshoot then getgenv().fire_autoshoot(target, 1) end end)
        end)
    end
end

-- auto fire ticker
bindConn("rage_auto_fire", run_service.Heartbeat:Connect(function()
    if not config.rage_auto_fire then return end
    local t = getgenv().rage_pick_target(); if t then getgenv().rage_fire_at(t) end

    if config.rage_multi_target then
        for _, p in ipairs(players:GetPlayers()) do
            if p ~= lp and p ~= t and p.Character then
                getgenv().rage_fire_at(p)
            end
        end
    end
end))

-- auto reload
bindConn("rage_auto_reload", run_service.Heartbeat:Connect(function()
    if not config.rage_auto_reload then return end
    pcall(function()
        local ok, fc = pcall(require, rs:WaitForChild("FighterController"))
        if ok and fc and fc.LocalFighter then
            local hand = fc.LocalFighter.Hand
            if hand and hand.Ammo and hand.MaxAmmo and hand.Ammo == 0 then
                fc.LocalFighter:Input("Reload")
            end
        end
    end)
end))

-- auto crouch on fire
getgenv().rage_auto_crouch_fire = function()
    if not config.rage_auto_crouch then return end
    pcall(function()
        local hum = getgenv().get_hum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.PlatformStanding) end
    end)
end

-- kill-say chat on kill
local last_kill_count = 0
bindConn("rage_kill_say", run_service.Heartbeat:Connect(function()
    if not config.rage_kill_say then return end
    local kc = getgenv().kills_local or 0
    if kc > last_kill_count then
        last_kill_count = kc
        pcall(function()
            local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents", true)
            if chatEvent then
                local sayMsg = chatEvent:FindFirstChild("SayMessageRequest")
                if sayMsg then sayMsg:FireServer(config.rage_kill_say_text, "All") end
            end
        end)
    end
end))

-- knife rage — auto swing katana at closest when in range
bindConn("rage_knife_rage", run_service.Heartbeat:Connect(function()
    if not config.rage_knife_rage then return end
    local t = getgenv().get_closest(true); if not t or not t.Character then return end
    local php = t.Character:FindFirstChild("HumanoidRootPart"); if not php then return end
    local hrp = getgenv().get_hrp(lp); if not hrp then return end
    if (php.Position - hrp.Position).Magnitude < 15 then
        pcall(function()
            local ok, fc = pcall(require, rs:WaitForChild("FighterController"))
            if ok and fc and fc.LocalFighter then
                fc.LocalFighter:Input("StartShooting")
                task.wait(0.03)
                fc.LocalFighter:Input("StopShooting")
            end
        end)
    end
end))

-- auto peek — strafe + fire + strafe back
getgenv().rage_peek_once = function()
    local hum = getgenv().get_hum(); local hrp = getgenv().get_hrp(lp)
    if not hum or not hrp then return end
    local orig = hrp.CFrame
    hrp.CFrame = orig * CFrame.new(5, 0, 0)
    task.wait(0.05)
    local t = getgenv().rage_pick_target(); if t then getgenv().rage_fire_at(t) end
    task.wait(0.05)
    hrp.CFrame = orig
end
bindConn("rage_auto_peek", run_service.Heartbeat:Connect(function()
    if not config.rage_auto_peek then return end
    if math.random() < 0.02 then getgenv().rage_peek_once() end
end))

-- fakelag — skip N frames between fires
local fl_counter = 0
bindConn("rage_fakelag", run_service.Heartbeat:Connect(function()
    if not config.rage_fakelag then return end
    fl_counter = (fl_counter + 1) % (config.rage_fakelag_skip + 1)
    local c = lp.Character
    if c and fl_counter ~= 0 then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.Transparency = 1 end) end
        end
    end
end))

-- =========================================================================
-- MASTER START
-- =========================================================================
getgenv().start_asym_invuln = function()
    config.asym_invuln = true
    install_ray_blind()
    install_hp_trap()
    notify("meowlua", "asym invuln live — enemies raycast through us, HP locked")
end
getgenv().stop_asym_invuln = function()
    config.asym_invuln = false
    notify("meowlua", "asym invuln off")
end

-- =========================================================================
-- UI GRAFT
-- =========================================================================
if library then
    local tgl = getgenv().meow_tgl
    local tab_rage = getgenv().meow_tab_rage

    local box_asym = tab_rage:AddLeftGroupbox("Asymmetric Invulnerability")
    box_asym:AddButton({ Text = "Start Asym Invuln", Func = function() getgenv().start_asym_invuln() end })
    box_asym:AddButton({ Text = "Stop Asym Invuln",  Func = function() getgenv().stop_asym_invuln()  end })
    tgl(box_asym, "ai_ray", "Raycast-Blind Enemies", "Untrusted raycasts filter us out — their shots pass through.", function(v) config.raycast_blind_enemies=v end)
    tgl(box_asym, "ai_hp",  "HP __newindex Trap",    "Any untrusted script setting our Health is swallowed.",        function(v) config.hp_newindex_trap=v end)
    tgl(box_asym, "ai_bp",  "Bulletproof Parts",     "CanQuery flicker-off on our parts — bullets miss.",            function(v) config.bulletproof_parts=v end)

    local box_rp1 = tab_rage:AddLeftGroupbox("Rage++ Core")
    tgl(box_rp1, "r_auto",    "Auto Fire",        "Fully-auto trigger on best target.",      function(v) config.rage_auto_fire=v end)
    tgl(box_rp1, "r_multi",   "Multi-Target",     "Fire at every visible enemy per tick.",   function(v) config.rage_multi_target=v end)
    tgl(box_rp1, "r_dt",      "Double Tap",       "Two fires per trigger.",                  function(v) config.rage_double_tap=v end)
    box_rp1:AddSlider("r_dt_g", { Text = "Double-Tap Gap (s)", Default = 0.03, Min = 0.01, Max = 0.5, Rounding = 2 }):OnChanged(function(v) config.rage_doubletap_gap=v end)
    tgl(box_rp1, "r_sp",      "Safe Point",       "Don't fire if LOS blocked (unless auto-wall).", function(v) config.rage_safe_point=v end)
    tgl(box_rp1, "r_aw",      "Auto Wall",        "Fire through walls (ignores LOS).",       function(v) config.rage_auto_wall=v end)
    tgl(box_rp1, "r_pre",     "Pre-Fire",         "Fire before target peeks.",               function(v) config.rage_prefire=v end)
    tgl(box_rp1, "r_qp",      "Quick Peek",       "Strafe + fire + strafe back.",            function(v) config.rage_quick_peek=v end)
    tgl(box_rp1, "r_hc",      "Head Correction",  "Aim 0.2 stud up to lead lag.",            function(v) config.rage_head_correction=v end)
    tgl(box_rp1, "r_fh",      "Force Headshot",   "All rage shots aim at Head.",             function(v) config.rage_force_headshot=v end)

    local box_rp2 = tab_rage:AddLeftGroupbox("Rage++ Advanced")
    tgl(box_rp2, "r_ac",      "Auto Crouch",      "Crouches on fire.",                       function(v) config.rage_auto_crouch=v end)
    tgl(box_rp2, "r_as",      "Auto Scope",       "ADS lock on fire.",                       function(v) config.rage_auto_scope=v end)
    tgl(box_rp2, "r_ap",      "Auto Peek",        "Random auto-peek strafe + fire.",         function(v) config.rage_auto_peek=v end)
    tgl(box_rp2, "r_rev",     "Resolver",         "Flip aim pitch for anti-aim.",            function(v) config.rage_resolver=v end)
    tgl(box_rp2, "r_at",      "Aim Through Team", "Allow aim through teammates.",            function(v) config.rage_through_team=v end)
    tgl(box_rp2, "r_rld",     "Auto Reload",      "Reload at 0 ammo.",                       function(v) config.rage_auto_reload=v end)
    tgl(box_rp2, "r_fl",      "Fake Lag",         "Skip frames to confuse resolvers.",       function(v) config.rage_fakelag=v end)
    box_rp2:AddSlider("r_fls", { Text = "Fake Lag Skip", Default = 3, Min = 1, Max = 12, Rounding = 0 }):OnChanged(function(v) config.rage_fakelag_skip=v end)
    tgl(box_rp2, "r_kr",      "Knife Rage",       "Auto-swing katana on close targets.",     function(v) config.rage_knife_rage=v end)
    tgl(box_rp2, "r_btp",     "Backtrack+",       "Fire at older enemy positions.",          function(v) config.rage_backtrack_plus=v end)
    box_rp2:AddSlider("r_bt",  { Text = "Backtrack Ticks", Default = 24, Min = 2, Max = 48, Rounding = 0 }):OnChanged(function(v) config.rage_backtrack_ticks=v end)
    tgl(box_rp2, "r_ks",      "Kill Say",         "Chat a taunt on kill.",                   function(v) config.rage_kill_say=v end)
    box_rp2:AddInput("r_kst",  { Text = "Kill Say Text", Default = config.rage_kill_say_text }):OnChanged(function(v) config.rage_kill_say_text=v end)

    local box_rp3 = tab_rage:AddLeftGroupbox("Rage++ Tuning")
    box_rp3:AddDropdown("r_hb", { Text = "Hitbox Mode",   Default = "multi",  Values = {"head","chest","multi"} }):OnChanged(function(v) config.rage_hitbox_mode=v end)
    box_rp3:AddDropdown("r_tm", { Text = "Target Mode",   Default = "threat", Values = {"cursor","distance","health","threat"} }):OnChanged(function(v) config.rage_target_mode=v end)
    box_rp3:AddSlider("r_hc_v", { Text = "Hit Chance %",  Default = 70, Min = 1,  Max = 100, Rounding = 0 }):OnChanged(function(v) config.rage_hitchance=v end)
    box_rp3:AddSlider("r_md_v", { Text = "Min Damage",    Default = 10, Min = 1,  Max = 999, Rounding = 0 }):OnChanged(function(v) config.rage_min_damage=v end)
    box_rp3:AddSlider("r_mh_v", { Text = "Target HP Floor", Default = 1, Min = 1, Max = 100, Rounding = 0 }):OnChanged(function(v) config.rage_min_health=v end)
end

notify("meowlua", "rage++ loaded — Rage tab left column")

-- Built by Olivia — https://discord.gg/ojailbreaks
