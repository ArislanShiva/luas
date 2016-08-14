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
    state.Buff["Avatar's Favor"] = buffactive["Avatar's Favor"] or false
    state.Buff["Astral Conduit"] = buffactive["Astral Conduit"] or false

	spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
    avatars = S{"Carbuncle", "Fenrir", "Diabolos", "Ifrit", "Titan", "Leviathan", "Garuda", "Shiva", "Ramuh", "Odin", "Alexander", "Cait Sith", "Atomos"}

	blood_pacts = {}

	blood_pacts.bp_Boon =
	S{
		'Healing Ruby','Healing Ruby II','Soothing Ruby','Pacifying Ruby',
		'Aerial Armor','Whispering Wind',
		'Earthen Ward',
		'Spring Water',
		"Altana's Favor",'Raise II','Mewing Lullaby','Reraise II'
	}

	blood_pacts.bp_Buffs =
	S{
		'Shining Ruby','Glittering Ruby',
		'Frost Armor','Crystal Blessing',
		'Hastega','Fleet Wind','Hastega II',
		'Earthen Armor',
		'Rolling Thunder','Lightning Armor',
		'Soothing Current',
		'Crimson Howl','Inferno Howl',
		'Ecliptic Growl','Ecliptic Howl','Heavenward Howl',
		'Noctoshield','Dream Shroud'
	}

	blood_pacts.bp_Debuffs =
	S{
		'Sleepga','Diamond Storm',
		'Shock Squall',
		'Slowga','Tidal Roar',
		'Eerie Eye',
		'Lunar Cry','Lunar Roar',
		'Ultimate Terror','Pavor Nocturnus'
	}

	blood_pacts.bp_Physical =
	S{
		'Poison Nails',
		'Axe Kick','Double Slap','Rush',
		'Claw','Predator Claws',
		'Rock Throw','Rock Buster','Megalith Throw','Mountain Buster','Crag Throw',
		'Shock Strike','Chaotic Strike','Volt Strike',
		'Barracude Dive','Tail Whip','Spinning Dive',
		'Punch','Double Punch',
		'Regal Scratch','Regal Gash',
		'Moonlit Charge','Crescent Fang','Eclipse Bite',
		'Camisado','Blindside'
	}

	blood_pacts.bp_Magical =
	S{
		'Searing Light','Meteorite','Holy Mist',
		'Diamond Dust','Blizard II','Blizzard IV',
		'Aerial Blast','Aero II','Aero IV',
		'Earthen Fury','Stone II','Stone IV',
		'Judgment Bolt','Thunder II','Thunderspark','Thunder IV',
		'Tidal Wave','Water II','Water IV',
		'Inferno','Fire II','Fire IV','Meteor Strike','Conflag Strike',
		'Level ? Holy',
		'Howling Moon','Lunar Bay',
		'Ruinous Omen','Somnolence','Nightmare','Nether Blast','Night Terror'
	}

	blood_pacts.bp_Merit =
	S{
		'Heavenly Strike','Wind Blade','Geocrush','Thunderstorm','Grand Fall',
		'Impact'
	}

	blood_pacts.bp_Hybrid =
	S{
		'Burning Strike','Flaming Crush'
	}

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal', 'Favor')
    state.IdleMode:options('Normal', 'Movement', 'PDT', 'MDT')
	state.PhysicalDefenseMode:options('PDT', 'MDT')

    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()

	--------------------------------------
    -- Precast Sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Elemental Siphon'] =
	{
		main="Espiritus", sub="Vox Grip", ammo="Esper Stone +1",
        head="Convoker's Horn +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Smn. Earring",
        body="Beck. Doublet +1", hands="Lamassu Mitts +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Conveyance Cape", waist="Kobo Obi", legs="Beck. Spats +1",feet="Beck. Pigaches +1"
	}

    sets.precast.JA['Mana Cede'] =
	{
		hands="Beck. Bracers +1"
	}

	sets.precast.JA['Astral Conduit'] =
	{
		head="Beckoner's Horn +1", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Evans Earring",
		body="Beck. Doublet +1", hands="Beck. Bracers +1", lring="Lebeche Ring", rring="Mephitas's Ring +1",
		back="Conveyance Cape", waist="Luminary Sash", legs="Amalric Slops", feet="Apogee Pumps"
	}


    -- Pact delay reduction gear
    sets.precast.BloodPactWard =
	{
		main="Espiritus", sub="Vox Grip", ammo="Sancus Sachet",
		head="Convoker's Horn +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Evans Earring",
		body="Apogee Dalmatica", hands="Glyphic Bracers +1", lring="Lebeche Ring", rring="Mephitas's Ring +1",
		back="Conveyance Cape", waist="Kobo Obi", legs="Beck. Spats +1", feet="Glyph. Pigaches +1"
	}

    sets.precast.BloodPactRage = sets.precast.BloodPactWard

	sets.precast.JA['Convert'] =
	{
		head="Vanya Hood", neck="Sanctity Necklace", lear="Etiolation Earring", rear="Mendi. Earring",
		body="Inyanga Jubbah +1", hands="Telchine Gloves", lring="Lebeche Ring", rring="Evoker's Ring",
		back="Conveyance Cape", waist="Luminary Sash", legs="Gyve Trousers", feet="Inyan. Crackows +1"
	}


    -- Fast cast sets for spells

	sets.precast.FC =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Vanya Hood", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
        body="Inyanga Jubbah +1", hands="Telchine Gloves", lring="Evanescence Ring", rring="Prolix Ring",
        back="Swith Cape +1", waist="Witful Belt", legs="Psycloth Lappas", feet="Amalric Nails"
	}

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC,
	{
		waist="Siegel Sash"
	})

	sets.precast.FC['Enfeebling Magic'] = set_combine(sets.precast.FC,
	{
		waist="Channeler's Stone"
	})

	sets.precast.FC['Elemental Magic'] = sets.precast.FC['Enfeebling Magic']

	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC,
	{
		head="Umuthi Hat",
		hands="Carapacho Cuffs",
		waist="Siegel Sash"
	})

	sets.precast.FC['Healing Magic'] = sets.precast.FC['Enfeebling Magic']

	sets.precast.FC.StatusRemoval = sets.precast.FC['Enfeebling Magic']

	sets.precast.FC.Cures = set_combine(sets.precast.FC,
	{
		rear="Mendi. Earring",
		waist="Channeler's Stone", feet="Vanya Clogs"
	})

	sets.precast.FC.Curaga = sets.precast.FC.Cures

	sets.precast.FC.Teleport = sets.precast.FC

	sets.precast.FC.Reraise = sets.precast.FC

	sets.precast.FC.Raise = sets.precast.FC

	sets.precast.FC.Statless = sets.precast.FC

	sets.precast.FC.Impact = set_combine(sets.precast.FC,
	{
		head=empty,
		body="Twilight Cloak",
		waist="Channeler's Stone"
	})

	sets.precast.WS['Myrkr'] = set_combine(sets.precast.JA['Astral Conduit'],
	{
		rear="Moonshade Earring"
	})

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Avatar pact sets.  All pacts are Ability type.



	sets.midcast.Pet.bp_Boon =
	{
		main="Espiritus", sub="Vox Grip", ammo="Esper Stone +1",
        head="Beckoner's Horn +1", neck="Consumm. Torque", lear="Andoaa Earring", rear="Gifted Earring",
        body="Beck. Doublet +1", hands="Beck. Bracers +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Conveyance Cape", waist="Lucidity Sash", legs="Beck. Spats +1",feet="Beck. Pigaches +1"
	}

	sets.midcast.Pet.bp_Buffs =
	{
		main="Espiritus", sub="Vox Grip", ammo="Esper Stone +1",
        head="Beckoner's Horn +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Smn. Earring",
        body="Beck. Doublet +1", hands="Lamassu Mitts +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Conveyance Cape", waist="Kobo Obi", legs="Beck. Spats +1",feet="Apogee Pumps"
	}

    sets.midcast.Pet.bp_Debuffs =
	{
		main="Espiritus", sub="Vox Grip", ammo="Sancus Sachet",
        head="Convoker's Horn +1", neck="Incanter's Torque", lear="Andoaa Earring", rear="Smn. Earring",
        body="Beck. Doublet +1", hands="Lamassu Mitts +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Conveyance Cape", waist="Incarnation Sash", legs="Beck. Spats +1",feet="Apogee Pumps"
	}

    sets.midcast.Pet.bp_Physical =
	{
		main=gear.Grioavolr_Pet, sub="Elan Strap", ammo="Sancus Sachet",
        head="Apogee Crown", neck="Empath Necklace", lear="Esper Earring", rear="Gelos Earring",
        body="Con. Doublet +1", hands="Merlinic Dastanas", lring="Varar Ring", rring="Varar Ring",
        back="Campestres's Cape", waist="Incarnation Sash", legs="Apogee Slacks", feet="Apogee Pumps"
	}

    sets.midcast.Pet.bp_Magical =
	{
		main=gear.Grioavolr_Pet, sub="Elan Strap", ammo="Sancus Sachet",
        head=gear.PetHood, neck="Deino Collar", lear="Esper Earring", rear="Gelos Earring",
        body="Apogee Dalmatica", hands="Merlinic Dastanas", lring="Varar Ring", rring="Speaker's Ring",
        back="Campestres's Cape", waist="Incarnation Sash", legs="Helios Spats", feet=gear.PetCrackows
	}

	   sets.midcast.Pet.bp_Merit =
	{
		main=gear.Grioavolr_Pet, sub="Elan Strap", ammo="Sancus Sachet",
        head=gear.PetHood, neck="Deino Collar", lear="Esper Earring", rear="Gelos Earring",
        body="Apogee Dalmatica", hands="Merlinic Dastanas", lring="Varar Ring", rring="Speaker's Ring",
        back="Campestres's Cape", waist="Incarnation Sash", legs="Enticer's Pants", feet=gear.PetCrackows
	}

    sets.midcast.Pet.bp_Hybrid =
	{
		main=gear.Grioavolr_Pet, sub="Elan Strap", ammo="Sancus Sachet",
        head=gear.PetHood, neck="Deino Collar", lear="Esper Earring", rear="Gelos Earring",
        body="Apogee Dalmatica", hands="Merlinic Dastanas", lring="Varar Ring", rring="Varar Ring",
        back="Campestres's Cape", waist="Incarnation Sash", legs="Apogee Slacks", feet=gear.PetCrackows
	}


----- Spell casts.


	sets.midcast.FC = sets.precast.FC

	sets.midcast.ConserveMP = set_combine(sets.midcast.FC,
	{
		neck="Incanter's Torque", lear="Gifted Earring", rear="Mendi. Earring",
		body="Amalric Doublet",
		back="Fi Follet Cape +1", waist="Luminary Sash", legs="Lengo Pants", feet=gear.PetCrackows
	})

	-- Cure sets

	sets.midcast.Cures =
	{
		head="Vanya Hood", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Amalric Doublet", hands="Telchine Gloves", lring="Lebeche Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Gishdubar Sash", legs="Gyve Trousers", feet="Vanya Clogs"
	}
	sets.midcast.Curaga = sets.midcast.Cures

	sets.midcast.StatusRemoval = sets.midcast.FC

	sets.midcast.Cursna = set_combine(sets.precast.FC,
	{
		neck="Debilis Medallion",
        hands="Hieros Mittens", lring="Haoma's Ring", rring="Haoma's Ring",
        back="Oretan. Cape +1", feet="Vanya Clogs"
	})

	sets.midcast['Healing Magic'] = sets.precast.FC['Healing Magic']

	sets.midcast.Duration =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Orunmila's Torque", lear="Etiolation Earring", rear="Loquac. Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Stikini Ring", rring="Stikini Ring",
		back="Swith Cape +1", waist="Luminary Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Stoneskin =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Telchine Cap", neck="Stone Gorget", lear="Andoaa Earring", rear="Earthcry Earring",
		body="Telchine Chas.", hands="Telchine Gloves", lring="Evanescence Ring", rring="Prolix Ring",
		back="Fi Follet Cape +1", waist="Olympus Sash", legs="Shedir Seraweels", feet="Telchine Pigaches"
	}

	sets.midcast.Aquaveil = set_combine(sets.midcast.Duration,
	{
		head="Amalric Coif", waist="Emphatikos Rope", legs="Shedir Seraweels"
	})

	sets.midcast['Enhancing Magic'] =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Befouled Crown", neck="Incanter's Torque", lear="Andoaa Earring", rear="Augment. Earring",
		body="Telchine Chas.", hands="Inyan. Dastanas +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Fi Follet Cape +1", waist="Olympus Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'],
	{
		legs="Shedir Seraweels"
	})

	sets.midcast.BarStatus = sets.midcast.BarElement

	sets.midcast.Regen =
	{
		main=gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Inyanga Tiara +1", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Lebeche Ring", rring="Prolix Ring",
        back="Swith Cape +1", waist="Luminary Sash", legs="Telchine Braconi", feet="Telchine Pigaches"
	}

	sets.midcast.Refresh =
	{
		gear.Grioavolr_Enh, sub="Clerisy Strap",
		head="Amalric Coif", neck="Orunmila's Torque", lear="Gifted Earring", rear="Mendi. Earring",
        body="Telchine Chas.", hands="Telchine Gloves", lring="Lebeche Ring", rring="Prolix Ring",
        back="Grapevine Cape", waist="Gishdubar Sash", legs="Telchine Braconi", feet="Inspirited Boots"
	}

	sets.midcast.Statless = sets.midcast.Duration

	sets.midcast.Storm = sets.midcast.Duration

	sets.midcast.Protectra = set_combine(sets.midcast.Duration,
	{
		lring="Sheltered Ring"
	})

	sets.midcast.Protect = sets.midcast.Protectra

	sets.midcast.Shellra = sets.midcast.Protectra

	sets.midcast.Shell = sets.midcast.Protectra

	sets.midcast.Teleport = sets.midcast.ConserveMP

	sets.midcast.Reraise = sets.midcast.ConserveMP

	sets.midcast.Raise = sets.midcast.ConserveMP

	sets.midcast.Macc =
	{
		main=gear.Grioavolr_Enf, sub="Mephitis Grip",
		head="Befouled Crown", neck="Incanter's Torque", lear="Digni. Earring", rear="Gwati Earring",
		body="Vanya Robe", hands="Inyan. Dastanas +1", lring="Stikini Ring", rring="Stikini Ring",
		back="Aurist's Cape +1", waist="Luminary Sash", legs="Merlinic Shalwar", feet="Medium's Sabots"
	}

	sets.midcast['Dark Magic'] = set_combine(sets.midcast.Macc,
	{
		sub="Clerisy Strap",
		head="Pixie Hairpin +1",
		body="Psycloth Vest", lring="Archon Ring", rring="Stikini Ring",
		waist="Fucho-no-Obi", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	})


	sets.midcast.Sap = set_combine(sets.midcast['Dark Magic'],
	{
		lring="Evanescence Ring", rring="Archon Ring"
	})

	sets.midcast['Elemental Magic'] =
	{
		main=gear.Grioavolr_Enf, sub="Niobid Strap", ammo="Pemphredo Tathlum",
		head=gear.NukeHood, neck="Sanctity Necklace", lear="Friomisi Earring", rear="Hecate's Earring",
		body="Merlinic Jubbah", hands="Amalric Gages", lring="Acumen Ring", rring="Shiva Ring",
		back="Seshaw Cape", waist="Eschan Stone", legs="Merlinic Shalwar", feet=gear.NukeCrackows
	}

	sets.midcast['Elemental Magic'].Impact = set_combine(sets.midcast['Elemental Magic'],
	{
		head=empty,
		body="Twilight Cloak", lring="Archon Ring",
	})

	sets.midcast.Utsusemi = sets.midcast.FC

    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------


	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
	sets.idle =
	{
		main="Gridarvor",sub="Mensch Strap", ammo="Staunch Tathlum",
		head="Beckoner's Horn +1", neck="Sanctity Necklace", lear="Dawn Earring", rear="Infused Earring",
		body="Shomonjijoe +1", hands="Asteria Mitts +1", lring="Sheltered Ring", rring="Paguroidea Ring",
        back="Shadow Mantle", waist="Fucho-no-Obi", legs="Assid. Pants +1", feet="Serpentes Sabots"
	}

	sets.idle.Movement = set_combine(sets.idle,
    {
        feet="Crier's Gaiters"
    })

	sets.idle.PDT = set_combine(sets.idle,
	{
		neck="Twilight Torque",
        body="Vrikodara Jupon", lring="Defending Ring", rring="Vocane Ring",
        feet="Battlecast Gaiters"
	})

	sets.idle.MDT = set_combine(sets.idle,
	{
		sub="Irenic Strap",
		neck="Twilight Torque", lear="Etiolation Earring", rear="Static Earring",
        lring="Defending Ring", rring="Vocane Ring",
        back="Solemnity Cape", waist="Lieutenant's Sash", feet="Inyan. Crackows +1"
	})

	sets.idle.Town = set_combine(sets.idle,
	{
		body="Councilor's Garb",
		feet="Crier's Gaiters"
	})

	sets.idle.Weak = sets.idle.MDT

	-- Defense sets

	sets.defense.PDT = set_combine(sets.idle.PDT,
	{
		legs="Artsieq Hose"
	})

	sets.defense.MDT = set_combine(sets.idle.MDT,
	{
		main=gear.Grioavolr_Enf, sub="Irenic Strap",
		head="Inyanga Tiara +1",
        body="Inyanga Jubbah +1", hands="Inyan. Dastanas +1",
        legs="Inyanga Shalwar +1"
	})

	sets.Kiting = {feet="Crier's Gaiters"}

    -- Can make due without either the head or the body, and use +refresh items in those slots.

    sets.idle.Avatar =
	{
		main="Gridarvor",sub="Mensch Strap", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Empath Necklace", lear="Domes. Earring",rear="Evans Earring",
        body="Apogee Dalmatica", hands="Glyphic Bracers +1", lring="Speaker's Ring", rring="Evoker's Ring",
        back="Campestres's Cape", waist="Klouskap Sash", legs="Enticer's Pants", feet="Apogee Pumps"
	}

    sets.idle.Movement.Avatar = set_combine(sets.idle.Avatar,
    {
        hands="Asteria Mitts +1",
        waist="Lucidity Sash", legs="Assid. Pants +1", feet="Crier's Gaiters"
    })

	sets.idle.Avatar.Favor =
	{
		main="Gridarvor",sub="Vox Grip", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Caller's Pendant", lear="Domes. Earring",rear="Evans Earring",
        body="Shomonjijoe +1", hands="Glyphic Bracers +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Campestres's Cape", waist="Klouskap Sash", legs="Assid. Pants +1", feet="Apogee Pumps"
	}

    sets.idle.PDT.Avatar =
	{
		main="Gridarvor",sub="Mensch Strap", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Caller's Pendant", ear1="Handler's Earring +1", ear2="Handler's Earring",
        body="Shomonjijoe +1", hands="Glyphic Bracers +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Campestres's Cape", waist="Isa Belt", legs="Enticer's Pants", feet="Apogee Pumps"
	}

	sets.idle.MDT.Avatar =
	{
		main="Gridarvor", sub="Irenic Strap", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Caller's Pendant", ear1="Handler's Earring +1", ear2="Handler's Earring",
        body="Shomonjijoe +1", hands="Glyphic Bracers +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Campestres's Cape", waist="Isa Belt", legs="Enticer's Pants", feet="Apogee Pumps"
	}

    sets.idle.Spirit =
	{
		main="Espiritus",sub="Mensch Strap", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Caller's Pendant", ear1="Andoaa Earring",ear2="Smn. Earring",
        body="Shomonjijoe +1", hands="Glyphic Bracers +1", ring1="Stikini Ring", ring2="Evoker's Ring",
        back="Campestres's Cape", waist="Lucidity Sash", legs="Assid. Pants +1", feet="Glyph. Pigaches +1"
	}

    sets.perp = {}

    sets.perp.Alexander = sets.midcast.Pet.Debuffs

	sets.perp.Odin = sets.midcast.Pet.Debuffs

	sets.perp.Carbuncle =
	{
		hands="Asteria Mitts +1"
	}

	sets.perp.CaitSith =
	{
		hands="Lamassu Mitts +1"
	}

    --------------------------------------
    -- Engaged sets
    --------------------------------------

	sets.engaged =
	{
		main="Gridarvor",sub="Mensch Strap", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Empath Necklace", lear="Domes. Earring",rear="Evans Earring",
        body="Apogee Dalmatica", hands="Glyphic Bracers +1", lring="Speaker's Ring", rring="Evoker's Ring",
        back="Campestres's Cape", waist="Klouskap Sash", legs="Enticer's Pants", feet="Apogee Pumps"
	}

	sets.engaged.Favor =
	{
		main="Gridarvor",sub="Vox Grip", ammo="Sancus Sachet",
        head="Beckoner's Horn +1", neck="Caller's Pendant", lear="Domes. Earring",rear="Evans Earring",
        body="Shomonjijoe +1", hands="Glyphic Bracers +1", lring="Stikini Ring", rring="Evoker's Ring",
        back="Campestres's Cape", waist="Klouskap Sash", legs="Assid. Pants +1", feet="Apogee Pumps"
	}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.Buff['Astral Conduit'] and pet_midaction() then
        eventArgs.handled = true
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    elseif storms:contains(buff) then
        handle_equipping_gear(player.status)
    end
end

-- Called when the player's pet's status changes.
-- This is also called after pet_change after a pet is released.  Check for pet validity.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if pet.isvalid and not midaction() and not pet_midaction() and (newStatus == 'Engaged' or oldStatus == 'Engaged') then
        handle_equipping_gear(player.status, newStatus)
    end
end


function job_get_spell_map(spell, default_spell_map)
    if (spell.type == 'BloodPactRage' or spell.type == 'BloodPactWard') then
        for category,spell_list in pairs(blood_pacts) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end


-- Called when a player gains or loses a pet.
-- pet == pet structure
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(petparam, gain)
    classes.CustomIdleGroups:clear()
    if gain then
        if avatars:contains(pet.name)  then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function pet_midcast(spell)
	if (spell.type == 'BloodPactRage' or spell.type == 'BloodPactWard') then
		if bp_Boon:contains(spell.name) then
			equip(sets.midcast.Pet.Boon)
		elseif bp_Buffs:contains(spell.name) then
			equip(sets.midcast.Pet.Buffs)
		elseif bp_Debuffs:contains(spell.name) then
			equip(sets.midcast.Pet.Debuffs)
		elseif bp_Physical:contains(spell.name) then
			equip(sets.midcast.Pet.Physical)
		elseif bp_Magical:contains(spell.name) then
			equip(sets.midcast.Pet.Magical)
		elseif bp_Hybrid:contains(spell.name) then
			equip(sets.midcast.Pet.Hybrid)
		end
	end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if pet.isvalid then
        if sets.perp[pet.name] then
            idleSet = set_combine(idleSet, sets.perp[pet.name])
        end
		if pet.name == 'Cait Sith' then
			idleSet = set_combine(idleSet, sets.perp.CaitSith)
		end
        if state.Buff["Avatar's Favor"] and avatars:contains(pet.name) then
            idleSet = set_combine(idleSet, sets.idle.Avatar.Favor)
        end
    end

    return idleSet
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        if avatars:contains(pet.name) then
            classes.CustomIdleGroups:append('Avatar')
        elseif spirits:contains(pet.name) then
            classes.CustomIdleGroups:append('Spirit')
        end
    end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book(reset)
    if reset == 'reset' then
        -- lost pet, or tried to use pact when pet is gone
    end

    -- Default macro set/book
    set_macro_page(1, 7)
end
