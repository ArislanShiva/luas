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
	state.IdleMode:options('Normal', 'PDT', 'MDT')

	-- Additional local binds
	send_command('bind ^` input /ja "Afflatus Solace" <me>')
	send_command('bind !` input /ja "Afflatus Misery" <me>')
	send_command('bind ^- input /ja "Light Arts" <me>')
	send_command('bind ^[ input /ja "Divine Seal" <me>')
	send_command('bind ^] input /ja "Divine Caress" <me>')
	send_command('bind ![ input /ja "Accession" <me>')
	send_command('bind ^, input /ma Sneak <stpc>')
	send_command('bind ^. input /ma Invisible <stpc>')

	select_default_macro_book()
end

function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^[')
	send_command('unbind ^]')
	send_command('unbind ![')
	send_command('unbind ^,')
	send_command('unbind !.')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	-- Precast Sets

	-- Fast cast sets for spells

	sets.precast.FC = {
	--	/SCH --10
		main="Sucellus", --5
		sub="Genmei Shield",
		ammo="Sapience Orb", --2
		head="Vanya Hood", --10
		body="Inyanga Jubbah +1", --13
		hands="Gende. Gages +1", --7
		legs="Artsieq Hose", --5
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Etiolation Earring", --1
		ear2="Loquacious Earring", --2
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5
		back="Alaunus's Cape", --10
		waist="Witful Belt", --3/(2)
		}
		
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		})

	sets.precast.FC.Stoneskin = sets.precast.FC['Enhancing Magic']

	sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {
		main="Vadose Rod",
		sub="Sors Shield",
		legs="Ebers Pant. +1",
		})

	sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

	sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
		main="Vadose Rod", --5
		sub="Sors Shield", --5
		head="Piety Cap +1", --13
		legs="Ebers Pant. +1", --13
		feet="Vanya Clogs", --15
		ear1="Nourish. Earring +1", --4
		ear2="Mendi. Earring", --5
		ring1="Lebeche Ring", --(2)
		})

	sets.precast.FC.Curaga = sets.precast.FC.Cure

	sets.precast.FC.CureSolace = sets.precast.FC.Cure

	sets.precast.FC.Impact = set_combine(sets.precast.FC, {
		head=empty,
		body="Twilight Cloak"
	})

	-- CureMelee spell map should default back to Healing Magic.
	
	-- Precast sets to enhance JAs
	sets.precast.JA.Benediction = {}
	
	-- Weaponskill sets

	-- Default set for any weaponskill that isn't any more specifically defined

	sets.precast.WS = {
		head="Telchine Cap",
		body="Onca Suit",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist=gear.ElementalBelt,
		}	

	-- Midcast Sets
	
	sets.midcast.FC = {
		head="Piety Cap +1",
		body="Inyanga Jubbah +1",
		hands="Fanatic Gloves",
		legs="Ebers Pant. +1",
		feet="Vanya Clogs",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		ring1="Prolix Ring",
		back="Swith Cape +1",
		waist="Witful Belt",
		} -- Haste
	
	-- Cure sets

	sets.midcast.CureSolace = {
		main="Queller Rod", --15(+2)/(-15)
		sub="Sors Shield", --3/(-5)
		ammo="Leisure Musk +1", --0/(-4)
		head="Gende. Caubeen +1", --15/(-8)
		body="Ebers Bliaud +1",
		hands="Theo. Mitts +1", --0/(-5)
		legs="Ebers Pant. +1",
		feet="Kaykaus Boots", --10/(-10)
		neck="Incanter's Torque",
		ear1="Nourish. Earring +1", --7
		ear2="Glorious Earring", -- (+2)/(-5)
		ring1="Lebeche Ring", --3/(-5)
		ring2="Haoma's Ring",
		back="Alaunus's Cape",
		waist="Bishop's Sash",
		}

	sets.midcast.Cure = sets.midcast.CureSolace

	sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
		main="Chatoyant Staff",
		waist=gear.ElementalObi,
		})

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		waist="Luminary Sash",
		})

	sets.midcast.CureMelee = sets.midcast.CureSolace

	sets.midcast.Cursna = {
		main="Queller Rod",
		sub="Genmei Shield",
		ammo="Hydrocera",
		head="Ebers Cap +1",
		body="Ebers Bliaud +1",
		hands="Fanatic Gloves",
		legs="Theo. Pant. +1",
		feet="Gende. Galosh. +1",
		neck="Malison Medallion",
		ring1="Haoma's Ring",
		ring2="Haoma's Ring",
		back="Alaunus's Cape",
		waist="Bishop's Sash",
		}

	sets.midcast.StatusRemoval = {
		main="Chatoyant Staff",
		sub="Clemency Grip",
		ammo="Hydrocera",
		head="Ebers Cap +1",
		body="Ebers Bliaud +1",
		hands="Fanatic Gloves",
		legs="Piety Pantaln. +1",
		feet="Vanya Clogs",
		neck="Incanter's Torque",
		ring1="Haoma's Ring",
		ring2="Haoma's Ring",
		back="Mending Cape",
		waist="Bishop's Sash",
		}

	-- 110 total Enhancing Magic Skill; caps even without Light Arts
	sets.midcast['Enhancing Magic'] = {
		main="Beneficus",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		neck="Incanter's Torque",
		ear2="Andoaa Earring",
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		back="Fi Follet Cape +1",
		waist="Olympus Sash",
		}

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
		main="Bolelabunga",
		sub="Genmei Shield",
		head="Inyanga Tiara +1",
		body="Piety Briault +1",
		hands="Ebers Mitts +1",
		legs="Theo. Pant. +1",
		})
	
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Gishdubar Sash",
		back="Grapevine Cape",
		})

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Nodens Gorget",
		waist="Siegel Sash",
		})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
		main="Vadose Rod",
		})

	sets.midcast.Auspice = set_combine(sets.midcast['Enhancing Magic'], {
		feet="Ebers Duckbills +1"
		})

	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
		head="Ebers Cap +1",
		body="Ebers Bliaud +1",
		hands="Ebers Mitts +1",
		legs="Piety Pantaln. +1",
		feet="Ebers Duckbills +1"
		})

	sets.midcast.BoostStat = set_combine(sets.midcast['Enhancing Magic'], {
		feet="Ebers Duckbills +1"
		})

	sets.midcast.Protectra = set_combine(sets.midcast['Enhancing Magic'], {
		ring1="Sheltered Ring",
		})

	sets.midcast.Shellra = sets.midcast.Protectra


	sets.midcast['Divine Magic'] = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		body="Vanya Robe",
		hands="Fanatic Gloves",
		feet="Medium's Sabots",
		neck="Incanter's Torque",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Globidonta Ring",
		ring2="Weather. Ring",
		back="Mending Cape",
		waist=gear.ElementalObi,
		}

	sets.midcast['Dark Magic'] = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Telchine Cap",
		body="Shango Robe",
		hands="Fanatic Gloves",
		legs="Assid. Pants +1",
		feet="Medium's Sabots",
		neck="Incanter's Torque",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Evanescence Ring",
		ring2="Weather. Ring",
		back="Aurist's Cape +1",
		waist=gear.ElementalObi,
		}

	-- Custom spell classes
	sets.midcast.MndEnfeebles = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Hydrocera",
		head="Befouled Crown",
		body="Inyanga Jubbah +1",
		hands="Inyan. Dastanas +1",
		legs="Assid. Pants +1",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Globidonta Ring",
		ring2="Levia. Ring +1",
		back="Alaunus's Cape",
		waist="Luminary Sash",
		}

	sets.midcast.IntEnfeebles = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Inyanga Jubbah +1",
		hands="Inyan. Dastanas +1",
		legs="Assid. Pants +1",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back="Aurist's Cape +1",
		waist="Yamabuki-no-Obi",
		}

	sets.midcast.Impact = {
		head=empty,
		body="Twilight Cloak",
		ring2="Archon Ring",
		}
	
	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {
		main="Chatoyant Staff",
		waist="Austerity Belt +1",
		}
	

	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle = {
		main="Bolelabunga",
		sub="Genmei Shield",
		ammo="Homiliary",
		head="Befouled Crown",
		body="Witching Robe",
		hands="Gende. Gages +1",
		legs="Assid. Pants +1",
		feet="Herald's Gaiters",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Umbra Cape",
		waist="Austerity Belt +1",
		}

	sets.idle.PDT = set_combine(sets.idle, {
		main="Bolelabunga",
		sub="Genmei Shield",
		head="Gende. Caubeen +1",
		body="Vanya Robe",
		hands="Gende. Gages +1",
		legs="Artsieq Hose",
		feet="Ebers Duckbills +1",
		ear1="Genmei Earring",
		neck="Loricate Torque +1",
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
		back="Umbra Cape",
		})

	sets.idle.MDT = set_combine(sets.idle, {
		head="Inyanga Tiara +1",
		body="Inyanga Jubbah +1",
		hands="Inyan. Dastanas +1",
		feet="Ebers Duckbills +1",
		neck="Loricate Torque +1",
		ear1="Etiolation Earring",
		ring1="Defending Ring",
		back="Solemnity Cape",
		})

	sets.idle.Town = set_combine(sets.idle, {
		main="Queller Rod",
		sub="Genmei Shield",
		head="Ebers Cap +1",
		body="Ebers Bliaud +1",
		hands="Ebers Mitts +1",
		legs="Ebers Pant. +1",
		neck="Incanter's Torque",
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		ear1="Nourish. Earring +1",
		ear2="Glorious Earring",
		back="Alaunus's Cape",
		})
	
	sets.idle.Weak = sets.idle
	
	-- Defense sets

	sets.defense.PDT = {
		main="Bolelabunga",
		sub="Genmei Shield", --10
		head="Gende. Caubeen +1", --4
		body="Vanya Robe", --1
		hands="Gende. Gages +1", --4
		legs="Artsieq Hose", --5
		feet="Ebers Duckbills +1",
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Defending Ring", --10
		ring2="Gelatinous Ring +1", --7
		back="Umbra Cape", --6
		}

	sets.defense.MDT = {
		head="Inyanga Tiara +1", --4
		body="Inyanga Jubbah +1", --7
		hands="Inyan. Dastanas +1", --3
		feet="Ebers Duckbills +1",
		neck="Loricate Torque +1", --6
		ear1="Etiolation Earring", --3
		ring1="Defending Ring", --10
		back="Solemnity Cape", --4
		}

	sets.Kiting = {
		feet="Herald's Gaiters"
		}

	sets.latent_refresh = {
		waist="Fucho-no-obi"
		}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Basic set for if no TP weapon is defined.
	sets.engaged = {
		head="Telchine Cap",
		body="Onca Suit",
		neck="Lissome Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Eschan Stone",
		back="Aurist's Cape +1",
		}


	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	sets.buff['Divine Caress'] = {
		back="Mending Cape",
		}

	sets.buff['Devotion'] = {
		head="Piety Cap +1",
		}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.english == "Paralyna" and buffactive.Paralyzed then
		-- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
		eventArgs.handled = true
	end
	
	if spell.skill == 'Healing Magic' then
		gear.default.obi_back = "Mending Cape"
	else
		gear.default.obi_back = "Toro Cape"
	end
end


function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
	if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
		equip(sets.buff['Divine Caress'])
	elseif default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
		if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
			if world.weather_element == 'Light' then
				return 'CureWeather'
			end
		end
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
		if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
			return "CureMelee"
		elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
			return "CureSolace"
		elseif spell.skill == "Enfeebling Magic" then
			if spell.type == "WhiteMagic" then
				return "MndEnfeebles"
			else
				return "IntEnfeebles"
			end
		end
	end
end


function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
	end
	return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
--[[if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
		local needsArts = 
			player.sub_job:lower() == 'sch' and
			not buffactive['Light Arts'] and
			not buffactive['Addendum: White'] and
			not buffactive['Dark Arts'] and
			not buffactive['Addendum: Black']
			
		if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
			if needsArts then
				send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
			else
				send_command('@input /ja "Afflatus Solace" <me>')
			end
		end
	end--]]
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
	set_macro_page(1, 4)
end
