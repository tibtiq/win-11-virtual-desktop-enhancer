#Requires AutoHotkey v2.0
#Include logger.ah2

class WallpaperManager {
    static wallpapers := Map()

    static Initialize() {
        this.Load()
        this.ValidateWallpapers()
    }

    static Load() {
        this.wallpapers := Map()
        if (FileExist(A_ScriptDir . "\wallpapers.ini")) {
            currentSection := ""
            loop read, A_ScriptDir . "\wallpapers.ini" {
                line := Trim(A_LoopReadLine)
                if (line = "")
                    continue
                if (RegExMatch(line, "^\[(\d+)\]$", &match)) {
                    currentSection := match[1]  ; string
                } else if (RegExMatch(line, "^path=(.+)$", &match) && currentSection != "") {
                    this.wallpapers[currentSection] := match[1]
                }
            }
        }
    }

    static ValidateWallpapers() {
        for num, path in this.wallpapers {
            if (path != "" && !FileExist(path) && !RegExMatch(path, "^0x[0-9A-Fa-f]{1,6}$")) {
                MsgBox("Invalid wallpaper path for desktop " . num . ": " . path, "Warning", "Icon!")
                this.wallpapers[num] := ""
                this.Save()
            }
        }
    }

    static Save() {
        ini := ""
        for num, path in this.wallpapers {
            ini .= "[" . num . "]`n"
            ini .= "path=" . path . "`n`n"
        }
        try {
            FileDelete(A_ScriptDir . "\wallpapers.ini")
            FileAppend(ini, A_ScriptDir . "\wallpapers.ini", "UTF-8")
        } catch as e {
            LogError("Failed to save wallpapers. Error: " . e.Message . " File: " . A_ScriptDir . "\wallpapers.ini")
            return false
        }
        return true
    }

    static SetWallpaper(num, path) {
        numStr := String(num)
        this.wallpapers[numStr] := path
        this.Save()
    }

    static GetWallpaper(num) {
        numStr := String(num)
        if (this.wallpapers.Has(numStr))
            return this.wallpapers[numStr]
        return ""
    }

    static SetDesktopWallpaper(path) {
        try {
            if (RegExMatch(path, "^0x([0-9A-Fa-f]{1,6})$", &hexMatch)) {
                hexColor := hexMatch[1]
                while (StrLen(hexColor) < 6) {
                    hexColor := "0" . hexColor
                }
                bgrColor := "0x" . SubStr(hexColor, 5, 2) . SubStr(hexColor, 3, 2) . SubStr(hexColor, 1, 2)
                bgrColor := Integer(bgrColor)

                result := DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", "", "UInt", 1)
                if (!result) {
                    LogError("Failed to set solid color wallpaper")
                    return false
                }
                result := DllCall("SetSysColors", "Int", 1, "Int*", 1, "UInt*", bgrColor)
                if (!result) {
                    LogError("Failed to set system color")
                    return false
                }
            } else if (FileExist(path)) {
                result := DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", path, "UInt", 1)
                if (!result) {
                    LogError("Failed to set wallpaper: " . path)
                    return false
                }
            } else {
                LogError("Invalid wallpaper path: " . path)
                return false
            }
            return true
        } catch as e {
            LogError("Error in SetDesktopWallpaper: " . e.Message)
            return false
        }
    }

    static ShowEditor() {
        currentDesktopNumber := GetCurrentDesktopNumber()
        currentWallpaper := this.GetWallpaper(currentDesktopNumber)

        try {
            wallpaperGui := Gui("+Resize +MinSize400x200", "Change Wallpaper")
            wallpaperGui.OnEvent("Close", Gui_Close)
            wallpaperGui.OnEvent("Escape", Gui_Close)

            wallpaperGui.Add("Text", "x10 y10", "Current wallpaper:")
            wallpaperGui.Add("Edit", "x10 y30 w300 ReadOnly", currentWallpaper)

            wallpaperGui.Add("Button", "x10 y60 w300", "Browse...").OnEvent("Click", BrowseButton_Click)
            wallpaperGui.Add("Button", "x10 y90 w300", "Remove").OnEvent("Click", RemoveButton_Click)
            wallpaperGui.Add("Button", "x10 y120 w300", "Save").OnEvent("Click", SaveButton_Click)

            wallpaperGui.Add("Text", "x10 y160", "Or enter a color code (e.g., 0xFF0000 for red):")
            colorInput := wallpaperGui.Add("Edit", "x10 y180 w300", "")
            colorInput.OnEvent("Change", ColorInput_Change)

            BrowseButton_Click(*) {
                try {
                    selectedFile := FileSelect(1, , "Select Wallpaper", "Image Files (*.jpg; *.jpeg; *.png; *.bmp)")
                    if (selectedFile) {
                        wallpaperGui["Edit1"].Value := selectedFile
                        colorInput.Value := ""
                    }
                } catch as e {
                    LogError("Failed to browse for wallpaper. Error: " . e.Message)
                }
            }

            RemoveButton_Click(*) {
                wallpaperGui["Edit1"].Value := ""
                colorInput.Value := ""
            }

            ColorInput_Change(*) {
                if (RegExMatch(colorInput.Value, "^0x[0-9A-Fa-f]{1,6}$")) {
                    wallpaperGui["Edit1"].Value := colorInput.Value
                }
            }

            SaveButton_Click(*) {
                newPath := wallpaperGui["Edit1"].Value
                this.SetWallpaper(currentDesktopNumber, newPath)
                if (newPath != "") {
                    if (!this.SetDesktopWallpaper(newPath)) {
                        LogError("Failed to set desktop wallpaper: " . newPath)
                    }
                }
                wallpaperGui.Destroy()
            }

            Gui_Close(*) {
                wallpaperGui.Destroy()
            }

            wallpaperGui.Show()
        } catch as e {
            LogError("Failed to create wallpaper changer GUI. Error: " . e.Message)
        }
    }
}
