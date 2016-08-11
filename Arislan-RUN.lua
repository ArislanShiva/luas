-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.
function job_setup()
	-- Number of runes
	if player.main_job_level >= 65 then
		max_runes = 3
	elseif player.main_job_level >= 35 then
		max_runes = 2
	elseif player.main_job_level >= 5 then
		max_runes = 1
	else
		max_runes = 0
	end
	-- /BLU Spell Maps
	blue_magic_maps = {}

	blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
		'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
	blue_magic_maps.Cure = S{'Wild Carrot'}
	blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'PDT', 'MDT', 'Refresh')
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT', 'Status')
	
	state.Knockback = M(false, 'Knockback')
	state.Death = M(false, "Death Resistance")

	state.Runes = M{['description']='Runes', "Ignis", "Gelus", "Flabra", "Tellus", "Sulpor", "Unda", "Lux", "Tenebrae"}
	
	send_command('bind ^` input //gs c rune')
	send_command('bind !` input /ja "Vivacious Pulse" <me>')
	send_command('bind ^- gs c cycleback Runes')
	send_command('bind ^= gs c cycle Runes')
	send_command('bind ^f11 gs c cycle MagicalDefenseMode')
	send_command('bind ^[ gs c toggle Knockback')
	send_command('bind ^] gs c toggle Death')
	send_command('bind !e input /ma "Refueling" <me>')
	send_command('bind !o input /ma "Cocoon" <me>')

	
	select_default_macro_book()
end

function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^=')
    send_command('unbind ^f11')
	send_command('unbind ^[')
	send_command('unbind !]')
	send_command('bind !e input /ma Haste <stpc>')
	send_command('unbind !o')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------

	-- Enmity set
	sets.Enmity = {
		-- Aettir 10 / Alber Strap 5
		ammo="Sapience Orb", --2
		head="Halitus Helm", --8
		body="Emet Harness", --9
--		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1", --7
		feet="Erilaz Greaves +1",--6
		neck="Unmoving Collar +1", --10
		ear1="Cryptic Earring", --4
		ear2="Friomisi Earring", --2
		ring1="Petrov Ring", --4
		ring2="Eihwaz Ring", --5
		back="Evasionist's Cape", --4
		waist="Trance Belt", --4
		}

	-- Precast sets to enhance JAs
	sets.precast.JA['Vallation'] = {body="Runeist Coat +1", legs="Futhark Trousers", back="Ogma's Cape"}
	sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	sets.precast.JA['Pflug'] = {feet="Runeist Bottes +1"}
	sets.precast.JA['Battuta'] = {head="Futhark Bandeau"}
	sets.precast.JA['Liement'] = {body="Futhark Coat"}

	sets.precast.JA['Lunge'] = {
		ammo="Ghastly Tathlum +1",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		back="Argocham. Mantle",
		waist="Eschan Stone",
		}

	sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
	sets.precast.JA['Gambit'] = {hands="Runeist Mitons +1"}
	sets.precast.JA['Rayke'] = {feet="Futhark Boots"}
	sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat"}
	sets.precast.JA['Swordplay'] = {hands="Futhark Mitons"}
	sets.precast.JA['Embolden'] = {back="Evasionist's Cape"}
	sets.precast.JA['Vivacious Pulse'] = {head="Erilaz Galea +1", neck="Incanter's Torque", legs="Rune. Trousers +1"}
	sets.precast.JA['One For All'] = {}
	sets.precast.JA['Provoke'] = sets.Enmity

	sets.precast.Waltz = {
		hands="Slither Gloves +1",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		}

	sets.precast.Waltz['Healing Waltz'] = {}

	-- Fast cast sets for spells
	sets.precast.FC = {
		ammo="Sapience Orb", --2
		head=gear.Herc_FC_head, --12
		body="Samnuha Coat", --5
		hands="Leyline Gloves", --7
		legs="Rawhide Trousers", --5
		feet="Carmine Greaves +1", --8
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring1="Prolix Ring", --2
		ring2="Weather. Ring", --5(3)
		waist="Ninurta's Sash",
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		legs="Futhark Trousers",
		waist="Siegel Sash",
		})

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		waist="Ninurta's Sash",
		})

	-- Weaponskill sets
	sets.precast.WS = {
		ammo="Seething Bomblet",
		head="Lilitu Headpiece",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs=gear.Herc_TA_legs,
		feet=gear.Herc_TA_feet,
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Brutal earring",
		ring1="Shukuyu Ring",
		ring2="Ifrit Ring +1",
		back="Bleating Mantle",
		waist=gear.ElementalBelt,
		}

	sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
		head="Adhemar Bonnet",
		legs="Samnuha Tights",
		ring2="Epona's Ring",
		})
		
	sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {
		head="Dampening Tam",
		legs="Adhemar Kecks",
		ear2="Zennaroi Earring",
		ring1="Rufescent Ring",
		})
	
	sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS['Resolution'], {
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",		
		})
		
	sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'], {
		legs="Samnuha Tights",
		ring1="Ramuh Ring +1",
		})

	sets.precast.WS['Herculean Slash'] = sets.precast.JA['Lunge']


	--------------------------------------
	-- Midcast Sets
	--------------------------------------
	
	sets.midcast.FastRecast = {
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		}

	sets.midcast['Enhancing Magic'] = {
--		head="Carmine Mask",
		hands="Runeist Mitons +1",
		legs="Carmine Cuisses +1",
		neck="Incanter's Torque",
		ear2="Andoaa Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Olympus Sash",
		}

	sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Futhark Bandeau",
		})

	sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Runeist Bandeau +1", 
		legs="Futhark Trousers",
		neck="Incanter's torque",
		})
		
	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Gishdubar Sash",
		})
	
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",
		})

	sets.midcast.EnhancingDuration = {
		head="Erilaz Galea +1",
		legs="Futhark Trousers",
		}

	sets.midcast['Divine Magic'] = {
		legs="Runeist Trousers +1",
		neck="Incanter's Torque",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Bishop's Sash",
		}

	sets.midcast.Flash = sets.Enmity

	sets.midcast.Foil = sets.midcast.EnhancingDuration--sets.Enmity

	sets.midcast.Utsusemi = {
		waist="Ninurta's Sash",
		}
	
	sets.midcast['Blue Magic'] = {}
	sets.midcast['Blue Magic'].Enmity = sets.Enmity
	sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
	sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']
	
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

	sets.idle = {
		ammo="Homiliary",
		head="Rawhide Mask",
		body="Runeist Coat +1",
		hands="Erilaz Gauntlets +1",
		legs="Carmine Cuisses +1",
		feet="Erilaz Greaves +1",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt",
		}

	sets.idle.Refresh = set_combine(sets.idle, {
		head="Rawhide Mask",
		body="Runeist Coat +1",
		waist="Fucho-no-obi",
		})
		   
	sets.idle.PDT = {
		ammo="Iron Gobbet",
		body="Erilaz Surcoat +1",
		legs="Eri. Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ring1="Gelatinous Ring +1",
		ring2="Defending Ring",
		back="Evasionist's Cape",
		waist="Flume Belt",
		}

	sets.idle.MDT = {
		ammo="Vanir Battery",
		head="Erilaz Galea +1",
		body="Erilaz Surcoat +1",
		hands="Erilaz Gauntlets +1",
		legs="Eri. Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Loricate Torque +1",
		ear1="Etiolation Earring",
		ear2="Odnowa Earring +1",
		ring1="Shadow Rinsg",
		ring2="Defending Ring",
		back="Mubvum. Mantle",
		waist="Lieutenant's Sash",
		}

	sets.idle.Town = {
		ammo="Ginsen",
		head="Erilaz Galea +1",
		body="Erilaz Surcoat +1",
		hands="Erilaz Gauntlets +1",
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		neck="Combatant's Torque",
		ear1="Genmei Earring",
		ear2="Odnowa Earring +1",
		ring1="Warden's Ring",
		ring2="Defending Ring",
		back="Ogma's Cape",
		waist="Windbuffet Belt +1",
		}

	sets.Kiting = {legs="Carmine Cuisses +1"}


    --------------------------------------
    -- Defense sets
    --------------------------------------

	sets.defense.Knockback = {back="Repulse Mantle"}

	sets.defense.Death = {ring1="Warden's Ring", ring2="Eihwaz Ring",}

	sets.defense.PDT = {
		--Aettir (5II) / Alber Strap 2
		ammo="Iron Gobbet", --(2)
		body="Erilaz Surcoat +1",
		legs="Eri. Leg Guards +1", --7
		feet="Erilaz Greaves +1", --5
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ear2="Odnowa Earring +1",
		ring1="Gelatinous Ring +1", --7
		ring2="Defending Ring", --10
		back="Evasionist's Cape", --7
		waist="Flume Belt", --4
		}
	
	sets.defense.MDT = {
		ammo="Vanir Battery",
		head="Erilaz Galea +1",
		body="Erilaz Surcoat +1",
		hands="Erilaz Gauntlets +1",
		legs="Eri. Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Loricate Torque +1", --6
		ear1="Etiolation Earring", --2
		ear2="Odnowa Earring +1", --2
		ring1="Shadow Ring",
		ring2="Defending Ring", --10
		back="Mubvum. Mantle", --6
		waist="Lieutenant's Sash", --2
		}

	sets.defense.Status = {
		ammo="Iron Gobbet", --(2)
		head="Meghanada Visor +1", --4
		body="Erilaz Surcoat +1",
		hands="Erilaz Gauntlets +1",
		legs="Rune. Trousers +1", --3
		feet="Erilaz Greaves +1", --5
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ear2="Hearty Earring",
		ring1="Gelatinous Ring +1", --7
		ring2="Defending Ring", --10
		back="Evasionist's Cape", --7
		waist="Flume Belt", --4
		}
	
	sets.defense.HP = {
		}

	--------------------------------------
	-- Engaged sets
	--------------------------------------

	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Cessance Earring",
		ear2="Dedition Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Ogma's Cape",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		hands=gear.Herc_TA_hands,
		feet=gear.Herc_TA_feet,
		neck="Combatant's Torque",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		ammo="Falcon Eye",
		legs="Adhemar Kecks",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		ear1="Digni. Earring",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.Fodder = set_combine(sets.engaged, {
		body="Thaumas Coat",
		waist="Sinew Belt",
		})

	-- Custom buff sets
	sets.buff.Doom = {waist="Gishdubar Sash"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
	if spell.english == 'Lunge' then
		local abil_recasts = windower.ffxi.get_ability_recasts()
		if abil_recasts[spell.recast_id] > 0 then
			send_command('input /jobability "Swipe" <t>')
			add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
			eventArgs.cancel = true
			return
		end
	end	
	if spellMap == 'Utsusemi' then
		if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
			cancel_spell()
			add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
			eventArgs.handled = true
			return
		elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
			send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
		end
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.english == 'Lunge' or spell.english == 'Swipe' then
		local obi = get_obi(get_rune_obi_element())
		if obi then
			equip({waist=obi})
		end
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	end
	-- If DefenseMode is active, apply that gear over midcast
	-- choices.  Precast is allowed through for fast cast on
	-- spells, but we want to return to def gear before there's
	-- time for anything to hit us.
	-- Exclude Job Abilities from this restriction, as we probably want
	-- the enhanced effect of whatever item of gear applies to them,
	-- and only one item should be swapped out.
	if state.DefenseMode.value ~= 'None' and spell.type ~= 'JobAbility' then
		handle_equipping_gear(player.status)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
	classes.CustomDefenseGroups:clear()
	classes.CustomDefenseGroups:append(state.Knockback.current)
	classes.CustomDefenseGroups:append(state.Death.current)

	classes.CustomMeleeGroups:clear()
	classes.CustomMeleeGroups:append(state.Knockback.current)
	classes.CustomMeleeGroups:append(state.Death.current)
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
		end
	if state.Knockback.value == true then
		idleSet = set_combine(idleSet, sets.defense.Knockback)
		end
	if state.Death.value == true then
		idleSet = set_combine(idleSet, sets.defense.Death)
		end	if state.Buff.Doom then
		idleSet = set_combine(idleSet, sets.buff.Doom)
		end	
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	if state.Knockback.value == true then
		meleeSet = set_combine(meleeSet, sets.defense.Knockback)
		end
	if state.Death.value == true then
		meleeSet = set_combine(meleeSet, sets.defense.Death)
		end
	if state.Buff.Doom then
		meleeSet = set_combine(meleeSet, sets.buff.Doom)
		end 
	return meleeSet
end

function customize_defense_set(defenseSet)
	if state.Knockback.value == true then
		defenseSet = set_combine(defenseSet, sets.defense.Knockback)
		end
	if state.Death.value == true then
		defenseSet = set_combine(defenseSet, sets.defense.Death)
		end
	if state.Buff.Doom then
		defenseSet = set_combine(defenseSet, sets.buff.Doom)
		end
	return defenseSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = 'Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': ['
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. '], WS: [' .. state.WeaponskillMode.value .. ']'
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
	end

	if state.Knockback.value == true then
        msg = msg .. ', Knockback: [ON]'
    end
	
	if state.Death.value == true then
        msg = msg .. ', Death: [ON]'
    end

	if state.Kiting.value then
		msg = msg .. ', Kiting'
	end

	msg = msg .. ', Rune: ['..state.Runes.current .. ']'

	add_to_chat(122, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Blue Magic' then
		for category,spell_list in pairs(blue_magic_maps) do
			if spell_list:contains(spell.english) then
				return category
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'rune' then
		send_command('@input /ja '..state.Runes.value..' <me>')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function get_rune_obi_element()
	weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
	day_rune = buffactive[elements.rune_of[world.day_element] or '']
	
	local found_rune_element
	
	if weather_rune and day_rune then
		if weather_rune > day_rune then
			found_rune_element = world.weather_element
		else
			found_rune_element = world.day_element
		end
	elseif weather_rune then
		found_rune_element = world.weather_element
	elseif day_rune then
		found_rune_element = world.day_element
	end
	
	return found_rune_element
end

function get_obi(element)
	if element and elements.obi_of[element] then
		return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book: (set, book)
--	if player.sub_job == 'BLU' then
--		set_macro_page(2, 12)
--	else
		set_macro_page(1, 12)
--	end
end