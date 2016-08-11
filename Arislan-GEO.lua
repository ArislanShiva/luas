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
	gear.default.obi_waist = "Refoccilation Stone"
	gear.default.obi_back = "Bookworm's Cape"
	gear.MPCoat = "Seidr Cotehardie"

	-- Additional local binds
	send_command('bind ^` input /ja "Full Circle" <me>')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind ^, input /ma Sneak <stpc>')
	send_command('bind ^. input /ma Invisible <stpc>')
	
	select_default_macro_book()
end

function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^,')
	send_command('unbind !.')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

	------------------------------------------------------------------------------------------------
	----------------------------------------- Precast Sets -----------------------------------------
	------------------------------------------------------------------------------------------------
	
	-- Precast sets to enhance JAs
	sets.precast.JA.Bolster = {
		body="Bagua Tunic +1"
	}
	sets.precast.JA['Life Cycle'] = {
		body="Geo. Tunic +1",
		back="Nantosuelta's Cape",
	}
  
	-- Fast cast sets for spells
	
	sets.precast.FC = {
	--	/RDM --15
  		main="Sucellus", --5
		sub="Genmei Shield",
		range="Dunna", --3
		head="Amalric Coif", --10
		body="Shango Robe", --8
		hands="Merlinic Dastanas", --6
		legs="Geo. Pants +1", --11
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --1
		ear2="Etiolation Earring", --2
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5
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
		body="Twilight Cloak",
		waist="Channeler's Stone",
		})
	 
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
		back="Toro Cape",
		waist=gear.ElementalBelt,
		}

	
	------------------------------------------------------------------------
	----------------------------- Midcast Sets -----------------------------
	------------------------------------------------------------------------
	
	-- Base fast recast for spells
	sets.midcast.FastRecast = {
  		main="Sucellus",
		sub="Genmei Shield",
		head="Amalric Coif",
		hands="Merlinic Dastanas",
		legs="Geo. Pants +1",
		feet="Regal Pumps +1",
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		ring1="Prolix Ring",
		back="Swith Cape +1",
		waist="Witful Belt",
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
		head="Vanya Hood", --10
		body="Vanya Robe", --7/(-6)
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
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		})

	sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
		main="Gada",
		sub="Genmei Shield",
		feet="Vanya Clogs",
		neck="Malison Medallion",
		ring1="Haoma's Ring",
		ring2="Haoma's Ring",
		})

	sets.midcast['Enhancing Magic'] = {
		main="Gada",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
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
		body="Telchine Chas.",
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
		head="Amalric Coif",
		})

	sets.midcast.Protectra = set_combine(sets.midcast['Enhancing Magic'], {
		ring1="Sheltered Ring",
		})

	sets.midcast.Shellra = sets.midcast.Protectra

	sets.midcast.EnhancingDuration = {
		main="Gada",
		sub="Genmei Shield",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		}

		sets.midcast.MndEnfeebles = {
		main="Grioavolr",
		sub="Mephitis Grip",
		head="Amalric Coif",
		body="Vanya Robe",
		hands="Azimuth Gloves +1",
		legs="Psycloth Lappas",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Aurist's Cape +1",
		waist="Luminary Sash",
		} -- MND/Magic accuracy
	
	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		ear1="Barkaro. Earring",
		}) -- INT/Magic accuracy

	sets.midcast['Dark Magic'] = {
		main="Grioavolr",
		sub="Mephitis Grip",
		head="Amalric Coif",
		body="Psycloth Vest",
		hands="Jhakri Cuffs +1",
		legs="Azimuth Tights +1",
		feet="Merlinic Crackows",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Digni. Earring",
		ring1="Evanescence Ring",
		ring2="Stikini Ring",
		back="Aurist's Cape +1",
		waist=gear.ElementalObi,
		}
	
	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Bagua Galero +1",
		ear2="Hirudinea Earring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		})
	
	sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
		feet="Regal Pumps +1"
		})

	-- Elemental Magic sets
	
	sets.midcast['Elemental Magic'] = {
  		main="Grioavolr",
		sub="Niobid Strap",
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
		back="Toro Cape",
		waist=gear.ElementalObi,
		}

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		main="Grioavolr",
		sub="Niobid Strap",
		legs="Azimuth Tights +1",
		neck="Sanctity Necklace",
		ear2="Hermetic Earring",
		back="Aurist's Cape +1",
		waist="Yamabuki-no-Obi",
		})

	sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'].Resistant, {
  		main="Solstice",
		sub="Culminus",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		})

	sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
		body="Seidr Cotehardie",
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
		head=empty,
		body="Twilight Cloak",
		ring2="Archon Ring",
		})

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
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Umbra Cape",
		waist="Austerity Belt +1",
		}
	
	sets.resting = set_combine(sets.idle, {
		main="Chatoyant Staff",
		waist="Austerity Belt +1",
	})

	sets.idle.PDT = set_combine(sets.idle, {
		main="Bolelabunga",
		sub="Genmei Shield",
		body="Vanya Robe",
		hands="Geo. Mitaines +1",
		legs="Artsieq Hose",
		feet="Azimuth Gaiters +1",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
		back="Umbra Cape",
		})

	sets.idle.MDT = set_combine(sets.idle, {
		head="Vanya Hood",
		body="Vanya Robe",
		legs="Gyve Trousers",
		neck="Loricate Torque +1",
		ear1="Odnowa Earring",
		ear2="Etiolation Earring",
		ring1="Shadow Ring",
		ring2="Defending Ring",
		back="Solemnity Cape",
		waist="Lieutenant's Sash",
		})

	sets.idle.Weak = sets.idle.PDT

	-- .Pet sets are for when Luopan is present.
	sets.idle.Pet = set_combine(sets.idle, { 
		-- dt/regen --
  		main="Sucellus", --3/3
		sub="Genmei Shield",
		range="Dunna", --5/0
		head="Azimuth Hood +1", --3/0
		body="Telchine Chas.", --0/1
		hands="Geo. Mitaines +1", --11/0
		legs="Psycloth Lappas", --4/0
		feet="Telchine Pigaches", --0/3
		ear1="Handler's Earring", --3*/0
		ear2="Handler's Earring +1", --4*/0
		back="Nantosuelta's Cape", --0/10
		waist="Isa Belt" --3/1
		})

	sets.idle.PDT.Pet = set_combine(sets.idle.Pet, {
		neck="Loricate Torque +1",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
		back="Nantosuelta's Cape",
		waist="Isa Belt"
		})

	sets.idle.MDT.Pet = set_combine(sets.idle.Pet, {
		neck="Loricate Torque +1",
		ring1="Shadow Ring",
		ring2="Defending Ring",
		back="Nantosuelta's Cape",
		waist="Isa Belt"
		})

	-- .Indi sets are for when an Indi-spell is active.
	sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants +1"})
	sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants +1"})
	sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {legs="Bagua Pants +1"})
	sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {legs="Bagua Pants +1"})

	sets.idle.Town = set_combine(sets.idle, {
  		main="Sucellus",
		sub="Culminus",
		head="Azimuth Hood +1",
		body="Azimuth Coat +1",
		hands="Bagua Mitaines +1",
		legs="Azimuth Tights +1",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Friomisi Earring",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		})
		
	-- Defense sets

	sets.defense.PDT = {
		main="Bolelabunga",
		sub="Genmei Shield", --10
		body="Vanya Robe", --1
		legs="Artsieq Hose", --5
		feet="Azimuth Gaiters +1", --4
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Gelatinous Ring +1", --7
		ring2="Defending Ring", --10
		back="Umbra Cape", --6
		}

	sets.defense.MDT = {
		head="Vanya Hood", --2
		body="Vanya Robe", --1
		legs="Gyve Trousers", --2
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
		ear2="Brutal Earring",
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
		legs="Merlinic Shalwar", --6
		feet="Merlinic Crackows", --11
		neck="Mizu. Kubikazari", --10
		ring1="Mujin Band", --(5)
		back="Seshaw Cape", --5
		}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
		equip(sets.magic_burst)
		if spell.english == "Impact" then
			equip(sets.midcast.Impact)
		end
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.english:startswith('Indi') then
			if not classes.CustomIdleGroups:contains('Indi') then
				classes.CustomIdleGroups:append('Indi')
			end
			--send_command('@timers d "'..indi_timer..'"')
			indi_timer = spell.english
			--send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
		elseif spell.skill == 'Elemental Magic' then
 --		   state.MagicBurst:reset()
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
end

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
