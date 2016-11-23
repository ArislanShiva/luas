-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:
		
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Auto. Lockstyle		Automatically locks desired equipset on file load
--]]

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
	state.OffenseMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'DT')
	
	state.WeaponLock = M(false, 'Weapon Lock')	
	state.CP = M(false, "Capacity Points Mode")

	-- Additional local binds
	send_command('bind ^` input /ja "Afflatus Solace" <me>')
	send_command('bind !` input /ja "Afflatus Misery" <me>')
	send_command('bind ^- input /ja "Light Arts" <me>')
	send_command('bind ^[ input /ja "Divine Seal" <me>')
	send_command('bind ^] input /ja "Divine Caress" <me>')
	send_command('bind ![ input /ja "Accession" <me>')
	send_command('bind !o input /ma "Regen IV" <stpc>')
	send_command('bind ^, input /ma Sneak <stpc>')
	send_command('bind ^. input /ma Invisible <stpc>')
	send_command('bind @c gs c toggle CP')
	send_command('bind @w gs c toggle WeaponLock')

	select_default_macro_book()
	set_lockstyle()
end

function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^[')
	send_command('unbind ^]')
	send_command('unbind ![')
	send_command('unbind !o')
	send_command('unbind ^,')
	send_command('unbind !.')
	send_command('unbind @c')
	send_command('unbind @w')
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
		sub="Chanter's Shield", --3
		ammo="Sapience Orb", --2
		head="Vanya Hood", --10
		body="Inyanga Jubbah +1", --13
		hands="Gende. Gages +1", --7
		legs="Kaykaus Tights", --6
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5
		back="Alaunus's Cape", --10
		waist="Witful Belt", --3/(2)
		}
		
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		back="Perimede Cape",
		waist="Siegel Sash",
		})

	sets.precast.FC.Stoneskin = sets.precast.FC['Enhancing Magic']

	sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {
		main="Vadose Rod",
		sub="Sors Shield",
		legs="Ebers Pant. +1",
		back="Perimede Cape",
		})

	sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

	sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
		main="Sucellus", --5
		sub="Sors Shield", --5
		ammo="Impatiens",
		head="Piety Cap +1", --13
		legs="Ebers Pant. +1", --13
		feet="Vanya Clogs", --15
		ear1="Nourish. Earring +1", --4
		ear2="Mendi. Earring", --5
		ring1="Lebeche Ring", --(2)
		back="Perimede Cape", --(4)
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
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Telos Earring",
		ring1="Rufescent Ring",
		ring2="Ramuh Ring +1",
		waist="Fotia Belt",
		}	

	-- Midcast Sets
	
	sets.midcast.FC = {
		head="Piety Cap +1",
		body="Inyanga Jubbah +1",
		hands="Fanatic Gloves",
		legs="Ebers Pant. +1",
		feet="Vanya Clogs",
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		ring1="Prolix Ring",
		back="Swith Cape +1",
		waist="Witful Belt",
		} -- Haste
	
	-- Cure sets

	sets.midcast.CureSolace = {
		main="Queller Rod", --15(+2)/(-15)
		sub="Sors Shield", --3/(-5)
		ammo="Esper Stone +1", --0/(-5)
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
		sub="Clerisy Strap +1",
		hands="Kaykaus Cuffs", --10/(-6)
		back="Solemnity Cape", --7/0
		waist="Hachirin-no-Obi",
		})

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		body="Kaykaus Bliaut", --5(+3)
		legs="Kaykaus Tights", --10/(-5)
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		waist="Luminary Sash",
		})

	sets.midcast.CureMelee = sets.midcast.CureSolace

	sets.midcast.StatusRemoval = {
		main="Chatoyant Staff",
		sub="Clemency Grip",
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
		
	sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
		main="Gada",
		sub="Genmei Shield",
		legs="Theo. Pant. +1", --15
		feet="Gende. Galosh. +1", --10
		neck="Malison Medallion", --10
		back="Alaunus's Cape", --25
		}) -- 105%

	-- 110 total Enhancing Magic Skill; caps even without Light Arts
	sets.midcast['Enhancing Magic'] = {
		main="Gada",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Ebers Duckbills +1",
		neck="Incanter's Torque",
		ear2="Andoaa Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Fi Follet Cape +1",
		waist="Olympus Sash",
		}

	sets.midcast.EnhancingDuration = set_combine(sets.midcast['Enhancing Magic'], {
		main="Gada",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		})

	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
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
		feet="Ebers Duckbills +1",
		})

	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
		head="Ebers Cap +1",
		body="Ebers Bliaud +1",
		hands="Ebers Mitts +1",
		legs="Piety Pantaln. +1",
		feet="Ebers Duckbills +1",
		})

	sets.midcast.BoostStat = set_combine(sets.midcast['Enhancing Magic'], {
		feet="Ebers Duckbills +1"
		})

	sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
		ring1="Sheltered Ring",
		})

	sets.midcast.Protectra = sets.midcast.Protectra
	sets.midcast.Shell = sets.midcast.Protectra
	sets.midcast.Shellra = sets.midcast.Protectra

	sets.midcast['Divine Magic'] = {
		main="Grioavolr",
		sub="Clerisy Strap +1",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Vanya Robe",
		hands="Fanatic Gloves",
		legs="Kaykaus Tights",
		feet="Chironic Slippers",
		neck="Incanter's Torque",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Alaunus's Cape",
		waist="Refoccilation Stone",
		}

	sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'], {
		main="Grioavolr",
		sub="Niobid Strap",
		head="Inyanga Tiara +1",
		body="Witching Robe",
		legs="Chironic Hose",
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring2="Weather. Ring",
		waist="Refoccilation Stone",
		})

	sets.midcast.Holy = sets.midcast.Banish

	sets.midcast['Dark Magic'] = {
		main="Grioavolr",
		sub="Clerisy Strap +1",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Shango Robe",
		hands="Inyan. Dastanas +1",
		legs="Chironic Hose",
		feet="Medium's Sabots",
		neck="Incanter's Torque",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Evanescence Ring",
		ring2="Stikini Ring",
		back="Alaunus's Cape",
		waist="Yamabuki-no-Obi",
		}

	-- Custom spell classes
	sets.midcast.MndEnfeebles = {
		main="Grioavolr",
		sub="Clerisy Strap +1",
		ammo="Hydrocera",
		head="Befouled Crown",
		body="Vanya Robe",
		hands="Inyan. Dastanas +1",
		legs="Chironic Hose",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Alaunus's Cape",
		waist="Luminary Sash",
		}

	sets.midcast.IntEnfeebles = {
		main="Grioavolr",
		sub="Clerisy Strap +1",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Vanya Robe",
		hands="Inyan. Dastanas +1",
		legs="Chironic Hose",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Aurist's Cape +1",
		waist="Yamabuki-no-Obi",
		}

	sets.midcast.Impact = {
		main="Grioavolr",
		sub="Niobid Strap",
		head=empty,
		body="Twilight Cloak",
		legs="Gyve Trousers",
		ring2="Archon Ring",
		}

	-- Initializes trusts at iLvl 119
	sets.midcast.Trust = sets.precast.FC

	
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
		back="Solemnity Cape",
		waist="Austerity Belt +1",
		}

	sets.idle.DT = set_combine(sets.idle, {
		main="Bolelabunga",
		sub="Genmei Shield", --10/0
		ammo="Staunch Tathlum", --2/2
		head="Gende. Caubeen +1", --4/4
		hands="Gende. Gages +1", --4/3
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4
		})

	sets.idle.Town = set_combine(sets.idle, {
		main="Izcalli",
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
	
	sets.idle.Weak = sets.idle.DT
	
	-- Defense sets

	sets.defense.PDT = {
		main="Bolelabunga",
		sub="Genmei Shield", --10/0
		ammo="Staunch Tathlum", --2/2
		head="Gende. Caubeen +1", --4/4
		hands="Gende. Gages +1", --4/3
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4
		}

	sets.defense.MDT = sets.defense.PDT

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
		main="Izcalli",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Onca Suit",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Chirich Ring",
		ring2="Ramuh Ring +1",
		waist="Grunfeld Rope",
		back="Aurist's Cape +1",
		}

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	sets.buff['Divine Caress'] = {back="Mending Cape"}
	sets.buff['Devotion'] = {head="Piety Cap +1"}

	sets.Obi = {waist="Hachirin-no-Obi"}
	sets.CP = {back="Mecisto. Mantle"}

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
end


function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
	if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
		equip(sets.buff['Divine Caress'])
	end
	if spellMap == 'Cure' or spellMap == 'Curaga' then
		if (world.weather_element == 'Light' or world.day_element == 'Light') then
			equip(sets.midcast.CureWeather)
		end
    end
	if spellMap == 'Banish' or spellMap == "Holy" then
		if (world.weather_element == 'Light' or world.day_element == 'Light') then
			equip(sets.Obi)
		end
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if state.WeaponLock.value == true then
		disable('main','sub')
	else
		enable('main','sub')
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
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
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

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 11')
end