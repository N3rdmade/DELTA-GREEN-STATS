# Delta Green Tabletop Simulator Character Sheets

Published by **Hellhorde**  
Release date: **2026-09-30**

Free to use, modify, and share provided the Hellhorde credit header remains intact in the Lua files.

## Files

- `Handler.lua` — Handler dashboard, physical dice roller, inventory/funds management, Home Time tools, equipment assignment, and Agent synchronization.
- `Agent_Red.lua`
- `Agent_Blue.lua`
- `Agent_Green.lua`
- `Agent_Purple.lua`
- `Agent_Pink.lua`
- `Agent_Orange.lua`

The Agent scripts are the same feature set with sheet-specific color, nameplate, and dice-tower GUID configuration.

### r72 equipment / session updates
- Failed-skill advancement is labeled as an **End Session** action; all marked failed skills improve by 1D4 and clear their marks.
- Weapon attack chat output no longer repeats ammo, fire mode, or modifier bookkeeping.
- Equipment rows include **REMOVE** and **REPLACE** controls. Removing a firearm leaves shared reserve ammunition in the Agent's caliber pool.
- Replacing an item opens the existing equipment browser filtered to its replacement class.
- Firearms browse as **Light / Medium / Heavy Pistols**, **Light / Heavy / Very Heavy Rifles**, **SMGs**, and **Shotguns**.

## Current versions

- Agent sheets: **r72**
- Handler dashboard: **v3.8**

## Notes

These are Tabletop Simulator object scripts. Attach the matching Agent script to each character sheet object and `Handler.lua` to the Handler dashboard object.

The scripts use shared dice storage and sheet-specific dice towers/GUIDs already configured in each file.