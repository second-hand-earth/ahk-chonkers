#Requires AutoHotkey v2.0

; keep track of running state.
isRunning := false

sleep_click := 300

F8::
{
    global isRunning, sleep_click
    
    CoordMode "Pixel", "Screen"
    CoordMode "Mouse", "Screen"

    if isRunning {
        Pause -1
    } else {
        isRunning := true
        ClickOnDistraction
        SetTimer ClickOnDistraction, sleep_click
    }


}

ClickOnDistraction() {
    if PixelSearch(&x, &y, 0, A_ScreenHeight * 0.1, A_ScreenWidth, A_ScreenHeight, 0xEECEDF)
        Click x, y  ; clicks near-red pixels
}

Esc::ExitApp