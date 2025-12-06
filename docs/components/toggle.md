
---

## **components/toggle.md**
```markdown
# Toggle

Toggles are switches with boolean states.

## Example

```lua
tab:AddToggle("Enable Feature", false, function(state)
    print("Toggle state:", state)
end)
