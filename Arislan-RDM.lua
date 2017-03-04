-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:
		
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Auto. Lockstyle		Automatically locks desired equipset on file load
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

	state.CP = M(false, "Capacity Points Mode")
	state.Buff.Saboteur = buffactive.saboteur or false
	
	enfeebling_magic_acc = S{'Bind', 'Break', 'Dispel', 'Distract', 'Distract II', 'Frazzle',
		'Frazzle II',  'Gravity', 'Gravity II', 'Silence', 'Sleep', 'Sleep II', 'Sleepga'}
	enfeebling_magic_skill = S{'Dia', 'Dia II', 'Dia III', 'Diaga', 'Distract III', 'Frazzle III'}

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
	send_command('bind ^` input /ja Composure <me>')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind ^- gs c scholar light')
	send_command('bind ^= gs c scholar dark')
	send_command('bind !- gs c scholar addendum')
	send_command('bind != gs c scholar addendum')
	send_command('bind ^; gs c scholar speed')
	send_command('bind !q input /ma "Temper" <me>')
	send_command('bind !w input /ma "Flurry II" <stpc>')
	send_command('bind !e input /ma "Haste II" <stpc>')
	send_command('bind !r input /ma "Refresh II" <stpc>')
	send_command('bind !o input /ma "Regen II" <stpc>')
	send_command('bind !p input /ma "Shock Spikes" <me>')
	send_command('bind ![ gs c scholar aoe')
	send_command('bind !; gs c scholar cost')
	send_command('bind ^, input /ma Sneak <stpc>')
	send_command('bind ^. input /ma Invisible <stpc>')
	send_command('bind @c gs c toggle CP')
	send_command('bind @h gs c cycle HelixMode')
	send_command('bind @w gs c toggle WeaponLock')

	update_offense_mode()	
	select_default_macro_book()
	set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind !-')
	send_command('unbind !=')
	send_command('unbind ^;')
	send_command('unbind !q')
	send_command('unbind !w')
	send_command('bind !e input /ma "Haste" <stpc>')
	send_command('bind !r input /ma "Refresh" <stpc>')
	send_command('unbind !o')
	send_command('unbind !p')
	send_command('unbind ![')
	send_command('unbind !;')
	send_command('unbind ^,')
	send_command('unbind !.')
	send_command('unbind @c')
	send_command('unbind @h')
	send_command('unbind @w')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	
	------------------------------------------------------------------------------------------------
	---------------------------------------- Precast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	-- Precast sets to enhance JAs
	sets.precast.JA['Chainspell'] = {body="Viti. Tabard +1"}
	
	-- Fast cast sets for spells
	
	-- Fast cast sets for spells
	sets.precast.FC = {
	--	Traits --30
		main="Oranyan", --7
		sub="Clerisy Strap +1", --3
		ammo="Sapience Orb", --2
		head="Carmine Mask +1", --14
		hands="Leyline Gloves", --7
		legs="Psycloth Lappas", --7
		feet="Carmine Greaves +1", --8
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Etiolation Earring", --1
		ring1="Kishar Ring", --4
		ring2="Weather. Ring", --5
		back="Swith Cape +1", --4
		waist="Witful Belt", --3/(3)
		}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC['Enhancing Magic'], {legs="Doyen Pants"})

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		ammo="Impatiens",
		legs="Doyen Pants", --15
		ear1="Mendi. Earring", --5
		ring1="Lebeche Ring", --(2)
		back="Perimede Cape", --(4)
		})

	sets.precast.FC.Curaga = sets.precast.FC.Cure
	sets.precast.FC['Healing Magic'] = sets.precast.FC.Cure
	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {waist="Channeler's Stone"})
	sets.precast.FC.Impact = {head=empty, body="Twilight Cloak"}
	sets.precast.Storm = set_combine(sets.precast.FC, {ring2="Levia. Ring +1", waist="Channeler's Stone"}) -- stop quick cast

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		ammo="Impatiens",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		back="Perimede Cape",
		waist="Ninurta's Sash",
		})


	------------------------------------------------------------------------------------------------
	------------------------------------- Weapon Skill Sets ----------------------------------------
	------------------------------------------------------------------------------------------------

	sets.precast.WS = {
		ammo="Floestone",
		head="Jhakri Coronal +1",
		body="Jhakri Robe +1",
		hands="Jhakri Cuffs +1",
		legs="Carmine Cuisses +1",
		feet="Jhakri Pigaches +1",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Bleating Mantle",
		waist="Fotia Belt",
		}

	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
		ammo="Yetshila",
		body="Ayanmo Corazza +1",
		feet="Thereoid Greaves",
		ear2="Brutal Earring",
		ring1="Begrudging Ring",
		ring2="Hetairoi Ring",
		})

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		neck="Caro Necklace",
		ring1="Rufescent Ring",
		ring2="Shukuyu Ring",
		waist="Prosilio Belt +1",
		})

	sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {
		ammo="Quartz Tathlum +1",
		ring1="Rufescent Ring",
		ring2="Shukuyu Ring",
		})

	sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Merlinic Jubbah",
		hands="Amalric Gages",
		legs=gear.Merlinic_MB_legs,
		feet="Merlinic Crackows",
		neck="Baetyl Pendant",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Archon Ring",
		back=gear.RDM_INT_Cape,
		waist="Refoccilation Stone",
		}

	------------------------------------------------------------------------------------------------
	---------------------------------------- Midcast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		ammo="Impatiens", --10
		legs="Carmine Cuisses +1", --20
		ear1="Halasz Earring", --5
		ring1="Evanescence Ring", --5
		waist="Rumination Sash", --10
		}

	sets.midcast.Cure = {
		main="Tamaxchi", --22/(-10)
		sub="Culminus",
		ammo="Esper Stone +1", --0/(-5)
		head="Gende. Caubeen +1", --15/(-8)
		body="Kaykaus Bliaut", --5(+3)
		hands="Kaykaus Cuffs", --10/(-6)
		legs="Kaykaus Tights", --10/(-5)
		feet="Kaykaus Boots", --10/(-10)
		neck="Incanter's Torque",
		ear1="Mendi. Earring", --5
		ear2="Roundel Earring", --5
		ring1="Lebeche Ring", --3/(-5)
		ring2="Haoma's Ring",
		back=gear.RDM_MND_Cape, --10
		waist="Bishop's Sash",
		}

	sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
		main="Chatoyant Staff",
		sub="Clerisy Strap +1",
		hands="Kaykaus Cuffs", --10/(-6)
		back="Twilight Cape",
		waist="Hachirin-no-Obi",
		})

	sets.midcast.CureSelf = set_combine(sets.midcast.Cure, {
		hands="Buremte Gloves", -- (13)
		neck="Phalaina Locket", -- 4(4)
		ring2="Asklepian Ring", -- (3)
		waist="Gishdubar Sash", -- (10)
		})

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		waist="Luminary Sash",
		})

	sets.midcast.StatusRemoval = {
		main="Tamaxchi",
		sub="Sors Shield",
		head="Vanya Hood",
		legs="Atrophy Tights +1",
		feet="Vanya Clogs",
		neck="Incanter's Torque",
		ring1="Haoma's Ring",
		ring2="Haoma's Ring",
		back=gear.RDM_MND_Cape,
		waist="Bishop's Sash",
		}
		
	sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
		feet="Vanya Clogs",
		neck="Malison Medallion",
		ear1="Beatific Earring",
		back="Oretan. Cape +1",
		})

	sets.midcast['Enhancing Magic'] = {
		main="Oranyan",
		sub="Enki Strap",
		head="Befouled Crown",
		body="Viti. Tabard +1",
		hands="Atrophy Gloves +1",
		legs="Atrophy Tights +1",
		feet="Leth. Houseaux +1",
		neck="Incanter's Torque",
		ear2="Andoaa Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Ghostfyre Cape",
		waist="Olympus Sash",
		}
	
	sets.midcast.EnhancingDuration = {
		main="Oranyan",
		sub="Enki Strap",
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Atrophy Gloves +1",
		legs="Telchine Braconi",
		feet="Leth. Houseaux +1",
		back=gear.RDM_MND_Cape,
		}

	sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
		main="Bolelabunga",
		sub="Beatific Shield +1",
		})

	sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {
		head="Amalric Coif",
		legs="Leth. Fuseau +1",
		waist="Gishdubar Sash",
		back="Grapevine Cape",
		})

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Nodens Gorget",
		waist="Siegel Sash",
		})

	sets.midcast['Phalanx'] = set_combine(sets.midcast['Enhancing Magic'], {
		body=gear.Taeon_FC_body,
		feet=gear.Taeon_PH_feet
		})
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
		head="Amalric Coif",
		waist="Emphatikos Rope",
		})

	sets.midcast.Storm = sets.midcast.EnhancingDuration

	sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
		ring2="Sheltered Ring",
		})

	sets.midcast.Protectra = sets.midcast.Protect
	sets.midcast.Shell = sets.midcast.Protect
	sets.midcast.Shellra = sets.midcast.Shell

 	-- Custom spell classes
	sets.midcast.MndEnfeebles = {
		main=gear.Grioavolr_MND,
		sub="Enki Strap",
		ammo="Quartz Tathlum +1",
		head="Carmine Mask +1",
		body="Lethargy Sayon +1",
		hands="Kaykaus Cuffs",
		legs="Chironic Hose",
		feet="Medium's Sabots",
		neck="Imbodla Necklace",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Kishar Ring",
		ring2="Globidonta Ring",
		back=gear.RDM_MND_Cape,
		waist="Luminary Sash",
		}

	sets.midcast.MndEnfeeblesAcc = set_combine(sets.midcast.MndEnfeebles, {
		ammo="Pemphredo Tathlum",
		body="Vanya Robe",
		neck="Sanctity Necklace",
		ring2="Weather. Ring",
		})
	
	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		main=gear.Grioavolr_MB,
		ammo="Pemphredo Tathlum",
		back=gear.RDM_INT_Cape,
		})

	sets.midcast.IntEnfeeblesAcc = set_combine(sets.midcast.IntEnfeebles, {
		ammo="Pemphredo Tathlum",
		body="Vanya Robe",
		neck="Sanctity Necklace",
		ring2="Weather. Ring",
		})

	sets.midcast.SkillEnfeebles = {
		sub="Mephitis Grip",
		head="Befouled Crown",
		neck="Incanter's Torque",
		ring1="Stikini Ring",
		waist="Rumination Sash",
		}

	sets.midcast.ElementalEnfeeble = sets.midcast.IntEnfeebles

	sets.midcast['Dia III'] = set_combine(sets.midcast.SkillEnfeebles, {head="Viti. Chapeau +1"})
	sets.midcast['Paralyze II'] = set_combine(sets.midcast.MndEnfeebles, {head="Vitivation Boots +1"})
	sets.midcast['Slow II'] = set_combine(sets.midcast.MndEnfeebles, {head="Viti. Chapeau +1"})

	sets.midcast['Dark Magic'] = {
		main=gear.Grioavolr_MB,
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head="Amalric Coif",
		body="Shango Robe",
		hands="Jhakri Cuffs +1",
		legs=gear.Merlinic_MAcc_legs,
		feet="Merlinic Crackows",
		neck="Incanter's Torque",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back=gear.RDM_INT_Cape,
		waist="Casso Sash",
		}

	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Pixie Hairpin +1",
		feet="Merlinic Crackows",
		ear2="Hirudinea Earring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		})
	
	sets.midcast.Aspir = sets.midcast.Drain
	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {waist="Luminary Sash"})

	sets.midcast['Elemental Magic'] = {
		main=gear.Grioavolr_MB,
		sub="Niobid Strap",
		ammo="Pemphredo Tathlum",
		head="Merlinic Hood",
		body="Merlinic Jubbah",
		hands="Amalric Gages",
		legs=gear.Merlinic_MB_legs,
		feet="Merlinic Crackows",
		neck="Baetyl Pendant",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.RDM_INT_Cape,
		waist="Refoccilation Stone",
		}

	sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
		main=gear.Grioavolr_MB,
		sub="Enki Strap",
		body="Seidr Cotehardie",
		legs=gear.Merlinic_MAcc_legs,
		neck="Sanctity Necklace",
		})

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		main=gear.Grioavolr_MB,
		sub="Enki Strap",
		legs=gear.Merlinic_MAcc_legs,
		neck="Sanctity Necklace",
		ear2="Hermetic Earring",
		waist="Yamabuki-no-Obi",
		})
		
	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
		main=gear.Grioavolr_MB,
		sub="Niobid Strap",
		head=empty,
		body="Twilight Cloak",
		ring1="Archon Ring",
		})
	
	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

	-- Initializes trusts at iLvl 119
	sets.midcast.Trust = sets.precast.FC
		
	-- Job-specific buff sets
	sets.buff.ComposureOther = {
		head="Leth. Chappel +1",
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs="Leth. Fuseau +1",
		feet="Leth. Houseaux +1",
		}

	sets.buff.Saboteur = {hands="Leth. Gantherots +1"}

	
	------------------------------------------------------------------------------------------------
	----------------------------------------- Idle Sets --------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.idle = {
		main="Bolelabunga",
		sub="Beatific Shield +1",
		ammo="Homiliary",
		head="Viti. Chapeau +1",
		body="Witching Robe",
		hands="Gende. Gages +1",
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt +1",
		}

	sets.idle.DT = set_combine(sets.idle, {
		main="Mafic Cudgel", --10/0
		sub="Beatific Shield +1", --4/29
		ammo="Staunch Tathlum", --2/2
		head="Gende. Caubeen +1", --4/4
		body="Emet Harness +1", --6/0
		hands="Gende. Gages +1", --4/3
 		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Solemnity Cape", --4/4
		waist="Flume Belt +1", --4/0
		})

	sets.idle.Town = set_combine(sets.idle, {
		body="Lethargy Sayon +1",
		hands="Leth. Gantherots +1",
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		ear1="Hermetic Earring",
		ear2="Digni. Earring",
		ring1="Levia. Ring +1",
		ring2="Shiva Ring +1",
		back=gear.RDM_INT_Cape,
		waist="Flume Belt +1",
		})

	sets.idle.Weak = sets.idle.DT

	sets.resting = set_combine(sets.idle, {
		main="Chatoyant Staff",
		waist="Shinjutsu-no-Obi +1",
		})
	
	------------------------------------------------------------------------------------------------
	---------------------------------------- Defense Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT	

	sets.magic_burst = { 
		main=gear.Grioavolr_MB, --5
		body="Merlinic Jubbah", --10
		hands="Amalric Gages", --(5)
		legs=gear.Merlinic_MB_legs, --6
		feet="Merlinic Crackows", --11
		neck="Mizu. Kubikazari", --10
		ring1="Mujin Band", --(5)
		}

	sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.latent_refresh = {waist="Fucho-no-obi"}


	------------------------------------------------------------------------------------------------
	---------------------------------------- Engaged Sets ------------------------------------------
	------------------------------------------------------------------------------------------------
	
	sets.engaged = {
		main="Colada",
		sub="Deliverance +1",
		ammo="Ginsen",
		head="Carmine Mask +1",
		body="Ayanmo Corazza +1",
		hands="Chironic Gloves",
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		neck="Anu Torque",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		ring2="Hetairoi Ring",
		back="Letalis Mantle",
		waist="Kentarch Belt +1",
		}

	sets.engaged.Acc = sets.engaged

	sets.engaged.DW = set_combine(sets.engaged, {
		--NIN --25
		sub="Blurred Knife +1",
		feet=gear.Taeon_DW_feet, --9
		})

	sets.engaged.DW.Acc = sets.engaged.DW


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

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Enfeebling Magic' then
		if enfeebling_magic_skill:contains(spell.english) then
			equip(sets.midcast.SkillEnfeebles)
		end
		if state.Buff.Saboteur then
			equip(sets.buff.Saboteur)
		end
	elseif spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	elseif spell.skill == 'Enhancing Magic' and spell.target.type == 'PLAYER' then
		if buffactive.composure then
			equip(sets.buff.ComposureOther)
		end
	elseif spellMap == 'Cure' and spell.target.type == 'SELF' then
		equip(sets.midcast.CureSelf)
	elseif spell.skill == 'Elemental Magic' then
		if state.MagicBurst.value and spell.english ~= 'Death' then
			equip(sets.magic_burst)
			if spell.english == "Impact" then
				equip(sets.midcast.Impact)
			end
		end
		if (spell.element == world.day_element or spell.element == world.weather_element) then
			equip(sets.Obi)
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)

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

-- Called for direct player commands.
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'scholar' then
		handle_strategems(cmdParams)
		eventArgs.handled = true
	elseif cmdParams[1]:lower() == 'nuke' then
		handle_nuking(cmdParams)
		eventArgs.handled = true
	end
end

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
			if (world.weather_element == 'Light' or world.day_element == 'Light') then
				return 'CureWeather'
			end
		end
		if spell.skill == 'Enfeebling Magic' then
			if spell.type == "WhiteMagic" and not enfeebling_magic_skill:contains(spell.english) then
				if enfeebling_magic_acc:contains(spell.english) then
					return "MndEnfeeblesAcc"
				else
					return "MndEnfeebles"
				end
			elseif spell.type == "BlackMagic" and not enfeebling_magic_skill:contains(spell.english) then
				if enfeebling_magic_acc:contains(spell.english) then
					return "IntEnfeeblesAcc"
				else
					return "IntEnfeebles"
				end
			else
				return "MndEnfeebles"
			end 
		end
	end
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
	update_offense_mode()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	if player.mpp < 51 then
		idleSet = set_combine(idleSet, sets.latent_refresh)
 	elseif state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end
	
	return idleSet
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	display_current_caster_state()
	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- General handling of strategems in an Arts-agnostic way.
-- Format: gs c scholar <strategem>
function handle_strategems(cmdParams)
	-- cmdParams[1] == 'scholar'
	-- cmdParams[2] == strategem to use

	if not cmdParams[2] then
		add_to_chat(123,'Error: No strategem command given.')
		return
	end
	local strategem = cmdParams[2]:lower()

	if strategem == 'light' then
		if buffactive['light arts'] then
			send_command('input /ja "Addendum: White" <me>')
		elseif buffactive['addendum: white'] then
			add_to_chat(122,'Error: Addendum: White is already active.')
		else
			send_command('input /ja "Light Arts" <me>')
		end
	elseif strategem == 'dark' then
		if buffactive['dark arts'] then
			send_command('input /ja "Addendum: Black" <me>')
		elseif buffactive['addendum: black'] then
			add_to_chat(122,'Error: Addendum: Black is already active.')
		else
			send_command('input /ja "Dark Arts" <me>')
		end
	elseif buffactive['light arts'] or buffactive['addendum: white'] then
		if strategem == 'cost' then
			send_command('input /ja Penury <me>')
		elseif strategem == 'speed' then
			send_command('input /ja Celerity <me>')
		elseif strategem == 'aoe' then
			send_command('input /ja Accession <me>')
		elseif strategem == 'addendum' then
			send_command('input /ja "Addendum: White" <me>')
		else
			add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
		end
	elseif buffactive['dark arts']  or buffactive['addendum: black'] then
		if strategem == 'cost' then
			send_command('input /ja Parsimony <me>')
		elseif strategem == 'speed' then
			send_command('input /ja Alacrity <me>')
		elseif strategem == 'aoe' then
			send_command('input /ja Manifestation <me>')
		elseif strategem == 'addendum' then
			send_command('input /ja "Addendum: Black" <me>')
		else
			add_to_chat(123,'Error: Unknown strategem ['..strategem..']')
		end
	else
		add_to_chat(123,'No arts has been activated yet.')
	end
end

function update_offense_mode()  
	if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
		state.CombatForm:set('DW')
	else
		state.CombatForm:reset()
	end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	set_macro_page(1, 13)
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 14')
end
