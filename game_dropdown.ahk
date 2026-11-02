#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; ===== Settings =====
GamesDir := A_MyDocuments "\Games Shortcuts"   ; folder that holds the game shortcuts
IconSize := 32                                  ; icon size in the menu (pixels)
Theme := "dark"                                 ; "dark", "light", or "auto" (match Windows)

chosen := 0
ApplyMenuTheme(Theme)

; First run: create the folder and open it so shortcuts can be moved in
if !DirExist(GamesDir) {
    DirCreate(GamesDir)
    MsgBox("I've made a folder for your game shortcuts:`n`n" GamesDir
        . "`n`nMove your game shortcuts into it, then open Games again.", "Games")
    Run(GamesDir)
    ExitApp()
}

; Collect shortcuts (.lnk, .url, .exe), sorted by name
names := ""
paths := Map()
Loop Files GamesDir "\*.*" {
    if !(A_LoopFileExt ~= "i)^(lnk|url|exe)$")
        continue
    name := RegExReplace(A_LoopFileName, "\.[^.]*$")
    paths[name] := A_LoopFileFullPath
    names .= name "`n"
}

if (names = "") {
    MsgBox("There are no shortcuts in:`n`n" GamesDir "`n`nDrop some game shortcuts in there and try again.", "Games")
    Run(GamesDir)
    ExitApp()
}

games := StrSplit(Sort(RTrim(names, "`n")), "`n")

; Build the menu
m := Menu()
for name in games {
    m.Add(StrReplace(name, "&", "&&"), PickGame)
    SetGameIcon(m, A_Index, paths[name])
}
m.Add()
m.Add("Open games folder", PickGame)

; Show it at the mouse (right where the desktop icon is)
m.Show()
Sleep(100)   ; give the click a moment to register

if (chosen >= 1 && chosen <= games.Length) {
    try Run(paths[games[chosen]])
} else if (chosen = games.Length + 2) {
    Run(GamesDir)
}

ExitApp()

; ===== Functions =====
PickGame(ItemName, ItemPos, *) {
    global chosen := ItemPos
}

; Switches this script's menus to dark or light.
; Uses two hidden Windows functions (in uxtheme.dll) that File Explorer uses for its own dark menus.
ApplyMenuTheme(theme) {
    modes := Map("auto", 1, "dark", 2, "light", 3)   ; 1 = follow Windows, 2 = force dark, 3 = force light
    mode := modes.Has(theme) ? modes[theme] : 1
    try {
        uxtheme := DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr")
        SetPreferredAppMode := DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr")
        FlushMenuThemes     := DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr")
        DllCall(SetPreferredAppMode, "Int", mode)
        DllCall(FlushMenuThemes)
    }
}

SetGameIcon(m, pos, file) {
    iconFile := "", iconNum := 1, target := ""
    try {
        if (file ~= "i)\.lnk$") {
            FileGetShortcut(file, &target, , , , &iconFile, &iconNum)
            if (iconFile = "")
                iconFile := target, iconNum := 1
        } else if (file ~= "i)\.url$") {
            ; Steam and other web-style shortcuts store their icon here
            iconFile := IniRead(file, "InternetShortcut", "IconFile", "")
            idx := Integer(IniRead(file, "InternetShortcut", "IconIndex", 0))
            iconNum := idx < 0 ? idx : idx + 1
        } else {
            iconFile := file
        }
        if (iconNum = "" || iconNum = 0)
            iconNum := 1
        if (iconFile != "")
            m.SetIcon(pos "&", iconFile, iconNum, IconSize)
    }
}
