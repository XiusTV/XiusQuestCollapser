# Xius Quest Collapser

An arrow on the line between the world map and the quest log. Click it to fold the list away, or to open it again. Works with the default map and with OpenMap.

## Features

- **One arrow.** It sits on the seam between the map and the quest list, at the same height whether the list is open or folded.
- **Click to collapse.** The list on the right folds away so the map can use that space. Click again to bring it back.
- **The arrow points at what it will show.** It faces the quests while the list is open, and faces the map after the list is collapsed.
- **Default map and OpenMap.** The same button works in a window and on the full-screen map.
- **Slash commands.** `/qlc` or `/xqc` toggles the list while the map is open.

The quest log cannot be opened or closed during combat.

## Installation

1. Download the latest release, or download the repository ZIP.
2. Extract the `XiusQuestCollapser` folder into:
   - Forever: `World of Warcraft\_forever_\Interface\AddOns`
   - Retail: `World of Warcraft\_retail_\Interface\AddOns`
3. The folder should contain `XiusQuestCollapser.toc` and `XiusQuestCollapser.lua`.
4. Enable **Xius Quest Collapser** and `/reload`.

If you downloaded the repository ZIP, rename the extracted `xiusquestcollapser-main` folder to `XiusQuestCollapser`.

**Compatibility:** World of Warcraft Forever (TOC `16001`) and modern retail (TOC `120001`–`120107`). Pure Lua 5.1 with no libraries. OpenMap is optional.

## Commands

| Command | Action |
| --- | --- |
| `/qlc` | Collapse or expand the quest log while the map is open |
| `/xqc` | Same as `/qlc` |

## License

Released under the [GNU General Public License v2.0](LICENSE).

## Development

Built with the assistance of Cursor, with in-game checks and maintenance by Xius.
