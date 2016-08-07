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
	info.addendumNukes = S{"Stone IV", "Water IV", "Aero IV", "Fire IV", "Blizzard IV", "Thunder IV",
		"Stone V", "Water V", "Aero V", "Fire V", "Blizzard V", "Thunder V"}

	state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
	update_active_strategems()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('None', 'Normal', 'Refresh')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

	state.MagicBurst = M(false, 'Magic Burst')

	-- Additional local binds
	send_command('bind !` gs c toggle MagicBurst')

	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind !`')
end



-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	---- Precast Sets ----

	-- Precast sets to enhance JAs

   sets.precast.JA['Tabula Rasa'] =
    {
		ammo="Psilomene",
		head="Pixie Hairpin +1", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Gifted Earring",
		body="Amalric Doublet", hands="Telchine Gloves", lring="Lebeche Ring", rring="Mephitas's Ring +1",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Peda. Pants +1", feet="Amalric Nails"
	}

	sets.precast.JA['Enlightenment'] =
	{
		body="Peda. Gown +1"
	}
	sets.precast.JA['Convert'] =
	{
		ammo="Psilomene",
		head="Vanya Hood", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Mendi. Earring",
		body="Vrikodara Jupon", hands="Telchine Gloves", lring="Lebeche Ring", rring="Mephitas's Ring +1",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Gyve Trousers", feet="Amalric Nails"
	}

	-- Fast cast sets for spells

	sets.precast.FC =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Staunch Tathlum",
		head="Vanya Hood", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
        body="Shango Robe", hands="Gende. Gages +1", lring="Evanescence Ring", rring="Prolix Ring",
        back="Swith Cape +1", waist="Witful Belt", legs="Psycloth Lappas", feet="Peda. Loafers +1"
	}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC,
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		waist="Siegel Sash"
	})

	sets.precast.Statless = sets.precast.FC['Enhancing Magic']

	sets.precast.FC['Enfeebling Magic'] = set_combine(sets.precast.FC,
	{
		main=gear.Grioavolr_Enf, sub="Clerisy Strap",
		waist="Emphatikos Rope"
	})

	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC,
	{
		main=gear.Grioavolr_Enf, sub="Clerisy Strap",
		waist="Emphatikos Rope"
	})

	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'],
	{
		head="Umuthi Hat",
		hands="Carapacho Cuffs"
	})

	sets.precast.FC.Klimaform = sets.precast.FC

	sets.precast.FC.Teleport = sets.precast.FC

	sets.precast.FC.Cures = set_combine(sets.precast.FC,
	{
		rear="Mendi. Earring",
		waist="Emphatikos Rope"
	})

	sets.precast.FC.Curaga = sets.precast.FC.Cures

	sets.precast.FC.Impact = set_combine(sets.precast.FC,
	{
		head=empty,
		body="Twilight Cloak",
		waist="Emphatikos Rope",
	})

	sets.precast.WS['Myrkr'] =
	{
		ammo="Psilomene",
		head="Pixie Hairpin +1", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Moonshade Earring",
		body="Amalric Doublet", hands="Telchine Gloves", lring="Lebeche Ring", rring="Mephitas's Ring +1",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Amalric Slops", feet="Amalric Nails"
	}

	sets.precast.FC.Reraise = sets.precast.FC

	sets.precast.FC.Raise = sets.precast.FC

	---- Precast Sets ----

	sets.midcast.FC = set_combine(sets.precast.FC,
	{
		head="Amalric Coif"
	})

	sets.midcast.ConserveMP = set_combine(sets.precast.FC,
	{
		ammo="Pemphredo Tathlum",
		neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
		body="Kaykaus Bliaut",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Lengo Pants", feet=gear.NukeCrackows
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

	sets.midcast.Regen =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Arbatel Bonnet +1", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Lebeche Ring", rring="Prolix Ring",
        back="Lugh's Cape", waist="Luminary Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Refresh =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Lebeche Ring", rring="Prolix Ring",
        back="Grapevine Cape", waist="Gishdubar Sash", legs="Telchine Braconi", feet="Inspirited Boots"
	}

	sets.midcast.StatusRemoval = sets.midcast.FC

	sets.midcast.Cursna = set_combine(sets.precast.FC,
	{
		neck="Debilis Medallion",
        hands="Hieros Mittens", lring="Haoma's Ring", rring="Haoma's Ring",
        back="Oretan. Cape +1", feet="Gende. Galosh. +1"
	})

	sets.midcast['Enhancing Magic'] =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Savant's Treatise",
		head="Befouled Crown", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Fi Follet Cape +1", waist="Olympus Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'],
	{
		head="Telchine Cap",
		legs="Shedir Seraweels"
	})

	sets.midcast.BarStatus = sets.midcast.BarElement

	sets.midcast.Stoneskin =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Stone Gorget", lear="Andoaa Earring", rear="Earthcry Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Evanescence Ring", rring="Prolix Ring",
		back="Lugh's Cape", waist="Witful Belt", legs="Shedir Seraweels", feet="Telchine Pigaches"
	}

	sets.midcast.Duration =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Lugh's Cape", waist="Witful Belt", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Aquaveil = set_combine(sets.midcast.Duration,
	{
		head="Amalric Coif", waist="Emphatikos Rope", legs="Shedir Seraweels"
	})

	sets.midcast.Statless = sets.midcast.Duration

	sets.midcast.Storm = sets.midcast.Duration

	sets.midcast['Hailstorm II'] = set_combine(sets.midcast.Duration,
	{
		feet="Peda. Loafers +1",
	})

	sets.midcast.Protect = set_combine(sets.midcast.Duration,
	{
		rring="Sheltered Ring",
	})

	sets.midcast.Klimaform = sets.midcast.FC

	sets.midcast.Protectra = sets.midcast.Protect

	sets.midcast.Shell = sets.midcast.Protect

	sets.midcast.Shellra = sets.midcast.Shell

	-- Custom spell classes
	sets.midcast.Macc =
	{
		main=gear.Grioavolr_Enf, sub="Mephitis Grip", ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Incanter's Torque", lear="Digni. Earring", rear="Barkaro. Earring",
		body="Vanya Robe", hands="Lurid Mitts", lring="Stikini Ring", rring="Stikini Ring",
		back="Lugh's Cape", waist="Luminary Sash", legs="Chironic Hose", feet="Medium's Sabots"
	}

	sets.midcast.MndEnfeebles = set_combine(sets.midcast.Macc,
	{
		head="Befouled Crown"
	})

	sets.midcast.IntEnfeebles = set_combine(sets.midcast.Macc,
	{
		head="Befouled Crown"
	})

	sets.midcast.ElementalEnfeeble = sets.midcast.Macc

	sets.midcast['Dark Magic'] = set_combine(sets.midcast.Macc,
	{
		sub="Clerisy Strap",
		head="Pixie Hairpin +1",
		body="Psycloth Vest", hands="Chironic Gloves", lring="Archon Ring", rring="Stikini Ring",
		waist="Fucho-no-Obi", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	})

	sets.midcast.Kaustra =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1", neck="Sanctity Necklace", lear="Friomisi Earring", rear="Barkaro. Earring",
		body="Merlinic Jubbah", hands="Chironic Gloves", lring="Archon Ring", rring="Stikini Ring",
		back="Lugh's Cape", waist="Refoccilation Stone", legs="Merlinic Shalwar", feet="Chironic Slippers"
	}

	sets.midcast.Sap = set_combine(sets.midcast['Dark Magic'],
	{
		body="Chironic Doublet", lring="Evanescence Ring", rring="Archon Ring"
	})

	sets.midcast.Stun =
	{
		main=gear.Grioavolr_Enf, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Amalric Coif", neck="Orunmila's Torque", lear="Digni. Earring", rear="Barkaro. Earring",
		body="Shango Robe", hands="Chironic Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Lugh's Cape", waist="Witful Belt", legs="Psycloth Lappas", feet=gear.NukeCrackows
	}

	-- Elemental Magic
	sets.midcast['Elemental Magic'] =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head=gear.NukeHood, neck="Sanctity Necklace", lear="Friomisi Earring", rear="Barkaro. Earring",
		body="Merlinic Jubbah", hands="Chironic Gloves", lring="Acumen Ring", rring="Shiva Ring",
		back="Lugh's Cape", waist="Refoccilation Stone", legs="Merlinic Shalwar", feet="Chironic Slippers"
	}

	sets.midcast['Elemental Magic'].Resistant =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head=gear.NukeHood, neck="Sanctity Necklace", lear="Friomisi Earring", rear="Barkaro. Earring",
		body="Merlinic Jubbah", hands="Chironic Gloves", lring="Acumen Ring", rring="Shiva Ring",
		back="Lugh's Cape", waist="Eschan Stone", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	}

	sets.midcast.Impact = set_combine(sets.midcast.Kaustra,
	{
		head=empty,
		body="Twilight Cloak", rring="Shiva Ring",
	})

	sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'],
	{
		main="Akademos"
	})

	sets.midcast.DarkHelix = set_combine(sets.midcast.Helix,
	{
		head="Pixie Hairpin +1",
		ring1="Archon Ring",
	})

	sets.midcast.Utsusemi = sets.midcast.FC

	------------------------------------------------------------------------------------------------
	------------------------------------------ Idle Sets -------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.idle =
	{
		main="Akademos", sub="Mensch Strap", ammo="Homiliary",
		head="Befouled Crown", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Witching Robe", hands="Serpentes Cuffs", lring="Sheltered Ring", rring="Paguroidea Ring",
        back="Shadow Mantle", waist="Fucho-no-Obi", legs="Assid. Pants +1", feet="Serpentes Sabots"
	}

	sets.idle.Movement = set_combine(sets.idle,
    {
        feet="Crier's Gaiters"
    })

	sets.idle.PDT = set_combine(sets.idle,
	{
		neck="Twilight Torque",
        body="Vrikodara Jupon", hands="Gende. Gages +1", lring="Defending Ring", rring="Vocane Ring",
        feet="Battlecast Gaiters"
	})

	sets.idle.MDT =set_combine(sets.idle,
	{
		sub="Irenic Strap",
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
        hands="Gende. Gages +1", lring="Defending Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Luminary Sash", feet="Vanya Clogs"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		feet="Crier's Gaiters"
	})

	sets.resting = set_combine(sets.idle,
	{
		main="Chatoyant Staff",
	})

	------------------------------------------------------------------------------------------------
	---------------------------------------- Defense Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.defense.PDT = set_combine(sets.idle.PDT,
	{
        ammo="Staunch Tathlum",
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
		feet="Crier's Gaiters"
	}

	sets.latent_refresh = sets.idle

	------------------------------------------------------------------------------------------------
	---------------------------------------- Engaged Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.engaged =
	{
		main="Akademos"
	}

	sets.engaged.Refresh = sets.idle

	------------------------------------------------------------------------------------------------
	---------------------------------------- Special Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.magic_burst =
	{
		main="Akademos", sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head=gear.NukeHead, neck="Mizu. Kubikazari", lear="Static Earring", rear="Barkaro. Earring",
		body="Merlinic Jubbah", hands="Amalric Gages", lring="Locus Ring", rring="Mujin Band",
		back="Lugh's Cape", waist="Refoccilation Stone", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	}

	sets.buff['Ebullience'] = {head="Arbatel Bonnet +1"}
	sets.buff['Rapture'] = {head="Arbatel Bonnet +1"}
	sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
	sets.buff['Immanence'] = {hands="Arbatel Bracers +1", "Lugh's Cape"}
	sets.buff['Celerity'] = {feet="Peda. Loafers +1"}
	sets.buff['Alacrity'] = {feet="Peda. Loafers +1"}

	sets.buff['Klimaform'] =
	{
	main="Akademos",
	waist="Hachirin-no-Obi", feet="Arbatel Loafers +1"
	}

	sets.buff.FullSublimation =
	{
		head="Acad. Mortar. +1", ear1="Savant's Earring",
		body="Peda. Gown +1"
	}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		apply_grimoire_bonuses(spell, action, spellMap, eventArgs)
	end

	if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
		if (spell.element ~= 'Dark' and (spell.element == world.day_element or spell.element == world.weather_element)) then
			equip(set_combine(sets.magic_burst,
			{
				main="Akademos",
				waist="Hachirin-no-Obi", feet="Arbatel Loafers +1"
			}))
		elseif spell.element == 'Dark' and spell.english ~= 'Impact' then
			if (world.weather_element == 'Dark' or world.day_element == 'Dark') then
				equip(set_combine(sets.magic_burst,
				{
					main="Akademos",
					head="Pixie Hairpin +1",
					lring="Archon Ring",
					waist="Hachirin-no-Obi", feet="Arbatel Loafers +1"
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
					main="Akademos",
					head=empty,
					body="Twilight Cloak", lring="Archon Ring",
					waist="Hachirin-no-Obi", feet="Arbatel Loafers +1"
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
				main="Akademos",
				lring="Archon Ring",
				waist="Hachirin-no-Obi"
			}
		else
			equip
			{
				main="Akademos",
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

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if buff == "Sublimation: Activated" then
		handle_equipping_gear(player.status)
	end
end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Offense Mode' then
		if newValue == 'None' then
			enable('main','sub','range')
		else
			disable('main','sub','range')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if default_spell_map == 'Cures' or default_spell_map == 'Curaga' then
			if (world.weather_element == 'Light' or world.day_element == 'Light') then
				return 'CureWithLightWeather'
			end
		elseif spell.skill == 'Enfeebling Magic' then
			if spell.type == 'WhiteMagic' then
				return 'MndEnfeebles'
			else
				return 'IntEnfeebles'
			end
		end
	end
end

function customize_idle_set(idleSet)
	if state.Buff['Sublimation: Activated'] then
		if state.IdleMode.value == 'Normal' then
			idleSet = set_combine(sets.idle, sets.buff.FullSublimation)
		elseif state.IdleMode.value == 'PDT' then
			idleSet = set_combine(sets.idle.PDT, sets.buff.FullSublimation)
		elseif state.IdleMode.value == 'MDT' then
			idleSet = set_combine(sets.idle.MDT, sets.buff.FullSublimation)
		end
	end

	return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	update_active_strategems()
	update_sublimation()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	display_current_caster_state()
	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'scholar' then
		handle_strategems(cmdParams)
		eventArgs.handled = true
	elseif cmdParams[1]:lower() == 'nuke' then
		handle_nuking(cmdParams)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Reset the state vars tracking strategems.
function update_active_strategems()
	state.Buff['Ebullience'] = buffactive['Ebullience'] or false
	state.Buff['Rapture'] = buffactive['Rapture'] or false
	state.Buff['Perpetuance'] = buffactive['Perpetuance'] or false
	state.Buff['Immanence'] = buffactive['Immanence'] or false
	state.Buff['Penury'] = buffactive['Penury'] or false
	state.Buff['Parsimony'] = buffactive['Parsimony'] or false
	state.Buff['Celerity'] = buffactive['Celerity'] or false
	state.Buff['Alacrity'] = buffactive['Alacrity'] or false

	state.Buff['Klimaform'] = buffactive['Klimaform'] or false
end

function update_sublimation()
	state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

-- Equip sets appropriate to the active buffs, relative to the spell being cast.
function apply_grimoire_bonuses(spell, action, spellMap)
	if state.Buff.Perpetuance and spell.type =='WhiteMagic' and spell.skill == 'Enhancing Magic' then
		equip(sets.buff['Perpetuance'])
	end
	if state.Buff.Rapture and (spellMap == 'Cures' or spellMap == 'Curaga') then
		equip(sets.buff['Rapture'])
	end
	if spell.skill == 'Elemental Magic' and spellMap ~= 'ElementalEnfeeble' then
		if state.Buff.Ebullience and spell.english ~= 'Impact' then
			equip(sets.buff['Ebullience'])
		end
		if state.Buff.Immanence then
			equip(sets.buff['Immanence'])
		end
		if state.Buff.Klimaform and spell.element == world.weather_element then
			equip(sets.buff['Klimaform'])
		end
	end

	if state.Buff.Penury then equip(sets.buff['Penury']) end
	if state.Buff.Parsimony then equip(sets.buff['Parsimony']) end
	if state.Buff.Celerity then equip(sets.buff['Celerity']) end
	if state.Buff.Alacrity then equip(sets.buff['Alacrity']) end
end


-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
	-- cmdParams[1] == 'scholar'
	-- cmdParams[2] == strategem to use

	if not cmdParams[2] then
		add_to_chat(123,'Error: No strategem command given.')
		return
	end
	local strategem = cmdParams[2]:lower()

	if strategem == 'light' then
		if buffactive['light arts'] then
			send_command('input /ja "Addendum: White" <me>')
		elseif buffactive['addendum: white'] then
			add_to_chat(122,'Error: Addendum: White is already active.')
		else
			send_command('input /ja "Light Arts" <me>')
		end
	elseif strategem == 'dark' then
		if buffactive['dark arts'] then
			send_command('input /ja "Addendum: Black" <me>')
		elseif buffactive['addendum: black'] then
			add_to_chat(122,'Error: Addendum: Black is already active.')
		else
			send_command('input /ja "Dark Arts" <me>')
		end
	elseif buffactive['light arts'] or buffactive['addendum: white'] then
		if strategem == 'cost' then
			send_command('input /ja Penury <me>')
		elseif strategem == 'speed' then
			send_command('input /ja Celerity <me>')
		elseif strategem == 'aoe' then
			send_command('input /ja Accession <me>')
		elseif strategem == 'power' then
			send_command('input /ja Rapture <me>')
		elseif strategem == 'duration' then
			send_command('input /ja Perpetuance <me>')
		elseif strategem == 'accuracy' then
			send_command('input /ja Altruism <me>')
		elseif strategem == 'enmity' then
			send_command('input /ja Tranquility <me>')
		elseif strategem == 'skillchain' then
			add_to_chat(122,'Error: Light Arts does not have a skillchain strategem.')
		elseif strategem == 'addendum' then
			send_command('input /ja "Addendum: White" <me>')
		else
			add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
		end
	elseif buffactive['dark arts']  or buffactive['addendum: black'] then
		if strategem == 'cost' then
			send_command('input /ja Parsimony <me>')
		elseif strategem == 'speed' then
			send_command('input /ja Alacrity <me>')
		elseif strategem == 'aoe' then
			send_command('input /ja Manifestation <me>')
		elseif strategem == 'power' then
			send_command('input /ja Ebullience <me>')
		elseif strategem == 'duration' then
			add_to_chat(122,'Error: Dark Arts does not have a duration strategem.')
		elseif strategem == 'accuracy' then
			send_command('input /ja Focalization <me>')
		elseif strategem == 'enmity' then
			send_command('input /ja Equanimity <me>')
		elseif strategem == 'skillchain' then
			send_command('input /ja Immanence <me>')
		elseif strategem == 'addendum' then
			send_command('input /ja "Addendum: Black" <me>')
		else
			add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
		end
	else
		add_to_chat(123,'No arts has been activated yet.')
	end
end


-- Gets the current number of available strategems based on the recast remaining
-- and the level of the sch.
function get_current_strategem_count()
	-- returns recast in seconds.
	local allRecasts = windower.ffxi.get_ability_recasts()
	local stratsRecast = allRecasts[231]

	local maxStrategems = (player.main_job_level + 10) / 20

	local fullRechargeTime = 4*60

	local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

	return currentCharges
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 4)
end
