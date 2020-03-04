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
--              [ WIN+H ]           Toggle Charm Defense Mods
--              [ WIN+D ]           Toggle Death Defense Mods
--              [ WIN+K ]           Toggle Knockback Defense Mods
--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Use current Rune
--              [ CTRL+- ]          Rune element cycle forward.
--              [ CTRL+= ]          Rune element cycle backward.
--              [ CTRL+` ]          Use current Rune
--
--              [ CTRL+Numpad/ ]    Berserk/Meditate/Souleater
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki/Arcane Circle
--              [ CTRL+Numpad- ]    Aggressor/Third Eye/Weapon Bash
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+G ]          Cycles between available greatswords
--              [ CTRL+W ]          Toggle Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Resolution
--              [ CTRL+Numpad8 ]    Upheaval
--              [ CTRL+Numpad9 ]    Dimidiation
--              [ CTRL+Numpad5 ]    Ground Strike
--              [ CTRL+Numpad6 ]    Full Break
--              [ CTRL+Numpad1 ]    Herculean Slash
--              [ CTRL+Numpad2 ]    Shockwave
--              [ CTRL+Numpad3 ]    Armor Break
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------


--  gs c rune                       Uses current rune
--  gs c cycle Runes                Cycles forward through rune elements
--  gs c cycleback Runes            Cycles backward through rune elements


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end

-- Setup vars that are user-independent.
function job_setup()

    -- /BLU Spell Maps
    blue_magic_maps = {}

    blue_magic_maps.Enmity = S{'Blank Gaze', 'Geist Wall', 'Jettatura', 'Soporific',
        'Poison Breath', 'Blitzstrahl', 'Sheep Song', 'Chaotic Eye'}
    blue_magic_maps.Cure = S{'Wild Carrot'}
    blue_magic_maps.Buffs = S{'Cocoon', 'Refueling'}

    rayke_duration = 35
    gambit_duration = 96

    lockstyleset = 4

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT', 'HP')
    state.MagicalDefenseMode:options('MDT')

    state.Knockback = M(false, 'Knockback')

    state.WeaponSet = M{['description']='Weapon Set', 'Epeolatry', 'Lionheart', 'Aettir', 'GreatAxe'}
    state.AttackMode = M{['description']='Attack', 'Uncapped', 'Capped'}
    state.CP = M(false, "Capacity Points Mode")
    state.WeaponLock = M(false, 'Weapon Lock')

    state.Runes = M{['description']='Runes', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae'}

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('bind ^` input //gs c rune')
    send_command('bind !` input /ja "Vivacious Pulse" <me>')
    send_command('bind ^insert gs c cycleback Runes')
    send_command('bind ^delete gs c cycle Runes')
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')
    send_command('bind @a gs c cycle AttackMode')
    send_command('bind @c gs c toggle CP')
    send_command('bind @e gs c cycleback WeaponSet')
    send_command('bind @r gs c cycle WeaponSet')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @k gs c toggle Knockback')
    send_command('bind !q input /ma "Temper" <me>')

    if player.sub_job == 'BLU' then
        send_command('bind !w input /ma "Cocoon" <me>')
    elseif player.sub_job == 'WAR' then
        send_command('bind !w input /ja "Defender" <me>')
    elseif player.sub_job == 'DRK' then
        send_command('bind !w input /ja "Last Resort" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind !w input /ja "Hasso" <me>')
    end

    send_command('bind !o input /ma "Regen IV" <stpc>')
    send_command('bind !p input /ma "Ice Spikes" <me>')

    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'DRK' then
        send_command('bind ^numpad/ input /ja "Souleater" <me>')
        send_command('bind ^numpad* input /ja "Arcane Circle" <me>')
        send_command('bind ^numpad- input /ja "Weapon Bash" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end

    send_command('bind ^numpad7 input /ws "Resolution" <t>')
    send_command('bind ^numpad8 input /ws "Upheaval" <t>')
    send_command('bind ^numpad9 input /ws "Dimidiation" <t>')
    send_command('bind ^numpad5 input /ws "Ground Strike" <t>;input /p Ground Strike')
    send_command('bind ^numpad6 input /ws "Full Break" <t>')
    send_command('bind ^numpad1 input /ws "Herculean Slash" <t>')
    send_command('bind ^numpad2 input /ws "Shockwave" <t>')
    send_command('bind ^numpad3 input /ws "Armor Break" <t>')

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^f11')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind @a')
    send_command('unbind @c')
    send_command('unbind @d')
    send_command('unbind !q')
    send_command('unbind @w')
    send_command('unbind @e')
    send_command('unbind @r')
    send_command('unbind !o')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind @w')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind @numpad*')

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
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Enmity sets
    sets.Enmity = {
        ammo="Aqreqaq Bomblet", --2
        head="Halitus Helm", --8
        body="Emet Harness +1", --10
        hands="Kurys Gloves", --9
        legs="Eri. Leg Guards +1", --7
        feet="Ahosi Leggings",--7
        neck="Moonbeam Necklace", --10
        ear1="Cryptic Earring", --4
        ear2="Trux Earring", --5
        ring1="Supershear Ring", --5
        ring2="Eihwaz Ring", --5
        back=gear.RUN_HPD_Cape, --10
        waist="Kasiri Belt", --3
        }

    sets.Enmity.HP = {
        ammo="Aqreqaq Bomblet", --2
        head="Halitus Helm", --8
        body="Emet Harness +1", --10
        hands="Kurys Gloves", --9
        legs="Eri. Leg Guards +1", --11
        feet="Ahosi Leggings",--7
        neck="Futhark Torque +1", --7
        ear1={name="Tuisto Earring", priority=3},
        ear2={name="Odnowa Earring +1", priority=2},
        ring1={name="Moonlight Ring", priority=1},
        ring2="Eihwaz Ring", --5
        back=gear.RUN_HPD_Cape, --10
        waist="Kasiri Belt", --3
        }

    sets.precast.JA['Vallation'] = {body="Runeist's Coat +3", legs="Futhark Trousers +3", back=gear.RUN_HPD_Cape,}
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
    sets.precast.JA['Pflug'] = {feet="Runeist's Boots +3"}
    sets.precast.JA['Battuta'] = {head="Fu. Bandeau +3"}
    sets.precast.JA['Liement'] = {body="Futhark Coat +3"}

    sets.precast.JA['Lunge'] = {
        ammo="Seeth. Bomblet +1",
        head=gear.Herc_MAB_head,
        body="Samnuha Coat",
        hands="Carmine Fin. Ga. +1",
        legs=gear.Herc_MAB_legs,
        feet=gear.Herc_MAB_feet,
        neck="Baetyl Pendant",
        ear1="Crematio Earring",
        ear2="Friomisi Earring",
        ring1={name="Fenrir Ring +1", bag="wardrobe3"},
        ring2={name="Fenrir Ring +1", bag="wardrobe4"},
        back="Argocham. Mantle",
        waist="Eschan Stone",
        }

    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
    sets.precast.JA['Gambit'] = {hands="Runeist's Mitons +3"}
    sets.precast.JA['Rayke'] = {feet="Futhark Boots +1"}
    sets.precast.JA['Elemental Sforzo'] = {body="Futhark Coat +3"}
    sets.precast.JA['Swordplay'] = {hands="Futhark Mitons +3"}
    sets.precast.JA['Vivacious Pulse'] = {head="Erilaz Galea +1"}


    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb", --2
        head="Rune. Bandeau +3", --14
        body=gear.Taeon_FC_body, --8
        hands="Leyline Gloves", --8
        legs="Aya. Cosciales +2", --6
        feet="Carmine Greaves +1", --8
        neck="Orunmila's Torque", --5
        ear1="Tuisto Earring",
        ear2="Odnowa Earring +1",
        ring1="Moonlight Ring",
        ring2="Weather. Ring +1", --6(4)
        back=gear.RUN_FC_Cape, --10
        waist="Oneiros Belt",
        }

    sets.precast.FC.HP = set_combine(sets.precast.FC, {
        ammo="Aqreqaq Bomblet",
        head={name="Rune. Bandeau +3", priority=5},
        body={name="Runeist's Coat +3", priority=1},
        ear1={name="Tuisto Earring", priority=4},
        ear2={name="Odnowa Earring +1", priority=3},
        ring1={name="Moonlight Ring", priority=2},
        waist="Oneiros Belt",
        })

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        legs="Futhark Trousers +3",
        })

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear2="Mendi. Earring"})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Impatiens",
        body="Passion Jacket",
        ring1="Lebeche Ring",
        waist="Rumination Sash",
        })


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Knobkierrie",
        head="Lilitu Headpiece",
        body=gear.Herc_WS_body,
        hands="Meg. Gloves +2",
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_TA_feet,
        neck="Fotia Gorget",
        ear1="Sherida Earring",
        ear2="Moonshade Earring",
        ring1="Regal Ring",
        ring2="Niqmaddu Ring",
        back=gear.RUN_WS1_Cape,
        waist="Fotia Belt",
        }

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        body=gear.Adhemar_B_body,
        legs="Meg. Chausses +2",
        ear2="Telos Earring",
        })

    sets.precast.WS.Uncapped = set_combine(sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        })  

    sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, {
        head="Lustratio Cap +1",
        body="Lustr. Harness +1",
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet="Lustra. Leggings +1",
        ring1="Epona's Ring",
        back=gear.RUN_WS1_Cape,
        })

    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {
        head=gear.Adhemar_B_head,
        hands=gear.Adhemar_A_hands,
        legs="Meg. Chausses +2",
        feet=gear.Herc_STP_feet,
        ear2="Telos Earring",
        })

    sets.precast.WS['Resolution'].Uncapped = set_combine(sets.precast.WS['Resolution'], {
        ammo="Seeth. Bomblet +1",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body,
        legs="Meg. Chausses +2",
        feet=gear.Herc_TA_feet,
        ring1="Regal Ring",
        })

    sets.precast.WS['Dimidiation'] = set_combine(sets.precast.WS, {
        body=gear.Adhemar_B_body,
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        ear1="Odr Earring",
        ring2="Epaminondas's Ring",
        back=gear.RUN_WS2_Cape,
        })

    sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'], {
        ammo="Seeth. Bomblet +1",
        body=gear.Adhemar_B_body,
        legs="Samnuha Tights",
        feet=gear.Herc_STP_feet,
        ear2="Mache Earring +1",
        })

    sets.precast.WS['Dimidiation'].Uncapped = set_combine(sets.precast.WS['Dimidiation'], {
        neck="Caro Necklace",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Herculean Slash'] = sets.precast.JA['Lunge']

    sets.precast.WS['Shockwave'] = {
        ammo="Pemphredo Tathlum",
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Leyline Gloves",
        legs="Aya. Cosciales +2",
        feet="Aya. Gambieras +2",
        neck="Erra Pendant",
        ear1="Digni. Earring",
        ear2="Moonshade Earring",
        ring1="Ayanmo Ring",
        ring2="Weather. Ring +1",
        back=gear.RUN_WS1_Cape,
        waist="Eschan Stone",
        }

    sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {
        feet="Lustra. Leggings +1",
        ear2="Ishvara Earring",
        back=gear.RUN_WS1_Cape,
        })

    sets.precast.WS['Upheaval'] = sets.precast.WS['Resolution']
    sets.precast.WS['Full Break'] = sets.precast.WS['Shockwave']

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Staunch Tathlum +1", --11
        body=gear.Taeon_Phalanx_body, --10
        hands="Regal Gauntlets", --10
        legs="Carmine Cuisses +1", --20
        feet=gear.Taeon_Phalanx_feet, --10
        neck="Moonbeam Necklace", --10
        ear1="Halasz Earring", --5
        ring2="Evanescence Ring", --5
        back=gear.RUN_FC_Cape, --10
        waist="Rumination Sash", --10
        } -- +10% from merit points

    sets.midcast.Cure = {
        sub="Mensch Strap +1",
        ammo="Staunch Tathlum +1",
        head="Fu. Bandeau +3",
        body="Vrikodara Jupon", -- 13
        hands="Buremte Gloves", --(13)
        legs="Aya. Cosciales +2",
        feet="Skaoi Boots", --7
        neck="Phalaina Locket", -- 4(4)
        ear1="Roundel Earring", -- 5
        ear2="Mendi. Earring", -- 5
        ring1="Lebeche Ring", -- 3
        ring2="Defending Ring",
        back="Solemnity Cape", -- 7
        waist="Gishdubar Sash", --(10)
        }

    sets.midcast['Enhancing Magic'] = {
        main="Pukulatmuj +1",
        sub="Pukulatmuj",
        head="Carmine Mask +1",
        body="Manasa Chasuble",
        hands="Runeist's Mitons +3",
        legs="Carmine Cuisses +1",
        neck="Incanter's Torque",
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Merciful Cape",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        head="Erilaz Galea +1",
        hands="Regal Gauntlets",
        legs="Futhark Trousers +3",
        }

    sets.midcast['Phalanx'] = set_combine(sets.midcast.SpellInterrupt, {
        main="Deacon Sword", --4
        sub="Pukulatmuj +1",
        ammo="Staunch Tathlum +1", --(11)
        head="Fu. Bandeau +3", --7
        body=gear.Taeon_Phalanx_body, --3(10)
        hands=gear.Taeon_Phalanx_hands, --3(10)
        legs=gear.Taeon_Phalanx_legs, --3(10)
        feet=gear.Taeon_Phalanx_feet, --3(10)
        ear1="Tuisto Earring",
        ear2="Odnowa Earring +1",
        ring1="Moonlight Ring",
        back=gear.RUN_FC_Cape, --(10)
        })

    sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], sets.midcast.SpellInterrupt, {
        main="Nibiru Faussar", --1
        sub="Refined Grip +1",
        })

    sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {head="Rune. Bandeau +3", neck="Sacro Gorget"})
    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {head="Erilaz Galea +1", waist="Gishdubar Sash"})
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
    sets.midcast.Shell = sets.midcast.Protect

    sets.midcast['Divine Magic'] = {
        ammo="Yamarang",
        legs="Rune. Trousers +3",
        neck="Incanter's Torque",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        waist="Bishop's Sash",
        }

    sets.midcast.Flash = sets.Enmity
    sets.midcast.Foil = sets.Enmity
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast['Blue Magic'] = {}
    sets.midcast['Blue Magic'].Enmity = sets.Enmity
    sets.midcast['Blue Magic'].Cure = sets.midcast.Cure
    sets.midcast['Blue Magic'].Buff = sets.midcast['Enhancing Magic']


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        sub="Mensch Strap +1",
        ammo="Homiliary",
        head="Turms Cap +1",
        body="Runeist's Coat +3",
        hands="Regal Gauntlets",
        legs="Turms Subligar +1",
        feet="Turms Leggings +1",
        neck="Bathy Choker +1",
        ear1="Sanare Earring",
        ear2="Odnowa Earring +1",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back=gear.RUN_HPD_Cape,
        waist="Ioskeha Belt +1",
        }

    sets.idle.DT = {
        sub="Mensch Strap +1", --5/0
        ammo="Staunch Tathlum +1", --3/3
        head="Fu. Bandeau +3", --6/0
        body="Runeist's Coat +3",
        hands="Turms Mittens +1",
        legs="Turms Subligar +1",
        feet="Turms Leggings +1",
        neck="Futhark Torque +1", --6/6
        ear1="Sanare Earring",
        ear2="Odnowa Earring +1", --0/2
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
        back=gear.RUN_HPD_Cape, --10/0
        waist="Flume Belt +1", --4/0
        }

    sets.idle.Town = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1",
        body="Ashera Harness",
        neck="Futhark Torque +1",
        ear1="Sanare Earring",
        })

    sets.idle.Weak = sets.idle.DT
    sets.Kiting = {legs="Carmine Cuisses +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.Knockback = {back="Repulse Mantle"}

    sets.defense.PDT = {
        sub="Refined Grip +1", --3/3
        ammo="Staunch Tathlum +1", --3/3
        head="Turms Cap +1",
        body="Ashera Harness", --7/7
        hands="Turms Mittens +1",
        legs="Eri. Leg Guards +1", --7/0
        feet="Turms Leggings +1",
        neck="Futhark Torque +1", --6/6
        ear1="Sanare Earring",
        ear2="Odnowa Earring +1", --0/2
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
        back=gear.RUN_HPD_Cape, --10/0
        waist="Engraved Belt",
        }

    sets.defense.MDT = {
        sub="Mensch Strap +1", --5/0
        ammo="Staunch Tathlum +1", --3/3
        head="Turms Cap +1",
        body="Runeist's Coat +3",
        hands="Turms Mittens +1",
        legs="Eri. Leg Guards +1", --7/0
        feet="Turms Leggings +1",
        neck="Futhark Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ear2="Odnowa Earring +1", --0/2
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back=gear.RUN_HPD_Cape, --10/0
        waist="Engraved Belt",
        }

    sets.defense.HP = {
        sub="Mensch Strap +1", --5/0
        ammo="Staunch Tathlum +1", --3/3
        head=gear.Adhemar_D_head, --4/0
        body={name="Runeist's Coat +3", priority=2},
        hands={name="Regal Gauntlets", priority=3},
        legs="Eri. Leg Guards +1", --7/0
        feet="Turms Leggings +1",
        neck="Futhark Torque +1", --6/6
        ear1={name="Tuisto Earring", priority=6}, --0/1
        ear2={name="Odnowa Earring +1", priority=5}, --0/2
        ring1={name="Moonlight Ring", priority=4}, --5/5
        ring2="Defending Ring", --10/10
        back={name="Moonlight Cape", priority=1}, --6/6
        waist="Flume Belt +1", --4/0
        }

    sets.defense.Parry = {
        hands="Turms Mittens +1",
        legs="Eri. Leg Guards +1",
        feet="Turms Leggings +1",
        back=gear.RUN_HPP_Cape,
        }

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
        sub="Utu Grip",
        ammo="Yamarang",
        head=gear.Adhemar_B_head,
        body=gear.Adhemar_B_body,
        hands=gear.Adhemar_B_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Brutal Earring",
        ring1="Epona's Ring",
        ring2="Niqmaddu Ring",
        back=gear.RUN_TP_Cape,
        waist="Ioskeha Belt +1",
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        head="Dampening Tam",
        hands=gear.Adhemar_A_hands,
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Regal Ring",
        feet=gear.Herc_STP_feet,
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        ammo="C. Palug Stone",
        head="Carmine Mask +1",
        body="Runeist's Coat +3",
        hands="Runeist's Mitons +3",
        legs="Carmine Cuisses +1",
        ear1="Odr Earring",
        ear2="Mache Earring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        head="Aya. Zucchetto +2",
        body="Ashera Harness",
        feet="Carmine Greaves +1",
        ear2="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        waist="Kentarch Belt +1",
        })

    sets.engaged.Aftermath = {
        head="Aya. Zucchetto +2",
        body="Ashera Harness",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Dedition Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2={name="Chirich Ring +1", bag="wardrobe4"},
        waist="Kentarch Belt +1",
        }


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.Hybrid = {
        head=gear.Adhemar_D_head, --4/0
        body="Ashera Harness", --7/7
        neck="Futhark Torque +1", --6/6
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
        back=gear.RUN_TP_Cape, --10/0
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.Hybrid)

--[[
    sets.engaged.Aftermath.DT = {
        head="Aya. Zucchetto +2",
        feet="Carmine Greaves +1",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Moonlight Ring",
        ring2="Defending Ring",
        waist="Kentarch Belt +1",
        }
]]

    sets.engaged.Aftermath.DT = {
        head="Aya. Zucchetto +2",
        body="Ashera Harness",
        hands=gear.Adhemar_A_hands,
        legs="Meg. Chausses +2",
        feet=gear.Herc_STP_feet,
        neck="Futhark Torque +1",
        ear1="Sherida Earring",
        ear2="Dedition Earring",
        ring1="Moonlight Ring",
        ring2="Defending Ring",
        back=gear.RUN_TP_Cape,
        waist="Ioskeha Belt +1",
        }    

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.Embolden = set_combine(sets.midcast.EnhancingDuration, {back="Evasionist's Cape"})
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

    sets.Epeolatry = {main="Epeolatry"}
    sets.Lionheart = {main="Lionheart"}
    sets.Aettir = {main="Aettir"}
    sets.GreatAxe = {main="Hepatizon Axe +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if buffactive['terror'] or buffactive['petrification'] or buffactive['stun'] or buffactive['sleep'] then
        add_to_chat(167, 'Stopped due to status.')
        eventArgs.cancel = true
        return
    end
    if state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.current == 'HP' then
        currentSpell = spell.english
        eventArgs.handled = true
        if spell.action_type == 'Magic' then
            equip(sets.precast.FC.HP)
            add_to_chat(1, 'Precast Swap Magic')
        elseif spell.action_type == 'Ability' then
            equip(sets.Enmity.HP)
			equip(sets.precast.JA[currentSpell])
            add_to_chat(1, 'Precast Swap Ability')
        end
	else
        if spell.action_type == 'Ability' then
            equip(sets.Enmity)
			equip(sets.precast.JA[spell])
        end
    end
    if spell.english == 'Lunge' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Swipe" <t>')
--            add_to_chat(122, '***Lunge Aborted: Timer on Cooldown -- Downgrading to Swipe.***')
            eventArgs.cancel = true
            return
        end
    end
    if spell.english == 'Valiance' then
        local abil_recasts = windower.ffxi.get_ability_recasts()
        if abil_recasts[spell.recast_id] > 0 then
            send_command('input /jobability "Vallation" <me>')
            eventArgs.cancel = true
            return
        elseif spell.english == 'Valiance' and buffactive['vallation'] then
            cast_delay(0.2)
            send_command('cancel Vallation') -- command requires 'cancel' add-on to work
        end
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

function job_midcast(spell, action, spellMap, eventArgs)
    if state.DefenseMode.value == 'Physical' and state.PhysicalDefenseMode.current == 'HP' and spell.english ~= "Phalanx" then
        eventArgs.handled = true
        if spell.action_type == 'Magic' then
            if spell.english == 'Flash' or spell.english == 'Foil' or spell.english == 'Stun'
                or blue_magic_maps.Enmity:contains(spell.english) then
                equip(sets.Enmity.HP)
				add_to_chat(1, 'Midcast Magic Swap')
            elseif spell.skill == 'Enhancing Magic' then
                equip(sets.midcast.EnhancingDuration)
            end
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if state.DefenseMode.value == 'None' then
        if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
            equip(sets.midcast.EnhancingDuration)
            if spellMap == 'Refresh' then
                equip(sets.midcast.Refresh)
            end
		end
        if spell.english == 'Phalanx' and buffactive['Embolden'] then
            equip(sets.midcast.EnhancingDuration)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    equip(sets[state.WeaponSet.current])

    if spell.name == 'Rayke' and not spell.interrupted then
        send_command('@timers c "Rayke ['..spell.target.name..']" '..rayke_duration..' down spells/00136.png')
        send_command('wait '..rayke_duration..';input /echo [Rayke just wore off!];')
    elseif spell.name == 'Gambit' and not spell.interrupted then
        send_command('@timers c "Gambit ['..spell.target.name..']" '..gambit_duration..' down spells/00136.png')
        send_command('wait '..gambit_duration..';input /echo [Gambit just wore off!];')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
    classes.CustomDefenseGroups:clear()
    classes.CustomDefenseGroups:append(state.Charm.current)
    classes.CustomDefenseGroups:append(state.Knockback.current)
    classes.CustomDefenseGroups:append(state.Death.current)

    classes.CustomMeleeGroups:clear()
    classes.CustomMeleeGroups:append(state.Charm.current)
    classes.CustomMeleeGroups:append(state.Knockback.current)
    classes.CustomMeleeGroups:append(state.Death.current)
end

function job_buff_change(buff,gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "terror" then
        if gain then
            equip(sets.defense.PDT)
        end
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

    if buff == 'Embolden' then
        if gain then
            equip(sets.Embolden)
            disable('head','legs','back')
        else
            enable('head','legs','back')
            status_change(player.status)
        end
    end

    if buff:startswith('Aftermath') then
        state.Buff.Aftermath = gain
        customize_melee_set()
        handle_equipping_gear(player.status)
    end

    if buff == 'Battuta' and not gain then
        status_change(player.status)
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end

    equip(sets[state.WeaponSet.current])

end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_update(cmdParams, eventArgs)
    equip(sets[state.WeaponSet.current])
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.Knockback.value == true then
        idleSet = set_combine(idleSet, sets.defense.Knockback)
    end

    --if state.CP.current == 'on' then
    --    equip(sets.CP)
    --    disable('back')
    --else
    --    enable('back')
    --end

    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == "Epeolatry"
        and state.DefenseMode.value == 'None' then
        if state.HybridMode.value == "DT" then
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath.DT)
        else
            meleeSet = set_combine(meleeSet, sets.engaged.Aftermath)
        end
    end
    if state.Knockback.value == true then
        meleeSet = set_combine(meleeSet, sets.defense.Knockback)
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Battuta'] then
        defenseSet = set_combine(defenseSet, sets.defense.Parry)
    end
    if state.Knockback.value == true then
        defenseSet = set_combine(defenseSet, sets.defense.Knockback)
    end

    return defenseSet
end

-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local r_msg = state.Runes.current
    local r_color = ''
    if state.Runes.current == 'Ignis' then r_color = 167
    elseif state.Runes.current == 'Gelus' then r_color = 210
    elseif state.Runes.current == 'Flabra' then r_color = 204
    elseif state.Runes.current == 'Tellus' then r_color = 050
    elseif state.Runes.current == 'Sulpor' then r_color = 215
    elseif state.Runes.current == 'Unda' then r_color = 207
    elseif state.Runes.current == 'Lux' then r_color = 001
    elseif state.Runes.current == 'Tenebrae' then r_color = 160 end

    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local am_msg = '(' ..string.sub(state.AttackMode.value,1,1).. ')'

    local ws_msg = state.WeaponskillMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Knockback.value == true then
        msg = msg .. ' Knockback Resist |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(r_color, string.char(129,121).. '  ' ..string.upper(r_msg).. '  ' ..string.char(129,122)
        ..string.char(31,210).. ' Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002).. ' |'
        ..string.char(31,207).. ' WS' ..am_msg.. ': ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060)
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002).. ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002).. ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'rune' then
        send_command('@input /ja '..state.Runes.value..' <me>')
    end
end

function get_custom_wsmode(spell, action, spellMap)
    if spell.type == 'WeaponSkill' and state.AttackMode.value == 'Uncapped' then
        return "Uncapped"
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'BLU' then
        set_macro_page(2, 12)
    elseif player.sub_job == 'DRK' then
        set_macro_page(3, 12)
    elseif player.sub_job == 'WHM' then
        set_macro_page(4, 12)
    else
        set_macro_page(1, 12)
    end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
