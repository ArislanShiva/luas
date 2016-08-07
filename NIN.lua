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
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'MDT', 'Evasion')
    state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

    gear.MovementFeet = {name="Danzo Sune-ate"}
    gear.DayFeet = "Danzo Sune-ate"
    gear.NightFeet = "Hachiya Kyahan"

    select_movement_feet()
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs

    sets.precast.JA['Futae'] =
	{
		feet="Hattori Tekko +1"
	}

    -- Waltz set (chr and vit)
	sets.precast.Waltz =
	{
		body="Passion Jacket",
		feet="Rawhide Boots"
	}

    -- Fast cast sets for spells
	sets.precast.FC =
	{
		ammo="Staunch Tathlum",
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
		back="Andartia's Mantle", waist="Flume Belt", legs="Gyve Trousers", feet="Hattori Kyahan +1"
	}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC,
	{
		body="Passion Jacket"
	})

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
  	sets.precast.WS =
	{
		ammo="Floestone",
		head="Lilitu Headpiece", neck="Fotia Gorget", lear="Brutal Earring", rear="Moonshade Earring",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Apate Ring", rring="Epona's Ring",
		back="Yokaze Mantle", waist="Fotia Belt", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.precast.WS.Acc = set_combine(sets.precast.WS,
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks", feet="Hiza. Sune-Ate +1"
	})

	sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS,
	{
		ammo="Yetshila",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan", hands="Herculean Gloves", lear="Garuda Ring",
		legs="Herculean Trousers"
	})

	sets.precast.WS['Blade: Hi'].Acc = set_combine(sets.precast.WS['Blade Hi'],
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks", feet="Hiza. Sune-Ate +1"
	})

	sets.precast.WS['Blade: Jin'] = sets.precast.WS['Blade: Hi']

	sets.precast.WS['Blade: Jin'].Acc = sets.precast.WS['Blade: Hi'].Accc

	sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS,
	{
		body="Hiza. Haramaki +1", lring="Ifrit Ring",
		feet="Hiza. Sune-Ate +1"
	})

	sets.precast.WS['Blade: Kamu'].Acc = set_combine(sets.precast.WS['Blade: Kamu'],
	{
		head="Dampening Tam", lear="Telos Earring",
		lring="Cacoethic Ring +1",
		legs="Adhemar Kecks"
	})

	sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS,
	{
		ammo="Pemphredo Tathlum",
		head="Herculean Helm", lear="Friomisi Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Acumen Ring", rring="Shiva Ring",
		back="Seshaw Cape", legs="Gyve Trousers", feet="Herculean Boots"
	})

	sets.precast.WS['Blade: Ei'] = sets.precast.WS['Blade: Yu']

	sets.precast.WS['Blade: Teki'] = sets.precast.WS['Blade: Yu']

	sets.precast.WS['Evisceration'] = sets.precast.WS['Blade: Hi']

	sets.precast.WS['Evisceration'].Acc = sets.precast.WS['Blade: Hi'].Acc

	sets.precast.WS['Gust Slash'] = sets.precast.WS['Blade: Yu']

	sets.precast.WS['Cyclone'] = sets.precast.WS['Blade: Yu']

	sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Blade: Yu']


    --------------------------------------
    -- Midcast sets
    --------------------------------------

	sets.midcast.FC =
	{
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
		back="Andartia's Mantle", waist="Flume Belt", legs="Gyve Trousers", feet="Hattori Kyahan +1"
	}

    sets.midcast.ElementalNinjutsu =
	{
		ammo="Pemphredo Tathlum",
		head="Herculean Helm", neck="Sanctity Necklace", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Samnuha Coat", hands="Hattori Tekko +1", lring="Acumen Ring", rring="Shiva Ring",
		back="Seshaw Cape", waist="Eschan Stone", legs="Gyve Trousers", feet="Herculean Boots"
	}

    sets.midcast.NinjutsuDebuff =
	{
        ammo="Pemphredo Tathlum",
		head="Herculean Helm", neck="Sanctity Necklace", lear="Digni. Earring", rear="Gwati Earring",
        body="Samnuha Coat", hands="Leyline Gloves", lring="Stikini Ring", rring="Stikini Ring",
        back="Yokaze Mantle", waist="Eschan Stone", legs="Gyve Trousers", feet="Herculean Boots"
	}

    sets.midcast.NinjutsuBuff =
	{
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Stikini Ring", rring="Prolix Ring",
		back="Andartia's Mantle", waist="Flume Belt", legs="Gyve Trousers", feet="Hattori Kyahan +1"
	}

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Idle sets
	sets.idle =
	{
		head="Dampening Tam", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Hiza. Haramaki +1", hands="Umuthi Gloves", lring="Sheltered Ring", rring="Paguroidea Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Herculean Trousers", feet="Herculean Boots"
	}

    sets.idle.Movement =
	{
		head="Dampening Tam", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Hiza. Haramaki +1", hands="Umuthi Gloves", lring="Sheltered Ring", rring="Paguroidea Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Herculean Trousers", feet="Danzo Sune-Ate"
	}

	sets.idle.PDT = set_combine (sets.idle,
	{
		head="Lithelimb Cap", neck="Twilight Torque",
		body="Emet Harness", lring="Defending Ring", rring="Vocane Ring",
		feet="Herculean Boots"
	})

	sets.idle.MDT = set_combine (sets.idle,
	{
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		body="Hiza. Haramaki +1", hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Solemnity Cape", legs="Feast Hose"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb", feet="Danzo Sune-Ate"
	})

	sets.idle.Weak = sets.idle.MDT


	-- Defense sets

	sets.defense.PDT =
	{
		head="Lithelimb Cap", neck="Twilight Torque",
		body="Emet Harness", hands="Umuthi Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Herculean Trousers", feet="Herculean Boots"
	}

	sets.defense.MDT =
	{
		head="Dampening Tam", neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		body="Hiza. Haramaki +1", hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		back="Solemnity Cape", legs="Feast Hose",
	}



    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged =
	{
		ammo="Happo Shuriken",
		head="Hattori Zukin +1", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Floral Gauntlets", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Yokaze Mantle", waist="Reiki Yotai", legs="Samnuha Tights", feet="Hiza. Sune-Ate +1"
	}

	sets.engaged.LowAcc = set_combine(sets.engaged,
	{
		neck="Combatant's Torque", lear="Telos Earring",
		lring="Cacoethic Ring +1"
	})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc,
	{
		rear="Cessance Earring",
		legs="Adhemar Kecks"
	})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,
	{
		head="Dampening Tam",
		rring="Cacoethic Ring"
	})

	sets.engaged.HighHaste =
	{
		ammo="Happo Shuriken",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Adhemar Jacket", hands="Adhemar Wristbands", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Yokaze Mantle", waist="Reiki Yotai", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste,
	{
		head="Dampening Tam", neck="Combatant's Torque",
		lring="Cacoethic Ring +1"
	})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc,
	{
		lear="Telos Earring",
		legs="Adhemar Kecks"
	})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc,
	{
		rear="Cessance Earring",
		hands="Floral Gauntlets", rring="Cacoethic Ring"
	})

	sets.engaged.MaxHaste =
	{
		ammo="Happo Shuriken",
		head="Adhemar Bonnet", neck="Asperity Necklace", lear="Brutal Earring", rear="Cessance Earring",
		body="Herculean Vest", hands="Adhemar Wristbands", lring="Hetairoi Ring", rring="Epona's Ring",
		back="Yokaze Mantle", waist="Windbuffet Belt +1", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste,
	{
		head="Dampening Tam", neck="Combatant's Torque",
		lring="Cacoethic Ring +1"
	})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc,
	{
		lear="Telos Earring",
		hands="Hizamaru Kote +1", legs="Adhemar Kecks"
	})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc,
	{
		rear="Cessance Earring",
		rring="Cacoethic Ring",
		waist="Kentarch Belt +1"
	})

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.



-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
end

function job_status_change(new_status, old_status)
    if new_status == 'Idle' then
        select_movement_feet()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
                return 'NinjutsuDebuff'
            end
        end
    end
end


-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    select_movement_feet()
    determine_haste_group()
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

function select_movement_feet()
    if world.time >= 17*60 or world.time < 7*60 then
        gear.MovementFeet.name = gear.NightFeet
    else
        gear.MovementFeet.name = gear.DayFeet
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 19)
end
