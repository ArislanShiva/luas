-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ CTRL+` ]          Toggle Treasure Hunter Mode
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Yonin
--              [ CTRL+= ]          Innin
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--              [ WIN+/ ]           Utsusemi: San
--              [ ALT+, ]           Monomi: Ichi
--              [ ALT+. ]           Tonko: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Blade: Kamu
--              [ CTRL+Numpad8 ]    Blade: Shun
--              [ CTRL+Numpad4 ]    Blade: Ten
--              [ CTRL+Numpad6 ]    Blade: Hi
--              [ CTRL+Numpad1 ]    Blade: Yu
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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lugra_ws = S{'Blade: Kamu', 'Blade: Shun', 'Blade: Ten'}

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")

    state.Night = M(false, "Dusk to Dawn")
    options.ninja_tool_warning_limit = 10

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('lua l gearinfo')

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^- input /ja "Yonin" <me>')
    send_command('bind ^= input /ja "Innin" <me>')
    send_command('bind ^, input /nin "Monomi: Ichi" <me>')
    send_command('bind ^. input /ma "Tonko: Ni" <me>')
    send_command('bind @/ input /ma "Utsusemi: San" <me>')

    send_command('bind @c gs c toggle CP')

    send_command('bind ^numlock input /ja "Innin" <me>')
    send_command('bind !numlock input /ja "Yonin" <me>')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind !numpad/ input /ja "Defender" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    end

    send_command('bind ^numpad7 input /ws "Blade: Kamu" <t>')
    send_command('bind ^numpad8 input /ws "Blade: Shun" <t>')
    send_command('bind ^numpad4 input /ws "Blade: Ten" <t>')
    send_command('bind ^numpad6 input /ws "Blade: Hi" <t>')
    send_command('bind ^numpad1 input /ws "Blade: Yu" <t>')
    send_command('bind ^numpad2 input /ws "Blade: Chi" <t>')

    -- Whether a warning has been given for low ninja tools
    state.warned = M(false)

    select_movement_feet()
    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind @/')
    send_command('unbind @c')
    send_command('unbind @t')
    send_command('unbind ^numlock')
    send_command('unbind !numlock')
    send_command('unbind ^numpad/')
    send_command('unbind !numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad+')
    send_command('unbind !numpad+')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')

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

    send_command('lua u gearinfo')

end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Enmity set
    sets.Enmity = {
        ammo="Sapience Orb", --2
        body="Emet Harness +1", --10
        hands="Kurys Gloves", --9
        feet="Ahosi Leggings", --7
        neck="Unmoving Collar +1", --10
        ear1="Cryptic Earring", --4
        ear2="Trux Earring", --5
        ring1="Supershear Ring", --5
        ring2="Eihwaz Ring", --5
        waist="Kasiri Belt", --3
        }

    sets.precast.JA['Provoke'] = sets.Enmity
--  sets.precast.JA['Mijin Gakure'] = {legs="Mochi. Hakama +1"}
    sets.precast.JA['Futae'] = {hands="Hattori Tekko +1"}
    sets.precast.JA['Sange'] = {body="Mochi. Chainmail +1"}

    sets.precast.Waltz = {
        ammo="Yamarang",
        body="Passion Jacket",
        legs="Dashing Subligar",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        waist="Gishdubar Sash",
        }

    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells

    sets.precast.FC = {
        ammo="Sapience Orb", --2
        head=gear.Herc_MAB_head, --7
        body=gear.Taeon_FC_body, --8
        hands="Leyline Gloves", --8
        legs="Rawhide Trousers", --5
        feet=gear.Herc_MAB_feet, --2
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        ring2="Weather. Ring +1", --6(4)
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        body="Mochi. Chainmail +1",
        neck="Magoraga Beads",
        })

    sets.precast.RA = {
        head=gear.Taeon_RA_head, --10/0
        body=gear.Taeon_RA_body, --10/0
        legs=gear.Adhemar_C_legs, --10/0
        }

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        range="Seeth. Bomblet +1",
        head="Hachiya Hatsu. +3",
        body=gear.Herc_WS_body,
        hands=gear.Adhemar_B_hands,
        legs="Hiza. Hizayoroi +2",
        feet=gear.Herc_TA_feet,
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Ishvara Earring",
        ring1="Regal Ring",
        ring2="Epaminondas's Ring",
        back=gear.NIN_WS1_Cape,
        waist="Fotia Belt",
        } -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring2="Ramuh Ring +1",
        })

    sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
        ammo="Yetshila +1",
        head=gear.Adhemar_B_head,
        hands="Mummu Wrists +2",
        feet="Mummu Gamash. +2",
        ring2="Mummu Ring",
        back=gear.NIN_WS1_Cape,
        })

    sets.precast.WS['Blade: Ten'] = set_combine(sets.precast.WS, {
        neck="Caro Necklace",
        waist="Grunfeld Rope",
        back=gear.NIN_WS1_Cape,
        })

    sets.precast.WS['Blade: Ten'].Acc = set_combine(sets.precast.WS['Blade: Ten'], {
        ear2="Telos Earring",
        })

    sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {
        ammo="Jukukik Feather",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body,
        legs="Jokushu Haidate",
        ear2="Mache Earring +1",
        ring2="Ilabrat Ring",
        back=gear.NIN_TP_Cape,
        })

    sets.precast.WS['Blade: Kamu'] = set_combine(sets.precast.WS, {
        ring2="Ilabrat Ring",
        })

    sets.precast.WS['Blade: Yu'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Hachiya Hatsu. +3",
        body="Samnuha Coat",
        hands="Leyline Gloves",
        legs=gear.Herc_MAB_legs,
        feet=gear.Herc_MAB_feet,
        neck="Baetyl Pendant",
        ear1="Moonshade Earring",
        ear2="Friomisi Earring",
        ring1="Dingir Ring",
        back=gear.NIN_MAB_Cape,
        waist="Eschan Stone",
        })

    sets.LugraLeft = {ear1="Lugra Earring"}
    sets.LugraRight = {ear2="Lugra Earring +1"}
    sets.WSDayBonus = {head="Gavialis Helm"}

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        }

    -- Specific spells
    sets.midcast.Utsusemi = set_combine(sets.midcast.SpellInterrupt, {feet="Hattori Kyahan +1", back=gear.NIN_TP_Cape,})

    sets.midcast.ElementalNinjutsu = {
        ammo="Pemphredo Tathlum",
        head=gear.Herc_MAB_head,
        body="Samnuha Coat",
        hands="Leyline Gloves",
        legs=gear.Herc_MAB_legs,
        feet=gear.Herc_MAB_feet,
        neck="Baetyl Pendant",
        ear1="Crematio Earring",
        ear2="Friomisi Earring",
        ring1={name="Shiva Ring +1", bag="wardrobe3"},
        ring2={name="Shiva Ring +1", bag="wardrobe4"},
        back=gear.NIN_MAB_Cape,
        waist="Eschan Stone",
        }

    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {
        neck="Sanctity Necklace",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        ear1="Hermetic Earring",
        })

    sets.midcast.EnfeeblingNinjutsu = {
        ammo="Pemphredo Tathlum",
        head="Hachiya Hatsu. +3",
        body="Mummu Jacket +2",
        hands="Mummu Wrists +2",
        legs="Mummu Kecks +2",
        feet="Hachiya Kyahan +3",
        neck="Sanctity Necklace",
        ear1="Hermetic Earring",
        ear2="Digni. Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back=gear.NIN_MAB_Cape,
        waist="Eschan Stone",
        }

    sets.midcast.EnhancingNinjutsu = {
        head="Hachiya Hatsu. +3",
        feet="Mochi. Kyahan +1",
        neck="Incanter's Torque",
        ear1="Stealth Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Astute Cape",
        waist="Cimmerian Sash",
        }

    sets.midcast.RA = {
        head="Mummu Bonnet +2",
        body="Mummu Jacket +2",
        hands=gear.Adhemar_C_hands,
        legs=gear.Adhemar_C_legs,
        feet="Mummu Gamash. +2",
        neck="Iskur Gorget",
        ear1="Enervating Earring",
        ear2="Telos Earring",
        ring1="Dingir Ring",
        ring2="Hajduk Ring +1",
        back=gear.NIN_TP_Cape,
        waist="Yemaya Belt",
        }

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------

    -- Resting sets
--    sets.resting = {}

    -- Idle sets
    sets.idle = {
        ammo="Seki Shuriken",
        head="Volte Cap",
        body="Ashera Harness",
        hands=gear.Herc_DT_hands,
        legs="Samnuha Tights",
        feet="Ahosi Leggings",
        neck="Bathy Choker +1",
        ear1="Sanare Earring",
        ear2="Infused Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        back="Moonlight Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        body="Ashera Harness", --7/7
        hands=gear.Herc_DT_hands, --7/5
        legs="Mummu Kecks +2", --5/5
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        waist="Flume Belt +1", --4/0
        })

    sets.idle.Town = set_combine(sets.idle, {
        head=gear.Adhemar_B_head,
        body="Ashera Harness",
        hands=gear.Adhemar_B_hands,
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        back=gear.NIN_TP_Cape,
        waist="Windbuffet Belt +1",
        })

    sets.idle.Weak = sets.idle.DT

    -- Defense sets
    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Danzo sune-ate"}

    sets.DayMovement = {feet="Danzo sune-ate"}
    sets.NightMovement = {feet="Hachiya Kyahan +3"}


    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- * NIN Native DW Trait: 35% DW

    -- No Magic Haste (74% DW to cap)
    sets.engaged = {
        ammo="Seki Shuriken",
        head=gear.Adhemar_B_head,
        body="Mochi. Chainmail +1", --7
        hands="Floral Gauntlets", --5
        legs="Samnuha Tights",
        feet="Hiza. Sune-Ate +2", --8
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.NIN_TP_Cape,
        waist="Reiki Yotai", --7
        } -- 35%

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ring2="Ilabrat Ring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
        ammo="Seki Shuriken",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands="Floral Gauntlets", --5
        legs="Samnuha Tights",
        feet="Hiza. Sune-Ate +2", --8
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.NIN_TP_Cape,
        waist="Reiki Yotai", --7
      } -- 35%

    sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
        feet=gear.Herc_TA_feet,
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
        ammo="Seki Shuriken",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands=gear.Adhemar_A_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.NIN_TP_Cape,
        waist="Reiki Yotai", --7
        } -- 22%

    sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
        feet=gear.Herc_TA_feet,
        ear1="Cessance Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Ilabrat Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidHaste.MidAcc, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.HighHaste = {
        ammo="Seki Shuriken",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body, --6
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.NIN_TP_Cape,
        waist="Windbuffet Belt +1",
        } -- 15% Gear

    sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        waist="Kentarch Belt +1",
        })

    sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
        ear1="Cessance Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Ilabrat Ring",
        })

    sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        waist="Kentarch Belt +1",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.MaxHaste = {
        ammo="Seki Shuriken",
        head=gear.Adhemar_B_head,
        body=gear.Herc_TA_body,
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Cessance Earring",
        ear2="Brutal Earring",
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back=gear.NIN_TP_Cape,
        waist="Windbuffet Belt +1",
        } -- 0%

    sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        head="Dampening Tam",
        neck="Combatant's Torque",
        waist="Kentarch Belt +1",
        })

    sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
        ear1="Cessance Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Ilabrat Ring",
        })

    sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        ring1="Regal Ring",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        body="Ashera Harness",
        neck="Iskur Gorget",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.Hybrid = {
        head=gear.Adhemar_D_head, --4/0
        body="Ashera Harness", --7/7
        neck="Loricate Torque +1", --6/6
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

    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.magic_burst = {
        feet="Hachiya Kyahan +3",
        ring1="Locus Ring",
        ring2="Mujin Band", --(5)
        }

--    sets.buff.Migawari = {body="Iga Ningi +2"}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }
        
--    sets.buff.Yonin = {}
--    sets.buff.Innin = {}

    sets.CP = {back="Mecisto. Mantle"}
    sets.TreasureHunter = {head="Volte Cap", hands=gear.Herc_TH_hands, waist="Chaac Belt"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    if spell.skill == "Ninjutsu" then
        do_ninja_tool_checks(spell, spellMap, eventArgs)
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
    if spell.type == 'WeaponSkill' then
        if lugra_ws:contains(spell.english) and state.Night.value == true then
                equip(sets.LugraRight)
            if spell.english == 'Blade: Kamu' then
                equip(sets.LugraLeft)
            end
        end
        if spell.english == 'Blade: Yu' and (world.weather_element == 'Water' or world.day_element == 'Water') then
            equip(sets.Obi)
        end
    end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if default_spell_map == 'ElementalNinjutsu' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
        if state.Buff.Futae then
            equip(sets.precast.JA['Futae'])
            add_to_chat(120, 'Futae GO!')
        end
    end
    if spell.type == 'WeaponSkill' then
        if state.Buff.Futae then
            add_to_chat(120, 'Futae GO!')
        end
    end
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
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
    if new_status == 'Idle' then
        select_movement_feet()
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
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
       idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end

    idleSet = set_combine(idleSet, select_movement_feet())

    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 1 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 1 and DW_needed <= 16 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 16 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 21 and DW_needed <= 34 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 34 then
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

function select_movement_feet()
    if world.time >= (17*60) or world.time <= (7*60) then
        state.Night:set()
        return sets.NightMovement
    else
        state.Night:reset()
        return sets.DayMovement
    end
end

-- Determine whether we have sufficient tools for the spell being attempted.
function do_ninja_tool_checks(spell, spellMap, eventArgs)
    local ninja_tool_name
    local ninja_tool_min_count = 1

    -- Only checks for universal tools and shihei
    if spell.skill == "Ninjutsu" then
        if spellMap == 'Utsusemi' then
            ninja_tool_name = "Shihei"
        elseif spellMap == 'ElementalNinjutsu' then
            ninja_tool_name = "Inoshishinofuda"
        elseif spellMap == 'EnfeeblingNinjutsu' then
            ninja_tool_name = "Chonofuda"
        elseif spellMap == 'EnhancingNinjutsu' then
            ninja_tool_name = "Shikanofuda"
        else
            return
        end
    end

    local available_ninja_tools = player.inventory[ninja_tool_name] or player.wardrobe[ninja_tool_name]

    -- If no tools are available, end.
    if not available_ninja_tools then
        if spell.skill == "Ninjutsu" then
            return
        end
    end

    -- Low ninja tools warning.
    if spell.skill == "Ninjutsu" and state.warned.value == false
        and available_ninja_tools.count > 1 and available_ninja_tools.count <= options.ninja_tool_warning_limit then
        local msg = '*****  LOW TOOLS WARNING: '..ninja_tool_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end

        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_ninja_tools.count > options.ninja_tool_warning_limit and state.warned then
        state.warned:reset()
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

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(2, 11)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 11)
    else
        set_macro_page(1, 11)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
