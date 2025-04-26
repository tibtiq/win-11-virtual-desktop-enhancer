#Requires AutoHotkey v2.0
#Include logger.ah2

class DesktopManager {
    static hVirtualDesktopAccessor := 0
    static GetDesktopCountProc := 0
    static GoToDesktopNumberProc := 0
    static GetCurrentDesktopNumberProc := 0
    static MoveWindowToDesktopNumberProc := 0
    static IsWindowOnDesktopNumberProc := 0
    static IsPinnedWindowProc := 0
    static PinWindowProc := 0
    static UnPinWindowProc := 0
    static IsPinnedAppProc := 0
    static PinAppProc := 0
    static UnPinAppProc := 0
    static GetDesktopNameProc := 0
    static SetDesktopNameProc := 0
    static RegisterPostMessageHookProc := 0
    static UnregisterPostMessageHookProc := 0

    static Initialize() {
        try {
            VDA_PATH := A_ScriptDir . ".\libraries\VirtualDesktopAccessor.dll"
            if (!FileExist(VDA_PATH)) {
                LogError("VirtualDesktopAccessor.dll not found at: " . VDA_PATH)
                throw Error("VirtualDesktopAccessor.dll not found")
            }

            this.hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", VDA_PATH, "Ptr")
            if (!this.hVirtualDesktopAccessor) {
                LogError("Failed to load VirtualDesktopAccessor.dll")
                throw Error("Failed to load VirtualDesktopAccessor.dll")
            }

            this.GetDesktopCountProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "GetDesktopCount",
                "Ptr")
            this.GoToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "GoToDesktopNumber", "Ptr")
            this.GetCurrentDesktopNumberProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "GetCurrentDesktopNumber", "Ptr")
            this.MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "MoveWindowToDesktopNumber", "Ptr")
            this.IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "IsWindowOnDesktopNumber", "Ptr")
            this.IsPinnedWindowProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "IsPinnedWindow",
                "Ptr")
            this.PinWindowProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr", "PinWindow",
                "Ptr")
            this.UnPinWindowProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "UnPinWindow",
                "Ptr")
            this.IsPinnedAppProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "IsPinnedApp",
                "Ptr")
            this.PinAppProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr", "PinApp", "Ptr")
            this.UnPinAppProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr", "UnPinApp",
                "Ptr")
            this.GetDesktopNameProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "GetDesktopName",
                "Ptr")
            this.SetDesktopNameProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "SetDesktopName",
                "Ptr")
            this.RegisterPostMessageHookProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "RegisterPostMessageHook", "Ptr")
            this.UnregisterPostMessageHookProc := DllCall("GetProcAddress", "Ptr", this.hVirtualDesktopAccessor, "AStr",
                "UnregisterPostMessageHook", "Ptr")
        } catch as e {
            MsgBox("Failed to initialize DLL functions. Error: " . e.Message, "Error", "Icon!")
            ExitApp(1)
        }
    }

    static GetDesktopCount() {
        return DllCall(this.GetDesktopCountProc, "Int")
    }

    static GetCurrentDesktopNumber() {
        return DllCall(this.GetCurrentDesktopNumberProc, "Int") + 1  ; DesktopNumber index is 0-based
    }

    static GoToDesktopNumber(num) {
        try {
            result := DllCall(this.GoToDesktopNumberProc, "Int", num - 1, "Int")
            if (result = 0) {
                LogError("Failed to switch to desktop " . num)
                return false
            }
            return true
        } catch as e {
            LogError("Error in GoToDesktopNumber: " . e.Message)
            return false
        }
    }

    static MoveWindowToDesktopNumber(hwnd, num) {
        try {
            result := DllCall(this.MoveWindowToDesktopNumberProc, "Ptr", hwnd, "Int", num - 1, "Int")
            if (result = 0) {
                LogError("Failed to move window to desktop " . num)
                return false
            }
            return true
        } catch as e {
            LogError("Error in MoveWindowToDesktopNumber: " . e.Message)
            return false
        }
    }

    static IsWindowOnDesktopNumber(hwnd, num) {
        return DllCall(this.IsWindowOnDesktopNumberProc, "Ptr", hwnd, "Int", num - 1, "Int")
    }

    static IsPinnedWindow(hwnd) {
        return DllCall(this.IsPinnedWindowProc, "Ptr", hwnd, "Int")
    }

    static PinWindow(hwnd) {
        DllCall(this.PinWindowProc, "Ptr", hwnd, "Int")
    }

    static UnPinWindow(hwnd) {
        DllCall(this.UnPinWindowProc, "Ptr", hwnd, "Int")
    }

    static IsPinnedApp(hwnd) {
        return DllCall(this.IsPinnedAppProc, "Ptr", hwnd, "Int")
    }

    static PinApp(hwnd) {
        DllCall(this.PinAppProc, "Ptr", hwnd, "Int")
    }

    static UnPinApp(hwnd) {
        DllCall(this.UnPinAppProc, "Ptr", hwnd, "Int")
    }

    static GetDesktopName(num) {
        return DllCall(this.GetDesktopNameProc, "Int", num - 1, "Str")
    }

    static SetDesktopName(num, name) {
        return DllCall(this.SetDesktopNameProc, "Int", num - 1, "Str", name, "Int")
    }

    static RegisterPostMessageHook(hwnd) {
        DllCall(this.RegisterPostMessageHookProc, "Int", hwnd, "Int", 0x1400 + 30)
    }

    static UnregisterPostMessageHook(hwnd) {
        DllCall(this.UnregisterPostMessageHookProc, "Int", hwnd)
    }
}
