## Brainstorm

- ctrl-shift as main super key

## Keybinds

```kdl
keybinds {
  // optional: remove default Alt-based pane movement/new pane
  unbind "Alt h" "Alt j" "Alt k" "Alt l" "Alt n"

  shared_except "locked" {
    // Vim-style navigation, always available
    bind "Ctrl Shift h" { MoveFocusOrTab "Left"; }
    bind "Ctrl Shift j" { MoveFocus "Down"; }
    bind "Ctrl Shift k" { MoveFocus "Up"; }
    bind "Ctrl Shift l" { MoveFocusOrTab "Right"; }

    // pane/tab actions
    bind "Ctrl Shift n" { NewPane; }
    bind "Ctrl Shift t" { NewTab; }

    // open a tab already named "heavy"
    bind "Ctrl Shift y" {
      NewTab {
        name "heavy"
      }
    }

    bind "Ctrl Shift x" { CloseFocus; }
    bind "Ctrl Shift Enter" { ToggleFloatingPanes; }
  }
}


```
