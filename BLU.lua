--------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
	Custom commands:
	gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.

	Treasure hunter modes:
		None - Will never equip TH gear
		Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
--]]

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()


	include('Mote-TreasureHunter')

	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}

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
	state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

	-- Additional local binds
	send_command('bind ^= gs c cycle treasuremode')

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
		waist="Chaac Belt",
	}

	sets.Kiting =
	{
		legs="Carmine Cuisses +1",
	}

	-- Actions we want to use to tag TH.
	sets.precast.Flourish1 = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter


	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs

    sets.precast.JA['Burst Affinity'] =
	{
		feet="Hashi. Basmak +1"
	}

    sets.precast.JA['Efflux'] =
	{
		legs="Hashishin Tayt +1"
	}

    sets.precast.JA['Azure Lore'] =
	{
		hands="Luh. Bazubands +1"
	}

    sets.precast.JA['Diffusion'] =
	{
		feet="Luhlaza Charuqs +1"
	}

	sets.precast.FC =
	{
		ammo="Sapience Orb",
		head="Amalric Coif", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Luhlaza Jubbah +1", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
		back="Swith Cape +1", waist="Witful Belt", legs="Psycloth Lappas", feet="Carmine Greaves"
	}

	sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC,
	{
		body="Hashishin Mintan +1"
	})

	sets.precast.FC.BlueSkill = set_combine(sets.precast.FC,
	{
		body="Hashishin Mintan +1",
		waist="Emphatikos Rope"
	})

	sets.precast.FC.Magical = sets.precast.FC.BlueSkill

	sets.precast.FC.Debuffs = sets.precast.FC.Magical

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC,
	{
		waist="Siegel Sash"
	})

	sets.precast.FC.Cures = set_combine(sets.precast.FC,
	{
		rear="Mendi. Earring",
		waist="Emphatikos Rope"
	})

	-- Weaponskill Sets

	sets.precast.WS =
	{
		ammo="Floestone",
		head="Lilitu Headpiece", neck="Fotia Gorget", lear="Brutal Earring", rear="Moonshade Earring",
		body="Herculean Vest", hands="Adhemar Wristbands", lring="Apate Ring", rring="Epona's Ring",
		back=gear.BLUCape_STP, waist="Fotia Belt", legs="Samnuha Tights", feet="Herculean Boots"
	} -- default set

	sets.precast.WS.Acc = set_combine(sets.precast.WS,
	{
		head="Dampening Tam", lear="Telos Earring",
		ring1="Cacoethic Ring +1",
		legs="Adhemar Kecks"
	})


	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS,
	{
		ammo="Falcon Eye",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan", hands="Herculean Gloves", lring="Begrudging Ring",
		back=gear.BLUCape_Crit, legs="Herculean Trousers", feet="Thereoid Greaves"
	})

	sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'],
	{
		head="Dampening Tam", lear="Telos Earring",
		legs="Samnuha Tights", feet="Herculean Boots"
	})

	sets.precast.WS['Vorpal Blade'] = set_combine(sets.precast.WS['Chant du Cygne'],
	{
		ammo="Floestone"
	})

	sets.precast.WS['Vorpal Blade'].Acc = set_combine(sets.precast.WS['Chant du Cygne'].Acc,
	{
		ammo="Floestone"
	})

	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS,
	{
		head="Carmine Mask",
		lring="Rufescent Ring",
		legs="Carmine Cuisses +1", feet="Carmine Greaves"
	})

	sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'],
	{
		ammo="Falcon Eye"
	})

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
	{
		lring="Rufescent Ring",
		feet="Carmine Greaves"
	})

	sets.precast.WS['Savage Blade'].Acc = sets.precast.WS['Savage Blade']

	sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS['Savage Blade'],
	{
		lring="Apate Ring"
	})

	sets.precast.WS['Expiacion'].Acc = sets.precast.WS['Expiacion']

	sets.precast.WS['Sanguine Blade'] =
	{
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1", neck="Fotia Gorget", lear="Friomisi Earring", rear="Moonshade Earring",
		body="Amalric Doublet", hands="Jhakri Cuffs +1", lring="Archon Ring", rring="Rufescent Ring",
		back="Cornflower Cape", waist="Fotia Belt", legs="Amalric Slops", feet="Amalric Nails"
	}

	sets.precast.WS['True Strike']= set_combine(sets.precast.WS['Savage Blade'],
	{
		lring="Ifrit Ring"
	})

	sets.precast.WS['True Strike'].Acc = sets.precast.WS['True Strike']

	sets.precast.WS['Judgment'] = sets.precast.WS['Savage Blade']

	sets.precast.WS['Judgment'].Acc = sets.precast.WS['Judgment']

	sets.precast.WS['Black Halo'] = sets.precast.WS['Savage Blade']

	sets.precast.WS['Black Halo'] = sets.precast.WS['Black Halo']

	sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']

	sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc

	sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'],
	{
		head="Jhakri Coronal +1",
		lring="Acumen Ring"
	})

	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = set_combine(sets.precast.FC,
	{
		head="Carmine Mask",
		back="Fi Follet Cape +1"
	})

	sets.midcast.ConserveMP = set_combine(sets.midcast.FastRecast,
	{
		ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
		body="Amalric Doublet",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Lengo Pants"
	})

	sets.midcast.BlueSkill = set_combine(sets.midcast.ConserveMP,
	{
		ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +1", neck="Incanter's Torque",
		body="Assim. Jubbah +1", hands="Rawhide Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Cornflower Cape", legs="Hashishin Tayt +1", feet="Luhlaza Charuqs +1"
	})

	sets.midcast.Cures =
	{
		ammo="Pemphredo Tathlum",
		head="Carmine Mask", neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Vrikodara Jupon", hands="Telchine Gloves", lring="Lebeche Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Gishdubar Sash", legs="Gyve Trousers", feet="Medium's Sabots"
	}

	sets.midcast['White Wind'] = set_combine(sets.midcast.Cures,
	{
		ammo="Pemphredo Tathlum",
		head="Luh. Keffiyeh +1", lear="Etiolation Earring", rear="Eabani Earring"
	})

	sets.midcast.Physical =
	{
		ammo="Floestone",
		head="Adhemar Bonnet", neck="Caro Necklace", lear="Telos Earring", rear="Tati Earring",
		body="Herculean Vest", hands="Adhemar Wristbands", lring="Ifrit Ring", rring="Apate Ring",
		back="Cornflower Cape", waist="Prosilio Belt +1", legs="Herculean Trousers", feet="Herculean Boots"
	}

	sets.midcast.AddEffect =
	{
		ammo="Falcon Eye",
		head="Carmine Mask", neck="Sanctity Necklace", lear="Digni. Earring", rear="Gwati Earring",
		body="Samnuha Coat", hands="Rawhide Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Cornflower Cape", waist="Eschan Stone", legs="Psycloth Lappas", feet="Jhakri Pigaches +1"
	}

	sets.midcast.Magical =
	{
		main="Nibiru Cudgel", sub="Nibiru Cudgel", ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +1", neck="Sanctity Necklace", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Amalric Doublet", hands="Amalric Gages", lring="Acumen Ring", rring="Shiva Ring",
		back="Cornflower Cape", waist="Eschan Stone", legs="Amalric Slops", feet="Amalric Nails"
	}

	sets.midcast.DarkBlue = set_combine(sets.midcast.Magical,
	{
		head="Pixie Hairpin +1",
		lring="Archon Ring"
	})

	sets.midcast.LightBlue = sets.midcast.Magical

	sets.midcast.Breath =
	{
		ammo="Psilomene",
		head="Luh. Keffiyeh +1", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Eabani Earring",
		body="Assim. Jubbah +1", hands="Telchine Gloves",
		back="Reiki Cloak", waist="Eschan Stone", legs="Hashishin Tayt +1", feet="Luhlaza Charuqs +1"
	}

	sets.midcast.Debuffs =
	{
		ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Samnuha Coat", hands="Rawhide Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Cornflower Cape", waist="Luminary Sash", legs="Psycloth Lappas", feet="Jhakri Pigaches +1"
	}

	sets.midcast.BlueDrain = set_combine(sets.midcast.Debuffs,
	{
		ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +1",
		body="Luhlaza Jubbah +1",
		legs="Hashishin Tayt +1", feet="Luhlaza Charuqs +1"
	})

	sets.midcast.Buffs = sets.midcast.ConserveMP

    sets.midcast.Duration =
	{
        ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Prolix Ring",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Refresh =
	{
		ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Evanescence Ring", rring="Prolix Ring",
        back="Grapevine Cape", waist="Gishdubar Sash", legs="Telchine Braconi", feet="Inspirited Boots"
	}

	sets.midcast.Regen =
	{
		ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Evanescence Ring", rring="Prolix Ring",
        back="Fi Follet Cape +1", waist="Luminary Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast['Enhancing Magic'] =
	{
		ammo="Pemphredo Tathlum",
		head="Carmine Mask", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Fi Follet Cape +1", waist="Olympus Sash", legs="Carmine Cuisses +1", feet="Telchine Pigaches"
	}

	sets.midcast.Statless = sets.midcast.Duration

	sets.midcast['Enfeebling Magic'] =
	{
		ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Samnuha Coat", hands="Jhakri Cuffs +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Cornflower Cape", waist="Luminary Sash", legs="Psycloth Lappas", feet="Jhakri Pigaches +1"
	}

	sets.midcast.Stun = set_combine(sets.midcast['Enfeebling Magic'],
	{
		hands="Leyline Gloves",
		waist="Witful Belt"
	})

	sets.midcast.Stoneskin = set_combine(sets.midcast.Duration,
	{
		legs="Shedir Seraweels"
	})

	sets.midcast.Aquaveil = set_combine(sets.midcast.Duration,
	{
		head="Amalric Coif",
		waist="Emphatikos Rope", legs="Shedir Seraweels"
	})

	sets.midcast.Cursna = set_combine(sets.precast.FC,
	{
		neck="Debilis Medallion",
        hands="Hieros Mittens", lring="Haoma's Ring", rring="Haoma's Ring",
        back="Oretan. Cape +1", legs="Carmine Cuisses +1"
	})

	sets.midcast.StatusRemoval = sets.midcast.FastRecast

	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'],
	{
		legs="Shedir Seraweels"
	})

	sets.midcast.BarStatus = sets.midcast.BarElement

	sets.midcast.Protect = set_combine(sets.midcast.Duration,
	{
		lring="Sheltered Ring",
	})

	sets.midcast.Shell = sets.midcast.Protect

	sets.midcast.Utsusemi = sets.midcast.FastRecast

	--------------------------------------
	-- Idle/resting/defense sets
	--------------------------------------

	-- Resting sets
	sets.resting = {}


	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle =
	{
		ammo="Staunch Tathlum",
		head="Rawhide Mask", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Amalric Doublet", hands="Serpentes Cuffs", lring="Sheltered Ring", rring="Paguroidea Ring",
		back="Shadow Mantle", waist="Fucho-no-Obi", legs="Lengo Pants", feet="Serpentes Sabots"
	}


	sets.idle.Movement = set_combine(sets.idle,
    {
        legs="Carmine Cuisses +1"
    })

	sets.idle.PDT = set_combine(sets.idle,
	{
		neck="Twilight Torque",
		body="Vrikodara Jupon", hands="Umuthi Gloves", lring="Defending Ring", rring="Vocane Ring",
		waist="Flume Belt", feet="Battlecast Gaiters"
	})

	sets.idle.MDT = set_combine(sets.idle,
	{
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Solemnity Cape", waist="Lieutenant's Sash", feet="Amalric Nails"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		legs="Carmine Cuisses +1"
	})

	sets.idle.Weak = sets.idle.PDT


	-- Defense sets

	sets.defense.PDT = set_combine(sets.idle.PDT,
	{
		head="Lithelimb Cap",
		body="Emet Harness", lring="Defending Ring", rring="Vocane Ring",
		legs="Herculean Trousers"
	})

	sets.defense.MDT = set_combine(sets.idle.MDT,
	{
		head="Dampening Tam",
		body="Amalric Doublet",
		legs="Gyve Trousers"
	})


	--------------------------------------
	-- Melee sets
	--------------------------------------

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	sets.magic_burst= set_combine(sets.midcast.Magical,
	{
		rear="Static Earring",
		body="Samnuha Coat", lring="Locus Ring", rring="Mujin Band",
		back="Seshaw Cape", feet="Jhakri Pigaches +1"
	})

	sets.buff['Burst Affinity'] = {feet="Hashi. Basmak +1"}
	sets.buff['Efflux'] = {legs="Hashishin Tayt +1"}
	sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +1"}

	sets.engaged =
	{
		main="Sequence", sub=gear.Colada_STP, ammo="Ginsen",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Petrov Ring", rring="Epona's Ring",
		back=gear.BLUCape_STP, waist="Reiki Yotai", legs="Carmine Cuisses +1", feet="Taeon Boots"
	}

	sets.engaged.LowAcc = set_combine(sets.engaged,
	{
		head="Dampening Tam", neck="Combatant's Torque",
	})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc,
	{
		ammo="Falcon Eye",
		lear="Telos Earring",
		lring="Cacoethic Ring +1",
		feet="Herculean Boots"
	})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,
	{
		rear="Cessance Earring",
		body="Herculean Vest", rring="Cacoethic Ring",
		waist="Kentarch Belt +1"
	})

	sets.engaged.HighHaste =
	{
		main="Sequence", sub=gear.Colada_STP, ammo="Ginsen",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Petrov Ring", rring="Epona's Ring",
		back=gear.BLUCape_STP, waist="Reiki Yotai", legs="Samnuha Tights", feet="Taeon Boots"
	}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste,
	{
		head="Dampening Tam", neck="Combatant's Torque"
	})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc,
	{
		ammo="Falcon Eye",
		lear="Telos Earring",
		lring="Cacoethic Ring +1"
	})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc,
	{
		rear="Cessance Earring",
		body="Herculean Vest", rring="Cacoethic Ring",
		waist="Kentarch Belt +1", legs="Carmine Cuisses +1"
	})

	sets.engaged.MaxHaste =
	{
		main="Sequence", sub=gear.Colada_STP, ammo="Ginsen",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Telos Earring", rear="Cessance Earring",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Hetairoi Ring", rring="Epona's Ring",
		back=gear.BLUCape_STP, waist="Windbuffet Belt +1", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste,
	{
		head="Dampening Tam", neck="Combatant's Torque",
	})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc,
	{
		ammo="Falcon Eye",
		lring="Cacoethic Ring +1"
	})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc,
	{
		body="Herculean Vest", rring="Cacoethic Ring",
		waist="Kentarch Belt +1", legs="Carmine Cuisses +1"
	})

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.


-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		apply_ability_bonuses(spell, action, spellMap, eventArgs)
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.

-- Called after the default aftercast handling is complete.


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
-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	determine_haste_group()
	update_active_abilities()
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

	if (buffactive.haste or buffactive.march) and buffactive['Mighty Guard'] then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.haste and (buffactive.embrava or buffactive.march == 2) then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.haste == 2 then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.haste == 1 then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 1 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	end
end

function update_active_abilities()
	state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
	state.Buff['Efflux'] = buffactive['Efflux'] or false
	state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
	if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'DarkBlue' or spellMap == 'LightBlue' or spellMap == 'Breath') then
		equip(sets.buff['Burst Affinity'])
	end
	if state.Buff.Efflux and spellMap == 'Physical' then
		equip(sets.buff['Efflux'])
	end
	if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
		equip(sets.buff['Diffusion'])
	end

	if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
	if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
	if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	set_macro_page(1, 5)
end
