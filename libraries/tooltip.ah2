#Requires AutoHotkey v2.0
#Include logger.ah2

class TooltipManager {
    static tooltipGui := 0
    static tooltipFadeOutTimer := 0

    static Initialize() {
        this.tooltipGui := 0
        this.tooltipFadeOutTimer := 0
    }

    static ShowTooltipOnMonitor(monitorNo, text) {
        try {
            monitorCount := MonitorGetCount()

            if (monitorNo > monitorCount) {
                LogError("Monitor number " . monitorNo . " is out of range. Total monitors: " . monitorCount)
                return false
            }

            MonitorGet(monitorNo, &left, &top, &right, &bottom)

            if (right <= left || bottom <= top) {
                LogError("Invalid monitor coordinates for monitor " . monitorNo .
                    " - Right must be greater than left, and bottom must be greater than top")
                return false
            }

            monitorWidth := right - left
            monitorHeight := bottom - top

            if (monitorWidth <= 0 || monitorHeight <= 0) {
                LogError("Invalid monitor dimensions for monitor " . monitorNo . " - Width: " . monitorWidth .
                    ", Height: " .
                    monitorHeight)
                return false
            }

            if (this.tooltipGui) {
                this.tooltipGui.Destroy()
            }

            this.tooltipGui := Gui("+ToolWindow -Caption +AlwaysOnTop +E0x20")
            this.tooltipGui.BackColor := TooltipsBackgroundColor
            this.tooltipGui.SetFont("s" . TooltipsFontSize . " w" . TooltipsFontInBold, "Segoe UI")
            textControl := this.tooltipGui.Add("Text", "c" . TooltipsFontColor, text)

            textControl.GetPos(, , &textWidth, &textHeight)

            tooltipX := left + (monitorWidth - textWidth) / 2
            tooltipY := top + (monitorHeight - textHeight) / 2

            this.tooltipGui.Show("x" . tooltipX . " y" . tooltipY)
            if (this.tooltipFadeOutTimer) {
                SetTimer(this.tooltipFadeOutTimer, 0)
            }
            this.tooltipFadeOutTimer := SetTimer((*) => this.FadeOutTooltip(TooltipsFadeOutAnimationDuration), -
            TooltipsLifespan)
        } catch as e {
            LogError("Failed to show tooltip on monitor " . monitorNo . ". Error: " . e.Message . " Line: " . e.Line .
                " File: " . e.File)
            return false
        }
        return true
    }

    static FadeOutTooltip(duration) {
        startTime := A_TickCount
        startOpacity := 255
        while (A_TickCount - startTime < duration) {
            try {
                opacity := Round(startOpacity * (1 - (A_TickCount - startTime) / duration))
                WinSetTransparent(opacity, this.tooltipGui)
                Sleep(10)
            } catch {
                return  ; tooltip is already destroyed
            }
        }
        try {
            this.tooltipGui.Destroy()
        } catch {
            return  ; tooltip is already destroyed
        }
    }

    static ShowTooltipOnAllMonitors(text) {
        loop MonitorGetCount() {
            this.ShowTooltipOnMonitor(A_Index, text)
        }
    }
}
