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