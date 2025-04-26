# Personalize the settings

You can customize various parameters in the `settings.ini` file to make the program behave exactly as you want.

## Table of contents

<!-- TOC -->

- [Main settings](#main-settings)
- [Tooltips](#tooltips)
- [Keyboard shortcuts](#keyboard-shortcuts)
- [Planned features](#planned-features)

<!-- /TOC -->

Click here to go back to the [README](../README.md).

## Main settings

The main settings are found in the `[General]` section of the `settings.ini` file.

| Setting         | Description                                                                           | Valid Values                               |
| --------------- | ------------------------------------------------------------------------------------- | ------------------------------------------ |
| DesktopWrapping | If going right from the last desktop should take you to the first one and vice-versa. | `1`, `0` (Meaning YES and NO respectively) |

## Tooltips

If you enable this feature, a tooltip will appear every time you switch desktops, showing the name of the desktop you switched to.

You can customize the appearance of these tooltips by editing the settings in the `[Tooltips]` section of the `settings.ini` file:

| Setting                  | Description                                                                  | Valid Values                                  |
| ------------------------ | ---------------------------------------------------------------------------- | --------------------------------------------- |
| Enabled                  | If tooltips should be shown.                                                 | `1`, `0` (Meaning YES and NO respectively)    |
| PositionX                | The horizontal position of the tooltip on the monitor.                       | LEFT, CENTER, RIGHT                           |
| PositionY                | The vertical position of the tooltip on the monitor.                         | TOP, CENTER, BOTTOM                           |
| FontSize                 | The size of the font.                                                        | Any reasonable number                         |
| FontColor                | The color of the font.                                                       | Any hexadecimal number (from 0x0 to 0xFFFFFF) |
| FontInBold               | If the font should be in bold.                                               | `1`, `0` (Meaning YES and NO respectively)    |
| BackgroundColor          | The color of the background.                                                 | Any hexadecimal number (from 0x0 to 0xFFFFFF) |
| Lifespan                 | The time in milliseconds for which each tooltip will be displayed.           | Any reasonable number                         |
| FadeOutAnimationDuration | The duration of the FadeOut animation in milliseconds.                       | Any reasonable number (best if less than 500) |
| OnEveryMonitor           | If the tooltips should be shown on every monitor or just on the primary one. | `1`, `0` (Meaning YES and NO respectively)    |

### Example configuration

Here is the default configuration:

```ini
[Tooltips]
Enabled=1
PositionX=CENTER
PositionY=CENTER
FontSize=11
FontColor=0xFFFFFF
FontInBold=1
BackgroundColor=0x1F1F1F
Lifespan=750
FadeOutAnimationDuration=100
OnEveryMonitor=1
```

## Keyboard shortcuts

You can configure your own keyboard shortcuts to perform various actions. A shortcut is composed of modifier keys and an identifier key.

### Modifier keys

Modifier keys can be any combination of:

- `Ctrl`
- `Shift`
- `Alt`
- `Win`

### Available shortcuts

#### Desktop switching actions

| Action                            | Modifier Key Setting           | Identifier Key Setting                                                                 |
| --------------------------------- | ------------------------------ | -------------------------------------------------------------------------------------- |
| Switch to desktop                 | `SwitchDesktop`                | `PreviousDesktop`, `NextDesktop`, `Desktop1`-`Desktop10`, `DesktopAlt1`-`DesktopAlt10` |
| Move window to desktop            | `MoveWindowToDesktop`          | `PreviousDesktop`, `NextDesktop`, `Desktop1`-`Desktop10`                               |
| Move window and switch to desktop | `MoveWindowAndSwitchToDesktop` | `PreviousDesktop`, `NextDesktop`, `Desktop1`-`Desktop10`                               |

#### Other actions

| Action               | Shortcut Setting     |
| -------------------- | -------------------- |
| Open desktop manager | `OpenDesktopManager` |
| Toggle pin window    | `TogglePinWindow`    |
| Toggle pin app       | `TogglePinApp`       |
| Pin window           | `PinWindow`          |
| Unpin window         | `UnPinWindow`        |
| Pin app              | `PinApp`             |
| Unpin app            | `UnPinApp`           |

### Example configuration

Here is the default configuration:

```ini
[KeyboardShortcuts]
; Modifier keys for desktop switching actions
SwitchDesktop=Win
MoveWindowToDesktop=Win,Ctrl
MoveWindowAndSwitchToDesktop=

; Identifier keys for desktop switching
PreviousDesktop=Left
NextDesktop=Right
Desktop1=1
Desktop2=2
Desktop3=3
Desktop4=4
Desktop5=5
Desktop6=6
Desktop7=7
Desktop8=8
Desktop9=9
Desktop10=0

; Alternative identifier keys
DesktopAlt1=F1
DesktopAlt2=F2
DesktopAlt3=F3
DesktopAlt4=F4
DesktopAlt5=F5
DesktopAlt6=F6
DesktopAlt7=F7
DesktopAlt8=F8
DesktopAlt9=F9
DesktopAlt10=F10

; Other shortcuts
OpenDesktopManager=Ctrl,Win,D
TogglePinWindow=Ctrl,Win,P
TogglePinApp=Ctrl,Shift,Win,P
PinWindow=Ctrl,Win,Shift,P
UnPinWindow=Ctrl,Win,Alt,P
PinApp=Ctrl,Win,Shift,A
UnPinApp=Ctrl,Win,Alt,A
```

## Desktop names

You can assign custom names to each virtual desktop. The name will be shown in tooltips when switching desktops.

### Example configuration

Here is an example of a working configuration:

```ini
[1]
name=Work
[2]
name=Games
[3]
name=Movies
[4]
name=Presentations
```

## Wallpapers

You can set a custom wallpaper (either an image or a solid color) for each virtual desktop.

### Image wallpapers

You can set an image file as wallpaper by specifying its path. The path can be absolute (e.g., `C:\Wallpapers\Default.jpg`) or relative to the script directory.

### Solid color wallpapers

You can set a solid color as wallpaper by specifying its hexadecimal RGB code (e.g., `0xFF0000` for red).

### Example configuration

Here is an example of a working configuration:

```ini
[1]
path=C:\Wallpapers\Default.jpg
[2]
path=0xFF0000
[3]
path=..\images\Email.jpg
```
