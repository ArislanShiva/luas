-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ ALT+F9 ]          Cycle Ranged Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+NumLock ]    Double Shot
--              [ CTRL+Numpad/ ]    Berserk/Meditate
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki
--              [ CTRL+Numpad- ]    Aggressor/Third Eye
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Trueflight
--              [ CTRL+Numpad8 ]    Last Stand
--              [ CTRL+Numpad4 ]    Wildfire
--
--  RA:         [ Numpad0 ]         Ranged Attack
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


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

    state.DualWield = M(false, 'Dual Wield III')

    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('STP', 'Normal', 'Acc', 'HighAcc', 'Critical')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'DT')

    state.CP = M(false, "Capacity Points Mode")

    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.ACCbullet = "Eradicating Bullet"
    gear.MAbullet = "Chrono Bullet"
    options.ammo_warning_limit = 10

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('bind ^` input /ja "Velocity Shot" <me>')
    send_command ('bind @` input /ja "Scavenge" <me>')

    if player.sub_job == 'DNC' then
        send_command('bind ^, input /ja "Spectral Jig" <me>')
        send_command('unbind ^.')
    else
        send_command('bind ^, input /item "Silent Oil" <me>')
        send_command('bind ^. input /item "Prism Powder" <me>')
    end

    send_command('bind @c gs c toggle CP')

    send_command('bind ^numlock input /ja "Double Shot" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end

    send_command('bind ^numpad7 input /ws "Trueflight" <t>')
    send_command('bind ^numpad8 input /ws "Last Stand" <t>')
    send_command('bind ^numpad4 input /ws "Wildfire" <t>')
    send_command('bind ^numpad6 input /ws "Coronach" <t>')
    send_command('bind ^numpad2 input /ws "Sniper Shot" <t>')
    send_command('bind ^numpad3 input /ws "Numbing Shot" <t>')

    send_command('bind numpad0 input /ra <t>')

    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
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
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
    send_command('unbind numpad0')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')
end


-- Set up all gear sets.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Eagle Eye Shot'] = {legs="Arc. Braccae +3"}
    sets.precast.JA['Bounty Shot'] = {hands="Amini Glove. +1"}
    sets.precast.JA['Camouflage'] = {body="Orion Jerkin +3"}
    sets.precast.JA['Scavenge'] = {feet="Orion Socks +3"}
    sets.precast.JA['Shadowbind'] = {hands="Orion Bracers +3"}
    sets.precast.JA['Sharpshot'] = {legs="Orion Braccae +1"}


    -- Fast cast sets for spells

    sets.precast.Waltz = {
        body="Passion Jacket",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        head="Carmine Mask +1", --14
        body=gear.Taeon_FC_body, --8
        hands="Leyline Gloves", --8
        legs="Rawhide Trousers", --5
        feet="Carmine Greaves +1", --8
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Weather. Ring +1", --6(4)
        waist="Rumination Sash",
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        ring2="Lebeche Ring",
        })


    -- (10% Snapshot, 5% Rapid from Merits)
    sets.precast.RA = {
        ammo=gear.RAbullet,
        head=gear.Taeon_RA_head, --10/0
        body="Oshosi Vest +1", --14/0
        hands="Carmine Fin. Ga. +1", --8/11
        legs=gear.Adhemar_D_legs, --9/10
        feet="Meg. Jam. +2", --10/0
        back=gear.RNG_SNP_Cape, --10/0
        waist="Yemaya Belt", --0/5
      } --61/16

    sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, {
        body="Amini Caban +1",
        }) --47/16

    sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
        head="Orion Beret +3", --0/18
        feet="Pursuer's Gaiters", --0/10
        waist="Impulse Belt", --3/0
        }) --30/49

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo=gear.RAbullet,
        head="Orion Beret +3",
        body=gear.Herc_RA_body,
        hands="Meg. Gloves +2",
        legs="Arc. Braccae +3",
        feet=gear.Herc_RA_feet,
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Regal Ring",
        ring2="Dingir Ring",
        back=gear.RNG_WS2_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo=gear.ACCbullet,
        feet="Orion Socks +3",
        neck="Combatant's Torque",
        ear2="Telos Earring",
        waist="Kwahu Kachina Belt",
        })

    sets.precast.WS['Apex Arrow'] = sets.precast.WS

    sets.precast.WS['Apex Arrow'].Acc = set_combine(sets.precast.WS['Apex Arrow'], {
        feet="Orion Socks +3",
        ear2="Telos Earring",
        waist="Kwahu Kachina Belt",
        })

    sets.precast.WS['Jishnu\'s Radiance'] = set_combine(sets.precast.WS, {
        head="Mummu Bonnet +2",
        body="Abnoba Kaftan",
        hands="Mummu Wrists +2",
        feet="Thereoid Greaves",
        ear1="Sherida Earring",
        ring1="Begrudging Ring",
        ring2="Mummu Ring",
        })

    sets.precast.WS['Jishnu\'s Radiance'].Acc = set_combine(sets.precast.WS['Jishnu\'s Radiance'], {
        body="Sayadio's Kaftan",
        legs="Mummu Kecks +2",
        neck="Iskur Gorget",
        ear1="Enervating Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Hajduk Ring +1",
        waist="Kwahu Kachina Belt",
        })

    sets.precast.WS["Last Stand"] = set_combine(sets.precast.WS, {
        neck="Fotia Gorget",
        })

    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS['Last Stand'], {
        ammo=gear.ACCbullet,
        legs=gear.Adhemar_C_legs,
    	feet="Orion Socks +3",
        neck="Iskur Gorget",
        ear2="Telos Earring",
        ring2="Hajduk Ring +1",
        waist="Kwahu Kachina Belt",
        })

    sets.precast.WS["Coronach"] = set_combine(sets.precast.WS['Last Stand'], {
        ear2="Sherida Earring",
        })

    sets.precast.WS["Coronach"].Acc = set_combine(sets.precast.WS['Coronach'], {
      ear2="Telos Earring",
      })

    sets.precast.WS["Trueflight"] = {
        ammo=gear.MAbullet,
        head="Orion Beret +3",
        body="Samnuha Coat",
        hands="Carmine Fin. Ga. +1",
        legs=gear.Herc_MWS_legs,
        feet=gear.Herc_MWS_feet,
        neck="Baetyl Pendant",
        ear1="Moonshade Earring",
        ear2="Friomisi Earring",
        ring1="Weather. Ring +1",
        ring2="Dingir Ring",
        back=gear.RNG_WS1_Cape,
        waist="Eschan Stone",
        }

    sets.precast.WS["Trueflight"].FullTP = {ear1="Novio Earring", waist="Svelt. Gouriz +1"}
    sets.precast.WS["Wildfire"] = set_combine(sets.precast.WS["Trueflight"], {ring1="Regal Ring"})

    sets.precast.WS['Evisceration'] = {
        head=gear.Adhemar_B_head,
        body="Abnoba Kaftan",
        hands="Mummu Wrists +2",
        legs="Samnuha Tights",
        feet=gear.Herc_STP_feet,
        neck="Fotia Gorget",
        ear2="Brutal Earring",
        ring1="Begrudging Ring",
        ring2="Mummu Ring",
        back=gear.RNG_TP_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        head="Dampening Tam",
        body=gear.Adhemar_B_body,
        legs=gear.Herc_WS_legs,
        ear2="Telos Earring",
        ring1="Regal Ring",
        })

    sets.precast.WS['Rampage'] = set_combine(sets.precast.WS['Evisceration'], {feet=gear.Herc_TA_feet})
    sets.precast.WS['Rampage'].Acc = sets.precast.WS['Evisceration'].Acc


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast recast for spells

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        legs="Carmine Cuisses +1", --20
        ring1="Evanescence Ring", --5
        waist="Rumination Sash", --10
        }

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    -- Ranged sets

    sets.midcast.RA = {
        ammo=gear.RAbullet,
        head="Arcadian Beret +2",
        body="Oshosi Vest +1",
        hands=gear.Adhemar_C_hands,
        legs=gear.Adhemar_C_legs,
        feet="Meg. Jam. +2",
        neck="Iskur Gorget",
        ear1="Enervating Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Dingir Ring",
        back=gear.RNG_RA_Cape,
        waist="Yemaya Belt",
        }

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {
        ammo=gear.ACCbullet,
        hands="Meg. Gloves +2",
        feet="Orion Socks +3",
        ring2="Hajduk Ring +1",
        })

    sets.midcast.RA.HighAcc = set_combine(sets.midcast.RA.Acc, {
        head="Orion Beret +3",
        body="Orion Jerkin +3",
        hands="Orion Bracers +3",
        legs="Meg. Chausses +2",
        waist="Kwahu Kachina Belt",
        })

    sets.midcast.RA.Critical = set_combine(sets.midcast.RA, {
        head="Meghanada Visor +2",
        body="Mummu Jacket +2",
        hands="Kobo Kote",
        legs="Mummu Kecks +2",
        feet="Oshosi Leggings",
        ring1="Begrudging Ring",
        ring2="Mummu Ring",
        waist="Kwahu Kachina Belt",
        })

    sets.midcast.RA.STP = set_combine(sets.midcast.RA, {
        feet=gear.Adhemar_D_feet,
        ear1="Dedition Earring",
        ring1="Ilabrat Ring",
        })

    sets.DoubleShot = {
        head="Oshosi Mask", --5
        body="Arc. Jerkin +3",
        hands="Oshosi Gloves", -- 4
        legs="Oshosi Trousers", --6
        feet="Oshosi Leggings", --3
        } --25


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    -- Idle sets
    sets.idle = {
        ammo=gear.RAbullet,
        head="Orion Beret +3",
        body="Oshosi Vest +1",
        hands="Orion Bracers +3",
        legs="Carmine Cuisses +1",
        feet="Ahosi Leggings",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back="Moonlight Cape",
        waist="Kwahu Kachina Belt",
        }

    sets.idle.DT = set_combine(sets.idle, {
        head="Meghanada Visor +2", --5/0
        body="Meg. Cuirie +2", --8/0
        hands=gear.Herc_DT_hands, --7/5
        neck="Loricate Torque +1", --6/6
        ear2="Etiolation Earring", --0/3
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Flume Belt +1", --4/0
        })

    sets.idle.Town = set_combine(sets.idle, {
        ammo=gear.ACCbullet,
        hands=gear.Adhemar_C_hands,
        neck="Iskur Gorget",
        ear1="Enervating Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Dingir Ring",
        back=gear.RNG_RA_Cape,
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

    sets.engaged = {
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body,
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Iskur Gorget",
        ear1="Cessance Earring",
        ear2="Brutal Earring",
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RNG_TP_Cape,
        waist="Windbuffet Belt +1",
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        head="Carmine Mask +1",
        feet=gear.Herc_STP_feet,
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        feet="Carmine Greaves +1",
        ring1="Chirich Ring",
        })

    -- * DNC Subjob DW Trait: +15%
    -- * NIN Subjob DW Trait: +25%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = {
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RNG_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 52%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {
        head="Dampening Tam",
        })

    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {
        head="Carmine Mask +1",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP = set_combine(sets.engaged.DW, {
        ring1="Chirich Ring",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = {
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands="Floral Gauntlets", --5
        legs="Carmine Cuisses +1", --6
        feet=gear.Taeon_DW_feet, --9
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RNG_TP_Cape,
        waist="Reiki Yotai", --7
        } -- 42%

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, {
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, {
        head="Carmine Mask +1",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {
        ring1="Chirich Ring",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = {
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RNG_TP_Cape,
        waist="Reiki Yotai", --7
      } -- 31%

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, {
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {
        ring1="Chirich Ring",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = {
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Eabani Earring", --4
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RNG_TP_Cape,
        waist="Reiki Yotai", --7
      } -- 27%

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, {
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {
        ring1="Chirich Ring",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = {
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Iskur Gorget",
        ear1="Suppanomimi", --5
        ear2="Telos Earring",
        ring1="Petrov Ring",
        ring2="Epona's Ring",
        back=gear.RNG_TP_Cape,
        waist="Windbuffet Belt +1",
        } -- 11%

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        head="Dampening Tam",
        waist="Kentarch Belt +1",
        })

    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {
        legs="Meg. Chausses +2",
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {
        head="Carmine Mask +1",
        legs="Carmine Cuisses +1",
        feet=gear.Herc_STP_feet,
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {
        ring1="Chirich Ring",
        })

    sets.engaged.DW.MaxHastePlus = set_combine(sets.engaged.DW.MaxHaste, {back=gear.RNG_DW_Cape})
    sets.engaged.DW.LowAcc.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHaste, {back=gear.RNG_DW_Cape})
    sets.engaged.DW.MidAcc.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHaste, {back=gear.RNG_DW_Cape})
    sets.engaged.DW.HighAcc.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHaste, {back=gear.RNG_DW_Cape})
    sets.engaged.DW.STP.MaxHastePlus = set_combine(sets.engaged.DW.STP.MaxHaste, {back=gear.RNG_DW_Cape})


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        head=gear.Adhemar_D_head, --4/0
        neck="Loricate Torque +1", --6/6
        ring2="Defending Ring", --10/10
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHastePlus = set_combine(sets.engaged.DW.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.LowAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.MidAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHastePlus = set_combine(sets.engaged.DW.HighAcc.MaxHastePlus, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHastePlus = set_combine(sets.engaged.DW.STP.MaxHastePlus, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Barrage = {hands="Orion Bracers +3"}
    sets.buff['Velocity Shot'] = set_combine(sets.midcast.RA, {body="Amini Caban +1", back=gear.RNG_TP_Cape})
    sets.buff.Camouflage = {body="Orion Jerkin +3"}

    sets.buff.Doom = {ring1="Eshmun's Ring", ring2="Eshmun's Ring", waist="Gishdubar Sash"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}
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

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
--        if state.Buff['Velocity Shot'] then
--            equip( sets.buff['Velocity Shot'])
--        end
        if spell.action_type == 'Ranged Attack' then
            if flurry == 2 then
                equip(sets.precast.RA.Flurry2)
            elseif flurry == 1 then
                equip(sets.precast.RA.Flurry1)
                end
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
    if spell.action_type == 'Ranged Attack' then
        if buffactive['Double Shot'] then
            equip(sets.DoubleShot)
        end
        if state.Buff.Barrage then
            equip(sets.buff.Barrage)
        end
--        if state.Buff['Velocity Shot'] and state.RangedMode.value == 'STP' then
--            equip(sets.buff['Velocity Shot'])
--        end
    end
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
-- If we gain or lose any flurry buffs, adjust gear.
    if S{'flurry'}:contains(buff:lower()) then
        if not gain then
            flurry = nil
            add_to_chat(122, "Flurry status cleared.")
        end
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

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

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


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.DualWield.value == true and player.sub_job == 'NIN' then
        meleeSet = set_combine(meleeSet, sets.LessDualWield)
    end

    return meleeSet
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

--Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
                end
            end
        end
    end)

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MaxHastePlus')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 27 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
        	    DW_needed = 0
                DW = false
      	    end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
          	if tonumber(cmdParams[3]) ~= Haste then
              	Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
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
                if state.WeaponskillMode.value == 'Acc' then
                    bullet_name = gear.ACCbullet
                else
                    bullet_name = gear.WSbullet
                end
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.action_type == 'Ranged Attack' then
        if state.RangedMode.value == 'Acc' or state.RangedMode == 'HighAcc' then
            bullet_name = gear.ACCbullet
        else
            bullet_name = gear.RAbullet
        end
        if buffactive['Double Shot'] then
            bullet_min_count = 2
        end
    end

    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]

    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'WeaponSkill' then
            if (state.WeaponskillMode.value == 'Acc' and player.equipment.ammo == gear.ACCbullet) or
            (state.WeaponskillMode.value ~= 'Acc' and players.equipment.ammo == gear.RAbullet) then
                add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
                return
            else
                add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
                eventArgs.cancel = true
                return
            end
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

function update_offense_mode()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 6)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
