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
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	

	DefaultAmmo = {['Steinthor'] = "Achiyal. Arrow", ['Holliday'] = "Achiyal. Bullet"}
	U_Shot_Ammo = {['Steinthor'] = "Achiyal. Arrow", ['Holliday'] = "Achiyal. Bullet"}

	select_default_macro_book()

	send_command('bind f9 gs c cycle RangedMode')
	send_command('bind ^f9 gs c cycle OffenseMode')
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind f9')
	send_command('unbind ^f9')
end


-- Set up all gear sets.
function init_gear_sets()
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Bounty Shot'] = 
	{
		hands="Amini Glove. +1"
	}
	
	sets.precast.JA['Barrage'] =
	{
		hands="Orion Bracers"
	}


	-- Fast cast sets for spells
    
    sets.precast.FC = 
	{
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
		back="Shadow Mantle", waist="Fotia Belt", legs="Herculean Trousers", feet="Herculean Boots"
	}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, 
	{
		body="Passion Jacket"
	})

	-- Ranged sets (snapshot)
	
	sets.precast.RA = 
	{
		head="Amini Gapette +1",
		body="Amini Caban +1", hands="Alruna's Gloves +1",
		back="Belenus's Cape", waist="Impulse Belt", legs="Adhemar Kecks",feet="Adhemar Gamashes"
	}


	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = 
	{
		head="Lilitu Headpiece", neck="Fotia Gorget", lear="Neritic Earring", rear="Moonshade Earring",
		body="Adhemar Jacket", hands="Meg. Gloves +1", lring="Apate Ring", rring="Garuda Ring",
		back="Belenus's Cape", waist="Fotia Belt", legs="Darraigner's Brais", feet="Meg. Jam. +1"
	}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, 
	{
		lring="Cacoethic Ring +1", rring="Cacoethic Ring"
	})
	
	sets.precast.WS["Jishnu's Radiance"] = set_combine(sets.precast.WS,
	{
		head="Adhemar Bonnet", lear="Pixie Earring",
		body="Abnoba Kaftan", lring="Begrudging Ring", rring="Ramuh Ring",
		legs="Herculean Trousers", feet="Thereoid Greaves"
	})
	
	sets.precast.WS["Jishnu's Radiance"].Acc = set_combine(sets.precast.WS["Jishnu's Radiance"],
	{
		lring="Cacoethic Ring +1", rring="Cacoethic Ring"
	})
	
	sets.precast.WS['Apex Arrow'] = set_combine(sets.precast.WS,
	{
		legs="Adhemar Kecks"
	})

	sets.precast.WS.Acc['Apex Arrow'] = set_combine(sets.precast.WS['Apex Arrow'], 
	{
		body="Kyujutsugi", rring="Cacoethic Ring +1",
	})
	
	sets.precast.WS['Refulgent Arrow'] = set_combine(sets.precast.WS,
	{
		body="Amini Caban +1", lring="Apate Ring", rring="Ifrit Ring",
		legs="Samnuha Tights"
	})

	sets.precast.WS.Acc['Refulgent Arrow'] = set_combine(sets.precast.WS, 
	{
		lring="Cacoethic Ring +1", rring="Cacoethic Ring"
	})
	
	sets.precast.WS['Trueflight'] = set_combine(sets.precast.WS,
	{
		head="Herculean Helm", neck="Fotia Gorget", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Apate Ring", rring="Garuda Ring",
		back="Belenus's Cape", waist="Fotia Belt", legs="Gyve Trousers", feet="Herculean Boots"
	})


	-- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.


	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = 
	{
		head="Herculean Helm", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Foppish Tunica", hands="Leyline Gloves", lring="Evanescence Ring", rring="Prolix Ring",
	}

	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.FastRecast

	-- Ranged sets

	sets.midcast.RA = 
	{
		head="Arcadian Beret +1", neck="Ocachi Gorget", ear1="Neritic earring", ear2="Telos Earring",
		body="Amini Caban +1", hands="Amini Glove. +1", lring="Cacoethic Ring", rring="Cacoethic Ring +1",
		back="Belenus's Cape", waist="Yemaya Belt", legs="Amini Brague +1", feet="Adhemar Gamashes"
	}
	
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA,
	{
		head="Arcadian Beret +1", neck="Marked Gorget", ear1="Neritic earring", ear2="Telos Earring",
		body="Amini Caban +1", hands="Meg. Gloves +1", lring="Cacoethic Ring", rring="Cacoethic Ring +1",
		back="Belenus's Cape", waist="Yemaya Belt", legs="Adhemar Kecks", feet="Meg. Jam. +1"
	})

	sets.midcast.RA.Steinthor = sets.midcast.RA

	sets.midcast.RA.Steinthor.Acc = set_combine(sets.midcast.RA.Acc)
	
	sets.midcast.RA.Holliday = sets.midcast.RA

	sets.midcast.RA.Holliday.Acc = set_combine(sets.midcast.RA.Acc, 
	{
		hands="Meg. Gloves +1"
	})
	
	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

	-- Sets to return to when not performing an action.

	-- Idle sets
	sets.idle = 
	{
		head="Dampening Tam", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Amini Caban +1", hands="Meg. Gloves +1", lring="Sheltered Ring", rring="Paguroidea Ring",
		back="Shadow Mantle", waist="Flume Belt", legs="Herculean Trousers", feet="Jute Boots +1"
	}

	sets.idle.PDT = set_combine (sets.idle, 
	{
		neck="Twilight Torque", 
		lring="Defending Ring", rring="Vocane Ring",
		feet="Herculean Boots"
	})

	sets.idle.MDT = set_combine (sets.idle, 
	{
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
		body="Samnuha Coat", hands="Leyline Gloves", lring="Defending Ring", rring="Vocane Ring",
		waist="Lieutenant's Sash"
	})
	
	sets.idle.Town = set_combine(sets.idle, 
	{
		body="Councilor's Garb",
		feet="Jute Boots +1"
	})
	
	-- Defense sets
	sets.defense.PDT = sets.idle.PDT

	sets.defense.MDT = sets.idle.MDT

	sets.Kiting =
	{
		feet="Jute Boots +1"
	}


	--------------------------------------
	-- Engaged sets
	--------------------------------------

	sets.engaged = 
	{
		head="Dampening Tam", neck="Combatant's Torque", lear="Digni. Earring", rear="Telos Earring",
		body="Herculean Vest", hands="Meg. Gloves +1", lring="Cacoethic Ring", rring="Cacoethic Ring +1",
		back="Shadow Mantle", waist="Eschan Stone", legs="Samnuha Tights", feet="Meg. Jam. +1"
	}

	sets.engaged.Acc = 
	{
		head="Dampening Tam", neck="Combatant's Torque", lear="Digni. Earring", rear="Telos Earring",
		body="Herculean Vest", hands="Meg. Gloves +1", lring="Cacoethic Ring", rring="Cacoethic Ring +1",
		back="Shadow Mantle", waist="Eschan Stone", legs="Samnuha Tights", feet="Meg. Jam. +1"
	}

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	
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
	
	if state.DefenseMode.value ~= 'None' and spell.type == 'WeaponSkill' then
		-- Don't gearswap for weaponskills when Defense is active.
		eventArgs.handled = true
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

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
		elseif player.inventory[player.equipment.ammo].count < 15 then
			add_to_chat(122,"Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low ("..player.inventory[player.equipment.ammo].count..")")
		end
	end
end



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 10)
end