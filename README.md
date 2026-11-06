# Xius Quest Collapser

An arrow on the line between the world map and the quest log for **modern World of Warcraft** and **World of Warcraft Forever**. Click it to fold the list away so the map can use that space, then click it again to open the list. It works on the default map and with OpenMap, in a window and on the full-screen map. A dark plate and a thin gold edge keep it with the rest of the Xius set.

## Features

### The arrow

- **On the seam:** The button sits on the line between the map and the quest list, at the same height whether the list is open or folded.
- **Click to collapse:** The list on the right folds away. Click again to bring it back.
- **Points at what you will see:** It faces the quests while the list is open, and faces the map after the list is collapsed.
- **Default map and OpenMap:** The same button works in a window and on the full-screen map.
- **Not in combat:** The quest log cannot be opened or closed while you are in combat.

## Display States

- **List open:** The arrow sits on the left edge of the quest log and points at the quests.
- **List collapsed:** The arrow stays on the right edge of the map and points back at the map.

## Controls & Slash Commands

| Command / Input | Action |
| --- | --- |
| Click the arrow | Collapse or expand the quest log |
| `/qlc` | Collapse or expand the quest log while the map is open |
| `/xqc` | Same as `/qlc` |

## Installation

1. Download the latest release `.zip` (or use **Code → Download ZIP** on this page).
2. Extract the `XiusQuestCollapser` folder into the addon directory for the client you play:
   - Forever: `World of Warcraft\_forever_\Interface\AddOns`
   - Retail: `World of Warcraft\_retail_\Interface\AddOns`
   If the extracted folder is named `xiusquestcollapser-main`, rename it to `XiusQuestCollapser`.
3. Verify the folder contains `XiusQuestCollapser.toc` and `XiusQuestCollapser.lua`.
4. Launch the game, confirm Xius Quest Collapser is checked in your AddOns menu, and run `/reload`.
5. Open the map. The arrow is on the line between the map and the quest log.

**Compatibility:** Modern retail (TOC `120001`–`120107`), World of Warcraft Forever (TOC `16001`), and The Burning Crusade Classic Anniversary (TOC `20505`–`20506`). Pure Lua 5.1 with zero external library dependencies. OpenMap is optional.

## File Overview

| File | Purpose |
| --- | --- |
| `XiusQuestCollapser.toc` | Addon manifest (interface versions, load order) |
| `XiusQuestCollapser.lua` | The seam arrow, collapse and expand, and slash commands |
| `CHANGELOG.md` | Version history |

## More From Xius

**Xius Marks Bar**: A compact raid marking bar. Click the flag for world markers or the star for target markers, with 5 / 10 / 20 pull timers, ready check, and role check built in.  
[GitHub](https://github.com/XiusTV/XiusMarksBar) · [CurseForge](https://www.curseforge.com/wow/addons/xius-marks-bar)

**Xius Threat Meter**: A clean, lightweight threat meter. Shows who is on the enemy's threat table, how much threat each player and pet has, and warns you before you pull aggro.  
[GitHub](https://github.com/XiusTV/XiusThreatMeter) · [CurseForge](https://www.curseforge.com/wow/addons/xius-threat-meter)

**Xius XP & Reputation Tracker**: A compact HUD card that replaces the default XP and reputation bars with a single movable panel: level, XP, rested, watched faction, session rates, gold, and time-to-level.  
[GitHub](https://github.com/XiusTV/XiusXPTracker) · [CurseForge](https://www.curseforge.com/wow/addons/xius-xp-and-reputation-tracker)

**Xius Max Graphics**: Pick-and-choose graphics upgrades for Forever and retail. Ultimate, Balance, and Defaults presets push view distance, grass, shadows, water, and image clarity past the normal graphics menu, with optional loot and gathering sparkles.  
[GitHub](https://github.com/XiusTV/XiusMaxGFX)

**Xius Kill Streak**: A ten-tier kill streak announcer for mobs and enemy players. Each new tier shows a banner and plays a call, with a small counter for the current streak and the time left to keep it going.  
[GitHub](https://github.com/XiusTV/XiusKillStreak)

All Xius addons share the same clean, dark gold style for a unified UI.

## License

Released under the [GNU General Public License v2.0](LICENSE).

## Development & AI Disclosure

This addon was built and refactored with the assistance of AI development tools (Cursor / LLMs) for code generation, UI layout structure, and the map quest-log toggle, with manual architecture, in-game verification, and maintenance by Xius.
