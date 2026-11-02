# Game Dropdown

A small AutoHotkey script that replaces a cluttered desktop full of game shortcuts with a single **Games** icon. Double-click it and a menu pops up listing all your games, each with its own icon. Click one to launch it.

## Features

- One desktop icon instead of many
- Games listed alphabetically, each with its own icon
- Works with Steam shortcuts (`.url`), normal shortcuts (`.lnk`) and programs (`.exe`)
- Dark, light, or automatic (match Windows) menu theme
- Add or remove games by adding or deleting shortcuts in a folder, with no need to edit the script
- "Open games folder" option at the bottom of the menu for quick changes

## Prerequisites

- **Windows 10 or 11**
- **[AutoHotkey v2](https://www.autohotkey.com/)** (free). Version 1 will not run this script.

## Installation

1. **Install AutoHotkey v2** from [autohotkey.com](https://www.autohotkey.com/). Choose the v2 download.
2. **Download `game_dropdown.ahk`** from this repository.
3. **Save it somewhere permanent**, for example `Documents\AHKScripts` is what I used. Avoid `Downloads` or the desktop, as the desktop icon will point to wherever the script lives.

## Setup

### 1. Create the games folder

Double-click `game_dropdown.ahk`. On the first run it creates a folder called `Games Shortcuts` in your Documents folder and opens it.

### 2. Add your games

Move your game shortcuts from the desktop into the `Games Shortcuts` folder.

> **Tip:** to get a shortcut for a Steam game, right-click it in your Steam library and choose **Manage > Add desktop shortcut**.

### 3. Create the Games desktop icon

1. Right-click `game_dropdown.ahk` and choose **Show more options > Send to > Desktop (create shortcut)**.
2. Rename the new desktop shortcut to **Games** (or whatever you want yourself).

### 4. Give it an icon (optional)

1. Right-click the **Games** shortcut and choose **Properties**.
2. Click **Change Icon**, then **Browse**.
3. Pick any icon you like, or add a png etc to your folder, save as .ico and use that.
4. Click **OK**, then **Apply**.

## Usage

- **Double-click** the **Games** icon to open the menu.
- **Click a game** to launch it.
- **Click anywhere else** to close the menu without launching anything.
- **Open games folder** (at the bottom of the menu) opens the folder so you can add or remove games.

### Adding or removing games

Add or delete shortcuts in the `Games Shortcuts` folder. The menu reads the folder every time it opens, so changes show up straight away.

## Configuration

Settings are at the top of `game_dropdown.ahk`. Open it in any text editor (e.g. Notepad) to change them.

| Setting | Default | Description |
|---|---|---|
| `GamesDir` | `Documents\Games Shortcuts` | Folder the menu reads shortcuts from |
| `IconSize` | `32` | Size of the icons in the menu, in pixels |
| `Theme` | `"dark"` | `"dark"`, `"light"`, or `"auto"` (follows the Windows app mode setting) |

Example, to use a different folder:

```ahk
GamesDir := "D:\My Games"
```

## Troubleshooting

**Double-clicking the script opens it in Notepad instead of running it.**
AutoHotkey v2 isn't installed, or `.ahk` files aren't associated with it. Reinstall AutoHotkey v2.

**An error mentions the version, or the script won't start.**
You're likely running AutoHotkey v1. Install v2; both can be installed side by side.

**A game shows without an icon.**
The shortcut's icon file may have moved or been deleted. Recreating the shortcut (e.g. from Steam) usually fixes it. The game will still launch either way.

**The menu is light even though `Theme` is set to `"dark"`.**
The dark theme uses an undocumented Windows feature. If a Windows update changes it, the script falls back to the light theme rather than breaking.

**Pop-up messages are light while the menu is dark.**
This is expected: Windows doesn't apply dark mode to message boxes.

## Optional: compile to an .exe

If you'd rather not keep AutoHotkey installed, you can turn the script into a standalone program:

1. Open **Ahk2Exe** (included with AutoHotkey; search for it in the Start menu).
2. Select `game_dropdown.ahk` as the source and click **Convert**.
3. Point your desktop shortcut at the new `.exe` instead.

## How it works

The script reads every `.lnk`, `.url` and `.exe` file in the games folder, sorts them by name, and builds a menu. For each entry it finds the right icon: from the shortcut's properties for `.lnk` files, from the `IconFile` entry for `.url` files (which Steam uses), or from the program itself for `.exe` files. When you click an item, the script launches it with `Run()` and exits, so nothing is left running in the background.
