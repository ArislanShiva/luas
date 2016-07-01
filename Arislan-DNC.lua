-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
	Custom commands:
	
	gs c step
		Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

	gs c step t
		Uses the currently configured step on the target, but forces use of <t>.
	
	
	Configuration commands:
	
	gs c cycle mainstep
		Cycles through the available steps to use as the primary step when using one of the above commands.
		
	gs c cycle altstep
		Cycles through the available steps to use for alternating with the configured main step.
		
	gs c toggle usealtstep
		Toggles whether or not to use an alternate step.
		
	gs c toggle selectsteptarget
		Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

	state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
	state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
	state.UseAltStep = M(false, 'Use Alt Step')
	state.SelectStepTarget = M(false, 'Select Step Target')
	state.IgnoreTargetting = M(false, 'Ignore Targetting')

	state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
	state.SkillchainPending = M(false, 'Skillchain Pending')

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.IdleMode:options('Normal', 'PDT', 'MDT')

	gear.default.weaponskill_neck = "Asperity Necklace"
	gear.default.weaponskill_waist = "Kentarch Belt +1"

	-- Additional local binds
	send_command('bind ^= gs c cycle mainstep')
	send_command('bind != gs c cycle altstep')
	send_command('bind ^- gs c toggle selectsteptarget')
	send_command('bind !- gs c toggle usealtstep')
	send_command('bind ^` input /ja "Fan Dance" <me>')
	send_command('bind !` input /ja "Chocobo Jig II" <me>')
	send_command('bind ^, input /ja "Spectral Jig" <me>')

	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^=')
	send_command('unbind !=')
	send_command('unbind ^-')
	send_command('unbind !-')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^,')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	-- PRECAST SETS
	
	
	-- Job Ability Sets

	sets.precast.JA['No Foot Rise'] = {
		body="Horos Casaque +1"
		}

	sets.precast.JA['Trance'] = {
		head="Horos Tiara +1"
		}
	  
	sets.precast.Waltz = {
		head="Horos Tiara +1",
		body="Maxixi Casaque +1",
		hands="Slither Gloves +1",
		legs="Horos Tights +1",
		feet="Maxixi Shoes +1",
		ear1="Roundel Earring",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		back="Toetapper Mantle",
		} -- Waltz Potency
		
	sets.precast.Waltz['Healing Waltz'] = {}

	
	sets.precast.Samba = {
		head="Maxixi Tiara +1",
		back="Senuna's Mantle",
		}

		
	sets.precast.Jig = {
		legs="Horos Tights +1",
		feet="Maxixi Shoes +1"
		}

		
	sets.precast.Step = {
		back="Senuna's Mantle",
		}
	
	sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {
		feet="Charis Shoes +1"
		})

	sets.precast.Flourish1 = {}
	
	sets.precast.Flourish1['Violent Flourish'] = {
		head="Dampening Tam",
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs="Horos Tights +1",
		feet=gear.Taeon_DW_feet,
		ear1="Digni. Earring",
		ear2="Hermetic Earring",
		ring2="Weather. Ring",
		} -- Magic Accuracy
		
	sets.precast.Flourish1['Desperate Flourish'] = {
		ammo="Charis Feather",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_TA_hands,
		legs=gear.Herc_TA_legs,
		feet=gear.Herc_TA_feet,
		neck="Lissome Necklace",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Senuna's Mantle",
		} -- Accuracy

	sets.precast.Flourish2 = {}
	
	sets.precast.Flourish2['Reverse Flourish'] = {
		hands="Macu. Bangles +1",
		back="Toetapper Mantle",
		}

	sets.precast.Flourish3 = {}
	
	sets.precast.Flourish3['Striking Flourish'] = {body="Macu. Casaque +1"}
	
	sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara +1",}
	
	sets.precast.FC = {
		ammo="Sapience Orb",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		feet=gear.Herc_MAB_feet,
		neck="Orunmila's Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		ring1="Prolix Ring",
		ring2="Weather. Ring",
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})
	   
	-- Weapon Skill Sets
	
	sets.precast.WS = {
		ammo="Focal Orb",
		head="Lilitu Headpiece",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Senuna's Mantle",
		waist=gear.ElementalBelt,
		} -- default set
		
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		legs="Adhemar Kecks",
		ring1="Ramuh Ring +1",
		})
	
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="Ginsen",
		head="Adhemar Bonnet",
		legs=gear.Herc_TA_legs,
		feet=gear.Herc_TA_feet,
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		})
		
	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_TA_hands,
		legs="Adhemar Kecks",
		ear2="Zennaroi Earring",
		ring1="Cacoethic Ring +1",
		})

	sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
		head="Adhemar Bonnet",
		legs="Samnuha Tights",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		})
		
	sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS['Pyrrhic Kleos'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_TA_hands,
		legs="Adhemar Kecks",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Falcon Eye",
		head="Adhemar Bonnet",
		ring1="Ramuh Ring +1",
		})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_TA_hands,
		legs="Adhemar Kecks",
		feet=gear.Herc_TA_feet,
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		})

	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
		ammo="Charis Feather",
		neck="Caro Necklace",
		ring2="Ramuh Ring +1",
		waist="Grunfeld Rope",
		})

	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {
		ammo="Falcon Eye",
		legs="Adhemar Kecks",
		ring1="Ramuh Ring +1",
		})

	sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back="Argocham. Mantle",
		waist="Eschan Stone",
		}
	
	sets.precast.Skillchain = {
		hands="Macu. Bangles +1",
		}
	
	
	-- MIDCAST SETS
	
	sets.midcast.FastRecast = {
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		}
		
	-- Specific spells
	sets.midcast.Utsusemi = {
		ear2="Loquacious Earring",
		waist="Ninurta's Sash",
		}

	
	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {}
	

	-- Idle sets

	sets.idle = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Mekosu. Harness",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet="Tandava Crackows",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt",
		}

	sets.idle.PDT = set_combine (sets.idle, {
		body="Horos Casaque +1",
		hands=gear.Herc_TA_hands,
		neck="Loricate Torque +1", 
		ear1="Genmei Earring",
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1",
		back="Solemnity Cape",
		waist="Flume Belt",
		})

	sets.idle.MDT = set_combine (sets.idle, {
		head="Dampening Tam",
		neck="Loricate Torque +1",
		ring1="Defending Ring", 
		ear1="Etiolation Earring",
		ring2=gear.DarkRing,
		back="Solemnity Cape",
		})

	sets.idle.Town = set_combine (sets.idle, {
		body="Adhemar Jacket",
		neck="Lissome Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Senuna's Mantle",
		waist="Windbuffet Belt +1",
		})
	
	sets.idle.Weak = sets.idle
	
	-- Defense sets

	sets.defense.PDT = {
		body="Horos Casaque +1", --4
		hands=gear.Herc_TA_hands, --2
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Defending Ring", --10
		ring2="Gelatinous Ring +1", --7
		back="Solemnity Cape", --4
		waist="Flume Belt", --4
		}

	sets.defense.MDT = {
		head="Dampening Tam", --4
		neck="Loricate Torque +1", --6
		ear1="Etiolation Earring", --3
		ring1="Defending Ring", --10
		back="Solemnity Cape", --4
		}

	sets.Kiting = {
		feet="Tandava Crackows",
		}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet,
		neck="Charis Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Senuna's Mantle",
		waist="Patentia Sash",
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		legs="Adhemar Kecks",
		neck="Subtlety Spec.",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.Fodder = set_combine(sets.engaged, {
		body="Thaumas Coat",
		waist="Sinew Belt",
		})

	sets.engaged.HighHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Senuna's Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear2="Zennaroi Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, {
		legs="Adhemar Kecks",
		neck="Subtlety Spec.",
		ear1="Digni. Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.HighHaste.Fodder = set_combine(sets.engaged.HighHaste, {
		body="Thaumas Coat",
		waist="Sinew Belt",
		})

	sets.engaged.MaxHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Senuna's Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear2="Zennaroi Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, {
		legs="Adhemar Kecks",
		neck="Subtlety Spec.",
		ear1="Digni. Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MaxHaste.Fodder = set_combine(sets.engaged.MaxHaste, {
		body="Thaumas Coat",
		waist="Sinew Belt",
		})

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	sets.buff['Saber Dance'] = {legs="Horos Tights +1"}
	sets.buff['Fan Dance'] = {body="Horos Casaque +1"}
	sets.buff['Climactic Flourish'] = {head="Maculele Tiara +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	--auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == "WeaponSkill" then
		if state.Buff['Climactic Flourish'] then
			equip(sets.buff['Climactic Flourish'])
		end
		if state.SkillchainPending.value == true then
			equip(sets.precast.Skillchain)
		end
	end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.english == "Wild Flourish" then
			state.SkillchainPending:set()
			send_command('wait 5;gs c unset SkillchainPending')
		elseif spell.type:lower() == "weaponskill" then
			state.SkillchainPending:toggle()
			send_command('wait 6;gs c unset SkillchainPending')
		end
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
	if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
		handle_equipping_gear(player.status)
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

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	determine_haste_group()
end


function customize_idle_set(idleSet)
	if player.hpp < 80 and not areas.Cities:contains(world.area) then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
	end
	
	return idleSet
end

function customize_melee_set(meleeSet)
	if state.DefenseMode.value ~= 'None' then
		if buffactive['saber dance'] then
			meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
		end
		if state.Buff['Climactic Flourish'] then
			meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
		end
	end
	
	return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
	if spell.type == 'Step' then
		if state.IgnoreTargetting.value == true then
			state.IgnoreTargetting:reset()
			eventArgs.handled = true
		end
		
		eventArgs.SelectNPCTargets = state.SelectStepTarget.value
	end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = 'Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ', WS: ' .. state.WeaponskillMode.value
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
	end
	
	if state.Kiting.value then
		msg = msg .. ', Kiting'
	end

	msg = msg .. ', ['..state.MainStep.current

	if state.UseAltStep.value == true then
		msg = msg .. '/'..state.AltStep.current
	end
	
	msg = msg .. ']'

	if state.SelectStepTarget.value == true then
		steps = steps..' (Targetted)'
	end

	add_to_chat(122, msg)

	eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1] == 'step' then
		if cmdParams[2] == 't' then
			state.IgnoreTargetting:set()
		end

		local doStep = ''
		if state.UseAltStep.value == true then
			doStep = state[state.CurrentStep.current..'Step'].current
			state.CurrentStep:cycle()
		else
			doStep = state.MainStep.current
		end		
		
		send_command('@input /ja "'..doStep..'" <t>')
	end
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
	
	if buffactive.embrava and (buffactive.haste or buffactive.march) and buffactive['haste samba'] then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.embrava and (buffactive.haste or buffactive.march or buffactive['haste samba']) then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 1 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 2 and (buffactive.haste or buffactive['haste samba']) then
		classes.CustomMeleeGroups:append('HighHaste')
	end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
	if spell.type == 'Step' then
		local allRecasts = windower.ffxi.get_ability_recasts()
		local prestoCooldown = allRecasts[236]
		local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
		 
		if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
			cast_delay(1.1)
			send_command('input /ja "Presto" <me>')
		end
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book: (set, book)
	if player.sub_job == 'WAR' then
		set_macro_page(1, 2)
	elseif player.sub_job == 'THF' then
		set_macro_page(2, 2)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 2)
	elseif player.sub_job == 'RUN' then
		set_macro_page(4, 2)
	elseif player.sub_job == 'SAM' then
		set_macro_page(5, 2)
	else
		set_macro_page(1, 2)
	end
end
