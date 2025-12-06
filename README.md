# SeizureUI

A lightweight, script-loadable UI library for Roblox developers who want quick, clean interfaces without rebuilding everything from scratch.

## Features

- Window creation with title bars  
- Tabs and tab switching  
- Buttons and toggles
- Minimal performance impact

## Installation

Load the library at runtime:

```lua
local SeizureUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/client0sided/seizure/refs/heads/main/Main.luau"))()
```

### Create a Window

```lua
local win = SeizureUI:CreateWindow({
    Title = "My Window",
    Size = UDim2.fromOffset(450, 300)
})
```

### Add a Tab

```lua
local tab = win:AddTab("Controls")
```

### Add a Button

```lua
tab:AddButton("Click Me", function()
    print("Button pressed")
end)
```

### Add a Toggle

```lua
tab:AddToggle("Auto Mode", false, function(state)
    print("Toggle state:", state)
end)
```

## Notes

- Works only in environments where `loadstring` and `HttpGet` are enabled.  
- Not an official Roblox library; use at your own risk.  
- Always inspect external scripts before running them.  
- UI behavior may vary depending on the exploit environment or Roblox updates.

## Credits

Created by the original developers of SeizureUI.  
Please credit the source appropriately when creating edits or forks.
