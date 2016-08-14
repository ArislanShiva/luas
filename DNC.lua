-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(false, 'Ignore Targetting')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}

    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
	state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT', 'MDT', 'Evasion')
    state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

    -- Additional local binds
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^- gs c toggle selectsteptarget')
    send_command('bind !- gs c toggle usealtstep')
    send_command('bind ^` input /ja "Chocobo Jig" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^=')
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Climactic Flourish'] =
	{
		head="Maculele Tiara +1"
	}

	--------------------------------------
	-- Precast sets
	--------------------------------------

    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] =
	{
		body="Horos Casaque +1"
	}

    sets.precast.JA['Trance'] =
	{
		head="Horos Tiara +1"
	}


    -- Waltz set (chr and vit)
    sets.precast.Waltz =
	{
        head="Horos Tiara +1", lear="Roundel Earring",
        body="Maxixi Casaque +1",
        back="Toetapper Mantle", waist="Fotia Belt", feet="Maxixi Shoes +1"
	}


    sets.precast.Samba =
	{
		head="Maxixi Tiara +1",
		back="Senuna's Mantle"
	}

    sets.precast.Jig =
	{
		legs="Horos Tights +1", feet="Maxixi Shoes +1"
	}

    sets.precast.Step =
	{
		ammo="Falcon Eye",
		head="Dampening Tam", neck="Combatant's Torque", lear="Telos Earring", rear="Digni. Earring",
		body="Adhemar Jacket", hands="Meg. Gloves +1", lring="Cacoethic Ring +1", rring="Cacoethic Ring",
		back="Toetapper Mantle", waist="Eschan Stone", legs="Adhemar Kecks", feet="Meg. Jam. +1"
	}

    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] =
	{
		ammo="Pemphredo Tathlum",
		head="Dampening Tam", neck="Sanctity Necklace", lear="Digni. Earring",ear2="Gwati Earring",
        body="Horos Casaque +1", hands="Leyline Gloves", lring="Stikini Ring", rring="Stikini Ring",
        back="Toetapper Mantle", waist="Eschan Stone", legs="Adhemar Kecks", feet="Herculean Boots"
	}
    sets.precast.Flourish1['Desperate Flourish'] =
	{
		ammo="Falcon Eye",
		head="Dampening Tam", neck="Combatant's Torque", lear="Telos Earring", rear="Digni. Earring",
		body="Adhemar Jacket", hands="Meg. Gloves +1", lring="Cacoethic Ring +1", rring="Cacoethic Ring",
		back="Toetapper Mantle", waist="Eschan Stone", legs="Adhemar Kecks", feet="Meg. Jam. +1"
	}

    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] =
	{
		hands="Macu. Bangles +1",
		back="Toetapper Mantle"
	}

    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Climactic Flourish'] =
	{
		head="Maculele Tiara +1"
	}

    -- Fast cast sets for spells

    sets.precast.FC =
	{
		ammo="Sapience Orb",
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Lebeche Ring", rring="Prolix Ring",
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
		back="Senuna's Mantle", waist="Fotia Belt", legs="Samnuha Tights", feet="Herculean Boots"
	} -- default set

	sets.precast.WS.Acc = set_combine(sets.precast.WS,
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks", feet="Meg. Jam. +1"
	})


	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS,
	{
		ammo="Ginsen",
		head="Meghanada Visor +1",
		lring="Garuda Ring", feet="Herculean Boots"
	})

	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'],
	{
		lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks", feet="Meg. Jam. +1"
	})

	sets.precast.WS['Exenterator'].CF = set_combine(sets.precast.WS['Exenterator'],
	{
		head="Maculele Tiara +1",
		body="Meg. Cuirie +1", lring="Begrudging Ring",
		legs="Herculean Trousers"
	})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,
	{
		ammo="Falcon Eye",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan", hands="Herculean Gloves", lring="Begrudging Ring",
		legs="Herculean Trousers"
	})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'],
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks", feet="Meg. Jam. +1"
	})

	sets.precast.WS['Evisceration'].CF = set_combine(sets.precast.WS['Evisceration'],
	{
		head="Maculele Tiara +1"
	})

	sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS,
	{
		ammo="Floestone",
		head="Meghanada Visor +1"
	})

	sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS['Pyrrhic Kleos'],
	{
		lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks", feet="Meg. Jam. +1"
	})

	sets.precast.WS['Pyrrhic Kleos'].CF = set_combine(sets.precast.WS['Pyrrhic Kleos'],
	{
		head="Maculele Tiara +1",
		body="Meg. Cuirie +1", lring="Begrudging Ring",
		legs="Herculean Trousers"
	})


	sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS,
	{
		lear="Dawn Earring",
		rring="Apate Ring"
	})

	sets.precast.WS['Rudra\'s Storm'].Acc = sets.precast.WS["Rudra's Storm"]

	sets.precast.WS['Rudra\'s Storm'].CF = set_combine(sets.precast.WS["Rudra's Storm"],
	{
		head="Maculele Tiara +1",
		body="Meg. Cuirie +1", lring="Ramuh Ring", rring="Begrudging Ring",
		legs="Herculean Trousers"
	})

	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS,
	{
		ammo="Pemphredo Tathlum",
		head="Herculean Helm", lear="Friomisi Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Acumen Ring", rring="Garuda Ring",
		back="Seshaw Cape", legs="Herculean Trousers", feet="Herculean Boots"
	})

	sets.precast.WS['Cyclone'] = sets.precast.WS['Aeolian Edge']

	sets.precast.WS['Gust Slash'] = sets.precast.WS['Aeolian Edge']

	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = sets.precast.FC

	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.FastRecast

	--------------------------------------
	-- Idle/resting/defense sets
	--------------------------------------

	sets.idle =
	{
		ammo="Staunch Tathlum",
		head="Dampening Tam", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Meg. Cuirie +1", hands="Umuthi Gloves", lring="Sheltered Ring", rring="Paguroidea Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Meg. Chausses +1", feet="Tandava Crackows"
	}

	sets.idle.PDT = set_combine (sets.idle,
	{
		head="Lithelimb Cap", neck="Twilight Torque",
		body="Meg. Cuirie +1", lring="Defending Ring", rring="Vocane Ring",
		feet="Herculean Boots"
	})

	sets.idle.MDT = set_combine (sets.idle,
	{
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Solemnity Cape", waist="Lieutenant's Sash", legs="Adhemar Kecks"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		feet="Tandava Crackows"
	})

	sets.idle.Weak = sets.idle.PDT


	-- Defense sets

	sets.defense.PDT =  sets.idle.PDT

	sets.defense.MDT = sets.idle.MDT


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
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Senuna's Mantle", waist="Reiki Yotai", legs="Samnuha Tights", feet="Taeon Boots"
	}

	sets.engaged.LowAcc = set_combine(sets.engaged,
	{
		ammo="Falcon Eye",
		head="Dampening Tam", neck="Combatant's Torque", lear="Telos Earring",
	})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc,
	{
		lring="Cacoethic Ring +1",
		waist="Kentarch Belt +1", legs="Adhemar Kecks"
	})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,
	{
		head="Meghanada Visor +1", rear="Digni. Earring",
		hands="Meg. Gloves +1", rring="Cacoethic Ring",
		feet="Meg. Jam. +1"
	})

	sets.engaged.HighHaste =
	{
		main="Aeneas", sub="Skinflayer", ammo="Ginsen",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Senuna's Mantle", waist="Reiki Yotai", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste,
	{
		ammo="Falcon Eye",
		head="Dampening Tam", neck="Combatant's Torque", lear="Telos Earring",
	})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc,
	{
		lring="Cacoethic Ring +1",
		waist="Kentarch Belt +1", legs="Adhemar Kecks"
	})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc,
	{
		head="Meghanada Visor +1", rear="Digni. Earring",
		hands="Meg. Gloves +1", rring="Cacoethic Ring",
		feet="Meg. Jam. +1"
	})

	sets.engaged.MaxHaste =
	{
		main="Aeneas", sub="Skinflayer", ammo="Ginsen",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Brutal Earring", rear="Cessance Earring",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Senuna's Mantle", waist="Windbuffet Belt +1", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste,
	{
		ammo="Falcon Eye",
		head="Dampening Tam", neck="Combatant's Torque", lear="Telos Earring",
	})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc,
	{
		lring="Cacoethic Ring +1",
		waist="Kentarch Belt +1", legs="Adhemar Kecks"
	})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc,
	{
		head="Meghanada Visor +1", rear="Digni. Earring",
		hands="Meg. Gloves +1", rring="Cacoethic Ring",
		feet="Meg. Jam. +1"
	})


end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
----------------------------------
---------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba','mighty guard'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif buff == 'Climactic Flourish' then
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

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
	local wsmode

	if state.Buff['Climactic Flourish'] then
		wsmode = 'CF'
	end

	return wsmode
end

function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end

    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
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

    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', ['..state.MainStep.current

    if state.UseAltStep.value == true then
        msg = msg .. '/'..state.AltStep.current
    end

    msg = msg .. ']'

    if state.SelectStepTarget.value == true then
        steps = steps..' (Targetted)'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end

        send_command('@input /ja "'..doStep..'" <t>')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()

    classes.CustomMeleeGroups:clear()

    if buffactive.embrava and buffactive.haste and (buffactive.march or buffactive['Mighty Guard']) then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba'] or buffactive['Mighty Guard']) then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 16)
end
