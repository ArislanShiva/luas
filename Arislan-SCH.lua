-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
		Custom commands:

		Shorthand versions for each strategem type that uses the version appropriate for
		the current Arts.

										Light Arts				Dark Arts

		gs c scholar light			  	Light Arts/Addendum
		gs c scholar dark										Dark Arts/Addendum
		gs c scholar cost			   	Penury				  	Parsimony
		gs c scholar speed			  	Celerity				Alacrity
		gs c scholar aoe				Accession			   	Manifestation
		gs c scholar power			  	Rapture				 	Ebullience
		gs c scholar duration		   	Perpetuance
		gs c scholar accuracy		   	Altruism				Focalization
		gs c scholar enmity			 	Tranquility			 	Equanimity
		gs c scholar skillchain								 	Immanence
		gs c scholar addendum			Addendum: White		 	Addendum: Black
--]]



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
	state.OffenseMode:options('None', 'Normal')
	state.CastingMode:options('Normal', 'Seidr', 'Resistant')
	state.IdleMode:options('Normal', 'PDT', 'MDT')
	
	state.MagicBurst = M(false, 'Magic Burst')
	state.MPCoat = M(false, 'MP Coat')

    gear.default.weaponskill_waist = "Windbuffet Belt +1"	
	gear.default.obi_waist = "Yamabuki-no-Obi"
	gear.default.obi_back = "Lugh's Cape"
	gear.MPCoat = "Seidr Cotehardie"

	-- Additional local binds
	send_command('bind ^` input /ja Immanence <me>')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind ^- gs c scholar light')
	send_command('bind ^= gs c scholar dark')
	send_command('bind !- gs c scholar addendum')
	send_command('bind != gs c scholar addendum')
	send_command('bind ^[ gs c scholar power')
	send_command('bind ^] gs c scholar accuracy')
	send_command('bind ![ gs c scholar aoe')
	send_command('bind !] gs c scholar duration')
	send_command('bind ^, input /ma Sneak <stpc>')
	send_command('bind ^. input /ma Invisible <stpc>')
	
	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind ^[')
	send_command('unbind ^]')
	send_command('unbind ![')
	send_command('unbind !]')
	send_command('unbind ^,')
	send_command('unbind !.')
end



-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	---- Precast Sets ----
	
	-- Precast sets to enhance JAs
	
   sets.precast.JA['Tabula Rasa'] = {
		legs="Pedagogy Pants"
		}
	
	sets.precast.JA['Enlightenment'] = {
		body="Peda. Gown +1"
		}

	-- Fast cast sets for spells
	
	sets.precast.FC = {
	--	/RDM --15
		main="Sucellus", --5
		sub="Genmei Shield",
		ammo="Sapience Orb", --2
		head="Amalric Coif", --10
		body="Shango Robe", --8
		hands="Gende. Gages +1", --7
		legs="Psycloth Lappas", --7
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5
		back=gear.SCH_FC_Cape, --10
		waist="Witful Belt", --3/(3)
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		})

	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
		waist="Channeler's Stone", --2
		})
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		main="Sucellus", --5
		sub="Sors Shield", --5
		feet="Vanya Clogs", --15
		ear1="Mendi. Earring", --5
		ring1="Lebeche Ring", --(2)
		back="Perimede Cape", --(4)
		})
	
	sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	sets.precast.FC.Impact = set_combine(sets.precast.FC['Elemental Magic'], {
		head=empty,
		body="Twilight Cloak"
		})

	sets.precast.WS = {
		head="Telchine Cap",
		body="Onca Suit",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Lugh's Cape",
		waist=gear.ElementalBelt,
		}

	sets.precast.WS['Myrkr'] = {
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Peda. Gown +1",
		hands="Telchine Gloves",
		legs="Amalric Slops",
		feet="Arbatel Loafers +1",
		neck="Orunmila's Torque",
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		ring1="Mephitas's Ring +1",
		ring2="Mephitas's Ring",
		back="Pahtli Cape",
		waist="Luminary Sash",
		} -- Max MP

	sets.precast.WS['Omniscience'] = {
		ammo="Hydrocera",
		head="Befouled Crown",
		body="Vanya Robe",
		hands="Arbatel Bracers +1",
		legs="Merlinic Shalwar",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Static Earring",
		ear2="Moonshade Earring",
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		back=gear.SCH_FC_Cape,
		waist="Luminary Sash",
		} -- MND
	
	sets.precast.WS['Starburst'] = sets.precast.WS['Omniscience']
   

	---- Precast Sets ----
	
	sets.midcast.FastRecast = {
		head="Amalric Coif",
		hands="Gende. Gages +1",
		legs="Merlinic Shalwar",
		feet="Regal Pumps +1",
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		ring1="Prolix Ring",
		back=gear.SCH_FC_Cape,
		waist="Witful Belt",
		} -- Haste
	
	sets.midcast.Cure = {
		main="Tamaxchi", --22/(-10)
		sub="Sors Shield", --3/(-5)
		ammo="Leisure Musk +1", --0/(-4)
		head="Gende. Caubeen +1", --15/(-8)
		body="Kaykaus Bliaut", --5(+3)
		hands="Telchine Gloves", --10
		legs="Kaykaus Tights", --10/(-5)
		feet="Kaykaus Boots", --10/(-10)
		neck="Incanter's Torque",
		ear1="Mendi. Earring", --5
		ear2="Loquac. Earring",
		ring1="Lebeche Ring", --3/(-5)
		ring2="Haoma's Ring",
		back="Oretan. Cape +1", --6
		waist="Bishop's Sash",
		}

	sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
		main="Chatoyant Staff",
		})
	
	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		back=gear.SCH_FC_Cape,
		waist="Luminary Sash",
		})
	
	sets.midcast.StatusRemoval = {
		main="Tamaxchi",
		sub="Sors Shield",
		head="Vanya Hood",
		body="Vanya Robe",
		hands="Telchine Gloves",
		legs="Acad. Pants +1",
		feet="Vanya Clogs",
		neck="Incanter's Torque",
		ring1="Haoma's Ring",
		ring2="Haoma's Ring",
		back="Oretan. Cape +1",
		waist="Bishop's Sash",
		}
	
	sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
		main="Gada",
		sub="Genmei Shield",
		feet="Gende. Galosh. +1",
		neck="Malison Medallion",
		})
	
	sets.midcast['Enhancing Magic'] = {
		main="Gada",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chasuble",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		neck="Incanter's Torque",
		ear2="Andoaa Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Fi Follet Cape +1",
		waist="Olympus Sash",
		}
	
	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
		main="Bolelabunga",
		sub="Genmei Shield",
		head="Arbatel Bonnet +1",
		body="Telchine Chas.",
		back=gear.SCH_FC_Cape,
		})
	
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Gishdubar Sash",
		back="Grapevine Cape",
		})
		
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		legs="Acad. Pants +1",
		neck="Nodens Gorget",
		waist="Siegel Sash",
		})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
		main="Vadose Rod",
		head="Amalric Coif",
		})
	
--	sets.midcast.Storm = set_combine(sets.midcast['Enhancing Magic'], {
--		feet="Peda. Loafers +1",
--		})
	
	sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {
		ring2="Sheltered Ring",
		})

	sets.midcast.Protectra = sets.midcast.Protect
	sets.midcast.Shell = sets.midcast.Protect
	sets.midcast.Shellra = sets.midcast.Shell
	
	sets.midcast.EnhancingDuration = {
		main="Gada",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		}

	-- Custom spell classes
	sets.midcast.MndEnfeebles = {
		main="Akademos",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Amalric Coif",
		body="Vanya Robe",
		hands="Kaykaus Cuffs",
		legs="Psycloth Lappas",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Barkaro. Earring",
		ear2="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back=gear.SCH_FC_Cape,
		waist="Luminary Sash",
		}
	
	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		back=gear.SCH_MAB_Cape,
		})

	sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles
	
	sets.midcast['Dark Magic'] = {
		main="Akademos",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Amalric Coif",
		body="Shango Robe",
		hands="Amalric Gages",
		legs="Psycloth Lappas",
		feet="Medium's Sabots",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Digni. Earring",
		ring1="Evanescence Ring",
		ring2="Stikini Ring",
		back=gear.SCH_MAB_Cape,
		waist=gear.ElementalObi,
		}
	
	sets.midcast.Kaustra = {
		main="Akademos",
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Merlinic Jubbah",
		hands="Amalric Gages",
		legs="Merlinic Shalwar",
		feet="Merlinic Crackows",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.SCH_MAB_Cape,
		waist=gear.ElementalObi,
		}
	
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Pixie Hairpin +1",
		ear2="Hirudinea Earring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		})
	
	sets.midcast.Aspir = sets.midcast.Drain
	
	sets.midcast.Stun = sets.midcast['Dark Magic']
	
	-- Elemental Magic
	sets.midcast['Elemental Magic'] = {
		main="Akademos",
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head="Merlinic Hood",
		body="Merlinic Jubbah",
		hands="Amalric Gages",
		legs="Merlinic Shalwar",
		feet="Merlinic Crackows",
		neck="Saevus Pendant +1",
		ear1="Barkaro. Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.SCH_MAB_Cape,
		waist=gear.ElementalObi,
		}

	sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
		body="Seidr Cotehardie",
		neck="Sanctity Necklace",
		})
		
	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		neck="Sanctity Necklace",
		ear2="Hermetic Earring",
		waist="Yamabuki-no-Obi",
		})
	
	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
		head=empty,
		body="Twilight Cloak",
		ring1="Archon Ring",
		})
	
	sets.midcast.Helix = set_combine(sets.midcast['Elemental Magic'], {
		main="Akademos",
		sub="Niobid Strap",
		ammo="Ghastly Tathlum +1",
		waist="Yamabuki-no-Obi",
		})

	sets.midcast.DarkHelix = set_combine(sets.midcast.Helix, {
		head="Pixie Hairpin +1",
		ring2="Archon Ring",
		})

	sets.midcast.LightHelix = set_combine(sets.midcast.Helix, {
		ring2="Weather. Ring"
		})
	
	------------------------------------------------------------------------------------------------
	------------------------------------------ Idle Sets -------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.idle = {
		main="Bolelabunga",
		sub="Genmei Shield",
		ammo="Homiliary",
		head="Befouled Crown",
		body="Witching Robe",
		hands="Gende. Gages +1",
		legs="Assiduity Pants +1",
		feet="Herald's Gaiters",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Umbra Cape",
		waist="Refoccilation Stone",
		}

	sets.idle.PDT = set_combine(sets.idle, {
		main="Bolelabunga",
		sub="Genmei Shield",
		head="Gende. Caubeen +1",
		body="Vanya Robe",
		hands="Gende. Gages +1",
		legs="Artsieq Hose",
		feet="Arbatel Loafers +1",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
		back="Umbra Cape",
		})

	sets.idle.MDT = set_combine(sets.idle, {
		ammo="Vanir Battery",
		head="Gende. Caubeen +1",
		body="Vanya Robe",
		hands="Gende. Gages +1",
		legs="Gyve Trousers",
		feet="Arbatel Loafers +1",
		neck="Loricate Torque +1",
		ear1="Odnowa Earring",
		ear2="Etiolation Earring",
		ring1="Shadow Ring",
		ring2="Defending Ring",
		back="Solemnity Cape",
		waist="Lieutenant's Sash",
		})

	sets.idle.Town = set_combine(sets.idle, {
		main="Akademos",
		sub="Niobid Strap",
		head="Merlinic Hood",
		body="Merlinic Jubbah",
		hands="Arbatel Bracers +1",
		legs="Merlinic Shalwar",
		ear1="Barkaro. Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.SCH_MAB_Cape,
		})
	
	sets.resting = set_combine(sets.idle, {
		main="Chatoyant Staff",
		waist="Austerity Belt +1",
		})
	
	------------------------------------------------------------------------------------------------
	---------------------------------------- Defense Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.defense.PDT = {
		main="Bolelabunga",
		sub="Genmei Shield", --10
		head="Gende. Caubeen +1", --4
		body="Vanya Robe", --1
		hands="Gende. Gages +1", --4
		legs="Artsieq Hose", --5
		feet="Arbatel Loafers +1",
 		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Gelatinous Ring +1", --7
		ring2="Defending Ring", --10
		back="Umbra Cape", --6
		}
	
	sets.defense.MDT = {
		ammo="Vanir Battery",
		head="Gende. Caubeen +1", --4
		body="Vanya Robe", --1
		hands="Gende. Gages +1", --3
		legs="Gyve Trousers", --2
		feet="Arbatel Loafers +1",
		neck="Loricate Torque +1", --6
		ear1="Odnowa Earring", --2
		ear2="Etiolation Earring", --2
		ring1="Shadow Ring",
		ring2="Defending Ring", --10
		back="Solemnity Cape", --4
		waist="Lieutenant's Sash", --2
		}
	
	sets.Kiting = {
		feet="Herald's Gaiters"
		}
	
	sets.latent_refresh = {
		waist="Fucho-no-obi"
		}
	
	------------------------------------------------------------------------------------------------
	---------------------------------------- Engaged Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.engaged = {
		head="Telchine Cap",
		body="Onca Suit",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Grunfeld Rope",
		back="Relucent Cape",
		}
	
	------------------------------------------------------------------------------------------------
	---------------------------------------- Special Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.magic_burst = { -- Staff 10
		body="Merlinic Jubbah", --10
		hands="Amalric Gages", --(5)
		legs="Merlinic Shalwar", --6
		feet="Merlinic Crackows", --11
		neck="Mizu. Kubikazari", --10
		ring1="Mujin Band", --(5)
		}
	
	sets.buff['Ebullience'] = {head="Arbatel Bonnet +1"}
	sets.buff['Rapture'] = {head="Arbatel Bonnet +1"}
	sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
	sets.buff['Immanence'] = {hands="Arbatel Bracers +1", "Lugh's Cape"}
	sets.buff['Penury'] = {legs="Arbatel Pants +1"}
	sets.buff['Parsimony'] = {legs="Arbatel Pants +1"}
	sets.buff['Celerity'] = {feet="Peda. Loafers +1"}
	sets.buff['Alacrity'] = {feet="Peda. Loafers +1"}
	sets.buff['Klimaform'] = {feet="Arbatel Loafers +1"}
	
	sets.buff.FullSublimation = {
		head="Acad. Mortar. +1",
		ear1="Savant's Earring",
		body="Peda. Gown +1",
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
		equip(sets.magic_burst)
		if spell.english == "Impact" then
			equip(sets.midcast.Impact)
		end
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
		if state.Buff.Perpetuance then
			equip(sets.buff['Perpetuance'])
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
		if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
			if world.weather_element == 'Light' then
				return 'CureWeather'
			end
		elseif spell.skill == 'Enfeebling Magic' then
			if spell.type == 'WhiteMagic' then
				return 'MndEnfeebles'
			else
				return 'IntEnfeebles'
			end
--[[		elseif spell.skill == 'Elemental Magic' then
			if info.low_nukes:contains(spell.english) then
				return 'LowTierNuke'
			elseif info.mid_nukes:contains(spell.english) then
				return 'MidTierNuke'
			elseif info.high_nukes:contains(spell.english) then
				return 'HighTierNuke'
			end --]]
		end
	end
end

function customize_idle_set(idleSet)
	if state.Buff['Sublimation: Activated'] then
		if state.IdleMode.value == 'Normal' then
			idleSet = set_combine(idleSet, sets.buff.FullSublimation)
		elseif state.IdleMode.value == 'PDT' then
			idleSet = set_combine(idleSet, sets.buff.PDTSublimation)
		end
	end

	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
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
	if state.Buff.Rapture and (spellMap == 'Cure' or spellMap == 'Curaga') then
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
	set_macro_page(1, 9)
end
