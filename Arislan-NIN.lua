-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:

        Haste Detection        Detects current magic haste level and equips corresponding engaged set to
                            optimize delay reduction (automatic)
        Haste Mode            Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
        Capacity Pts. Mode    Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle        Automatically locks specified equipset on file load
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
    state.Buff.Migawari = buffactive.migawari or false
    state.Buff.Doom = buffactive.doom or false
    state.Buff.Yonin = buffactive.Yonin or false
    state.Buff.Innin = buffactive.Innin or false
    state.Buff.Futae = buffactive.Futae or false

    state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}

    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    state.CP = M(false, "Capacity Points Mode")
    state.TH = M(false, "Treasure Hunter Mode")

    -- Additional local binds
    send_command('bind ^- input /ja "Yonin" <me>')
    send_command('bind ^= input /ja "Innin" <me>')
    if player.sub_job == 'DNC' then
        send_command('bind ^, input /ja "Spectral Jig" <me>')
        send_command('unbind ^.')
    else
        send_command('bind ^, input /nin "Monomi: Ichi" <me>')
        send_command('bind ^. input /ma "Tonko: Ni" <me>')
    end
    send_command('bind ^, input /nin "Monomi: Ichi" <me>')
    send_command('bind ^. input /ma "Tonko: Ni" <me>')
    send_command('bind @h gs c cycle HasteMode')
    send_command('bind @c gs c toggle CP')
    send_command('bind @t gs c toggle TH')

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

    select_movement_feet()
    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind @h')
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
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
--    sets.precast.JA['Mijin Gakure'] = {legs="Mochizuki Hakama"}
--    sets.precast.JA['Futae'] = {legs="Iga Tekko +2"}
--    sets.precast.JA['Sange'] = {legs="Mochizuki Chainmail"}

    sets.precast.Waltz = {
        body="Passion Jacket",
        legs="Dashing Subligar",
        neck="Phalaina Locket",
        ring1="Asklepian Ring",
        ring2="Valseur's Ring",
        waist="Gishdubar Sash",
        }
        
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
        ammo="Sapience Orb", --2
        head=gear.Herc_MAB_head, --7
        body=gear.Taeon_FC_body, --8
        hands="Leyline Gloves", --7
        legs="Rawhide Trousers", --5
        feet=gear.Herc_MAB_feet, --2
        neck="Orunmila's Torque", --5
        ear1="Loquacious Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        ring2="Weather. Ring +1", --6(4)
        }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
        ammo="Staunch Tathlum",
        body="Passion Jacket",
        neck="Magoraga Beads",
        ring1="Lebeche Ring",
        })

    sets.precast.RA = {
        head=gear.Taeon_RA_head, --10/0
        body=gear.Taeon_RA_body, --9/0
        legs="Adhemar Kecks", --9/0
        }
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Seeth. Bomblet +1",
        head="Lilitu Headpiece",
        body="Adhemar Jacket",
        hands=gear.Adhemar_TP_hands,
        legs="Hiza. Hizayoroi +1",
        feet=gear.Herc_TA_feet,
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Ishvara Earring",
        ring1="Ifrit Ring +1",
        ring2="Shukuyu Ring",
        back="Bleating Mantle",
        waist="Fotia Belt",
        } -- default set

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
        head=gear.Adhemar_TP_head,
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_Acc_feet,
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        back="Letalis Mantle",
        })

    sets.precast.WS['Blade: Hi'] = set_combine (sets.precast.WS, {
        ammo="Yetshila",
        ear1="Lugra Earring",
        ear2="Lugra Earring +1",
        ring1="Begrudging Ring",
        ring2="Epona's Ring",
        waist="Windbuffet Belt +1",
        })

    sets.precast.WS['Blade: Ten'] = set_combine (sets.precast.WS, {
        neck="Caro Necklace",
        ear2="Lugra Earring +1",
        ring2="Ilabrat Ring",
        waist="Grunfeld Rope",
        })

    sets.precast.WS['Blade: Shun'] = set_combine (sets.precast.WS, {
        legs="Samnuha Tights",
        ear1="Lugra Earring",
        ear2="Lugra Earring +1",
        ring1="Ramuh Ring +1",
        ring2="Ilabrat Ring",
        })

    sets.precast.WS['Blade: Kamu'] = set_combine (sets.precast.WS, {
        ear1="Lugra Earring",
        ear2="Lugra Earring +1",
        ring2="Ilabrat Ring",
        })

    sets.precast.WS['Blade: Yu'] = set_combine (sets.precast.WS, {
        ammo="Seeth. Bomblet +1",
        head=gear.Herc_MAB_head,
        body="Samnuha Coat",
        hands="Leyline Gloves",
        legs=gear.Herc_MAB_legs,
        feet=gear.Herc_MAB_feet,
        neck="Baetyl Pendant",
        ear1="Moonshade Earring",
        ear2="Friomisi Earring",
        ring1="Shiva Ring +1",
        ring2="Shiva Ring +1",
        back="Argocham. Mantle",
        waist="Eschan Stone",
        })


    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        ring1="Evanescence Ring", --5
        }
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    sets.midcast.ElementalNinjutsu = {
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
        }

--    sets.midcast.ElementalNinjutsu.Resistant = set_combine(sets.midcast.Ninjutsu, {})

--    sets.midcast.NinjutsuDebuff = {}

--    sets.midcast.NinjutsuBuff = {}

--    sets.midcast.RA = {}

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
    
    -- Resting sets
--    sets.resting = {}
    
    -- Idle sets
    sets.idle = {
        ammo="Ginsen",
        head="Dampening Tam",
        body="Hiza. Haramaki +1",
        hands=gear.Herc_DT_hands,
        legs="Samnuha Tights",
        feet="Danzo Sune-ate",
        neck="Bathy Choker +1",
        ear1="Genmei Earring",
        ear2="Infused Earring",
        ring1="Paguroidea Ring",
        ring2="Sheltered Ring",
        back="Moonbeam Cape",
        waist="Flume Belt +1",
        }

    sets.idle.DT = set_combine (sets.idle, {
        ammo="Staunch Tathlum", --2/2
        head=gear.Herc_DT_head, --3/3
        hands=gear.Herc_DT_hands, --6/4
        feet="Amm Greaves", --3/3
        neck="Loricate Torque +1", --6/6
        ear1="Genmei Earring", --2/0
        ring1="Gelatinous Ring +1", --7/(-1)
        ring2="Defending Ring", --10/10
        back="Moonbeam Cape", --5/5
        waist="Flume Belt +1", --4/0
        })

    sets.idle.Town = set_combine(sets.idle, {
        neck="Combatant's Torque",
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        back="Letalis Mantle",
        waist="Windbuffet Belt +1",
        })
    
    sets.idle.Weak = sets.idle.DT
    
    -- Defense sets
    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Danzo sune-ate"}
    
    sets.DayMovement = {feet="Danzo sune-ate"}
    sets.NightMovement = {feet="Hachi. Kyahan +1"}


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
        ammo="Ginsen",
        head="Dampening Tam",
        body="Adhemar Jacket", --5
        hands="Floral Gauntlets", --5
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back="Bleating Mantle",
        waist="Reiki Yotai", --7
        } -- 35%

    sets.engaged.LowAcc = set_combine(sets.engaged, {
        ammo="Falcon Eye",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
        ring2="Ilabrat Ring",
        back="Letalis Mantle",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_Acc_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP = set_combine(sets.engaged, {
        ring1="Petrov Ring",
        })

    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.LowHaste = {
        ammo="Ginsen",
        head="Dampening Tam",
        body="Adhemar Jacket", --5
        hands="Floral Gauntlets", --5
        legs="Samnuha Tights",
        feet=gear.Taeon_DW_feet, --9
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back="Bleating Mantle",
        waist="Reiki Yotai", --7
        } -- 35%

    sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
        ammo="Falcon Eye",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
        feet=gear.Herc_TA_feet,
        ring2="Ilabrat Ring",
        back="Letalis Mantle",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_Acc_feet,
        ear1="Cessance Earring",
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
        ring1="Petrov Ring",
        })

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.MidHaste = {
        ammo="Ginsen",
        head="Dampening Tam",
        body="Adhemar Jacket", --5
        hands=gear.Adhemar_TP_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back="Bleating Mantle",
        waist="Reiki Yotai", --7
        } -- 21%

    sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
        ammo="Falcon Eye",
        neck="Combatant's Torque",
        })

    sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
        feet=gear.Herc_TA_feet,
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        back="Letalis Mantle",
        waist="Kentarch Belt +1",
        })

    sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidHaste.MidAcc, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_Acc_feet,
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
        ring1="Petrov Ring",
        })

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.HighHaste = {
        ammo="Ginsen",
        head="Dampening Tam",
        body="Adhemar Jacket", --5
        hands=gear.Adhemar_TP_hands,
        legs="Samnuha Tights",
        feet=gear.Herc_TA_feet,
        neck="Erudit. Necklace",
        ear1="Eabani Earring", --4
        ear2="Suppanomimi", --5
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back="Bleating Mantle",
        waist="Windbuffet Belt +1",
        } -- 14% Gear

    sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
        neck="Combatant's Torque",
        waist="Kentarch Belt +1",
        })

    sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
        ammo="Falcon Eye",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        back="Letalis Mantle",
        })

    sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_Acc_feet,
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
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
        neck="Erudit. Necklace",
        ear1="Cessance Earring",
        ear2="Brutal Earring",
        ring1="Hetairoi Ring",
        ring2="Epona's Ring",
        back="Bleating Mantle",
        waist="Windbuffet Belt +1",
        } -- 0%

    sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        neck="Combatant's Torque",
        waist="Kentarch Belt +1",
        })

    sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
        ammo="Falcon Eye",
        ear1="Cessance Earring",
        ring2="Ilabrat Ring",
        back="Letalis Mantle",
        })

    sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
        legs=gear.Herc_WS_legs,
        feet=gear.Herc_Acc_feet,
        ear2="Telos Earring",
        ring1="Ramuh Ring +1",
        ring2="Ramuh Ring +1",
        waist="Olseni Belt",
        })

    sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
        neck="Ainia Collar",
        ear1="Dedition Earring",
        ear2="Telos Earring",
        ring1="Petrov Ring",
        waist="Kentarch Belt +1",
        })

    sets.engaged.Hybrid = {
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

--    sets.buff.Migawari = {body="Iga Ningi +2"}
    sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}
--    sets.buff.Yonin = {}
--    sets.buff.Innin = {}

    sets.CP = {back="Mecisto. Mantle"}
    sets.TH = {waist="Chaac Belt"}
    sets.Reive = {neck="Ygnas's Resolve +1"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
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
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
        determine_haste_group()
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

--function job_status_change(new_status, old_status)
    if new_status == 'Idle' then
        select_movement_feet()
    end
--end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
                return 'NinjutsuDebuff'
            end
        end
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
    if state.TH.current == 'on' then
        equip(sets.TH)
        disable('waist')
    else
        enable('waist')
    end

    idleSet = set_combine(idleSet, select_movement_feet())

    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    select_movement_feet()
    determine_haste_group()
end

-- Function to display the current relevant user state when doing an update.
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
    
    msg = msg .. ' ]'
    
    add_to_chat(060, msg)

    eventArgs.handled = true
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
    -- Victory March +0/+3/+4/+5    9.4%/14%/15.6%/17.1%
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


function select_movement_feet()
    if world.time >= (17*60) or world.time <= (7*60) then
       return sets.NightMovement
    else
       return sets.DayMovement
    end
end


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
    send_command('wait 2; input /lockstyleset 6')
end