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
--              [ WIN+A ]           AttackMode: Capped/Uncapped WS Modifier
--              [ WIN+C ]           Toggle Capacity Points Mode
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

-- Setup vars that are user-independent.
function job_setup()

    wyv_breath_spells = S{'Dia', 'Poison', 'Blaze Spikes', 'Protect', 'Sprout Smack', 'Head Butt', 'Cocoon',
	    'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
    wyv_elem_breath = S{'Flame Breath', 'Frost Breath', 'Sand Breath', 'Hydro Breath', 'Gust Breath', 'Lightning Breath'}

    lockstyleset = 4

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'MaxAcc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'DT')
    state.IdleMode:options('Normal', 'DT')

    state.AttackMode = M{['description']='Attack', 'Capped', 'Uncapped'}
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    include('Global-Binds.lua') -- OK to remove this line
    include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('bind ^` input /ja "Call Wyvern" <me>')
    send_command('bind !` input /ja "Spirit Link" <me>')
    send_command('bind @` input /ja "Dismiss" <me>')
    send_command('bind @a gs c cycle AttackMode')
    send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind !w input /ja "Defender" <me>')
	elseif player.sub_job == 'SAM' then
        send_command('bind !w input /ja "Hasso" <me>')
    end

    send_command('bind @w gs c toggle WeaponLock')
    send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>')
    end

    send_command('bind ^numpad7 input /ws "Camlann\'s Torment" <t>')
    send_command('bind ^numpad8 input /ws "Drakesbane" <t>')
    send_command('bind ^numpad4 input /ws "Stardiver" <t>')
    send_command('bind ^numpad5 input /ws "Geirskogul" <t>')
    send_command('bind ^numpad1 input /ws "Sonic Thrust" <t>')
    send_command('bind ^numpad2 input /ws "Leg Sweep" <t>')

    send_command('bind numpad0 input /ja "Jump" <t>')
    send_command('bind numpad. input /ja "High Jump" <t>')
    send_command('bind ^numpad0 input /ja "Spirit Jump" <t>')
    send_command('bind ^numpad. input /ja "Soul Jump" <t>')
    send_command('bind ^numpadenter input /ja "Super Jump" <t>')

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind @`')
    send_command('unbind @a')
    send_command('unbind @c')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad8')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')
    send_command('unbind numpad0')
    send_command('unbind numpad.')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')
    send_command('unbind ^numpadenter')

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

    sets.precast.JA['Spirit Surge'] = {body="Ptero. Mail +1"}
    sets.precast.JA['Call Wyvern'] = {body="Ptero. Mail +1"}
    sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +3"}

    sets.precast.JA['Spirit Link'] = {
        head="Vishap Armet +3",
        hands="Pel. Vambraces +1",
        feet="Ptero. Greaves +1",
        ear1="Pratik Earring",
        }

    sets.precast.JA['Steady Wing'] = {
        legs="Vishap Brais +3",
		feet="Ptero. Greaves +1",
        neck="Chanoix's Gorget",
        ear1="Lancer's Earring",
        ear2="Anastasi Earring",
        back="Updraft Mantle",
        }

    sets.precast.JA['Jump'] = {
        ammo="Ginsen",
        head="Flam. Zucchetto +2",
        body="Vishap Mail +3",
        hands="Vis. Fng. Gaunt. +3",
        legs="Ptero. Brais +3",
        feet="Ostro Greaves",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        ring1="Chirich Ring +1",
        ring2="Niqmaddu Ring",
        back=gear.DRG_JMP_Cape,
        waist="Ioskeha Belt +1",
        }

    sets.precast.JA['High Jump'] = sets.precast.JA['Jump']
    sets.precast.JA['Spirit Jump'] = sets.precast.JA['Jump']
    sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA['Jump'], {hands="Emi. Gauntlets +1", legs=gear.Valo_STP_legs})
    sets.precast.JA['Super Jump'] = {}

    sets.precast.JA['Angon'] = {ammo="Angon", hands="Ptero. Fin. G. +3"}

    -- Fast cast sets for spells
    sets.precast.FC = {
        ammo="Sapience Orb", --2
        head="Carmine Mask +1", --14
        body=gear.Taeon_FC_body, --8
        hands="Leyline Gloves", --8
        legs="Aya. Cosciales +2", --6
        feet="Carmine Greaves +1", --8
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring2="Weather. Ring +1", --6(4)
        }

    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        ammo="Knobkierrie",
        head=gear.Valo_WSD_head,
        body=gear.Valo_WSD_body,
        hands="Ptero. Fin. G. +3",
        legs="Vishap Brais +3",
        feet="Sulev. Leggings +2",
        neck="Fotia Gorget",
        ear1="Sherida Earring",
        ear2="Moonshade Earring",
        ring1="Regal Ring",
        ring2="Niqmaddu Ring",
        back=gear.DRG_WS2_Cape,
        waist="Fotia Belt",
        }

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

	sets.precast.WS.Uncapped = set_combine(sets.precast.WS, {
        head="Sulevia's Mask +2",
        legs=gear.Valo_WSD_legs,
        })

    sets.precast.WS['Camlann\'s Torment'] = set_combine(sets.precast.WS, {
        head="Lustratio Cap +1",
		ear2="Ishvara Earring",
        })

    sets.precast.WS['Camlann\'s Torment'].Acc = set_combine(sets.precast.WS['Camlann\'s Torment'], {})

	sets.precast.WS['Camlann\'s Torment'].Uncapped = set_combine(sets.precast.WS['Camlann\'s Torment'], {
        legs=gear.Valo_WSD_legs,
        })

    sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {
        head="Flam. Zucchetto +2", 
        hands="Flamma Manopolas +2",
        legs="Pelt. Cuissots +1",
        ear2="Brutal Earring",
        ring1="Begrudging Ring",
        back=gear.DRG_WS1_Cape,
        waist="Ioskeha Belt +1",
        })

    sets.precast.WS['Drakesbane'].Acc = set_combine(sets.precast.WS['Drakesbane'], {})

	sets.precast.WS['Drakesbane'].Uncapped = set_combine(sets.precast.WS['Drakesbane'], {
        head="Sulevia's Mask +2",
        legs=gear.Valo_WSD_legs,
        })

    sets.precast.WS['Geirskogul'] = set_combine(sets.precast.WS, {
        head="Lustratio Cap +1",
        legs="Lustr. Subligar +1",
        ear2="Mache Earring +1",
        back=gear.DRG_WS3_Cape,
        })

    sets.precast.WS['Geirskogul'].Acc = set_combine(sets.precast.WS['Geirskogul'], {})

	sets.precast.WS['Geirskogul'].Uncapped = set_combine(sets.precast.WS['Geirskogul'], {
        head="Sulevia's Mask +2", 
        legs=gear.Valo_WSD_legs,
        })

    sets.precast.WS['Sonic Thrust'] = sets.precast.WS['Camlann\'s Torment']
    sets.precast.WS['Sonic Thrust'].Acc = sets.precast.WS['Camlann\'s Torment'].Acc
    sets.precast.WS['Sonic Thrust'].Uncapped = sets.precast.WS['Camlann\'s Torment'].Uncapped

    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
        head="Flam. Zucchetto +2", 
        body=gear.Valo_TP_body,
        hands="Sulev. Gauntlets +2",
        legs="Sulev. Cuisses +2",
        feet="Flam. Gambieras +2",
        back=gear.DRG_WS1_Cape,
        })

    sets.precast.WS['Stardiver'].Acc = set_combine(sets.precast.WS['Stardiver'], {
        head="Ptero. Armet +3",
        feet="Vishap Greaves +3",
        })

	sets.precast.WS['Stardiver'].Uncapped = set_combine(sets.precast.WS['Stardiver'], {
        head="Ptero. Armet +3",
        legs="Sulev. Cuisses +2",
        })

    sets.precast.WS['Raiden Thrust'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        hands="Carmine Fin. Ga. +1",
        ear1="Hermetic Earring",
        ear2="Friomisi Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back="Argocham. Mantle",
        })

    sets.precast.WS['Thunder Thrust'] = sets.precast.WS['Raiden Thrust']
	
    sets.precast.WS['Leg Sweep'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Flam. Zucchetto +2",
		body="Flamma Korazin +2",
		hands="Flam. Manopolas +2",
        legs="Flamma Dirs +2",
		feet="Flam. Gambieras +2",
		ear1="Digni. Earring",
		ring1="Stikini Ring +1",
		ring2="Weather. Ring +1",
        })

    sets.WSDayBonus = {head="Gavialis Helm"}

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.HealingBreath = {
        head="Ptero. Armet +3",
        body=gear.Acro_Pet_body,
        hands=gear.Acro_Pet_hands,
        legs="Vishap Brais +3",
        feet="Ptero. Greaves +1",
        neck="Lancer's Torque",
		ear1="Lancer's Earring",
		ear2="Anastasi Earring",
		back="Updraft Mantle",
        waist="Glassblower's Belt",
        }

    sets.midcast.ElementalBreath = {
        head="Ptero. Armet +3",
        body=gear.Acro_Pet_body,
        hands=gear.Acro_Pet_hands,
        neck="Lancer's Torque",
		back="Updraft Mantle",
        waist="Glassblower's Belt",
        }

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.idle = {
        ammo="Staunch Tathlum +1", --3/3
        head="Volte Cap",
        body="Sulevia's Plate. +2", --9/9
        hands="Sulev. Gauntlets +2", --5/5
        legs="Carmine Cuisses +1",
        feet="Volte Boots",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Chirich Ring +1",
        ring2="Chirich Ring +1",
        back="Moonlight Cape", --6/6
        waist="Flume Belt +1", --4/0
        }

    sets.idle.DT = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1", --3/3
        body="Sulevia's Plate. +2", --9/9
        head="Sulevia's Mask +2", --6/6
        hands="Sulev. Gauntlets +2", --5/5
        neck="Loricate Torque +1", --6/6
        ear1="Eabani Earring",
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
        })

    sets.idle.Pet = set_combine(sets.idle, {
        body="Vishap Mail +3",
        hands="Ptero. Fin. G. +3",
        feet="Ptero. Greaves +1",
        ear1="Enmerkar Earring",
        ear2="Anastasi Earring",
        waist="Isa Belt",
        })

    sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
        head="Sulevia's Mask +2", --6/6
        body="Emicho Haubert +1",
        legs="Ptero. Brais +3",
        neck="Loricate Torque +1", --6/6
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
        back="Moonlight Cape", --6/6
        })

    sets.idle.Town = set_combine(sets.idle, {
        ammo="Staunch Tathlum +1",
        head="Ptero. Armet +3",
        body="Emicho Haubert +1",
        hands="Ptero. Fin. G. +3",
        feet="Vishap Greaves +3",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Telos Earring",
        back=gear.DRG_TP_Cape,
        waist="Ioskeha Belt +1",
        })

    sets.idle.Weak = sets.idle.DT
    sets.Kiting = {legs="Carmine Cuisses +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged = {
        ammo="Focal Orb",
        head="Flam. Zucchetto +2",
        body=gear.Valo_TP_body,
        hands="Sulev. Gauntlets +2",
        legs=gear.Valo_TP_legs,
        feet="Flam. Gambieras +2",
        neck="Anu Torque",
        ear1="Sherida Earring",
        ear2="Brutal Earring",
        ring1="Chirich Ring +1",
        ring2="Niqmaddu Ring",
        back=gear.DRG_TP_Cape,
        waist="Ioskeha Belt +1",
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        ammo="Amar Cluster",
        neck="Combatant's Torque",
        ear2="Cessance Earring",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ammo="Ginsen",
        neck="Shulmanu Collar",
        ring1="Flamma Ring",
		ear2="Telos Earring",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        ammo="Amar Cluster",
        body="Emicho Haubert +1",
        hands="Emi. Gauntlets +1",
        legs=gear.Valo_STP_legs,
        ring1="Regal Ring",
        })

    sets.engaged.MaxAcc = set_combine(sets.engaged.HighAcc, {
        body="Vishap Mail +3",
        head="Vishap Armet +3",
        legs="Ptero. Brais +3",
        feet="Vishap Greaves +3",
        ear2="Mache Earring +1",
        ring1="Flamma Ring",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        ammo="Ginsen",
        hands=gear.Acro_STP_hands,
        legs=gear.Valo_STP_legs,
        ear2="Telos Earring",
        back=gear.DRG_JMP_Cape,
        })


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
        ammo="Staunch Tathlum +1", --3/3
        neck="Loricate Torque +1", --6/6
        body="Vishap Mail +3",
        ring1="Moonlight Ring", --5/5
        ring2="Defending Ring", --10/10
        }

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Eshmun's Ring", --20
        ring2="Eshmun's Ring", --20
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.name == 'Hasso' and not spell.interrupted then
        send_command('wait 285;input /echo Hasso wearing off soon!;')
    end
end

function job_precast(spell, action, spellMap, eventArgs)
    -- Wyvern Commands
    if spell.name == 'Dismiss' and pet.hpp < 100 then		
		eventArgs.cancel = true
		add_to_chat(50, 'Cancelling Dismiss! ' ..pet.name.. ' is below full HP! [ ' ..pet.hpp.. '% ]')
    elseif wyv_breath_spells:contains(spell.english) or (spell.skill == 'Ninjutsu' and player.hpp < 33) then
        equip(sets.precast.HealingBreath)
    end

    -- Jump Overrides
    --if pet.isvalid and player.main_job_level >= 77 and spell.name == "Jump" then
    --    eventArgs.cancel = true
    --    send_command('@input /ja "Spirit Jump" <t>')
    --end

    --if pet.isvalid and player.main_job_level >= 85 and spell.name == "High Jump" then
    --    eventArgs.cancel = true
    --    send_command('@input /ja "Soul Jump" <t>')
    --end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' and state.WeaponskillMode.current == 'Normal' then
        if spell.english == 'Sonic Thrust' then
            if world.day_element == 'Earth' or world.day_element == 'Light' then
                equip(sets.WSDayBonus)
            end
		elseif spell.english == 'Stardiver' then
            if world.day_element == 'Earth' or world.day_element == 'Light' or world.day_element == 'Dark' then
                equip(sets.WSDayBonus)
           end
        end
    end
end

function job_pet_midcast(spell, action, spellMap, eventArgs)
    if spell.name:startswith('Healing Breath') or spell.name == 'Restoring Breath' then
        equip(sets.midcast.HealingBreath)
    elseif wyv_elem_breath:contains(spell.english) then
        equip(sets.midcast.ElementalBreath)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

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

    if state.Kiting.value then
        msg = msg .. '[ Kiting Mode ]'
    end

    add_to_chat(060, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

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
    --if player.sub_job == 'SAM' then
        set_macro_page(1, 8)
    --else
        --set_macro_page(2, 8)
    --end
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
end
