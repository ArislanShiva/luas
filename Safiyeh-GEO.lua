-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ ALT+` ]           Magic Burst Mode Toggle
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Full Circle
--              [ CTRL+B ]          Blaze of Glory
--              [ CTRL+A ]          Ecliptic Attrition
--              [ CTRL+D ]          Dematerialize
--              [ CTRL+L ]          Life Cycle
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad0 ]    Myrkr
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
    geo_timer = ''
    indi_timer = ''
    indi_duration = 308
    entrust_timer = ''
    entrust_duration = 344
    entrust = 0
    newLuopan = 0

    state.Buff.Entrust = buffactive.Entrust or false
    state.Buff['Blaze of Glory'] = buffactive['Blaze of Glory'] or false

    state.CP = M(false, "Capacity Points Mode")

    state.Auto = M(true, 'Auto Nuke')
    state.Element = M{['description']='Element','Fire','Blizzard','Aero','Stone','Thunder','Water'}

    no_swap_gear = S{"Warp Ring", "Dim. Ring (Dem)", "Dim. Ring (Holla)", "Dim. Ring (Mea)",
              "Trizek Ring", "Echad Ring", "Facility Ring", "Capacity Ring"}

    degrade_array = {
        ['Fire'] = {'Fire','Fire II','Fire III','Fire IV','Fire V'},
        ['Ice'] = {'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V'},
        ['Wind'] = {'Aero','Aero II','Aero III','Aero IV','Aero V'},
        ['Earth'] = {'Stone','Stone II','Stone III','Stone IV','Stone V'},
        ['Lightning'] = {'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V'},
        ['Water'] = {'Water', 'Water II','Water III', 'Water IV','Water V'},
        ['Aspirs'] = {'Aspir','Aspir II','Aspir III'},
        }

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Seidr', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')
    state.MagicBurst = M(false, 'Magic Burst')

    -- Additional local binds
    include('Global-Binds.lua')

    send_command('lua l gearinfo')

    send_command('bind ^` input /ja "Full Circle" <me>')
    send_command('bind ^b input /ja "Blaze of Glory" <me>')
    send_command('bind ^a input /ja "Ecliptic Attrition" <me>')
    send_command('bind ^d input /ja "Dematerialize" <me>')
    send_command('bind ^c input /ja "Life Cycle" <me>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^insert gs c cycleback Element')
    send_command('bind ^delete gs c cycle Element')
    send_command('bind !w input /ma "Aspir III" <t>')
    send_command('bind !p input /ja "Entrust" <me>')
    send_command('bind ^, input /ma Sneak <stpc>')
    send_command('bind ^. input /ma Invisible <stpc>')
    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')

    send_command('bind ^numpad7 input /ws "Black Halo" <t>')
    send_command('bind ^numpad8 input /ws "Hexa Strike" <t>')
    send_command('bind ^numpad9 input /ws "Realmrazer" <t>')
    send_command('bind ^numpad6 input /ws "Exudation" <t>')
    send_command('bind ^numpad1 input /ws "Flash Nova" <t>')

    send_command('bind #- input /follow <t>')

    select_default_macro_book()
    set_lockstyle()

    state.Auto_Kite = M(false, 'Auto_Kite')
    moving = false
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind ^b')
    send_command('unbind ^a')
    send_command('unbind ^d')
    send_command('unbind ^c')
    send_command('unbind !`')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind !w')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad1')
    send_command('unbind !numpad7')
    send_command('unbind !numpad8')
    send_command('unbind !numpad9')
    send_command('unbind !numpad4')
    send_command('unbind !numpad5')
    send_command('unbind !numpad6')
    send_command('unbind !numpad1')
    send_command('unbind !numpad+')

    send_command('lua u gearinfo')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Precast Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +3"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +1"}
    sets.precast.JA['Life Cycle'] = {head="Bagua Galero +3", body="Geomancy Tunic +3", back=gear.GEO_Idle_Cape,}


    -- Fast cast sets for spells

    sets.precast.FC = {
    --  /RDM --15
        ranged="Dunna", --3
        main="Sucellus", --5
        sub="Chanter's Shield", --3
        head="Amalric Coif", --10
        body=gear.Merl_MB_body, --6
        hands="Merlinic Dastanas", --7
        legs="Geomancy Pants +3", --15
        feet="Regal Pumps +1", --7
        neck="Baetyl Pendant", --4
        ear1="Malignance Earring", --4
        ear2="Etiolation Earring", --1
        ring1="Kishar Ring", --4
        ring2="Weather. Ring +1", --6(4)
        back=gear.GEO_FC_Cape, --10
        waist="Embla Sash", --5
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        back="Perimede Cape",
        waist="Siegel Sash",
        })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {hands="Bagua Mitaines +3"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --(2)
        back="Perimede Cape", --(4)
        waist="Witful Belt", --3(3)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {main="Daybreak", sub="Ammurapi Shield"})


    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Brutal Earring",
        ring1="Petrov Ring",
        ring2="Hetairoi Ring",
        waist="Fotia Belt",
        }

    sets.precast.WS['Hexastrike'] = set_combine(sets.precast.WS, {
        neck="Caro Necklace",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Exudation'] = sets.precast.WS['Hexastrike']

    ------------------------------------------------------------------------
    ----------------------------- Midcast Sets -----------------------------
    ------------------------------------------------------------------------

    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        main="Sucellus",
        sub="Chanter's Shield",
        head="Amalric Coif",
        hands="Merlinic Dastanas",
        legs="Geomancy Pants +3",
        ear1="Malignance Earring",
        ear2="Etiolation Earring",
        ring1="Kishar Ring",
        ring2="Weather. Ring +1",
        back=gear.GEO_FC_Cape,
        waist="Witful Belt",
        } -- Haste

   sets.midcast.Geomancy = {
        main="Idris",
        sub="Chanter's Shield",
        head="Bagua Galero +3",
        body="Azimuth Coat +1",
        hands="Shrieker's Cuffs",
        legs="Vanya Slops",
        feet="Merlinic Crackows",
        ear1="Calamitous Earring",
        ear2="Gifted Earring",
        neck="Reti Pendant",
        ring1={name="Stikini Ring", bag="wardrobe3"},
        ring2={name="Stikini Ring", bag="wardrobe4"},
        back="Lifestream Cape",
        waist="Austerity Belt +1",
        }

    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        head="Vanya Hood",
        legs="Bagua Pants +3",
        feet="Azimuth Gaiters +1",
        back="Lifestream Cape",
        })

    sets.midcast.Cure = {
        main="Daybreak", --30
        sub="Sors Shield", --3/(-5)
        head="Vanya Hood", --10
        body="Vanya Robe", --7/(-6)
        hands="Vanya Cuffs",
        legs="Vanya Slops",
        feet="Vanya Clogs", --5
        neck="Incanter's Torque",
        ear1="Beatific Earring",
        ear2="Meili Earring",
        ring1="Lebeche Ring", --3/(-5)
        ring2={name="Haoma's Ring", bag="wardrobe3"},
        back=gear.GEO_Cure_Cape, --0/(-10)
        waist="Bishop's Sash",
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        neck="Nuna Gorget +1",
        ring2="Metamor. Ring +1",
        waist="Luminary Sash",
        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        neck="Malison Medallion",
        ring1={name="Haoma's Ring", bag="wardrobe3"},
        ring2={name="Haoma's Ring", bag="wardrobe4"},
        back="Oretan. Cape +1",
        })

    sets.midcast['Enhancing Magic'] = {
        main=gear.Gada_ENH,
        sub="Ammurapi Shield",
        head="Befouled Crown",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        ear1="Mimir Earring",
        ear2="Andoaa Earring",
        ring1={name="Stikini Ring", bag="wardrobe3"},
        ring2={name="Stikini Ring", bag="wardrobe4"},
        back="Perimede Cape",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        main=gear.Gada_ENH,
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        waist="Embla Sash",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        })

    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
        head="Amalric Coif",
        })

    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {
        main="Vadose Rod",
        sub="Ammurapi Shield",
        head="Amalric Coif",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast.MndEnfeebles = {
        main="Idris",
        sub="Ammurapi Shield",
        head="Geo. Galero +3",
        body="Geomancy Tunic +3",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Bagua Sandals +3",
        neck="Bagua Charm +2",
        ear1="Malignance Earring",
        ear2="Vor Earring",
        ring1="Kishar Ring",
        ring2={name="Stikini Ring", bag="wardrobe4"},
        back=gear.GEO_FC_Cape,
        waist="Luminary Sash",
        } -- MND/Magic accuracy

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        ring1="Freke Ring",
        ring2="Weather. Ring +1",
        back=gear.GEO_MAB_Cape,
        }) -- INT/Magic accuracy

    sets.midcast.Dispelga = set_combine(sets.midcast.IntEnfeebles, {main="Daybreak", sub="Ammurapi Shield"})

    sets.midcast['Dark Magic'] = {
        main="Rubicundity",
        sub="Ammurapi Shield",
        head="Geo. Galero +3",
        body="Geomancy Tunic +3",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Digni. Earring",
        ring1={name="Stikini Ring", bag="wardrobe3"},
        ring2="Metamor. Ring +1",
        back=gear.GEO_MAB_Cape,
        waist="Luminary Sash",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Bagua Galero +3",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        ear2="Mani Earring",
        waist="Fucho-no-Obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        })

    -- Elemental Magic sets

    sets.midcast['Elemental Magic'] = {
        main="Daybreak",
        sub="Ammurapi Shield",
        head="Bagua Galero +3",
        body="Bagua Tunic +3",
        hands="Bagua Mitaines +3",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Saevus Pendant +1",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Metamor. Ring +1",
        back=gear.GEO_MAB_Cape,
        waist="Refoccilation Stone",
        }

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        feet="Bagua Sandals +3",
        neck="Sanctity Necklace",
        ear2="Digni. Earring",
        })

    sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {})

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'].Resistant, {
        body="Seidr Cotehardie",
        })

    sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {})

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    ------------------------------------------------------------------------------------------------
    ------------------------------------------ Idle Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main="Bolelabunga",
        sub="Genmei Shield",
        head="Befouled Crown",
        body="Geomancy Tunic +3",
        hands="Bagua Mitaines +3",
        legs="Assid. Pants +1",
        feet="Ea Pigaches +1",
        neck="Bathy Choker +1",
        ear1="Lugalbanda Earring",
        ear2="Etiolation Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back=gear.GEO_Idle_Cape,
        waist="Slipor Sash",
        }

    sets.resting = set_combine(sets.idle, {
        waist="Austerity Belt +1",
        })

    sets.idle.DT = set_combine(sets.idle, {
        sub="Genmei Shield", --10/0
        head="Ea Hat +1",
        body="Mallquis Saio +2", --8/8
        hands="Geo. Mitaines +3", --3/0
        legs="Ea Slops +1",
        feet="Ea Pigaches +1",
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ear2="Etiolation Earring", --0/3
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back=gear.GEO_Idle_Cape, --5/5
        waist="Slipor Sash", --0/3
        })

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, {
        -- Pet: -DT (37.5% to cap) / Pet: Regen
        main="Idris", --0/0/25/0
        sub="Genmei Shield", --10/0/0/0
        head="Telchine Cap", --0/0/0/3
        body="Telchine Chas.", --0/0/0/3
        hands="Geo. Mitaines +3", --3/0/13/0
        legs="Telchine Braconi", --0/0/0/3
        feet="Bagua Sandals +3", --0/0/0/5
        neck="Bagua Charm +2",
        ear1="Lugalbanda Earring",
        ear2="Etiolation Earring", --0/3/0/0
        ring1="Gelatinous Ring +1", --7/(-1)/0/0
        ring2="Defending Ring", --10/10/0/0
        back=gear.GEO_Pet_Cape, --0/0/0/15
        waist="Isa Belt" --0/0/3/1
        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
        body="Mallquis Saio +2", --8/8
        back=gear.GEO_Idle_Cape, --5/5
        })

    sets.PetHP = {head="Bagua Galero +3"}

    -- .Indi sets are for when an Indi-spell is active.
    --sets.idle.Indi = set_combine(sets.idle, {})
    --sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {})
    --sets.idle.DT.Indi = set_combine(sets.idle.DT, {})
    --sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {})

    sets.idle.Town = set_combine(sets.idle, {
        main="Idris",
        sub="Ammurapi Shield",
        head="Bagua Galero +3",
        body="Geomancy Tunic +3",
        legs="Bagua Pants +3",
        feet="Bagua Sandals +3",
        neck="Bagua Charm +2",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Freke Ring",
        ring2="Weather. Ring +1",
        back=gear.GEO_Pet_Cape,
        })

    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Geo. Sandals +3"}

    sets.latent_refresh = {waist="Fucho-no-Obi"}

    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    -- Normal melee group
    sets.engaged = {
        main="Idris",
        sub="Genmei Shield",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        ear1="Cessance Earring",
        ear2="Brutal Earring",
        ring1="Petrov Ring",
        ring2="Hetairoi Ring",
        waist="Cetl Belt",
        }


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    --[[sets.magic_burst = {
        head="Merlinic Hood", --5
        body=gear.Merl_MB_body, --10
        hands="Amalric Gages", --(5)
        legs="Merlinic Shalwar", --11
        neck="Mizu. Kubikazari", --10
        ring2="Mujin Band", --(5)
        }
    ]]--

    sets.magic_burst = {
        head="Ea Hat +1", --7/(7)
        body="Ea Houppe. +1", --9/(9)
        hands="Amalric Gages +1", --(6)
        legs="Ea Slops +1", --8/(8)
        feet="Ea Pigaches +1", --5/(6)
        neck="Mizu. Kubikazari", --10
        ring2="Mujin Band", --(5)
        }

    sets.buff.Doom = {ring1={name="Saida Ring", bag="wardrobe3"}, ring2={name="Saida Ring", bag="wardrobe4"},}
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell, spellMap, eventArgs)
    if spell.type == 'Geomancy' then
        if spell.name:startswith('Indi') and state.Buff.Entrust and spell.target.type == 'SELF' then
            add_to_chat(002, 'Entrust active - Select a party member!')
            cancel_spell()
        end
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Aspir') then
        refine_various_spells(spell, action, spellMap, eventArgs)
    elseif state.Auto.value == true then
        if spell.skill == 'Elemental Magic' and spell.english ~= 'Impact' and spellMap ~= 'GeoNuke' then
            refine_various_spells(spell, action, spellMap, eventArgs)
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    elseif spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    elseif spell.skill == 'Geomancy' then
        if state.Buff.Entrust and spell.english:startswith('Indi-') then
            equip({main=gear.Gada_GEO})
                entrust = 1
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        --[[if spell.english:startswith('Geo') then
            geo_timer = spell.english
            send_command('@timers c "'..geo_timer..'" 600 down spells/00136.png')
        elseif spell.english:startswith('Indi') then
            if entrust == 1 then
                entrust_timer = spell.english
                send_command('@timers c "'..entrust_timer..' ['..spell.target.name..']" '..entrust_duration..' down spells/00136.png')
                entrust = 0
            else
                send_command('@timers d "'..indi_timer..'"')
                indi_timer = spell.english
                send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
            end
        end ]]
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english:startswith('Geo-') or spell.english == "Life Cycle" then
            newLuopan = 1
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
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
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    if gain == false then
        send_command('@timers d "'..geo_timer..'"')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_handle_equipping_gear(playerStatus, eventArgs)
    check_gear()
    check_moving()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    classes.CustomIdleGroups:clear()
end

function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == 'Enfeebling Magic' then
            if spell.type == 'WhiteMagic' then
                return 'MndEnfeebles'
            else
                return 'IntEnfeebles'
            end
        elseif spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        elseif spell.skill == 'Elemental Magic' then
            if spellMap == 'GeoElem' then
                return 'GeoElem'
            end
        end
    end
end

function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if pet.isvalid then
        if pet.hpp > 73 then
            if newLuopan == 1 then
                equip(sets.PetHP)
                disable('head')
            end
        elseif pet.hpp <= 73 then
            enable('head')
            newLuopan = 0
        end
    end
    if state.Auto_Kite.value == true then
       idleSet = set_combine(idleSet, sets.Kiting)
    end

    return idleSet
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Auto.value then
        msg = ' Auto: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(060, '| Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end

function refine_various_spells(spell, action, spellMap, eventArgs)

    local newSpell = spell.english
    local spell_recasts = windower.ffxi.get_spell_recasts()
    local cancelling = 'All '..spell.english..' are on cooldown. Cancelling.'

    local spell_index

    if spell_recasts[spell.recast_id] > 0 then
        if spell.skill == 'Elemental Magic' and spellMap ~= 'GeoElem' then
            spell_index = table.find(degrade_array[spell.element],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array[spell.element][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        elseif spell.name:startswith('Aspir') then
            spell_index = table.find(degrade_array['Aspirs'],spell.name)
            if spell_index > 1 then
                newSpell = degrade_array['Aspirs'][spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
                eventArgs.cancel = true
            end
        end
    end
end



-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'nuke' and not midaction() then
        send_command('@input /ma "' .. state.Element.current .. ' V" <t>')
    end
    gearinfo(cmdParams, eventArgs)
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
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

function check_moving()
    if state.DefenseMode.value == 'None'  and state.Kiting.value == false then
        if state.Auto_Kite.value == false and moving then
            state.Auto_Kite:set(true)
        elseif state.Auto_Kite.value == true and moving == false then
            state.Auto_Kite:set(false)
        end
    end
end

function check_gear()
    if no_swap_gear:contains(player.equipment.left_ring) then
        disable("ring1")
    else
        enable("ring1")
    end
    if no_swap_gear:contains(player.equipment.right_ring) then
        disable("ring2")
    else
        enable("ring2")
    end
end

windower.register_event('zone change',
    function()
        if no_swap_gear:contains(player.equipment.left_ring) then
            enable("ring1")
            equip(sets.idle)
        end
        if no_swap_gear:contains(player.equipment.right_ring) then
            enable("ring2")
            equip(sets.idle)
        end
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 1)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 1')
end
