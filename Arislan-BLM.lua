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
--              [ ALT+` ]           Toggle Magic Burst Mode
--              [ WIN+D ]           Toggle Death Casting Mode Toggle
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Spells:     [ CTRL+` ]          Stun
--              [ ALT+P ]           Shock Spikes
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

    state.CP = M(false, "Capacity Points Mode")
    lockstyleset = 10

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.CastingMode:options('Normal', 'Resistant', 'Spaekona', 'Occult')
    state.IdleMode:options('Normal', 'DT')

    state.WeaponLock = M(false, 'Weapon Lock')    
    state.MagicBurst = M(false, 'Magic Burst')
    state.DeathMode = M(false, 'Death Mode')
    state.CP = M(false, "Capacity Points Mode")

    lowTierNukes = S{'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'}
    
    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line
    
    send_command('bind ^` input /ma Stun <t>')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind !p input /ma "Shock Spikes" <me>')
    send_command('bind @d gs c toggle DeathMode')
    send_command('bind @c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind ^numpad0 input /Myrkr')

    select_default_macro_book()
    set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind @d')
    send_command('unbind @c')
    send_command('unbind @w')
    send_command('unbind ^numpad0')

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
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    ---- Precast Sets ----
    
    -- Precast sets to enhance JAs
    sets.precast.JA['Mana Wall'] = {
        feet="Wicce Sabots +1",
        back=gear.BLM_Death_Cape,
        }

    sets.precast.JA.Manafont = {body="Arch. Coat"}

    -- Fast cast sets for spells
    sets.precast.FC = {
    --    /RDM --15 /SCH --10
        main="Oranyan", --7
        sub="Clerisy Strap +1", --3
        ammo="Sapience Orb", --2
        head="Amalric Coif", --10
        body="Shango Robe", --8
        hands="Merlinic Dastanas", --6
        legs="Psycloth Lappas", --7
        feet="Regal Pumps +1", --7
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        ring2="Weather. Ring +1", --5
        back=gear.BLM_FC_Cape, --10
        waist="Witful Belt", --3/(2)
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        waist="Siegel Sash",
        back="Perimede Cape",
        })

    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        waist="Channeler's Stone", --2
        })

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        main="Oranyan", --7
        sub="Clerisy Strap +1", --3
        ammo="Impatiens",
        ear1="Mendi. Earring", --5
        ring1="Lebeche Ring", --(2)
        back="Perimede Cape", --(4)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
    sets.precast.Storm = set_combine(sets.precast.FC, {ring2="Levia. Ring +1", waist="Channeler's Stone"}) -- stop quick cast
    
    sets.precast.FC.DeathMode = {
        ammo="Ghastly Tathlum +1",
        head="Amalric Coif", --10
        body="Amalric Doublet",
        hands="Merlinic Dastanas", --6
        legs="Psycloth Lappas", --7
        feet="Regal Pumps +1", --7
        neck="Orunmila's Torque", --5
        ear1="Etiolation Earring", --1
        ear2="Loquacious Earring", --2
        ring1="Mephitas's Ring +1",
        ring2="Weather. Ring +1", --5
        back="Bane Cape", --4
        waist="Witful Belt", --3/(2)
        }

    sets.precast.FC.Impact.DeathMode = set_combine(sets.precast.FC.DeathMode, {head=empty, body="Twilight Cloak"})

    -- Weaponskill sets
    
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Floestone",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Telchine Braconi",
        feet="Jhakri Pigaches +2",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Rufescent Ring",
        ring2="Shukuyu Ring",
        back="Relucent Cape",
        waist="Fotia Belt",
        }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Vidohunir'] = {
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        body="Amalric Doublet",
        hands="Amalric Gages",
        legs=gear.Merlinic_MB_legs,
        feet="Merlinic Crackows",
        neck="Baetyl Pendant",
        ear1="Barkaro. Earring",
        ear2="Moonshade Earring",
        ring1="Shiva Ring +1",
        ring2="Archon Ring",
        back=gear.BLM_MAB_Cape,
        waist="Yamabuki-no-Obi",
        } -- INT

    sets.precast.WS['Myrkr'] = {
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        body="Weather. Robe +1",
        hands="Telchine Gloves",
        legs="Amalric Slops",
        feet="Medium's Sabots",
        neck="Orunmila's Torque",
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        ring1="Mephitas's Ring +1",
        ring2="Mephitas's Ring",
        back="Bane Cape",
        waist="Shinjutsu-no-Obi +1",
        } -- Max MP

    
    ---- Midcast Sets ----

    sets.midcast.FastRecast = {
        head="Amalric Coif",
        hands="Merlinic Dastanas",
        legs=gear.Merlinic_MB_legs,
        feet="Regal Pumps +1",
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        ring1="Kishar Ring",
        back=gear.BLM_FC_Cape,
        waist="Witful Belt",
        } -- Haste

    sets.midcast.Cure = {
        main="Tamaxchi", --22/(-10)
        sub="Sors Shield", --3/(-5)
        ammo="Esper Stone +1", --0/(-5)
        body="Vanya Robe",
        hands="Telchine Gloves", --10
        legs="Gyve Trousers", --10
        feet="Medium's Sabots", --12
        neck="Nodens Gorget", --5
        ear1="Mendi. Earring", --5
        ear2="Roundel Earring", --5
        ring1="Lebeche Ring", --3/(-5)
        ring2="Haoma's Ring",
        back="Oretan. Cape +1", --6
        waist="Bishop's Sash",
        }

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        neck="Nuna Gorget +1",
        ring1="Levia. Ring +1",
        ring2="Levia. Ring +1",
        waist="Luminary Sash",
        })

    sets.midcast.Cursna = set_combine(sets.midcast.Cure, {
        main="Gada",
        sub="Genmei Shield",
        head="Vanya Hood",
        body="Vanya Robe",
        hands="Hieros Mittens",
        feet="Vanya Clogs",
        neck="Debilis Medallion",
        ear1="Beatific Earring",
        ear2="Healing Earring",
        ring1="Haoma's Ring",
        ring2="Haoma's Ring",
        })

    sets.midcast['Enhancing Magic'] = {
        main="Gada",
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        ear1="Augment. Earring",
        ear2="Andoaa Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back="Fi Follet Cape +1",
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
        body="Telchine Chas.",
        })
    
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        head="Amalric Coif",
        --feet="Inspirited Boots",
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        })
    
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck="Nodens Gorget",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
        main="Vadose Rod",
        sub="Ammurapi Shield",
        head="Amalric Coif",
        waist="Emphatikos Rope",
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        ring1="Sheltered Ring",
        })
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast.MndEnfeebles = {
        main=gear.Grioavolr_MND,
        sub="Enki Strap",
        ammo="Quartz Tathlum +1",
        head="Merlinic Hood",
        body="Vanya Robe",
        hands="Ea Cuffs",
        legs=gear.Merlinic_MAcc_legs,
        feet="Skaoi Boots",
        neck="Erra Pendant",
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Kishar Ring",
        ring2="Stikini Ring",
        back=gear.BLM_FC_Cape,
        waist="Rumination Sash",
        } -- MND/Magic accuracy

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main=gear.Grioavolr_MB,
        ammo="Pemphredo Tathlum",
        back=gear.BLM_MAB_Cape,
        }) -- INT/Magic accuracy
        
    sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

    sets.midcast['Dark Magic'] = {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        ammo="Pemphredo Tathlum",
        head="Merlinic Hood",
        body="Jhakri Robe +2",
        hands="Ea Cuffs",
        legs=gear.Merlinic_MAcc_legs,
        feet="Merlinic Crackows",
        neck="Erra Pendant",
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back=gear.BLM_MAB_Cape,
        waist="Luminary Sash",
        }

    sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
        head="Pixie Hairpin +1",
        feet="Merlinic Crackows",
        ear1="Hirudinea Earring",
        ring1="Evanescence Ring",
        ring2="Archon Ring",
        waist="Fucho-no-obi",
        })

    sets.midcast.Aspir = sets.midcast.Drain

    sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
        feet="Regal Pumps +1",
        waist="Channeler's Stone",
        })

    sets.midcast.Death = {
        main=gear.Grioavolr_MB, --5
        sub="Enki Strap",
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        body="Merlinic Jubbah", --10
        hands="Ea Cuffs", --5(5)
        legs="Amalric Slops",
        feet="Merlinic Crackows", --11
        neck="Mizu. Kubikazari", --10
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Mephitas's Ring +1",
        back=gear.BLM_Death_Cape, --5
        waist="Yamabuki-no-Obi",
        }

    sets.midcast.Death.Resistant = set_combine(sets.midcast.Death, {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        head="Amalric Coif",
        legs=gear.Merlinic_MAcc_legs,
        ring2="Shiva Ring +1",
        })

    sets.midcast.Death.Occult = set_combine(sets.midcast.Death, {
        sub="Bloodrain Strap",
        head="Mallquis Chapeau +1",
        legs="Perdition Slops",
        feet="Battlecast Gaiters",
        neck="Seraphic Ampulla",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Apate Ring",
        waist="Oneiros Rope",
        })

    -- Elemental Magic sets
    
    sets.midcast['Elemental Magic'] = {
        main=gear.Lathi_MAB,
        sub="Niobid Strap",
        ammo="Pemphredo Tathlum",
        head="Merlinic Hood",
        body="Merlinic Jubbah",
        hands="Amalric Gages",
        legs=gear.Merlinic_MAcc_legs,
        feet="Merlinic Crackows",
        neck="Baetyl Pendant",
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back=gear.BLM_MAB_Cape,
        waist="Refoccilation Stone",
        }

    sets.midcast['Elemental Magic'].DeathMode = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        ammo="Ghastly Tathlum +1",
        legs="Amalric Slops",
        feet="Jhakri Pigaches +2",
        neck="Erra Pendant",
        back=gear.BLM_Death_Cape,
        })

    sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        hands="Ea Cuffs",
        neck="Sanctity Necklace",
        waist="Yamabuki-no-Obi",
        })
            
    sets.midcast['Elemental Magic'].Spaekona = set_combine(sets.midcast['Elemental Magic'], {
        sub="Enki Strap",
        body="Spaekona's Coat +2",
        legs=gear.Merlinic_MAcc_legs,
        neck="Erra Pendant",
        })

    sets.midcast['Elemental Magic'].Occult = set_combine(sets.midcast['Elemental Magic'], {
        sub="Bloodrain Strap",
        head="Mallquis Chapeau +1",
        legs="Perdition Slops",
        feet="Battlecast Gaiters",
        neck="Seraphic Ampulla",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Apate Ring",
        waist="Oneiros Rope",
        })

    sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
        sub="Niobid Strap",
        head=empty,
        body="Twilight Cloak",
        ring2="Archon Ring",
        })

    sets.midcast.Impact.Resistant = set_combine(sets.midcast['Elemental Magic'].Resistant, {
        sub="Enki Strap",
        head=empty,
        body="Twilight Cloak",
        })

    sets.midcast.Impact.Occult = set_combine(sets.midcast.Impact, {
        sub="Bloodrain Strap",
        legs="Perdition Slops",
        feet="Battlecast Gaiters",
        neck="Seraphic Ampulla",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Apate Ring",
        waist="Oneiros Rope",
        })

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC
    
    sets.resting = {
        main="Chatoyant Staff",
        waist="Shinjutsu-no-Obi +1",
        }

    -- Idle sets
    
    sets.idle = {
        main="Bolelabunga",
        sub="Genmei Shield",
        ammo="Pemphredo Tathlum",
        head="Befouled Crown",
        body="Jhakri Robe +2",
        hands="Ea Cuffs",
        legs="Assid. Pants +1",
        feet="Herald's Gaiters",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back="Moonbeam Cape",
        waist="Refoccilation Stone",
        }

    sets.idle.DT = set_combine(sets.idle, {
        main="Mafic Cudgel", --10/0
        sub="Genmei Shield", --10/0
        ammo="Staunch Tathlum", --2/2
        body="Mallquis Saio +1", --6/6
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonbeam Cape", --5/5
        waist="Slipor Sash", --0/3
        })

    sets.idle.ManaWall = {
        feet="Wicce Sabots +1",
        back=gear.BLM_Death_Cape,
        }

    sets.idle.DeathMode = {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        ammo="Ghastly Tathlum +1",
        head="Pixie Hairpin +1",
        body="Amalric Doublet",
        hands="Amalric Gages",
        legs="Amalric Slops",
        feet="Merlinic Crackows",
        neck="Sanctity Necklace",
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Mephitas's Ring +1",
        ring2="Mephitas's Ring",
        back=gear.BLM_Death_Cape,
        waist="Shinjutsu-no-Obi +1",
        }

    sets.idle.Town = set_combine(sets.idle, {
        main=gear.Grioavolr_MB,
        sub="Enki Strap",
        head="Merlinic Hood",
        body="Merlinic Jubbah",
        hands="Ea Cuffs",
        legs=gear.Merlinic_MB_legs,
        neck="Incanter's Torque",
        ear1="Barkaro. Earring",
        ear2="Regal Earring",
        ring1="Shiva Ring +1",
        ring2="Weather. Ring +1",
        back=gear.BLM_MAB_Cape,
        })

    sets.idle.Weak = sets.idle.DT
        
    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Herald's Gaiters"}
    sets.latent_refresh = {waist="Fucho-no-obi"}
    sets.latent_dt = {ear2="Sorcerer's Earring"}

    sets.magic_burst = { 
        body="Merlinic Jubbah", --10
        hands="Ea Cuffs", --5(5)
        feet="Merlinic Crackows", --11
        neck="Mizu. Kubikazari", --10
        ring1="Mujin Band", --(5)
        back=gear.BLM_MAB_Cape, --5
        }

    sets.magic_burst.Resistant = {} 

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group

    sets.engaged = {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring",
        ring2="Hetairoi Ring",
        back="Relucent Cape",
        }

    sets.buff.Doom = {ring1="Eshmun's Ring", ring2="Eshmun's Ring", waist="Gishdubar Sash"}

    sets.DarkAffinity = {head="Pixie Hairpin +1",ring2="Archon Ring"}
    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        equip(sets.precast.FC.DeathMode)
        if spell.english == "Impact" then
            equip(sets.precast.FC.Impact.DeathMode)
        end
    end
    
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' and state.DeathMode.value then
        eventArgs.handled = true
        if spell.skill == 'Elemental Magic' then
            equip(sets.midcast['Elemental Magic'].DeathMode)
        else
            if state.CastingMode.value == "Resistant" then
                equip(sets.midcast.Death.Resistant)
            else
                equip(sets.midcast.Death)
            end
        end
    end

    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) and not state.DeathMode.value then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
    if spell.skill == 'Elemental Magic' and spell.english == "Comet" then
        equip(sets.DarkAffinity)        
    end
    if spell.skill == 'Elemental Magic' then
        if state.MagicBurst.value and spell.english ~= 'Death' then
            --if state.CastingMode.value == "Resistant" then
                --equip(sets.magic_burst.Resistant)
            --else
                equip(sets.magic_burst)
            --end
            if spell.english == "Impact" then
                equip(sets.midcast.Impact)
            end
        end
        if (spell.element == world.day_element or spell.element == world.weather_element) then
            equip(sets.Obi)
        end
    end
    if buffactive['Mana Wall'] then
        equip(sets.precast.JA['Mana Wall'])
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" or spell.english == "Sleepga II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Break" or spell.english == "Breakga" then
            send_command('@timers c "Break ['..spell.target.name..']" 30 down spells/00255.png')
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
    -- Unlock armor when Mana Wall buff is lost.
    if buff== "Mana Wall" then
        if gain then
            --send_command('gs enable all')
            equip(sets.precast.JA['Mana Wall'])
            --send_command('gs disable all')
        else
            --send_command('gs enable all')
            handle_equipping_gear(player.status)
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

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end

-- latent DT set auto equip on HP% change
    windower.register_event('hpp change', function(new, old)
        if new<=25 then
            equip(sets.latent_dt)
        end
    end)


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.DeathMode.value then
        idleSet = sets.idle.DeathMode
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if player.hpp <= 25 then
        idleSet = set_combine(idleSet, sets.latent_dt)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if buffactive['Mana Wall'] then
        idleSet = set_combine(idleSet, sets.precast.JA['Mana Wall'])
    end
    
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if buffactive['Mana Wall'] then
        meleeSet = set_combine(meleeSet, sets.precast.JA['Mana Wall'])
    end

    return meleeSet
end

function customize_defense_set(defenseSet)
    if buffactive['Mana Wall'] then
        defenseSet = set_combine(defenseSet, sets.precast.JA['Mana Wall'])
    end

    return defenseSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 5)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end