-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Cycle Treasure Hunter Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ ALT+` ]           Flee
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad8 ]    Mandalic Stab
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
-- 
--  TH Modes:  None                 Will never equip TH gear
--             Tag                  Will equip TH gear sufficient for initial contact with a mob (either melee,
--
--             SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
--             Fulltime - Will keep TH gear equipped fulltime


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
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 1

    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'DT')

    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind !` input /ja "Flee" <me>')
    send_command('bind @c gs c toggle CP')

    send_command('bind ^numlock input /ja "Assassin\'s Charge" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end
	
    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad8 input /ws "Mandalic Stab" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')

    send_command('bind ^numpad0 input /ja "Sneak Attack" <me>')
    send_command('bind ^numpad. input /ja "Trick Attack" <me>')

    select_default_macro_book()
    set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')

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

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Ability Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.TreasureHunter = {
        hands="Plunderer's Armlets +1",
        feet="Skulk. Poulaines +1",
        waist="Chaac Belt",
        }
        
    sets.buff['Sneak Attack'] = {
        ammo="Yetshila",
        head="Pill. Bonnet +3",
        body="Pillager's Vest +3", 
        hands=gear.Adhemar_B_hands,
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        neck="Caro Necklace",
        ear1="Sherida Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        back=gear.THF_TP_Cape,
        }

    sets.buff['Trick Attack'] = {
        ammo="Yetshila",
        head="Pill. Bonnet +3",
        body="Pillager's Vest +3", 
        hands="Pillager's Armlets +1",
        legs="Pill. Culottes +3",
        feet="Meg. Jam. +2",
        neck="Magoraga Beads",
        ear2="Infused Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        back=gear.THF_TP_Cape,
        waist="Svelt. Gouriz +1",
        }

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Accomplice'] = {head="Skulker's Bonnet +1"}
    sets.precast.JA['Flee'] = {feet="Pill. Poulaines +2"}
    sets.precast.JA['Hide'] = {body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = {body="Skulker's Vest +1"}

    sets.precast.JA['Steal'] = {
        ammo="Barathrum", --3
        --head="Asn. Bonnet +2",
        hands="Pillager's Armlets +1",
        feet="Pill. Poulaines +2",
        }

    sets.precast.JA['Despoil'] = {ammo="Barathrum",    legs="Skulk. Culottes +1", feet="Skulk. Poulaines +1"}
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = {legs="Plunderer's Culottes +1"}
    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

    sets.precast.Waltz = {
        ammo="Yamarang",
        body="Passion Jacket",
        legs="Dashing Subligar",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
        ammo="Sapience Orb",
        head=gear.Herc_MAB_head, --7
        body=gear.Taeon_FC_body, --8
        hands="Leyline Gloves", --8
        legs="Rawhide Trousers", --5
        feet=gear.Herc_MAB_feet, --2
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring2="Weather. Ring +1", --6(4)
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Passion Jacket",
        neck="Magoraga Beads",
        ring1="Lebeche Ring",
        })

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Focal Orb",
        head="Pill. Bonnet +3", 
        body=gear.Herc_WS_body,
        hands="Meg. Gloves +2",
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        back=gear.THF_WS1_Cape,
        waist="Fotia Belt",
        } -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Falcon Eye",
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        })

    sets.precast.WS.Critical = {ammo="Yetshila", body="Meg. Cuirie +2"}

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body,
        legs="Meg. Chausses +2",
        feet="Meg. Jam. +2",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        })

    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
        ammo="Falcon Eye",
        head="Dampening Tam",
        })

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        ammo="Yetshila",
        head=gear.Adhemar_B_head,
        body="Pillager's Vest +3",
        hands="Mummu Wrists +2",
        legs="Pill. Culottes +3",
        feet=gear.Herc_TA_feet,
        ear1="Sherida Earring",
        ear2="Brutal Earring",
        ring1="Begrudging Ring",
        ring2="Mummu Ring",
        back=gear.THF_WS2_Cape,
        })

    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
        ammo="Falcon Eye",
        head="Skulker's Bonnet +1",
        ear2="Telos Earring",
        ring1="Regal Ring",
        })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        ammo="Expeditious Pinion",
        neck="Caro Necklace",
        ear1="Sherida Earring",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Rudra\'s Storm'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'], {
        ammo="Falcon Eye",
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        })

    sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]
    sets.precast.WS['Mandalic Stab'].Acc = sets.precast.WS["Rudra's Storm"].Acc

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        head=gear.Herc_MAB_head,
        body="Samnuha Coat",
        hands="Leyline Gloves",
        legs=gear.Herc_MAB_legs,
        feet=gear.Herc_MAB_feet,
        neck="Baetyl Pendant",
        ear1="Novio Earring",
        ear2="Friomisi Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back="Argocham. Mantle",
        waist="Eschan Stone",
        })

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        }
        
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {}

    sets.idle = {
        ammo="Staunch Tathlum",
        head="Pill. Bonnet +3",
        body="Turms Harness",
        hands=gear.Herc_DT_hands,
        legs="Mummu Kecks +2",
        feet="Jute Boots +1",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back="Moonbeam Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum", --2/2
        body="Meg. Cuirie +2", --8/0
        hands=gear.Herc_DT_hands, --7/5
        legs="Mummu Kecks +2", --5/5
        neck="Loricate Torque +1", --6/6
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonbeam Cape", --5/5
        })

    sets.idle.Town = set_combine(sets.idle, {
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body,
        hands=gear.Adhemar_B_hands,
        legs="Lustr. Subligar +1",
        neck="Combatant's Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ilabrat Ring",
        back=gear.THF_TP_Cape,
        waist="Windbuffet Belt +1",
        })

    sets.idle.Weak = sets.idle.DT


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Jute Boots +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- * THF Native DW Trait: 25% DW
    -- * THF Job Points DW Gift: 5% DW
    
    -- No Magic Haste (74% DW to cap)
    sets.engaged = {
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, -- 6
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 41%

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        head="Dampening Tam",
        body="Pillager's Vest +3", 
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        neck="Anu Torque",
        ring1="Chirich Ring",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, -- 6
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Erudit. Necklace",
        ear1="Cessance Earring",
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 37%

    sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
        head="Dampening Tam",
        body="Pillager's Vest +3", 
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
        neck="Anu Torque",
        ring1="Chirich Ring",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body="Pillager's Vest +3", 
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 26%

    sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        })

    sets.engaged.MidHaste.MidAcc = set_combine(sets.engaged.LowAcc.MidHaste, {
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidHaste.MidAcc, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
        neck="Anu Torque",
        ear1="Sherida Earring",
        ring1="Chirich Ring",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.HighHaste = {
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body="Pillager's Vest +3", 
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.THF_DW_Cape, --10
        waist="Reiki Yotai", --7
        } -- 22%

    sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.MaxHaste = {
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body="Pillager's Vest +3", 
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Sherida Earring",
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.THF_TP_Cape,
        waist="Windbuffet Belt +1",
        } -- 5%

    sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        head="Skulker's Bonnet +1",
        neck="Combatant's Torque",
        waist="Kentarch Belt +1",
        })

    sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
        head="Dampening Tam",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        })

    sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
        legs="Pill. Culottes +3",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        waist="Kentarch Belt +1",
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        neck="Loricate Torque +1", --6/6
        ring1="Moonbeam Ring", --4/4
        ring2="Defending Ring", --10/10
        }
    
    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DT.LowHaste = set_combine(sets.engaged.LowHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.LowHaste = set_combine(sets.engaged.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.LowHaste = set_combine(sets.engaged.HighAcc.LowHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.LowHaste = set_combine(sets.engaged.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DT.MidHaste = set_combine(sets.engaged.MidHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.MidHaste = set_combine(sets.engaged.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.MidHaste = set_combine(sets.engaged.HighAcc.MidHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.MidHaste = set_combine(sets.engaged.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DT.HighHaste = set_combine(sets.engaged.HighHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.HighHaste = set_combine(sets.engaged.HighAcc.HighHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.HighHaste = set_combine(sets.engaged.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DT.MaxHaste = set_combine(sets.engaged.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT.MaxHaste = set_combine(sets.engaged.HighAcc.MaxHaste, sets.engaged.Hybrid)    
    sets.engaged.STP.DT.MaxHaste = set_combine(sets.engaged.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
    
    sets.buff.Doom = {ring1="Eshmun's Ring", ring2="Eshmun's Ring", waist="Gishdubar Sash"}

    sets.Reive = {neck="Ygnas's Resolve +1"}
    sets.CP = {back="Mecisto. Mantle"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
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

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
    end
    if spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end

end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust gear.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
        determine_haste_group()
        if not gain then
            haste = nil
            --add_to_chat(122, "Haste Status: Cleared")
        end
        if not midaction() then
            handle_equipping_gear(player.status)
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

function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
        determine_haste_group()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    determine_haste_group()
    th_update(cmdParams, eventArgs)
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
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


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
    msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ' ][ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end
    
    if state.Kiting.value then
        msg = msg .. ' ][ Kiting Mode: ON'
    end
    
    msg = msg .. ' ][ TH: ' .. state.TreasureMode.value
    
    msg = msg .. ' ]'

    add_to_chat(060, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

--Read incoming packet to differentiate between Haste I and II
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
                if param == 57 then
                    --add_to_chat(122, 'Haste Status: Haste I (Haste)')
                    haste = 1
                elseif param == 511 then
                    --add_to_chat(122, 'Haste Status: Haste II (Haste II)')
                    haste = 2
                end
            elseif act.category == 5 then
                if act.param == 5389 then
                    --add_to_chat(122, 'Haste Status: Haste II (Spy Drink)')
                    haste = 2
                end
            elseif act.category == 13 then
                local param = act.param
                if param == 595 then 
                    --add_to_chat(122, 'Haste Status: Haste I (Hastega)')
                    haste = 1
                elseif param == 602 then
                    --add_to_chat(122, 'Haste Status: Haste II (Hastega2)')
                    haste = 2
                end
            end
        end
    end)

function determine_haste_group()

    -- Assuming the following values:

    -- Haste - 15%
    -- Haste II - 30%
    -- Haste Samba - 5%
    -- Honor March - 15%
    -- Victory March - 25%
    -- Advancing March - 15%
    -- Embrava - 25%
    -- Mighty Guard (buffactive[604]) - 15%
    -- Geo-Haste (buffactive[580]) - 30%

    classes.CustomMeleeGroups:clear()

    if (haste == 2 and (buffactive[580] or buffactive.march or buffactive.embrava or buffactive[604])) or
        (haste == 1 and (buffactive[580] or buffactive.march == 2 or (buffactive.embrava and buffactive['haste samba']) or (buffactive.march and buffactive[604]))) or
        (buffactive[580] and (buffactive.march or buffactive.embrava or buffactive[604])) or
        (buffactive.march == 2 and (buffactive.embrava or buffactive[604])) or
        (buffactive.march and (buffactive.embrava and buffactive['haste samba'])) then
        --add_to_chat(122, 'Magic Haste Level: 43%')
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif ((haste == 2 or buffactive[580] or buffactive.march == 2) and buffactive['haste samba']) or
        (haste == 1 and buffactive['haste samba'] and (buffactive.march or buffactive[604])) or
        (buffactive.march and buffactive['haste samba'] and buffactive[604]) then
        --add_to_chat(122, 'Magic Haste Level: 35%')
        classes.CustomMeleeGroups:append('HighHaste')
    elseif (haste == 2 or buffactive[580] or buffactive.march == 2 or (buffactive.embrava and buffactive['haste samba']) or
        (haste == 1 and (buffactive.march or buffactive[604])) or (buffactive.march and buffactive[604])) then
        (buffactive.march == 1 and buffactive[604]) or (buffactive.march == 1 and haste == 1)) then
        --add_to_chat(122, 'Magic Haste Level: 30%')
        classes.CustomMeleeGroups:append('MidHaste')
    elseif (haste == 1 or buffactive.march or buffactive[604] or buffactive.embrava) then
        --add_to_chat(122, 'Magic Haste Level: 15%')
        classes.CustomMeleeGroups:append('LowHaste')
    end
end


-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'WAR' then
        set_macro_page(2, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 1)
    else
        set_macro_page(1, 1)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end