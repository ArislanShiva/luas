-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Standard', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'PhysicalDef', 'MagicalDef')
    state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

	select_default_macro_book()
end

function user_unload()
	send_command('unbind !`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

	sets.Enmity =
	{
		lear="Friomisi Earring",
		body="Emet Harness", hands="Futhark Mitons", lring="Petrov Ring", rring="Begrudging Ring",
		back="Reiki Cloak", legs="Eri. Leg Guards +1", feet="Erilaz Greaves +1"
	}

	-- Precast sets to enhance JAs
	sets.precast.JA['Swipe'] =
	{
		ammo="Pemphredo Tathlum",
		head="Herculean Helm", neck="Sanctity Necklace", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Acumen Ring", rring="Shiva Ring",
		back="Evasionist's Cape", waist="Eschan Stone", legs="Samnuha Tights", feet="Herculean Boots"
	}

	sets.precast.JA['Lunge'] = sets.precast.Swipe

	sets.precast.JA['Gambit'] =
	{
		hands="Runeist Mitons +1"
	}

	sets.precast.JA['Rayke'] =
	{
		feet="Futhark Boots"
	}

	sets.precast.Swordplay = set_combine(sets.Enmity,
	{
		hands="Futhark Mitons"
	})

	sets.precast.JA['Vallation'] = set_combine(sets.Enmity,
	{
		body="Runeist Coat +1",
		back="Ogma's Cape"
	})

	sets.precast.JA['Valiance'] = set_combine(sets.Enmity,
	{
		body="Runeist Coat +1",
		back="Ogma's Cape"
	})

	sets.precast.JA['Pflug'] = set_combine(sets.Enmity,
	{
		feet="Runeist Bottes +1"
	})

	sets.precast.JA['Battuta'] = set_combine(sets.Enmity,
	{
		head="Fu. Bandeau +1"
	})

	sets.precast.JA['Liement'] = set_combine(sets.Enmity,
	{
		body="Futhark Coat +1"
	})

	sets.precast.JA['Vivacious Pulse'] = set_combine(sets.Enmity,
	{
		head="Erilaz Galea +1", neck="Incanter's Torque",
		lring="Stikini Ring", rring="Stikini Ring",
		legs="Rune. Trousers +1"
	})

	sets.precast.Embolden =
	{
		back="Evasionist's Cape"
	}

	sets.precast.JA['Elemental Sforzo'] = set_combine(sets.Enmity,
	{
		body="Futhark Coat +1"
	})

	sets.precast.JA['Provoke'] = sets.Enmity

	sets.precast.JA['Warcry'] = sets.Enmity

	sets.precast.JA['Last Resort'] = sets.Enmity

	sets.precast.JA['Souleater'] = sets.Enmity

	sets.precast.JA['Weapon Bash'] = sets.Enmity

	sets.precast.JA['Sentinel'] = sets.Enmity

    -- Precast Sets

	sets.precast.FC =
	{
		ammo="Staunch Tathlum",
        head="Rune. Bandeau +1", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquacious Earring",
        body="Vrikodara Jupon", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
        back="Shadow Mantle", waist="Luminary Sash", legs="Rawhide Trousers", feet="Carmine Greaves"
	}

	sets.precast.Utsusemi = set_combine(sets.precast.FC,
	{
		body="Passion Jacket"
	})

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC,
	{
		waist="Siegel Sash",
		legs="Futhark Trousers +1"
	})

	-- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS =
	{
		ammo="Floestone",
		head="Lilitu Headpiece", neck="Fotia Gorget", lear="Brutal Earring", rear="Moonshade Earring",
		body="Meg. Cuirie +1", hands="Meg. Gloves +1", lring="Ifrit Ring", rring="Epona's Ring",
		back="Evasionist's Cape", waist="Fotia Belt", legs="Samnuha Tights", feet="Herculean Boots"
	}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS,
	{
		ammo="Falcon Eye",
		lring="Ramuh Ring",
	})

    -- Midcast Sets

    sets.midcast.FastRecast =
	{
		ammo="Staunch Tathlum",
        head="Rune. Bandeau +1", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquacious Earring",
        body="Vrikodara Jupon", hands="Leyline Gloves", lring="Defending Ring", rring="Prolix Ring",
        back="Shadow Mantle", waist="Flume Belt", legs="Carmine Cuisses +1", feet="Carmine Greaves"
	}

	sets.midcast.Cures =
	{
		head="Rune. Bandeau +1", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Vrikodara Jupon", hands="Leyline Gloves", lring="Lebeche Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Gishdubar Sash", legs="Carmine Cuisses +1", feet="Carmine Greaves"
	}

	sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cures,
	{
		waist="Hachirin-no-Obi"
	})

    sets.midcast.Curaga = sets.midcast.Cures

	sets.midcast.StatusRemoval = sets.midcast.FastRecast

	sets.midcast.Cursna = set_combine(sets.midcast.FastRecast,
	{
		ammo="Pemphredo Tathlum",
		neck="Debilis Medallion",
        lring="Haoma's Ring", rring="Haoma's Ring",
	})

	sets.midcast.Regen =
	{
		ammo="Staunch Tathlum",
		head="Rune. Bandeau +1", neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Futhark Coat +1", hands="Runeist Mitons +1", lring="Defending Ring", rring="Vocane Ring",
        back="Reiki Cloak", waist="Flume Belt", legs="Futhark Trousers +1", feet="Erilaz Greaves +1"
	}

	sets.midcast.Refresh =
	{
		ammo="Staunch Tathlum",
		head="Erilaz Galea +1", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Futhark Coat +1", hands="Runeist Mitons +1", lring="Defending Ring", rring="Vocane Ring",
        back="Reiki Cloak", waist="Gishdubar Sash", legs="Futhark Trousers +1", feet="Erilaz Greaves +1"
	}

	sets.midcast.Phalanx =
	{
		ammo="Staunch Tathlum",
		head="Fu. Bandeau +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
        body="Futhark Coat +1", hands="Runeist Mitons +1", lring="Stikini Ring", rring="Stikini Ring",
        back="Reiki Cloak", waist="Olympus Sash", legs="Futhark Trousers +1", feet="Erilaz Greaves +1"
	}

	sets.midcast.Temper = sets.midcast.Phalanx

	sets.midcast.BarElement = set_combine(sets.midcast.GainStat,
	{
		ammo="Staunch Tathlum",
		head="Carmine Mask", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
        body="Futhark Coat +1", hands="Runeist Mitons +1", lring="Stikini Ring", rring="Stikini Ring",
        back="Reiki Cloak", waist="Olympus Sash", legs="Carmine Cuisses +1", feet="Erilaz Greaves +1"
	})

	sets.midcast.BarStatus = sets.midcast.BarElement

	sets.midcast.Stoneskin =
	{
		ammo="Staunch Tathlum",
		head="Fu. Bandeau +1", neck="Stone Gorget", lear="Andoaa Earring", rear="Earthcry Earring",
        body="Futhark Coat +1", hands="Stone Mufflers", lring="Defending Ring", rring="Vocane Ring",
        back="Reiki Cloak", waist="Olympus Sash", legs="Carmine Cuisses +1", feet="Erilaz Greaves +1"
	}

	sets.midcast.Duration =
	{
		ammo="Staunch Tathlum",
		head="Rune. Bandeau +1", neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Futhark Coat +1", hands="Runeist Mitons +1", lring="Defending Ring", rring="Vocane Ring",
        back="Reiki Cloak", waist="Fotia Belt", legs="Futhark Trousers +1", feet="Erilaz Greaves +1"
	}

	sets.midcast.Aquaveil = sets.midcast.Duration

	sets.midcast.Statless = sets.midcast.Duration

	sets.midcast['Enhancing Magic'] = sets.midcast.Duration

	sets.midcast.Teleport = sets.midcast.FastRecast

	sets.midcast.Raise = sets.midcast.FastRecast

	sets.midcast.Reraise = sets.midcast.FastRecast

    sets.midcast.Macc =
	{
		ammo="Pemphredo Tathlum",
		head="Herculean Helm", neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
        body="Samnuha Coat", hands="Leyline Gloves", lring="Stikini Ring", rring="Stikini Ring",
        back="Reiki Cloak", waist="Luminary Sash", legs="Rawhide Trousers", feet="Herculean Boots"
	}

	sets.midcast.Flash = set_combine(sets.Enmity,
	{
		ammo="Pemphredo Tathlum",
		head="Rune. Bandeau +1", neck="Incanter's Torque", rear="Gwati Earring",
		hands="Leyline Gloves", rring="Stikini Ring",
		waist="Luminary Sash", feet="Carmine Greaves"
	})

	sets.midcast['Blue Magic'] = sets.midcast.Flash

	sets.midcast.Utsusemi = sets.midcast.FastRecast

	sets.midcast.Protect = set_combine(sets.midcast.Duration,
	{
		lring="Sheltered Ring",
	})

	sets.midcast.Protectra = sets.midcast.Protect

	sets.midcast.Shell = sets.midcast.Protect

	sets.midcast.Shellra = sets.midcast.Shell

    -- Sets to return to when not performing an action.

	------------------------------------------------------------------------------------------------
	------------------------------------------ Idle Sets -------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.idle =
	{
		main="Aettir", sub="Mensch Strap", ammo="Homiliary",
		head="Rawhide Mask", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Runeist Coat +1", hands="Runeist Mitons +1", lring="Sheltered Ring", rring="Paguroidea Ring",
        back="Shadow Mantle", waist="Fucho-no-Obi", legs="Rawhide Trousers", feet="Erilaz Greaves +1"
	}

	sets.idle.Movement = set_combine(sets.idle,
    {
        legs="Carmine Cuisses +1"
    })

	sets.idle.PDT =
	{
		main="Aettir", sub="Mensch Strap", ammo="Homiliary",
		head="Rawhide Mask", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Erilaz Surcoat +1", hands="Runeist Mitons +1", lring="Sheltered Ring", rring="Paguroidea Ring",
        back="Shadow Mantle", waist="Flume Belt", legs="Carmine Cuisses +1", feet="Erilaz Greaves +1"
	}

	sets.idle.MDT =
	{
		main="Aettir", sub="Irenic Strap", ammo="Homiliary",
		head="Rawhide Mask", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Futhark Coat +1", hands="Erilaz Gauntlets +1", lring="Sheltered Ring", rring="Paguroidea Ring",
        back="Reiki Cloak", waist="Fucho-no-Obi", legs="Carmine Cuisses +1", feet="Erilaz Greaves +1"
	}

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		legs="Carmine Cuisses +1"
	})


    -- Defense sets
    sets.defense.PDT = set_combine(sets.idle.PDT,
	{
		ammo="Staunch Tathlum",
		head="Fu. Bandeau +1", neck="Twilight Torque",
		body="Erilaz Surcoat +1", hands="Runeist Mitons +1", lring="Defending Ring", rring="Vocane Ring",
        waist="Flume Belt", legs="Eri. Leg Guards +1"
	})

    sets.defense.MDT = set_combine(sets.idle.MDT,
	{
		sub="Irenic Strap", ammo="Staunch Tathlum",
		head="Dampening Tam", neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		lring="Defending Ring", rring="Vocane Ring",
		back="Reiki Cloak", waist="Lieutenant's Sash", legs="Eri. Leg Guards +1"
	})

    sets.Kiting =
	{
		legs="Carmine Cuisses +1"
	}

	--------------------------------------
	-- Melee sets
	--------------------------------------

	sets.engaged =
	{
		main="Aettir", sub="Mensch Strap", ammo="Staunch Tathlum",
		head="Dampening Tam", neck="Twilight Torque", lear="Etiolation Earring", rear="Telos Earring",
		body="Erilaz Surcoat +1", hands="Erilaz Gauntlets +1", lring="Defending Ring", rring="Vocane Ring",
        back="Reiki Cloak", waist="Flume Belt", legs="Eri. Leg Guards +1", feet="Erilaz Greaves +1"
	}

	sets.engaged.Standard =
	{
		main="Aettir", ammo="Ginsen",
		head="Dampening Tam", neck="Asperity Necklace", lear="Brutal Earring", rear="Cessance Earring",
		body="Herculean Vest", hands="Adhemar Wristbands", lring="Petrov Ring", rring="Epona's Ring",
        back="Evasionist's Cape", waist="Windbuffet Belt +1", legs="Samnuha Tights", feet="Herculean Boots"
	}


	sets.engaged.LowAcc = set_combine(sets.engaged,
	{
		neck="Combatant's Torque", lear="Telos Earring",
		back="Evasionist's Cape"
	})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc,
	{
		head="Carmine Mask",
		hands="Meg. Gloves +1", lring="Cacoethic Ring", rring="Cacoethic Ring +1",
		feet="Meg. Jam. +1"
	})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,
	{
		rear="Digni. Earring",
		body="Meg. Cuirie +1",
		waist="Kentarch Belt +1", legs="Carmine Cuisses +1"
	})

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if default_spell_map == 'Cures' or default_spell_map == 'Curaga' then
			if (world.weather_element == 'Light' or world.day_element == 'Light') then
				return 'CureWithLightWeather'
			end
		end
	end
end

-- Called by the 'update' self-command.

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

	add_to_chat(122, msg)

	eventArgs.handled = true
end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 14)
end
