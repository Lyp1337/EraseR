local a = require("ffi")
local b = require("neverlose/pui")
local c = require("vector")
local d = require("neverlose/clipboard")
local e = require("neverlose/base64")
local f = require("neverlose/csgo_weapons")
local g = require("neverlose/drag_system")
utils.console_exec("play ui\\beepclear")
local h = {
	"global",
	"stand",
	"slow walk",
	"run",
	"duck",
	"duck move",
	"jump",
	"duck jump",
	"freestanding",
	"manual",
	"safe head",
	"fakelag",
	"hideshots",
	"air exploit",
}
local i = {
	[0] = "generic",
	[1] = "head",
	[2] = "chest",
	[3] = "stomach",
	[4] = "left arm",
	[5] = "right arm",
	[6] = "left leg",
	[7] = "right leg",
	[8] = "neck",
	[10] = "gear",
}
local j = { names = {}, values = {} }
local utils = utils
local k = {}
local l = {}
local m = {}
local n = {}
local o = {}
local p = {}
local q = {}
local r = {}
local s = {}
local t = ui.get_style("Link Active")
local u = ui.get_style("Active Text")
getmetatable(color()).override = function(v, w, x)
	local y = v:clone()
	y[w] = x
	return y
end
local z
do
	a.cdef([[typedef struct {char  pad_0000[20];int m_nOrder; int m_nSequence; float m_flPrevCycle; float m_flWeight; float m_flWeightDeltaRate; float m_flPlaybackRate; float m_flCycle; void *m_pOwner; char  pad_0038[4]; } CAnimationLayer;void* GetProcAddress(void* hModule, const char* lpProcName);void* LoadLibraryA(const char* lpLibFileName);typedef void* (__cdecl *CreateInterfaceFn)(const char* pName, int* pReturnCode); ]])
	z = {}
	function z.get_interface(A, B)
		local C = a.C.LoadLibraryA(A)
		local D = a.cast("CreateInterfaceFn", a.C.GetProcAddress(C, "CreateInterface"))
		local E = D(B, nil)
		return E
	end
	function z.getvfunc(F, G)
		local H = a.cast("intptr_t**", F)[0]
		return a.cast("intptr_t", H[G])
	end
	z.GameUI = {}
	z.GameUI.__index = z.GameUI
	function z.GameUI.new(E)
		local self = setmetatable({}, z.GameUI)
		self.interface = E
		return self
	end
	function z.GameUI:msg_box(I, J, K, L, M, N, O, P, Q)
		local R = a.cast(
			"void(__thiscall*)(void*, const char*, const char*, bool, bool, const char*, const char*, const char*, const char*, const char*)",
			z.getvfunc(self.interface, 19)
		)
		R(self.interface, I, J, K, L, M, N, O, P, Q)
	end
	local S = z.get_interface("client.dll", "GameUI011")
	local T = z.GameUI.new(S)
	T:msg_box("METEOR.BEST", "Author: 1sTar \n\nQQ: 510315561", true, false, nil, nil, nil, nil, nil)
	z.bind_argument = function(U, V)
		return function(...)
			return U(V, ...)
		end
	end
	z.entity_list_pointer = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")
	z.native_GetNetChannelInfo = utils.get_vfunc("engine.dll", "VEngineClient014", 78, "void* (__thiscall*)(void* ecx)")
	z.native_GetLatency = utils.get_vfunc(9, "float(__thiscall*)(void*, int)")
	z.engine_client = a.cast(a.typeof("void***"), utils.create_interface("engine.dll", "VEngineClient014"))
	z.console_is_visible = z.bind_argument(a.cast("bool(__thiscall*)(void*)", z.engine_client[0][11]), z.engine_client)
end
do
	local W = 0
	utils.defensive = function()
		local X = entity.get_local_player()
		local Y = X.m_nTickBase
		if math.abs(Y - W) > 64 then
			W = 0
		end
		local Z = 0
		if Y > W then
			W = Y
		elseif W > Y then
			Z = math.min(14, math.max(0, W - Y - 1))
		end
		return Z
	end
	utils.get_weapon_struct = function(_)
		local a0 = _:get_player_weapon()
		if a0 == nil then
			return
		end
		local a1 = f[a0.m_iItemDefinitionIndex]
		if a1 == nil then
			return
		end
		return a1
	end
	utils.get_weapon_index = function(_)
		local a0 = _:get_player_weapon()
		if a0 == nil then
			return
		end
		return a0.m_iItemDefinitionIndex
	end
	utils.air = function(a2)
		local a3 = a2.m_fFlags
		return bit.band(a3, 1) == 0
	end
	utils.in_duck = function(a2)
		local a3 = a2.m_fFlags
		return bit.band(a3, 4) == 4
	end
	utils.color_text = function(...)
		local a4 = { ... }
		local a5 = ""
		for a6 = 1, #a4 do
			if a4[a6][2] == nil then
				a5 = a5 .. a4[a6][1]
			else
				a5 = a5 .. ("\a%s%s\aDEFAULT"):format(a4[a6][2]:to_hex(), a4[a6][1])
			end
		end
		return a5
	end
	utils.centered_text = function(a5)
		local a7 = ""
		if #a5 > 44 then
			return ""
		end
		for a6 = 1, 44 - #a5 do
			a7 = a7 .. "\x20"
		end
		return a7 .. a5
	end
	utils.data = {}
	utils.spin = function(a8, a9, aa, ab, ac, ad)
		utils.data[a8] = utils.data[a8]
			or {
				active = 0,
				method = "spin",
				start = math.min(a9, aa),
				target = math.max(a9, aa),
				speed = ab or 4,
				iterations = ac or 1,
				value = ad or a9,
			}
		local ae = utils.data[a8]
		ae.start, ae.target = math.min(a9, aa), math.max(a9, aa)
		ae.speed, ae.iterations = ab, ac
		return ae
	end
end
do
	l.rage = {
		hitboxs = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hitboxes"),
		dormant = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
		multipoint = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint"),
		quick_switch = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch"),
		hit_chance = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
		doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
		doubletap_config = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
		doubletap_fakelag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
		min_damage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
		prefer_body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
		prefer_safety = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
		quick_peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
		hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
		hideshots_config = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
		peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Retreat Mode"),
	}
	l.aa = {
		angles = {
			inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
			hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
			enable_aa = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
			pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
			yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
			yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
			yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
			yaw_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
			yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
			yaw_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
			body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
			left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
			right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
			body_yaw_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
			body_yaw_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
			freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
			disable_yaw_modif = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
			body_freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
			extended_angles = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
			extended_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
			extended_roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
		},
		fakelag = {
			fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
			fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
			fakelag_var = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
		},
		other = {
			slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
			fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
			legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
		},
	}
	l.misc = {
		main = {
			in_game = { clan_tag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag") },
			other = {
				weapon_actions = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"),
				fake_latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
			},
		},
	}
end
do
	math.vector_lerp = function(af, ag, ah)
		local ai = globals.frametime * 100
		ah = ah * math.min(ai, math.max_lerp_low_fps)
		return af:lerp(ag, ah)
	end
	math.color_lerp = function(af, ag, ah)
		local ai = globals.frametime * 100
		ah = ah * math.min(ai, math.max_lerp_low_fps)
		return af:lerp(ag, ah)
	end
	math.lerp = function(af, ag, ah)
		if af == ag then
			return ag
		end
		local ai = globals.frametime * 170
		ah = ah * ai
		local aj = af + (ag - af) * ah
		if math.abs(aj - ag) < 0.01 then
			return ag
		end
		return aj
	end
	k.base_speed = 0.095
	k._list = {}
	k.new = function(ak, al, ab, am)
		ab = ab or k.base_speed
		local an = type(al) == "userdata"
		local ao = type(al) == "vector"
		if k._list[ak] == nil then
			k._list[ak] = am and am or (an and color(255) or 0)
		end
		local ap
		if ao then
			ap = math.vector_lerp
		elseif an then
			ap = math.color_lerp
		else
			ap = math.lerp
		end
		k._list[ak] = ap(k._list[ak], al, ab)
		return k._list[ak]
	end
end
local aq
do
	aq = {}
	local function ar(as)
		local at = {}
		local au = 0
		for av in as:gmatch(".[\128-\191]*") do
			au = au + 1
			at[au] = av
		end
		return at, au
	end
	function aq.wave(as, aw, ax, ah)
		ah = ah or globals.realtime
		local ay = {}
		local at, au = ar(as)
		local az = 1 / (au - 1)
		local aA = ax.r - aw.r
		local aB = ax.g - aw.g
		local aC = ax.b - aw.b
		local aD = ax.a - aw.a
		local aE = color()
		for a6 = 1, au do
			local aF = math.abs((ah - 1) % 2 - 1)
			aE.r = aw.r + aA * aF
			aE.g = aw.g + aB * aF
			aE.b = aw.b + aC * aF
			aE.a = aw.a + aD * aF
			local aG = "\a" .. aE:to_hex() .. at[a6]
			table.insert(ay, aG)
			ah = ah + az
		end
		return table.concat(ay)
	end
end
do
	n.builder = {}
	local aH = function()
		return utils.color_text({ "\a" .. u:to_hex() .. utils.centered_text("meteor.nl © 2021 - 2024"), u })
	end
	local aI = aH()
	local aJ = {
		list = b.create("\v\f<house> \rmain", "\v\f<bolt> \rInformations"),
		anitaim = {
			builder = b.create("\v\f<house> \rmain", "\v\f<user-gear> \r Builder"),
			other = b.create("\v\f<house> \rmain", "\v\f<lightbulb> \r Other"),
			defensive = b.create("\v\f<house> \rmain", "\v\f<circle-info> \r Defensive"),
		},
		visuals = b.create("\v\f<house> \rmain", "\v\f<pen> \r Visuals"),
		misc = b.create("\v\f<house> \rmain", "\v\f<lightbulb> \r Misc"),
		socials = b.create("\v\f<house> \rmain", "\v\f<download> \r Socials"),
		home = b.create("\v\f<house> \rmain", "\v\f<download> \r Home"),
	}
	n.main_list = aJ.list:list("\n", { "home", "anti-aim", "visuals", "misc" })
	aJ.list:label(aI)
	n.home = {}
	do
		n.home.presets = aJ.home:list("", { "Default" })
		n.home.name = aJ.home:input("", "")
		n.home.load = aJ.home:button("       load       ", function()
			local aK = n.home.presets.ref
			local aL = j.values[aK:get()]
			xpcall(function()
				local aM = json.parse(e.decode(aL))
				b.load(aM)
			end, function()
				common.add_notify("出错啦！", "参数数值解析错误!")
			end)
			utils.console_exec("play ui\\beepclear")
			common.add_notify("meteor", "succesfully import!")
		end, true)
		n.home.save = aJ.home:button("       save       ", function()
			local aK = n.home.presets.ref
			s.parse()
			if n.home.name() == "" then
				common.add_notify("meteor", "name is nil")
				utils.console_exec("play resource\\warning.wav")
				return
			end
			local aN = b.save()
			local aj = e.encode(json.stringify(aN))
			table.insert(j.names, n.home.name())
			table.insert(j.values, aj)
			s.update()
			aK:update(j.names)
			utils.console_exec("play ui\\beepclear")
			common.add_notify("meteor", "Preset succesfully saved!")
		end, true)
		n.home.delete = aJ.home:button("       delete       ", function()
			local aK = n.home.presets.ref
			s.parse()
			if aK:get() > 1 then
				table.remove(j.names, aK:get())
				table.remove(j.values, aK:get())
			end
			s.update()
			aK:update(j.names)
			utils.console_exec("play ui\\beepclear")
			common.add_notify("meteor", "Preset succesfully deleted!")
		end, true)
		n.home.export = aJ.home:button("    export settings    ", function()
			local aL = b.save()
			local aO = e.encode(json.stringify(aL))
			d.set(aO)
			utils.console_exec("play ui\\beepclear")
			common.add_notify("meteor", "succesfully export!")
		end, true)
		n.home.import = aJ.home:button("    import settings    ", function(aL)
			assert(d.get() ~= nil, "参数数值不能为空!")
			local aL = d.get():match("[%w%+%/]+%=*")
			xpcall(function()
				local aM = json.parse(e.decode(aL))
				b.load(aM)
			end, function()
				common.add_notify("出错啦！", "参数数值解析错误!")
			end)
			utils.console_exec("play ui\\beepclear")
			common.add_notify("meteor", "succesfully import!")
		end, true)
		local function aP()
			local ah = common.get_system_time()
			local aG = string.format("    Time:   \a{Link Active}%02d:%02d:%02d", ah.hours, ah.minutes, ah.seconds)
			return aG
		end
		n.home.user =
			aJ.socials:label(ui.get_icon("circle-user") .. string.format("    User: \a{Link Active}%s", "  Meteor"))
		n.home.build =
			aJ.socials:label(ui.get_icon("code-branch") .. string.format("    Build: \a{Link Active}%s", "  Debug"))
		n.home.clock = aJ.socials:label(ui.get_icon("clock") .. aP() .. "                                     ")
		local function aQ()
			n.home.clock:name(ui.get_icon("clock") .. aP() .. "                                     ")
			utils.execute_after(1.0, aQ)
		end
		aQ()
		n.home.Config = aJ.socials:button(ui.get_icon("gear") .. "  Config  ", function()
			panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=m6iYq9")
		end, true)
		n.home.Discord = aJ.socials:button(ui.get_icon("discord") .. "  Discord  ", function()
			panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/UAm89wGPyz")
		end, true)
		n.home.Youtube = aJ.socials:button(ui.get_icon("youtube") .. "  Youtube  ", function()
			panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://qm.qq.com/q/1Z5Um1gPwM")
		end, true)
	end
	n.switch_builder = aJ.anitaim.builder:switch("anti-aim builder"):depend({ n.main_list, 2 })
	n.anitaim = {
		manual = aJ.anitaim.other:combo("manual", { "default", "manual left", "manual right", "manual forward" }),
		freestand = aJ.anitaim.other:switch("freestanding", false, nil, function(aR)
			local aS = { air = aR:selectable("blocking conditions", { "stand", "slow walk", "run", "duck", "jump" }) }
			return aS
		end),
		edge_yaw = aJ.anitaim.other:switch("edge yaw", false),
		antiaims_tweaks = aJ.anitaim.other:selectable(
			"additionals",
			{ "anti-aim on use", "avoid-backstab", "static manual", "safe head", "manual disabled defensive" }
		),
		anim_breakers = aJ.anitaim.other:selectable(
			"anim breakers",
			{ "legs on ground", "legs in air", "0 pitch on land", "move lean earthquake" },
			nil,
			function(aR)
				local aS = {
					ground = aR:combo("Legs on ground", { "sliding", "allah", "dislocated arm" }),
					air = aR:combo("Legs in air", { "static", "allah", "t-pose", "dumb", "stiff duck" }),
				}
				return aS
			end
		),
		safe_head_multiselect = aJ.anitaim.other:selectable(
			"safe head",
			{ "height distance", "high distance", "knife", "zeus" }
		),
		air_lag = aJ.anitaim.other:switch("air lag exploit", false),
		roll = aJ.anitaim.other:switch("Roll", false, function(aR)
			local aS = { roll = aR:slider("\n", -45, 45, 0), auto_switch = aR:switch("auto switch") }
			return aS, true
		end),
		condition = aJ.anitaim.builder:combo("builder condition", h),
	}
	for aT, aU in ipairs(h) do
		n.builder[aU] = {}
		local aV = n.builder[aU]
		if aU ~= "global" then
			aV.enable = aJ.anitaim.builder:switch(utils.color_text({ "activate ", u }, { aU, t }))
		end
		aV.type = aJ.anitaim.builder:combo("mode", { "meteor", "break" })
		aV.yaw_base = aJ.anitaim.builder:combo("base\n" .. aU, { "local view", "at target" })
		aV.yaw_add = aJ.anitaim.builder:slider("yaw\n" .. aU, -180, 180, 0, true, "°", 1, function(aR, self)
			local aS = { random = aR:slider("random\n" .. aU, -180, 180, 0, true, "°", 1) }
			return aS
		end)
		aV.body_yaw = aJ.anitaim.builder:combo("body yaw\n" .. aU, { "off", "static", "jitter" }, function(aR, self)
			local aS = {
				body_yaw_offset = aR:slider("\nbody_yaw_offset " .. aU, -60, 60, 0, true, "°", 1)
					:depend({ self, "off", true }),
				body_yaw_options = aR:selectable("\nbody_yaw_options" .. aU, { "avoid overlap", "anti bruteforce" }),
			}
			return aS
		end)
		aV.yaw_expand = aJ.anitaim.builder:combo(
			"extend\n" .. aU,
			{ "off", "left/right", "x-way", "random" },
			function(aR, self)
				local aS = {
					expand_yaw = aR:slider("\nexpand_yaw " .. aU, -80, 80, 0, true, "°", 1)
						:depend({ self, "off", true }),
					expand_yaw_2 = aR:slider("\nexpand_yaw_2 " .. aU, -80, 80, 0, true, "°", 1):depend({
						self,
						function()
							return self() == "left/right" or self() == "random"
						end,
					}),
					x_way = aR:slider("\nyaw offset xway" .. aU, 3, 7, 3, true, "-w"):depend({ self, "x-way" }),
					delay = aR:slider("add \aCDCDCD60delay\n" .. aU, 1, 10, 0, true, "t", 1)
						:depend({ self, "left/right" }, { aV.body_yaw, "jitter", false }),
				}
				return aS
			end
		)
		aV.yaw_jitter = aJ.anitaim.builder:combo(
			"modifier \n" .. aU,
			{ "off", "offset", "center", "random", "skitter" },
			function(aR, self)
				local aS = {
					yaw_jitter_add = aR:slider("\nyaw_jitter_add " .. aU, -180, 180, 0, true, "°", 1)
						:depend({ self, "off", true }),
				}
				return aS
			end
		)
		aV.break_lc = aJ.anitaim.defensive:switch("force break lc" .. "\n" .. aU)
		aV.defensive = aJ.anitaim.defensive:switch("defensive aa" .. "\n" .. aU, false, function(aR, self)
			local aS = {
				pitch = aR:combo("pitch" .. "\n" .. aU, { "off", "static", "spin", "random", "x-way" }),
				pitch_angles_1 = aR:slider(
					utils.color_text({ "~ ", t }) .. "angles 1\n pitch" .. aU,
					-89,
					89,
					0,
					1,
					"°"
				),
				pitch_angles_2 = aR:slider(
					utils.color_text({ "~ ", t }) .. "angles 2\n pitch" .. aU,
					-89,
					89,
					0,
					1,
					"°"
				),
				pitch_x_way = aR:slider("\n defensive pitch xway" .. aU, 3, 7, 3, true, "-w"),
				pitch_angles_from = aR:slider(
					utils.color_text({ "~ ", t }) .. "from\n pitch " .. aU,
					-89,
					89,
					0,
					1,
					"°"
				),
				pitch_angles_to = aR:slider(utils.color_text({ "~ ", t }) .. "to\npitch" .. aU, -89, 89, 0, 1, "°"),
				pitch_angles_speed = aR:slider(utils.color_text({ "~ ", t }) .. "speed\npitch" .. aU, 1, 64, 1, 1, "t"),
				yaw = aR:combo("yaw" .. "\n" .. aU, { "off", "static", "spin", "random", "x-way", "jitter", "wraith" }),
				yaw_angles = aR:slider(utils.color_text({ "~ ", t }) .. "angles \n yaw" .. aU, -180, 180, 0, 1, "°"),
				delay = aR:slider(utils.color_text({ "~ ", t }) .. "delay \n yaw" .. aU, 1, 10, 1, 1, "t"),
				yaw_x_way = aR:slider("\n defensive yaw xway" .. aU, 3, 7, 3, true, "-w"),
				yaw_angles_from = aR:slider(utils.color_text({ "~ ", t }) .. "from\n yaw" .. aU, 0, 360, 0, 1, "°"),
				yaw_angles_to = aR:slider(utils.color_text({ "~ ", t }) .. "to\n yaw" .. aU, 0, 360, 0, 1, "°"),
				yaw_angles_speed = aR:slider(utils.color_text({ "~ ", t }) .. "speed\n yaw" .. aU, 1, 64, 1, 1, "t"),
				freestand = aR:switch(utils.color_text({ "~ ", t }) .. "freestand yaw\n" .. aU),
			}
			aS.yaw_angles_from:depend({ aS.yaw, "spin" })
			aS.yaw_angles_to:depend({ aS.yaw, "spin" })
			aS.yaw_angles_speed:depend({ aS.yaw, "spin" })
			aS.delay:depend({ aS.yaw, "jitter" })
			aS.yaw_angles:depend({
				aS.yaw,
				function()
					return aS.yaw() == "static" or aS.yaw() == "random" or aS.yaw() == "x-way" or aS.yaw() == "jitter"
				end,
			})
			aS.pitch_x_way:depend({ aS.pitch, "x-way" })
			aS.yaw_x_way:depend({ aS.yaw, "x-way" })
			aS.pitch_angles_from:depend({ aS.pitch, "spin" })
			aS.pitch_angles_to:depend({ aS.pitch, "spin" })
			aS.pitch_angles_speed:depend({ aS.pitch, "spin" })
			aS.pitch_angles_1:depend({
				aS.pitch,
				function()
					return aS.pitch() == "static" or aS.pitch() == "random" or aS.pitch() == "x-way"
				end,
			})
			aS.pitch_angles_2:depend({
				aS.pitch,
				function()
					return aS.pitch() == "random"
				end,
			})
			return aS, true
		end)
		for aT, aW in pairs(aV) do
			local at = { { n.main_list, 2 }, { n.anitaim.condition, aU }, { n.switch_builder, true } }
			if aT ~= "enable" and aU ~= "global" then
				at =
					{ { n.anitaim.condition, aU }, { aV.enable, true }, { n.main_list, 2 }, { n.switch_builder, true } }
			end
			aW:depend(table.unpack(at))
		end
	end
	n.visuals = {
		sc_indicators = aJ.visuals:switch("screen indicator", false, nil, function(aR)
			local aS = {
				ind_color = aR:color_picker("Indicator color", color(255, 255, 255)),
				build_color = aR:color_picker("Build color", color(255, 255, 255)),
				glow_px = aR:slider("offset", 0, 100, 10, 1, "px"),
				glow_switch = aR:switch("glow", false),
			}
			return aS, true
		end),
		damage_indicator = aJ.visuals:switch("damage indicator"),
		aspect_ratio = aJ.visuals:switch("aspect ratio", false, nil, function(aR)
			local aS = {
				val = aR:slider("value", 50, 300, 0, 0.01),
				preset1 = aR:button(" 4:3 "),
				preset2 = aR:button(" 5:4"),
				preset3 = aR:button(" 3:2"),
				preset4 = aR:button(" 16:10"),
				preset5 = aR:button("16:9 "),
			}
			aS.preset1:set_callback(function()
				aS.val:set(133)
			end)
			aS.preset2:set_callback(function()
				aS.val:set(125)
			end)
			aS.preset3:set_callback(function()
				aS.val:set(150)
			end)
			aS.preset4:set_callback(function()
				aS.val:set(160)
			end)
			aS.preset5:set_callback(function()
				aS.val:set(178)
			end)
			return aS, true
		end),
		nade_radius = aJ.visuals:switch("nade radius", false, nil, function(aR)
			local aS = {
				grenade_select = aR:listable("", { "Smoke", "Molotov" }),
				molotov_color = aR:color_picker("Team Molotov Color", color(116, 192, 41, 255)),
				enemy_molotov_color = aR:color_picker("Enemy Molotov Color", color(255, 63, 63, 190)),
				smoke_color = aR:color_picker("Smoke Color", color(61, 147, 250, 180)),
			}
			aS.molotov_color:depend({ aS.grenade_select, 2 })
			aS.enemy_molotov_color:depend({ aS.grenade_select, 2 })
			aS.smoke_color:depend({ aS.grenade_select, 1 })
			return aS, true
		end),
		console_color = aJ.visuals:switch("vgui color", false, nil, function(aR)
			local aS = { accent_color = aR:color_picker("color", color(114, 168, 236, 255)) }
			return aS, true
		end),
		velocity_indication = aJ.visuals:switch("indication", false, nil, function(aR)
			local aS = {
				velocity_indication = aR:switch("velocity", false),
				velocity_accent_color = aR:color_picker("color", color(255)),
				defensive_indication = aR:switch("defensive", false),
				defensive_accent_color = aR:color_picker("color", color(255)),
				airlag_indication = aR:switch("airlag", false),
				airlag_accent_color = aR:color_picker("color", color(255)),
			}
			aS.velocity_accent_color:depend({ aS.velocity_indication, true })
			aS.defensive_accent_color:depend({ aS.defensive_indication, true })
			aS.airlag_accent_color:depend({ aS.airlag_indication, true })
			return aS, true
		end),
	}
	n.misc = {
		killsay = aJ.misc:switch("chat spammer"),
		clantag = aJ.misc:switch("clantag"),
		auto_hideshots = aJ.misc:switch("automatic hideshots", false, nil, function(aR)
			local aS = {
				auto_hideshots_wpns = aR:selectable(
					"\nStyle",
					{ "Pistol", "Scout", "Scar", "Rifle", "SMG", "Machinegun", "Shotgun" }
				),
			}
			return aS, true
		end),
		dormant_aimbot = aJ.misc:switch("dormant aimbot", false, nil, function(aR)
			local aS = {
				hitboxes = aR:selectable("Hitboxes", { "Head", "Chest", "Stomach", "Legs" }),
				hitchance = aR:slider("Accuracy", 50, 85, 60, nil, "%"),
				damage = aR:slider("Min. Damage", -1, 130, -1, nil, function(aX)
					if aX == -1 then
						return "Auto"
					end
					if aX > 100 then
						return "+" .. aX - 100
					end
					return nil
				end),
				auto_scope = aR:switch("Auto Scope"),
			}
			return aS, true
		end),
		aimbot_logging = aJ.misc:switch("log aimbot shots", false, nil, function(aR)
			local aS = {
				selectable = aR:selectable("\n", "print_dev", "print_raw"),
				hit = aR:color_picker("hit", color(163, 211, 80, 255)),
				miss = aR:color_picker("miss", color(240, 191, 86, 255)),
			}
			return aS, true
		end),
		ping_spike = aJ.misc:switch("ping spike", false, nil, function(aR)
			local aS = { val = aR:slider("\n ping_spike val", 0, 200, 0, 1) }
			return aS, true
		end),
		fast = aJ.misc:switch("fast ladder move"),
		fall = aJ.misc:switch("no fall damage"),
		peek_bot = aJ.misc:switch("peek bot", false, nil, function(aR)
			local aS = {
				on_key = aR:switch("key"),
				freestand = aR:switch("freestand"),
				response = aR:combo("response", "medium", "fast", "slow"),
				pr = aR:switch("force teleport"),
				set_stand = aR:switch("force stand"),
				val = aR:slider("\n stand val", 0, 500, 20, 1),
			}
			aS.val:depend(aS.set_stand)
			return aS, true
		end),
	}
	for aT, aW in pairs(n.anitaim) do
		aW:depend({ n.main_list, 2 }, { n.switch_builder, true })
	end
	for aT, aW in pairs(n.home) do
		aW:depend({ n.main_list, 1 })
	end
	for aT, aW in pairs(n.visuals) do
		aW:depend({ n.main_list, 3 })
	end
	for aT, aW in pairs(n.misc) do
		aW:depend({ n.main_list, 4 })
	end
	local aY = function(aZ)
		ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"):disabled(aZ)
		ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"):disabled(aZ)
		ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"):disabled(aZ)
		ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"):disabled(aZ)
		ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"):disabled(aZ)
		l.aa.angles.freestanding:disabled(aZ)
	end
	n.switch_builder:set_callback(function(self)
		if self:get() then
			aY(true)
		end
		if not self:get() then
			aY(false)
		end
	end, true)
	b.setup(n)
end
do
	files.default_path = "nl\\meteor"
	files.config_path = files.default_path .. "\\configs.json"
	local a_ = { main = { names = j.names, values = j.values } }
	s.on_first_load = function()
		if files.read(files.config_path) == nil then
			files.create_folder(files.default_path)
			files.write(files.config_path, json.stringify(a_.main))
		end
	end
	s.on_first_load()
	s.exist = function()
		local ay = json.parse(files.read(files.config_path))
		a_.main.names = j.names
		a_.main.values = j.values
		for a6 = 1, #j.names do
			if j.names[a6] ~= ay.names[a6] or j.values[a6] ~= ay.values[a6] then
				files.write(files.config_path, json.stringify(a_.main))
			end
		end
	end
	s.exist()
	s.parse = function()
		local ay = json.parse(files.read(files.config_path))
		j.names = ay.names
		j.values = ay.values
		n.home.presets.ref:update(j.names)
	end
	s.parse()
	s.update = function()
		a_.main.names = j.names
		a_.main.values = j.values
		files.write(files.config_path, json.stringify(a_.main))
	end
	s.update()
	n.home.presets.ref:update(j.names)
end
do
	local b0 = function()
		local b1 = math.huge
		local b2 = 0
		local b3 = entity.get_local_player()
		local b4 = entity.get_players(true)
		for a6 = 1, #b4 do
			local a2 = b4[a6]
			local b5 = a2:get_origin()
			local b6 = b3:get_origin()
			if a2 ~= b3 and a2:is_alive() then
				local b7 = (c(b5.x, b5.y, b5.z) - c(b6.x, b6.y, b6.z)):length2d()
				if b7 < b1 then
					b1 = b7
					b2 = b5.z - b6.z
				end
			end
		end
		return math.floor(b1 / 10), math.floor(b2)
	end
	local b8 = globals.tickcount
	local b9 = true
	m.get_state = function()
		local X = entity.get_local_player()
		local ba = X.m_vecVelocity:length()
		local bb = utils.in_duck(X) or l.aa.other.fake_duck:get()
		local aU = ba > 1.5 and "run" or "stand"
		if utils.air(X) or b9 then
			aU = bb and "duck jump" or "jump"
		elseif ba > 1.5 and bb then
			aU = "duck move"
		elseif l.aa.other.slow_walk:get() then
			aU = "slow walk"
		elseif bb then
			aU = "duck"
		end
		if globals.tickcount ~= b8 then
			b9 = utils.air(X)
			b8 = globals.tickcount
		end
		return aU
	end
	m.fs_disablers = {
		["stand"] = function()
			return m.get_state() == "stand"
		end,
		["run"] = function()
			return m.get_state() == "run"
		end,
		["slow walk"] = function()
			return m.get_state() == "slow walk"
		end,
		["jump"] = function()
			return utils.air(entity.get_local_player())
		end,
		["duck"] = function()
			return utils.in_duck(entity.get_local_player())
		end,
	}
	m.disable_freestanding = function()
		if #n.anitaim.freestand.air.value <= 0 then
			return
		end
		for w, ak in pairs(n.anitaim.freestand.air()) do
			if m.fs_disablers[ak]() then
				return true
			end
		end
	end
	m.calculate_additional_states = function(bc)
		local aU = m.get_state()
		local bd = l.rage.doubletap:get()
		local be = l.rage.hideshots:get()
		local bf = l.aa.other.fake_duck:get()
		local bg = n.misc.peek_bot() and n.misc.peek_bot.on_key() and n.misc.peek_bot.freestand()
			or n.anitaim.freestand() and not m.disable_freestanding() and rage.antiaim:get_target(true)
		local bh = { b0() }
		local bi = entity.get_local_player():get_player_weapon()
		local bj = bi ~= nil and bi:get_classname() == "CKnife"
		local bk = bi ~= nil and bi:get_classname() == "CWeaponTaser"
		local bl = n.anitaim.safe_head_multiselect:get("knife") and bj
		local bm = n.anitaim.safe_head_multiselect:get("zeus") and bk
		local bn = n.anitaim.safe_head_multiselect:get("height distance") and bh[2] < -50
		local bo = n.anitaim.safe_head_multiselect:get("high distance") and bh[1] > 119
		local bp = o.get_manual(bc) ~= 0
		if n.builder["freestanding"].enable() and rage.antiaim:get_target(true) and bg then
			aU = "freestanding"
		end
		if bp and n.builder["manual"].enable() then
			aU = "manual"
		end
		if n.builder["safe head"].enable() and (bl or bm or bn or bo) and (aU == "duck jump" or aU == "jump") then
			aU = "safe head"
		end
		if n.builder["air exploit"].enable() and p.reset then
			aU = "air exploit"
		end
		if n.builder["fakelag"].enable() and (not bd and not be or bf) then
			aU = "fakelag"
		end
		if n.builder["hideshots"].enable() and be and not bd and not bf then
			aU = "hideshots"
		end
		return aU
	end
end
do
	local bq = globals.realtime
	local br = false
	local bs = function(bc)
		local X = entity.get_local_player()
		if X == nil then
			return 0
		end
		local bt = X:get_eye_position()
		if bt == nil then
			return 0
		end
		local au = 0
		local bu = {}
		for bv = 18, 360, 18 do
			local bw = c():angles(0, bv)
			local bx = bt + bw * 32
			local by = utils.trace_line(bt, bx, X, 0xFFFFFFFF, 1)
			local a2, bz = by.entity, by.fraction
			if bz == 1.0 or a2 == nil or by:did_hit_non_world() then
				goto bA
			end
			au = au + 1
			table.insert(bu, bv)
			::bA::
		end
		if au < 2 then
			return 0
		end
		local bB = bc.view_angles
		local bC = (bu[1] + bu[au]) * 0.5
		local bD = math.normalize_yaw(-bB.y + bC)
		if math.abs(bD) > 90 then
			return 0
		end
		bD = bD * 2.0 + 180
		return bD
	end
	o.get_manual = function(bc)
		local bE = n.anitaim.manual() == "manual left"
		local bF = n.anitaim.manual() == "manual right"
		local bw = n.anitaim.manual() == "manual forward"
		if bE then
			return -90
		elseif bF then
			return 90
		elseif bw then
			return 180
		end
		return 0
	end
	local bG = false
	local bH = nil
	local bI = function(a4)
		local bJ, bK = a4.body_yaw.value, a4.body_yaw.body_yaw_offset.value
		local bL = false
		local bx, bM = a4.yaw_expand.value, a4.yaw_expand.delay.value
		local bN = bM * 2
		if bJ == "jitter" then
			if
				bx == "left/right"
				and (l.rage.hideshots:get() or l.rage.doubletap:get())
				and rage.exploit:get() == 1
			then
				if globals.tickcount % bN == bN - 1 then
					bG = not bG
				end
			else
				if globals.tickcount % 2 == 0 then
					bG = not bG
				end
			end
		elseif bJ == "static" then
			bH = not (bK >= 0)
		end
		return bG
	end
	local bO = 1
	local bP = false
	local bQ = false
	local bR = function(bc, a4)
		local aX, bS, bT, bU = a4.yaw_add.value, a4.yaw_expand.value, a4.yaw_expand.x_way.value, a4.yaw_add.random.value
		local bV, bW = a4.yaw_expand.expand_yaw.value, a4.yaw_expand.expand_yaw_2.value
		if globals.tickcount % 2 == 0 then
			bP = not bP
		end
		if a4.body_yaw.value == "static" or a4.body_yaw.value == "off" then
			bQ = bP
		else
			bQ = rage.antiaim:inverter()
		end
		if bS == "left/right" then
			aX = aX + (bQ and bV or bW)
		elseif bS == "random" then
			aX = aX + math.random(bV, bW)
		elseif bS == "x-way" then
			bO = bO < bT - 1 and bO + 1 or 0
			local az = bO / (bT - 1)
			aX = aX + math.lerp(-bV, bV, az)
		end
		return aX + math.random(-bU, bU)
	end
	local bX = 1
	local bY = false
	local bZ = false
	local b_ = function(bc, a4)
		local aX, bS, c0 = 0, a4.yaw_jitter.value, a4.yaw_jitter.yaw_jitter_add.value
		if globals.tickcount % 2 == 0 then
			bY = not bY
		end
		if a4.body_yaw.value == "static" or a4.body_yaw.value == "off" then
			bZ = bY
		else
			bZ = rage.antiaim:inverter()
		end
		if bS == "offset" then
			aX = bZ and c0 or 0
		elseif bS == "center" then
			aX = bZ and -c0 / 2 or c0 / 2
		elseif bS == "random" then
			aX = math.random(0, c0) - c0 / 2
		elseif bS == "skitter" then
			bX = bX < 3 - 1 and bX + 1 or 0
			local az = bX / (3 - 1)
			aX = math.lerp(-c0, c0, az)
		end
		return aX
	end
	local c1 = 0
	local c2 = 0
	local c3 = false
	local c4 = 0
	local c5 = function(bc, a4)
		local c6, c5, c7 = a4.break_lc.value, a4.defensive.value, 89
		l.rage.doubletap_config:override(c6 and "always on" or "on peek")
		l.rage.hideshots_config:override(c6 and "Break LC" or nil)
		l.aa.angles.hidden:override(c5 and not n.anitaim.edge_yaw())
		if not c5 then
			return
		end
		for a8, aU in pairs(utils.data) do
			local c8 = globals.tickcount
			if c8 > aU.speed or math.abs(c8) > 64 then
				for a6 = 1, aU.iterations do
					if aU.value < aU.target then
						aU.value = aU.value + 1
					else
						aU.value = aU.start
					end
				end
			end
		end
		local c9, ca, cb, cc =
			a4.defensive.pitch.value,
			a4.defensive.pitch_angles_1.value,
			a4.defensive.pitch_angles_2.value,
			a4.defensive.pitch_x_way.value
		if c9 == "static" then
			c7 = ca
		elseif c9 == "random" then
			c7 = math.random(ca, cb)
		elseif c9 == "x-way" then
			c1 = c1 < cc - 1 and c1 + 1 or 0
			local az = c1 / (cc - 1)
			c7 = math.lerp(-ca, ca, az)
		elseif c9 == "spin" then
			c7 = utils.spin(
				string.format("spinbot_pitch_%s", a4),
				a4.defensive.pitch_angles_from.value,
				a4.defensive.pitch_angles_to.value,
				1,
				a4.defensive.pitch_angles_speed.value
			).value
		end
		local bR, cd, ce = a4.defensive.yaw.value, a4.defensive.yaw_angles.value, a4.defensive.yaw_x_way.value
		if bR == "static" then
			c4 = cd
		elseif bR == "random" then
			c4 = math.random(-cd, cd)
		elseif bR == "x-way" then
			c2 = c2 < ce - 1 and c2 + 1 or 0
			local az = c2 / (ce - 1)
			c4 = math.lerp(-cd, cd, az)
		elseif bR == "spin" then
			c4 = utils.spin(
				string.format("spinbot_yaw_%s", a4),
				a4.defensive.yaw_angles_from.value,
				a4.defensive.yaw_angles_to.value,
				1,
				a4.defensive.yaw_angles_speed.value
			).value
		elseif bR == "jitter" then
			local bN = a4.defensive.delay.value * 2
			if globals.tickcount % bN == bN - 1 then
				c3 = not c3
			end
			c4 = c3 and cd or -cd
		elseif bR == "wraith" then
			if c4 >= 1080 then
				c4 = 0
			end
			c4 = c4 + 20
		end
		rage.antiaim:override_hidden_pitch(c7)
		rage.antiaim:override_hidden_yaw_offset(c4)
	end
	local cf = false
	local cg = function(bc)
		cf = false
		if not n.anitaim.antiaims_tweaks:get("anti-aim on use") then
			return
		end
		if not bc.in_use then
			bq = globals.realtime
			return
		end
		local _ = entity.get_local_player()
		if _ == nil then
			return
		end
		local ch = _:get_origin()
		local ci = entity.get_entities("CPlantedC4")
		local cj = 999
		if #ci > 0 then
			local ck = ci[1]
			local cl = ck:get_origin()
			cj = ch:dist(cl)
		end
		local cm = entity.get_entities("CHostage")
		local cn = 999
		if #cm > 0 then
			local co = { cm[1]:get_origin(), cm[2]:get_origin() }
			cn = math.min(ch:dist(co[1]), ch:dist(co[2]))
		end
		if cn < 65 and _.m_iTeamNum ~= 2 then
			return
		end
		if cj < 65 and _.m_iTeamNum ~= 2 then
			return
		end
		if bc.in_use then
			if globals.realtime - bq < 0.02 then
				return
			end
		end
		bc.in_use = false
		cf = true
	end
	o.setup = function(bc)
		local _ = entity.get_local_player()
		if _ == nil then
			return
		end
		local aU = m.calculate_additional_states(bc)
		local a4 = n.builder[aU].enable.value and n.builder[aU] or n.builder["global"]
		local cp = a4.body_yaw.value ~= "off"
		local cq = a4.yaw_base.value
		local bR = utils.defensive() > 0 and a4.defensive.freestand() and 0
			or bR(bc, a4) + b_(bc, a4) + o.get_manual(bc)
		local cr = utils.defensive() > 0 and a4.defensive.freestand() and c3 or bI(a4)
		local cs = a4.body_yaw.body_yaw_options.value
		c5(bc, a4)
		cg(bc)
		if n.anitaim.edge_yaw() then
			bR = bR + bs(bc)
		end
		local bg
		if
			n.misc.peek_bot() and n.misc.peek_bot.on_key() and n.misc.peek_bot.freestand()
			or n.anitaim.freestand.value and not m.disable_freestanding()
		then
			bg = true
		else
			bg = false
		end
		local c9 = "down"
		if cf then
			cq = "local view"
			c9 = "Disabled"
			bR = bR + 180
			bg = false
		end
		rage.antiaim:inverter(cr)
		l.aa.angles.yaw_backstab:override(n.anitaim.antiaims_tweaks:get("avoid-backstab"))
		l.aa.angles.pitch:override(c9)
		l.aa.angles.yaw_offset:override(bR)
		l.aa.angles.yaw:override("backward")
		l.aa.angles.yaw_base:override(cq)
		l.aa.angles.body_yaw:override(cp)
		l.aa.angles.left_limit:override(58)
		l.aa.angles.right_limit:override(58)
		l.aa.angles.body_yaw_options:override(cs)
		l.aa.angles.freestanding:override(bg)
		l.aa.angles.yaw_modifier:override("Disabled")
		l.aa.angles.disable_yaw_modif:override(false)
		l.aa.angles.body_freestanding:override(false)
		if n.anitaim.roll() then
			bc.view_angles.z = n.anitaim.roll.auto_switch()
					and (rage.antiaim:inverter() and n.anitaim.roll.roll() or -n.anitaim.roll.roll())
				or n.anitaim.roll.roll()
		end
	end
	n.switch_builder:set_event("createmove", o.setup)
end
local ct
do
	ct = {}
	ct.handle = function()
		local _ = entity.get_local_player()
		local cu = z.entity_list_pointer(_:get_index())
		if _ == nil then
			return
		end
		if n.anitaim.anim_breakers:get("legs in air") then
			if n.anitaim.anim_breakers.air() == "allah" then
				if bit.band(entity.get_local_player()["m_fFlags"], 1) == 0 then
					a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 10640)[0][6].m_flWeight = 1
					entity.get_local_player().m_flPoseParameter[7] = 1
				end
			elseif n.anitaim.anim_breakers.air() == "t-pose" then
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][4].m_flCycle = 0.4
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][4].m_nSequence = 11
			elseif n.anitaim.anim_breakers.air() == "static" then
				entity.get_local_player().m_flPoseParameter[6] = 1
			elseif
				n.anitaim.anim_breakers.air() == "dumb" and bit.band(entity.get_local_player()["m_fFlags"], 1) == 0
			then
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][6].m_flWeight = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][6].m_nSequence = 135
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_flWeight = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_nSequence = 100
			elseif
				n.anitaim.anim_breakers.air() == "stiff duck"
				and bit.band(entity.get_local_player()["m_fFlags"], 1) == 0
			then
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][6].m_flWeight = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][6].m_nSequence = 30
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_flWeight = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][6].m_nSequence = 30
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][2].m_flCycle = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_flCycle = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_nSequence = 185
			end
		end
		if n.anitaim.anim_breakers:get("legs on ground") then
			if n.anitaim.anim_breakers.ground() == "allah" then
				l.aa.other.legs:set("Walking")
				entity.get_local_player().m_flPoseParameter[7] = 0
			elseif n.anitaim.anim_breakers.ground() == "sliding" then
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_flWeight = 1
				entity.get_local_player().m_flPoseParameter[0] = 1
				l.aa.other.legs:set("Sliding")
			elseif
				not bit.band(entity.get_local_player()["m_fFlags"], 1) == 0
				and n.anitaim.anim_breakers.ground() == "dislocated arm"
			then
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_flWeight = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][6].m_nSequence = 5
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][4].m_flCycle = 5
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][8].m_flWeight = 1
				a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][7].m_nSequence = 400
			end
		end
		if n.anitaim.anim_breakers:get("0 pitch on land") and entity.get_local_player():get_anim_state().landing then
			entity.get_local_player().m_flPoseParameter[12] = 0.5
		end
		if n.anitaim.anim_breakers:get("move lean earthquake") then
			a.cast("CAnimationLayer**", a.cast("uintptr_t", cu) + 0x2990)[0][12].m_flWeight =
				utils.random_int(-0.3, 0.65)
		end
	end
	n.switch_builder:set_event("post_update_clientside_animation", ct.handle)
end
do
	p.reset = false
	p.backups = function()
		if p.reset then
			l.aa.other.fake_duck:override(nil)
			l.aa.fakelag.fakelag_limit:override(nil)
			l.aa.fakelag.fakelag_var:override(nil)
			cvar.sv_maxusrcmdprocessticks:int(16)
			p.reset = false
		end
	end
	p.handle = function()
		if not n.anitaim.air_lag() then
			return p.backups()
		end
		if not l.rage.doubletap:get() then
			return p.backups()
		end
		rage.exploit:allow_defensive(false)
		cvar.sv_maxusrcmdprocessticks:int(19)
		l.aa.fakelag.fakelag_limit:override(17)
		l.aa.fakelag.fakelag_var:override(0)
		rage.exploit:force_charge()
		l.aa.other.fake_duck:override(globals.tickcount % 10 == 0 and true or nil)
		p.reset = true
	end
	n.switch_builder:set_event("createmove", p.handle)
end
do
	local cv = render.load_font("Verdana Bold", 10, "ad")
	local cw = render.screen_size()
	q.sc_indicators = function()
		local cx = {}
		local cy = n.visuals.sc_indicators()
		local cz = n.visuals.sc_indicators.ind_color()
		local cA = n.visuals.sc_indicators.build_color()
		cx.main = k.new("screen_indication_main", cy and 255 or 0)
		if cx.main < 1 then
			return
		end
		local _ = entity.get_local_player()
		if _ == nil or not _:is_alive() then
			return
		end
		local cB = _.m_bIsScoped
		local cC = 25 + n.visuals.sc_indicators.glow_px()
		local cD = {
			{ "safe", l.rage.prefer_safety:get() == "Force" },
			{ "body", l.rage.prefer_body:get() == "Force" },
			{ "dt", l.rage.doubletap:get() },
			{ "hs", l.rage.hideshots:get() },
			{ "fs", n.anitaim.freestand() },
			{ "al", p.reset },
		}
		local cE = render.measure_text(cv, nil, "meteor").x
		cx.lua_name = {}
		cx.lua_name.move = {}
		cx.lua_name.alpha = k.new("lua_name_alpha", cy and 255 or 0)
		cx.lua_name.move = 0 + string.format("%.0f", k.new("lua_name_move", cy and not cB and -cE * 0.5 or 15))
		cx.lua_name.text = aq.wave(
			"meteor",
			cz:override("a", cx.lua_name.alpha),
			cA:override("a", cx.lua_name.alpha),
			globals.realtime
		)
		if cx.lua_name.alpha > 1 then
			if n.visuals.sc_indicators.glow_switch() then
				render.shadow(
					cw * 0.5 + c(cx.lua_name.move, cC + 7),
					cw * 0.5 + c(cx.lua_name.move, cC + 7) + c(cE, 0),
					color(cz.r, cz.g, cz.b, cx.lua_name.alpha),
					20,
					0
				)
			end
			render.text(
				cv,
				cw * 0.5 + c(cx.lua_name.move, cC),
				color(cz.r, cz.g, cz.b, cx.lua_name.alpha),
				nil,
				cx.lua_name.text
			)
			cC = cC + string.format("%.0f", cx.lua_name.alpha / 255 * 12)
		end
		local aG = ""
		cx.binds = {}
		for w, aW in pairs(cD) do
			cx.binds[aW[1]] = {}
			cx.binds[aW[1]].alpha = k.new("binds_alpha_" .. aW[1], cy and aW[2] and 255 or 0, 0.5)
			cx.binds[aW[1]].move = 0
				+ string.format(
					"%.0f",
					k.new("binds_move_" .. aW[1], cy and not cB and -render.measure_text(1, nil, aW[1]).x * 0.5 or 15)
				)
			if cx.binds[aW[1]].alpha > 1 then
				render.text(
					1,
					cw * 0.5 + c(cx.binds[aW[1]].move, cC),
					aW[1] ~= "hs" and color()
						or (not l.rage.doubletap:get() and color() or color(255, 100, 100, cx.binds[aW[1]].alpha))
						or (
							aW[1] ~= "dt" and color()
							or (rage.exploit:get() == 1 and color() or color(255, 100, 100, cx.binds[aW[1]].alpha))
						),
					nil,
					aW[1]
				)
				cC = cC + string.format("%.0f", cx.binds[aW[1]].alpha / 255 * 12)
			end
		end
	end
	q.damage_indicator = function()
		local _ = entity.get_local_player()
		if _ == nil or not _:is_alive() then
			return
		end
		local bC = render.screen_size() / 2
		local cF = tostring(l.rage.min_damage:get())
		render.text(1, c(cw.x / 2 + 10, cw.y / 2 - 15), color(), "", cF)
	end
	n.visuals.sc_indicators:set_event("render", q.sc_indicators)
	n.visuals.damage_indicator:set_event("render", q.damage_indicator)
	events.render:set(function()
		render.text(cv, c(cw.x * 0.5, cw.y - 15), color(), "c", "m e t e o r")
	end)
	local cG = {}
	do
		local cH = ui.get_icon("meteor")
		local ak = "Meteor"
		local function cI()
			local cJ = ui.get_style()
			local aG = aq.wave(ak, cJ["Link Active"], cJ["Disabled Text"], globals.realtime)
			ui.sidebar(aG, cH)
		end
		events.render(cI)
	end
end
do
	local cK = cvar.r_aspectratio
	local cL = cK.float
	local cM = function()
		local cN = n.visuals.aspect_ratio.val() / 100
		if n.visuals.aspect_ratio.val() == 50 then
			cN = 0
		end
		if not n.visuals.aspect_ratio() then
			cN = 0
		end
		local cO = cL(cK)
		if cN ~= cO then
			cL(cK, cN)
		end
	end
	local cP = function()
		cL(cK, 0)
	end
	cM()
	n.visuals.aspect_ratio:set_callback(cM)
	n.visuals.aspect_ratio.val:set_callback(cM)
	n.visuals.aspect_ratio.preset1:set_callback(cM)
	n.visuals.aspect_ratio.preset2:set_callback(cM)
	n.visuals.aspect_ratio.preset3:set_callback(cM)
	n.visuals.aspect_ratio.preset4:set_callback(cM)
	n.visuals.aspect_ratio.preset5:set_callback(cM)
	events.shutdown:set(cP)
end
local cQ
do
	cQ = function(cR)
		local cS = i[cR.hitgroup]
		local bN = entity.get(cR.target)
		local cT = bN:get_name()
		local cU = cR.damage
		local cV = cR.hitchance
		local cW = cR.state
		local cX = bN["m_iHealth"]
		local cY = i[cR.wanted_hitgroup]
		local cZ = cR.backtrack
		local c_ = n.misc.aimbot_logging.hit()
		local d0 = n.misc.aimbot_logging.miss()
		local function d1(type, a5)
			local d2 = type == 1 and c_ or type == 2 and d0
			if d2 ~= nil then
				return "\a" .. d2:to_hex() .. a5 .. "\aDCDCDCFF"
			end
		end
		if cW == nil then
			local d3 = "  METEOR ~ "
				.. "Hit "
				.. d1(1, cT)
				.. "'s "
				.. d1(1, cS)
				.. " for "
				.. d1(1, cU)
				.. " damage "
				.. "( hc = "
				.. d1(1, cV)
				.. " | "
				.. d1(1, cX)
				.. " health remaining"
				.. " | backtrack = "
				.. d1(1, cZ)
				.. ")"
			local d4 = "Hit "
				.. d1(1, cT)
				.. "'s "
				.. d1(1, cS)
				.. " for "
				.. d1(1, cU)
				.. " damage "
				.. "( hc = "
				.. d1(1, cV)
				.. " | "
				.. d1(1, cX)
				.. " health remaining"
				.. " | backtrack = "
				.. d1(1, cZ)
				.. ")"
			if n.misc.aimbot_logging.selectable:get("print_dev") then
				print_dev(d4)
			end
			if n.misc.aimbot_logging.selectable:get("print_raw") then
				print_raw(d3)
			end
		else
			local d5 = "  METEOR ~ "
				.. "Missed "
				.. d1(2, cT)
				.. "'s "
				.. d1(2, cY)
				.. " due to "
				.. d1(2, cW)
				.. " ( hc = "
				.. d1(2, cV)
				.. " | backtrack = "
				.. d1(2, cZ)
				.. ")"
			local d6 = "Missed "
				.. d1(2, cT)
				.. "'s "
				.. d1(2, cY)
				.. " due to "
				.. d1(2, cW)
				.. " ( hc = "
				.. d1(2, cV)
				.. " | backtrack = "
				.. d1(2, cZ)
				.. ")"
			if n.misc.aimbot_logging.selectable:get("print_dev") then
				print_dev(d6)
			end
			if n.misc.aimbot_logging.selectable:get("print_raw") then
				print_raw(d5)
			end
		end
	end
	n.misc.aimbot_logging:set_event("aim_ack", cQ)
end
local d7
do
	d7 = function(bc)
		local X = entity.get_local_player()
		if X == nil then
			return
		end
		if X.m_MoveType == 9 then
			bc.view_angles.y = math.floor(bc.view_angles.y + 0.5)
			if bc.forwardmove > 0 then
				if bc.view_angles.x < 45 then
					bc.view_angles.x = 89
					bc.in_moveright = 1
					bc.in_moveleft = 0
					bc.in_forward = 0
					bc.in_back = 1
					if bc.sidemove == 0 then
						bc.view_angles.y = bc.view_angles.y + 90
					end
					if bc.sidemove < 0 then
						bc.view_angles.y = bc.view_angles.y + 150
					end
					if bc.sidemove > 0 then
						bc.view_angles.y = bc.view_angles.y + 30
					end
				end
			elseif bc.forwardmove < 0 then
				bc.view_angles.x = 89
				bc.in_moveleft = 1
				bc.in_moveright = 0
				bc.in_forward = 1
				bc.in_back = 0
				if bc.sidemove == 0 then
					bc.view_angles.y = bc.view_angles.y + 90
				end
				if bc.sidemove > 0 then
					bc.view_angles.y = bc.view_angles.y + 150
				end
				if bc.sidemove < 0 then
					bc.view_angles.y = bc.view_angles.y + 30
				end
			end
		end
	end
	n.misc.fast:set_event("createmove", d7)
end
local d8
do
	local d9 = function(a2, da)
		local db, dc, dd = a2.m_vecOrigin.x, a2.m_vecOrigin.y, a2.m_vecOrigin.z
		local de = math.pi * 2
		local az = de / 8
		for aR = 0, de, az do
			local df, dg = 10 * math.cos(aR) + db, 10 * math.sin(aR) + dc
			local by = utils.trace_line(c(df, dg, dd), c(df, dg, dd - da), a2)
			local bz, entity = by.fraction, by.entity
			if bz ~= 1 then
				return true
			end
		end
		return false
	end
	d8 = function(bc)
		local _ = entity.get_local_player()
		if _ == nil then
			return
		end
		local ba = _.m_vecVelocity
		if ba.z < -500 then
			if d9(_, 15) then
				bc.in_duck = 0
			elseif d9(_, 75) then
				bc.in_duck = 1
			end
		end
	end
	n.misc.fall:set_event("createmove", d8)
end
local dh
do
	local di = {
		"ez owned by meteor? lol",
		"what u do?? dog",
		"1, y u lose? xaxaxaxaxa",
		"legends never die -- meteor",
		"lol, brainless kid, miss again and dead again",
		"Легенда никогда не кончается – метеор",
		"Get Meteor - Recode ----> https://en.neverlose.cc/market/item?id=R1lm2A, xaxaxaxaxa",
		"你的aa比薯片脆",
		"实在不行你去买个模型吧",
		"你的脑子只适合玩原神?",
		"滚去玩王者荣耀吧窝囊废",
		"你是没有手吗?",
		"你的脑容量比你参群人数还少",
		"银行卡密码都被我骗出来了",
		"农村人滚回去种地",
		"你怎么一骗就出了孩子",
		"你在屏幕前红温的样子被我记录下来了",
		"我杀你只需要一根手指",
		"ez",
		"这就死了吗...我都还没开始发力",
		"我没想到你参数这么垃圾...",
		"杀你只需要一根手指",
		"1",
		"1，你怎么这么菜...",
		"你在用otc么废物?",
		"easy xD",
		"1,别急",
		"农民你被你爹1了，滚去买个好点的参数吧",
		"你也被脑控了吗",
	}
	dh = function(cR)
		local X = entity.get_local_player()
		local dj = entity.get(cR.userid, true)
		local dk = entity.get(cR.attacker, true)
		if dj == dk or dk ~= X then
			return
		end
		utils.execute_after(1, function()
			utils.console_exec('say "' .. di[utils.random_int(1, #di)]:gsub('"', "") .. '"')
		end)
	end
	n.misc.killsay:set_event("player_death", dh)
end
local dl
do
	dl = {}
	local dm = function(a5)
		local dn = { " ", " ", " " }
		local dp = ""
		for a6 = 1, #a5 do
			local av = a5:sub(a6, a6)
			dp = dp:lower() .. av:upper()
			dn[a6] = dp
		end
		dn[#dn + 1] = a5
		for a6 = #dn, 1, -1 do
			table.insert(dn, dn[a6])
		end
		dn[#dn + 1] = " "
		dn[#dn + 1] = " "
		dn[#dn + 1] = " "
		return dn
	end
	local dq, dr = false, 0
	dl.build = function()
		local dn = dm("meteor ")
		dq = false
		local ds = math.floor(globals.curtime * 4.5)
		if dr ~= ds then
			common.set_clan_tag(dn[ds % #dn + 1])
		end
		dr = ds
		l.misc.main.in_game.clan_tag:set(false)
	end
	n.misc.clantag:set_event("render", dl.build)
end
local dt
do
	local du =
		{ ["pistol"] = "Pistol", ["rifle"] = "Rifle", ["smg"] = "SMG", ["machinegun"] = "Machinegun", ["shotgun"] = "Shotgun" }
	local dv = { ["SSG 08"] = "Scout", ["SCAR-20"] = "Scar", ["G3SG1"] = "Scar" }
	local dw = { [64] = true }
	dt = function(bc)
		if not n.misc.auto_hideshots.value or #n.misc.auto_hideshots.auto_hideshots_wpns.value <= 0 then
			return
		end
		if n.anitaim.air_lag() then
			l.rage.hideshots:override()
			return
		end
		local a2 = entity.get_local_player()
		local dx = utils.get_weapon_struct(a2)
		if dx == nil then
			return
		end
		local dy = du[dx.type] ~= nil and n.misc.auto_hideshots.auto_hideshots_wpns:get(du[dx.type])
		local dz = dv[dx.name] ~= nil and n.misc.auto_hideshots.auto_hideshots_wpns:get(dv[dx.name])
		if
			bc.in_duck
			and not utils.air(a2)
			and l.rage.doubletap:get()
			and (dy or dz)
			and not dw[utils.get_weapon_index(a2)]
		then
			l.rage.hideshots:override(true)
			l.rage.doubletap:override(false)
		else
			l.rage.hideshots:override(nil)
			l.rage.doubletap:override(nil)
		end
	end
	n.misc.auto_hideshots:set_event("createmove", dt)
end
local dA
do
	local dB =
		{ "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }
	local dC = color(255)
	local dD = function(dE)
		if dC ~= dE then
			for aT, dF in pairs(dB) do
				materials.get_materials(dF)[1]:alpha_modulate(dE.a / 255)
				materials.get_materials(dF)[1]:color_modulate(color(dE.r, dE.g, dE.b))
			end
			dC = dE
		end
	end
	dA = function()
		local dE = z.console_is_visible() and n.visuals.console_color.accent_color() or color(255)
		dD(dE)
	end
	n.visuals.console_color:set_event("render", dA)
end
local dG
do
	local dH = function()
		local _ = entity.get_local_player()
		if _ == nil then
			return
		end
		local dI = _:get_origin()
		local dJ = entity.get_entities("CSmokeGrenadeProjectile")
		local dK = entity.get_entities("CInferno")
		local dL = { { position = c(0, 0, 0), percentage = 0, alpha = 0, draw = false } }
		local dM = { { position = c(0, 0, 0), percentage = 0, radius = 0, alpha = 0, draw = false, teammate = false } }
		local dN = globals.tickcount
		local dO = globals.tickinterval
		local dP = 600
		if dJ ~= nil then
			for w, aW in pairs(dJ) do
				if dL[w] == nil then
					dL[w] = {}
				end
				dL[w].percentage = (17.55 - dO * (dN - aW.m_nSmokeEffectTickBegin)) / 17.55
				dL[w].position = aW:get_origin()
				dL[w].alpha = aW:get_bbox().alpha * 255
				if aW.m_bDidSmokeEffect and dI:dist(dL[w].position) < dP then
					dL[w].draw = true
				end
			end
		end
		if dK ~= nil then
			local dQ = cvar.mp_friendlyfire:int() == 0
			for w, aW in pairs(dK) do
				if dM[w] == nil then
					dM[w] = {}
				end
				dM[w].percentage = (7 - dO * (dN - aW.m_nFireEffectTickBegin)) / 7
				dM[w].position = aW:get_origin()
				dM[w].alpha = aW:get_bbox().alpha * 255
				local dR = aW.m_hOwnerEntity
				if dQ and dR ~= _ and not dR:is_enemy() then
					dM[w].teammate = true
				end
				local dS = 40
				local dT = 0
				local dU = {}
				local dV = 0
				local dW, dX
				for a6 = 1, 64 do
					if aW.m_bFireIsBurning[a6] == true then
						table.insert(dU, c(aW.m_fireXDelta[a6], aW.m_fireYDelta[a6], aW.m_fireZDelta[a6]))
					end
				end
				local dY = #dU
				for aW = 1, dY do
					for w = 1, dY do
						local dZ = dU[aW]:dist(dU[w])
						if dZ > dV then
							dV = dZ
							dW = dU[aW]
							dX = dU[w]
						end
					end
				end
				if dW ~= nil and dX ~= nil and dI:dist(dM[w].position) < dP then
					dM[w].draw = true
					dM[w].radius = dV / 2 + dS
				end
			end
		end
		return { smoke = dL, molotov = dM }
	end
	dG = function()
		local d_ = n.visuals.nade_radius.grenade_select.ref:get(2)
		local e0 = n.visuals.nade_radius.grenade_select.ref:get(1)
		if not d_ and not e0 then
			return
		end
		local e1 = dH()
		if e1 == nil then
			return
		end
		local e2 = n.visuals.nade_radius.enemy_molotov_color()
		local e3 = n.visuals.nade_radius.molotov_color()
		local e4 = n.visuals.nade_radius.smoke_color()
		local e5 = { team = { e3.a / 255, e3:override("a", 0), e3 }, enemy = { e2.a / 255, e2:override("a", 0), e2 } }
		local cx = {}
		cx.molotov_radius = {}
		for a6 = 1, #e1.molotov do
			local aW = e1.molotov[a6]
			cx.molotov_radius[a6] = k.new("molotov_radius_" .. a6, aW.draw and aW.radius or 0, 0.095)
			if aW.draw and d_ then
				local dE = e5[aW.teammate and "team" or "enemy"]
				render.circle_3d(aW.position, dE[3]:override("a", dE[1] * aW.alpha), cx.molotov_radius[a6], 0, 1)
				render.circle_3d_outline(
					aW.position,
					dE[3]:override("a", dE[1] * aW.alpha),
					cx.molotov_radius[a6],
					0,
					aW.percentage,
					1.5
				)
			end
		end
		local e6 = e4.a / 255
		local e7 = e4:override("a", 0)
		cx.smoke_radius = {}
		for a6 = 1, #e1.smoke do
			local aW = e1.smoke[a6]
			cx.smoke_radius[a6] = k.new("smoke_radius_" .. a6, aW.draw and 125 or 0, 0.095)
			if aW.draw and e0 then
				local dE = e4
				render.circle_3d(aW.position, dE:override("a", e6 * aW.alpha), cx.smoke_radius[a6], 0, 1)
				render.circle_3d_outline(
					aW.position,
					dE:override("a", e6 * aW.alpha),
					cx.smoke_radius[a6],
					0,
					aW.percentage,
					1.5
				)
			end
		end
	end
	n.visuals.nade_radius:set_event("render", dG)
end
local e8
do
	local e9 = b.create("\v\f<house> \rmain", "\v\f<bolt> \rInformations")
		:slider("pos_x", 0, render.screen_size().x, 900)
		:visibility(false)
	local ea = b.create("\v\f<house> \rmain", "\v\f<bolt> \rInformations")
		:slider("pos_y", 0, render.screen_size().y, 300)
		:visibility(false)
	e8 = g.register({ e9, ea }, c(190, 50), "Velocity", function(self)
		local _ = entity.get_local_player()
		if _ == nil or _:is_alive() == false then
			return
		end
		local eb = n.visuals.velocity_indication.velocity_indication()
		local ec = n.visuals.velocity_indication.velocity_accent_color()
		local ed = n.visuals.velocity_indication.defensive_indication()
		local ee = n.visuals.velocity_indication.defensive_accent_color()
		local ed = n.visuals.velocity_indication.defensive_indication()
		local ef = n.visuals.velocity_indication.airlag_accent_color()
		local eg = n.visuals.velocity_indication.airlag_indication()
		local eh = c(self.position.x, self.position.y)
		local ei = k.new(
			"m_flVelocityModifier",
			ui.get_alpha() > 0 and _.m_flVelocityModifier == 1 and 0.5 or _:is_alive() and _.m_flVelocityModifier or 1
		)
		local ej = k.new(
			"m_flDefensiveModifier",
			ui.get_alpha() > 0 and not l.rage.doubletap:get() and 1 or (utils.defensive() > 0 and 0 or 1) or 1
		)
		local cx = {}
		local cC = 0
		local ek = c(120, 0)
		cx.drag = k.new("anim_drag", (eb or ed) and ui.get_alpha() > 0.5 and 255 or 0)
		cx.defensive =
			k.new("defensive_indication", ed and (l.rage.doubletap:get() or ui.get_alpha() > 0.5) and 255 or 0)
		ek.y = ek.y + cx.defensive / 255 * 29
		if cx.defensive > 1 then
			local aG = utils.color_text({ "defensive: " }, { utils.defensive() > 1 and "active" or "ready", ee })
			render.text(1, c(eh.x + 20, eh.y + 5), color(255):override("a", cx.defensive), nil, aG)
			render.shadow(c(eh.x + 4, eh.y + 19), c(eh.x + 126, eh.y + 25), ee:override("a", cx.defensive), 20, 0)
			render.rect(
				c(eh.x + 4, eh.y + 19),
				c(eh.x + 126, eh.y + 25),
				color(0, 255):override("a", cx.defensive / 2),
				2
			)
			render.rect(c(eh.x + 5, eh.y + 20), c(eh.x + ej * 120 + 5, eh.y + 24), ee:override("a", cx.defensive), 2)
		end
		cC = cC + cx.defensive / 255 * 29
		cx.velocity = k.new("velocity_indication", eb and (ui.get_alpha() > 0.5 and 255 or ei < 0.9 and 255 or 0) or 0)
		ek.y = ek.y + cx.velocity / 255 * 29
		if cx.velocity > 1 then
			local aG = utils.color_text({ "Slowed down " }, { tostring(math.floor(ei * 100)), ec }, { "%" })
			render.text(1, c(eh.x + 20, eh.y + cC + 5), color(255):override("a", cx.velocity), nil, aG)
			render.shadow(
				c(eh.x + 4, eh.y + cC + 19),
				c(eh.x + 126, eh.y + cC + 25),
				ec:override("a", cx.velocity),
				20,
				0
			)
			render.rect(
				c(eh.x + 4, eh.y + cC + 19),
				c(eh.x + 126, eh.y + cC + 25),
				color(0, 255):override("a", cx.velocity / 2),
				2
			)
			render.rect(
				c(eh.x + 5, eh.y + cC + 20),
				c(eh.x + ei * 120 + 5, eh.y + cC + 24),
				ec:override("a", cx.velocity),
				2
			)
		end
		cC = cC + cx.velocity / 255 * 29
		cx.airlag = k.new(
			"airlag_indication",
			eg and (ui.get_alpha() > 0.5 and 255 or n.anitaim.air_lag() and rage.exploit:get() and 255 or 0) or 0
		)
		ek.y = ek.y + cx.airlag / 255 * 29
		if cx.airlag > 1 then
			local aG = utils.color_text(
				{ "air lag exploit " },
				{ tostring(math.floor(rage.exploit:get() * 100)), ef },
				{ "%" }
			)
			render.text(1, c(eh.x + 20, eh.y + cC + 5), color(255):override("a", cx.airlag), nil, aG)
			render.shadow(
				c(eh.x + 4, eh.y + cC + 19),
				c(eh.x + 126, eh.y + cC + 25),
				ef:override("a", cx.airlag),
				20,
				0
			)
			render.rect(
				c(eh.x + 4, eh.y + cC + 19),
				c(eh.x + 126, eh.y + cC + 25),
				color(0, 255):override("a", cx.airlag / 2),
				2
			)
			render.rect(
				c(eh.x + 5, eh.y + cC + 20),
				c(eh.x + rage.exploit:get() * 120 + 5, eh.y + cC + 24),
				ef:override("a", cx.airlag),
				2
			)
		end
	end)
	local el = function()
		e8:update()
	end
	n.visuals.velocity_indication:set_event("render", el)
end
local em
do
	em = {
		last_target = nil,
		last_tick = 0,
		last_point = c(),
		active = false,
		was_enabled = false,
		origin = c(),
		renderpoints = c(),
		last_hitbox = nil,
	}
	local en = function(bw, eo, ba)
		local ep = ba.x * bw.x + ba.y * bw.y + ba.z * bw.z
		local eq = eo - ep
		if eq > 0 then
			local er = cvar.sv_accelerate:float() * globals.tickinterval * math.max(250, eo)
			if er > eq then
				er = eq
			end
			ba = ba + er * bw
		end
		return ba
	end
	local es = function(bw, ba)
		local X = entity.get_local_player()
		local eo = 450
		local et = X.m_flMaxspeed
		ba = en(bw, eo, ba)
		if ba:lengthsqr() > et ^ 2 then
			ba = ba / ba:length() * et
		end
		return ba
	end
	local eu = function(ev, ew, a2, bw)
		local ba = c(a2.m_vecVelocity)
		local ex = {}
		for a6 = 1, ew do
			ba = es(bw, ba)
			ev = ev + ba * globals.tickinterval
			ex[a6] = ev
		end
		return ex
	end
	local ey = function()
		local X = entity.get_local_player()
		local bN = entity.get_threat()
		if not bN or bN:is_dormant() then
			return
		end
		local ez = #l.rage.hitboxs:get() == 1 and l.rage.hitboxs:get("head")
		local eA = n.misc.peek_bot.response:get()
		local eB = ez and 0 or eA == "fast" and 8 or eA == "medium" and 3 or eA == "slow" and 5
		local eC = bN:get_hitbox_position(eB)
		local a9 = X:get_origin()
		local aa = bN:get_origin()
		local c9, bR, eD = (aa - a9):angles()
		return { ent = bN, pos = aa, hitboxes = eC, angle = bR }
	end
	local eE = function()
		local X = entity.get_local_player()
		local eF = X:get_player_weapon()
		if not eF then
			return
		end
		local bi = f(eF)
		if not bi then
			return
		end
		if bi.type == "knife" or bi.type == "grenade" or bi.type == "c4" or bi.type == "taser" then
			return
		end
		if math.max(eF.m_flNextPrimaryAttack, X.m_flNextAttack) - globals.tickinterval - globals.curtime >= 0 then
			return
		end
		if eF.m_zoomLevel ~= nil and eF.m_zoomLevel == 0 and (bi.type == "sniper" or bi.type == "sniperrifle") then
			return false
		end
		return true
	end
	utils.clamp = function(aj, eG, eH)
		assert(aj and eG and eH, "not very useful error message here")
		if eG > eH then
			eG, eH = eH, eG
		end
		return math.max(eG, math.min(eH, aj))
	end
	local eI = function()
		local eJ = cvar.cl_updaterate:int()
		local eK = cvar.sv_minupdaterate:int()
		local eL = cvar.sv_maxupdaterate:int()
		if eK and eL then
			eJ = eL
		end
		local eM = cvar.cl_interp_ratio:float()
		if eM == 0 then
			eM = 1
		end
		local eN = cvar.cl_interp:float()
		local eO = cvar.sv_client_min_interp_ratio:float()
		local eP = cvar.sv_client_max_interp_ratio:float()
		if eO and eP and eO ~= 1 then
			eM = utils.clamp(eM, eO, eP)
		end
		return math.max(eN, eM / eJ)
	end
	local eQ = function()
		local eR = z.native_GetNetChannelInfo()
		if not eR then
			return 0
		end
		local eS = cvar.sv_maxunlag:float()
		local eT = globals.curtime - math.floor(entity.get_local_player().m_nTickBase * globals.tickinterval - eS)
		local eU, eV = z.native_GetLatency(eR, 0), z.native_GetLatency(eR, 1)
		local eW = utils.clamp(eU + eV + eI(), 0, eS)
		return utils.clamp(eS + eW * 2, 0, eT) / globals.tickinterval
	end
	local eX = function(bN, ew, eY)
		local X = entity.get_local_player()
		local eZ = {}
		for aT, bD in ipairs({ 90, -90 }) do
			local bw = c():init(0, bD, 0)
			local e_ = eu(em.origin, ew - eY, X, bw)
			for aT, aW in ipairs(e_) do
				table.insert(eZ, aW)
			end
		end
		return eZ
	end
	local f0 = function(f1)
		local X = entity.get_local_player()
		local f2 = c(X.m_vecMins)
		local f3 = c(X.m_vecMaxs)
		local a9 = X:get_origin() + c((f2.x + f3.x) / 2, (f2.y + f3.y) / 2, (f2.z + f3.z) / 2 + 10)
		local aa = f1 + c((f2.x + f3.x) / 2, (f2.y + f3.y) / 2, (f2.z + f3.z) / 2 + 10)
		local f4 = utils.trace_hull(a9, aa, f2, f3, { skip = X, mask = "MASK_SHOT", type = "TRACE_EVERYTHING" })
		return f4.end_pos - c((f2.x + f3.x) / 2, (f2.y + f3.y) / 2, (f2.z + f3.z) / 2 + 10)
	end
	local f5 = function(a2)
		return a2:is_enemy()
	end
	local f6 = function(bN, eZ, f7)
		local X = entity.get_local_player()
		local eh = X:get_origin()
		local f8 = #eZ
		local f9 = { damage = 0, point = nil, ticks = 0 }
		for a6 = 1, f8, f8 / (f7 * 2) do
			local a6 = utils.clamp(math.floor(a6 + 0.5), 1, f8)
			eZ[a6] = f0(eZ[a6])
			em.renderpoints = eZ[a6]
			local f1 = eZ[a6]
			local fa = 0
			local fb
			local cU = utils.trace_bullet(X, f1, bN.hitboxes, f5)
			if cU > fa then
				fa = cU
				fb = bN.hitboxes
			end
			if fa > f9.damage or f9.point and fa == f9.damage and eh:dist2d(f9.point) > eh:dist2d(eZ[a6]) then
				f9.damage = fa
				f9.point = eZ[a6]
				f9.hitbox = fb
				f9.ticks = a6
			end
		end
		if f9.ticks > f8 / 2 then
			f9.ticks = f9.ticks - f8 / 2
		end
		if not f9.point then
			return
		end
		return f9
	end
	local fc = function(bN)
		if not bN then
			return
		end
		if not eE() then
			return
		end
		local fd = eQ()
		local eY = fd > 24 and 12 or 6
		local eZ = eX(bN, fd, eY)
		em.available_points = eZ
		local fe = 6
		local f9 = f6(bN, eZ, fe)
		if not f9 then
			return
		end
		if f9.damage < math.min(l.rage.min_damage:get(), bN.ent.m_iHealth) then
			return
		end
		return { tick_time = f9.ticks, tick = fd - eY, point = f9.point, hitbox = f9.hitbox, target = bN.ent }
	end
	local ff = function(bc, f1)
		local X = entity.get_local_player()
		local ev = X:get_origin()
		local bR = ev:to(f1):angles()
		bc.in_forward = 1
		bc.in_back = 0
		bc.in_moveleft = 0
		bc.in_moveright = 0
		bc.in_speed = 0
		bc.forwardmove = 800
		bc.sidemove = 0
		bc.move_yaw = bR.y
	end
	local fg = { "on shot" }
	local fh = function(bc)
		if not n.misc.peek_bot:get() then
			return
		end
		if not n.misc.peek_bot.on_key:get() then
			l.rage.peek:override(nil)
			l.rage.quick_peek:override(nil)
			em.was_enabled = false
			return
		end
		l.rage.peek:override(fg)
		l.rage.quick_peek:override(true)
		local X = entity.get_local_player()
		if not em.was_enabled then
			em.origin = X:get_origin()
			em.was_enabled = true
		end
		local bN = ey()
		if not em.active then
			local a4 = fc(bN)
			if a4 then
				em.tick_time = a4.tick_time
				em.last_tick = a4.tick + globals.tickcount
				em.last_target = bN.ent
				em.last_point = a4.point
				em.last_hitbox = a4.hitbox
				em.active = true
			end
		end
		if em.last_tick - globals.tickcount < 0 or bN and em.last_target ~= bN.ent then
			em.active = false
		end
		if em.active then
			if rage.exploit:get() == 1 and n.misc.peek_bot.pr:get() then
				rage.exploit:force_teleport()
			end
			ff(bc, em.last_point)
		elseif n.misc.peek_bot.set_stand:get() and X:get_origin():dist2d(em.origin) > n.misc.peek_bot.val:get() then
			ff(bc, em.origin)
		end
	end
	local fi = { enabled_fraction = 0, origin = c(), point = c(), hitbox = c() }
	local function fj(ev, fk, fl, fm, aR)
		local fn = ev
		render.line(
			render.world_to_screen(c(fn.x - 15, fn.y - 15, fn.z)),
			render.world_to_screen(c(fn.x - 15, fn.y + 15, fn.z)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x - 15, fn.y + 15, fn.z)),
			render.world_to_screen(c(fn.x + 15, fn.y + 15, fn.z)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x + 15, fn.y + 15, fn.z)),
			render.world_to_screen(c(fn.x + 15, fn.y - 15, fn.z)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x + 15, fn.y - 15, fn.z)),
			render.world_to_screen(c(fn.x - 15, fn.y - 15, fn.z)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x - 15, fn.y - 15, fn.z + 70)),
			render.world_to_screen(c(fn.x - 15, fn.y + 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x - 15, fn.y + 15, fn.z + 70)),
			render.world_to_screen(c(fn.x + 15, fn.y + 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x + 15, fn.y + 15, fn.z + 70)),
			render.world_to_screen(c(fn.x + 15, fn.y - 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x + 15, fn.y - 15, fn.z + 70)),
			render.world_to_screen(c(fn.x - 15, fn.y - 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x - 15, fn.y - 15, fn.z)),
			render.world_to_screen(c(fn.x - 15, fn.y - 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x - 15, fn.y + 15, fn.z)),
			render.world_to_screen(c(fn.x - 15, fn.y + 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x + 15, fn.y - 15, fn.z)),
			render.world_to_screen(c(fn.x + 15, fn.y - 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
		render.line(
			render.world_to_screen(c(fn.x + 15, fn.y + 15, fn.z)),
			render.world_to_screen(c(fn.x + 15, fn.y + 15, fn.z + 70)),
			color(fk, fl, fm, aR)
		)
	end
	local render = function()
		local X = entity.get_local_player()
		if n.misc.peek_bot.on_key:get() and em.active then
			fi.enabled_fraction = utils.clamp(fi.enabled_fraction + globals.frametime * 10, 0, 1)
		else
			fi.enabled_fraction = utils.clamp(fi.enabled_fraction - globals.frametime * 10, 0, 1)
			return
		end
		fi.origin = em.origin
		fi.point = fi.point:lerp(em.last_point, globals.frametime * 20)
		fi.hitbox = fi.hitbox:lerp(em.last_hitbox, globals.frametime * 20)
		local f1 = render.world_to_screen(c(em.last_point.x, em.last_point.y, em.last_point.z))
		local ev = render.world_to_screen(c(fi.origin.x, fi.origin.y, em.origin.z))
		if f1.x and f1.y and ev.x and ev.y then
			render.line(c(f1.x, f1.y), c(ev.x, ev.y), color(255, 255, 255, 200 * fi.enabled_fraction))
		end
		fj(fi.point, 255, 255, 255, 150 * fi.enabled_fraction)
	end
	n.misc.peek_bot:set_event("render", render)
	n.misc.peek_bot:set_event("createmove", fh)
end
local fo
do
	local eS = cvar.sv_maxunlag
	local function fp(aX)
		if aX == -1 then
			l.misc.main.other.fake_latency:override()
			eS:float(tonumber(eS:string()), false)
		else
			eS:float(math.max(0.200, aX * 0.002), true)
			l.misc.main.other.fake_latency:override(aX)
		end
	end
	local function fq()
		fp(-1)
	end
	local fr = function()
		if n.misc.ping_spike() then
			fp(n.misc.ping_spike.val())
		else
			fp(-1)
		end
	end
	fr()
	events.shutdown:set(fq)
	n.misc.ping_spike.val:set_callback(fr)
	n.misc.ping_spike:set_callback(fr)
end
local fs
do
	local ft = 5
	local fu
	local fv
	local fw
	local fx
	local fy
	local fz = false
	local fA = false
	local fB = 1
	local fC = 0.0
	local fD = {
		[0] = "Generic",
		[1] = "Head",
		[2] = "Chest",
		[3] = "Stomach",
		[4] = "Chest",
		[5] = "Chest",
		[6] = "Legs",
		[7] = "Legs",
		[8] = "Head",
		[10] = "Gear",
	}
	local fE = {
		{ scale = 5, hitbox = "Stomach", vec = c(0, 0, 40) },
		{ scale = 6, hitbox = "Chest", vec = c(0, 0, 50) },
		{ scale = 3, hitbox = "Head", vec = c(0, 0, 58) },
		{ scale = 4, hitbox = "Legs", vec = c(0, 0, 20) },
	}
	local function fF(ay, aX)
		for a6 = 1, #ay do
			if ay[a6] == aX then
				return true
			end
		end
		return false
	end
	local function fG(type)
		return type >= 1 and type <= 6
	end
	local function fH()
		local ay = {}
		local fI = entity.get_player_resource()
		for a6 = 1, globals.max_players do
			local _ = entity.get(a6)
			if _ == nil then
				goto fJ
			end
			local fK = fI.m_bConnected[a6] and _:is_enemy() and _:is_dormant()
			if not fK then
				goto fJ
			end
			table.insert(ay, _)
			::fJ::
		end
		return ay
	end
	local function fL(a9, aa, fM)
		local bu = a9:to(aa):angles()
		local fN = math.rad(bu.y + 90)
		local bw = c(math.cos(fN), math.sin(fN), 0)
		local fO = bw * fM
		return { { text = "Middle", vec = aa }, { text = "Left", vec = aa + fO }, { text = "Right", vec = aa - fO } }
	end
	local function fP(_, fQ, ag, bA)
		local cU, by = utils.trace_bullet(_, fQ, ag, bA)
		if by ~= nil then
			local a2 = by.entity
			if a2 == nil then
				return 0, by
			end
			if a2:is_player() and not a2:is_enemy() then
				return 0, by
			end
		end
		return cU, by
	end
	local function fR(bc)
		l.rage.dormant:override(false)
		local X = entity.get_local_player()
		if X == nil then
			return
		end
		local bi = X:get_player_weapon()
		if bi == nil then
			return
		end
		local fS = bi:get_weapon_info()
		if fS == nil then
			return
		end
		local fT = bi:get_inaccuracy()
		if fT == nil then
			return
		end
		local dN = globals.tickcount
		local fU = X:get_eye_position()
		local fV = X:get_simulation_time().current
		local fW = bit.band(X.m_fFlags, bit.lshift(1, 0)) ~= 0
		if dN < fC then
			return
		end
		if bc.in_jump and not fW then
			return
		end
		local fX = fS.weapon_type
		if not fG(fX) or bi.m_iClip1 <= 0 then
			return false
		end
		local fY = fH()
		local eC = n.misc.dormant_aimbot.hitboxes:get()
		if dN % #fY ~= 0 then
			fB = fB + 1
		else
			fB = 1
		end
		local bN = fY[fB]
		if bN == nil then
			return
		end
		local fZ = bN:get_bbox()
		local ev = bN:get_origin()
		local f_ = bN.m_flDuckAmount
		local g0 = n.misc.dormant_aimbot.hitchance:get()
		local g1 = n.misc.dormant_aimbot.damage:get()
		if g1 == -1 then
			g1 = l.rage.min_damage:get()
		end
		if g1 > 100 then
			g1 = g1 - 100 + bN.m_iHealth
		end
		local eZ = {}
		for a6 = 1, #fE do
			local a4 = fE[a6]
			local g2 = a4.vec
			local g3 = a4.scale
			local cS = a4.hitbox
			if cS == "Head" then
				g2 = g2 - c(0, 0, 10 * f_)
			end
			if cS == "Chest" then
				g2 = g2 - c(0, 0, 4 * f_)
			end
			if #eC ~= 0 then
				if fF(eC, cS) then
					table.insert(eZ, { vec = g2, scale = g3, hitbox = cS })
				end
			else
				table.insert(eZ, 1, { vec = g2, scale = g3, hitbox = cS })
			end
		end
		local g4 = fS.is_revolver and bi.m_flNextPrimaryAttack < fV
			or math.max(X.m_flNextAttack, bi.m_flNextPrimaryAttack, bi.m_flNextSecondaryAttack) < fV
		if not g4 then
			return
		end
		local g5
		local g6
		if g0 >= math.floor(fZ.alpha * 100) + 5 then
			return
		end
		for g7 = 1, #eZ do
			local f1 = eZ[g7]
			local g8 = fL(fU, ev + f1.vec, f1.scale)
			for w = 1, #g8 do
				local g9 = g8[w]
				local ga = g9.vec
				local cU, f4 = fP(X, fU, ga, function(a2)
					return a2 == bN
				end)
				if f4 ~= nil and f4:is_visible() then
					goto fJ
				end
				if cU ~= 0 and g1 < cU then
					g5 = ga
					g6 = cU
					fu = bN
					fw = f1.hitbox
					fx = cU
					fv = g9.text
					fy = fZ.alpha
					break
				end
				::fJ::
			end
			if g5 and g6 then
				break
			end
		end
		if not g5 or not g6 then
			return
		end
		local bu = fU:to(g5):angles()
		bc.block_movement = 1
		if n.misc.dormant_aimbot.auto_scope:get() then
			local gb = not bc.in_jump and fW
			local gc = X.m_bIsScoped or X.m_bResumeZoom
			local gd = fS.weapon_type == ft
			if not gc and gd and gb then
				bc.in_attack2 = true
			end
		end
		if fT < 0.01 then
			bc.view_angles = bu
			bc.in_attack = true
			fA = true
		end
	end
	local function ge(cR)
		utils.execute_after(0.03, function()
			if entity.get(cR.userid, true) == entity.get_local_player() then
				if fA and not fz then
					events["dormant_miss"]:call({ userid = fu, aim_hitbox = fw, aim_damage = fx, aim_point = fv, accuracy = fy })
				end
				fz = false
				fA = false
				fu = nil
				fw = nil
				fx = nil
				fv = nil
				fy = nil
			end
		end)
	end
	local function gf(cR)
		local X = entity.get_local_player()
		local gg = entity.get(cR.userid, true)
		local dk = entity.get(cR.attacker, true)
		if gg == nil or dk ~= X then
			return
		end
		local fZ = gg:get_bbox()
		if fZ == nil then
			return
		end
		if gg:is_dormant() and fA == true then
			fz = true
			events["dormant_hit"]:call({
				userid = gg,
				attacker = dk,
				health = cR.health,
				armor = cR.armor,
				weapon = cR.weapon,
				dmg_health = cR.dmg_health,
				dmg_armor = cR.dmg_armor,
				hitgroup = cR.hitgroup,
				accuracy = fZ.alpha,
				hitbox = fD[cR.hitgroup],
				aim_point = fv,
				aim_hitbox = fw,
				aim_damage = fx,
			})
		end
	end
	local function fq()
		l.rage.dormant:override()
	end
	n.misc.dormant_aimbot:set_callback(function(gh)
		local aX = gh:get()
		if not aX then
			l.rage.dormant:override()
		end
		events.shutdown(fq, aX)
		events.createmove(fR, aX)
		events.weapon_fire(ge, aX)
		events.player_hurt(gf, aX)
	end, true)
end
