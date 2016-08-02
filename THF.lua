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

	determine_haste_group()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.HybridMode:options('Normal')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.PhysicalDefenseMode:options('PDT', 'Evasion', 'MDT')

	-- Additional local binds
	send_command('bind ^= gs c cycle treasuremode')
	send_command('bind !- gs c cycle targetmode')

	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^=')
	send_command('unbind !-')
	send_command('unbind ^,')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Special sets (required by rules)
	--------------------------------------

	sets.TreasureHunter = 
	{
		head="Skulker's Bonnet +1",
		hands="Plun. Armlets +1",
		feet="Skulk. Poulaines +1"
	}
		
	sets.ExtraRegen = {}
	
	sets.Kiting = 
	{
		feet="Jute Boots +1",
	}

	sets.buff['Sneak Attack'] = 
	{
		ammo="Yetshila",
		head="Adhemar Bonnet", neck="Caro Necklace", lear="Dawn Earring", rear="Pixie Earring",
		body="Abnoba Kaftan", hands="Herculean Gloves", lring="Ramuh Ring", rring="Apate Ring",
		back="Toutatis's Cape", waist="Chaac Belt", legs="Herculean Trousers", feet="Herculean Boots"
	}

	sets.buff['Trick Attack'] = 
	{
		ammo="Yetshila",
		head="Adhemar Bonnet", neck="Pentalagus Charm", lear="Dawn Earring", rear="Infused Earring",
		body="Adhemar Jacket", hands="Pill. Armlets +1", lring="Garuda Ring", rring="Apate Ring",
		back="Canny Cape", waist="Chaac Belt", legs="Meg. Chausses +1", feet="Meg. Jam. +1"
	}

	-- Actions we want to use to tag TH.
	sets.precast.Step = sets.TreasureHunter
	sets.precast.Flourish1 = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter


	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Collaborator'] = 
	{
		head="Skulker's Bonnet +1"
	}

	sets.precast.JA['Accomplice'] = 
	{
		head="Skulker's Bonnet +1"
	}

	sets.precast.JA['Flee'] = 
	{
		feet="Pill. Poulaines +1"
	}
	sets.precast.JA['Steal'] = 
	{
		head="Adhemar Bonnet", neck="Pentalagus Charm", lear="Dawn Earring", rear="Infused Earring",
		body="Adhemar Jacket", hands="Pill. Armlets +1", lring="Garuda Ring", rring="Apate Ring",
		back="Canny Cape", waist="Chaac Belt", legs="Pill. Culottes +1", feet="Pill. Poulaines +1"
	}

	sets.precast.JA['Despoil'] = 
	{
		feet="Skulk. Poulaines +1"
	}

	sets.precast.JA['Perfect Dodge'] = 
	{
		hands="Plun. Armlets +1"
	}

	sets.precast.JA['Feint'] = 
	{
		legs="Plunderer's Culottes +1",
	}

	sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	
	sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

	sets.precast.Waltz = 
	{
		body="Passion Jacket",
		feet="Rawhide Boots"
	}

	sets.precast.Waltz['Healing Waltz'] = {}

	sets.precast.FC = 
	{
		ammo="Staunch Tathlum",
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Defending Ring", rring="Prolix Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Herculean Trousers", feet="Herculean Boots"
	}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, 
	{
		body="Passion Jacket"
	})

	-- Weaponskill Sets

	sets.precast.WS = 
	{
		ammo="Falcon Eye",
		head="Lilitu Headpiece", neck="Fotia Gorget", lear="Brutal Earring", rear="Moonshade Earring",
		body="Adhemar Jacket", hands="Meg. Gloves +1", lring="Ramuh Ring", rring="Epona's Ring",
		back="Toutatis's Cape", waist="Fotia Belt", legs="Samnuha Tights", feet="Herculean Boots"
	} -- default set

	sets.precast.WS.Acc = set_combine(sets.precast.WS, 
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks"
	})
	
	sets.precast.WS.SA = set_combine(sets.precast.WS,
	{
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Meg. Cuirie +1", lring="Begrudging Ring",
		legs="Herculean Trousers"
	})
	
	sets.precast.WS.TA = set_combine(sets.precast.WS.SA,
	{
		feet="Meg. Jam. +1"
	})


	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, 
	{
		ammo="Ginsen",
		hands="Adhemar Wristbands", lring="Garuda Ring"
	})

	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], 
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks"
	})
	
	sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'], 
	{
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Meg. Cuirie +1", lring="Begrudging Ring",
		legs="Herculean Trousers"
	})
	
	sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].SA, 
	{
		feet="Meg. Jam. +1"
	})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, 
	{
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan", hands="Herculean Gloves", lring="Begrudging Ring",
		legs="Herculean Trousers"
	})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], 
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks"
	})
	
	sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'], 
	{
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan",
		legs="Herculean Trousers"
	})
	
	sets.precast.WS['Evisceration'].TA = sets.precast.WS['Evisceration'].SA

	sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, 
	{
		lear="Dawn Earring",
		body="Adhemar Jacket", rring="Apate Ring",
		legs="Herculean Trousers"
	})

	sets.precast.WS['Rudra\'s Storm'].Acc = sets.precast.WS["Rudra's Storm"] 
	
	sets.precast.WS['Rudra\'s Storm'].SA = set_combine(sets.precast.WS["Rudra's Storm"], 
	{
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Meg. Cuirie +1", rring="Begrudging Ring",
		legs="Herculean Trousers"
	})
	
	sets.precast.WS['Rudra\'s Storm'].TA = sets.precast.WS["Rudra's Storm"].SA

	sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]

	sets.precast.WS['Mandalic Stab'].Acc = sets.precast.WS["Rudra's Storm"].Acc
	
	sets.precast.WS['Mandalic Stab'].SA = sets.precast.WS["Rudra's Storm"].SA
	
	sets.precast.WS['Mandalic Stab'].TA = sets.precast.WS["Rudra's Storm"].TA

	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, 
	{
		ammo="Pemphredo Tathlum",
		head="Herculean Helm", lear="Friomisi Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Acumen Ring", rring="Garuda Ring",
		back="Seshaw Cape", legs="Herculean Trousers", feet="Herculean Boots"
	})

	sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)
	
	sets.precast.WS['Cyclone'] = sets.precast.WS['Aeolian Edge']
	
	sets.precast.WS['Gust Slash'] = sets.precast.WS['Aeolian Edge']
    
	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = 
	{
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Defending Ring", rring="Prolix Ring",
	}

	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.FastRecast


	--------------------------------------
	-- Idle/resting/defense sets
	--------------------------------------

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = 
	{
		ammo="Staunch Tathlum",
		head="Dampening Tam", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Meg. Cuirie +1", hands="Umuthi Gloves", lring="Sheltered Ring", rring="Paguroidea Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Meg. Chausses +1", feet="Jute Boots +1"
	}

	sets.idle.PDT = set_combine (sets.idle, 
	{
		ammo="Staunch Tathlum",
		head="Meghanada Visor +1", neck="Twilight Torque", 
		body="Meg. Cuirie +1", lring="Defending Ring", rring="Vocane Ring",
		feet="Herculean Boots"
	})

	sets.idle.MDT = set_combine (sets.idle, 
	{
		ammo="Staunch Tathlum",
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Solemnity Cape", legs="Feast Hose"
	})

	sets.idle.Town = set_combine(sets.idle, 
	{
		body="Councilor's Garb"
	})

	sets.idle.Weak = sets.idle.PDT


	-- Defense sets
	
	sets.defense.PDT = 
	{
		ammo="Staunch Tathlum",
		head="Meghanada Visor +1", neck="Twilight Torque", 
		body="Meg. Cuirie +1", hands="Umuthi Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Meg. Chausses +1", feet="Herculean Boots"
	}
	
	sets.defense.Evasion = 
	{
		ammo="Staunch Tathlum",
		head="Herculean Helm", neck="Combatant's Torque", lear="Eabani Earring", rear="Infused Earring",
		body="Emet Harness", hands="Herculean Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Canny Cape", waist="Flume Belt", legs="Herculean Trousers", feet="Skulk. Poulaines +1"
	}

	sets.defense.MDT = 
	{
		ammo="Staunch Tathlum",
		head="Dampening Tam", neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Solemnity Cape", legs="Feast Hose", feet="Jute Boots +1"
	}


	--------------------------------------
	-- Melee sets
	--------------------------------------

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	sets.engaged = 
	{
		main="Aeneas", sub="Skinflayer", ammo="Ginsen",
		head="Adhemar Bonnet", neck="Clotharius Torque", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Floral Gauntlets", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Canny Cape", waist="Reiki Yotai", legs="Samnuha Tights", feet="Taeon Boots"
	}

	sets.engaged.LowAcc = set_combine(sets.engaged, 
	{
		head="Dampening Tam", neck="Combatant's Torque",
		lring="Cacoethic Ring +1",
		back="Toutatis's Cape"
	})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, 
	{
		ammo="Falcon Eye",
		lear="Telos Earring",
		hands="Meg. Gloves +1",
		legs="Adhemar Kecks"
	})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, 
	{
		head="Meghanada Visor +1", rear="Digni. Earring",
		rring="Cacoethic Ring",
		waist="Kentarch Belt +1", feet="Meg. Jam. +1"
	})

	sets.engaged.HighHaste = 
	{
		main="Aeneas", sub="Skinflayer", ammo="Ginsen",
		head="Adhemar Bonnet", neck="Clotharius Torque", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Floral Gauntlets", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Canny Cape", waist="Reiki Yotai", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, 
	{
		head="Dampening Tam", neck="Combatant's Torque",
		lring="Cacoethic Ring +1",
		back="Toutatis's Cape"
	})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, 
	{
		ammo="Falcon Eye",
		lear="Telos Earring",
		hands="Meg. Gloves +1",
		legs="Adhemar Kecks"
	})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, 
	{
		head="Meghanada Visor +1", rear="Digni. Earring",
		rring="Cacoethic Ring",
		waist="Kentarch Belt +1", feet="Meg. Jam. +1"
	})

	sets.engaged.MaxHaste = 
	{
		main="Aeneas", sub="Skinflayer", ammo="Ginsen",
		head="Adhemar Bonnet", neck="Clotharius Torque", lear="Brutal Earring", rear="Cessance Earring",
		body="Adhemar Jacket", hands="Floral Gauntlets", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Toutatis's Cape", waist="Windbuffet Belt +1", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste, 
	{
		head="Dampening Tam", neck="Combatant's Torque",
		lring="Cacoethic Ring +1"
	})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, 
	{
		ammo="Falcon Eye",
		lear="Telos Earring",
		hands="Meg. Gloves +1",
		legs="Adhemar Kecks"
	})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, 
	{
		head="Meghanada Visor +1", rear="Digni. Earring",
		rring="Cacoethic Ring",
		waist="Kentarch Belt +1", feet="Meg. Jam. +1"
	})

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
	if S{'haste','march','embrava','haste samba', 'mighty guard'}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	elseif state.Buff['Sneak Attack'] == false or state.Buff['Trick Attack'] == false then
		handle_equipping_gear(player.status)
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
	if player.hpp < 80 then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
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
	local msg = 'Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ', WS: ' .. state.WeaponskillMode.value
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
	end
	
	if state.Kiting.value == true then
		msg = msg .. ', Kiting'
	end

	if state.PCTargetMode.value ~= 'default' then
		msg = msg .. ', Target PC: '..state.PCTargetMode.value
	end

	if state.SelectNPCTargets.value == true then
		msg = msg .. ', Target NPCs'
	end
	
	msg = msg .. ', TH: ' .. state.TreasureMode.value

	add_to_chat(122, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()

	classes.CustomMeleeGroups:clear()
	
	if buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['Mighty Guard']) then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.embrava or buffactive.haste or buffactive.march then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive['Mighty Guard'] then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 1 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
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
		set_macro_page(1, 15)
	elseif player.sub_job == 'WAR' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 15)
	else
		set_macro_page(1, 15)
	end
end