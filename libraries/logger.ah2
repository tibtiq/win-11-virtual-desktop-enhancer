#Requires AutoHotkey v2.0

LogError(message) {
    try {
        timestamp := FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss")
        logMessage := "[" . timestamp . " UTC] " . message . "`n"
        FileAppend(logMessage, A_ScriptDir . "\error.log", "UTF-8")
    } catch as e {
        ; if failed to write to error log, notify with MsgBox
        MsgBox("Failed to write to error log.`nError: " . e.Message, "Error", "Icon!")
    }
}

; clear error log
ClearErrorLog() {
    try {
        FileDelete(A_ScriptDir . "\error.log")
    } catch as e {
        MsgBox("Failed to clear error log.`nError: " . e.Message, "Error", "Icon!")
    }
}
