-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:

		Step Selector		Cycle through available primary and secondary step types,
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
	Custom step commands:
	
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
	state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

	state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
	state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
	state.UseAltStep = M(false, 'Use Alt Step')
	state.SelectStepTarget = M(false, 'Select Step Target')
	state.IgnoreTargetting = M(false, 'Ignore Targetting')
	state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}
	
	state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
--	state.SkillchainPending = M(false, 'Skillchain Pending')

	state.CP = M(false, "Capacity Points Mode")

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.IdleMode:options('Normal', 'DT')

	-- Additional local binds
	send_command('bind ^- gs c cycleback mainstep')
	send_command('bind ^= gs c cycle mainstep')
	send_command('bind !- gs c cycleback altstep')
	send_command('bind != gs c cycle altstep')
	send_command('bind !p gs c toggle usealtstep')
	send_command('bind ^` input /ja "Saber Dance" <me>')
	send_command('bind !` input /ja "Chocobo Jig II" <me>')
	send_command('bind ^, input /ja "Spectral Jig" <me>')
	send_command('unbind ^.')
	send_command('bind @h gs c cycle HasteMode')
	send_command('bind @c gs c toggle CP')

	select_default_macro_book()
	set_lockstyle()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind !p')
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^,')
	send_command('unbind @h')
	send_command('unbind @c')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	-- PRECAST SETS
	
	-- Enmity set
	sets.Enmity = {
		ammo="Sapience Orb", --2
		head="Halitus Helm", --8
		body="Emet Harness +1", --10
		hands="Kurys Gloves", --9
		neck="Unmoving Collar +1", --10
		ear1="Cryptic Earring", --4
		ear2="Friomisi Earring", --2
		ring1="Supershear Ring", --5
		ring2="Eihwaz Ring", --5
		waist="Trance Belt", --4
		}
		
	-- Job Ability Sets

	sets.precast.JA['Provoke'] = sets.Enmity

	sets.precast.JA['No Foot Rise'] = {
		body="Horos Casaque +1"
		}

	sets.precast.JA['Trance'] = {
		head="Horos Tiara +1"
		}
	  
	sets.precast.Waltz = {
		head="Horos Tiara +1", --11
		body="Maxixi Casaque +1", --15
		hands="Slither Gloves +1", --5
		feet="Maxixi Shoes +1", --10
		neck="Phalaina Locket", --(4)
		ear1="Roundel Earring", --5
		ring1="Asklepian Ring", --(3)
		ring2="Carb. Ring +1", --3
		back="Toetapper Mantle", --5
		waist="Gishdubar Sash", --(10)
		} -- Waltz Potency
		
	sets.precast.Waltz['Healing Waltz'] = {}
	sets.precast.Samba = {head="Maxixi Tiara +1", back=gear.DNC_TP_Cape}
	sets.precast.Jig = {legs="Horos Tights +1", feet="Maxixi Shoes +1"}

	sets.precast.Step = {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Meg. Gloves +1",
		legs="Meg. Chausses +1",
		feet=gear.Herc_Acc_feet,
		neck="Sanctity Necklace",
		ear1="Mache Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		back=gear.DNC_TP_Cape
		}

	sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {feet="Macu. Toeshoes +1"})

	sets.precast.Flourish1 = {}
	sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

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
		head="Meghanada Visor +1",
		body=gear.Herc_TA_body,
		hands="Meg. Gloves +1",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		neck="Combatant's Torque",
		ear1="Mache Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back=gear.DNC_TP_Cape,
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
		head=gear.Herc_MAB_head, --7
		body=gear.Taeon_FC_body, --8
		hands="Leyline Gloves", --7
		legs="Rawhide Trousers", --5
		feet=gear.Herc_MAB_feet, --2
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring2="Weather. Ring", --5(3)
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		ammo="Impatiens",
		body="Passion Jacket",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		waist="Ninurta's Sash",
		})
	   
	-- Weapon Skill Sets
	
	sets.precast.WS = {
		ammo="Focal Orb",
		head="Lilitu Headpiece",
		body="Meg. Cuirie +1",
		hands="Meg. Gloves +1",
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back=gear.DNC_WS1_Cape,
		waist="Fotia Belt",
		} -- default set
		
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		legs="Meg. Chausses +1",
		ring1="Ramuh Ring +1",
		ear2="Telos Earring",
		})
	
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="Ginsen",
		head="Adhemar Bonnet",
		legs="Meg. Chausses +1",
		feet="Meg. Jam. +1",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring2="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back=gear.DNC_WS2_Cape,
		})
		
	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		})

	sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
		ammo="Cheruski Needle",
		head="Adhemar Bonnet",
		body="Adhemar Jacket",
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		ear1="Mache Earring",
		ear2="Brutal Earring",
		ring1="Apate Ring",
		ring2="Epona's Ring",
		back=gear.DNC_WS2_Cape,
		})
		
	sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS['Pyrrhic Kleos'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Meg. Gloves +1",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Charis Feather",
		head="Adhemar Bonnet",
		body="Abnoba Kaftan",
		hands="Mummu Wrists +1",
		legs="Samnuha Tights", 
		feet=gear.Herc_TA_feet,
		ear2="Brutal Earring",
		ring1="Begrudging Ring",
		ring2="Epona's Ring",
		})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Meg. Gloves +1",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
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
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		})

	sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Baetyl Pendant",
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
	
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		ammo="Impatiens", --10
		ear1="Halasz Earring", --5
		ring1="Evanescence Ring", --5
		waist="Ninurta's Sash", --6
		}
		
	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt
	
	-- Resting sets
	sets.resting = {}
	

	-- Idle sets

	sets.idle = {
		ammo="Staunch Tathlum",
		head="Dampening Tam",
		body="Mekosu. Harness",
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet="Skd. Jambeaux +1",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt +1",
		}

	sets.idle.DT = set_combine (sets.idle, {
		ammo="Staunch Tathlum", --2/2
		head=gear.Herc_DT_head, --3/3
		body="Meg. Cuirie +1", --7/0
		hands=gear.Herc_DT_hands, --6/4
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		})

	sets.idle.Town = set_combine (sets.idle, {
		ammo="Ginsen",
		body="Adhemar Jacket",
		neck="Combatant's Torque",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back=gear.DNC_TP_Cape,
		waist="Windbuffet Belt +1",
		})
	
	sets.idle.Weak = sets.idle.DT
	
	-- Defense sets

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT

	sets.Kiting = {
		feet="Skd. Jambeaux +1",
		}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- * DNC Native DW Trait: 30% DW
	-- * DNC Job Points DW Gift: 5% DW
	
	-- No Magic Haste (74% DW to cap)
	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Macu. Casaque +1", --11
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Charis Necklace", --5
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.DNC_TP_Cape,
		waist="Patentia Sash", --5
		} -- 39%

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		body="Adhemar Jacket",
		ring2="Ramuh Ring +1",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP = set_combine(sets.engaged, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 15% Magic Haste (67% DW to cap)
	sets.engaged.LowHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Macu. Casaque +1", --11
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Charis Necklace", --5
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.DNC_TP_Cape,
		waist="Patentia Sash", --5
		} -- 30%

	sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		feet=gear.Herc_TA_feet,
		ring2="Ramuh Ring +1",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 30% Magic Haste (56% DW to cap)
	sets.engaged.MidHaste = {
		ammo="Ginsen",
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
		back=gear.DNC_TP_Cape,
		waist="Patentia Sash", --5
		} -- 19%

	sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
		feet=gear.Herc_TA_feet,
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 35% Magic Haste (51% DW to cap)
	sets.engaged.HighHaste = {
		ammo="Ginsen",
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
		back=gear.DNC_TP_Cape,
		waist="Windbuffet Belt +1",
		} -- 14% Gear

	sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
		ammo="Falcon Eye",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 47% Magic Haste (36% DW to cap)
	sets.engaged.MaxHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back=gear.DNC_TP_Cape,
		waist="Windbuffet Belt +1",
		} -- 0%

	sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		ring1="Chirich Ring",
		})

	sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
		ammo="Falcon Eye",
		ear1="Cessance Earring",
		ring2="Ramuh Ring +1",
		})

	sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		neck="Anu Torque",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
	sets.buff['Saber Dance'] = {legs="Horos Tights +1"}
	sets.buff['Fan Dance'] = {body="Horos Casaque +1"}
	sets.buff['Climactic Flourish'] = {head="Maculele Tiara +1"}
	
	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

	sets.CP = {back="Mecisto. Mantle"}
	sets.Reive = {neck="Ygnas's Resolve +1"}

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
--		if state.SkillchainPending.value == true then
--			equip(sets.precast.Skillchain)
--		end
	end
end


-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
--	if not spell.interrupted then
--		if spell.english == "Wild Flourish" then
--			state.SkillchainPending:set()
--			send_command('wait 5;gs c unset SkillchainPending')
--		elseif spell.type:lower() == "weaponskill" then
--			state.SkillchainPending:toggle()
--			send_command('wait 6;gs c unset SkillchainPending')
--		end
--	end
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
	elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
		handle_equipping_gear(player.status)
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

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	determine_haste_group()
end


function customize_idle_set(idleSet)
	if player.hpp < 80 and not areas.Cities:contains(world.area) then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
	end
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
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
	local msg = '[ Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value .. ' ]'
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
	end

	msg = msg .. '[ ' .. state.HasteMode.value .. ' ]'
	
	if state.Kiting.value then
		msg = msg .. '[ Kiting Mode: ON ]'
	end

	msg = msg .. '[ *'..state.MainStep.current

	if state.UseAltStep.value == true then
		msg = msg .. '/'..state.AltStep.current
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

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 1')
end