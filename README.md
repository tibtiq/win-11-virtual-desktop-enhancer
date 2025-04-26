# Windows 11 Virtual Desktop Enhancer (AutoHotkey v2)

This is a new implementation of  for Windows 11 using AutoHotkey v2.
The original project was designed for Windows 10 and AutoHotkey v1, but this version has been completely rewritten to work with the latest Windows and AutoHotkey versions.

This project started as a fork of [win-10-virtual-desktop-enhancer](https://github.com/sdias/win-10-virtual-desktop-enhancer), but has been completely rewritten for Windows 11 using AutoHotkey v2.
It is now an independent project, fully redesigned and reimplemented from scratch.

## Introduction

Windows 11 Virtual Desktop Enhancer is an [AutoHotkey v2](https://www.autohotkey.com/) script which adds some useful features to Windows 11 Virtual Desktops, like:

### Keyboard Shortcuts

- Switch between desktops using customizable keyboard shortcuts
- Move windows between desktops with keyboard shortcuts
- Pin/unpin windows or applications to all desktops
- Quick access to desktop manager
- Support for up to 10 virtual desktops

### Desktop Customization

- Set custom names for each virtual desktop
- Assign different wallpapers to each desktop
  - Support for image files (JPG, PNG, BMP)
  - Support for solid colors using hex color codes
- Customizable tooltips showing desktop names when switching
  - Adjustable position, font size, colors, and duration
  - Support for multiple monitor setups

### Tray Icon

- Display current desktop number in the system tray
  - Custom icons for each desktop number
- Show desktop name in tooltip when hovering over the tray icon
- Quick access menu for common functions
  - Edit settings
  - Edit desktop names
  - Change wallpaper
  - Reload script
  - Exit application

### Settings

- All settings are configurable through INI files
- Keyboard shortcuts can be fully customized
- Tooltip appearance and behavior can be adjusted
- Desktop wrapping can be enabled/disabled

## Main resources

- [Installation](docs/installation.md)
- [Customization](docs/settings.md)

## Installation

Windows 11 Virtual Desktop Enhancer is AutoHotkey v2 script.

Please read [the installation page](docs/installation.md) for more detailed instructions.

## Customization

Windows 11 Virtual Desktop Enhancer is built to be customizable and to adapt to your needs: learn how to personalize your experience [here](docs/settings.md).

## License

Windows 11 Virtual Desktop Enhancer is licensed under the [MIT license](https://github.com/mogya/win-11-virtual-desktop-enhancer/blob/master/LICENSE).  
This means you are free to modify and redistribute this program as you wish, but you must include the license and this notice in your version.

## Unimplemented Features

To keep this version maintainable and focused on core functionalities, the following features that existed in the AutoHotkey v1 version have been intentionally omitted:

- Program execution when switching desktops
- Taskbar scroll switching
- Dynamic desktop name changes through popup
- Advanced window focus control
- Native desktop switching shortcut conflict handling
- Default desktop setting
- Detailed tooltips for pin/unpin operations

If you find any of these features essential for your use case, please open an issue or submit a pull request explaining your need in detail.

## Credits

This project was originally forked from [win-10-virtual-desktop-enhancer](https://github.com/sdias/win-10-virtual-desktop-enhancer) by sdias (Sergio Dias).
Although it has been completely rewritten for Windows 11 and AutoHotkey v2, we would like to acknowledge and thank sdias for the inspiration.

Thanks also to Ciantic (Jari Pennanen) for his library and sample AHK script, which can be found [here](https://github.com/Ciantic/VirtualDesktopAccessor).
