-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:
		
		Magic Burst			Toggle Magic Burst Mode  [Alt-`]
		Haste Detection		Detects current magic haste level and equips corresponding engaged set to
							optimize delay reduction (automatic)
		Haste Mode			Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Reive Detection		Automatically equips Reive bonus gear
		Auto. Lockstyle		Automatically locks specified equipset on file load
--]]

--------------------------------------------------------------------------------------------------------------------
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
	state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
	state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
	state.Buff.Convergence = buffactive.Convergence or false
	state.Buff.Diffusion = buffactive.Diffusion or false
	state.Buff.Efflux = buffactive.Efflux or false
	
	state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
	blue_magic_maps = {}
	
	-- Mappings for gear sets to use for various blue magic spells.
	-- While Str isn't listed for each, it's generally assumed as being at least
	-- moderately signficant, even for spells with other mods.

	-- Physical spells with no particular (or known) stat mods
	blue_magic_maps.Physical = S{'Bilgestorm'}

	-- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
	blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

	-- Physical spells with Str stat mod
	blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
		'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
		'Uppercut','Vertical Cleave'}

	-- Physical spells with Dex stat mod
	blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
		'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
		'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

	-- Physical spells with Vit stat mod
	blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Delta Thrust','Glutinous Dart','Grand Slam',
		'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

	-- Physical spells with Agi stat mod
	blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
		'Pinecone Bomb','Spiral Spin','Wild Oats'}

	-- Physical spells with Int stat mod
	blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

	-- Physical spells with Mnd stat mod
	blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

	-- Physical spells with Chr stat mod
	blue_magic_maps.PhysicalChr = S{'Bludgeon'}

	-- Physical spells with HP stat mod
	blue_magic_maps.PhysicalHP = S{'Final Sting'}

	-- Magical spells with the typical Int mod
	blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
		'Droning Whirlwind','Embalming Earth','Entomb','Firespit','Foul Waters','Ice Break','Leafstorm',
		'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
		'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}
	
	blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
		'Tenebral Crush'}
		
	blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
		'Retinal Glare'}

	-- Magical spells with a primary Mnd mod
	blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

	-- Magical spells with a primary Chr mod
	blue_magic_maps.MagicalChr = S{'Mysterious Light'}

	-- Magical spells with a Vit stat mod (on top of Int)
	blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

	-- Magical spells with a Dex stat mod (on top of Int)
	blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

	-- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
	-- Add Int for damage where available, though.
	blue_magic_maps.MagicAccuracy = S{'1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
		'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
		'Cimicine Discharge','Cold Wave','Corrosive Ooze','Demoralizing Roar','Digest','Dream Flower',
		'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
		'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
		'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
		'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'}

	-- Breath-based spells
	blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
		'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

	-- Stun spells
	blue_magic_maps.Stun = S{'Blitzstrahl','Frypan','Head Butt','Sudden Lunge','Tail slap','Temporal Shift',
		'Thunderbolt','Whirl of Rage'}
	
	-- Healing spells
	blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
		'White Wind','Wild Carrot'}

	-- Buffs that depend on blue magic skill
	blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
		'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

	-- Other general buffs
	blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
		'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
		'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
		'Warm-Up','Winds of Promyvion','Zephyr Mantle'}
	
	blue_magic_maps.Refresh = S{'Battery Charge'}

	-- Spells that require Unbridled Learning to cast.
	unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
		'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
		'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}

		
	state.HasteMode = M{['description']='Haste Mode', 'Haste II', 'Haste I'}
	state.CP = M(false, "Capacity Points Mode")

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.HybridMode:options('Normal')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Resistant')
	state.PhysicalDefenseMode:options('PDT', 'MDT')
	state.IdleMode:options('Normal', 'DT', 'Learning')

	state.MagicBurst = M(false, 'Magic Burst')
	state.CP = M(false, "Capacity Points Mode")
	state.Logger = M(false, "Logger Addon")

	-- Additional local binds
	send_command('bind ^` input /ma "Blank Gaze" <t>')
	send_command('bind !` gs c toggle MagicBurst')
	send_command('bind ^- input /ja "Chain Affinity" <me>')
	send_command('bind ^[ input /ja "Efflux" <me>')
	send_command('bind ^= input /ja "Burst Affinity" <me>')
	send_command('bind ![ input /ja "Diffusion" <me>')
	send_command('bind !] input /ja "Unbridled Learning" <me>')
	send_command('bind !e input /ma "Erratic Flutter" <me>')
	send_command('bind !t input /ma "Occultation" <me>')

	if player.sub_job == "RDM"then	
		send_command('bind !q input /ma "Fantod" <me>')
		send_command('bind !w input /ma "Reactor Cool" <me>')
		send_command('bind !r input /ma "Refresh" <stpc>')
		send_command('bind !y input /ma "Phalanx" <me>')
		send_command('bind !u input /ma "Stoneskin" <me>')
		send_command('bind !p input /ma "Carcharian Verve" <me>')
	else
		send_command('bind !q input /ma "Nat. Meditation" <me>')
		send_command('bind !w input /ma "Cocoon" <me>')
		send_command('bind !r input /ma "Battery Charge" <me>')
		send_command('bind !y input /ma "Barrier Tusk" <me>')
		send_command('bind !u input /ma "Diamondhide" <me>')
		send_command('bind !p input /ma "Mighty Guard" <me>')
	end
	
	if player.sub_job == 'DNC' then
		send_command('bind ^, input /ja "Spectral Jig" <me>')
		send_command('unbind ^.')
	elseif player.sub_job == "RDM" then
		send_command('bind ^, input /ma "Sneak" <stpc>')
		send_command('bind ^. input /ma "Invisible" <stpc>')
	else
		send_command('bind ^, input /item "Silent Oil" <me>')
		send_command('bind ^. input /item "Prism Powder" <me>')
	end
	
	send_command('bind @c gs c toggle CP')
	send_command('bind @h gs c cycle HasteMode')
	
	select_default_macro_book()
	set_lockstyle()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind ^[')
	send_command('unbind ![')
	send_command('unbind !]')
	send_command('unbind !q')
	send_command('unbind !w')
	send_command('bind !e input /ma Haste <stpc>')
	send_command('bind !t input /ma Blink <me>')
	send_command('bind !r input /ma Refresh <stpc>')
	send_command('bind !y input /ma Phalanx <me>')
	send_command('bind !u input /ma Stoneskin <me>')
	send_command('unbind !p')
	send_command('unbind ^,')
	send_command('unbind @c')
	send_command('unbind @h')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

	-- Enmity set
	sets.Enmity = {
		ammo="Sapience Orb", --2
		head="Halitus Helm", --8
		body="Emet Harness +1", --10
		hands="Kurys Gloves", --9
		neck="Unmoving Collar +1", --10
		ear1="Cryptic Earring", --4
		ear2="Friomisi Earring", --2
		ring1="Supershear Ring", --5
		ring2="Eihwaz Ring", --5
		waist="Trance Belt", --4
		}

	------------------------------------------------------------------------------------------------
	---------------------------------------- Precast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	-- Precast sets to enhance JAs

	sets.buff['Burst Affinity'] = {feet="Hashi. Basmak +1"}
	sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +1"}
	sets.buff['Efflux'] = {legs="Hashishin Tayt +1"}

	sets.precast.JA['Azure Lore'] = {hands="Luhlaza Bazubands"}
	sets.precast.JA['Chain Affinity'] = {feet="Assim. Charuqs +1"}
	--sets.precast.JA['Convergence'] = {head="Luh. Keffiyeh +1"}
	--sets.precast.JA['Enchainment'] = {body="Luhlaza Jubbah +1"}

	sets.precast.Waltz = {
		body="Passion Jacket",
		hands="Slither Gloves +1",
		legs="Dashing Subligar",
		neck="Phalaina Locket",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		waist="Gishdubar Sash",
		}

	sets.precast.FC = {
		-- Tanmoygayi +1 6 / Colada 4
		ammo="Sapience Orb", --2
		head="Carmine Mask +1", --14
		body=gear.Taeon_FC_body, --8
		hands="Leyline Gloves", --7
		legs="Psycloth Lappas", --7
		feet="Carmine Greaves +1", --8
		neck="Orunmila's Torque", --5
		ear1="Loquacious Earring", --2
		ear2="Enchntr. Earring +1", --2
		ring1="Kishar Ring", --4
		ring2="Weather. Ring", --5(3)
		back="Swith Cape +1", --4
		waist="Witful Belt", --3/(2)
		}

	sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear2="Mendi. Earring"})

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		ammo="Impatiens",
		body="Passion Jacket",
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		waist="Ninurta's Sash",
		})

	
	------------------------------------------------------------------------------------------------
	------------------------------------- Weapon Skill Sets ----------------------------------------
	------------------------------------------------------------------------------------------------

	sets.precast.WS = {
		ammo="Focal Orb",
		head="Lilitu Headpiece",
		body=gear.Herc_TA_body,
		hands="Jhakri Cuffs +1",
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_TA_feet,
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Shukuyu Ring",
		ring2="Ilabrat Ring",
		back=gear.BLU_WS2_Cape,
		waist="Fotia Belt",
		}

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_WS_hands,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		legs="Adhemar Kecks"
		})

	sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
		ammo="Jukukik Feather",
		head=gear.Adhemar_TP_head,
		body="Abnoba Kaftan",
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights", 
		feet="Thereoid Greaves",
		ear2="Brutal Earring",
		ring1="Begrudging Ring",
		ring2="Epona's Ring",
		back=gear.BLU_WS1_Cape,
		})

	sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body="Sayadio's Kaftan",
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ilabrat Ring",
		})

	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		ammo="Floestone",
		hands=gear.Adhemar_TP_hands,
		neck="Caro Necklace",
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		waist="Prosilio Belt +1",
		})

	sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {
		ammo="Focal Orb",
		body=gear.Herc_TA_body,
		hands=gear.Herc_Acc_hands,
		feet=gear.Herc_Acc_feet,
		neck="Combatant's Torque",
		ear2="Telos Earring",
		ring1="Rufescent Ring",
		waist="Grunfeld Rope",
		})

	sets.precast.WS['Requiescat'] = {
		ammo="Quartz Tathlum +1",
		head="Jhakri Coronal +1",
		body="Jhakri Robe +1",
		hands="Jhakri Cuffs +1",
		legs=gear.Herc_WS_legs,
		feet="Jhakri Pigaches +1",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Brutal Earring",
		ring1="Rufescent Ring",
		ring2="Epona's Ring",
		back=gear.BLU_WS1_Cape,
		waist="Fotia Belt",
		}

	sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		hands=gear.Herc_Acc_hands,
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ear2="Telos Earring",
		})

	sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS['Savage Blade'], {
		ring1="Apate Ring",
		})

	sets.precast.WS['Expiacion'].Acc = set_combine(sets.precast.WS['Expiacion'], {
		body=gear.Herc_TA_body,
		feet=gear.Herc_Acc_feet,
		ear2="Telos Earring",
		})

	sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1", 
		body="Amalric Doublet",
		hands="Jhakri Cuffs +1",
		legs="Amalric Slops",
		feet="Jhakri Pigaches +1",
		--feet="Amalric Nails"
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Regal Earring",
		ring1="Archon Ring",
		ring2="Rufescent Ring",
		back=gear.BLU_MAB_Cape,
		waist="Fotia Belt",
		}

	sets.precast.WS['True Strike']= set_combine(sets.precast.WS['Savage Blade'], {ring1="Ifrit Ring +1"})
	sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
	sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
	sets.precast.WS['Judgment'].Acc = sets.precast.WS['True Strike'].Acc
	sets.precast.WS['Black Halo'] = sets.precast.WS['True Strike']
	sets.precast.WS['Black Halo'].Acc = sets.precast.WS['True Strike'].Acc
	sets.precast.WS['Realmrazer'] = sets.precast.WS['Requiescat']
	sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc
	
	sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {
		head="Jhakri Coronal +1",
		ring1="Levia. Ring +1",
		ring2="Weather. Ring",
		})

	------------------------------------------------------------------------------------------------
	---------------------------------------- Midcast Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		ammo="Impatiens", --10
		--ear1="Halasz Earring", --5
		ring1="Evanescence Ring", --5
		waist="Ninurta's Sash", --6
		}

	sets.midcast['Blue Magic'] = {
		ammo="Mavi Tathlum",
		head="Luh. Keffiyeh +1",
		body="Assim. Jubbah +1",
		hands="Rawhide Gloves",
		legs="Hashishin Tayt +1", 
		feet="Luhlaza Charuqs +1",
		neck="Incanter's Torque",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		back="Cornflower Cape", 
		}

	sets.midcast['Blue Magic'].Physical = {
		ammo="Ginsen",
		head=gear.Adhemar_TP_head, 
		body=gear.Herc_TA_body,
		hands=gear.Adhemar_TP_hands,
		legs=gear.Herc_WS_legs,
		feet=gear.Herc_TA_feet,
		neck="Caro Necklace", 
		ring1="Ifrit Ring +1",
		ring2="Shukuyu Ring",
		back=gear.BLU_WS2_Cape,
		waist="Prosilio Belt +1",
		}

	sets.midcast['Blue Magic'].PhysicalAcc = set_combine(sets.midcast['Blue Magic'].Physical, {
		ammo="Floestone",
		head="Carmine Mask +1",
		hands=gear.Herc_Acc_hands,
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		neck="Sanctity Necklace", 
		ear2="Telos Earring",
		back="Cornflower Cape",
		waist="Grunfeld Rope",
		})

	sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical

	sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {
		ammo="Falcon Eye",
		ear2="Mache Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back=gear.BLU_WS1_Cape,
		})

	sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical

	sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {
		body="Sayadio's Kaftan",
		ring1="Garuda Ring +1",
		ring2="Garuda Ring +1",
		})

	sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {
		ear2="Regal Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.BLU_MAB_Cape,
		})

	sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {
		ear2="Regal Earring",
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		})
	
	sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {ear1="Regal Earring", ear2="Enchntr. Earring +1"})

	sets.midcast['Blue Magic'].Magical = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +1",
		body="Vedic Coat",
		hands="Amalric Gages",
		legs="Amalric Slops",
		feet="Jhakri Pigaches +1",
		neck="Baetyl Pendant",
		ear1="Friomisi Earring",
		ear2="Regal Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back=gear.BLU_MAB_Cape,
		waist="Eschan Stone",
		}

	sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {	
		body="Samnuha Coat",
		neck="Sanctity Necklace",
		ear1="Digni. Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Yamabuki-no-Obi",
		})

	sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {
		head="Pixie Hairpin +1",
		ring1="Archon Ring",
		})

	sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {
		ring2="Weather. Ring"
		})

	sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {
		ring1="Levia. Ring +1",
		ring2="Levia. Ring +1",
		})

	sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		})

	sets.midcast['Blue Magic'].MagicalVit = sets.midcast['Blue Magic'].Magical
	sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {ear1="Regal Earring", ear2="Enchntr. Earring +1"})

	sets.midcast['Blue Magic'].MagicAccuracy = {
		ammo="Pemphredo Tathlum",
		head="Amalric Coif",
		body="Amalric Doublet",
		hands="Rawhide Gloves", 
		legs="Psycloth Lappas",
		feet="Jhakri Pigaches +1",
		neck="Incanter's Torque",
		ear1="Hermetic Earring",
		ear2="Regal Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Luminary Sash",
		}

	sets.midcast['Blue Magic'].Breath = sets.midcast['Blue Magic'].Magical

	sets.midcast['Blue Magic'].Stun = sets.midcast['Blue Magic'].MagicAccuracy

	sets.midcast['Blue Magic'].Healing = {
		ammo="Pemphredo Tathlum",
		head="Carmine Mask +1", 
		body="Vrikodara Jupon", -- 13
		hands="Telchine Gloves", -- 10
		feet="Medium's Sabots", -- 12
		neck="Incanter's Torque",
		ear1="Calamitous Earring",
		ear2="Mendi. Earring", -- 5
		ring1="Lebeche Ring", -- 3
		ring2="Haoma's Ring",
		back="Solemnity Cape", -- 7
		waist="Bishop's Sash",
		}

	sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {
		hands="Buremte Gloves", -- (13)
		legs="Gyve Trousers", -- 10
		neck="Phalaina Locket", -- 4(4)
		ring2="Asklepian Ring", -- (3)
		waist="Gishdubar Sash", -- (10)
		})

		
	sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
	sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {head="Amalric Coif", waist="Gishdubar Sash", back="Grapevine Cape"})
	sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']
	
	sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {
		ammo="Mavi Tathlum",
		head="Carmine Mask +1",
		hands="Hashi. Bazu. +1",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring", 	
		ring1="Kishar Ring",
		ring2="Weather. Ring",
		waist="Witful Belt",
		})

	sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {
		head="Amalric Coif",
		waist="Emphatikos Rope",
		})

	sets.midcast['Enhancing Magic'] = {
		ammo="Pemphredo Tathlum",
		head="Carmine Mask +1",
		neck="Incanter's Torque",
		ear1="Andoaa Earring",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		ear1="Augment. Earring",
		ear2="Andoaa Earring",
		back="Fi Follet Cape +1",
		waist="Olympus Sash",
		legs="Carmine Cuisses +1",
		feet="Telchine Pigaches"
		}

	sets.midcast.EnhancingDuration = {
		head="Telchine Cap",
		body="Telchine Chas.",
		hands="Telchine Gloves",
		legs="Telchine Braconi",
		feet="Telchine Pigaches",
		}

	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif", waist="Gishdubar Sash", back="Grapevine Cape"})
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {waist="Siegel Sash"})
	sets.midcast.Phalanx = set_combine(sets.midcast['Enhancing Magic'], {body=gear.Taeon_FC_body, feet=gear.Taeon_PH_feet})
	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {head="Amalric Coif", waist="Emphatikos Rope"})

	sets.midcast.Protect = {ring1="Sheltered Ring"}
	sets.midcast.Protectra = sets.midcast.Protect
	sets.midcast.Shell = sets.midcast.Protect
	sets.midcast.Shellra = sets.midcast.Protect

	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


	------------------------------------------------------------------------------------------------
	----------------------------------------- Idle Sets --------------------------------------------
	------------------------------------------------------------------------------------------------

	-- Resting sets
	sets.resting = {}


	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = {
		ammo="Staunch Tathlum",
		head="Rawhide Mask", 
		body="Jhakri Robe +1",
		hands=gear.Adhemar_TP_hands,
		legs="Carmine Cuisses +1",
		feet="Carmine Greaves +1",
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Moonbeam Cape",
		waist="Flume Belt +1",
		}

	sets.idle.DT = set_combine(sets.idle, {
		ammo="Staunch Tathlum", --2/2
		head=gear.Herc_DT_head, --3/3
		body="Hagondes Coat +1", --4/4
		hands=gear.Herc_DT_hands, --6/4
		feet="Battlecast Gaiters", --3/0
		neck="Loricate Torque +1", --6/6
		ear1="Genmei Earring", --2/0
		ring1="Gelatinous Ring +1", --7/(-1)
		ring2="Defending Ring", --10/10
		back="Moonbeam Cape", --5/5
		waist="Flume Belt +1", --4/0
		})

	sets.idle.Town = set_combine(sets.idle, {
		head="Dampening Tam",
		feet="Carmine Greaves +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back=gear.BLU_WS1_Cape,
		waist="Windbuffet Belt +1",
		})

	sets.idle.Weak = sets.idle.DT

	sets.idle.Learning = set_combine(sets.idle, sets.Learning)

	------------------------------------------------------------------------------------------------
	---------------------------------------- Defense Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT

	------------------------------------------------------------------------------------------------
	---------------------------------------- Engaged Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- * DW6: +37%
	-- * DW5: +35%
	-- * DW4: +30%
	-- * DW3: +25% (NIN Subjob)
	-- * DW2: +15% (DNC Subjob)
	-- * DW1: +10%
	
	-- No Magic Haste (74% DW to cap)
	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_TP_hands,
		legs="Carmine Cuisses +1", --6
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace", 
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back=gear.BLU_TP_Cape,
		waist="Reiki Yotai", --7
		} -- 36%
		
	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		hands=gear.Herc_Acc_hands,
		ring2="Ilabrat Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		head="Carmine Mask +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP = set_combine(sets.engaged, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 15% Magic Haste (67% DW to cap)
	sets.engaged.LowHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_TP_hands,
		legs="Carmine Cuisses +1", --6
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace", 
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back=gear.BLU_TP_Cape,
		waist="Reiki Yotai", --7
		} -- 36%

	sets.engaged.LowAcc.LowHaste = set_combine(sets.engaged.LowHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		})

	sets.engaged.MidAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		hands=gear.Herc_Acc_hands,
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.LowHaste = set_combine(sets.engaged.LowAcc.LowHaste, {
		head="Carmine Mask +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.LowHaste = set_combine(sets.engaged.LowHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	-- 30% Magic Haste (56% DW to cap)
	sets.engaged.MidHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet, --9
		neck="Asperity Necklace", 
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back=gear.BLU_TP_Cape,
		waist="Windbuffet Belt +1",
		} -- 23%

	sets.engaged.LowAcc.MidHaste = set_combine(sets.engaged.MidHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		})

	sets.engaged.MidAcc.MidHaste = set_combine(sets.engaged.LowAcc.MidHaste, {
		hands=gear.Herc_Acc_hands,
		feet=gear.Herc_TA_feet,
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.MidHaste = set_combine(sets.engaged.MidHaste.MidAcc, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MidHaste = set_combine(sets.engaged.MidHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})
		
	-- 35% Magic Haste (51% DW to cap)
	sets.engaged.HighHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket", --5
		hands=gear.Adhemar_TP_hands,
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace", 
		ear1="Eabani Earring", --4
		ear2="Suppanomimi", --5
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back=gear.BLU_TP_Cape,
		waist="Windbuffet Belt +1",
		} -- 14%

	sets.engaged.LowAcc.HighHaste = set_combine(sets.engaged.HighHaste, {
		neck="Combatant's Torque",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc.HighHaste = set_combine(sets.engaged.LowAcc.HighHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_Acc_hands,
		ear2="Telos Earring",
		ring2="Ilabrat Ring",
		})

	sets.engaged.HighAcc.HighHaste = set_combine(sets.engaged.MidAcc.HighHaste, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ear1="Cessance Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.HighHaste = set_combine(sets.engaged.HighHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
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
		neck="Asperity Necklace",
		ear1="Cessance Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back=gear.BLU_TP_Cape,
		waist="Windbuffet Belt +1",
		} -- 0%

	sets.engaged.LowAcc.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		ammo="Falcon Eye",
		neck="Combatant's Torque",
		})

	sets.engaged.MidAcc.MaxHaste = set_combine(sets.engaged.LowAcc.MaxHaste, {
		hands=gear.Herc_Acc_hands,
		ring2="Ilabrat Ring",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighAcc.MaxHaste = set_combine(sets.engaged.MidAcc.MaxHaste, {
		head="Carmine Mask +1",
		legs="Carmine Cuisses +1",
		feet=gear.Herc_Acc_feet,
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.STP.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		feet="Carmine Greaves +1",
		neck="Ainia Collar",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Petrov Ring",
		waist="Kentarch Belt +1",
		})

	------------------------------------------------------------------------------------------------
	---------------------------------------- Special Sets ------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {
		body="Samnuha Coat", --(8)
		hands="Amalric Gages", --(5)
		feet="Jhakri Pigaches +1", --5
		ear2="Static Earring", --5
		ring1="Mujin Band", --(5)
		back="Seshaw Cape", --5
		})

	sets.Kiting = {legs="Carmine Cuisses +1"}
	sets.Learning = {hands="Assim. Bazu."}
	sets.latent_refresh = {waist="Fucho-no-obi"}

	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}

	sets.CP = {back="Mecisto. Mantle"}
	sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
		eventArgs.cancel = true
		windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
	end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	-- Add enhancement gear for Chain Affinity, etc.
	if spell.skill == 'Blue Magic' then
		for buff,active in pairs(state.Buff) do
			if active and sets.buff[buff] then
				equip(sets.buff[buff])
			end
		end
		if spellMap == 'Healing' and spell.target.type == 'SELF' then
			equip(sets.midcast['Blue Magic'].HealingSelf)
		end
	end

	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
		if spellMap == 'Refresh' then
			equip(sets.midcast.Refresh)
		end
	end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.english == "Dream Flower" then
			send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
		elseif spell.english == "Soporific" then
			send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
		elseif spell.english == "Sheep Song" then
			send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
		elseif spell.english == "Yawn" then
			send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
		elseif spell.english == "Entomb" then
			send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end

	if buffactive['Reive Mark'] then
		if gain then		   
			equip(sets.Reive)
			disable('neck')
		else
			enable('neck')
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

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
	if spell.skill == 'Blue Magic' then
		for category,spell_list in pairs(blue_magic_maps) do
			if spell_list:contains(spell.english) then
				return category
			end
		end
	end
end

-- Modify the default idle set after it was constructed.
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
	if state.IdleMode.value == 'Learning' then
		equip(sets.Learning)
		disable('hands')
	else
		enable('hands')
	end
	
	return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	determine_haste_group()
	update_active_abilities()
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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

	if state.IdleMode.value ~= 'None' then
		msg = msg .. '[ Idle: ' .. state.IdleMode.value .. ' ]'
	end

	msg = msg .. '[ ' .. state.HasteMode.value .. ' ]'
	
	if state.Kiting.value then
		msg = msg .. '[ Kiting Mode: ON ]'
	end

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
	-- Victory March +0/+3/+4/+5	9.4%/14%/15.6%/17.1%
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

function update_active_abilities()
	state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
	state.Buff['Efflux'] = buffactive['Efflux'] or false
	state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
	if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
		if state.MagicBurst.value then
			equip(sets.magic_burst)
		end
		equip(sets.buff['Burst Affinity'])
	end
	if state.Buff.Efflux and spellMap == 'Physical' then
		equip(sets.buff['Efflux'])
	end
	if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
		equip(sets.buff['Diffusion'])
	end

	if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
	if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
	if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 10)
	elseif player.sub_job == 'RDM' then
		set_macro_page(2, 10)
	else
		set_macro_page(1, 10)
	end
end

function set_lockstyle()
	send_command('wait 2; input /lockstyleset 3')
end