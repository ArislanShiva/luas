-------------------------------------------------------------------------------------------------------------------
--  Global Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Spells:     [ ALT+, ]           Sneak/Spectral Jig/Silent Oil
--              [ ALT+. ]           Invisible/Prism Powder
--              [ ALT+Numpad7 ]     Paralyna
--              [ ALT+Numpad8 ]     Silena
--              [ ALT+Numpad9 ]     Blindna
--              [ ALT+Numpad4 ]     Poisona
--              [ ALT+Numpad5 ]     Stona
--              [ ALT+Numpad6 ]     Viruna
--              [ ALT+Numpad1 ]     Cursna
--              [ ALT+Numpad+ ]     Erase
--              [ ALT+Numpad0 ]     Sacrifice
--              [ ALT+Numpad. ]     Esuna
--
--  Items:      [ WIN+Numpad/ ]     Soldier's Drink
--              [ WIN+Numpad7 ]     Remedy
--              [ WIN+Numpad8 ]     Echo Drops
--              [ WIN+Numpad9 ]     Eye Drops
--              [ WIN+Numpad4 ]     Antidote
--              [ WIN+Numpad6 ]     Remedy
--              [ WIN+Numpad1 ]     Holy Water
--              [ WIN+Numpad0 ]     Catholican +1
--              [ WIN+Numpad. ]     Catholican
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------

    -- Default Spell HotKeys
    if player.main_job == 'DNC' or player.sub_job == 'DNC' then
        send_command('bind ^, input /ja "Spectral Jig" <me>')
        send_command('unbind ^.')
    elseif player.main_job == 'RDM' or player.sub_job == 'RDM'
        or player.main_job == 'SCH' or player.sub_job == 'SCH'
        or player.main_job == 'WHM' or player.sub_job == 'WHM' then
        send_command('bind ^, input /ma "Sneak" <stpc>')
        send_command('bind ^. input /ma "Invisible" <stpc>')
    else
        send_command('bind ^, input /item "Silent Oil" <me>')
        send_command('bind ^. input /item "Prism Powder" <me>')
    end

    send_command('bind @, input /ma "Utsusemi: Ichi" <me>')
    send_command('bind @. input /ma "Utsusemi: Ni" <me>')

    -- Default Enhancing HotKeys
    send_command('bind !e input /ma "Haste" <stpc>')
    send_command('bind !r input /ma "Refresh" <stpc>')
    send_command('bind !t input /ma "Blink" <me>')
    send_command('bind !y input /ma "Phalanx" <me>')
    send_command('bind !u input /ma "Stoneskin" <me>')
    send_command('bind !i input /ma "Aquaveil" <me>')
    send_command('bind !o input /ma "Cure IV" <stpc>')

    -- Default Status Cure HotKeys
    send_command('bind !numpad7 input /ma "Paralyna" <t>')
    send_command('bind !numpad8 input /ma "Silena" <t>')
    send_command('bind !numpad9 input /ma "Blindna" <t>')
    send_command('bind !numpad4 input /ma "Poisona" <t>')
    send_command('bind !numpad5 input /ma "Stona" <t>')
    send_command('bind !numpad6 input /ma "Viruna" <t>')
    send_command('bind !numpad1 input /ma "Cursna" <t>')
    send_command('bind !numpad+ input /ma "Erase" <t>')
    send_command('bind !numpad0 input /ma "Sacrifice" <t>')
    send_command('bind !numpad. input /ma "Esuna" <me>')

    -- Default Status Enfeebling HotKeys
    send_command('bind ~numpad7 input /ma "Paralyze" <t>')
    send_command('bind ~numpad8 input /ma "Silence" <t>')
    send_command('bind ~numpad9 input /ma "Blind" <t>')
    send_command('bind ~numpad4 input /ma "Poison" <t>')
    send_command('bind ~numpad5 input /ma "Slow" <t>')
    send_command('bind ~numpad6 input /ma "Addle" <t>')
    send_command('bind ~numpad1 input /ma "Distract" <t>')
    send_command('bind ~numpad2 input /ma "Frazzle" <t>')
    send_command('bind ~numpad0 input /ma "Dia II" <t>')

    -- Default Item HotKeys
    send_command('bind @numpad7 input /item "Remedy" <me>')
    send_command('bind @numpad8 input /item "Echo Drops" <me>')
    send_command('bind @numpad9 input /item "Eye Drops" <me>')
    send_command('bind @numpad4 input /item "Antidote" <me>')
    send_command('bind @numpad6 input /item "Remedy" <me>')
    send_command('bind @numpad1 input /item "Holy Water" <me>')

    -- Dual Box Key Binds (Requires Send and Shortcuts)
    send_command('bind #f1 input //send @others //setkey f1 down;wait 0.1;input //send @others //setkey f1 up')
    send_command('bind #f2 input //send @others //setkey f2 down;wait 0.1;input //send @others //setkey f2 up')
    send_command('bind #f3 input //send @others //setkey f3 down;wait 0.1;input //send @others //setkey f3 up')
    send_command('bind #f4 input //send @others //setkey f4 down;wait 0.1;input //send @others //setkey f4 up')
    send_command('bind #f5 input //send @others //setkey f5 down;wait 0.1;input //send @others //setkey f5 up')
    send_command('bind #f6 input //send @others //setkey f6 down;wait 0.1;input //send @others //setkey f6 up')
    send_command('bind #f7 input //send @others /follow <p1>')
    send_command('bind #f8 input //send @others /ta <bt>')

    send_command('bind #escape input //send @others //setkey escape down;wait 0.1;input //send @others //setkey escape up')
    send_command('bind #enter input //send @others //setkey enter down;wait 0.1;input //send @others //setkey enter up')
    send_command('bind #tab input //send @others //setkey tab down;wait 0.1;input //send @others //setkey tab up')

    send_command('bind #up down input //send @others //setkey up down')
    send_command('bind #up up input //send @others //setkey up up')
    send_command('bind #down down input //send @others //setkey down down')
    send_command('bind #down up input //send @others //setkey down up')
    send_command('bind #left down input //send @others //setkey left down')
    send_command('bind #left up input //send @others //setkey left up')
    send_command('bind #right down input //send @others //setkey right down')
    send_command('bind #right up input //send @others //setkey right up')

    send_command('bind #- input //send @others /follow <t>')
    send_command('bind #= input //send @others //setkey numpad7 down;wait 0.2;input //send @others //setkey numpad7 up')

    send_command('bind #f10 input //send @others //gs c cycle defensemode')
    send_command('bind #f11 input //send @others //gs c cycle castingmode')
    send_command('bind #f12 input //send @others //gs c cycle idlemode')
