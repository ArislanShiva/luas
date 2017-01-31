-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:

		QuickDraw Selector	Cycle through available primary and secondary shot types,
							and trigger with a single macro
		Haste Detection		Detects current magic haste level and equips corresponding engaged set to
							optimize delay reduction (automatic)
		Haste Mode			Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Reive Detection		Automatically equips Reive bonus gear
		Auto. Lockstyle		Automatically locks specified equipset on file load
--]]


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
	-- QuickDraw Selector
	state.Mainqd = M{['description']='Primary Shot', 'Dark Shot', 'Earth Shot', 'Water Shot', 'Wind Shot', 'Fire Shot', 'Ice Shot', 'Thunder Shot'}
	state.Altqd = M{['description']='Secondary Shot', 'Earth Shot', 'Water Shot', 'Wind Shot', 'Fire Shot', 'Ice Shot', 'Thunder Shot', 'Dark Shot'}
	state.UseAltqd = M(false, 'Use Secondary Shot')
	state.SelectqdTarget = M(false, 'Select Quick Draw Target')
	state.IgnoreTargetting = M(false, 'Ignore Targetting')
	state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}

	state.Currentqd = M{['description']='Current Quick Draw', 'Main', 'Alt'}
	
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
	state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.RangedMode:options('Acc', 'Critical', 'STP', 'Normal')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.IdleMode:options('Normal', 'DT')

	state.WeaponLock = M(false, 'Weapon Lock')	
	state.CP = M(false, "Capacity Points Mode")

	gear.RAbullet = "Decimating Bullet"
	gear.WSbullet = "Decimating Bullet"
	gear.MAbullet = "Living Bullet"
	gear.QDbullet = "Living Bullet"
	options.ammo_warning_limit = 5

	-- Additional local binds
	send_command('bind ^` input /ja "Double-up" <me>')
	send_command('bind !` input /ja "Bolter\'s Roll" <me>')
	send_command ('bind @` gs c toggle LuzafRing')

	send_command('bind ^- gs c cycleback mainqd')
	send_command('bind ^= gs c cycle mainqd')
	send_command('bind !- gs c cycle altqd')
	send_command('bind != gs c cycleback altqd')
	send_command('bind ^[ gs c toggle selectqdtarget')
	send_command('bind ^] gs c toggle usealtqd')

	if player.sub_job == 'DNC' then
		send_command('bind ^, input /ja "Spectral Jig" <me>')
		send_command('unbind ^.')
	elseif player.sub_job == "RDM" or player.sub_job == "WHM" then
		send_command('bind ^, input /ma "Sneak" <stpc>')
		send_command('bind ^. input /ma "Invisible" <stpc>')
	else
		send_command('bind ^, input /item "Silent Oil" <me>')
		send_command('bind ^. input /item "Prism Powder" <me>')
	end

	send_command('bind @c gs c toggle CP')
	send_command('bind @h gs c cycle HasteMode')
	send_command('bind @w gs c toggle WeaponLock')

	select_default_macro_book()
	set_lockstyle()
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
	send_command('unbind @c')
	send_command('unbind @h')
	send_command('unbind @w')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

	------------------------------------------------------------------------------------------------
	---------------------------------------- Precast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
	sets.precast.JA['Snake Eye'] = {legs="Lanun Culottes"}
	sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +1"}
	sets.precast.JA['Random Deal'] = {body="Lanun Frac +1"}

	
	sets.precast.CorsairRoll = {
		range="Compensator",
		head="Lanun Tricorne +1",
		body="Meg. Cuirie +1",
		hands="Chasseur's Gants +1",
		legs="Desultor Tassets",
		feet="Lanun Bottes +1",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Etiolation Earring",
		ring1="Defending Ring",
		ring2="Barataria Ring",
		back="Camulus's Mantle",
		waist="Flume Belt +1",
		}
	
	sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chas. Culottes +1"})
	sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chass. Bottes +1"})
	sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chass. Tricorne +1"})
	sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
	sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
	
	sets.precast.LuzafRing = {ring1="Luzaf's Ring"}
	sets.precast.FoldDoubleBust = {hands="Lanun Gants +1"}
	
	sets.precast.CorsairShot = {}

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
		body="Taeon Tabard", --9
		hands="Leyline Gloves", --7
		legs="Rawhide Trousers", --5
		feet="Carmine Greaves +1", --8
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring1="Kishar Ring", --4
		ring2="Weather. Ring", --5(3)
		waist="Ninurta's Sash",
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		body="Passion Jacket",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})

	sets.precast.RA = {
		ammo=gear.RAbullet,
		head="Taeon Chapeau", --10/0
		body="Pursuer's Doublet", --6
		hands="Carmine Fin. Ga. +1", --8/11
		legs="Adhemar Kecks", --9
		feet="Meg. Jam. +1", --8
		back="Navarch's Mantle", --7
		waist="Impulse Belt", --3
		} -- 10% Gifts

	   
	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
	sets.precast.WS = {
		ammo=gear.WSbullet,
		head="Meghanada Visor +1",
		body="Laksa. Frac +2",
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet=gear.Herc_RA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back=gear.COR_WS3_Cape,
		waist="Fotia Belt",
		}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		feet="Meg. Jam. +1",
		ear2="Telos Earring",
		ring1="Cacoethic Ring +1",
		waist="Kwahu Kachina Belt",
		})


	------------------------------------------------------------------------------------------------
	------------------------------------- Weapon Skill Sets ----------------------------------------
	------------------------------------------------------------------------------------------------

	sets.precast.WS["Last Stand"] = sets.precast.WS

	sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
		ammo=gear.WSbullet,
		neck="Marked Gorget",
		ear2="Telos Earring",
		ring1="Cacoethic Ring +1",
		waist="Kwahu Kachina Belt",
		})

	sets.precast.WS['Wildfire'] = {
		ammo=gear.MAbullet,
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_WS_feet,
		neck="Baetyl Pendant",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Arvina Ringlet +1",
		ring2="Garuda Ring +1",
		back=gear.COR_WS1_Cape,
		waist="Eschan Stone",
		}
	
	sets.precast.WS['Leaden Salute'] = 	{
		ammo=gear.MAbullet,
		head="Pixie Hairpin +1",
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_WS_feet,
		neck="Baetyl Pendant",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Archon Ring",
		ring2="Garuda Ring +1",
		back=gear.COR_WS1_Cape,
		waist="Eschan Stone",
		}

	sets.precast.WS['Leaden Salute'].FullTP = {ear1="Hecate's Earring", waist="Svelt. Gouriz +1"}
		
	sets.precast.WS['Evisceration'] = {
		head="Adhemar Bonnet",
		body="Meg. Cuirie +1",
		hands=gear.Adhemar_Att_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Brutal Earring",
		ring1="Begrudging Ring",
		ring2="Epona's Ring",
		back=gear.COR_WS2_Cape,
		waist="Fotia Belt",
		}

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Evisceration'], {
		head="Lilitu Headpiece",
		body=gear.Herc_TA_body,
		hands="Meg. Gloves +1",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_TA_feet,
		neck="Caro Necklace",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		back=gear.COR_WS2_Cape,
		waist="Prosilio Belt +1",
		})
		
	sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
		body=gear.Herc_TA_body,
		feet=gear.Herc_Acc_feet,
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring1="Rufescent Ring",
		waist="Grunfeld Rope",
		})

	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS['Savage Blade'], {
		head="Meghanada Visor +1",
		body=gear.Herc_TA_body,
		feet="Carmine Greaves +1",
		neck="Fotia Gorget",
		ring1="Levia. Ring +1",
		ring2="Epona's Ring",
		back=gear.COR_WS2_Cape,
		waist="Fotia Belt",
		}) --MND

	sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
		body=gear.Herc_TA_body,
		feet=gear.Herc_Acc_feet,
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring1="Rufescent Ring",
		ring2="Ramuh Ring +1",
		})


	------------------------------------------------------------------------------------------------
	---------------------------------------- Midcast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		legs="Carmine Cuisses +1", --20
		ear1="Halasz Earring", --5
		ring1="Evanescence Ring", --5
		waist="Ninurta's Sash", --6
		}

	sets.midcast.Cure = {
		neck="Incanter's Torque",
		ear1="Roundel Earring",
		ear2="Mendi. Earring",
		ring1="Lebeche Ring",
		ring2="Haoma's Ring",
		waist="Bishop's Sash",
		}	

	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

	sets.midcast['Dark Magic'] = {
		ammo=gear.QDbullet,
		head=gear.Herc_MAB_head,
		body="Pursuer's Doublet",
		hands=gear.Adhemar_RA_hands,
		legs="Chas. Culottes +1",
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		ring2="Chirich Ring",
		back=gear.COR_RA_Cape,
		waist="Oneiros Rope",		
		}

	sets.midcast.CorsairShot = {
		ammo=gear.QDbullet,
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Carmine Fin. Ga. +1",
		legs=gear.Herc_MAB_legs,
		feet="Chass. Bottes +1",
		neck="Baetyl Pendant",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Fenrir Ring +1",
		ring2="Fenrir Ring +1",
		back=gear.COR_WS1_Cape,
		waist="Eschan Stone",
		}

	sets.midcast.CorsairShot.Resistant = set_combine(sets.midcast.CorsairShot, {
		head="Carmine Mask +1",
		body="Mummu Jacket +1",
		hands="Mummu Wrists +1",
		legs="Mummu Kecks +1",
		feet="Mummu Gamash. +1",
		neck="Sanctity Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Arvina Ringlet +1",
		ring2="Stikini Ring",
		waist="Kwahu Kachina Belt",
		})

	sets.midcast.CorsairShot['Light Shot'] = sets.midcast.CorsairShot.Resistant
	sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot.Resistant


	-- Ranged gear
	sets.midcast.RA = {
		ammo=gear.RAbullet,	
		head="Meghanada Visor +1",
		body="Laksa. Frac +2",
		hands=gear.Adhemar_RA_hands,
		legs="Adhemar Kecks",
		feet=gear.Herc_RA_feet,
		neck="Marked Gorget",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		ring1="Arvina Ringlet +1",
		ring2="Garuda Ring +1",
		back=gear.COR_RA_Cape,
		waist="Yemaya Belt",
		}

	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
		ammo=gear.RAbullet,
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet="Meg. Jam. +1",
		neck="Combatant's Torque",
		ring1="Cacoethic Ring +1",
		waist="Kwahu Kachina Belt",
		})

	sets.midcast.RA.Critical = set_combine(sets.midcast.RA.Acc, {
		head="Mummu Bonnet +1",
		body="Mummu Jacket +1",
		hands="Mummu Wrists +1",
		legs="Mummu Kecks +1",
		feet="Mummu Gamash. +1",
		})

	sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
		body="Pursuer's Doublet",
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ring1="Petrov Ring",
		ring2="Apate Ring",
		})


	------------------------------------------------------------------------------------------------
	----------------------------------------- Idle Sets --------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.resting = {}

	sets.idle = {
		ranged="Death Penalty",
		ammo=gear.MAbullet,
		head="Dampening Tam",
		body="Laksa. Frac +2",
		hands="Carmine Fin. Ga. +1",
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt +1",
		}

	sets.idle.DT = set_combine (sets.idle, {
		head=gear.Herc_DT_head, --3/3
		body="Meg. Cuirie +1", --7/0
		hands=gear.Herc_DT_hands, --6/4
		feet="Lanun Bottes +1", --4/0
		neck="Loricate Torque +1", --6/6
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		})

	sets.idle.Town = set_combine(sets.idle, {
		head="Carmine Mask +1",
		feet="Carmine Greaves +1",
		neck="Baetyl Pendant",
		ear1="Eabani Earring",
		ear2="Telos Earring",
		ring1="Arvina Ringlet +1",
		ring2="Garuda Ring +1",
		back=gear.COR_WS1_Cape,
		waist="Windbuffet Belt +1",
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

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- * DNC Subjob DW Trait: +15%
	-- * NIN Subjob DW Trait: +25%
	
	-- No Magic Haste (74% DW to cap)
	sets.engaged = {
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
		back=gear.COR_DW_Cape, --10
		waist="Shetal Stone", --6
		} -- 50%

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		head="Carmine Mask +1",
		hands=gear.Herc_Acc_hands,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP = set_combine(sets.engaged, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
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
		back=gear.COR_DW_Cape, --10
		waist="Shetal Stone", --6
		} -- 50%

	sets.engaged.LowHaste.LowAcc = set_combine(sets.engaged.LowHaste, {
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.LowHaste.MidAcc = set_combine(sets.engaged.LowHaste.LowAcc, {
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.LowHaste.HighAcc = set_combine(sets.engaged.LowHaste.MidAcc, {
		head="Carmine Mask +1",
		hands=gear.Herc_Acc_hands,
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.LowHaste.STP = set_combine(sets.engaged.LowHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 30% Magic Haste (56% DW to cap)
	sets.engaged.MidHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_Att_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.COR_DW_Cape, --10
		waist="Shetal Stone", --6
		} -- 39%

	sets.engaged.MidHaste.LowAcc = set_combine(sets.engaged.MidHaste, {
		hands=gear.Herc_TA_hands,
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidHaste.MidAcc = set_combine(sets.engaged.MidHaste.LowAcc, {
		legs="Meg. Chausses +1",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.MidHaste.HighAcc = set_combine(sets.engaged.MidHaste.MidAcc, {
		head="Carmine Mask +1",
		hands=gear.Herc_Acc_hands,
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MidHaste.STP = set_combine(sets.engaged.MidHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 35% Magic Haste (51% DW to cap)
	sets.engaged.HighHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_Att_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.COR_DW_Cape, --10
		waist="Shetal Stone", --6
		} -- 35%

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		hands=gear.Herc_TA_hands,
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, {
		legs="Meg. Chausses +1",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, {
		head="Carmine Mask +1",
		hands=gear.Herc_Acc_hands,
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.HighHaste.STP = set_combine(sets.engaged.HighHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})
		
	-- 47% Magic Haste (36% DW to cap)
	sets.engaged.MaxHaste = {
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_Att_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.COR_TP_Cape,
		waist="Shetal Stone", --6
		} -- 20%

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		hands=gear.Herc_TA_hands,
		ring1="Chirich Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, {
		legs="Meg. Chausses +1",
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, {
		head="Carmine Mask +1",
		hands=gear.Herc_Acc_hands,
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MaxHaste.STP = set_combine(sets.engaged.MaxHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

	sets.Obi = {waist="Hachirin-no-Obi"}
	sets.CP = {back="Mecisto. Mantle"}
	sets.Reive = {neck="Ygnas's Resolve +1"}

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
	end
	
	if spell.english == 'Fold' and buffactive['Bust'] == 2 then
		if sets.precast.FoldDoubleBust then
			equip(sets.precast.FoldDoubleBust)
			eventArgs.handled = true
		end
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Equip obi if weather/day matches for WS/Quick Draw.
	if spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
		if spell.english == 'Leaden Salute' then
			if world.weather_element == 'Dark' or world.day_element == 'Dark' then
				equip(sets.Obi)
			end
			if player.tp > 2900 then
				equip(sets.precast.WS['Leaden Salute'].FullTP)
			end	
		elseif spell.english == 'Wildfire' and (world.weather_element == 'Fire' or world.day_element == 'Fire') then
			equip(sets.Obi)
		elseif spell.type == 'CorsairShot' and (spell.element == world.weather_element or spell.element == world.day_element) then
			if spell.english ~= "Light Shot" and spell.english ~= "Dark Shot" then
				equip(sets.Obi)
			end
		end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if spell.type == 'CorsairRoll' and not spell.interrupted then
		display_roll_info(spell)
	end
end

function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
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

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if state.WeaponLock.value == true then
		disable('ranged')
	else
		enable('ranged')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end
	return idleSet
end

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.

function job_update(cmdParams, eventArgs)
	determine_haste_group()
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
		
		eventArgs.SelectNPCTargets = state.SelectqdTarget.value
	end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = ''
	
	msg = msg .. '[ Offense/Ranged: '..state.OffenseMode.current..'/'..state.RangedMode.current .. ' ]'
	msg = msg .. '[ WS: '..state.WeaponskillMode.current .. ' ]'

	if state.DefenseMode.value ~= 'None' then
		msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
	end
	
	if state.Kiting.value then
		msg = msg .. '[ Kiting Mode: ON ]'
	end

	msg = msg .. '[ ' .. state.HasteMode.value .. ' ]'

	msg = msg .. '[ *'..state.Mainqd.current

	if state.UseAltqd.value == true then
		msg = msg .. '/'..state.Altqd.current
	end
	
	msg = msg .. '* ]'
	
	add_to_chat(060, msg)

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

		local doqd = ''
		if state.UseAltqd.value == true then
			doqd = state[state.Currentqd.current..'qd'].current
			state.Currentqd:cycle()
		else
			doqd = state.Mainqd.current
		end		
		
		send_command('@input /ja "'..doqd..'" <t>')
	end
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
			(buffactive.march == 2 and buffactive[604])) then
			--add_to_chat(215, '---------- <<<< | Magic Haste Level: 43% | >>>> ----------')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba']) then
			--add_to_chat(004, '---------- <<<< | Magic Haste Level: 35% | >>>> ----------')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif ((buffactive[580] or buffactive[33] or buffactive.march == 2) or
			(buffactive.march == 1 and buffactive[604])) then
			--add_to_chat(008, '---------- <<<< | Magic Haste Level: 30% | >>>> ----------')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif (buffactive.march == 1 or buffactive[604]) then
			--add_to_chat(007, '---------- <<<< | Magic Haste Level: 15% | >>>> ----------')
			classes.CustomMeleeGroups:append('LowHaste')
		end
	else
		if (buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or
			(buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604])) or
			(buffactive.march == 2 and (buffactive[33] or buffactive[604])) or
			(buffactive[33] and buffactive[604] and buffactive.march ) then
			--add_to_chat(215, '---------- <<<< | Magic Haste Level: 43% | >>>> ----------')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or
			(buffactive.march == 2 and buffactive['haste samba']) or
			(buffactive[580] and buffactive['haste samba'] ) then
			--add_to_chat(004, '---------- <<<< | Magic Haste Level: 35% | >>>> ----------')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif (buffactive.march == 2 ) or
			((buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
			(buffactive[580] ) or  -- geo haste
			(buffactive[33] and buffactive[604]) then
			--add_to_chat(008, '---------- <<<< | Magic Haste Level: 30% | >>>> ----------')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
			--add_to_chat(007, '---------- <<<< | Magic Haste Level: 15% | >>>> ----------')
			classes.CustomMeleeGroups:append('LowHaste')
		end
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
		["Allies' Roll"]	= {lucky=3, unlucky=10, bonus="Skillchain Damage"},
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
		if spell.type == 'CorsairShotShot' and player.equipment.ammo ~= 'empty' then
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
		set_macro_page(1, 7)
	end
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 1')
end