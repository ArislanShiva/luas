-------------------------------------------------------------------------------------------------------------------
-- Modify the sets table.  Any gear sets that are added to the sets table need to
-- be defined within this function, because sets isn't available until after the
-- include is complete.  It is called at the end of basic initialization in Mote-Include.
-------------------------------------------------------------------------------------------------------------------

function define_global_sets()

	-- Adhemar
	gear.Adhemar_RA_hands = {name="Adhemar Wristbands", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}}
	gear.Adhemar_Att_hands = {name="Adhemar Wristbands", augments={'STR+10','DEX+10','Attack+15',}}

	-- Herculean Triple Attack Set
	gear.Herc_TA_body = {name="Herculean Vest", augments={'Accuracy+21 Attack+21','"Triple Atk."+3','STR+6','Accuracy+8',}}
	gear.Herc_TA_hands = {name="Herculean Gloves", augments={'Accuracy+20 Attack+20','"Triple Atk."+3','DEX+8','Accuracy+1',}}
	gear.Herc_TA_feet = {name="Herculean Boots", augments={'Accuracy+21 Attack+21','"Triple Atk."+4','STR+9','Accuracy+15',}}
	
	-- Herculean Accuracy Set
	gear.Herc_Acc_hands = {name="Herculean Gloves", augments={'Accuracy+23 Attack+23','"Counter"+1','STR+3','Accuracy+15',}}
	gear.Herc_Acc_feet = {name="Herculean Boots", augments={'Accuracy+19 Attack+19','"Store TP"+4','DEX+10','Accuracy+15','Attack+10',}}
	
	-- Herculean Ranged Set
	gear.Herc_RA_body = {name="Herculean Vest", augments={'Rng.Acc.+25 Rng.Atk.+25','Weapon skill damage +3%','AGI+6','Rng.Acc.+15','Rng.Atk.+11',}}
	gear.Herc_RA_hands = {name="Herculean Gloves", augments={'Rng.Acc.+24 Rng.Atk.+24','"Subtle Blow"+5','Rng.Acc.+12',}}
	gear.Herc_RA_feet = {name="Herculean Boots", augments={'Rng.Acc.+23 Rng.Atk.+23','"Rapid Shot"+3','DEX+9','Rng.Acc.+15','Rng.Atk.+12',}}
	
	-- Herculean Weapon Skill Set
	gear.Herc_WS_hands = {name="Herculean Gloves", augments={'Accuracy+27','Weapon skill damage +4%','DEX+9','Attack+7',}}
	gear.Herc_WS_legs = {name="Herculean Trousers", augments={'Accuracy+25 Attack+25','Weapon skill damage +3%','DEX+13','Accuracy+6','Attack+4',}}
	
	-- Herculean Magic Attack Bonus Set
	gear.Herc_MAB_head = {name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Store TP"+4','INT+1','Mag. Acc.+14','"Mag.Atk.Bns."+14',}}
	gear.Herc_MAB_legs = {name="Herculean Trousers", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','"Fast Cast"+3','AGI+10','"Mag.Atk.Bns."+15',}}
	gear.Herc_MAB_feet = {name="Herculean Boots", augments={'"Mag.Atk.Bns."+22','"Fast Cast"+2','Accuracy+10 Attack+10','Mag. Acc.+15 "Mag.Atk.Bns."+15',}}

	-- Herculean -DT Set
	gear.Herc_DT_head = {name="Herculean Helm", augments={'Damage taken-3%','Accuracy+10',}}
	gear.Herc_DT_hands = {name="Herculean Gloves", augments={'Attack+20','Damage taken-4%','AGI+3','Accuracy+9',}}

	-- Taeon Dual Wield Set
	gear.Taeon_DW_feet = {name="Taeon Boots", augments={'Accuracy+18 Attack+18','"Dual Wield"+5','Weapon skill damage +3%',}}


	-- Augmented Weapons
	gear.Akademos_MAB = {name="Akademos", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}}
	gear.Akademos_MAC = {name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}}

	gear.Lathi_MAB = {name="Lathi", augments={'MP+80','INT+20','"Mag.Atk.Bns."+20',}}
	gear.Lathi_ENF = {name="Lathi", augments={'Mag. Acc.+20','Enfb.mag. skill +15','Dark magic skill +15',}}
	
	gear.Grioavolr_MP = {name="Grioavolr", augments={'"Fast Cast"+5','MP+97','Mag. Acc.+28','"Mag.Atk.Bns."+29',}}
	gear.Grioavolr_INT = {name="Grioavolr", augments={'"Conserve MP"+6','INT+15','Mag. Acc.+27','"Mag.Atk.Bns."+22','Magic Damage +1',}}
	
	-- JSE Capes
	gear.BLM_Death_Cape = {name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}
	gear.BLM_FC_Cape = {name="Taranus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}
	gear.BLM_MAB_Cape = {name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}
	
	gear.BLU_WS1_Cape = {name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}}
	gear.BLU_WS2_Cape = {name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
	gear.BLU_TP_Cape = {name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}

	gear.COR_DW_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}}
    gear.COR_RA_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}}
	gear.COR_TP_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
    gear.COR_WS1_Cape = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}}
    gear.COR_WS2_Cape = {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}
	gear.COR_WS3_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}}
	
	gear.DNC_TP_Cape = {name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}
    gear.DNC_WS1_Cape = {name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}
    gear.DNC_WS2_Cape = {name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}}
	
    gear.RUN_HP_Cape = { name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}}
    gear.RUN_TP_Cape = { name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10',}}
    gear.RUN_WS2_Cape = { name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}}

	gear.SCH_MAB_Cape = {name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}}
    gear.SCH_FC_Cape = {name="Lugh's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}

end