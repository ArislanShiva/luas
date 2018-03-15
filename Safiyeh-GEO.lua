-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:
        
        Magic Burst            Toggle Magic Burst Mode  [Alt-`]
        Capacity Pts. Mode    Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle        Automatically locks desired equipset on file load
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
    indi_timer = ''
    indi_duration = 180

    state.CP = M(false, "Capacity Points Mode")
    
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

    send_command('bind ^` input /ja "Full Circle" <me>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind !w input /ma "Aspir III" <t>')
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
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind !w')
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
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Precast Sets -----------------------------------------
    ------------------------------------------------------------------------------------------------
    
    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {body="Bagua Tunic +1"}
    sets.precast.JA['Full Circle'] = {head="Azimuth Hood +1"}
    sets.precast.JA['Life Cycle'] = {body="Geomancy Tunic +3", back=gear.GEO_Idle_Cape,}

  
    -- Fast cast sets for spells
    
    sets.precast.FC = {
    --  /RDM --15
        --ranged="Dunna", --3
        main="Sucellus",
        sub="Chanter's Shield", --3
        head="Amalric Coif", --10
        body="Merlinic Jubbah", --6
        hands="Merlinic Dastanas", --7
        legs="Geomancy Pants +3", --15
        feet="Regal Pumps +1", --7
        neck="Baetyl Pendant", --4
        ear1="Loquacious Earring", --2
        ear2="Etiolation Earring", --1
        ring1="Kishar Ring", --4
        ring2="Weather. Ring", --5
        back=gear.GEO_FC_Cape, --10
        waist="Witful Belt", --3
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
        back="Perimede Cape",
        })
        
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        hands="Bagua Mitaines +1",
        ear1="Barkarole Earring",
        })

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        ear1="Mendi. Earring", --5
        back="Perimede Cape", --(4)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})

     
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +1",
        feet="Jhakri Pigaches +1",
		neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Regal Earring",
        ring1="Hetairoi Ring",
        ring2="Apate Ring",
		waist="Fotia Belt",
        }
    
    ------------------------------------------------------------------------
    ----------------------------- Midcast Sets -----------------------------
    ------------------------------------------------------------------------
    
    -- Base fast recast for spells
    sets.midcast.FastRecast = {
        main="Solstice",
        sub="Chanter's Shield", 
        head="Amalric Coif",
        hands="Merlinic Dastanas",
        legs="Geomancy Pants +3",
        ear1="Loquacious Earring",
        ear2="Etiolation Earring",
        ring1="Kishar Ring",
        ring2="Weather. Ring",
        back=gear.GEO_FC_Cape,
        waist="Witful Belt",
        } -- Haste
    
   sets.midcast.Geomancy = {
        main="Sucellus",
        sub="Chanter's Shield",
        head="Vanya Hood",
        body="Azimuth Coat +1",
        hands="Shrieker's Cuffs",
        legs="Azimuth Tights +1",
        feet="Merlinic Crackows",
        ear1="Calamitous Earring",
        ear2="Gifted Earring",
        neck="Incanter's Torque",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back="Lifestream Cape",
        waist="Austerity Belt +1",
        }
    
    sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {
        hands="Geo. Mitaines +3",
        legs="Bagua Pants +1",
        feet="Azimuth Gaiters +1",
        })

    sets.midcast.Cure = {
        main="Tamaxchi", --22/(-10)
        sub="Sors Shield", --3
        head="Vanya Hood", --10
        body="Vanya Robe", --7
        hands="Telchine Gloves", --17
        feet="Vanya Clogs", --5
        neck="Incanter's Torque",
        ear1="Beatific Earring",
        ear2="Mendi. Earring", --5
        ring1="Haoma's Ring",
        ring2="Haoma's Ring",
        back="Oretan. Cape +1", --5
        waist="Bishop's Sash",
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {

        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        feet="Vanya Clogs",
        neck="Malison Medallion",
        ear1="Beatific Earring",
        ring1="Haoma's Ring",
        ring2="Haoma's Ring",
        back="Oretan. Cape +1",
        })

    sets.midcast['Enhancing Magic'] = {
        main="Gada",
        sub="Ammurapi Shield",
        head="Befouled Crown",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        main="Gada",
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        }

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        })
    
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        head="Amalric Coif",
        })
            
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck="Nodens Gorget",
		waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
        main="Vadose Rod",
        sub="Ammurapi Shield",
        head="Amalric Coif",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        ring2="Sheltered Ring",
        })

    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect


    sets.midcast.MndEnfeebles = {
        main="Grioavolr",
        sub="Enki Strap",
        head="Geo. Galero +2",
        body="Geomancy Tunic +3",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Geo. Sandals +3",
        neck="Erra Pendant",
        ear1="Barkarole Earring",
        ear2="Regal Earring",
        ring1="Kishar Ring",
        ring2="Stikini Ring",
        back=gear.GEO_FC_Cape,
        waist="Luminary Sash",
       } -- MND/Magic accuracy
    
    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        ear1="Barkarole Earring",
        ring1="Shiva Ring",
        ring2="Shiva Ring",
        back=gear.GEO_MAB_Cape,
        }) -- INT/Magic accuracy

    sets.midcast['Dark Magic'] = {
        main="Rubicundity",
        sub="Ammurapi Shield",
        head="Geo. Galero +2",
        body="Geomancy Tunic +3",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +3",
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        ear1="Barkarole Earring",
        ear2="Digni. Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back=gear.GEO_MAB_Cape,
        waist="Luminary Sash",
        }
    
    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Bagua Galero +1",
        ring1="Evanescence Ring",
        waist="Fucho-no-Obi",
        })
    
    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        })

    -- Elemental Magic sets
    
    sets.midcast['Elemental Magic'] = {
        main="Solstice",
        sub="Ammurapi Shield",
        head="Merlinic Hood",
        body="Jhakri Robe +2",
        hands="Amalric Gages",
        legs="Merlinic Shalwar",
        feet="Merlinic Crackows",
        neck="Baetyl Pendant",
        ear1="Barkarole Earring",
        ear2="Regal Earring",
        ring1="Shiva Ring",
        ring2="Shiva Ring",
        back=gear.GEO_MAB_Cape,
        waist="Refoccilation Stone",
        }

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        head="Geo. Galero +2",
        neck="Erra Pendant",
        ear2="Digni. Earring",
        })

    sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {

        })

    sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
        body="Seidr Cotehardie",
        })

    sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {
        body="Seidr Cotehardie",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        head=empty,
        body="Twilight Cloak",
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
        body="Jhakri Robe +2",
        hands="Bagua Mitaines +1",
        legs="Assid. Pants +1",
        feet="Geo. Sandals +3",
        neck="Bathy Choker +1",
        ear2="Infused Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back="Moonbeam Cape",
        waist="Austerity Belt +1",
        }
    
    sets.resting = set_combine(sets.idle, {
        waist="Austerity Belt +1",
        })

    sets.idle.DT = set_combine(sets.idle, {
        sub="Genmei Shield", --10/0
        body="Mallquis Saio +2", --8/8
        hands="Geo. Mitaines +3", --3/0
        feet="Azimuth Gaiters +1", --4/0
        neck="Loricate Torque +1", --6/6
        ear2="Etiolation Earring", --0/3
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonbeam Cape", --5/5
        })

    sets.idle.Weak = sets.idle.DT

    -- .Pet sets are for when Luopan is present.
    sets.idle.Pet = set_combine(sets.idle, { 
        -- Pet: -DT (37.5% to cap) / Pet: Regen
        main="Sucellus", --3/3
        sub="Genmei Shield",
        --ranged="Dunna", --5/0
        head="Telchine Cap", --0/3
        body="Telchine Chas.", --0/3
        hands="Geo. Mitaines +3", --13/0
        legs="Telchine Braconi", --0/2
        feet="Telchine Pigaches", --0/3
        ear1="Handler's Earring", --3*/0
        ear2="Handler's Earring +1", --4*/0
        back=gear.GEO_Idle_Cape, --0/10
        waist="Isa Belt" --3/1
        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
        neck="Loricate Torque +1", --6/6
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring",
        back="Moonbeam Cape", --5/5
        })

    -- .Indi sets are for when an Indi-spell is active.
    --sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants +1"})
    --sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants +1"})
    --sets.idle.DT.Indi = set_combine(sets.idle.DT, {legs="Bagua Pants +1"})
    --sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {legs="Bagua Pants +1"})

    sets.idle.Town = set_combine(sets.idle, {
        sub="Ammurapi Shield",
        head="Geo. Galero +2",
        body="Geomancy Tunic +3",
        hands="Geo. Mitaines +3",
        legs="Geomancy Pants +3",
        neck="Incanter's Torque",
        ear2="Regal Earring",
        })
        
    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {
        feet="Geo. Sandals +3",
        }

    sets.latent_refresh = {
        waist="Fucho-no-Obi",
        }
    
    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {        
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +1",
        feet="Jhakri Pigaches +1",
        ear1="Cessance Earring",
        ear2="Regal Earring",
        ring1="Hetairoi Ring",
        ring2="Apate Ring",
        waist="Cetl Belt",
        }


    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.magic_burst = {
        head="Merlinic Hood", --5
        hands="Amalric Gages", --(5)
        body="Merlinic Jubbah", --10
        legs="Merlinic Shalwar", --11
        neck="Mizu. Kubikazari", --10
        ring2="Mujin Band", --(5)
        }

    sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
    
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

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
    end
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            --send_command('@timers d "'..indi_timer..'"')
            --indi_timer = spell.english
            --send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.skill == 'Elemental Magic' then
 --           state.MagicBurst:reset()
        end
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        end 
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
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
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

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

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'nuke' then
        handle_nuking(cmdParams)
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 1)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 1')
end