/**
 * DELTA GREEN STATS — Equipment Catalog
 * Sourced from the Delta Green: Agent's Handbook Foundry VTT compendium.
 * Used by the equipment picker to build character loadouts for Foundry export.
 */
'use strict';

// Canonical ammo-pool caliber labels use ASCII "x" consistently, e.g.
// 9x19mm, 5.56x45mm NATO, 7.62x39mm, 7.62x51mm NATO.
window.DG_EQUIPMENT_CATALOG = [

    // ── FIREARMS ──────────────────────────────────────────────────────────────────
    {
        category: 'Firearms', name: 'Light pistol', type: 'weapon', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Revolver capacity: 6. Examples: .22 LR, .32 ACP, .380 ACP, .38 Special: S&amp;W Model 36, Walther PPK.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Medium pistol', type: 'weapon', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Revolver capacity: 6. Examples: 9×19 mm, .40 S&amp;W, .45 ACP: Beretta Mod 92FS (M9), Colt M1911A1, Glock 17, Glock 22.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Heavy pistol', type: 'weapon', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Revolver capacity: 6. Examples: .357 Magnum, .44 Magnum, .50 AE: Colt Delta Elite, Glock 20, S&amp;W Model 13.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Light rifle or carbine', type: 'weapon', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED IF CAPABLE OF FULLY AUTOMATIC FIRE.</strong> Use the Lethality rating if firing bursts. Examples: AR-15, Colt M4, FN SCAR-L. <strong>Lethality: 10%</strong></em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '10 or 30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Heavy rifle', type: 'weapon', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED IF CAPABLE OF FULLY AUTOMATIC FIRE.</strong> Examples: H&amp;K G3, FN FAL, Remington Model 700 (M24). <strong>Lethality: 10%</strong></em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '10 or 20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Very heavy rifle', type: 'weapon', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Examples: .408 CheyTac, .50 Browning: Barrett Model 82A1, CheyTac M200.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '10', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Submachine gun (SMG)', type: 'weapon', subcategory: 'SMGs', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED IF CAPABLE OF FULLY AUTOMATIC FIRE.</strong> Examples: B&amp;T MP9, FN P90, H&amp;K MP5, IMI Uzi, KRISS Vector. <strong>Lethality: 10%</strong></em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Shotgun (firing shot)', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Half damage beyond base range. Includes +20% bonus for firing shot. Examples: Mossberg Model 500, Remington Model 870.</em></p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Shotgun (firing slug)', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Damage reduced to 2D6 beyond base range.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Shotgun (firing nonlethal)', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Damage:</strong> 1D6 and Stunned</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },

    // ── N3RDMADE EXPANDED FIREARM VARIANTS
    {
        category: 'Firearms', name: '.22 LR pocket pistol', type: 'weapon', subcategory: 'Pistols', caliber: '.22 LR',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '.380 ACP compact pistol', type: 'weapon', subcategory: 'Pistols', caliber: '.380 ACP',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '.38 Special snub-nose revolver', type: 'weapon', subcategory: 'Pistols', caliber: '.38 Special',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '9mm service pistol', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Medium pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '.40 S&W service pistol', type: 'weapon', subcategory: 'Pistols', caliber: '.40 S&W',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Medium pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '.45 ACP service pistol', type: 'weapon', subcategory: 'Pistols', caliber: '.45 ACP',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Medium pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '.357 Magnum revolver', type: 'weapon', subcategory: 'Pistols', caliber: '.357 Magnum',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '.44 Magnum revolver', type: 'weapon', subcategory: 'Pistols', caliber: '.44 Magnum',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: '10mm Auto pistol', type: 'weapon', subcategory: 'Pistols', caliber: '10mm Auto',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy pistol; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'AR-15 carbine', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light rifle or carbine; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'M4 carbine', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light rifle or carbine; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'FN SCAR-L', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light rifle or carbine; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'H&K G3 battle rifle', type: 'weapon', caliber: '7.62x51mm NATO', subcategory: 'Battle Rifles',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy rifle; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'FN FAL battle rifle', type: 'weapon', caliber: '7.62x51mm NATO', subcategory: 'Battle Rifles',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy rifle; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'M24 sniper rifle', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy rifle; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Barrett M82A1 anti-materiel rifle', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Very heavy rifle; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '10', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'CheyTac M200 anti-materiel rifle', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.408 CheyTac',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Very heavy rifle; uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '7', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'H&K MP5 submachine gun', type: 'weapon', subcategory: 'SMGs', caliber: '9x19mm',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Submachine gun (SMG); uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'FN P90 submachine gun', type: 'weapon', subcategory: 'SMGs', caliber: '5.7x28mm',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Submachine gun (SMG); uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '50', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'IMI Uzi submachine gun', type: 'weapon', subcategory: 'SMGs', caliber: '9x19mm',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Submachine gun (SMG); uses the same Delta Green game statistics.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '32', expense: 'Unusual', equipped: true }
    },

    // ── N3RDMADE FIREARMS — PISTOLS
    {
        category: 'Firearms', name: 'Chiappa Rhino 60DS', type: 'weapon', subcategory: 'Pistols', caliber: '.357 Magnum', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Chiappa Rhino 60DS</strong> — .357 Magnum, standard capacity 6. Delta Green game stats are based on the existing Heavy pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Glock 17 Gen5', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Glock 17 Gen5</strong> — 9x19mm, standard capacity 17. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '17', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Glock 19 Gen5', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Glock 19 Gen5</strong> — 9x19mm, standard capacity 15. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'SIG Sauer P320 Full Size', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>SIG Sauer P320 Full Size</strong> — 9x19mm, standard capacity 17. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '17', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'SIG Sauer P226', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>SIG Sauer P226</strong> — 9x19mm, standard capacity 15. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Beretta 92FS', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Beretta 92FS</strong> — 9x19mm, standard capacity 15. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'HK USP45', type: 'weapon', subcategory: 'Pistols', caliber: '.45 ACP', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>HK USP45</strong> — .45 ACP, standard capacity 12. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '12', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'HK VP9', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>HK VP9</strong> — 9x19mm, standard capacity 15. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'CZ 75 B', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>CZ 75 B</strong> — 9x19mm, standard capacity 16. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '16', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'CZ P-10 C', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>CZ P-10 C</strong> — 9x19mm, standard capacity 15. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Walther PDP Compact', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Walther PDP Compact</strong> — 9x19mm, standard capacity 15. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Smith & Wesson M&P9 M2.0', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Smith & Wesson M&P9 M2.0</strong> — 9x19mm, standard capacity 17. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '17', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Colt Python', type: 'weapon', subcategory: 'Pistols', caliber: '.357 Magnum', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Colt Python</strong> — .357 Magnum, standard capacity 6. Delta Green game stats are based on the existing Heavy pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Ruger GP100', type: 'weapon', subcategory: 'Pistols', caliber: '.357 Magnum', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Ruger GP100</strong> — .357 Magnum, standard capacity 6. Delta Green game stats are based on the existing Heavy pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'FN 509', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>FN 509</strong> — 9x19mm, standard capacity 17. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '17', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'FN Five-seveN MRD', type: 'weapon', subcategory: 'Pistols', caliber: '5.7x28mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>FN Five-seveN MRD</strong> — 5.7x28mm, standard capacity 20. Delta Green game stats are based on the existing Light pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Springfield Armory Echelon', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Springfield Armory Echelon</strong> — 9x19mm, standard capacity 17. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '17', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Colt Government 1911', type: 'weapon', subcategory: 'Pistols', caliber: '.45 ACP', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Colt Government 1911</strong> — .45 ACP, standard capacity 7. Delta Green game stats are based on the existing Medium pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Desert Eagle Mark XIX', type: 'weapon', subcategory: 'Pistols', caliber: '.50 AE', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Desert Eagle Mark XIX</strong> — .50 AE, standard capacity 7. Delta Green game stats are based on the existing Heavy pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'SIG Sauer P365', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm', subcategory: 'Pistols', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>SIG Sauer P365</strong> — 9x19mm, standard capacity 10. Delta Green game stats are based on the existing Light pistol profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Standard', equipped: true }
    },

    // ── N3RDMADE FIREARMS — CARBINES
    {
        category: 'Firearms', name: 'HK416 A5', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>HK416 A5</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'SIG MCX SPEAR LT', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>SIG MCX SPEAR LT</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'IWI Tavor X95', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>IWI Tavor X95</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Steyr AUG A3', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Steyr AUG A3</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Ruger Mini-14', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Ruger Mini-14</strong> — 5.56x45mm / .223 Rem, standard capacity 20. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'CZ BREN 2 Ms Carbine', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>CZ BREN 2 Ms Carbine</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Beretta ARX100', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Beretta ARX100</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'IWI Galil ACE Gen II', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>IWI Galil ACE Gen II</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Kel-Tec RDB', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Kel-Tec RDB</strong> — 5.56x45mm NATO, standard capacity 20. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Bushmaster ACR', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO', subcategory: 'Carbines', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Bushmaster ACR</strong> — 5.56x45mm NATO, standard capacity 30. Delta Green game stats are based on the existing Light rifle or carbine profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },

    // ── N3RDMADE FIREARMS — MARKSMAN RIFLES
    {
        category: 'Firearms', name: 'M110 SASS', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>M110 SASS</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Knight\'s Armament SR-25', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Knight\'s Armament SR-25</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'HK417', type: 'weapon', subcategory: 'Battle Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>HK417</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'HK G28', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>HK G28</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'FN SCAR 20S', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>FN SCAR 20S</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'SIG Sauer 716i TREAD', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>SIG Sauer 716i TREAD</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'M14 EBR', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>M14 EBR</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'SVD Dragunov', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x54R', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>SVD Dragunov</strong> — 7.62x54R, standard capacity 10. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Mk 12 SPR', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '5.56x45mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Mk 12 SPR</strong> — 5.56x45mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Daniel Defense DD5 V4', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO', subcategory: 'Marksman Rifles', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Daniel Defense DD5 V4</strong> — 7.62x51mm NATO, standard capacity 20. Delta Green game stats are based on the existing Heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },

    // ── N3RDMADE FIREARMS — HEAVY SNIPERS
    {
        category: 'Firearms', name: 'Barrett M107A1', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Barrett M107A1</strong> — .50 BMG, standard capacity 10. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '10', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Barrett Model 95', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Barrett Model 95</strong> — .50 BMG, standard capacity 5. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '5', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Barrett Model 99', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Barrett Model 99</strong> — .50 BMG, standard capacity 1. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Accuracy International AX50', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Accuracy International AX50</strong> — .50 BMG, standard capacity 5. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '5', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'McMillan TAC-50', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>McMillan TAC-50</strong> — .50 BMG, standard capacity 5. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '5', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Desert Tech HTI', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Desert Tech HTI</strong> — .50 BMG, standard capacity 5. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '5', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Steyr HS .50 M1', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Steyr HS .50 M1</strong> — .50 BMG, standard capacity 5. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '5', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Sako TRG M10', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.338 Lapua Magnum', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Sako TRG M10</strong> — .338 Lapua Magnum, standard capacity 8. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '8', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Barrett MRAD', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.338 Lapua Magnum', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Barrett MRAD</strong> — .338 Lapua Magnum, standard capacity 10. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '10', expense: 'Major', equipped: true }
    },
    {
        category: 'Firearms', name: 'Accuracy International AXMC', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.338 Lapua Magnum', subcategory: 'Heavy Snipers', caliber: 'various',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Accuracy International AXMC</strong> — .338 Lapua Magnum, standard capacity 10. Delta Green game stats are based on the existing Very heavy rifle profile; real-world chambering/capacity is preserved for inventory tracking.</p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '10', expense: 'Major', equipped: true }
    },

    // ── N3RDMADE FIREARMS — SHOTGUNS
    {
        category: 'Firearms', name: 'Franchi SPAS-12', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Franchi SPAS-12</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 8.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '8', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Remington 870 Police Magnum', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Remington 870 Police Magnum</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 4.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '4', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Mossberg 500 Tactical', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Mossberg 500 Tactical</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 5.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Mossberg 590A1 Tactical', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Mossberg 590A1 Tactical</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 7.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '8', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Benelli M4 EXT', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Benelli M4 EXT</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 7.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Ithaca Model 37 Defense', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Ithaca Model 37 Defense</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 4.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '4', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Winchester Model 1897 Riot Gun', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Winchester Model 1897 Riot Gun</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 5.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Browning Auto-5', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Browning Auto-5</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 4.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '4', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Stoeger Coach Gun', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Stoeger Coach Gun</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 2.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '2', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Sawed-off Double-Barrel Shotgun', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Sawed-off Double-Barrel Shotgun</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 2.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '2', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Saiga-12', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Saiga-12</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 5.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'VEPR-12', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>VEPR-12</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 5.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'AA-12', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>AA-12</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 8.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '8', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Kel-Tec KSG', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Kel-Tec KSG</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 14.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '14', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Standard Manufacturing DP-12', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Standard Manufacturing DP-12</strong> — expanded catalog variant using the existing Shotgun (firing shot) Delta Green profile; chambering 12 gauge; standard capacity 16.</p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '16', expense: 'Standard', equipped: true }
    },


    // ── 7.62x39mm ASSAULT RIFLES ───────────────────────────────────────────────
    {
        category: 'Firearms', name: 'AKM', type: 'weapon', subcategory: 'Assault Rifles', caliber: '7.62x39mm',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>7.62x39mm Kalashnikov-pattern assault rifle; mapped to the standard light rifle/carbine game profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'AK-103', type: 'weapon', subcategory: 'Assault Rifles', caliber: '7.62x39mm',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Modern 7.62x39mm Kalashnikov-pattern assault rifle; mapped to the standard light rifle/carbine game profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Zastava M70', type: 'weapon', subcategory: 'Assault Rifles', caliber: '7.62x39mm',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Yugoslav/Serbian 7.62x39mm Kalashnikov-pattern assault rifle; mapped to the standard light rifle/carbine game profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'IWI Galil ACE Gen II 7.62x39', type: 'weapon', subcategory: 'Assault Rifles', caliber: '7.62x39mm',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Modern 7.62x39mm Galil ACE rifle; mapped to the standard light rifle/carbine game profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'CZ BREN 2 Ms 7.62x39', type: 'weapon', subcategory: 'Assault Rifles', caliber: '7.62x39mm',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>7.62x39mm BREN 2 configuration; mapped to the standard light rifle/carbine game profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },

    // ── MELEE WEAPONS ─────────────────────────────────────────────────────────────
    {
        category: 'Melee Weapons', name: 'Unarmed attack', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/unarmed.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'unarmed_combat', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4-1', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'NA', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Brass knuckles, heavy flashlight, or steel-toe boots', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/brass-knuckles.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'unarmed_combat', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Garrote', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/rope.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Works only from surprise. Target is pinned and cannot make a sound; does 1D6 damage per round until escape or death. A Kevlar garrote can cut through flexible cuffs.</em></p>', skill: 'unarmed_combat', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Long knife or combat dagger', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Hatchet', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/hatchet.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Club, nightstick, baton, or collapsible baton', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baton.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Baseball bat or rifle butt', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baseball-bat.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Machete, tomahawk, or sword', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Spear or fixed bayonet', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/bayonet.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Wood axe', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/wood-axe.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Long sword', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/long-sword.svg', flags: {}, effects: [],
        system: { name: '', description: '', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Standard', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Two-handed sword', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/two-handed-sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires special training.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Standard', equipped: true }
    },

    // ── N3RDMADE EXPANDED MELEE VARIANTS
    {
        category: 'Melee Weapons', name: 'Combat dagger', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Long knife or combat dagger; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Nightstick', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baton.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Club, nightstick, baton, or collapsible baton; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Collapsible baton', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baton.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Club, nightstick, baton, or collapsible baton; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Baseball bat', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baseball-bat.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Baseball bat or rifle butt; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Rifle butt', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baseball-bat.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Baseball bat or rifle butt; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Machete', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Machete, tomahawk, or sword; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Tomahawk', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Machete, tomahawk, or sword; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Fixed bayonet', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/bayonet.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Spear or fixed bayonet; uses the same Delta Green game statistics.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },

    // ── N3RDMADE MELEE — SWORDS
    {
        category: 'Melee Weapons', name: 'Katana', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/long-sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Katana</strong> — expanded catalog variant using the existing Long sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Standard', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Wakizashi', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Wakizashi</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'European Longsword', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/long-sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>European Longsword</strong> — expanded catalog variant using the existing Long sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Standard', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Rapier', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Rapier</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Cavalry Saber', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Cavalry Saber</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Cutlass', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Cutlass</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Jian', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Jian</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Dao', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Dao</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Falchion', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/tomahawk.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Falchion</strong> — expanded catalog variant using the existing Machete, tomahawk, or sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Claymore', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/two-handed-sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Claymore</strong> — expanded catalog variant using the existing Two-handed sword Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Standard', equipped: true }
    },

    // ── N3RDMADE MELEE — KNIVES
    {
        category: 'Melee Weapons', name: 'Kukri', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Kukri</strong> — expanded catalog variant using the existing Long knife or combat dagger Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Arkansas Toothpick', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Arkansas Toothpick</strong> — expanded catalog variant using the existing Long knife or combat dagger Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Bowie Knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Bowie Knife</strong> — expanded catalog variant using the existing Long knife or combat dagger Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Fairbairn-Sykes Fighting Knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Fairbairn-Sykes Fighting Knife</strong> — expanded catalog variant using the existing Long knife or combat dagger Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'KA-BAR Fighting Knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>KA-BAR Fighting Knife</strong> — expanded catalog variant using the existing Long knife or combat dagger Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'M1918 Trench Knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/combat-knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>M1918 Trench Knife</strong> — expanded catalog variant using the existing Long knife or combat dagger Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Tanto Knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Tanto Knife</strong> — expanded catalog variant using the existing Knife Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Karambit', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Karambit</strong> — expanded catalog variant using the existing Knife Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Stiletto', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Stiletto</strong> — expanded catalog variant using the existing Knife Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Puukko', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><strong>Puukko</strong> — expanded catalog variant using the existing Knife Delta Green profile.</p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 3, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },

    // ── HEAVY WEAPONS ─────────────────────────────────────────────────────────────
    {
        category: 'Heavy Weapons', name: 'Hand grenade', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires special training. <strong>RESTRICTED.</strong> Examples: M67, RGO. Includes +20% blast-zone bonus.</em></p>', skill: 'athletics', skillModifier: 20, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Grenade launcher (GL)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Revolver capacity: 6. Examples: Colt M203, H&amp;K M320, Springfield M79. Includes +20% blast-zone bonus.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '150M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Grenade machine gun (GMG)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> If firing a burst (5 grenades), Lethality is 20%. Examples: H&amp;K GMG, Saco MK 19 MOD 3. Includes +20% blast-zone bonus.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '300M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '30', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Rocket-propelled grenade launcher (RPG)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: ATK M72 LAW, Bazalt RPG-7V, Bofors AT4. Includes +20% blast-zone bonus.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 20, lethality: 30, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Light machine gun (LMG)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: FN MINIMI (M249 SAW), Molot RPK.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 3, lethality: 10, isLethal: true, killRadius: '1M', ammo: '100 or 200', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'General-purpose machine gun (GPMG)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: FN MAG (M240), Kovrov PKM, Saco M60.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '300M', damage: '', armorPiercing: 3, lethality: 15, isLethal: true, killRadius: '1M', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Heavy machine gun (HMG)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: Browning M2HB, Degtyaryov DShKM, Kovrov NSV.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '400M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: '1M', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Autocannon', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/autocannon.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: ATK M242 Bushmaster, KBP 2A70.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '400M', damage: '', armorPiercing: 5, lethality: 30, isLethal: true, killRadius: '3M', ammo: '100', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Minigun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/minigun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: Dillon GAU-17/A, GE M134, KBP GShG-7.62.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '300M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: '3M', ammo: '4000', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Handheld flamethrower', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/flamethrower.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Example: Ion XM42.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '5M', damage: '', armorPiercing: 0, lethality: 10, isLethal: true, killRadius: '1M', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Military flamethrower', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/flamethrower.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Example: AEC M9A1-7.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '', armorPiercing: 0, lethality: 10, isLethal: true, killRadius: '2M', ammo: '5', expense: 'Unusual', equipped: true }
    },

    // ── N3RDMADE EXPANDED HEAVY-WEAPON VARIANTS
    {
        category: 'Heavy Weapons', name: 'M67 fragmentation grenade', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Hand grenade; uses the same Delta Green game statistics.</em></p>', skill: 'athletics', skillModifier: 20, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'RGO fragmentation grenade', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Hand grenade; uses the same Delta Green game statistics.</em></p>', skill: 'athletics', skillModifier: 20, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M203 grenade launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Grenade launcher (GL); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '150M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M320 grenade launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Grenade launcher (GL); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '150M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M79 grenade launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Grenade launcher (GL); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '150M', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'RPG-7V launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Rocket-propelled grenade launcher (RPG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 20, lethality: 30, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M72 LAW', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Rocket-propelled grenade launcher (RPG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 20, lethality: 30, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'AT4 launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Rocket-propelled grenade launcher (RPG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 20, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 20, lethality: 30, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M249 SAW', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light machine gun (LMG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 3, lethality: 10, isLethal: true, killRadius: '1M', ammo: '100 or 200', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'RPK light machine gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Light machine gun (LMG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '200M', damage: '', armorPiercing: 3, lethality: 10, isLethal: true, killRadius: '1M', ammo: '100 or 200', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M240 machine gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of General-purpose machine gun (GPMG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '300M', damage: '', armorPiercing: 3, lethality: 15, isLethal: true, killRadius: '1M', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'PKM machine gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of General-purpose machine gun (GPMG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '300M', damage: '', armorPiercing: 3, lethality: 15, isLethal: true, killRadius: '1M', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M60 machine gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of General-purpose machine gun (GPMG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '300M', damage: '', armorPiercing: 3, lethality: 15, isLethal: true, killRadius: '1M', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'Browning M2HB heavy machine gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Heavy machine gun (HMG); uses the same Delta Green game statistics.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '400M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: '1M', ammo: '100', expense: 'Major', equipped: true }
    },

    // ── ARTILLERY ─────────────────────────────────────────────────────────────────
    {
        category: 'Artillery', name: 'Light mortar', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/mortar.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: M224, Hirtenberger M6.</em></p>', skill: 'artillery', skillModifier: 20, customSkillTarget: 50, range: '2KM', damage: '', armorPiercing: 0, lethality: 20, isLethal: true, killRadius: '25M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Artillery', name: 'Heavy mortar', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/mortar.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: M120, 2B11 Sani.</em></p>', skill: 'artillery', skillModifier: 20, customSkillTarget: 50, range: '4KM', damage: '', armorPiercing: 5, lethality: 35, isLethal: true, killRadius: '50M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Artillery', name: 'General-purpose bomb', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/general-purpose-bomb.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Requires special training. Examples: MK 82, FAB-250.</em></p>', skill: 'artillery', skillModifier: 20, customSkillTarget: 50, range: 'Air-dropped', damage: '', armorPiercing: 10, lethality: 70, isLethal: true, killRadius: '100M', ammo: '', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Artillery', name: 'Anti-tank guided missile (ATGM)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/rocket.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Examples: AGM-114 Hellfire, 9M120 Ataka. Includes +20% blaze-zone bonus.</em></p>', skill: 'artillery', skillModifier: 20, customSkillTarget: 50, range: '4KM', damage: '', armorPiercing: 25, lethality: 45, isLethal: true, killRadius: '50M', ammo: '', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Artillery', name: 'Cruise missile', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/cruise-missile.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Requires special training. Examples: BGM-109 Tomahawk, Kh-55SM. Includes +20% blaze-zone bonus.</em></p>', skill: 'artillery', skillModifier: 20, customSkillTarget: 50, range: '100KM', damage: '', armorPiercing: 15, lethality: 80, isLethal: true, killRadius: '150M', ammo: '', expense: 'Extreme', equipped: true }
    },

    // ── DEMOLITIONS ───────────────────────────────────────────────────────────────
    {
        category: 'Demolitions', name: 'ANFO explosive', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/anfo.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Ammonium nitrate fuel oil — requires Science (Chemistry) and Demolitions skills. Includes +20% blast-zone bonus.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 30, isLethal: true, killRadius: '20M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Improvised explosive device (IED)', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED</strong>, though the ingredients usually are not. Example: Pipe bomb. Includes +20% blast-zone bonus.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Large IED', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED</strong>, though the ingredients usually are not. Example: Car bomb. Includes +20% blast-zone bonus.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 60, isLethal: true, killRadius: '75M', ammo: '', expense: 'Standard', equipped: true }
    },
    {
        category: 'Demolitions', name: 'C4 plastic explosive block, 570 g', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/c4.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Example: M112. Includes +20% blast-zone bonus.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 30, isLethal: true, killRadius: '2M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Explosively formed penetrator mine', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/penetrator-mine.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Example: M21. Includes +20% blast-zone bonus.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 20, lethality: 25, isLethal: true, killRadius: '10M', ammo: '', expense: 'Standard', equipped: true }
    },

    // ── N3RDMADE EXPANDED DEMOLITIONS VARIANTS
    {
        category: 'Demolitions', name: 'Improvised pipe bomb', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Improvised explosive device (IED); uses the same Delta Green game statistics.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Car bomb / vehicle IED', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Large IED; uses the same Delta Green game statistics.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 60, isLethal: true, killRadius: '75M', ammo: '', expense: 'Standard', equipped: true }
    },
    {
        category: 'Demolitions', name: 'M112 C4 demolition charge', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/c4.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of C4 plastic explosive block, 570 g; uses the same Delta Green game statistics.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 30, isLethal: true, killRadius: '2M', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Demolitions', name: 'M21 anti-vehicle mine', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/penetrator-mine.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Explosively formed penetrator mine; uses the same Delta Green game statistics.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 20, lethality: 25, isLethal: true, killRadius: '10M', ammo: '', expense: 'Standard', equipped: true }
    },

    // ── LESS-LETHAL ───────────────────────────────────────────────────────────────
    {
        category: 'Less-Lethal', name: 'Stun gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/electroshock.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>Victim\'s Penalty:</strong> \u221220% for 1D20 turns</em></p>', skill: 'unarmed_combat', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Shock baton', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/electroshock.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>Victim\'s Penalty:</strong> \u221220% for 1D20 turns</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '200', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'CED pistol', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/electroshock.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires special training. <strong>Victim\'s Penalty:</strong> \u221220% for 1D20 turns</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '4M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '4', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Flash-bang grenade, thrown', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/flash-bang-grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>Restricted.</strong> Requires special training. Radius halved outdoors. Radius: 10 m. <strong>Victim\'s Penalty:</strong> \u221240% for 1D6 turns</em></p>', skill: 'athletics', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Flash-bang grenade, launched', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/flash-bang-grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>Restricted.</strong> Radius halved outdoors. Radius: 10 m. <strong>Victim\'s Penalty:</strong> \u221240% for 1D6 turns</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Tear gas grenade, thrown', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/tear-gas-grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>Restricted.</strong> Requires special training. Radius: 10 m. <strong>Victim\'s Penalty:</strong> \u221240% for 1 hr</em></p>', skill: 'athletics', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Tear gas grenade, launched', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/tear-gas-grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>Restricted. Radius:</strong> 10 m. <strong>Victim\'s Penalty:</strong> \u221240% for 1 hr</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Pepper spray keychain', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/pepper-spray-keychain.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Radius: 1 target. <strong>Victim\'s Penalty:</strong> \u221220% for 1 hr</em></p>', skill: 'unarmed_combat', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '1', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Pepper spray can', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/pepper-spray-can.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Radius: 2 targets. <strong>Victim\'s Penalty:</strong> \u221220% for 1 hr</em></p>', skill: 'unarmed_combat', skillModifier: 0, customSkillTarget: 50, range: '3M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '12', expense: 'Incidental', equipped: true }
    },

    // ── ARMOR ─────────────────────────────────────────────────────────────────────
    {
        category: 'Armor', name: 'Kevlar vest', type: 'armor',
        img: 'systems/deltagreen/assets/icons/kevlar-vest.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>If worn below outer garments, noticing it requires an Alertness test.</em></p>', protection: 3, equipped: true, expense: 'Standard' }
    },
    {
        category: 'Armor', name: 'Reinforced Kevlar vest', type: 'armor',
        img: 'systems/deltagreen/assets/icons/kevlar-vest.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>If worn below outer garments, noticing it requires an Alertness test at +20%.</em></p>', protection: 4, equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Armor', name: 'Tactical body armor', type: 'armor',
        img: 'systems/deltagreen/assets/icons/tactical-body-armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Cannot be concealed.</em></p>', protection: 5, equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Armor', name: 'Kevlar helmet', type: 'armor',
        img: 'systems/deltagreen/assets/icons/helmet.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Adds its Armor Rating to any other armor. Cannot be concealed.</em></p>', protection: 1, equipped: true, expense: 'Standard' }
    },
    {
        category: 'Armor', name: 'Riot helmet', type: 'armor',
        img: 'systems/deltagreen/assets/icons/helmet.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Adds its Armor Rating to any other armor. Effective only against melee, thrown, and unarmed attacks. Cannot be concealed.</em></p>', protection: 1, equipped: true, expense: 'Standard' }
    },
    {
        category: 'Armor', name: 'Bomb suit', type: 'armor',
        img: 'systems/deltagreen/assets/icons/bomb-suit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Already includes a helmet. Cannot be concealed.</em></p>', protection: 10, equipped: true, expense: 'Extreme' }
    },

    // ── N3RDMADE EXPANDED ARMOR VARIANTS
    {
        category: 'Armor', name: 'Concealable soft body armor', type: 'armor',
        img: 'systems/deltagreen/assets/icons/kevlar-vest.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Kevlar vest; uses the same Delta Green game statistics.</em></p>', protection: 3, equipped: true, expense: 'Standard' }
    },
    {
        category: 'Armor', name: 'Reinforced concealable body armor', type: 'armor',
        img: 'systems/deltagreen/assets/icons/kevlar-vest.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Reinforced Kevlar vest; uses the same Delta Green game statistics.</em></p>', protection: 4, equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Armor', name: 'Plate carrier / tactical vest', type: 'armor',
        img: 'systems/deltagreen/assets/icons/tactical-body-armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Tactical body armor; uses the same Delta Green game statistics.</em></p>', protection: 5, equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Armor', name: 'Ballistic helmet', type: 'armor',
        img: 'systems/deltagreen/assets/icons/helmet.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Kevlar helmet; uses the same Delta Green game statistics.</em></p>', protection: 1, equipped: true, expense: 'Standard' }
    },
    {
        category: 'Armor', name: 'EOD bomb suit', type: 'armor',
        img: 'systems/deltagreen/assets/icons/bomb-suit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded-catalog variant of Bomb suit; uses the same Delta Green game statistics.</em></p>', protection: 10, equipped: true, expense: 'Extreme' }
    },

    // ── SURVEILLANCE ──────────────────────────────────────────────────────────────
    {
        category: 'Surveillance', name: 'Simple directional microphone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/microphone.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Surveillance', name: 'Voice-activated recorder', type: 'gear',
        img: 'systems/deltagreen/assets/icons/sound.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Directional microphone & acoustic software', type: 'gear',
        img: 'systems/deltagreen/assets/icons/microphone.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>20 m. range in typical urban conditions. Advanced versions have 50 m. range as an Unusual expense.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Fiber optic scope', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Bug detector', type: 'gear',
        img: 'systems/deltagreen/assets/icons/bug-detector.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'GPS tracking device', type: 'gear',
        img: 'systems/deltagreen/assets/icons/gps-tracking.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Surveillance', name: 'GPS jammer', type: 'gear',
        img: 'systems/deltagreen/assets/icons/jammer.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Audio jammer (RF/cellular)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/jammer.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Surveillance', name: 'Basic, open-market drone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/drone.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires special training (DEX).</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Advanced drone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/drone.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires Pilot (Drone) skill.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Military-grade drone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/drone.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires Pilot (Drone) skill; can carry weapons.</em></p>', equipped: true, expense: 'Extreme' }
    },
    {
        category: 'Surveillance', name: 'Ground-penetrating radar', type: 'gear',
        img: 'systems/deltagreen/assets/icons/ground-penetrating-radar.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>About the size of a lawn mower; requires special training (INT).</em></p>', equipped: true, expense: 'Major' }
    },

    // ── COMMS & TECH ──────────────────────────────────────────────────────────────
    {
        category: 'Comms & Tech', name: 'Burner phone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/phone.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Comms & Tech', name: 'Short-range walkie talkie or early-generation mobile phone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/walkie-talkie.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Comms & Tech', name: 'Earpiece communication set', type: 'gear',
        img: 'systems/deltagreen/assets/icons/sound.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: 'Tablet computer or smartphone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/tablet.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: 'Satellite phone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/satellite-phone.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Comms & Tech', name: 'Ordinary computer', type: 'gear',
        img: 'systems/deltagreen/assets/icons/computer.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: 'Powerful computer', type: 'gear',
        img: 'systems/deltagreen/assets/icons/computer.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Major' }
    },
    {
        category: 'Comms & Tech', name: 'Portable IMSI catcher for cell surveillance', type: 'gear',
        img: 'systems/deltagreen/assets/icons/imsi-catcher.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Cannot be concealed.</em></p>', equipped: true, expense: 'Major' }
    },
    {
        category: 'Comms & Tech', name: '"Script kiddie" hacking software', type: 'gear',
        img: 'systems/deltagreen/assets/icons/software.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires Computer Science; a failed Luck roll indicates it\'s faulty.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Comms & Tech', name: 'Advanced data-analysis software', type: 'gear',
        img: 'systems/deltagreen/assets/icons/software.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires Computer Science or special training (INT).</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: 'Cutting-edge encryption or data-mining software', type: 'gear',
        img: 'systems/deltagreen/assets/icons/software.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Requires Computer Science or special training (INT).</em></p>', equipped: true, expense: 'Major' }
    },
    {
        category: 'Comms & Tech', name: '3D printer (plastic)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/3d-printer.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: '3D printer (metal)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/3d-printer.svg', flags: {}, effects: [],
        system: { name: '', description: '', equipped: true, expense: 'Major' }
    },

    // ── OPTICS & VISION ───────────────────────────────────────────────────────────
    {
        category: 'Optics & Vision', name: 'Large flashlight', type: 'gear',
        img: 'systems/deltagreen/assets/icons/flashlight.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Useful to 100 m. Runs for 10 hours.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Optics & Vision', name: 'Tactical light or weapon light', type: 'gear',
        img: 'systems/deltagreen/assets/icons/flashlight.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Useful to 50 m. Runs for 1 hour. Available with optional IR or UV filters.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Optics & Vision', name: 'Ordinary binoculars', type: 'gear',
        img: 'systems/deltagreen/assets/icons/binoculars.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>\u00d710 magnification; allows Alertness tests at greater distance.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Optics & Vision', name: 'Advanced binoculars or telescope', type: 'gear',
        img: 'systems/deltagreen/assets/icons/binoculars.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>\u00d720 magnification; allows Alertness tests at greater distance.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Optics & Vision', name: 'Powerful telescope', type: 'gear',
        img: 'systems/deltagreen/assets/icons/telescope.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>\u00d750 magnification; allows Alertness tests at greater distance.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Optics & Vision', name: 'Civilian night vision goggles (NVG)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/goggles.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Allows operating in reduced light. Most skill tests at \u221220% penalty. Runs for 100 hours.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Optics & Vision', name: 'Military-grade night vision goggles', type: 'gear',
        img: 'systems/deltagreen/assets/icons/goggles.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Allows operating in reduced light. Most skills at no penalty; finely detailed perception at \u221220%.</em></p>', equipped: true, expense: 'Major' }
    },

    // ── WEAPON ACCESSORIES ────────────────────────────────────────────────────────
    {
        category: 'Weapon Accessories', name: 'Holographic sight', type: 'gear',
        img: 'systems/deltagreen/assets/icons/holographic-sight.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>+20% bonus to hit as long as the Agent has taken no damage since their last action.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Weapon Accessories', name: 'Telescopic sight', type: 'gear',
        img: 'systems/deltagreen/assets/icons/telescopic-sight.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Doubles a firearm\'s base range if the Agent spent the previous turn taking the Aim action.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Weapon Accessories', name: 'Targeting laser', type: 'gear',
        img: 'systems/deltagreen/assets/icons/laser.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>+20% bonus to hit if undamaged since last action. Useful to 200 m. Runs for 100 hours. Also available with IR mode (Unusual expense).</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Weapon Accessories', name: 'Night vision sight', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Allows aiming in reduced light. Useful to 400 m. Runs for 100 hours. Doubles a firearm\'s base range at night if the Agent spends the previous turn Aiming.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Weapon Accessories', name: 'Thermal Weapon Sight (TWS)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Allows aiming in complete darkness. Useful to 400 m. Runs for two hours. Doubles range if Agent spent previous turn Aiming.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Weapon Accessories', name: 'Advanced Combat Optical Gunsight (ACOG)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/acog.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Combines holographic sight and telescopic sight: +20% to hit if undamaged; doubles range if previous turn spent Aiming.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Weapon Accessories', name: 'Sound suppressor', type: 'gear',
        img: 'systems/deltagreen/assets/icons/suppressor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em><strong>RESTRICTED.</strong> Requires an Alertness test to hear from beyond a wall or door.</em></p>', equipped: true, expense: 'Standard' }
    },

    // ── ENTRY TOOLS ───────────────────────────────────────────────────────────────
    {
        category: 'Entry Tools', name: 'Lockpick kit', type: 'gear',
        img: 'systems/deltagreen/assets/icons/lockpick-kit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires special training (DEX).</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Entry Tools', name: 'Halligan forcible-entry tool', type: 'gear',
        img: 'systems/deltagreen/assets/icons/forcible-entry-tool.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Allows a STR test to get through a hard barrier.</em></p>', equipped: true, expense: 'Standard' }
    },

    // ── RESTRAINTS ────────────────────────────────────────────────────────────────
    {
        category: 'Restraints', name: 'Handcuffs', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handcuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Require a cuff key, special training with lockpicks, or Craft (Locksmith) to open; or a DEX\u00d75 test at \u221220% to wriggle out.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Restraints', name: 'Flexible cuffs', type: 'gear',
        img: 'systems/deltagreen/assets/icons/flexible-cuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires a blade or scissors to cut open. A zip-tie used as makeshift cuffs can be broken with a STR\u00d75 test at +20%.</em></p>', equipped: true, expense: 'Incidental' }
    },

    // ── SURVIVAL & MEDICAL ────────────────────────────────────────────────────────
    {
        category: 'Survival & Medical', name: 'Individual first aid kit', type: 'gear',
        img: 'systems/deltagreen/assets/icons/first-aid-kit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Adds +20% to a single First Aid roll.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'First responder medical kit', type: 'gear',
        img: 'systems/deltagreen/assets/icons/first-aid-kit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Bandages, IV kits and fluids, medications, stethoscope, suture and intubation kits, hemostatic gel. Adds +20% to four First Aid rolls.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Survival & Medical', name: 'Basic camping gear', type: 'gear',
        img: 'systems/deltagreen/assets/icons/camping-gear.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Daypack, bivouac sack, survival blanket, compass, flashlight, matches, meal bars, water purification tablets. Grants +20% to Survival for 3 days.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'Extended camping gear', type: 'gear',
        img: 'systems/deltagreen/assets/icons/camping-gear.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Large backpack, sleeping bag, tent, compass, headlamp, firestarter, dehydrated meals, water filter, canister stove. Grants +20% to Survival for 14 days.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Survival & Medical', name: 'Handheld GPS', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handheld-gps.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Does not require a radio signal. Battery life is 14 to 25 hours.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'SCUBA gear', type: 'gear',
        img: 'systems/deltagreen/assets/icons/scuba-gear.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Requires special training (Swim).</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Survival & Medical', name: 'Personal protection equipment (PPE)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/ppe.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Apron, goggles, gloves, breath mask; provides 2 Armor against chemical and acid splashes and fumes.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'Gas mask', type: 'gear',
        img: 'systems/deltagreen/assets/icons/gas-mask.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Effective against airborne hazards.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Survival & Medical', name: 'HAZMAT suit', type: 'gear',
        img: 'systems/deltagreen/assets/icons/hazmat-suit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Effective against airborne or contact hazards. Requires 30 minutes to don safely.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Survival & Medical', name: 'Small fire extinguisher (CO2)', type: 'gear',
        img: 'systems/deltagreen/assets/icons/fire-extinguisher.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Douses a small fire. Can be used with a DEX\u00d75 test to spray an animal in the face to make it run away.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'Heavy-duty fire extinguisher', type: 'gear',
        img: 'systems/deltagreen/assets/icons/fire-extinguisher.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Douses a room-sized fire.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Survival & Medical', name: 'Polypropylene barrel filled with acid', type: 'gear',
        img: 'systems/deltagreen/assets/icons/acid.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Sufficient to reduce a corpse to sludge. Remember to wear PPE!</em></p>', equipped: true, expense: 'Unusual' }
    },


    // ── HELLHORDE EXPANDED CATALOG — 2026-09-30 ────────────────────────────────
    // Real-world named examples mapped onto existing Delta Green weapon classes.

    // Pistols — 5 additional real-world examples
    {
        category: 'Firearms', name: 'Smith & Wesson Model 29', type: 'weapon', subcategory: 'Pistols', caliber: '.44 Magnum',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Six-shot .44 Magnum revolver. Game statistics are mapped to the Delta Green Heavy pistol class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Smith & Wesson Model 686', type: 'weapon', subcategory: 'Pistols', caliber: '.357 Magnum',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>.357 Magnum revolver. Game statistics are mapped to the Delta Green Heavy pistol class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '6', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Browning Hi-Power', type: 'weapon', subcategory: 'Pistols', caliber: '9x19mm',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Classic 9mm service pistol with a 13-round magazine. Game statistics are mapped to the Delta Green Medium pistol class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '15M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '13', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Glock 20 Gen5', type: 'weapon', subcategory: 'Pistols', caliber: '10mm Auto',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Full-size 10mm Auto pistol with a 15-round magazine. Game statistics are mapped to the Delta Green Heavy pistol class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '15', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Colt Delta Elite', type: 'weapon', subcategory: 'Pistols', caliber: '10mm Auto',
        img: 'systems/deltagreen/assets/icons/pistol.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>1911-pattern 10mm Auto pistol with an 8-round magazine. Game statistics are mapped to the Delta Green Heavy pistol class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D12', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '8', expense: 'Standard', equipped: true }
    },

    // SMGs — MP5 and P90 already existed, so these are five additional examples
    {
        category: 'Firearms', name: 'B&T MP9', type: 'weapon', subcategory: 'SMGs', caliber: '9x19mm',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact select-fire personal-defense weapon. Game statistics are mapped to the Delta Green SMG class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'KRISS Vector SMG', type: 'weapon', subcategory: 'SMGs', caliber: '.45 ACP',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>.45 ACP select-fire SMG. Game statistics are mapped to the Delta Green SMG class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '25', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'MAC-10', type: 'weapon', subcategory: 'SMGs', caliber: '.45 ACP',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact .45 ACP machine pistol/SMG. Game statistics are mapped to the Delta Green SMG class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'CZ Scorpion EVO 3 A1', type: 'weapon', subcategory: 'SMGs', caliber: '9x19mm',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Modern 9mm select-fire SMG. Game statistics are mapped to the Delta Green SMG class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Heckler & Koch MP7A1', type: 'weapon', subcategory: 'SMGs', caliber: '4.6x30mm',
        img: 'systems/deltagreen/assets/icons/smg.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact 4.6x30mm personal-defense weapon. Game statistics are mapped to the Delta Green SMG class.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '50M', damage: '1D10', armorPiercing: 0, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '40', expense: 'Unusual', equipped: true }
    },

    // Melee — 5 additional common/improvised weapons
    {
        category: 'Melee Weapons', name: 'Aluminum baseball bat', type: 'weapon', subcategory: 'Other',
        img: 'systems/deltagreen/assets/icons/baseball-bat.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Light metal baseball bat; uses the standard bat profile.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Spiked baseball bat', type: 'weapon', subcategory: 'Other',
        img: 'systems/deltagreen/assets/icons/baseball-bat.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Improvised bat fitted with spikes or nails; a homebrew variation of the standard bat profile.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 1, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Crowbar', type: 'weapon', subcategory: 'Other',
        img: 'systems/deltagreen/assets/icons/baton.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Steel wrecking/pry bar used as an improvised melee weapon.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 1, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Claw hammer', type: 'weapon', subcategory: 'Other',
        img: 'systems/deltagreen/assets/icons/hatchet.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Common claw hammer used as an improvised melee weapon.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 1, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Sledgehammer', type: 'weapon', subcategory: 'Other',
        img: 'systems/deltagreen/assets/icons/hatchet.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavy two-handed striking tool; slower and more cumbersome than a normal club.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },

    // Grenades / throwables / improvised explosives — 5 additions
    {
        category: 'Heavy Weapons', name: 'Molotov cocktail', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Improvised thrown incendiary. 1D6 initial fire damage; continued burning and spread are adjudicated by the Handler.</em></p>', skill: 'athletics', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '1', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'M18 smoke grenade', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Thrown smoke grenade. Produces an obscuring smoke cloud rather than direct damage.</em></p>', skill: 'athletics', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: '10M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'M84 stun grenade', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/flash-bang-grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Named flash-bang variant. Uses the existing thrown flash-bang game effect: -40% for 1D6 turns.</em></p>', skill: 'athletics', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'AN-M14 TH3 incendiary grenade', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/grenade.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Military incendiary grenade. Uses a compact fire-effect profile; ongoing ignition effects are adjudicated by the Handler.</em></p>', skill: 'athletics', skillModifier: 0, customSkillTarget: 50, range: '20M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: '2M', ammo: '1', expense: 'Standard', equipped: true }
    },
    {
        category: 'Demolitions', name: 'PVC nail bomb', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Improvised fragmentation IED represented with the standard Delta Green IED profile; the name describes the fictional game item, not construction instructions.</em></p>', skill: 'demolitions', skillModifier: 20, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Incidental', equipped: true }
    },


    // ── HELLHORDE EXPANDED CATALOG — FULL CATEGORY PASS 2026-09-30 ─────────────
    // Five additional entries in each remaining equipment section.
    // Named real-world examples are mapped onto existing Delta Green-style game profiles.

    // FIREARMS — CARBINES
    {
        category: 'Firearms', name: 'SIG MCX carbine', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Modern modular carbine mapped to the standard light rifle/carbine profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'HK416 carbine', type: 'weapon', subcategory: 'Carbines', caliber: '5.56x45mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Gas-piston service carbine mapped to the standard light rifle/carbine profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },
    
    
    {
        category: 'Firearms', name: 'AK-105 carbine', type: 'weapon', subcategory: 'Carbines', caliber: '5.45x39mm',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact Kalashnikov-pattern carbine mapped to the standard light rifle/carbine profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '1D12', armorPiercing: 3, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '30', expense: 'Unusual', equipped: true }
    },

    // FIREARMS — MARKSMAN RIFLES
    {
        category: 'Firearms', name: 'M14 DMR', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Designated-marksman rifle mapped to the heavy-rifle profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    
    {
        category: 'Firearms', name: 'FN SCAR-H', type: 'weapon', subcategory: 'Battle Rifles', caliber: '7.62x51mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>7.62mm modular battle rifle mapped to the heavy-rifle profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'SR-25', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x51mm NATO',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Semi-automatic precision rifle mapped to the heavy-rifle profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '20', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Dragunov SVD', type: 'weapon', subcategory: 'Marksman Rifles', caliber: '7.62x54R',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Semi-automatic designated-marksman rifle mapped to the heavy-rifle profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '1D12+2', armorPiercing: 5, lethality: 10, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Unusual', equipped: true }
    },

    // FIREARMS — HEAVY SNIPERS
    
    
    {
        category: 'Firearms', name: 'Serbu BFG-50', type: 'weapon', subcategory: 'Heavy Snipers', caliber: '.50 BMG',
        img: 'systems/deltagreen/assets/icons/rifle.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Single-shot heavy rifle mapped to the very-heavy-rifle profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '1', expense: 'Major', equipped: true }
    },
    
    

    // FIREARMS — SHOTGUNS
    {
        category: 'Firearms', name: 'Benelli M4', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Semi-automatic tactical shotgun using the standard shot profile.</em></p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Firearms', name: 'Mossberg 590A1', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavy-duty pump shotgun using the standard shot profile.</em></p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '8', expense: 'Standard', equipped: true }
    },
    {
        category: 'Firearms', name: 'Winchester SXP Defender', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Pump-action defensive shotgun using the standard shot profile.</em></p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    
    {
        category: 'Firearms', name: 'Stoeger M3000 Defense', type: 'weapon', subcategory: 'Shotguns', caliber: '12 gauge',
        img: 'systems/deltagreen/assets/icons/shotgun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Semi-automatic defensive shotgun using the standard shot profile.</em></p>', skill: 'firearms', skillModifier: 20, customSkillTarget: 50, range: '75M', damage: '2D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '7', expense: 'Standard', equipped: true }
    },

    // MELEE — KNIVES
    {
        category: 'Melee Weapons', name: 'KA-BAR fighting knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Full-size fighting/utility knife.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Fairbairn-Sykes fighting knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Double-edged fighting knife.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Bowie knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Large fixed-blade knife.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Karambit', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact curved utility/fighting knife.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Rescue knife', type: 'weapon', subcategory: 'Knives',
        img: 'systems/deltagreen/assets/icons/knife.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Folding rescue knife with utility blade.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D4', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },

    // MELEE — SWORDS
    {
        category: 'Melee Weapons', name: 'Katana', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Curved two-handed sword.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 1, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Machete', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavy chopping blade common as a field tool.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Cutlass', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Short, broad-bladed saber.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Military saber', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Curved military-style saber.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D8', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Melee Weapons', name: 'Longsword', type: 'weapon', subcategory: 'Swords',
        img: 'systems/deltagreen/assets/icons/sword.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Historical two-edged sword, typically used with two hands.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D10', armorPiercing: 1, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Unusual', equipped: true }
    },

    // HEAVY WEAPONS
    {
        category: 'Heavy Weapons', name: 'M249 SAW', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Light machine gun represented using a standard automatic heavy-weapon profile.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '', armorPiercing: 3, lethality: 15, isLethal: true, killRadius: 'N/A', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M240B', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>General-purpose machine gun.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'PKM machine gun', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>General-purpose machine gun.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '150M', damage: '', armorPiercing: 5, lethality: 20, isLethal: true, killRadius: 'N/A', ammo: '100', expense: 'Major', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'M2 Browning', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavy .50-caliber machine gun represented as a mounted heavy weapon.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '250M', damage: '', armorPiercing: 8, lethality: 30, isLethal: true, killRadius: 'N/A', ammo: '100', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Heavy Weapons', name: 'RPK-74', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/machine-gun.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Squad automatic weapon represented as an automatic heavy-weapon profile.</em></p>', skill: 'heavy_weapons', skillModifier: 0, customSkillTarget: 50, range: '100M', damage: '', armorPiercing: 3, lethality: 15, isLethal: true, killRadius: 'N/A', ammo: '45', expense: 'Major', equipped: true }
    },

    // ARTILLERY
    {
        category: 'Artillery', name: 'M224 60mm mortar', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/artillery.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Light infantry mortar represented abstractly for game use.</em></p>', skill: 'artillery', skillModifier: 0, customSkillTarget: 50, range: '3500M', damage: '', armorPiercing: 0, lethality: 30, isLethal: true, killRadius: '15M', ammo: '1', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Artillery', name: 'M252 81mm mortar', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/artillery.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Medium infantry mortar represented abstractly for game use.</em></p>', skill: 'artillery', skillModifier: 0, customSkillTarget: 50, range: '5600M', damage: '', armorPiercing: 0, lethality: 40, isLethal: true, killRadius: '20M', ammo: '1', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Artillery', name: 'M119 105mm howitzer', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/artillery.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Towed field howitzer represented abstractly for game use.</em></p>', skill: 'artillery', skillModifier: 0, customSkillTarget: 50, range: '14000M', damage: '', armorPiercing: 0, lethality: 50, isLethal: true, killRadius: '30M', ammo: '1', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Artillery', name: 'M777 155mm howitzer', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/artillery.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>155mm field artillery represented abstractly for game use.</em></p>', skill: 'artillery', skillModifier: 0, customSkillTarget: 50, range: '24000M', damage: '', armorPiercing: 0, lethality: 60, isLethal: true, killRadius: '40M', ammo: '1', expense: 'Extreme', equipped: true }
    },
    {
        category: 'Artillery', name: 'Mk 19 automatic grenade launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/artillery.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Mounted automatic grenade launcher represented as a crew-served weapon.</em></p>', skill: 'artillery', skillModifier: 0, customSkillTarget: 50, range: '1500M', damage: '', armorPiercing: 0, lethality: 25, isLethal: true, killRadius: '10M', ammo: '32', expense: 'Extreme', equipped: true }
    },

    // DEMOLITIONS — fictional/game inventory abstractions only
    {
        category: 'Demolitions', name: 'Commercial blasting charge', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Commercial demolition charge represented abstractly; placement and effects are resolved by the Handler.</em></p>', skill: 'demolitions', skillModifier: 0, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 20, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Breaching charge', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Purpose-built breaching explosive represented abstractly for game use.</em></p>', skill: 'demolitions', skillModifier: 0, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 15, isLethal: true, killRadius: '5M', ammo: '1', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Satchel charge', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Portable demolition charge represented abstractly for game use.</em></p>', skill: 'demolitions', skillModifier: 0, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 30, isLethal: true, killRadius: '15M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Remote demolition charge', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Remote-triggered game abstraction of a demolition charge; no construction details are included.</em></p>', skill: 'demolitions', skillModifier: 0, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 25, isLethal: true, killRadius: '10M', ammo: '1', expense: 'Major', equipped: true }
    },
    {
        category: 'Demolitions', name: 'Vehicle demolition charge', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/ied.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Large demolition charge represented only as a game inventory item.</em></p>', skill: 'demolitions', skillModifier: 0, customSkillTarget: 50, range: '', damage: '', armorPiercing: 0, lethality: 35, isLethal: true, killRadius: '20M', ammo: '1', expense: 'Major', equipped: true }
    },

    // LESS-LETHAL
    {
        category: 'Less-Lethal', name: 'Pepper spray canister', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/less-lethal.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Handheld OC spray for close-range compliance.</em></p>', skill: 'dex', skillModifier: 20, customSkillTarget: 50, range: '3M', damage: '', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '10', expense: 'Incidental', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'TASER 7', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/less-lethal.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Conducted-energy device represented with the existing stun profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '7M', damage: '1D4', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '2', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Beanbag shotgun rounds', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/less-lethal.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Less-lethal 12-gauge impact rounds using the nonlethal shotgun profile.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '10M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '5', expense: 'Standard', equipped: true }
    },
    {
        category: 'Less-Lethal', name: '40mm sponge round launcher', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/less-lethal.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Single-shot less-lethal impact launcher.</em></p>', skill: 'firearms', skillModifier: 0, customSkillTarget: 50, range: '30M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '1', expense: 'Unusual', equipped: true }
    },
    {
        category: 'Less-Lethal', name: 'Expandable baton', type: 'weapon',
        img: 'systems/deltagreen/assets/icons/baton.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Collapsible impact baton.</em></p>', skill: 'melee_weapons', skillModifier: 0, customSkillTarget: 50, range: '1M', damage: '1D6', armorPiercing: 0, lethality: 0, isLethal: false, killRadius: 'N/A', ammo: '', expense: 'Incidental', equipped: true }
    },

    // ARMOR
    {
        category: 'Armor', name: 'Soft armor vest NIJ II', type: 'armor',
        img: 'systems/deltagreen/assets/icons/armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Low-profile soft body armor.</em></p>', protection: 3, equipped: true, expense: 'Standard' }
    },
    {
        category: 'Armor', name: 'Soft armor vest NIJ IIIA', type: 'armor',
        img: 'systems/deltagreen/assets/icons/armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavier soft body armor.</em></p>', protection: 4, equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Armor', name: 'Plate carrier with Level III plates', type: 'armor',
        img: 'systems/deltagreen/assets/icons/armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Plate carrier with rifle-rated hard plates.</em></p>', protection: 5, equipped: true, expense: 'Major' }
    },
    {
        category: 'Armor', name: 'Plate carrier with Level IV plates', type: 'armor',
        img: 'systems/deltagreen/assets/icons/armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavy rifle-rated hard armor.</em></p>', protection: 6, equipped: true, expense: 'Major' }
    },
    {
        category: 'Armor', name: 'Ballistic helmet', type: 'armor',
        img: 'systems/deltagreen/assets/icons/armor.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Modern ballistic helmet; Handler adjudicates location-specific protection if used.</em></p>', protection: 2, equipped: true, expense: 'Standard' }
    },

    // SURVEILLANCE
    {
        category: 'Surveillance', name: 'Digital audio recorder', type: 'gear',
        img: 'systems/deltagreen/assets/icons/surveillance.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Pocket-sized high-capacity field audio recorder.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Surveillance', name: 'Trail camera', type: 'gear',
        img: 'systems/deltagreen/assets/icons/surveillance.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Motion-triggered weather-resistant still/video camera.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Body-worn camera', type: 'gear',
        img: 'systems/deltagreen/assets/icons/surveillance.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact wearable evidence camera.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Surveillance', name: 'Parabolic microphone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/surveillance.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Directional long-range listening microphone.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Surveillance', name: 'RF detector', type: 'gear',
        img: 'systems/deltagreen/assets/icons/surveillance.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Handheld detector for nearby radio-frequency emissions.</em></p>', equipped: true, expense: 'Unusual' }
    },

    // COMMS & TECH
    {
        category: 'Comms & Tech', name: 'Ruggedized laptop', type: 'gear',
        img: 'systems/deltagreen/assets/icons/computer.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Field-ready laptop with reinforced chassis.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Comms & Tech', name: 'Satellite phone', type: 'gear',
        img: 'systems/deltagreen/assets/icons/radio.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Portable satellite communications handset.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Comms & Tech', name: 'Encrypted handheld radio', type: 'gear',
        img: 'systems/deltagreen/assets/icons/radio.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Programmable digital handheld radio with encryption support.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: 'Portable LTE/5G hotspot', type: 'gear',
        img: 'systems/deltagreen/assets/icons/computer.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Battery-powered cellular data hotspot.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Comms & Tech', name: 'Portable data-storage array', type: 'gear',
        img: 'systems/deltagreen/assets/icons/computer.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Rugged portable storage for field evidence and forensic images.</em></p>', equipped: true, expense: 'Standard' }
    },

    // OPTICS & VISION
    {
        category: 'Optics & Vision', name: 'PVS-14 night-vision monocular', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Helmet- or hand-mounted image-intensifier monocular.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Optics & Vision', name: 'Thermal monocular', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Handheld thermal-imaging monocular.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Optics & Vision', name: '10x42 binoculars', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>General-purpose field binoculars.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Optics & Vision', name: 'Laser rangefinder', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Handheld optical rangefinder for measuring distance.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Optics & Vision', name: 'Digital borescope', type: 'gear',
        img: 'systems/deltagreen/assets/icons/optics.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Flexible inspection camera for viewing confined spaces.</em></p>', equipped: true, expense: 'Incidental' }
    },

    // WEAPON ACCESSORIES
    {
        category: 'Weapon Accessories', name: 'Weapon-mounted flashlight', type: 'gear',
        img: 'systems/deltagreen/assets/icons/weapon-accessory.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact rail-mounted white light.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Weapon Accessories', name: 'Two-point rifle sling', type: 'gear',
        img: 'systems/deltagreen/assets/icons/weapon-accessory.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Adjustable tactical sling for long guns.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Weapon Accessories', name: 'Bipod', type: 'gear',
        img: 'systems/deltagreen/assets/icons/weapon-accessory.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Folding support for a rifle or machine gun.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Weapon Accessories', name: 'Holographic weapon sight', type: 'gear',
        img: 'systems/deltagreen/assets/icons/weapon-accessory.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Non-magnified electronic aiming sight.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Weapon Accessories', name: 'Low-power variable optic', type: 'gear',
        img: 'systems/deltagreen/assets/icons/weapon-accessory.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Variable-magnification rifle optic suitable for short-to-medium range.</em></p>', equipped: true, expense: 'Unusual' }
    },

    // ENTRY TOOLS
    {
        category: 'Entry Tools', name: 'Hydraulic door spreader', type: 'gear',
        img: 'systems/deltagreen/assets/icons/forcible-entry-tool.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Portable hydraulic forcible-entry tool.</em></p>', equipped: true, expense: 'Major' }
    },
    {
        category: 'Entry Tools', name: 'Bolt cutters', type: 'gear',
        img: 'systems/deltagreen/assets/icons/forcible-entry-tool.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Heavy cutters for chains, padlocks, and wire.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Entry Tools', name: 'Pry bar', type: 'gear',
        img: 'systems/deltagreen/assets/icons/forcible-entry-tool.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact steel leverage tool.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Entry Tools', name: 'Glass-break rescue tool', type: 'gear',
        img: 'systems/deltagreen/assets/icons/forcible-entry-tool.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact spring-loaded glass breaker and seatbelt cutter.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Entry Tools', name: 'Portable ram', type: 'gear',
        img: 'systems/deltagreen/assets/icons/forcible-entry-tool.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Two-handed impact tool used for forcible entry.</em></p>', equipped: true, expense: 'Standard' }
    },

    // RESTRAINTS
    {
        category: 'Restraints', name: 'Chain handcuffs', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handcuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Standard steel chain-link handcuffs.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Restraints', name: 'Hinged handcuffs', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handcuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Rigid hinged cuffs offering greater control than chain cuffs.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Restraints', name: 'Transport waist chain', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handcuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Prisoner transport restraint system.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Restraints', name: 'Leg irons', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handcuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Steel ankle restraints for prisoner transport.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Restraints', name: 'Disposable restraint pack', type: 'gear',
        img: 'systems/deltagreen/assets/icons/flexible-cuffs.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Bundle of single-use flexible restraints.</em></p>', equipped: true, expense: 'Incidental' }
    },

    // SURVIVAL & MEDICAL
    {
        category: 'Survival & Medical', name: 'Trauma kit', type: 'gear',
        img: 'systems/deltagreen/assets/icons/first-aid-kit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Expanded field medical kit for serious trauma response.</em></p>', equipped: true, expense: 'Standard' }
    },
    {
        category: 'Survival & Medical', name: 'Automated external defibrillator', type: 'gear',
        img: 'systems/deltagreen/assets/icons/first-aid-kit.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Portable AED with voice-guided operation.</em></p>', equipped: true, expense: 'Unusual' }
    },
    {
        category: 'Survival & Medical', name: 'Waterproof bivy sack', type: 'gear',
        img: 'systems/deltagreen/assets/icons/camping-gear.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Compact waterproof emergency shelter.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'Portable water filter', type: 'gear',
        img: 'systems/deltagreen/assets/icons/camping-gear.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Field filtration system for treating natural water sources.</em></p>', equipped: true, expense: 'Incidental' }
    },
    {
        category: 'Survival & Medical', name: 'Personal locator beacon', type: 'gear',
        img: 'systems/deltagreen/assets/icons/handheld-gps.svg', flags: {}, effects: [],
        system: { name: '', description: '<p><em>Emergency satellite distress beacon for remote operations.</em></p>', equipped: true, expense: 'Standard' }
    },

]; // end DG_EQUIPMENT_CATALOG
