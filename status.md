# Pillow's Random Scenarios (PZ b42.13) status

Last updated: 2025-12-18

## Goal

Bring the mod up to Project Zomboid `b42.13` while keeping compatibility with older `b42.12` by splitting the mod into version-gated folders.

## Completed

- Added a new `42.13/` folder with copied content from `42/`:
  - `Contents/mods/Pillow's Random Scenarios/42.13/`
- Version gating:
  - `Contents/mods/Pillow's Random Scenarios/42.13/mod.info` now has `versionMin=42.13` and `pzversion=42.13`
  - Legacy `mod.info` files now have `versionMax=42.12`:
    - `Contents/mods/Pillow's Random Scenarios/mod.info`
    - `Contents/mods/Pillow's Random Scenarios/42/mod.info`
    - `Contents/mods/Pillow's Random Scenarios/common/mod.info`
- Stats API migration (b42.13):
  - Replaced `stats:setX(...)` calls with `stats:set(CharacterStat.X, value)` where applicable.
  - Hospital drunkenness now uses a safe enum resolver to avoid crashing if the enum name differs:
    - `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/HospitalChallenge.lua`
- ItemBodyLocation migration (b42.13):
  - Added `toItemBodyLocation()` conversion helper and used it when calling `player:setWornItem(...)`:
    - `.../Abandoned Soldier.lua`
    - `.../EnterAreaChallenge.lua`
    - `.../HospitalChallenge.lua`
    - `.../LastDitchSecurity.lua`
    - `.../PrisonChallenge.lua`
    - `.../TheLastFlight.lua`
- Fixed a crash in NakedAndAfraid (b42.13):
  - Incorrect indexing `itemlist[ZombRand(7)]` sometimes returned `nil` (Lua arrays are 1-based).
  - Now uses `list[ZombRand(#list) + 1]` via a helper.
  - File: `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/NakedAndAfraid.lua`
- Player/body damage server-side bridge (b42.13):
  - Added server handler for client commands:
    - `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/server/PillowsRandomScenarios_Server.lua`
  - Client scenarios now send `ApplyBodyDamageOps` instead of directly mutating body parts client-side:
    - `.../HospitalChallenge.lua`
    - `.../TheLastFlight.lua`
- FireSale stability fixes (b42.13):
  - Fixed `normalloops` nil crash by using `pillowmod.normalloops`.
  - Replaced `tile:explode()` calls with a safe `startSquareFire()` wrapper (with MP server command fallback).
  - Added `StartSquareFire` server command support in `PillowsRandomScenarios_Server.lua`.
  - Files:
    - `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/FireSale.lua`
    - `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/HospitalChallenge.lua`

## Known issues / remaining work

### 1) Confirm correct b42.13 `CharacterStat` names

- We had to add fallback resolution for the “drunk” stat because `CharacterStat.DRUNKENNESS` was `nil` in at least one b42.13 build.
- Action:
  - Verify which enum exists in your target b42.13 build (likely one of: `DRUNKENNESS`, `DRUNK`, `INTOXICATION`).
  - Once confirmed, hardcode to the correct name (and remove fallbacks if desired).

### 2) Verify fire-start behavior in b42.13

- We now route fires through `startSquareFire()` which attempts:
  - `square:explode()` (if present), otherwise
  - `IsoFireManager.StartFire(...)`
  - and uses `sendClientCommand` server-side in MP.
- Action:
  - Confirm fires actually appear for FireSale/HospitalChallenge in:
    - SP
    - MP (hosted / dedicated)

### 3) Run-through all scenarios in 42.13

The following files should each be smoke-tested in b42.13:
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/Abandoned Soldier.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/DodgeballOfTheDead.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/EnterAreaChallenge.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/FireSale.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/HospitalChallenge.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/LastDitchSecurity.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/NakedAndAfraid.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/PrisonChallenge.lua`
- `Contents/mods/Pillow's Random Scenarios/42.13/media/lua/client/LastStand/TheLastFlight.lua`

### 4) Check for remaining API changes mentioned by community

These were part of the initial report, but have not been encountered in this mod’s code yet (so may not apply):
- `WeaponType` enum rename (`barehands` -> `UNARMED`, etc.)
- `PropertyContainer` method rename (`:Is` -> `:has`, etc.)
- Trait API rename (`HasTrait("X")` -> `hasTrait(CharacterTrait.X)`)

If any of these appear during testing, update them in `42.13/` only.

## Suggested testing checklist

- SP: start each scenario once and ensure:
  - no exceptions on load
  - player starts with expected items/clothing
  - any intended injuries/stats apply
- MP host: repeat FireSale + HospitalChallenge specifically:
  - verify injuries/fires still happen (server-side commands working)
- b42.12.x install sanity:
  - verify only the legacy folder loads (because of `versionMax=42.12`)

