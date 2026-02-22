## solo workflow

`jj new`: start changes from a certain commit (default @)
`jj edit`: go back to a checkpoint, current changes are associated to current @
`jj describe`: give a checkpoint a description (easier to come back to later)
`jj abandon`: discard checkpoint and its changes

## when ready, want to set new checkpoint

`jj diff`: review changes
`jj commit -m "feat: add thing"`: combines `jj describe` and `jj new`

## want to share with others (think branches)

`jj bookmark create my-feature -r @-`
`jj bookmark track my-feature`: add branch to remote, else local only by default
`jj git push`

## sync remote branch to new checkpoint

`jj rebase -d main`: rebase current checkpoint onto main, '-d' for destination

## sync current checkpoint with main

`jj bookmark move app_ui --to @-`
`jj git push --bookmark app_ui`

## cleaning up checkpoints

- `jj squash --into @-`: push current changes into previous checkpoint
