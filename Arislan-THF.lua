-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
	Custom commands:

	gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
	
	Treasure hunter modes:
		None - Will never equip TH gear
		Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
		SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
		Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Trick Attack'] = buffactive['trick attack'] or false
	state.Buff['Feint'] = buffactive['feint'] or false
	
	include('Mote-TreasureHunter')

	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}

	state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.HybridMode:options('Normal')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.IdleMode:options('Normal', 'DT')

	state.CP = M(false, "Capacity Points Mode")

	-- Additional local binds
	send_command('bind ^` gs c cycle treasuremode')
	send_command('bind !` input /ja "Flee" <me>')
	if player.sub_job == 'DNC' then
		send_command('bind ^, input /ja "Spectral Jig" <me>')
		send_command('unbind ^.')
	else
		send_command('bind ^, input /item "Silent Oil" <me>')
		send_command('bind ^. input /item "Prism Powder" <me>')
	end
	send_command('bind @h gs c cycle HasteMode')
	send_command('bind @c gs c toggle CP')

	select_default_macro_book()
	set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^,')
	send_command('unbind @h')
	send_command('unbind @c')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Special sets (required by rules)
	--------------------------------------

	sets.TreasureHunter = {
		hands="Plunderer's Armlets +1",
		feet="Skulk. Poulaines +1",
		waist="Chaac Belt",
		}
		
	sets.ExtraRegen = {}
	
	sets.Kiting = {
		--feet="Jute Boots +1",
		feet="Skd. Jambeaux +1",
		}

	sets.buff['Sneak Attack'] = {
		ammo="Yetshila",
		head="Dampening Tam",
		body="Adhemar Jacket", 
		hands=gear.Adhemar_TP_hands,
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",
		neck="Caro Necklace",
		ear2="Mache Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Toutatis's Cape",
		}

	sets.buff['Trick Attack'] = {
		ammo="Yetshila",
		head="Pillager's Bonnet +1",
		body="Adhemar Jacket", 
		hands="Pillager's Armlets +1",
		legs="Pillager's Culottes +1",
		feet="Meg. Jam. +1",
		neck="Marked Gorget",
		ear2="Infused Earring",
		ring2="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back="Toutatis's Cape",
		waist="Svelt. Gouriz +1",
		}

	-- Actions we want to use to tag TH.
	sets.precast.Step = sets.TreasureHunter
	sets.precast.Flourish1 = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter


	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	--sets.precast.JA['Collaborator'] = {head="Raider's Bonnet +1"}
	--sets.precast.JA['Accomplice'] = {head="Raider's Bonnet +1"}
	--sets.precast.JA['Flee'] = {feet="Rog. Poulaines +1"}
	sets.precast.JA['Hide'] = {body="Pillager's Vest +1"}
	--sets.precast.JA['Conspirator'] = {body="Raider's Vest +1"}

	sets.precast.JA['Steal'] = {
		ammo="Barathrum",
		--head="Asn. Bonnet +2",
		hands="Pillager's Armlets +1",
		legs="Pillager's Culottes +1",
		}

	sets.precast.JA['Despoil'] = {
		ammo="Barathrum",
		--legs="Raider's Culottes +1",
		feet="Skulk. Poulaines +1",
		}

	sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
	sets.precast.JA['Feint'] = {legs="Plunderer's Culottes +1"}
	sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

	sets.precast.Waltz = {
		body="Passion Jacket",
		hands="Slither Gloves +1",
		neck="Phalaina Locket",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		waist="Gishdubar Sash",
		}

	sets.precast.Waltz['Healing Waltz'] = {}

	sets.precast.FC = {
		ammo="Sapience Orb",
		head=gear.Herc_MAB_head, --7
		body=gear.Taeon_FC_body, --8
		hands="Leyline Gloves", --7
		legs="Rawhide Trousers", --5
		feet=gear.Herc_MAB_feet, --2
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Enchntr. Earring +1", --2
		ring2="Weather. Ring", --5(3)
		waist="Ninurta's Sash",
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		body="Passion Jacket",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})

	-- Weaponskill Sets

	sets.precast.WS = {
		ammo="Focal Orb",
		head="Lilitu Headpiece",
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +1",
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ilabrat Ring",
		back="Toutatis's Cape",
		waist="Fotia Belt",
		} -- default set

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		legs="Meg. Chausses +1",
		ear2="Telos Earring",
		})

	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head="Adhemar Bonnet",
		legs="Meg. Chausses +1",
		feet="Meg. Jam. +1",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Garuda Ring +1",
		})

	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan",
		hands="Mummu Wrists +1",
		legs="Samnuha Tights", 
		feet=gear.Herc_TA_feet,
		ear1="Mache Earring",
		ear2="Brutal Earring",
		ring1="Begrudging Ring",
		ring2="Epona's Ring",
		})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		hands="Meg. Gloves +1",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		})

	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
		ammo="Expeditious Pinion",
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		})

	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {
		ammo="Falcon Eye",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		})

	sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]

	sets.precast.WS['Mandalic Stab'].Acc = sets.precast.WS["Rudra's Storm"].Acc

	sets.precast.WS['Shark Bite'] = sets.precast.WS["Rudra's Storm"]

	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
		ammo="Seeth. Bomblet +1",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Baetyl Pendant",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back="Argocham. Mantle",
		waist="Eschan Stone",
		})

	sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)


	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		ammo="Impatiens", --10
		ear1="Halasz Earring", --5
		ring1="Evanescence Ring", --5
		waist="Ninurta's Sash", --6
		}
		
	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

	--------------------------------------
	-- Idle/resting/defense sets
	--------------------------------------

	-- Resting sets
	sets.resting = {}


	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Meg. Cuirie +1",
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
--		feet="Jute Boots +1",
		feet="Skd. Jambeaux +1",
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt +1",
		}

	sets.idle.DT = set_combine (sets.idle, {
		ammo="Staunch Tathlum", --2/2
		head=gear.Herc_DT_head, --3/3
		body="Meg. Cuirie +1", --7/0
		hands=gear.Herc_DT_hands, --6/4
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		})

	sets.idle.Town = set_combine(sets.idle, {
		body="Adhemar Jacket",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Toutatis's Cape",
		waist="Windbuffet Belt +1",
		})

	sets.idle.Weak = sets.idle.DT


	-- Defense sets

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT


	--------------------------------------
	-- Melee sets
	--------------------------------------

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- * THF Native DW Trait: 25% DW
	
	-- No Magic Haste (74% DW to cap)
	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", -- 5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Erudit. Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Canny Cape", --4
		waist="Patentia Sash", --5
		} -- 32%

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		ring2="Ilabrat Ring",
		back="Toutatis's Cape",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP = set_combine(sets.engaged, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 15% Magic Haste (67% DW to cap)
	sets.engaged.LowHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", -- 5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Erudit. Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Canny Cape", --4
		waist="Patentia Sash", --5
		} -- 32%

	sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		ring2="Ilabrat Ring",
		back="Toutatis's Cape",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 30% Magic Haste (56% DW to cap)
	sets.engaged.MidHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", -- 5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Erudit. Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Canny Cape", --4
		waist="Patentia Sash", --5
		} -- 32%

	sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		ring1="Chirich Ring",
		})

	sets.engaged.MidHaste.MidAcc = set_combine(sets.engaged.LowAcc.MidHaste, {
		feet=gear.Herc_TA_feet,
		ear1="Cessance Earring",
		ring2="Ilabrat Ring",
		back="Toutatis's Cape",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidHaste.MidAcc, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 35% Magic Haste (51% DW to cap)
	sets.engaged.HighHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", -- 5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Erudit. Necklace",
		ear1="Eabani Earring", --4
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Toutatis's Cape",
		waist="Patentia Sash", --5
		} -- 23%

	sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
		ammo="Falcon Eye",
		ear1="Cessance Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 47% Magic Haste (36% DW to cap)
	sets.engaged.MaxHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Erudit. Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Toutatis's Cape",
		waist="Windbuffet Belt +1",
		} -- 9%

	sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
		ammo="Falcon Eye",
		ear1="Cessance Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})
	
	-- Custom buff sets
	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

	sets.Reive = {neck="Ygnas's Resolve +1"}
	sets.CP = {back="Mecisto. Mantle"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
		equip(sets.TreasureHunter)
	elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
	end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
		equip(sets.TreasureHunter)
	end

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	-- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
	if spell.type == 'WeaponSkill' and not spell.interrupted then
		state.Buff['Sneak Attack'] = false
		state.Buff['Trick Attack'] = false
		state.Buff['Feint'] = false
	end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- If Feint is active, put that gear set on on top of regular gear.
	-- This includes overlaying SATA gear.
	check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end

	if buffactive['Reive Mark'] then
		equip(sets.Reive)
		disable('neck')
	else
		enable('neck')
	end

	if buff == "doom" then
		if gain then		   
			equip(sets.buff.Doom)
			send_command('@input /p Doomed.')
			disable('ring1','ring2','waist')
		else
			enable('ring1','ring2','waist')
			handle_equipping_gear(player.status)
		end
	end

end

function job_status_change(new_status, old_status)
	if new_status == 'Engaged' then
		determine_haste_group()
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
	local wsmode

	if state.Buff['Sneak Attack'] then
		wsmode = 'SA'
	end
	if state.Buff['Trick Attack'] then
		wsmode = (wsmode or '') .. 'TA'
	end

	return wsmode
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
	-- Check that ranged slot is locked, if necessary
	check_range_lock()

	-- Check for SATA when equipping gear.  If either is active, equip
	-- that gear specifically, and block equipping default gear.
	check_buff('Sneak Attack', eventArgs)
	check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end

	return idleSet
end


function customize_melee_set(meleeSet)
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end

	return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = '[ Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ' ][ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
	end
	
	if state.Kiting.value then
		msg = msg .. ' ][ Kiting Mode: ON'
	end
	
	msg = msg .. ' ][ TH: ' .. state.TreasureMode.value
	
	msg = msg .. ' ]'

	add_to_chat(060, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()

	-- Gearswap can't detect the difference between Haste I and Haste II
	-- so use winkey-H to manually set Haste spell level.

	-- Haste (buffactive[33]) - 15%
	-- Haste II (buffactive[33]) - 30%
	-- Haste Samba - 5%/10%
	-- Victory March +0/+3/+4/+5	9.4%/14%/15.6%/17.1%
	-- Advancing March +0/+3/+4/+5  6.3%/10.9%/12.5%/14% 
	-- Embrava - 30%
	-- Mighty Guard (buffactive[604]) - 15%
	-- Geo-Haste (buffactive[580]) - 40%

	classes.CustomMeleeGroups:clear()

	if state.HasteMode.value == 'Haste II' then
		if(((buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604])) or
			(buffactive[33] and (buffactive[580] or buffactive.embrava)) or
			(buffactive.march == 2 and buffactive[604]) or buffactive.march == 3) then
			add_to_chat(122, 'Magic Haste Level: 43%')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba']) then
			add_to_chat(122, 'Magic Haste Level: 35%')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif ((buffactive[580] or buffactive[33] or buffactive.march == 2) or
			(buffactive.march == 1 and buffactive[604])) then
			add_to_chat(122, 'Magic Haste Level: 30%')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif (buffactive.march == 1 or buffactive[604]) then
			add_to_chat(122, 'Magic Haste Level: 15%')
			classes.CustomMeleeGroups:append('LowHaste')
		end
	else
		if (buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or
			(buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604])) or
			(buffactive.march == 2 and (buffactive[33] or buffactive[604])) or
			(buffactive[33] and buffactive[604] and buffactive.march ) or buffactive.march == 3 then
			add_to_chat(122, 'Magic Haste Level: 43%')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or
			(buffactive.march == 2 and buffactive['haste samba']) or
			(buffactive[580] and buffactive['haste samba'] ) then
			add_to_chat(122, 'Magic Haste Level: 35%')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif (buffactive.march == 2 ) or
			((buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
			(buffactive[580] ) or  -- geo haste
			(buffactive[33] and buffactive[604]) then
			add_to_chat(122, 'Magic Haste Level: 30%')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
			add_to_chat(122, 'Magic Haste Level: 15%')
			classes.CustomMeleeGroups:append('LowHaste')
		end
	end
end


-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
	if state.Buff[buff_name] then
		equip(sets.buff[buff_name] or {})
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
		eventArgs.handled = true
	end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
	if category == 2 or -- any ranged attack
		--category == 4 or -- any magic action
		(category == 3 and param == 30) or -- Aeolian Edge
		(category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
		(category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
		then return true
	end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
	if player.equipment.range ~= 'empty' then
		disable('range', 'ammo')
	else
		enable('range', 'ammo')
	end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 1)
	elseif player.sub_job == 'WAR' then
		set_macro_page(2, 1)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 1)
	else
		set_macro_page(1, 1)
	end
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 1')
end