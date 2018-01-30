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

    -- Default Item HotKeys
    send_command('bind @numpad7 input /item "Remedy" <me>')
    send_command('bind @numpad8 input /item "Echo Drops" <me>')
    send_command('bind @numpad9 input /item "Eye Drops" <me>')
    send_command('bind @numpad4 input /item "Antidote" <me>')
    send_command('bind @numpad6 input /item "Remedy" <me>')
    send_command('bind @numpad1 input /item "Holy Water" <me>')

    -- Dual Box Key Binds (Requires Send and Shortcuts)
    send_command('bind #f1 input //send safiyeh /ta <p0>')
    send_command('bind #f2 input //send safiyeh /ta <p1>')
    send_command('bind #f3 input //send safiyeh /ta <p2>')
    send_command('bind #f4 input //send safiyeh /ta <p3>')
    send_command('bind #f5 input //send safiyeh /ta <p4>')
    send_command('bind #f6 input //send safiyeh /ta <p5>')
    send_command('bind #f7 input //send safiyeh /ta Arislan')
    send_command('bind #f8 input //send safiyeh /ta <bt>')

    send_command('bind #f9 input //send safiyeh //gs c cycle offensemode')
    send_command('bind #f10 input //send safiyeh //gs c cycle defensemode')
    send_command('bind #f11 input //send safiyeh //gs c cycle castingmode')
    send_command('bind #f12 input //send safiyeh //gs c cycle idlemode')

    send_command('bind #` input //send safiyeh /ja "Full Circle" <me>')

    send_command('bind #1 input //send safiyeh /ma "Geo-Frailty" <t>')
    send_command('bind #2 input //send safiyeh /ma "Indi-Fury" <t>')
    send_command('bind #3 input //send safiyeh /ma "Indi-Haste" <t>')
    send_command('bind #4 input //send safiyeh /ma "Indi-Refresh" <t>')
    send_command('bind #5 input //send safiyeh /ma "Geo-Malaise" <t>')
    send_command('bind #6 input //send safiyeh /ma "Indi-Acumen" <t>')

    send_command('bind #7 input //send safiyeh /ma "Dia II" <t>')
    send_command('bind #8 input //send safiyeh /ma "Silence" <t>')
    send_command('bind #9 input //send safiyeh /ma "Gravity" <t>')
    send_command('bind #0 input //send safiyeh /ma "Dispel" <t>')

    send_command('bind #q input //send safiyeh /ma "Stone V" <t>')
    send_command('bind #w input //send safiyeh /ma "Aspir II" <t>')
    send_command('bind #e input //send safiyeh /ma "Haste" <t>')
    send_command('bind #r input //send safiyeh /ma "Refresh" <t>')
    send_command('bind #t input //send safiyeh /ma "Blink" <me>')
    send_command('bind #y input //send safiyeh /ma "Phalanx" <me>')
    send_command('bind #u input //send safiyeh /ma "Stoneskin" <me>')
    send_command('bind #i input //send safiyeh /ma "Aquaveil" <me>')
    send_command('bind #o input //send safiyeh /ma "Cure IV" <t>')
    send_command('bind #p input //send safiyeh /ja "Entrust" <me>')

    send_command('bind #, input //send safiyeh /ma "Sneak" <t>')
    send_command('bind #. input //send safiyeh /ma "Invisible <t>')
    send_command('bind #b input //send safiyeh /ja "Blaze of Glory" <me>')
    send_command('bind #d input //send safiyeh /ja "Dematerialize" <me>')
    send_command('bind #l input //send safiyeh /ja "Life Cycle" <me>')
    send_command('bind #a input //send safiyeh /ja "Ecliptic Attrition" <me>')
    send_command('bind #s input //send safiyeh /ja "Lasting Emanation" <me>')

    send_command('bind #- input //send safiyeh /follow <t>')

    send_command('bind #numpad7 input //send safiyeh /ma "Paralyna" <t>')
    send_command('bind #numpad8 input //send safiyeh /ma "Silena" <t>')
    send_command('bind #numpad9 input //send safiyeh /ma "Blindna" <t>')
    send_command('bind #numpad4 input //send safiyeh /ma "Poisona" <t>')
    send_command('bind #numpad5 input //send safiyeh /ma "Stona" <t>')
    send_command('bind #numpad6 input //send safiyeh /ma "Viruna" <t>')
    send_command('bind #numpad1 input //send safiyeh /ma "Cursna" <t>')
    send_command('bind #numpad+ input //send safiyeh /ma "Erase" <t>')