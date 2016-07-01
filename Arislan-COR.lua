-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[

	Custom commands:
	
	gs c qd
		Uses the currently configured shot on the target, with either <t> or <stnpc> depending on setting.

	gs c qd t
		Uses the currently configured shot on the target, but forces use of <t>.
	
	
	Configuration commands:
	
	gs c cycle mainqd
		Cycles through the available steps to use as the primary shot when using one of the above commands.
		
	gs c cycle altqd
		Cycles through the available steps to use for alternating with the configured main shot.
		
	gs c toggle usealtqd
		Toggles whether or not to use an alternate shot.
		
	gs c toggle selectqdtarget
		Toggles whether or not to use <stnpc> (as opposed to <t>) when using a shot.
		
		
	gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
	
	Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
	for ranged weaponskills, but not actually meleeing.
	
	Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	-- QuickDraw Selector
	state.MainQD = M{['description']='Primary Shot', 'Dark Shot', 'Earth Shot', 'Water Shot', 'Wind Shot', 'Fire Shot', 'Ice Shot', 'Thunder Shot'}
	state.AltQD = M{['description']='Secondary Shot', 'Earth Shot', 'Water Shot', 'Wind Shot', 'Fire Shot', 'Ice Shot', 'Thunder Shot', 'Dark Shot'}
	state.UseAltQD = M(false, 'Use Secondary Shot')
	state.SelectQDTarget = M(false, 'Select Quick Draw Target')
	state.IgnoreTargetting = M(false, 'Ignore Targetting')

	state.CurrentQD = M{['description']='Current Quick Draw', 'Main', 'Alt'}
	
	-- Whether to use Luzaf's Ring
	state.LuzafRing = M(false, "Luzaf's Ring")
	-- Whether a warning has been given for low ammo
	state.warned = M(false)

	define_roll_values()
	determine_haste_group()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
	state.RangedMode:options('Normal', 'Acc', 'Fodder')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'PDT', 'MDT')

	gear.RAbullet = "Adlivun Bullet"
	gear.WSbullet = "Adlivun Bullet"
	gear.MAbullet = "Orichalc. Bullet"
	gear.QDbullet = "Animikii Bullet"
	options.ammo_warning_limit = 5

	-- Additional local binds
	send_command('bind ^` input /ja "Double-up" <me>')
	send_command('bind !` input /ja "Bolter\'s Roll" <me>')
	send_command ('bind @` gs c toggle LuzafRing')

	send_command('bind ^- gs c cycle mainqd')
	send_command('bind ^= gs c cycleback mainqd')
	send_command('bind !- gs c cycle altqd')
	send_command('bind != gs c cycleback altqd')
	send_command('bind ^[ gs c toggle selectqdtarget')
	send_command('bind ^] gs c toggle usealtqd')
	send_command('bind ^, input /ja "Spectral Jig" <me>')

	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind @`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind ^[')
	send_command('unbind ^]')
	send_command('unbind ^,')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	-- Precast Sets
	
	sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
	sets.precast.JA['Snake Eye'] = {legs="Lanun Culottes"}
	sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +1"}
	sets.precast.JA['Random Deal'] = {body="Lanun Frac +1"}

	
	sets.precast.CorsairRoll = {
--		range="Compensator",
		head="Lanun Tricorne +1",
		body="Lanun Frac +1",
		hands="Chasseur's Gants +1",
		legs="Desultor Tassets",
		legs="Desultor Tassets",
		feet="Lanun Bottes +1",
		neck="Loricate Torque +1",
		ring1="Barataria Ring",
		back="Camulus's Mantle",
		waist="Flume Belt",
		}
	
	sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes"})
	sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +1"})
	sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +1"})
	sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
	sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
	
	sets.precast.LuzafRing = {ring2="Luzaf's Ring"}
	sets.precast.FoldDoubleBust = {hands="Lanun Gants +1"}
	
	sets.precast.CorsairShot = {}

	sets.precast.Waltz = {
		hands="Slither Gloves +1",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		} -- CHR and VIT

	sets.precast.Waltz['Healing Waltz'] = {}
	
	sets.precast.FC = {
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs="Carmine Cuisses +1",
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

	sets.precast.RA = {
		ammo=gear.RAbullet,
		head="Aurore Beret +1", --5
		body="Lak. Frac +1",
		hands="Carmine Fin. Ga. +1", --8
		legs="Adhemar Kecks", --9
		feet="Wurrukatte Boots", --6
		back="Navarch's Mantle", --6.5
		waist="Impulse Belt", --3
		}

	   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
		ammo=gear.WSbullet,
		head="Pursuer's Beret",
		body="Chasseur's Frac +1",
		hands="Carmine Fin. Ga. +1",
		legs="Pursuer's Pants",
		feet="Adhemar Gamashes",		
		neck=gear.ElementalGorget,
		ear1="Enervating Earring",
		ear2="Moonshade Earring",
		ring1="Arvina Ringlet +1",
		ring2="Garuda Ring +1",
		back=gear.COR_WS_Cape,
		waist=gear.ElementalBelt,
		}

	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

	sets.precast.WS["Last Stand"] = set_combine(sets.precast.WS['Last Stand'], {
		ring1="Garuda Ring +1",
		})

	sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
		ammo=gear.WSbullet,
		head="Chass. Tricorne +1",
		hands="Floral Gauntlets",
		feet=gear.Taeon_RA_feet,		
		neck="Bilious Torque",
		ring1="Cacoethic Ring +1",
		})

	sets.precast.WS['Wildfire'] = {
		ammo=gear.MAbullet,
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Arvina Ringlet +1",
		ring2="Garuda Ring +1",
		back=gear.COR_WS_Cape,
		waist="Eschan Stone",
		}
	
	sets.precast.WS['Leaden Salute'] = 	{
		ammo=gear.MAbullet,
		head="Pixie Hairpin +1",
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Archon Ring",
		ring2="Garuda Ring +1",
		back=gear.COR_WS_Cape,
		waist="Eschan Stone",
		}
		
	sets.precast.WS['Evisceration'] = {
		head="Adhemar Bonnet",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back=gear.COR_WS_Cape,
		waist=gear.ElementalBelt,
		}

	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS['Evisceration'], {
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		})
	
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Evisceration'], {
		head="Lilitu Headpiece",
		legs=gear.Herc_TA_legs,
		neck="Caro Necklace",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		waist="Prosilio Belt +1",
		})

	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS['Savage Blade'], {
		hands=gear.Herc_TA_hands,
		neck=gear.ElementalGorget,
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		back="Bleating Mantle",
		waist=gear.ElementalBelt,
		}) --MND
	
	-- Midcast Sets
	sets.midcast.FastRecast = {
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		}

	sets.midcast.Cure = {
		neck="Incanter's Torque",
		ear1="Roundel Earring",
		ear2="Mendi. Earring",
		ring1="Lebeche Ring",
		ring2="Haoma's Ring",
		waist="Bishop's Sash",
		}	

	sets.midcast.Utsusemi = {
		waist="Ninurta's Sash",
		}

	sets.midcast.CorsairShot = {
		ammo=gear.QDbullet,
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
--		feet=gear.Herc_MAB_feet,
		feet="Chass. Bottes +1",
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		back=gear.COR_WS_Cape,
		waist="Eschan Stone",
		}

	sets.midcast.CorsairShot['Light Shot'] = set_combine(sets.midcast.CorsairShot, {
		hands="Leyline Gloves",
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Cacoethic Ring +1",
		ring2="Weather. Ring",
		})

	sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']


	-- Ranged gear
	sets.midcast.RA = {
		ammo=gear.RAbullet,	
		head="Pursuer's Beret",
		body="Chasseur's Frac +1",
		hands="Carmine Fin. Ga. +1",
		legs="Pursuer's Pants",
		feet="Adhemar Gamashes",
		neck="Marked Gorget",
		ear1="Enervating Earring",
		ear2="Neritic Earring",
		ring1="Arvina Ringlet +1",
		ring2="Garuda Ring +1",
		back="Gunslinger's Cape",
		waist="Yemaya Belt",
		}

	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		ammo=gear.RAbullet,
		head="Chass. Tricorne +1",
		hands="Floral Gauntlets",
		legs="Pursuer's Pants",
		neck="Bilious Torque",
		ring1="Cacoethic Ring +1",
		waist="Eschan Stone",
		})

	sets.midcast.RA.Fodder = set_combine(sets.midcast.RA, {
		ammo=gear.RAbullet,
		body="Chasseur's Frac +1",
		neck="Ocachi Gorget",
		waist="Ponente Sash",
		})

	-- Sets to return to when not performing an action.
	
	-- Resting sets
	sets.resting = {}
	
	-- Idle sets
	sets.idle = {
		ammo=gear.RAbullet,
		head="Dampening Tam",
		body="Mekosu. Harness",
		hands="Carmine Fin. Ga. +1",
		legs="Carmine Cuisses +1",
		feet=gear.Herc_TA_feet,
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt",
		}

	sets.idle.PDT = set_combine (sets.idle, {
		body="Lanun Frac +1",
		hands=gear.Herc_TA_hands,
		feet="Lanun Bottes +1",
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
		back="Solemnity Cape",
		})

	sets.idle.Town = set_combine(sets.idle, {
		body="Lanun Frac +1",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back=gear.COR_WS_Cape,
		waist="Eschan Stone",
		})

	
	-- Defense sets
	sets.defense.PDT = {
		body="Lanun Frac +1", --4
		hands=gear.Herc_TA_hands, --2
		feet="Lanun Bottes +1", --4
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
		ring1="Defending Ring", --10
		ear1="Etiolation Earring", --3
		back="Solemnity Cape", --4
		}
	

	sets.Kiting = {legs="Carmine Cuisses +1"}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	-- Normal melee group
	sets.engaged = {
		ammo=gear.RAbullet,
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Floral Gauntlets",
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet,
		neck="Lissome Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.COR_TP_Cape,
		waist="Windbuffet Belt +1",
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		legs=gear.Herc_TA_legs,
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		legs="Carmine Cuisses +1",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		legs="Carmine Cuisses +1",
		neck="Decimus Torque",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.Fodder = set_combine(sets.engaged, {
		body="Thaumas Coat",
		neck="Asperity Necklace",
		})

	sets.engaged.HighHaste = {
		ammo=gear.RAbullet,
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
		back=gear.COR_TP_Cape,
		waist="Windbuffet Belt +1",
		}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		hands=gear.Herc_TA_hands,
		legs=gear.Herc_TA_legs,
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, {
		legs="Adhemar Kecks",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, {
		legs="Carmine Cuisses +1",
		neck="Decimus Torque",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.HighHaste.Fodder = set_combine(sets.engaged.HighHaste, {
		body="Thaumas Coat",
		neck="Asperity Necklace",
		})

	sets.engaged.MaxHaste = {
		ammo=gear.RAbullet,
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Lissome Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.COR_TP_Cape,
		waist="Windbuffet Belt +1",
		}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		hands=gear.Herc_TA_hands,
		legs=gear.Herc_TA_legs,
		waist="Kentarch Belt +1",
		})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, {
		legs="Adhemar Kecks",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, {
		legs="Carmine Cuisses +1",
		neck="Decimus Torque",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MaxHaste.Fodder = set_combine(sets.engaged.MaxHaste, {
		body="Thaumas Coat",
		neck="Asperity Necklace",
		})

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	-- Check that proper ammo is available if we're using ranged attacks or similar.
	if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
		do_bullet_checks(spell, spellMap, eventArgs)
	end

	-- gear sets
	if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
		equip(sets.precast.LuzafRing)
	elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
		classes.CustomClass = 'Acc'
	elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
		if sets.precast.FoldDoubleBust then
			equip(sets.precast.FoldDoubleBust)
			eventArgs.handled = true
		end
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if spell.type == 'CorsairRoll' and not spell.interrupted then
		display_roll_info(spell)
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

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.

function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.

function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

function display_current_job_state(eventArgs)

end

function get_custom_wsmode(spell, spellMap, default_wsmode)
	if buffactive['Transcendancy'] then
		return 'Brew'
	end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
		state.OffenseMode:set('Ranged')
	end
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
	if spell.type == 'CorsairShot' then
		if state.IgnoreTargetting.value == true then
			state.IgnoreTargetting:reset()
			eventArgs.handled = true
		end
		
		eventArgs.SelectNPCTargets = state.SelectQDTarget.value
	end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = ''
	
	msg = msg .. 'Offense/Ranged: ['..state.OffenseMode.current..'/'..state.RangedMode.current
	msg = msg .. '], WS: ['..state.WeaponskillMode.current..']'

	if state.DefenseMode.value ~= 'None' then
		local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
		msg = msg .. ', Defense: ('..state.DefenseMode.value..' '..defMode..')'
	end
	
	if state.Kiting.value then
		msg = msg .. ', Kiting'
	end

	msg = msg .. ', ['..state.MainQD.current

	if state.UseAltQD.value == true then
		msg = msg .. '/'..state.AltQD.current
	end
	
	msg = msg .. ']'
	
	add_to_chat(122, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1] == 'qd' then
		if cmdParams[2] == 't' then
			state.IgnoreTargetting:set()
		end

		local doQD = ''
		if state.UseAltQD.value == true then
			doQD = state[state.CurrentQD.current..'QD'].current
			state.CurrentQD:cycle()
		else
			doQD = state.MainQD.current
		end		
		
		send_command('@input /ja "'..doQD..'" <t>')
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

function define_roll_values()
	rolls = {
		["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
		["Ninja Roll"]	   = {lucky=4, unlucky=8, bonus="Evasion"},
		["Hunter's Roll"]	= {lucky=4, unlucky=8, bonus="Accuracy"},
		["Chaos Roll"]	   = {lucky=4, unlucky=8, bonus="Attack"},
		["Magus's Roll"]	 = {lucky=2, unlucky=6, bonus="Magic Defense"},
		["Healer's Roll"]	= {lucky=3, unlucky=7, bonus="Cure Potency Received"},
		["Drachen Roll"]	  = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
		["Choral Roll"]	  = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
		["Monk's Roll"]	  = {lucky=3, unlucky=7, bonus="Subtle Blow"},
		["Beast Roll"]	   = {lucky=4, unlucky=8, bonus="Pet Attack"},
		["Samurai Roll"]	 = {lucky=2, unlucky=6, bonus="Store TP"},
		["Evoker's Roll"]	= {lucky=5, unlucky=9, bonus="Refresh"},
		["Rogue's Roll"]	 = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
		["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
		["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
		["Puppet Roll"]	 = {lucky=3, unlucky=7, bonus="Pet Magic Attack/Accuracy"},
		["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
		["Wizard's Roll"]	= {lucky=5, unlucky=9, bonus="Magic Attack"},
		["Dancer's Roll"]	= {lucky=3, unlucky=7, bonus="Regen"},
		["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
		["Naturalist's Roll"]	   = {lucky=3, unlucky=7, bonus="Enh. Magic Duration"},
		["Runeist's Roll"]	   = {lucky=4, unlucky=8, bonus="Magic Evasion"},
		["Bolter's Roll"]	= {lucky=3, unlucky=9, bonus="Movement Speed"},
		["Caster's Roll"]	= {lucky=2, unlucky=7, bonus="Fast Cast"},
		["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
		["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
		["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
		["Allies's Roll"]	= {lucky=3, unlucky=10, bonus="Skillchain Damage"},
		["Miser's Roll"]	 = {lucky=5, unlucky=7, bonus="Save TP"},
		["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
		["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
	}
end

function display_roll_info(spell)
	rollinfo = rolls[spell.english]
	local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

	if rollinfo then
		add_to_chat(104, '[ Lucky: '..tostring(rollinfo.lucky)..' / Unlucky: '..tostring(rollinfo.unlucky)..' ] '..spell.english..': '..rollinfo.bonus..' ('..rollsize..') ')
	end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
	local bullet_name
	local bullet_min_count = 1
	
	if spell.type == 'WeaponSkill' then
		if spell.skill == "Marksmanship" then
			if spell.element == 'None' then
				-- physical weaponskills
				bullet_name = gear.WSbullet
			else
				-- magical weaponskills
				bullet_name = gear.MAbullet
			end
		else
			-- Ignore non-ranged weaponskills
			return
		end
	elseif spell.type == 'CorsairShot' then
		bullet_name = gear.QDbullet
	elseif spell.action_type == 'Ranged Attack' then
		bullet_name = gear.RAbullet
		if buffactive['Triple Shot'] then
			bullet_min_count = 3
		end
	end
	
	local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
	
	-- If no ammo is available, give appropriate warning and end.
	if not available_bullets then
		if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
			add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
			return
		elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
--			add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
			return
		else
			add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
			eventArgs.cancel = true
			return
		end
	end
	
	-- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
	if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
		add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
		eventArgs.cancel = true
		return
	end
	
	-- Low ammo warning.
	if spell.type ~= 'CorsairShot' and state.warned.value == false
		and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
		local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
		--local border = string.repeat("*", #msg)
		local border = ""
		for i = 1, #msg do
			border = border .. "*"
		end
		
		add_to_chat(104, border)
		add_to_chat(104, msg)
		add_to_chat(104, border)

		state.warned:set()
	elseif available_bullets.count > options.ammo_warning_limit and state.warned then
		state.warned:reset()
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	if player.sub_job == 'DNC' then
		set_macro_page(1, 7)
	else
		set_macro_page(2, 7)
	end
end
