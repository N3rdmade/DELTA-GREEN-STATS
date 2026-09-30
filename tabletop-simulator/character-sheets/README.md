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

## Current versions

- Agent sheets: **r63**
- Handler dashboard: **v3.0**

## Notes

These are Tabletop Simulator object scripts. Attach the matching Agent script to each character sheet object and `Handler.lua` to the Handler dashboard object.

The scripts use shared dice storage and sheet-specific dice towers/GUIDs already configured in each file.