#Requires AutoHotkey v2.0
#Include logger.ah2

class DesktopNamesManager {
    static desktopNames := Map()
    static MAX_NAME_LENGTH := 50

    static Initialize() {
        this.Load()
        this.ValidateNames()
    }

    static ValidateNames() {
        for num, name in this.desktopNames {
            if (StrLen(name) > this.MAX_NAME_LENGTH) {
                MsgBox("Desktop name for desktop " . num . " is too long (max " . this.MAX_NAME_LENGTH . " characters)",
                    "Warning", "Icon!")
                this.desktopNames[num] := SubStr(name, 1, this.MAX_NAME_LENGTH)
                this.Save()
            }
        }
    }

    static Load() {
        this.desktopNames := Map()
        if (FileExist(A_ScriptDir . "\desktop-names.ini")) {
            currentSection := ""
            loop read, A_ScriptDir . "\desktop-names.ini" {
                line := Trim(A_LoopReadLine)
                if (line = "")
                    continue
                if (RegExMatch(line, "^\[(\d+)\]$", &match)) {
                    currentSection := match[1]
                } else if (RegExMatch(line, "^name=(.+)$", &match) && currentSection != "") {
                    this.desktopNames[currentSection] := match[1]
                }
            }
        } else {
            LogError("Failed to load desktop names. File not found: " . A_ScriptDir . "\desktop-names.ini")
        }
    }

    static GetName(num) {
        numStr := String(num)
        if (this.desktopNames.Has(numStr))
            return this.desktopNames[numStr]
        return "desktop " . num
    }

    static SetName(num, name) {
        numStr := String(num)
        this.desktopNames[numStr] := name
        this.Save()
    }

    static Save() {
        ini := ""
        for num, name in this.desktopNames {
            ini .= "[" . num . "]`n"
            ini .= "name=" . name . "`n`n"
        }
        try {
            FileDelete(A_ScriptDir . "\desktop-names.ini")
            FileAppend(ini, A_ScriptDir . "\desktop-names.ini", "UTF-8")
        } catch as e {
            LogError("Failed to save desktop names. Error: " . e.Message . " File: " . A_ScriptDir .
                "\desktop-names.ini")
            return false
        }
        return true
    }

    static ShowEditor() {
        desktopCount := GetDesktopCount()
        try {
            desktopNamesGui := Gui("+Resize +MinSize250x150", "edit desktop names")
            desktopNamesGui.OnEvent("Size", Gui_Size)
            desktopNamesGui.OnEvent("Close", Gui_Close)
            desktopNamesGui.OnEvent("Escape", Gui_Close)

            loop desktopCount {
                i := A_Index
                iStr := String(i)
                desktopNamesGui.Add("Text", "x10 y" . (30 + (i - 1) * 30), "desktop " . i . ":")
                desktopNamesGui.Add("Edit", "x100 y" . (30 + (i - 1) * 30) . " w200", this.desktopNames.Has(iStr) ?
                    this.desktopNames[iStr] : "")
            }

            desktopNamesGui.Add("Button", "x10 y" . (30 + desktopCount * 30) . " w290", "save").OnEvent("Click",
                SaveButton_Click)

            SaveButton_Click(*) {
                loop desktopCount {
                    i := A_Index
                    iStr := String(i)
                    control := desktopNamesGui["Edit" . i]
                    if (control) {
                        DesktopNamesManager.desktopNames[iStr] := control.Value
                    }
                }
                if (!DesktopNamesManager.Save()) {
                    LogError("Failed to save desktop names in EditDesktopNames")
                }
                desktopNamesGui.Destroy()
            }

            Gui_Size(thisGui, MinMax, Width, Height) {
                if (MinMax = -1)
                    return
                loop desktopCount {
                    i := A_Index
                    control := thisGui["Edit" . i]
                    if (control) {
                        control.Move(, , Width - 110)
                    }
                }
                saveButton := thisGui["Button1"]
                if (saveButton) {
                    saveButton.Move(, Height - 40, Width - 20)
                }
            }

            Gui_Close(*) {
                desktopNamesGui.Destroy()
            }

            desktopNamesGui.Show()
        } catch as e {
            LogError("Failed to create desktop names editor GUI. Error: " . e.Message . " Line: " . e.Line)
        }
    }
}
