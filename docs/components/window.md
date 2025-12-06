# Window

The `Window` is the main container for your UI.  
It can hold tabs, sections, and other components.

## Example

```lua
local window = SeizureUI:CreateWindow({
    Title = "Main Window",
    Size = Vector2.new(400, 300),
    Theme = "Dark"
})
