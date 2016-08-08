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
	update_active_abilities()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Shield')
    state.HybridMode:options('Normal', 'PhysicalDef', 'MagicalDef')
    state.CastingMode:options('Normal', 'Resistant', 'Potency')
    state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

	state.MagicBurst = M(false, 'Magic Burst')

    send_command('bind !` gs c toggle MagicBurst')

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

    -- Precast Sets

    -- Precast sets to enhance JAs
    sets.precast.JA['Chainspell'] = {body="Viti. Tabard +1"}

	sets.precast.JA['Convert'] =
	{
		ammo="Psilomene",
		head="Viti. Chapeau +1", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Mendi. Earring",
		body="Amalric Doublet", hands="Telchine Gloves", lring="Lebeche Ring", lring="Mephitas's Ring +1",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Amalric Slops", feet="Amalric Nails"
	}

    sets.precast.FC =
	{
		ammo="Staunch Tathlum",
        head="Atrophy Chapeau +1",neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquacious Earring",
        body="Viti. Tabard +1",hands="Leyline Gloves",lring="Evanescence Ring", rring="Prolix Ring",
        back="Swith Cape +1",waist="Witful Belt",legs="Carmine Cuisses +1",feet="Amalric Nails"
	}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC,
	{
		waist="Emphatikos Rope"
	})

	sets.precast.Statless = sets.precast.FC['Enhancing Magic']

	sets.precast.FC['Enfeebling Magic'] = sets.precast.Statless

	sets.precast.Klimaform = sets.precast.FC

	sets.precast.Teleport = sets.precast.FC

	sets.precast.Cures = sets.precast.Statless

	sets.precast.Curaga = sets.precast.Cures

    sets.precast.Impact = set_combine(sets.precast.Statless,
	{
		gear.Grioavolr_Enf, sub="Clerisy Strap",
		head=empty,
		body="Twilight Cloak",
		legs="Psycloth Lappas", feet="Carmine Greaves"
	})

	sets.precast.Reraise = sets.precast.FC

	sets.precast.Raise = sets.precast.FC

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS =
	{
		ammo="Floestone",
		head="Carmine Mask", neck="Fotia Gorget", lear="Brutal Earring", rear="Moonshade Earring",
		body="Despair Mail", hands="Taeon Gloves", lring="Rufescent Ring", rring="Levia. Ring",
		back=gear.RDMCape_Melee, waist="Fotia Belt", legs="Carmine Cuisses +1", feet="Carmine Greaves"
	}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS,
	{
		rring="Ifrit Ring",
		legs="Taeon Tights"
	})

	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS['Savage Blade'],
	{
		ammo="Yetshila",
		head="Taeon Chapeau",
		lring="Begrudging Ring", rring="Hetairoi Ring",
		feet="Thereoid Greaves"
	})

	sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']

	sets.precast.WS['Sanguine Blade'] =
	{
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1", neck="Fotia Gorget", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Merlinic Jubbah", hands="Chironic Gloves", lring="Archon Ring", rring="Levia. Ring",
		back=gear.RDMCape_Nuke, waist="Fotia Belt", legs="Merlinic Shalwar", feet="Chironic Slippers"
	}

    -- Midcast Sets

    sets.midcast.FastRecast =
	{
		ammo="Staunch Tathlum",
        head="Carmine Mask", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquacious Earring",
        body="Viti. Tabard +1", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
        back="Swith Cape +1", waist="Witful Belt", legs="Carmine Cuisses +1", feet="Amalric Nails"
	}

	sets.midcast.ConserveMP = set_combine(sets.midcast.FastRecast,
	{
		ammo="Pemphredo Tathlum",
		head="Vanya Hood", neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
		body="Vanya Robe", hands="Leyline Gloves",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Lengo Pants", feet="Carmine Greaves"
	})

	sets.midcast.Cures =
	{
		main=gear.Grioavolr_Enh, sub="Achaq Grip", ammo="Esper Stone +1",
		head="Vanya Hood", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Kaykaus Bliaut", hands="Kaykaus Cuffs", lring="Lebeche Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Gishdubar Sash", legs="Gyve Trousers", feet="Vanya Clogs"
	}

	sets.midcast.CureWithLightWeather = set_combine(sets.midcast.Cures,
	{
		main="Chatoyant Staff",
		back="Twilight Cape", waist="Hachirin-no-Obi"
	})

    sets.midcast.Curaga = sets.midcast.Cures

	sets.midcast.StatusRemoval = sets.midcast.FastRecast

	sets.midcast.Cursna = set_combine(sets.midcast.FastRecast,
	{
		neck="Debilis Medallion",
        hands="Hieros Mittens", lring="Haoma's Ring", rring="Haoma's Ring",
        back="Oretan. Cape +1", feet="Gende. Galosh. +1"
	})

	sets.midcast.Regen =
	{
		main="Bolelabunga", sub="Thuellaic Ecu +1", ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Atrophy Gloves +1", lring="Evanescence Ring", rring="Prolix Ring",
        back="Sucellos's Cape", waist="Luminary Sash", legs="Telchine Braconi", feet="Leth. Houseaux +1"
	}

	sets.midcast.Refresh =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Atrophy Gloves +1", lring="Evanescence Ring", rring="Prolix Ring",
        back="Grapevine Cape", waist="Gishdubar Sash", legs="Leth. Fuseau +1", feet="Leth. Houseaux +1"
	}

	sets.midcast.Enspells =
	{
		ammo="Pemphredo Tathlum",
		head="Befouled Crown", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
		body="Viti. Tabard +1", hands="Viti. Gloves +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Sucellos's Cape", waist="Olympus Sash", legs="Carmine Cuisses +1", feet="Leth. Houseaux +1"
	}

	sets.midcast.Phalanx = set_combine(sets.midcast.Enspells,
	{
		body="Telchine Chas."
	})

	sets.midcast['Temper II'] = sets.midcast.Enspells

	sets.midcast.Klimaform = sets.midcast.FastRecast

	sets.midcast.GainStat =
	{
		ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Incanter's Torque", lear="Andoaa Earring", rear="Mendi. Earring",
		body="Telchine Chas.", hands="Atrophy Gloves +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Sucellos's Cape", waist="Olympus Sash", legs="Telchine Braconi", feet="Leth. Houseaux +1"
	}

	sets.midcast.BarElement = set_combine(sets.midcast.GainStat,
	{
		legs="Shedir Seraweels"
	})

	sets.midcast.BarStatus = sets.midcast.BarElement

	sets.midcast.Stoneskin =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Stone Gorget", lear="Andoaa Earring", rear="Earthcry Earring",
		body="Telchine Chas.", hands="Stone Mufflers", lring="Evanescence Ring", rring="Prolix Ring",
		back="Sucellos's Cape", waist="Witful Belt", legs="Shedir Seraweels", feet="Leth. Houseaux +1"
	}

	sets.midcast.Duration =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Telchine Chas.", hands="Atrophy Gloves +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Sucellos's Cape", waist="Witful Belt", legs="Telchine Braconi", feet="Leth. Houseaux +1"
	}

	sets.midcast.Aquaveil = set_combine(sets.midcast.Duration,
	{
		head="Amalric Coif",
		waist="Emphatikos Rope", legs="Shedir Seraweels"
	})

	sets.midcast.Statless = sets.midcast.Duration

	sets.midcast.Storm = sets.midcast.Duration

	sets.midcast['Enhancing Magic'] = sets.midcast.Duration

	sets.midcast.Teleport = sets.midcast.ConserveMP

	sets.midcast.Raise = sets.midcast.ConserveMP

	sets.midcast.Reraise = sets.midcast.ConserveMP

    sets.midcast.Macc =
	{
		main=gear.Grioavolr_Enf, sub="Mephitis Grip", ammo="Pemphredo Tathlum",
		head=gear.NukeHood, neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Merlinic Jubbah", hands="Leth. Gantherots +1", lring="Stikini Ring", rring="Stikini Ring",
		back=gear.RDMCape_Nuke, waist="Luminary Sash", legs="Chironic Hose", feet="Medium's Sabots"
	}

	sets.midcast['Enfeebling Magic'] = set_combine(sets.midcast.Macc,
	{
		head="Befouled Crown",
		body="Lethargy Sayon +1",
		back=gear.RDMCape_Nuke, legs="Psycloth Lappas"
	})

	sets.midcast['Enfeebling Magic'].Resistant = set_combine(sets.midcast.Macc,
	{
		body="Vanya Robe",
		back=gear.RDMCape_Nuke
	})

	sets.midcast['Enfeebling Magic'].Potency = set_combine(sets.midcast.Macc,
	{
		head="Viti. Chapeau +1",
		body="Lethargy Sayon +1",
		back=gear.RDMCape_Nuke, legs="Psycloth Lappas"
	})

    sets.midcast['Dia III'] = set_combine(sets.midcast.ConserveMP,
	{
		head="Viti. Chapeau +1"
	})

	sets.midcast['Dark Magic'] = set_combine(sets.midcast.Macc,
	{
		sub="Clerisy Strap",
		head="Pixie Hairpin +1",
		body="Psycloth Vest", hands="Leyline Gloves", lring="Archon Ring", rring="Stikini Ring",
		waist="Fucho-no-Obi", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	})

	sets.midcast.Sap = set_combine(sets.midcast['Dark Magic'],
	{
		body="Chironic Doublet", lring="Evanescence Ring", rring="Archon Ring"
	})

	sets.midcast.Stun =
	{
		main=gear.Grioavolr_Enf, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Orunmila's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Shango Robe", hands="Leyline Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back=gear.RDMCape_Nuke, waist="Luminary Sash", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	}

	sets.midcast['Blue Magic'] =
	{
		main=gear.Grioavolr_Enf, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Shango Robe", hands="Leyline Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back=gear.RDMCape_Nuke, waist="Luminary Sash", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	}

	-- Elemental Magic
	sets.midcast['Elemental Magic'] =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head=gear.NukeHood, neck="Sanctity Necklace", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Merlinic Jubbah", hands="Chironic Gloves", lring="Acumen Ring", rring="Shiva Ring",
		back=gear.RDMCape_Nuke, waist="Refoccilation Stone", legs="Merlinic Shalwar", feet="Chironic Slippers"
	}

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'],
	{
		waist="Eschan Stone", feet=gear.NukeCrackows
	})

	sets.midcast['Elemental Magic'].Potency = sets.midcast['Elemental Magic']

	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'],
	{
		head=empty,
		body="Twilight Cloak", rring="Archon Ring"
	})

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
		main="Bolelabunga", sub="Beatific Shield +1", ammo="Homiliary",
		head="Viti. Chapeau +1", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Witching Robe", hands="Serpentes Cuffs", lring="Sheltered Ring", rring="Paguroidea Ring",
        back="Shadow Mantle", waist="Fucho-no-Obi", legs="Lengo Pants", feet="Serpentes Sabots"
	}

	sets.idle.Movement = set_combine(sets.idle,
    {
        legs="Carmine Cuisses +1"
    })

	sets.idle.PDT = set_combine(sets.idle,
	{
		sub="Genmei Shield",
		neck="Twilight Torque",
        body="Vrikodara Jupon", hands="Gende. Gages +1", lring="Defending Ring", rring="Vocane Ring",
        waist="Flume Belt", feet="Battlecast Gaiters"
	})

	sets.idle.MDT = set_combine(sets.idle,
	{
		hneck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
        body="Witching Robe", hands="Gende. Gages +1", lring="Defending Ring", rring="Vocane Ring",
        back="Reiki Cloak", waist="Lieutenant's Sash", feet="Vanya Clogs"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		legs="Carmine Cuisses +1"
	})


    -- Defense sets
    sets.defense.PDT = set_combine(sets.idle.PDT,
	{
		ammo="Staunch Tathlum",
		head="Lithelimb Cap", neck="Twilight Torque",
        body="Emet Harness", hands="Umuthi Gloves", 
        legs="Artsieq Hose"
	})

    sets.defense.MDT = set_combine(sets.idle.MDT,
	{
		ammo="Staunch Tathlum",
		head="Vanya Hood",
        body="Vanya Robe", 
        legs="Gyve Trousers"
	})

    sets.Kiting =
	{
		legs="Carmine Cuisses +1"
	}

	sets.magic_burst =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head=gear.NukeHood, neck="Mizu. Kubikazari", lear="Friomisi Earring", rear="Static Earring",
		body="Merlinic Jubbah", hands="Amalric Gages", lring="Locus Ring", rring="Mujin Band",
		back=gear.RDMCape_Nuke, waist="Refoccilation Stone", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	}

	sets.buff['Saboteur'] =
	{
		hands="Leth. Gantherots +1"
	}

	sets.buff['Composure'] =
	{
		head="Leth. Chappel +1",
		body="Lethargy Sayon +1",
		legs="Leth. Fuseau +1", feet="Leth. Houseaux +1"
	}

	--------------------------------------
	-- Melee sets
	--------------------------------------

	sets.engaged =
	{
		main="Sequence", sub="Colada", ammo="Ginsen",
		head="Taeon Chapeau", neck="Asperity Necklace", lear="Eabani Earring", rear="Suppanomimi",
		body="Despair Mail", hands="Taeon Gloves", lring="Petrov Ring", rring="Hetairoi Ring",
		back=gear.RDMCape_Melee, waist="Reiki Yotai", legs="Carmine Cuisses +1", feet="Taeon Boots"
	}

	sets.engaged.LowAcc = set_combine(sets.engaged,
	{
		neck="Combatant's Torque", lear="Telos Earring",
		lring="Cacoethic Ring", rring="Cacoethic Ring +1"
	})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc,
	{
		head="Carmine Mask",
		hands="Leyline Gloves"
	})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,
	{
		rear="Digni. Earring",
		waist="Kentarch Belt +1"
	})

	sets.engaged.Shield =
	{
		main="Sequence", sub="Genmei Shield", ammo="Ginsen",
		head="Carmine Mask", neck="Combatant's Torque", lear="Telos Earring", rear="Cessance Earring",
		body="Despair Mail", hands="Taeon Gloves", lring="Defending Ring", rring="Vocane Ring",
		back=gear.RDMCape_Melee, waist="Kentarch Belt +1", legs="Carmine Cuisses +1", feet="Carmine Greaves"
	}

	sets.engaged.HighHaste =
	{
		main="Sequence", sub="Colada", ammo="Ginsen",
		head="Taeon Chapeau", neck="Asperity Necklace", lear="Brutal Earring", rear="Suppanomimi",
		body="Despair Mail", hands="Taeon Gloves", lring="Petrov Ring", rring="Hetairoi Ring",
		back=gear.RDMCape_Melee, waist="Reiki Yotai", legs="Carmine Cuisses +1", feet="Taeon Boots"
	}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste,
	{
		neck="Combatant's Torque", lear="Telos Earring",
		lring="Cacoethic Ring", rring="Cacoethic Ring +1"
	})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc,
	{
		head="Carmine Mask",
		hands="Leyline Gloves"
	})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc,
	{
		rear="Digni. Earring",
		waist="Kentarch Belt +1"
	})



	sets.engaged.MaxHaste =
	{
		main="Sequence", sub="Colada", ammo="Ginsen",
		head="Taeon Chapeau", neck="Asperity Necklace", lear="Brutal Earring", rear="Cessance Earring",
		body="Despair Mail", hands="Taeon Gloves", lring="Petrov Ring", rring="Hetairoi Ring",
		back=gear.RDMCape_Melee, waist="Windbuffet Belt +1", legs="Taeon Tights", feet="Carmine Greaves"
	}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste,
	{
		neck="Combatant's Torque", lear="Telos Earring",
		lring="Cacoethic Ring", rring="Cacoethic Ring +1"
	})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc,
	{
		head="Carmine Mask",
		hands="Leyline Gloves"
	})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc,
	{
		rear="Digni. Earring",
		waist="Kentarch Belt +1"
	})


end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
		apply_abilities(spell, action, spellMap, eventArgs)
	end

	if spell.skill == 'Enfeebling Magic' then
		if spell.english == 'Slow II' then
			equip(
			{
				head="Viti. Chapeau +1"
			})
		elseif spell.english == 'Paralyze II' then
			equip(
			{
				feet="Vitivation Boots +1"
			})
		end
	end

	if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
		if (spell.element == world.day_element or spell.element == world.weather_element) then
			equip(set_combine(sets.magic_burst,
			{
				waist="Hachirin-no-Obi"
			}))
		elseif spell.element == 'Dark' and spell.english ~= 'Impact' then
			if (world.weather_element == 'Dark' or world.day_element == 'Dark') then
				equip(set_combine(sets.magic_burst,
				{
					head="Pixie Hairpin +1",
					lring="Archon Ring",
					waist="Hachirin-no-Obi"
				}))
			else
				equip(set_combine(sets.magic_burst,
				{
					head="Pixie Hairpin +1",
					lring="Archon Ring"
				}))

			end
		elseif spell.element == 'Dark' and spell.english == 'Impact' then
			if (world.weather_element == 'Dark' or world.day_element == 'Dark') then
				equip(set_combine(sets.magic_burst,
				{
					head=empty,
					body="Twilight Cloak", lring="Archon Ring",
					waist="Hachirin-no-Obi"
				}))
			else
				equip(set_combine(sets.magic_burst,
				{
					head=empty,
					body="Twilight Cloak", lring="Archon Ring"
				}))
			end

		else
			equip(sets.magic_burst)
		end
	elseif spell.skill =='Elemental Magic' and (spell.element == world.day_element or spell.element == world.weather_element) then
		if spell.element == 'Dark' then
			equip
			{
				lring="Archon Ring",
				waist="Hachirin-no-Obi"
			}
		else
			equip
			{
				waist="Hachirin-no-Obi"
			}
		end
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.skill == 'Elemental Magic' then
			--state.MagicBurst:reset()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------
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
function job_update(cmdParams, eventArgs)
	determine_haste_group()
	update_active_abilities()
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
	state.Buff['Saboteur'] = buffactive['Saboteur'] or false
	state.Buff['Composure'] = buffactive['Composure'] or false
end

function apply_abilities(spell, action, spellMap)
	if state.Buff.Composure and spell.skill == 'Enhancing Magic' then
		if spell.target.type == 'PLAYER' then
			equip(sets.buff['Composure'])
		end
	end

	if state.Buff.Saboteur and spell.skill == 'Enfeebling Magic' then
		equip(sets.buff['Saboteur'])
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 1)
end
