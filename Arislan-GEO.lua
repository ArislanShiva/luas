-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:
		
		Magic Burst			Toggle Magic Burst Mode  [Alt-`]
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
	indi_timer = ''
	indi_duration = 180

	state.CP = M(false, "Capacity Points Mode")
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Seidr', 'Resistant')
	state.IdleMode:options('Normal', 'DT')

	state.WeaponLock = M(false, 'Weapon Lock')	
	state.MagicBurst = M(false, 'Magic Burst')

	-- Additional local binds
	send_command('bind ^` input /ja "Full Circle" <me>')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind !w input /ma "Aspir III" <t>')
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
	send_command('unbind !w')
	send_command('unbind ^,')
	send_command('unbind !.')
	send_command('unbind @c')
	send_command('unbind @w')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

	------------------------------------------------------------------------------------------------
	----------------------------------------- Precast Sets -----------------------------------------
	------------------------------------------------------------------------------------------------
	
	-- Precast sets to enhance JAs
	sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
	sets.precast.JA['Life Cycle'] = {body="Geo. Tunic +1", back="Nantosuelta's Cape"}
  
	-- Fast cast sets for spells
	
	sets.precast.FC = {
	--	/RDM --15
		main="Oranyan", --7
		sub="Clerisy Strap +1", --3
		range="Dunna", --3
		head="Amalric Coif", --10
		body="Shango Robe", --8
		hands="Merlinic Dastanas", --6
		legs="Geo. Pants +1", --11
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Enchntr. Earring +1", --2
		ring1="Kishar Ring", --4
		ring2="Weather. Ring +1", --5
		back="Lifestream Cape", --7
		waist="Witful Belt", --3/(2)
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		back="Perimede Cape",
		})
		
	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
		hands="Bagua Mitaines +1",
		waist="Channeler's Stone",
		})

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		main="Oranyan", --7
		sub="Clerisy Strap +1", --3
		ear1="Mendi. Earring", --5
		ring1="Lebeche Ring", --(2)
		back="Perimede Cape", --(4)
		})

	sets.precast.FC.Curaga = sets.precast.FC.Cure
	sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})

	 
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
		back="Toro Cape",
		waist="Fotia Belt",
		}

	
	------------------------------------------------------------------------
	----------------------------- Midcast Sets -----------------------------
	------------------------------------------------------------------------
	
	-- Base fast recast for spells
	sets.midcast.FastRecast = {
		main="Oranyan",
		sub="Clerisy Strap +1",
		head="Amalric Coif",
		hands="Merlinic Dastanas",
		legs="Geo. Pants +1",
		feet="Regal Pumps +1",
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		ring1="Kishar Ring",
		back="Lifestream Cape",
		} -- Haste
	
   sets.midcast.Geomancy = {
  		main="Sucellus",
		sub="Genmei Shield",
		range="Dunna",
		head="Azimuth Hood +1",
		body="Azimuth Coat +1",
		hands="Azimuth Gloves +1",
		legs="Azimuth Tights +1",
		feet="Azimuth Gaiters +1",
		neck="Incanter's Torque",
		ear1="Gifted Earring",
		ear2="Calamitous Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Lifestream Cape",
		waist="Austerity Belt +1",
		}
	
	sets.midcast.Geomancy.Indi = {
  		main="Sucellus",
		sub="Genmei Shield",
		range="Dunna",
		head="Azimuth Hood +1",
		body="Azimuth Coat +1",
		hands="Geo. Mitaines +1",
		legs="Bagua Pants +1",
		feet="Azimuth Gaiters +1",
		neck="Incanter's Torque",
		ear1="Gifted Earring",
		ear2="Calamitous Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Lifestream Cape",
		waist="Austerity Belt +1",
		}

	sets.midcast.Cure = {
		main="Tamaxchi", --22/(-10)
		sub="Sors Shield", --3/(-5)
		hands="Telchine Gloves", --10
		legs="Gyve Trousers", --10
		feet="Medium's Sabots", --12
		neck="Incanter's Torque",
		ear1="Mendi. Earring", --5
		ear2="Loquacious Earring",
		ring1="Lebeche Ring", --3/(-5)
		ring2="Haoma's Ring",
		back="Oretan. Cape +1", --6
		waist="Bishop's Sash",
		}

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		neck="Nuna Gorget +1",
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		})

	sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
		main="Gada",
		sub="Genmei Shield",
		head="Vanya Hood",
		feet="Vanya Clogs",
		neck="Debilis Medallion",
		ear1="Beatific Earring",
		ring1="Haoma's Ring",
		ring2="Haoma's Ring",
		})

	sets.midcast['Enhancing Magic'] = {
		main="Oranyan",
		sub="Enki Strap",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		neck="Incanter's Torque",
		ear1="Augment. Earring",
		ear2="Andoaa Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Fi Follet Cape +1",
		waist="Olympus Sash",
		}
		
	sets.midcast.EnhancingDuration = {
		main="Oranyan",
		sub="Enki Strap",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		}

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
		main="Bolelabunga",
		sub="Genmei Shield",
		body="Telchine Chas.",
		})
	
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		head="Amalric Coif",
		waist="Gishdubar Sash",
		back="Grapevine Cape",
		})
			
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Nodens Gorget",
		waist="Siegel Sash",
		})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
		main="Vadose Rod",
		head="Amalric Coif",
		waist="Emphatikos Rope",
		})

	sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
		ring1="Sheltered Ring",
		})
	sets.midcast.Protectra = sets.midcast.Protect
	sets.midcast.Shell = sets.midcast.Protect
	sets.midcast.Shellra = sets.midcast.Protect


	sets.midcast.MndEnfeebles = {
		main=gear.Grioavolr_MND,
		sub="Enki Strap",
		head="Merlinic Hood",
		body="Vanya Robe",
		hands="Azimuth Gloves +1",
		legs=gear.Merlinic_MAcc_legs,
		feet="Skaoi Boots",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Regal Earring",
		ring1="Kishar Ring",
		ring2="Stikini Ring",
		back="Aurist's Cape +1",
		waist="Luminary Sash",
		} -- MND/Magic accuracy
	
	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		main=gear.Grioavolr_MB,
		back="Nantosuelta's Cape",
		}) -- INT/Magic accuracy

	sets.midcast['Dark Magic'] = {
		main=gear.Grioavolr_MB,
		sub="Enki Strap",
		head="Merlinic Hood",
		body="Shango Robe",
		hands="Jhakri Cuffs +1",
		legs="Azimuth Tights +1",
		feet="Merlinic Crackows",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Regal Earring",
		ring1="Evanescence Ring",
		ring2="Stikini Ring",
		back="Perimede Cape",
		waist="Casso Sash",
		}
	
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Bagua Galero +1",
		feet="Merlinic Crackows",
		ear1="Hirudinea Earring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		})
	
	sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
		feet="Regal Pumps +1"
		})

	-- Elemental Magic sets
	
	sets.midcast['Elemental Magic'] = {
		main=gear.Grioavolr_MB,
		sub="Niobid Strap",
		head="Merlinic Hood",
		body="Merlinic Jubbah",
		hands="Amalric Gages",
		legs=gear.Merlinic_MB_legs,
		feet="Merlinic Crackows",
		neck="Baetyl Pendant",
		ear1="Barkaro. Earring",
		ear2="Regal Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back="Toro Cape",
		waist="Refoccilation Stone",
		}

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		main=gear.Grioavolr_MB,
		sub="Enki Strap",
		legs=gear.Merlinic_MAcc_legs,
		neck="Sanctity Necklace",
		back="Aurist's Cape +1",
		waist="Yamabuki-no-Obi",
		})

	sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {
  		main="Solstice",
		sub="Culminus",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		})

	sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
		sub="Enki Strap",
		body="Seidr Cotehardie",
		legs=gear.Merlinic_MAcc_legs,
		neck="Sanctity Necklace",
		})

	sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {
  		main="Solstice",
		sub="Culminus",		
		body="Seidr Cotehardie",
		neck="Sanctity Necklace",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		})

	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
		main=gear.Grioavolr_MB,
		sub="Niobid Strap",
		head=empty,
		body="Twilight Cloak",
		ring2="Archon Ring",
		})

	-- Initializes trusts at iLvl 119
	sets.midcast.Trust = sets.precast.FC

	------------------------------------------------------------------------------------------------
	------------------------------------------ Idle Sets -------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.idle = {
		main="Bolelabunga",
		sub="Genmei Shield",
		ranged="Dunna",
		head="Befouled Crown",
		body="Witching Robe",
		hands="Bagua Mitaines +1",
		legs="Assid. Pants +1",
		feet="Geo. Sandals +1",
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Moonbeam Cape",
		waist="Austerity Belt +1",
		}
	
	sets.resting = set_combine(sets.idle, {
		main="Chatoyant Staff",
		waist="Shinjutsu-no-Obi +1",
		})

	sets.idle.DT = set_combine(sets.idle, {
		main="Mafic Cudgel", --10/0
		sub="Genmei Shield", --10/0
		body="Mallquis Saio +1", --6/6
		hands="Hagondes Cuffs +1", --3/3
		feet="Azimuth Gaiters +1", --4/0
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ear2="Etiolation Earring", --0/3
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Moonbeam Cape", --5/5
		})

	sets.idle.Weak = sets.idle.DT

	-- .Pet sets are for when Luopan is present.
	sets.idle.Pet = set_combine(sets.idle, { 
		-- Pet: -DT (37.5% to cap) / Pet: Regen 
  		main="Sucellus", --3/3
		sub="Genmei Shield",
		range="Dunna", --5/0
		head="Azimuth Hood +1", --0/3
		body="Telchine Chas.", --0/3
		hands="Geo. Mitaines +1", --11/0
		legs="Telchine Braconi", --0/3
		feet="Telchine Pigaches", --0/3
		ear1="Handler's Earring", --3*/0
		ear2="Handler's Earring +1", --4*/0
		back="Nantosuelta's Cape", --0/10
		waist="Isa Belt" --3/1
		})

	sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
		body="Mallquis Saio +1", --6/6
		legs="Psycloth Lappas", --4/0
		neck="Loricate Torque +1", --6/6
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Moonbeam Cape", --5/5
		})

	-- .Indi sets are for when an Indi-spell is active.
--	sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants +1"})
--	sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants +1"})
--	sets.idle.DT.Indi = set_combine(sets.idle.DT, {legs="Bagua Pants +1"})
--	sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {legs="Bagua Pants +1"})

	sets.idle.Town = set_combine(sets.idle, {
  		main="Sucellus",
		sub="Culminus",
		head="Azimuth Hood +1",
		body="Azimuth Coat +1",
		hands="Bagua Mitaines +1",
		legs="Azimuth Tights +1",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Regal Earring",
		ring1="Fenrir Ring +1",
		ring2="Weather. Ring +1",
		})
		
	-- Defense sets

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT

	sets.Kiting = {
		feet="Herald's Gaiters"
		}

	sets.latent_refresh = {
		waist="Fucho-no-obi"
		}
	
	--------------------------------------
	-- Engaged sets
	--------------------------------------

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {		
		head="Telchine Cap",
		body="Onca Suit",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Grunfeld Rope",
		back="Relucent Cape",
		}


	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.magic_burst = {
		body="Merlinic Jubbah", --10
		hands="Amalric Gages", --(5)
		legs=gear.Merlinic_MB_legs, --6
		feet="Merlinic Crackows", --11
		neck="Mizu. Kubikazari", --10
		ring1="Mujin Band", --(5)
		back="Seshaw Cape", --5
		}

	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

	sets.Obi = {waist="Hachirin-no-Obi"}
	sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.name == 'Impact' then
		equip(sets.precast.FC.Impact)
	end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' then 
		if state.MagicBurst.value then
			equip(sets.magic_burst)
			if spell.english == "Impact" then
				equip(sets.midcast.Impact)
			end
		end
		if (spell.element == world.day_element or spell.element == world.weather_element) then
			equip(sets.Obi)
		end
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
		if spellMap == 'Refresh' then
			equip(sets.midcast.Refresh)
		end
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.english:startswith('Indi') then
			if not classes.CustomIdleGroups:contains('Indi') then
				classes.CustomIdleGroups:append('Indi')
			end
			--send_command('@timers d "'..indi_timer..'"')
			--indi_timer = spell.english
			--send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
		elseif spell.skill == 'Elemental Magic' then
 --		   state.MagicBurst:reset()
		end
		if spell.english == "Sleep II" then
			send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
		elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
			send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
		end 
	elseif not player.indi then
		classes.CustomIdleGroups:clear()
	end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if player.indi and not classes.CustomIdleGroups:contains('Indi')then
		classes.CustomIdleGroups:append('Indi')
		handle_equipping_gear(player.status)
	elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
		classes.CustomIdleGroups:clear()
		handle_equipping_gear(player.status)
	end

	if buff == "doom" then
		if gain then		   
			equip(sets.buff.Doom)
			send_command('@input /p Doomed.')
			disable('ring1','ring2','waist')
		else
			enable('ring1','ring2','waist')
			handle_equipping_gear(player.status)
		end
	end

end

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

function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if spell.skill == 'Enfeebling Magic' then
			if spell.type == 'WhiteMagic' then
				return 'MndEnfeebles'
			else
				return 'IntEnfeebles'
			end
		elseif spell.skill == 'Geomancy' then
			if spell.english:startswith('Indi') then
				return 'Indi'
			end
		elseif spell.skill == 'Elemental Magic' then
			if spellMap == 'GeoElem' then
				return 'GeoElem'
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
	classes.CustomIdleGroups:clear()
	if player.indi then
		classes.CustomIdleGroups:append('Indi')
	end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
	display_current_caster_state()
	eventArgs.handled = true
end

function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'nuke' then
		handle_nuking(cmdParams)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(10, 3)
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 10')
end