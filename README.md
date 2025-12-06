# SeizureUI

A lightweight, script-loadable UI library for Roblox developers who want
quick, clean interfaces without building everything from scratch.

## Features

-   Window creation with title bars\a
-   Tabs and tab switching\
-   Buttons, toggles, sliders and basic inputs\
-   Simple theming system\
-   Minimal performance overhead\
-   Designed for easy drop-in use through `loadstring`

## Installation

Load the library at runtime with:

``` lua
local SeizureUI = loadstring(game:HttpGet("YOUR_URL_HERE"))()
```

Replace `YOUR_URL_HERE` with the actual script URL where the library is
hosted.

## Basic Usage

### Create a Window

``` lua
local win = SeizureUI:CreateWindow({
    Title = "My Window",
    Size = UDim2.fromOffset(450, 300)
})
```

### Add a Tab

``` lua
local tab = win:AddTab("Controls")
```

### Add a Button

``` lua
tab:AddButton("Click Me", function()
    print("Button pressed")
end)
```

### Add a Toggle

``` lua
tab:AddToggle("Auto Mode", false, function(state)
    print("Toggle state:", state)
end)
```

## Notes

-   Works only in environments where `loadstring` and `HttpGet` are
    allowed.\
-   Not an official Roblox library. Use at your own risk.\
-   Always inspect the source script before running it.\
-   UI may behave differently depending on exploit environment or Roblox
    updates.

## Credits

Created by the original authors of SeizureUI.\
Edits and forks should credit the source appropriately.
