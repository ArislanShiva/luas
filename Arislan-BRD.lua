-- Original: Motenten / Modified: Arislan

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Mode
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ CTRL+F11 ]        Cycle Casting Modes
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+` ]          Cycle SongMode
--
--  Songs:      [ ALT+` ]           Chocobo Mazurka
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  Weapons:    [ CTRL+W ]          Toggles Weapon Lock
--
--  WS:         [ CTRL+Numpad7 ]    Mordant Rime
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:
    
    SongMode may take one of three values: None, Placeholder, FullLength
    
    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle SongMode
    gs c set SongMode Placeholder
    
    The Placeholder state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.
    
    
    Simple macro to cast a placeholder Daurdabla song:
    /console gs c set SongMode Placeholder
    /ma "Shining Fantasia" <me>
    
    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
    res = require 'resources'
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.SongMode = M{['description']='Song Mode', 'None', 'Placeholder'}

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false

    include('Mote-TreasureHunter')

    lockstyleset = 1
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')

    state.LullabyMode = M{['description']='Lullaby', 'Potency', 'Duration', 'Range'}

    state.Carol = M{['description']='Carol', 
        'Fire Carol', 'Fire Carol II', 'Ice Carol', 'Ice Carol II', 'Wind Carol', 'Wind Carol II',
        'Earth Carol', 'Earth Carol II', 'Lightning Carol', 'Lightning Carol II', 'Water Carol', 'Water Carol II',
        'Light Carol', 'Light Carol II', 'Dark Carol', 'Dark Carol II',
        }

    state.Threnody = M{['description']='Threnody',
        'Fire Threnody II', 'Ice Threnody II', 'Wind Threnody II', 'Earth Threnody II',
        'Ltng. Threnody II', 'Water Threnody II', 'Light Threnody II', 'Dark Threnody II',
        }

    state.Etude = M{['description']='Etude', 'Sinewy Etude', 'Herculean Etude', 'Learned Etude', 'Sage Etude',
        'Quick Etude', 'Swift Etude', 'Vivacious Etude', 'Vital Etude', 'Dextrous Etude', 'Uncanny Etude',
        'Spirited Etude', 'Logical Etude', 'Echanting Etude', 'Bewitching Etude'}

    state.WeaponLock = M(false, 'Weapon Lock')
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line
   
    -- Adjust this if using the Terpander (new +song instrument)
    info.ExtraSongInstrument = 'Daurdabla'
    -- How many extra songs we can keep from Daurdabla/Terpander
    info.ExtraSongs = 2
    
    send_command('bind ^` gs c cycle SongMode')
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')
    send_command('bind !p input /ja "Pianissimo" <me>')

    send_command('bind ^backspace gs c cycle SongTier')
    send_command('bind ^insert gs c cycleback Etude')
    send_command('bind ^delete gs c cycle Etude')
    send_command('bind ^home gs c cycleback Carol')
    send_command('bind ^end gs c cycle Carol')
    send_command('bind ^pageup gs c cycleback Threnody')
    send_command('bind ^pagedown gs c cycle Threnody')

    send_command('bind @l gs c cycle LullabyMode')
    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')

    send_command('bind ^numpad7 input /ws "Mordant Rime" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
    send_command('bind ^numpad2 input /ws "Wasp Sting" <t>')
    send_command('bind ^numpad3 input /ws "Gust Slash" <t>')

    select_default_macro_book()
    set_lockstyle()
    update_combat_form()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^backspace')
    send_command('unbind !insert')
    send_command('unbind !delete')
    send_command('unbind ^insert')
    send_command('unbind ^delete')
    send_command('unbind ^home')
    send_command('unbind ^end')
    send_command('unbind ^pageup')
    send_command('unbind ^pagedown')
    send_command('unbind @l')
    send_command('unbind @w')
    send_command('unbind @c')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind ^numpad3')
end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Fast cast sets for spells
    sets.precast.FC = {
        main=gear.Kali_Song, --7
        sub="Genmei Shield",
        head="Nahtirah Hat", --10
        body="Inyanga Jubbah +2", --14
        hands="Gende. Gages +1", --7/5
        legs="Aya. Cosciales +2", --6
        feet="Volte Gaiters", --6
        neck="Orunmila's Torque", --5
        ear1="Loquac. Earring", --2
        ear2="Etiolation Earring", --1
        ring1="Weather. Ring +1", --5
        ring2="Kishar Ring", --4
        back=gear.BRD_Song_Cape, --10
        waist="Witful Belt", --3(3)
        }

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
        feet="Kaykaus Boots +1", --0/7
        ear2="Mendi. Earring", --0/5
        })

    sets.precast.FC.BardSong = set_combine(sets.precast.FC, {
        head="Fili Calot +1", --0/14
        feet="Bihu Slippers +1", --8
        neck="Loricate Torque +1",
        ear1="Genmei Earring",
        ring2="Defending Ring",
        })

    sets.precast.FC.SongPlaceholder = set_combine(sets.precast.FC.BardSong, {range=info.ExtraSongInstrument})
    
    -- Precast sets to enhance JAs
    
    sets.precast.JA.Nightingale = {feet="Bihu Slippers +1"}
    sets.precast.JA.Troubadour = {body="Bihu Jstcorps +1"}
    sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
       
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        range=gear.Linos_WS,
        head="Lustratio Cap +1",
        body="Ayanmo Corazza +2",
        hands="Aya. Manopolas +2",
        legs="Lustr. Subligar +1",
        feet="Lustra. Leggings +1",
        neck="Fotia Gorget",
        ear1="Ishvara Earring",
        ear2="Moonshade Earring",
        ring1="Shukuyu Ring",
        ring2="Ilabrat Ring",
        back=gear.BRD_WS_Cape,
        waist="Fotia Belt",
        }
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        range=gear.Linos_TP,
        ear1="Brutal Earring",
        --ring1="Begrudging Ring",
        back=gear.BRD_TP_Cape,
        })
        
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Mordant Rime'] = set_combine(sets.precast.WS, {
        ear2="Regal Earring",
        ring1={name="Carb. Ring +1", bag="wardrobe3"},
        ring2={name="Carb. Ring +1", bag="wardrobe4"},
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
        neck="Caro Necklace",
        ring1="Ramuh Ring +1",
        waist="Grunfeld Rope",
        })
    
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- General set for recast times.
    sets.midcast.FastRecast = sets.precast.FC
        
    -- Gear to enhance certain classes of songs.
    sets.midcast.Ballad = {legs="Fili Rhingrave +1"}
    sets.midcast.Carol = {hands="Mousai Gages"}
    sets.midcast.Etude = {head="Mousai Turban"}
    --sets.midcast.HonorMarch = {range="Marsyas", hands="Fili Manchettes +1"}
    sets.midcast.Lullaby = {range="Daurdabla", body="Fili Hongreline +1", hands="Brioso Cuffs +2"}
    sets.midcast.Madrigal = {head="Fili Calot +1"}
    --sets.midcast.Mambo = {feet="Mousai Crackows"}
    sets.midcast.March = {hands="Fili Manchettes +1"}
    sets.midcast.Minne = {legs="Mousai Seraweels"}
    sets.midcast.Minuet = {body="Fili Hongreline +1"}
    sets.midcast.Paeon = {head="Brioso Roundlet +2"}
    sets.midcast.Threnody = {body="Mousai Manteel"}
    --sets.midcast['Magic Finale'] = {legs="Fili Rhingrave +1"}
    sets.midcast["Sentinel's Scherzo"] = {feet="Fili Cothurnes +1"}

    -- For song buffs (duration and AF3 set bonus)
    sets.midcast.SongEnhancing = {
        main=gear.Kali_Song,
        sub="Genmei Shield",
        range="Gjallarhorn",
        head="Fili Calot +1",
        body="Fili Hongreline +1",
        hands="Fili Manchettes +1",
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        ear1="Genmei Earring",
        ear2="Etiolation Earring",
        ring1="Moonlight Ring",
        ring2="Defending Ring",
        waist="Flume Belt +1",
        back=gear.BRD_Song_Cape,
        }

    -- For song defbuffs (duration primary, accuracy secondary)
    sets.midcast.SongEnfeeble = {
        main=gear.Kali_Song,
        sub="Ammurapi Shield",
        range="Gjallarhorn",
        head="Brioso Roundlet +2",
        body="Brioso Justau. +2",
        hands="Brioso Cuffs +2",
        legs="Inyanga Shalwar +2",
        feet="Brioso Slippers +3",
        neck="Mnbw. Whistle +1",
        ear1="Digni. Earring",
        ear2="Regal Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        waist="Luminary Sash",
        back=gear.BRD_Song_Cape,
        }

    -- For song defbuffs (accuracy primary, duration secondary)
    sets.midcast.SongEnfeebleAcc = set_combine(sets.midcast.SongEnfeeble, {legs="Brioso Cannions +2"})

    -- Placeholder song; minimize duration to make it easy to overwrite.
    sets.midcast.SongPlaceholder = set_combine(sets.midcast.SongEnhancing, {range=info.ExtraSongInstrument})

    -- Other general spells and classes.
    sets.midcast.Cure = {
        main="Chatoyant Staff", --10
        sub="Achaq Grip",
        head="Kaykaus Mitra +1", --11
        body="Kaykaus Bliaut +1", --(+4)/(-6)
        hands="Kaykaus Cuffs +1", --11(+2)/(-6)
        legs="Chironic Hose", --8
        feet="Kaykaus Boots +1", --11(+2)/(-12)
        neck="Incanter's Torque",
        ear2="Mendi. Earring", --5
        ring1="Lebeche Ring", --3/(-5)
        ring2="Haoma's Ring",
        back="Aurist's Cape +1",
        waist="Bishop's Sash",
        }
        
    sets.midcast.Curaga = sets.midcast.Cure
        
    sets.midcast.StatusRemoval = {
        head="Vanya Hood",
        body="Vanya Robe",
        legs="Aya. Cosciales +2",
        feet="Vanya Clogs",
        neck="Incanter's Torque",
        ear2="Healing Earring",
        ring1="Menelaus's Ring",
        ring2="Haoma's Ring",
        back=gear.BRD_Song_Cape,
        waist="Bishop's Sash",
        }
        
    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        hands="Hieros Mittens",
        neck="Debilis Medallion",
        ear1="Beatific Earring",
        back="Oretan. Cape +1",
        })
    
    sets.midcast['Enhancing Magic'] = {
        main=gear.Kali_Song,
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chas.",
        hands="Telchine Gloves",
        legs="Telchine Braconi",
        feet="Telchine Pigaches",
        neck="Incanter's Torque",
        ear1="Augment. Earring",
        ear2="Andoaa Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Fi Follet Cape +1",
        waist="Olympus Sash",
        }

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {head="Inyanga Tiara +2"})
    sets.midcast.Haste = sets.midcast['Enhancing Magic']
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash", back="Grapevine Cape"})
    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {neck="Nodens Gorget", waist="Siegel Sash"})
    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {waist="Emphatikos Rope"})
    sets.midcast.Protect = set_combine(sets.midcast['Enhancing Magic'], {ring2="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Shell

    
    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        main=gear.Kali_Idle,
        sub="Genmei Shield",
        range="Gjallarhorn",
        head="Inyanga Tiara +2",
        body="Kaykaus Bliaut +1",
        hands="Gende. Gages +1",
        legs="Assid. Pants +1",
        feet="Fili Cothurnes +1",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1={name="Stikini Ring +1", bag="wardrobe3"},
        ring2={name="Stikini Ring +1", bag="wardrobe4"},
        back="Moonlight Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = {
        sub="Genmei Shield", --10/0
        range="Gjallarhorn",
        head="Inyanga Tiara +2", --0/5
        body="Inyanga Jubbah +2", --0/8
        hands="Inyan. Dastanas +2", --0/4
        legs="Inyanga Shalwar +2", --0/6
        feet="Inyan. Crackows +2", --0/3
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ear2="Etiolation Earring", --0/3
        ring1="Gelatinous Ring +1", --7/{-1}
        ring2="Defending Ring",  --10/10
        waist="Flume Belt +1", --4/0
        back="Moonlight Cape", --6/6
        }

    sets.idle.Town = set_combine(sets.idle, {
        main="Twashtar",
        sub="Genmei Shield",
        range="Gjallarhorn",
        head="Brioso Roundlet +2",
        body="Brioso Justau. +2",
        hands="Brioso Cuffs +2",
        legs="Brioso Cannions +2",
        neck="Mnbw. Whistle +1",
        ear1="Enchntr. Earring +1",
        ear2="Regal Earring",
        back=gear.BRD_Song_Cape,
        })
    
    sets.idle.Weak = sets.idle.DT
    
    
    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Fili Cothurnes +1"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    sets.engaged = {
        main="Twashtar",
        sub="Genmei Shield",
        range=gear.Linos_TP,
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Aya. Manopolas +2",
        legs="Aya. Cosciales +2",
        feet="Chironic Slippers",
        neck="Bard's Charm +1",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Ilabrat Ring",
        back=gear.BRD_TP_Cape,
        waist="Windbuffet Belt +1",
        }

	sets.engaged.Acc = set_combine(sets.engaged, {
        ear2="Mache Earring +1",
		ring2="Ramuh Ring +1",
        waist="Kentarch Belt +1",
        })

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW = {
        main="Aeneas",
        sub="Blurred Knife +1",
        range=gear.Linos_TP,
        head="Aya. Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Aya. Manopolas +2",
        legs="Aya. Cosciales +2",
        feet="Chironic Slippers",
        --neck="Bard's Charm +1",
        neck="Ainia Collar",
        ear1="Eabani Earring", --4
        ear2="Telos Earring",
        ring1={name="Chirich Ring +1", bag="wardrobe3"},
        ring2="Ilabrat Ring",
        back=gear.BRD_TP_Cape,
        waist="Reiki Yotai", --7
        }

    sets.engaged.DW.Acc = set_combine(sets.engaged.DW, {
        ear2="Mache Earring +1",
		ring2="Ramuh Ring +1",
        })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.SongDWDuration = {main=gear.Kali_Song, sub=gear.Kali_Idle}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1={name="Eshmun's Ring", bag="wardrobe3"}, --20
        ring2={name="Eshmun's Ring", bag="wardrobe4"}, --20
        waist="Gishdubar Sash", --10
        }

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --[[if spell.type == 'BardSong' then
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
    end]]
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

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BardSong' then
        --if state.SongMode.value == 'FullLength' then
        --    equip(sets.midcast.Daurdabla)
        --end

        --state.SongMode:reset()
        if state.CombatForm.current == 'DW' then
            equip(sets.SongDWDuration)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.english:contains('Lullaby') and not spell.interrupted then
        set_lullaby_timer(spell)
    end
end

function job_buff_change(buff,gain)

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

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'etude' then
        send_command('@input /ma '..state.Etude.value..' <stpc>')
    elseif cmdParams[1]:lower() == 'carol' then
        send_command('@input /ma '..state.Carol.value..' <stpc>')
    elseif cmdParams[1]:lower() == 'threnody' then
        send_command('@input /ma '..state.Threnody.value..' <stnpc>')
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end

    return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
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

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'SongEnfeebleAcc'
        else
            return 'SongEnfeeble'
        end
    elseif state.SongMode.value == 'Placeholder' then
        return 'SongPlaceholder'
    else
        return 'SongEnhancing'
    end
end

function set_lullaby_timer(spell)
    local self = windower.ffxi.get_player()

    local troubadour = false
    local clarioncall = false
    local soulvoice = false
    local marcato = false
 
    for i,v in pairs(self.buffs) do
        if v == 348 then troubadour = true end
        if v == 499 then clarioncall = true end
        if v == 52 then soulvoice = true end
        if v == 231 then marcato = true end
    end

    --User Lullaby duration enhancing gear total
    mult = 2.17

    if troubadour then
        mult = mult * 2
    end

    if spell.en == "Foe Lullaby II" or spell.en == "Horde Lullaby II" then 
        base = 60
    elseif spell.en == "Foe Lullaby" or spell.en == "Horde Lullaby" then 
        base = 30
    end

    totalDuration = math.floor(mult * base)
        
    -- Job Points Buff
    totalDuration = totalDuration + self.job_points.brd.lullaby_duration
    if troubadour then 
        totalDuration = totalDuration + self.job_points.brd.lullaby_duration
        -- adding it a second time if Troubadour up
    end

    if clarioncall then
        if troubadour then 
            totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2 * 2)
            -- Clarion Call gives 2 seconds per Job Point upgrade.  * 2 again for Troubadour
        else
            totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2)
            -- Clarion Call gives 2 seconds per Job Point upgrade. 
        end
    end
    
    if marcato and not soulvoice then
        totalDuration = totalDuration + self.job_points.brd.marcato_effect
    end

    -- Create the custom timer
    if spell.english == "Foe Lullaby II" or spell.english == "Horde Lullaby II" then
        send_command('@timers c "Lullaby II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00377.png')
    elseif spell.english == "Foe Lullaby" or spell.english == "Horde Lullaby" then
        send_command('@timers c "Lullaby ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00376.png')
    end
end

function update_combat_form()
    classes.CustomMeleeGroups:clear()
    if S{'NIN','DNC'}:contains(player.sub_job) then
        --if not (player.equipment.sub:contains('Shield') or player.equipment.sub == 'empty') then
            state.CombatForm:set('DW')
        else
            state.CombatForm:reset()
        --end
    end
end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 14)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end