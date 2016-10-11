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
	state.Buff.Barrage = buffactive.Barrage or false
	state.Buff.Camouflage = buffactive.Camouflage or false
	state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
	state.Buff['Velocity Shot'] = buffactive['Velocity Shot'] or false
	state.Buff['Double Shot'] = buffactive['Double Shot'] or false
	
	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
	state.RangedMode:options('Normal', 'Acc', 'STP')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.IdleMode:options('Normal', 'DT')
	
	state.CP = M(false, "Capacity Points Mode")

	gear.default.weaponskill_neck = "Fotia Gorget"
	gear.default.weaponskill_waist = "Fotia Belt"
	
--	DefaultAmmo = {['Nobility'] = "Achiyal. Arrow", ['Doomsday'] = "Achiyal. Bullet"}
	DefaultAmmo = {['Nobility'] = "Achiyal. Arrow", ['Doomsday'] = "Orichalc. Bullet"}
	U_Shot_Ammo = {['Nobility'] = "Achiyal. Arrow", ['Doomsday'] = "Animikii Bullet"}

	-- Additional local binds
	send_command('bind ^` input /ja "Velocity Shot" <me>')
	send_command('bind !` input /ja "Double Shot" <me>')
	send_command ('bind @` input /ja "Scavenge" <me>')
	if player.sub_job == 'DNC' then
		send_command('bind ^, input /ja "Spectral Jig" <me>')
		send_command('unbind ^.')
	else
		send_command('bind ^, input /item "Silent Oil" <me>')
		send_command('bind ^. input /item "Prism Powder" <me>')
	end
	send_command('bind @c gs c toggle CP')

	select_default_macro_book()
	set_lockstyle()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind f9')
	send_command('unbind ^f9')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
	send_command('unbind ^,')
	send_command('unbind @c')
end


-- Set up all gear sets.
function init_gear_sets()
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Eagle Eye Shot'] = {legs="Arc. Braccae +1"}
	sets.precast.JA['Bounty Shot'] = {hands="Amini Glove. +1"}
--	sets.precast.JA['Camouflage'] = {body="Orion Jerkin +1"}
	sets.precast.JA['Scavenge'] = {feet="Htr. Socks +1"}
	sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +1"}
	sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +1"}


	-- Fast cast sets for spells

	sets.precast.Waltz = {
		hands="Slither Gloves +1",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		} -- CHR and VIT

	sets.precast.Waltz['Healing Waltz'] = {}

	sets.precast.FC = {
		head="Carmine Mask +1", --14
		body="Taeon Tabard", --9
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

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})


	-- Ranged sets (snapshot)
	
	sets.precast.RA = {
		head="Amini Gapette +1", --7
		body="Pursuer's Doublet", --6
		hands="Carmine Fin. Ga. +1", --8
		legs="Adhemar Kecks", --9
		feet="Meg. Jam. +1", --8
		back="Lutian Cape",
		waist="Impulse Belt", --3
		}


	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
		head=gear.Taeon_RA_head,
		body="Meg. Cuirie +1",
		hands="Carmine Fin. Ga. +1",
		legs="Meg. Chausses +1",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back="Belenus's Cape",
		waist="Fotia Belt",
		}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		head="Meghanada Visor +1",
		hands="Meg. Gloves +1",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		waist="Kwahu Kachina Belt",
		})

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

	sets.precast.WS['Apex Arrow'] = sets.precast.WS

	sets.precast.WS['Apex Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
		hands="Kobo Kote",
		feet="Meg. Jam. +1",
		waist="Kwahu Kachina Belt",
		})

	sets.precast.WS["Jishnu's Radiance"] = set_combine(sets.precast.WS, {
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Amini Brague +1",
		ear1="Mache Earring",
		ear2="Moonshade Earring",
		ring1="Apate Ring",
		ring2="Ramuh Ring +1",
		})

	sets.precast.WS["Jishnu's Radiance"].Acc = set_combine(sets.precast.WS["Jishnu's Radiance"], {
		head="Meghanada Visor +1",
		hands="Meg. Gloves +1",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		ear1="Enervating Earring",
		ring1="Cacoethic Ring +1",
		waist="Kwahu Kachina Belt",
		})

	sets.precast.WS["Last Stand"] = {
		hands="Kobo Kote",
		neck="Fotia Gorget",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		}

	sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
		head="Meghanada Visor +1",
		hands="Meg. Gloves +1",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		ring1="Cacoethic Ring +1",
		waist="Kwahu Kachina Belt",
		})
		
	sets.precast.WS["Trueflight"] = {
		head=gear.Herc_MAB_head,
		body="Gyve Doublet",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,		
		neck="Sanctity Necklace",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Weather. Ring",
		ring2="Arvina Ringlet +1",
		back="Argocham. Mantle",
		waist="Eschan Stone",
		}

	sets.precast.WS["Wildfire"] = sets.precast.WS["Trueflight"]

	sets.precast.WS['Rampage'] = {
		head="Lilitu Headpiece",
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +1",
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet=gear.Herc_TA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		back="Bleating Mantle",
		waist="Fotia Belt",
		}

	sets.precast.WS['Decimation'] = sets.precast.WS['Rampage']

	sets.precast.WS['Evisceration'] = {
		head="Adhemar Bonnet",
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet=gear.Herc_TA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Bleating Mantle",
		waist="Fotia Belt",
		}
	
	
	--------------------------------------
	-- Midcast sets
	--------------------------------------

	-- Fast recast for spells
	
	sets.midcast.FastRecast = {
		body="Samnuha Coat",
		ear1="Loquacious Earring",
		ear2="Etiolation Earring",
		}

	sets.midcast.Utsusemi = {
		waist="Ninurta's Sash",
		}

	-- Ranged sets

	sets.midcast.RA = {
		head="Arcadian Beret +1",
		body="Pursuer's Doublet",
		hands="Kobo Kote",
		legs="Amini Brague +1",
		feet="Carmine Greaves +1",
		neck="Ocachi Gorget",
		ear1="Enervating Earring",
		ear2="Neritic Earring",
		ring1="Apate Ring",
		ring2="Garuda Ring +1",
		back="Belenus's Cape",
		waist="Yemaya Belt",
		}
	
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		head="Meghanada Visor +1",
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		ring1="Cacoethic Ring +1",
		ring2="Garuda Ring +1",
		waist="Kwahu Kachina Belt",
		})
		
	sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
		hands="Amini Glove. +1",
		neck="Ainia Collar",
		ear2="Dedition Earring",
		ring2="Rajas Ring",
		})

	sets.midcast.RA.Doomsday = set_combine(sets.midcast.RA, {
		hands="Carmine Fin. Ga. +1",
		ring2="Arvina Ringlet +1",
		})

	sets.midcast.RA.Doomsday.Acc = set_combine(sets.midcast.RA.Acc, {
		hands="Carmine Fin. Ga. +1",
		ring2="Arvina Ringlet +1",
		waist="Kwahu Kachina Belt",
		})

	sets.midcast.RA.Doomsday.STP = set_combine(sets.midcast.RA.STP, {
		hands="Carmine Fin. Ga. +1",
		ring2="Arvina Ringlet +1",
		})
	
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

	-- Sets to return to when not performing an action.

	-- Resting sets
	sets.resting = {}

	-- Idle sets
	sets.idle = {
		head="Amini Gapette +1",
		body="Mekosu. Harness",
		hands="Carmine Fin. Ga. +1",
		legs="Carmine Cuisses +1",
		feet="Amini Bottillons +1",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Kwahu Kachina Belt",
		}

	sets.idle.DT = set_combine (sets.idle, {
		head="Dampening Tam", --0/4
		body="Meg. Cuirie +1", --7/0
		hands="Meg. Gloves +1", --3/0
		legs="Meg. Chausses +1", --5/0
		feet="Meg. Jam. +1", --2/0
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ear2="Etiolation Earring", --0/3
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		})
		
	sets.idle.Town = set_combine(sets.idle, {
		head="Arcadian Beret +1",
		body="Gyve Doublet",
		feet="Carmine Greaves +1",
		neck="Combatant's Torque",
		ear1="Enervating Earring",
		ear2="Neritic Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back="Belenus's Cape",
		})
	
	-- Defense sets
	sets.defense.PDT = {
		head="Dampening Tam", --0/4
		body="Meg. Cuirie +1", --7/0
		hands="Meg. Gloves +1", --3/0
		legs="Meg. Chausses +1", --5/0
		feet="Meg. Jam. +1", --2/0
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ear2="Etiolation Earring", --0/3
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		}

	sets.defense.MDT = sets.defense.PDT

	sets.Kiting = {
		legs="Carmine Cuisses +1",
		}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

	sets.engaged = {
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet,
		neck="Lissome Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		hands=gear.Herc_TA_hands,
		legs=gear.Herc_TA_legs,
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		legs="Adhemar Kecks",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		ear1="Mache Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.Fodder = set_combine(sets.engaged, {
		body="Thaumas Coat",
		neck="Asperity Necklace",
		back="Bleating Mantle",
		})

	sets.engaged.HighHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Lissome Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		hands=gear.Herc_TA_hands,
		legs=gear.Herc_TA_legs,
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, {
		legs="Adhemar Kecks",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		ear1="Mache Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.HighHaste.Fodder = set_combine(sets.engaged.HighHaste, {
		body="Thaumas Coat",
		neck="Asperity Necklace",
		back="Bleating Mantle",
		})

	sets.engaged.MaxHaste = {
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Lissome Necklace",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		hands=gear.Herc_TA_hands,
		legs=gear.Herc_TA_legs,
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, {
		legs="Adhemar Kecks",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		ear1="Mache Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MaxHaste.Fodder = set_combine(sets.engaged.MaxHaste, {
		body="Thaumas Coat",
		neck="Asperity Necklace",
		back="Bleating Mantle",
		})

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, {hands="Orion Bracers +1"})
	sets.buff['Velocity Shot'] = set_combine(sets.midcast.RA, {body="Amini Caban +1", back="Belenus's Cape"})
	sets.buff['Double Shot'] = set_combine(sets.midcast.RA, {back="Belenus's Cape"})
--	sets.buff.Camouflage = {body="Orion Jerkin +1"}

	sets.Obi = {waist="Hachirin-no-Obi"}
	sets.Reive = {neck="Ygnas's Resolve +1"}
	sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end

	if spell.action_type == 'Ranged Attack' or
		(spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
		check_ammo(spell, action, spellMap, eventArgs)
	end

	if spell.action_type == 'Ranged Attack' and state.Buff['Velocity Shot'] then
		equip(sets.buff['Velocity Shot'])
		eventArgs.handled = true
	end

	if spell.action_type == 'Ranged Attack' and state.Buff['Double Shot'] then
		equip(sets.buff['Double Shot'])
		eventArgs.handled = true
	end

	if state.DefenseMode.value ~= 'None' and spell.type == 'WeaponSkill' then
		-- Don't gearswap for weaponskills when Defense is active.
		eventArgs.handled = true
	end

end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Equip obi if weather/day matches for WS.
    if spell.type == 'WeaponSkill' then
		if spell.english == 'Trueflight' and (world.weather_element == 'Light' or world.day_element == 'Light') then
			equip(sets.Obi)
		elseif spell.english == 'Wildfire' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
			equip(sets.Obi)
		end
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
		eventArgs.handled = true
	end
	if spell.action_type == 'Ranged Attack' and state.Buff['Velocity Shot'] then
		equip(sets.buff['Velocity Shot'])
		eventArgs.handled = true
	end
	if spell.action_type == 'Ranged Attack' and state.Buff['Double Shot'] then
		equip(sets.buff['Double Shot'])
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	elseif buff == "Camouflage" then
		if gain then
			equip(sets.buff.Camouflage)
			disable('body')
		else
			enable('body')
		end
	end
	if buffactive['Reive Mark'] then
		equip(sets.Reive)
		disable('neck')
	else
		enable('neck')
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

function customize_idle_set(idleSet)
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end
	
	return idleSet
end

function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.

function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

function display_current_job_state(eventArgs)
	local msg = ''
	
	msg = msg .. '[ Offense/Ranged: '..state.OffenseMode.current..'/'..state.RangedMode.current
	msg = msg .. ' ][ WS: '..state.WeaponskillMode.current

	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ' ][ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
	end
	
	if state.Kiting.value then
		msg = msg .. ' ][ Kiting Mode: ON'
	end

	msg = msg .. ' ]'
	
	add_to_chat(060, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
	-- We have three groups of DW in gear: Charis body, Charis neck + DW earrings, and Patentia Sash.

	-- For high haste, we want to be able to drop one of the 10% groups (body, preferably).
	-- High haste buffs:
	-- 2x Marches + Haste
	-- 2x Marches + Haste Samba
	-- 1x March + Haste + Haste Samba
	-- Embrava + any other haste buff
	
	-- For max haste, we probably need to consider dropping all DW gear.
	-- Max haste buffs:
	-- Embrava + Haste/March + Haste Samba
	-- 2x March + Haste + Haste Samba

	classes.CustomMeleeGroups:clear()
	
	if buffactive.embrava and (buffactive.haste or buffactive.march) then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.embrava and (buffactive.haste or buffactive.march) then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 1 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	end
end

-- Check for proper ammo when shooting or weaponskilling
function check_ammo(spell, action, spellMap, eventArgs)
	-- Filter ammo checks depending on Unlimited Shot
	if state.Buff['Unlimited Shot'] then
		if player.equipment.ammo ~= U_Shot_Ammo[player.equipment.range] then
			if player.inventory[U_Shot_Ammo[player.equipment.range]] or player.wardrobe[U_Shot_Ammo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active. Using custom ammo.")
				equip({ammo=U_Shot_Ammo[player.equipment.range]})
			elseif player.inventory[DefaultAmmo[player.equipment.range]] or player.wardrobe[DefaultAmmo[player.equipment.range]] then
				add_to_chat(122,"Unlimited Shot active but no custom ammo available. Using default ammo.")
				equip({ammo=DefaultAmmo[player.equipment.range]})
			else
				add_to_chat(122,"Unlimited Shot active but unable to find any custom or default ammo.")
			end
		end
	else
		if player.equipment.ammo == U_Shot_Ammo[player.equipment.range] and player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Unlimited Shot not active. Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Removing Unlimited Shot ammo.")
					equip({ammo=empty})
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Removing Unlimited Shot ammo.")
				equip({ammo=empty})
			end
		elseif player.equipment.ammo == 'empty' then
			if DefaultAmmo[player.equipment.range] then
				if player.inventory[DefaultAmmo[player.equipment.range]] then
					add_to_chat(122,"Using Default Ammo")
					equip({ammo=DefaultAmmo[player.equipment.range]})
				else
					add_to_chat(122,"Default ammo unavailable.  Leaving empty.")
				end
			else
				add_to_chat(122,"Unable to determine default ammo for current weapon.  Leaving empty.")
			end
		elseif player.inventory[player.equipment.ammo].count < 10 then
			add_to_chat(122,"Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low ("..player.inventory[player.equipment.ammo].count..")")
		end
	end
end



-- Select default macro book on initial load or subjob change.

function select_default_macro_book()
	-- Default macro set/book: (set, book)
	if player.sub_job == 'DNC' then
		set_macro_page(1, 6)	
	elseif player.sub_job == 'NIN' then
		set_macro_page(2, 6)	
	elseif player.sub_job == 'WAR' then
		set_macro_page(3, 6)
	else
		set_macro_page(1, 6)
	end
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 1')
end