-------------------------------------------------------------------------------------------------------------------
-- Modify the sets table.  Any gear sets that are added to the sets table need to
-- be defined within this function, because sets isn't available until after the
-- include is complete.  It is called at the end of basic initialization in Mote-Include.
-------------------------------------------------------------------------------------------------------------------

function define_global_sets()

    gear.Gada_ENF = {name="Gada", augments={'Enmity-4','MND+7','Mag. Acc.+22','"Mag.Atk.Bns."+20',}}
    gear.Gada_ENH = {name="Gada", augments={'Enh. Mag. eff. dur. +6','Mag. Acc.+11',}}
    gear.Gada_GEO = {name="Gada", augments={'Indi. eff. dur. +11','DMG:+4',}}

    gear.Adhemar_C_legs = {name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}}
    gear.Adhemar_D_legs = {name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}}

    gear.Merl_FC_hands = {name="Merlinic Dastanas", augments={'"Fast Cast"+7','CHR+3','Mag. Acc.+12','"Mag.Atk.Bns."+1',}}

    gear.Merl_Idle_feet = {name="Merlinic Crackows", augments={'Attack+24','"Store TP"+1','"Refresh"+1','Mag. Acc.+15 "Mag.Atk.Bns."+15',}}

    gear.Merl_MAB_head = {name="Merlinic Hood", augments={'Mag. Acc.+23 "Mag.Atk.Bns."+23','Magic burst dmg.+5%','CHR+6','Mag. Acc.+4','"Mag.Atk.Bns."+10',}}
    gear.Merl_MAB_legs = {name="Merlinic Shalwar", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+11%','Mag. Acc.+14','"Mag.Atk.Bns."+14',}}
    gear.Merl_MAB_feet = {name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+15','"Mag.Atk.Bns."+13',}}

    gear.Ody_DA_legs = {name="Odyssean Cuisses", augments={'Accuracy+16 Attack+16','"Dbl.Atk."+4','Accuracy+9','Attack+9',}}

    --gear.Ody_FC_legs = {name="Odyssean Cuisses", augments={'Accuracy+29','"Fast Cast"+5','Attack+13',}}
    gear.Ody_FC_feet = {name="Odyssean Greaves", augments={'Attack+5','"Fast Cast"+6','Accuracy+10',}}

    gear.COR_DW_Cape = {name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10',}} --*
    gear.COR_RA_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','"Store TP"+10',}} --*
    gear.COR_SNP_Cape = {name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Snapshot"+10',}} --*
    gear.COR_WS1_Cape = {name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}} --*
    gear.COR_WS2_Cape = {name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}} --*
    gear.COR_WS3_Cape = {name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}} --*

    gear.DRK_DA_Cape = {name="Ankou's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}} --**
    gear.DRK_FC_Cape = {name="Ankou's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Spell interruption rate down-10%',}} --**
    gear.DRK_WS1_Cape = {name="Ankou's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**
    gear.DRK_WS2_Cape = {name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}} --**
    gear.DRK_WS3_Cape = {name="Ankou's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}} --**

    gear.GEO_Cure_Cape = {name="Nantosuelta's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Spell interruption rate down-10%',}} --**
    gear.GEO_FC_Cape = {name="Nantosuelta's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10',}} --*
    gear.GEO_Idle_Cape = {name="Nantosuelta's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Cure" potency +10%','Damage taken-5%',}} --**
    gear.GEO_MAB_Cape = {name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}} --**
    gear.GEO_Pet_Cape = {name="Nantosuelta's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Pet: "Regen"+10','Pet: "Regen"+5',}} --**

    gear.WHM_Cure_Cape = {name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Enmity-10','Spell interruption rate down-10%',}} --**
    gear.WHM_FC_Cape = {name="Alaunus's Cape", augments={'INT+20','Eva.+20 /Mag. Eva.+20','MND+10','"Fast Cast"+10','Phys. dmg. taken-10%',}} --**

end
