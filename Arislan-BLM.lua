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

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('None', 'Normal')
	state.CastingMode:options('Normal', 'Spaekona', 'Resistant', 'DeathMode')
	state.IdleMode:options('Normal', 'PDT', 'MDT', 'DeathMode')
	state.MagicBurst = M(false, 'Magic Burst')
	state.DeathMode = M(false, "Death Mode")

	lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'}
	
	-- Additional local binds
	send_command('bind ^` input /ma Stun <t>')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind @` gs c toggle DeathMode')
	send_command('bind !o input /ma "Shock Spikes" <me>')
--	send_command('bind !p input /ma "Warp II" <stpc>')
	send_command('bind ^, input /ma Sneak <stpc>')
	send_command('bind ^. input /ma Invisible <stpc>')

	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
	send_command('unbind !o')
--	send_command('unbind !p')
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
	sets.precast.JA['Mana Wall'] = {
		feet="Wicce Sabots +1",
		back=gear.BLM_MAB_Cape,
		}

--	sets.precast.JA.Manafont = {body="Src. Coat +2"}
	
	-- equip to maximize HP (for Tarus) and minimize MP loss before using convert
	sets.precast.JA.Convert = {}


	-- Fast cast sets for spells

	sets.precast.FC = {
	--	/RDM --15 /SCH --10
		main="Sucellus", --5
		sub="Genmei Shield",
		ammo="Sapience Orb", --2
		head="Amalric Coif", --10
		body="Shango Robe", --8
		hands="Merlinic Dastanas", --6
		legs="Psycloth Lappas", --7
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Etiolation Earring", --1
		ear2="Loquacious Earring", --2
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5
		back="Bane Cape", --4
		waist="Witful Belt", --3/(2)
		}

	sets.precast.FC.DeathMode = {
		ammo="Ghastly Tathlum +1",
		head="Amalric Coif", --10
		body="Amalric Doublet",
		hands="Amalric Gages",
		legs="Psycloth Lappas", --7
		feet="Regal Pumps +1", --7
		neck="Orunmila's Torque", --5
		ear1="Etiolation Earring", --1
		ear2="Loquacious Earring", --2
		ring1="Mephitas's Ring +1",
		ring2="Weather. Ring", --5
		back="Bane Cape", --4
		waist="Witful Belt", --3/(2)
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		back="Perimede Cape",
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
		body="Twilight Cloak",
		waist="Channeler's Stone",
		})

	sets.precast.Death = {
		main="Grioavolr",
		sub="Elder's Grip +1",
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Merlinic Jubbah", --10
		hands="Amalric Gages", --(5)
		legs="Amalric Slops",
		feet="Merlinic Crackows", --11
		neck="Mizu. Kubikazari", --10
		ear1="Barkaro. Earring",
		ear2="Static Earring", --5
		ring1="Mephitas's Ring +1",
		ring2="Archon Ring",
		back=gear.BLM_Death_Cape, --5
		waist=gear.ElementalObi,
		}

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
		back=gear.BLM_MAB_Cape,
		waist=gear.ElementalBelt,
		}

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

	sets.precast.WS['Vidohunir'] = {
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Amalric Doublet",
		hands="Amalric Gages",
		legs="Merlinic Shalwar",
		feet="Merlinic Crackows",
		neck="Imbodla Necklace",
		ear1="Barkaro. Earring",
		ear2="Moonshade Earring",
		ring1="Shiva Ring +1",
		ring2="Archon Ring",
		back=gear.BLM_MAB_Cape,
		waist="Yamabuki-no-Obi",
		} -- INT

	sets.precast.WS['Myrkr'] = {
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Amalric Doublet",
		hands="Telchine Gloves",
		legs="Amalric Slops",
		feet="Telchine Pigaches",
		neck="Orunmila's Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		ring1="Mephitas's Ring +1",
		ring2="Mephitas's Ring",
		back="Bane Cape",
		waist="Luminary Sash",
		} -- Max MP

	
	---- Midcast Sets ----

	sets.midcast.FastRecast = {
		head="Amalric Coif",
		hands="Merlinic Dastanas",
		legs="Merlinic Shalwar",
		feet="Regal Pumps +1",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		ring1="Prolix Ring",
		back="Swith Cape +1",
		waist="Witful Belt",
		} -- Haste

	sets.midcast.Cure = {
		main="Tamaxchi", --22/(-10)
		sub="Sors Shield", --3/(-5)
		ammo="Leisure Musk +1", --0/(-4)
		head="Vanya Hood", --10
		body="Vanya Robe", --7/(-6)
		hands="Telchine Gloves", --10
		legs="Gyve Trousers", --10
		feet="Medium's Sabots", --12
		neck="Incanter's Torque",
		ear1="Mendi. Earring", --5
		ear2="Roundel Earring", --5
		ring1="Lebeche Ring", --3/(-5)
		ring2="Haoma's Ring",
		back="Oretan. Cape +1", --6
		waist="Bishop's Sash",
		}

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		waist="Luminary Sash",
		})

	sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
		feet="Vanya Clogs",
		neck="Malison Medallion",
		ring1="Haoma's Ring",
		})

	sets.midcast['Enhancing Magic'] = {
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
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		}

	sets.midcast.MndEnfeebles = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Hydrocera",
		head="Amalric Coif",
		body="Vanya Robe",
		hands="Amalric Gages",
		legs="Psycloth Lappas",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Globidonta Ring",
		ring2="Levia. Ring +1",
		back="Aurist's Cape +1",
		waist="Luminary Sash",
		} -- MND/Magic accuracy

	sets.midcast.IntEnfeebles = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Amalric Coif",
		body="Vanya Robe",
		hands="Amalric Gages",
		legs="Psycloth Lappas",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Barkaro. Earring",
		ear2="Digni. Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.BLM_MAB_Cape,
		waist="Channeler's Stone",
		} -- INT/Magic accuracy
		
	sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

	sets.midcast['Dark Magic'] = {
		main="Grioavolr",
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Amalric Coif",
		body="Shango Robe",
		hands="Arch. Gloves +1",
		legs="Psycloth Lappas",
		feet="Merlinic Crackows",
		neck="Incanter's Torque",
		ear1="Barkaro. Earring",
		ear2="Digni. Earring",
		ring1="Evanescence Ring",
		ring2="Weather. Ring",
		back=gear.BLM_MAB_Cape,
		waist=gear.ElementalObi,
		}

	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Pixie Hairpin +1",
		ear2="Hirudinea Earring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		})
	
	sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
		feet="Regal Pumps +1",
		waist="Channeler's Stone",
		})

	sets.midcast.BardSong = set_combine(sets.midcast['Enfeebling Magic'], {
		feet="Telchine Pigaches",
		})

	-- Elemental Magic sets
	
	sets.midcast['Elemental Magic'] = {
		main="Lathi",
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
		back=gear.BLM_MAB_Cape,
		waist=gear.ElementalObi,
		}

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		neck="Sanctity Necklace",
		ear2="Hermetic Earring",
		waist="Yamabuki-no-Obi",
		})

			
	sets.midcast['Elemental Magic'].Spaekona = set_combine(sets.midcast['Elemental Magic'], {
		body="Spae. Coat +1",
		neck="Sanctity Necklace",
		})

	sets.midcast.Comet = set_combine(sets.midcast['Elemental Magic'], {
		head="Pixie Hairpin +1",
		ring2="Archon Ring",
		})

	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
		head=empty,
		body="Twilight Cloak",
		ring2="Archon Ring",
		})

	sets.midcast.Death = sets.precast.Death

	-- Minimal damage gear for procs
	sets.midcast['Elemental Magic'].Proc = {
		main="Chatoyant Staff"
		}

	-- Sets to return to when not performing an action.
	
	sets.resting = {
		main="Chatoyant Staff",
		waist="Austerity Belt +1",
		}

	-- Idle sets
	
	sets.idle = {
		main="Bolelabunga",
		sub="Genmei Shield",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Witching Robe",
		hands="Amalric Gages",
		legs="Assid. Pants +1",
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
		body="Vanya Robe",
		legs="Artsieq Hose",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
		back="Umbra Cape",
		})

	sets.idle.MDT = set_combine(sets.idle, {
		ammo="Vanir Battery",
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

	sets.idle.DeathMode = {
		main="Grioavolr",
		sub="Elder's Grip +1",
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Amalric Doublet",
		hands="Amalric Gages",
		legs="Amalric Slops",
		feet="Merlinic Crackows",
		neck="Sanctity Necklace",
		ear1="Barkaro. Earring",
		ear2="Static Earring",
		ring1="Mephitas's Ring +1",
		ring2="Mephitas's Ring",
		back=gear.BLM_Death_Cape,
		waist="Refoccilation Stone",
		}

	sets.idle.Weak = sets.idle.PDT
	
	sets.idle.Town = set_combine(sets.idle, {
		main="Lathi",
		sub="Niobid Strap",
		head="Merlinic Hood",
		body="Merlinic Jubbah",
		legs="Merlinic Shalwar",
		neck="Saevus Pendant +1",
		ear1="Barkaro. Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.BLM_MAB_Cape,
		})
		
	-- Defense sets

	sets.defense.PDT = {
		main="Bolelabunga",
		sub="Genmei Shield", --10
		body="Vanya Robe", --1
		legs="Artsieq Hose", --5
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Gelatinous Ring +1", --7
		ring2="Defending Ring", --10
		back="Umbra Cape", --6
		}

	sets.defense.MDT = {
		ammo="Vanir Battery",
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

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	
	sets.buff['Mana Wall'] = {
		feet="Wicce Sabots +1",
		}


	sets.magic_burst = { 
		body="Merlinic Jubbah", --10
		hands="Amalric Gages", --(5)
		legs="Merlinic Shalwar", --6
		feet="Merlinic Crackows", --11
		neck="Mizu. Kubikazari", --10
		ring1="Mujin Band", --(5)
		back=gear.BLM_MAB_Cape, --5
		} 

	-- Engaged sets

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

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spellMap == 'Cure' or spellMap == 'Curaga' then
		gear.default.obi_waist = "Bishop's Sash"
	elseif spell.skill == 'Elemental Magic' then
		gear.default.obi_waist = "Refoccilation Stone"
		if state.CastingMode.value == 'Proc' then
			classes.CustomClass = 'Proc'
		end
	elseif state.CastingMode.value == 'DeathMode' then
		classes.CustomClass = 'DeathMode'
		end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)

end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' and state.MagicBurst.value then
		equip(sets.magic_burst)
	elseif state.CastingMode.value == 'DeathMode' then
		equip(sets.precast.Death)
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.english == 'Death' then
			state.DeathMode:reset()
			enable('ammo','head','neck','ear1','ear2','body','hands','ring1','ring2','back','waist','legs','feet')
		end
		-- Lock feet after using Mana Wall.
		if spell.english == 'Mana Wall' then
			enable('feet','back')
			equip(sets.buff['Mana Wall'])
			disable('feet','back')
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
	-- Unlock feet when Mana Wall buff is lost.
    if buff == "Mana Wall" and not gain then
		enable('feet','back')
		handle_equipping_gear(player.status)
	end
end

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
		if spell.skill == "Enfeebling Magic" then
			if spell.type == "WhiteMagic" then
				return "MndEnfeebles"
			else
				return "IntEnfeebles"
			end
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.DeathMode.current == 'on' then
		equip(sets.precast.Death)
		disable('ammo','head','neck','ear1','ear2','body','hands','ring1','ring2','back','waist','legs','feet')
	else
		enable('ammo','head','neck','ear1','ear2','body','hands','ring1','ring2','back','waist','legs','feet')
	end
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
	end
	
	return idleSet
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
	set_macro_page(1, 5)
end
