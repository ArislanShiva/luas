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

	state.FlurryMode = M{['description']='Flurry Mode', 'Flurry II', 'Flurry I'}
	state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}

	-- Whether a warning has been given for low ammo
	state.warned = M(false)

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.RangedMode:options('STP', 'Normal', 'Acc', 'Critical')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.IdleMode:options('Normal', 'DT')
	
	state.CP = M(false, "Capacity Points Mode")
	
	gear.RAbullet = "Chrono Bullet"
	gear.WSbullet = "Chrono Bullet"
	gear.MAbullet = "Orichalc. Bullet"
	options.ammo_warning_limit = 10

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

	send_command('bind @f gs c cycle FlurryMode')
	send_command('bind @h gs c cycle HasteMode')
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
	send_command('unbind @f')
	send_command('unbind @h')
	send_command('unbind @c')
end


-- Set up all gear sets.
function init_gear_sets()

	------------------------------------------------------------------------------------------------
	---------------------------------------- Precast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Eagle Eye Shot'] = {legs="Arc. Braccae +1"}
	sets.precast.JA['Bounty Shot'] = {hands="Amini Glove. +1"}
	sets.precast.JA['Camouflage'] = {body="Orion Jerkin +1"}
	sets.precast.JA['Scavenge'] = {feet="Orion Socks +1"}
	sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +1"}
	sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +1"}


	-- Fast cast sets for spells

	sets.precast.Waltz = {
		body="Passion Jacket",
		hands="Slither Gloves +1",
		neck="Phalaina Locket",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		waist="Gishdubar Sash",
		}

	sets.precast.Waltz['Healing Waltz'] = {}

	sets.precast.FC = {
		head="Carmine Mask +1", --14
		body=gear.Taeon_FC_body, --8
		hands="Leyline Gloves", --7
		legs="Rawhide Trousers", --5
		feet="Carmine Greaves +1", --8
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Enchntr. Earring +1", --2
		ring2="Weather. Ring", --5(3)
		waist="Ninurta's Sash",
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		body="Passion Jacket",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})


	-- (10% Snapshot, 5% Rapid from Merits)
	sets.precast.RA = {
		ammo=gear.RAbullet,
		head="Taeon Chapeau", --10/0
		body=gear.Taeon_RA_body, --9/0
		hands="Carmine Fin. Ga. +1", --8/11
		legs=gear.Adhemar_RS_legs, --9/10
		feet="Meg. Jam. +1", --8/0
		back=gear.RNG_SNP_Cape, --10/0
		waist="Impulse Belt", --3/0
		} --57/11

	sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
		head="Orion Beret +1", --0/14
		waist="Yemaya Belt", --0/5
		}) --44/40

	sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
		body="Arcadian Jerkin +1", --0/12
		legs="Pursuer's Pants", --0/19
		waist="Impulse Belt", --3/0
		}) --29/56

	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
		ammo=gear.RAbullet,
		head="Meghanada Visor +1",
		body=gear.Herc_RA_body,
		hands="Carmine Fin. Ga. +1",
		legs="Meg. Chausses +2",
		feet=gear.Herc_RA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back=gear.RNG_WS2_Cape,
		waist="Fotia Belt",
		}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		hands="Meg. Gloves +2",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		waist="Kwahu Kachina Belt",
		})


	------------------------------------------------------------------------------------------------
	------------------------------------- Weapon Skill Sets ----------------------------------------
	------------------------------------------------------------------------------------------------

	sets.precast.WS['Apex Arrow'] = sets.precast.WS

	sets.precast.WS['Apex Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
		hands="Kobo Kote",
		feet="Meg. Jam. +1",
		ear2="Telos Earring",
		waist="Kwahu Kachina Belt",
		})

	sets.precast.WS["Jishnu's Radiance"] = set_combine(sets.precast.WS, {
		body="Adhemar Jacket",
		hands="Meg. Gloves +2",
		feet="Thereoid Greaves",
		ear1="Moonshade Earring",
		ear2="Mache Earring",
		ring1="Ramuh Ring +1",
		ring2="Ilabrat Ring",
		})

	sets.precast.WS["Jishnu's Radiance"].Acc = set_combine(sets.precast.WS["Jishnu's Radiance"], {
		body=gear.Herc_RA_body,
		neck="Combatant's Torque",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		ring1="Hajduk Ring +1",
		ring2="Hajduk Ring +1",
		waist="Kwahu Kachina Belt",
		})

	sets.precast.WS["Last Stand"] = set_combine(sets.precast.WS, {
		hands="Kobo Kote",
		neck="Fotia Gorget",
		ring1="Garuda Ring +1",
		ring2="Ilabrat Ring",
		})

	sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
		hands="Meg. Gloves +2",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring1="Hajduk Ring +1",
		ring2="Hajduk Ring +1",
		waist="Kwahu Kachina Belt",
		})
		
	sets.precast.WS["Trueflight"] = {
		ammo=gear.MAbullet,
		head=gear.Herc_MAB_head,
		body="Gyve Doublet",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_WS_feet,		
		neck="Baetyl Pendant",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Weather. Ring",
		ring2="Arvina Ringlet +1",
		back=gear.RNG_WS1_Cape,
		waist="Eschan Stone",
		}

	sets.precast.WS["Trueflight"].FullTP = {ear1="Hecate's Earring", waist="Svelt. Gouriz +1"}

	sets.precast.WS["Wildfire"] = set_combine(sets.precast.WS["Trueflight"], {ring1="Garuda Ring +1"})

	sets.precast.WS['Rampage'] = {
		head="Lilitu Headpiece",
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +2",
		legs=gear.Herc_WS_legs,
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
		hands=gear.Adhemar_TP_hands,
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_TA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ilabrat Ring",
		back="Bleating Mantle",
		waist="Fotia Belt",
		}
	
	
	------------------------------------------------------------------------------------------------
	---------------------------------------- Midcast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	-- Fast recast for spells
	
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		ammo="Impatiens", --10
		legs="Carmine Cuisses +1", --20
		ear1="Halasz Earring", --5
		ring1="Evanescence Ring", --5
		waist="Ninurta's Sash", --6
		}

	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

	-- Ranged sets

	sets.midcast.RA = {
		ammo=gear.RAbullet,
		head="Arcadian Beret +1",
		body=gear.Herc_RA_body,
		hands=gear.Adhemar_RA_hands,
		legs=gear.Adhemar_RA_legs,
		feet=gear.Herc_RA_feet,
		neck="Erudit. Necklace",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		ring1="Garuda Ring +1",
		ring2="Ilabrat Ring",
		back=gear.RNG_TP_Cape,
		waist="Yemaya Belt",
		}
	
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		head="Meghanada Visor +1",
		body="Meg. Cuirie +1",
		hands="Kobo Kote",
		legs="Meg. Chausses +2",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		ring1="Hajduk Ring +1",
		ring2="Hajduk Ring +1",
		waist="Kwahu Kachina Belt",
		})

	sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
		head="Mummu Bonnet +1",
		body="Mummu Jacket +1",
		hands="Mummu Wrists +1",
		legs="Mummu Kecks +1",
		feet="Mummu Gamash. +1",
		})
		
	sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
		body="Pursuer's Doublet",
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Dedition Earring",
		ring1="Apate Ring",
		})

		
	------------------------------------------------------------------------------------------------
	----------------------------------------- Idle Sets --------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.resting = {}

	-- Idle sets
	sets.idle = {
		ranged="Fomalhaut",
		ammo=gear.RAbullet,
		head=gear.Herc_DT_head,
		body="Meg. Cuirie +1",
		hands=gear.Herc_DT_hands,
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Kwahu Kachina Belt",
		}

	sets.idle.DT = set_combine (sets.idle, {
		head=gear.Herc_DT_head, --3/3
		body="Meg. Cuirie +1", --7/0
		hands=gear.Herc_DT_hands, --6/4
		feet="Meg. Jam. +1", --2/0
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		})
		
	sets.idle.Town = set_combine(sets.idle, {
		head="Arcadian Beret +1",
		body=gear.Herc_RA_body,
		hands="Kobo Kote",
		neck="Combatant's Torque",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back=gear.RNG_TP_Cape,
		})

		
	------------------------------------------------------------------------------------------------
	---------------------------------------- Defense Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT

	sets.Kiting = {legs="Carmine Cuisses +1"}


	------------------------------------------------------------------------------------------------
	---------------------------------------- Engaged Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- * DNC Subjob DW Trait: +15%
	-- * NIN Subjob DW Trait: +25%
	
	-- No Magic Haste (74% DW to cap)	
	sets.engaged = {
		ammo=gear.RAbullet,
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands="Floral Gauntlets", --5
		legs="Carmine Cuisses +1", --6
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Patentia Sash", --5
		} -- 39%

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		head="Carmine Mask +1",
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP = set_combine(sets.engaged, {
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 15% Magic Haste (67% DW to cap)
	sets.engaged.LowHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands="Floral Gauntlets", --5
		legs="Carmine Cuisses +1", --6
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Patentia Sash", --5
		} -- 39%

	sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, {
		head="Carmine Mask +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 30% Magic Haste (56% DW to cap)
	sets.engaged.MidHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands="Floral Gauntlets", --5
		legs="Carmine Cuisses +1", --6
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Patentia Sash", --5
		} -- 40%

	sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, {
		head="Carmine Mask +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 35% Magic Haste (51% DW to cap)
	sets.engaged.HighHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands="Floral Gauntlets", --5
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Patentia Sash", --5
		} -- 33%

	sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
		legs="Meg. Chausses +2",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Cessance Earring",
		ear2="Dedition Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 47% Magic Haste (36% DW to cap)
	sets.engaged.MaxHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Letalis Mantle",
		waist="Patentia Sash", --5
		} -- 19%

	sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
		legs="Meg. Chausses +2",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.buff.Barrage = set_combine(sets.midcast.RA.Acc, {hands="Orion Bracers +1"})
	sets.buff['Velocity Shot'] = set_combine(sets.midcast.RA, {body="Amini Caban +1", back=gear.RNG_TP_Cape})
	sets.buff['Double Shot'] = set_combine(sets.midcast.RA, {back=gear.RNG_TP_Cape})
--	sets.buff.Camouflage = {body="Orion Jerkin +1"}

	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

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
	-- Check that proper ammo is available if we're using ranged attacks or similar.
	if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
		do_bullet_checks(spell, spellMap, eventArgs)
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
--		if state.Buff['Velocity Shot'] then
--			equip( sets.buff['Velocity Shot'])
--		end
		if state.FlurryMode.value == 'Flurry II' and (buffactive[265] or buffactive[581]) then
			equip(sets.precast.RA.Flurry2)
		elseif state.FlurryMode.value == 'Flurry I' and (buffactive[265] or buffactive[581]) then
			equip(sets.precast.RA.Flurry1)
		end
	end
	-- Equip obi if weather/day matches for WS.
    if spell.type == 'WeaponSkill' then
		if spell.english == 'Trueflight' then
			if world.weather_element == 'Light' or world.day_element == 'Light' then
				equip(sets.Obi)
			end
			if player.tp > 2900 then
				equip(sets.precast.WS["Trueflight"].FullTP)
			end	
		elseif spell.english == 'Wildfire' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
			equip(sets.Obi)
		end
	end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and state.Buff.Barrage then
		equip(sets.buff.Barrage)
	end
--	if spell.action_type == 'Ranged Attack' and state.Buff['Velocity Shot'] and state.RangedMode.value == 'STP' then
--		equip(sets.buff['Velocity Shot'])
--	end
end


function job_aftercast(spell, action, spellMap, eventArgs)
	if spell.english == "Shadowbind" then
		send_command('@timers c "Shadowbind ['..spell.target.name..']" 42 down abilities/00122.png')
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
	end

	if buff == "Camouflage" then
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

	-- Gearswap can't detect the difference between Haste I and Haste II
	-- so use winkey-H to manually set Haste spell level.

	-- Haste (buffactive[33]) - 15%
	-- Haste II (buffactive[33]) - 30%
	-- Haste Samba - 5%/10%
	-- Victory March +0/+3/+4/+5	9.4%/14%/15.6%/17.1%
	-- Advancing March +0/+3/+4/+5  6.3%/10.9%/12.5%/14% 
	-- Embrava - 30%
	-- Mighty Guard (buffactive[604]) - 15%
	-- Geo-Haste (buffactive[580]) - 40%

	classes.CustomMeleeGroups:clear()

	if state.HasteMode.value == 'Haste II' then
		if(((buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604])) or
			(buffactive[33] and (buffactive[580] or buffactive.embrava)) or
			(buffactive.march == 2 and buffactive[604]) or buffactive.march == 3) then
			add_to_chat(122, 'Magic Haste Level: 43%')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba']) then
			add_to_chat(122, 'Magic Haste Level: 35%')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif ((buffactive[580] or buffactive[33] or buffactive.march == 2) or
			(buffactive.march == 1 and buffactive[604])) then
			add_to_chat(122, 'Magic Haste Level: 30%')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif (buffactive.march == 1 or buffactive[604]) then
			add_to_chat(122, 'Magic Haste Level: 15%')
			classes.CustomMeleeGroups:append('LowHaste')
		end
	else
		if (buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or
			(buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604])) or
			(buffactive.march == 2 and (buffactive[33] or buffactive[604])) or
			(buffactive[33] and buffactive[604] and buffactive.march ) or buffactive.march == 3 then
			add_to_chat(122, 'Magic Haste Level: 43%')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or
			(buffactive.march == 2 and buffactive['haste samba']) or
			(buffactive[580] and buffactive['haste samba'] ) then
			add_to_chat(122, 'Magic Haste Level: 35%')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif (buffactive.march == 2 ) or
			((buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
			(buffactive[580] ) or  -- geo haste
			(buffactive[33] and buffactive[604]) then
			add_to_chat(122, 'Magic Haste Level: 30%')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
			add_to_chat(122, 'Magic Haste Level: 15%')
			classes.CustomMeleeGroups:append('LowHaste')
		end
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
	elseif spell.action_type == 'Ranged Attack' then
		bullet_name = gear.RAbullet
		if buffactive['Double Shot'] then
			bullet_min_count = 2
		end
	end
	
	local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
	
	-- If no ammo is available, give appropriate warning and end.
	if not available_bullets then
		if spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
			add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
			return
		else
			add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
			eventArgs.cancel = true
			return
		end
	end
	
	-- Low ammo warning.
	if state.warned.value == false
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
	-- Default macro set/book: (set, book)
	if player.sub_job == 'DNC' then
		set_macro_page(1, 6)	
	else
		set_macro_page(2, 6)	
	end
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 5')
end