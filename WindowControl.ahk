; Simple program to add more control over a window
; Instructions:
; F1 = Toggle "AlwaysOnTop" of window
; F2 = Change Opacity of window
; F3 = Set window as "Anchor"
; F4 = Exit

; Notes: 
; RIPY was here.
; BoxFoe was here.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent

ToolTip, [ON]`nF1 = Toggle "AlwaysOnTop" of window`nF2 = Change Opacity of window`nF3 = Set window as "Anchor" `nF4 = Exit`n`nRead the [README.txt] for more infos!,
SetTimer, RemoveToolTip, -10000

CoordMode, mouse, Screen ; MouseGetPos is fucky wacky without.

CurrentWindow = "" ; used around to define the current window before an action
AnchorWindow = "" ; used to define the anchor window, a window that you can give focus temporary

Gui, +AlwaysOnTop
Gui, Add, Text, w255 vOpacityValueText, %Opacity%
Gui, Add, Slider, w255 vOpacityValueSlider gUpdateOpacity Range32-255 altsubmit, %Opacity%

/*
HELLO! you seems to be looking at the code! proud of you!
in case you wish to make an edit, i hope the comments are enough to understand whats going on.
I leave here some code templates  in case you need it: (put them under this section).

;Sends the equivalent [Arrow key] input.
!W::
	Send {Up}
	return

; send the input to the anchor window, without it beign on focus, works well enough with browser stuff, but with applications it works rarely.
#Up::
	ControlSend,ahk_parent, {Up},ahk_id %AnchorWindow%    
	return

; move AnchorWindow window 25 pixels right
!#right::
	wingetpos x, y,,, ahk_id %AnchorWindow%   ; get coordinates of the active window
	x += 25			  ; add 25 to the x coordinate
	winmove, ahk_id %AnchorWindow%,,%x%, %y%  ; make the active window use the new coordinates
	return				  ; finish


; Send any input to the anchor window
!#Z::
ToolTip, [Anchor send-inputs mode ON]`n[Press [ESC] to exit],
SetTimer, RemoveToolTip, -2500
While ( 1 ) { ; loop
	Input, SingleKey, L1 E M, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
	IfInString, ErrorLevel, EndKey:
	{
		StringTrimLeft, SingleKey, ErrorLevel, 7
		if ( SingleKey = "Escape" ) { 
			break 
		}
		else if ( SingleKey = "F4" ) { 
			SetTimer, ExitQuit, -1
			return
		}
		else if ( SingleKey = "F1" ) { 
			ToolTip, [Escape next character]
			SetTimer, RemoveToolTip, -500
			Input, SingleKey, L1 E M,
			Send {%SingleKey%}
			continue
		}
		ControlSend,ahk_parent, {%SingleKey%},ahk_id %AnchorWindow% 
	}
	else
		ControlSend,ahk_parent, %SingleKey%,ahk_id %AnchorWindow%  
}
ToolTip, [Anchor send-inputs mode OFF],
SetTimer, RemoveToolTip, -500
return


*/

; ----- ALWAYS ON TOP TOGGLE --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[

F1:: 
Winset, AlwaysOnTop, , A
WinGet, ExStyle, ExStyle, A
if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST (always on top).
	ToolTip, [AlwaysOnTop ON],
else
	ToolTip, [AlwaysOnTop OFF],
SetTimer, RemoveToolTip, -5000
return

; ----- SET OPACITY -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[

#MaxThreadsPerHotkey 2 ; To be able to have both "close on lost focus" and "close on pressing f2"
F2:: 
if (WinExist("Set Opacity")) { ; Close the GUI if F2 is pressed again
	Gui, Cancel
	return
}

WinGet, CurrentWindow, ID, A ; Get the Window ID
WinGet, Transparent, Transparent, ahk_id %CurrentWindow% ; Get the Opacity value of the window

; Gui objects setup.
if(!Transparent) ; if Opacity = Off (which is basicly 255)
{
	GuiControl,, OpacityValueSlider, 255
	GuiControl,, OpacityValueText, Off
} 
else 
{
	GuiControl,, OpacityValueSlider, %Transparent%
	GuiControl,, OpacityValueText, %Transparent%
}

; Show Gui at mouse cord.
MouseGetPos, xpos, ypos
Gui, Show, x%xpos% y%ypos%, Set Opacity

; Close on lost focus
WinWaitNotActive, Set Opacity
Gui, Cancel
return

; ----- ANCHOR ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[

; Set anchor
#MaxThreadsPerHotkey 1
F3:: 
WinGet, AnchorWindow, ID, A ; Get the Window ID
ToolTip, [Anchor SET],
SetTimer, RemoveToolTip, -5000
return

; Bring anchor to focus
#Z::
WinGet, CurrentWindow, ID, A ; Get the Window ID
WinActivate, ahk_id %AnchorWindow% 
While ( GetKeyState( "Z","P" ) ) { ; While "Z" is pressed, just loop until its not.
		Sleep, 5
		if ( GetKeyState( "Ctrl","P" ) ) { ; if pressed Ctrl, the window will remain open, just alt-tab to get to the previous one
			return
		}
	}
WinActivate, ahk_id %CurrentWindow%   
return

; Anchor hotkeys:
#Space::
	ControlSend,ahk_parent, {Space},ahk_id %AnchorWindow%    
	return
#Up::
	ControlSend,ahk_parent, {Up},ahk_id %AnchorWindow%    
	return
#Left::
	ControlSend,ahk_parent, {Left},ahk_id %AnchorWindow%    
	return
#Down::
	ControlSend,ahk_parent, {Down},ahk_id %AnchorWindow%    
	return
#Right::
	ControlSend,ahk_parent, {Right},ahk_id %AnchorWindow%    
	return
#W::
	ControlSend,ahk_parent, {Up},ahk_id %AnchorWindow%    
	return
#A::
	ControlSend,ahk_parent, {Left},ahk_id %AnchorWindow%    
	return
#S::
	ControlSend,ahk_parent, {Down},ahk_id %AnchorWindow%    
	return
#D::
	ControlSend,ahk_parent, {Right},ahk_id %AnchorWindow%    
	return

; ----- OTHER ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[

;Sends the equivalent [Arrow key] input.
!W::
	Send {Up}
	return
!A::
	Send {Left}
	return
!S::
	Send {Down}
	return
!D::
	Send {Right}
	return

; ----- CLOSE -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[

F4:: 
SetTimer, ExitQuit, -1
return

; ----- FUNCTIONS -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------[

UpdateOpacity:
if(OpacityValueSlider = 255) ; if Opacity = 255 (which is basicly Off)
{
	GuiControl,, OpacityValueText, 255 (Off)
	WinSet, Transparent, 255, ahk_id %CurrentWindow%
	WinSet, Transparent, Off, ahk_id %CurrentWindow%
} 
else 
{
	GuiControl,, OpacityValueText, %OpacityValueSlider%
	WinSet, Transparent, %OpacityValueSlider%, ahk_id %CurrentWindow%
}
return

RemoveToolTip:
ToolTip
return

ExitQuit:
ToolTip, [OFF],
SetTimer, RemoveToolTip, -500
SetTimer, ExitQuitReal, -500
return
ExitQuitReal:
ExitApp