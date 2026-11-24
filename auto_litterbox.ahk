#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 2
CoordMode "Mouse", "Screen"

; how many rooms to cycle
total_rooms := 8

; click on distractions?
isClickOnDistractions := true

; location where no cat is selected.
; adjust to include as many playing cats
; adjust to auto click through new discoveries?
distractionsXPercent := 55
distractionsYPercent := 65

click_ms := 200
clicking := false

sleep_room_switch := 100
sleep_close_menu := 100

; litterbox variables
; set litterbox coordinates as % of screen.
; adjust if needed
litterbox_x_percent := 47
litterbox_y_percent := 40

; poop coordinates as %
; adjust if needed
poop_1_x_percent := 52
poop_1_y_percent := 40

poop_2_x_percent := 55
poop_2_y_percent := 49

poop_3_x_percent := 62
poop_3_y_percent := 49

sleep_poop := 305000 ; 5 min reset for poop. +5 second just in case

; close button coordinates as %
close_x_percent := 51
close_y_percent := 60

sleep_litterbox := 600
sleep_poop_click := 250 ; time to wait before clicking on another poop
sleep_close := 2300

; kibble variables
kibble_x_percent := 55
kibble_y_percent := 13

skip_game_x_percent := 91
skip_game_y_percent := 87

sleep_kibble_reset := 15000 ; 2.5 min reset for kibble
sleep_kibble := 600
sleep_kibble_close := 500

; keep track of running state.
isRunning := false

; F6 to start/pause script.
F6::{
    global isRunning, sleep_poop
    if isRunning {
        Pause -1
    } else {
        isRunning := true
        LoopRooms
        SetTimer LoopRooms, sleep_poop
    }
}

ClickAt(xPercent, yPercent) {
    x := Round(A_ScreenWidth * xPercent / 100)
    y := Round(A_ScreenHeight * yPercent / 100)
    Click x, y
}

CleanLitterbox() {
    global litterbox_x_percent, litterbox_y_percent
    global poop_1_x_percent, poop_1_y_percent
    global poop_2_x_percent, poop_2_y_percent
    global poop_3_x_percent, poop_3_y_percent
    global close_x_percent, close_y_percent
    global sleep_litterbox, sleep_poop_click, sleep_close
    global sleep_close_menu

    ClickAt(litterbox_x_percent, litterbox_y_percent)
    Sleep sleep_litterbox
    ClickAt(poop_1_x_percent, poop_1_y_percent)
    Sleep sleep_poop_click
    ClickAt(poop_2_x_percent, poop_2_y_percent)
    Sleep sleep_poop_click
    ClickAt(poop_3_x_percent, poop_3_y_percent)
    Sleep sleep_close
    ClickAt(close_x_percent, close_y_percent)
    Sleep sleep_close_menu
}

RefillKibble() {
    global kibble_x_percent, kibble_y_percent
    global skip_game_x_percent, skip_game_y_percent
    global close_x_percent, close_y_percent
    global sleep_kibble, sleep_close_menu
    global sleep_kibble_close

    ClickAt(kibble_x_percent, kibble_y_percent)
    Sleep sleep_kibble
    ClickAt(skip_game_x_percent, skip_game_y_percent)
    Sleep sleep_kibble_close
    ClickAt(close_x_percent, close_y_percent)
    Sleep sleep_close_menu
}

LoopRooms() {
    global total_rooms, sleep_room_switch, sleep_kibble_reset
    global isClickOnDistractions, clicking

    if clicking {
        SetTimer ClickLoop, 0
        clicking := false
    }

    Loop total_rooms {
        Send A_Index ; press room key
        Sleep sleep_room_switch
        CleanLitterbox()
        RefillKibble()
    }
    ; Box resets at 4.5 min. Kibble resets at 2.5 min. No nice way to do double kibble without shenanigans.
    ;Sleep sleep_kibble_reset ; 2.5 min wait for kibble
    ;RefillKibble()

    if isClickOnDistractions {
        global click_ms, distractionsXPercent, distractionsYPercent
        ClickAt(distractionsXPercent, distractionsYPercent)
        clicking := true
        SetTimer(ClickLoop, clicking ? click_ms : 0) ; click every ? ms
    }
}

ClickLoop() {
    if clicking {
        Click
    } else {
        SetTimer ClickLoop, 0
        return
    }
}


Esc::ExitApp