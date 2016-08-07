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
	state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
	state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('None', 'Normal')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')

	-- Additional local binds
	send_command('bind ^- input /ja "Light Arts" <me>')
	send_command('bind ^[ input /ja "Divine Seal" <me>')
	send_command('bind ^] input /ja "Divine Caress" <me>')
	send_command('bind ![ input /ja "Accession" <me>')

	select_default_macro_book()
end

function user_unload()
	send_command('unbind ^-')
	send_command('unbind ^[')
	send_command('unbind ^]')
	send_command('unbind ![')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	-- Precast Sets

	-- Precast sets to enhance JAs
	sets.precast.JA.Benediction =
	{
        body="Piety Briault +1"
    }

	sets.precast.JA.Martyr =
	{
        "Piety Mitts +1"
    }

	sets.precast.JA['Convert'] =
	{
		ammo="Psilomene",
		head="Vanya Hood", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Mendi. Earring",
		body="Ebers Bliaud +1", hands="Telchine Gloves", lring="Lebeche Ring", rring="Mephitas's Ring +1",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Gyve Trousers", feet="Amalric Nails"
	}


	-- Fast cast sets for spells
	sets.precast.FC =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Staunch Tathlum",
		head="Vanya Hood", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
        body="Inyanga Jubbah +1", hands="Fanatic Gloves", lring="Evanescence Ring", rring="Prolix Ring",
        back="Alaunus's Cape", waist="Witful Belt", legs="Lengo Pants", feet="Telchine Pigaches"
	}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC,
	{
		waist="Siegel Sash"
	})

	sets.precast.FC['Enfeebling Magic'] = set_combine(sets.precast.FC,
	{
		waist="Emphatikos Rope"
	})

	sets.precast.FC['Divine Magic'] = sets.precast.FC['Enfeebling Magic']

	sets.precast.FC['Elemental Magic'] = sets.precast.FC['Divine Magic']

	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC,
	{
		main=gear.Grioavolr_Enh,
		head="Umuthi Hat",
		hands="Carapacho Cuffs",
		waist="Siegel Sash"
	})

	sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC,
	{
		waist="Emphatikos Rope", legs="Ebers Pant. +1"
	})

	sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

	sets.precast.FC.Cures = set_combine(sets.precast.FC,
	{
		main="Queller Rod", Sub="Sors Shield",
		neck="Aceso's Choker +1", rear="Mendi. Earring",
		waist="Emphatikos Rope", legs="Ebers Pant. +1", feet="Hygieia Clogs +1"
	})

	sets.precast.FC.Curaga = sets.precast.FC.Cures

	sets.precast.FC.Teleport = sets.precast.FC

	sets.precast.FC.Reraise = sets.precast.FC

	sets.precast.FC.Raise = sets.precast.FC

	sets.precast.FC.Statless = sets.precast.FC

	sets.precast.FC.Impact = set_combine(sets.precast.FC,
	{
		ammo="Psilomene",
		head=empty,
		body="Twilight Cloak",
		waist="Emphatikos Rope"
	})

	-- Midcast Sets

	sets.midcast.FC = sets.precast.FC

	sets.midcast.ConserveMP = set_combine(sets.midcast.FC,
	{
		ammo="Pemphredo Tathlum",
		neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
		body="Kaykaus Bliaut",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Lengo Pants", feet="Hygieia Clogs +1"
	})

	-- Cure sets

	sets.midcast.CureSolace =
	{
		main="Queller Rod", Sub="Sors Shield", ammo="Esper Stone +1",
		head="Vanya Hood", neck="Incanter's Torque", lear="Glorious Earring", rear="Mendi. Earring",
        body="Ebers Bliaud +1", hands="Kaykaus Cuffs", lring="Lebeche Ring", rring="Prolix Ring",
        back="Alaunus's Cape", waist="Hachirin-no-Obi", legs="Sifahir Slacks", feet="Vanya Clogs"
	}

	sets.midcast.Cures =
	{
		main="Chatoyant Staff", sub="Achaq Grip", ammo="Esper Stone +1",
		head="Vanya Hood", neck="Orunmila's Torque", lear="Glorious Earring", rear="Mendi. Earring",
        body="Kaykaus Bliaut", hands="Kaykaus Cuffs", lring="Lebeche Ring", rring="Prolix Ring",
        back="Twilight Cape", waist="Hachirin-no-Obi", legs="Sifahir Slacks", feet="Hygieia Clogs +1"
	}
	sets.midcast.Curaga = sets.midcast.Cures

	sets.midcast.StatusRemoval = set_combine(sets.precast.FC['Healing Magic'],
	{
		ammo="Pemphredo Tathlum",
		waist="Witful Belt"
	})

	sets.midcast.Cursna = set_combine(sets.precast.FC['Healing Magic'],
	{
		main="Queller Rod", sub="Sors Shield",
		head="Ebers Cap +1", neck="Debilis Medallion",
        body="Ebers Bliaud +1", lring="Haoma's Ring", rring="Haoma's Ring",
        waist="Witful Belt", legs="Theo. Pant. +1", feet="Gende. Galosh. +1"
	})

	sets.midcast.StatusRemoval = set_combine(sets.precast.FC.StatusRemoval,
	{
		main="Queller Rod", sub="Thuellaic Ecu +1",
		head="Ebers Cap +1",
		lring="Lebeche Ring", rring="Prolix Ring",
		waist="Witful Belt",
	})

	sets.midcast['Healing Magic'] = sets.precast.FC['Healing Magic']

	sets.midcast.Duration =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Alaunus's Cape", waist="Olympus Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Stoneskin =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Stone Gorget", lear="Andoaa Earring", rear="Earthcry Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Alaunus's Cape", waist="Siegel Sash", legs="Shedir Seraweels", feet="Telchine Pigaches"
	}

	sets.midcast.Aquaveil = set_combine(sets.midcast.Duration,
	{
		main="Vadose Rod", sub="Thuellaic Ecu +1",
		head="Chironic Hat", waist="Emphatikos Rope", legs="Shedir Seraweels"
	})

	sets.midcast.Auspice = set_combine(sets.midcast.Duration,
	{
		feet="Ebers Duckbills +1"
	})

	sets.midcast.BarElement =
	{
		main="Beneficus", sub="Thuellaic Ecu +1",
		head="Ebers Cap +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
        body="Ebers Bliaud +1", hands="Ebers Mitts +1", lring="Stikini Ring", rring="Stikini Ring",
        back="Alaunus's Cape", waist="Luminary Sash", legs="Piety Pantaln. +1", feet="Ebers Duckbills +1"
	}

	sets.midcast.BarStatus =
	{
		main="Beneficus", sub="Thuellaic Ecu +1",
		head="Ebers Cap +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
        body="Ebers Bliaud +1", hands="Ebers Mitts +1", lring="Stikini Ring", rring="Stikini Ring",
        back="Alaunus's Cape", waist="Luminary Sash", legs="Piety Pantaln. +1", feet="Ebers Duckbills +1"
	}

	sets.midcast.BoostStat =
	{
		main="Gada", sub="Thuellaic Ecu +1",
		head="Telchine Cap", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
		body="Telchine Chas.", hands="Dynasty Mitts", lring="Stikini Ring", rring="Stikini Ring",
		back="Fi Follet Cape +1", waist="Olympus Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Regen =
	{
		main="Bolelabunga", sub="Thuellaic Ecu +1", ammo="Pemphredo Tathlum",
		head="Inyanga Tiara +1", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Piety Briault +1", hands="Ebers Mitts +1", lring="Lebeche Ring", rring="Prolix Ring",
        back="Fi Follet Cape +1", waist="Luminary Sash", legs="Theo. Pant. +1", feet="Telchine Pigaches"
	}

	sets.midcast.Refresh =
	{
		gear.Grioavolr_Enh, sub="Clerisy Strap", ammo="Pemphredo Tathlum",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Lebeche Ring", rring="Prolix Ring",
        back="Grapevine Cape", waist="Gishdubar Sash", legs="Telchine Braconi", feet="Inspirited Boots"
	}

	sets.midcast.Statless = sets.midcast.Duration

	sets.midcast.Storm = sets.midcast.Duration

	sets.midcast.Protectra = set_combine(sets.midcast.Duration,
	{
		lring="Sheltered Ring", feet="Piety Duckbills +1"
	})

	sets.midcast.Protect = sets.midcast.Duration

	sets.midcast.Shellra = set_combine(sets.midcast.Duration,
	{
		lring="Sheltered Ring", legs="Piety Pantaln. +1"
	})

	sets.midcast.Shell = sets.midcast.Duration

	sets.midcast.Teleport = sets.midcast.ConserveMP

	sets.midcast.Reraise = sets.midcast.ConserveMP

	sets.midcast.Raise = sets.midcast.ConserveMP

	sets.midcast.Macc =
	{
		main=gear.Grioavolr_Enf, sub="Mephitis Grip", ammo="Pemphredo Tathlum",
		head="Befouled Crown", neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Vanya Robe", hands="Inyan. Dastanas +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Alaunus's Cape", waist="Luminary Sash", legs="Chironic Hose", feet="Medium's Sabots"
	}

	sets.midcast['Divine Magic'] = set_combine(sets.midcast.Macc,
    {
        sub="Clerisy Strap"
    })

	sets.midcast['Dark Magic'] = set_combine(sets.midcast.Macc,
	{
		main=gear.Grioavolr_Enf, sub="Clerisy Strap",
		head="Pixie Hairpin +1",
		body="Shango Robe", lring="Archon Ring", rring="Stikini Ring",
		waist="Fucho-no-Obi"
	})

	sets.midcast.Sap = set_combine(sets.midcast['Dark Magic'],
	{
		body="Chironic Doublet", lring="Evanescence Ring", rring="Archon Ring"
	})

	sets.midcast.DivineNuke =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head="Chironic Hat", neck="Sanctity Necklace", lear="Friomisi Earring", rear="Hecate's Earring",
        body="Chironic Doublet", hands="Chironic Gloves", lring="Acumen Ring", rring="Levia. Ring",
        back="Seshaw Cape", waist="Hachirin-no-Obi", legs="Chironic Hose", feet="Chironic Slippers"
	}

	sets.midcast['Elemental Magic'] = set_combine(sets.midcast.DivineNuke,
	{
		rring="Shiva Ring",
		waist="Refoccilation Stone"
	})

	sets.midcast.Impact = set_combine(sets.midcast.Banish,
	{
		head=empty,
		body="Twilight Cloak",lring="Archon Ring", rring="Shiva Ring",
		waist="Eschan Stone"
	})


	-- Idle sets
	sets.idle =
	{
		main="Bolelabunga", sub="Genmei Shield", ammo="Homiliary",
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

	sets.idle.MDT = set_combine(sets.idle,
	{
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
        hands="Inyan. Dastanas +1", lring="Defending Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Luminary Sash", feet="Inyan. Crackows +1"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		feet="Crier's Gaiters"
	})

	sets.idle.Weak = sets.idle.MDT

	-- Defense sets

	sets.defense.PDT = set_combine(sets.idle.PDT,
	{
		ammo="Staunch Tathlum",
		legs="Artsieq Hose"
	})

	sets.defense.MDT = set_combine(sets.idle.MDT,
	{
		main=gear.Grioavolr_Enf, sub="Irenic Strap", ammo="Staunch Tathlum",
		head="Inyanga Tiara +1",
        body="Inyanga Jubbah +1",
        legs="Inyanga Shalwar +1"
	})

	sets.Kiting =
	{
		feet="Crier's Gaiters"
	}

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	sets.buff['Divine Caress'] =
	{
        hands="Ebers Mitts +1", back="Mending Cape"
    }

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
	if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
		equip(sets.buff['Divine Caress'])
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if stateField == 'Offense Mode' then
		if newValue == 'Normal' then
			disable('main','sub','range')
		else
			enable('main','sub','range')
		end
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if default_spell_map == 'Cures' and state.Buff['Afflatus Solace'] then
			return "CureSolace"
		elseif spell.skill == "Enfeebling Magic" then
			return "Macc"
		end
	end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
	display_current_caster_state()
	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	set_macro_page(1, 2)
end
