# get config path for workspaces.toml
def ws-file [] {
  [$env.HOME ".config" "zesh" "zellij-workspaces.toml"] | path join
}

def load-workspaces [] {
  let file = (ws-file)
  if not ($file | path exists) {
    error make { msg: $"Missing config: ($file)" }
  }

  let data = (open $file)
  ($data | get -o workspace | default [])
}

def pick-fzf [rows] {
  let lines = (
    $rows
    | each {|r|
        let layout = ($r | get -o layout | default "")
        $"($r.id)\t(($r.path | path expand))\t($layout)"
      }
    | str join (char nl)
  )

  let picked = (do -i { $lines | ^fzf --delimiter '\t' --with-nth 1,2 --prompt 'workspace> ' } | str trim)
  if ($picked | is-empty) { return null }

  let id = ($picked | split row (char tab) | first)
  ($rows | where id == $id | first)
}

export def ws [
  target?: string   # workspace id or alias
  --list(-l)
  --edit(-e)
] {
  let file = (ws-file)

  if $edit {
    let editor = ($env.EDITOR? | default "hx")
    ^$editor $file
    return
  }

  let rows = (load-workspaces)
  if ($rows | is-empty) {
    error make { msg: $"No [[workspace]] entries in ($file)" }
  }

  if $list {
    $rows
    | each {|r|
        {
          id: $r.id
          path: ($r.path | path expand)
          layout: ($r | get -o layout | default "")
          aliases: (($r | get -o aliases | default []) | str join ", ")
        }
      }
    | sort-by id
    | table
    return
  }

  let selected = if ($target | is-not-empty) {
    let needle = ($target | str downcase)
    let found = (
      $rows | where {|r|
        let id_hit = (($r.id | str downcase) == $needle)
        let alias_hit = (($r | get -o aliases | default []) | any {|a| ($a | str downcase) == $needle })
        $id_hit or $alias_hit
      }
    )

    if ($found | is-empty) {
      error make { msg: $"Unknown workspace: ($target)" }
    }
    $found | first
  } else {
    let p = (pick-fzf $rows)
    if ($p == null) { return }
    $p
  }

  let expanded = ($selected.path | path expand)
  let repo_root = (do -i { ^git -C $expanded rev-parse --show-toplevel } | str trim)
  let root = if ($repo_root | is-empty) { $expanded } else { $repo_root }

  let layout = ($selected | get -o layout | default "" | str trim)
  if ($layout | is-empty) {
    ^zesh connect $root
  } else {
    ^zesh connect -n $layout $root
  }
}
