# jj (Jujutsu VCS) Practical Cheat Sheet — beginner-friendly project workflows

A “copy/paste first” guide to getting productive with **jj** in real repos: making commits, fixing earlier commits, stacking PRs, and pushing to GitHub/GitLab.

---

## Table of contents

- [The 60-second mental model](#the-60-second-mental-model)
- [Quick start: your first feature + push](#quick-start-your-first-feature--push)
- [Everyday commands](#everyday-commands)
- [Starting a repo (clone / adopt an existing Git repo)](#starting-a-repo-clone--adopt-an-existing-git-repo)
- [Core workflow: edit → describe → commit](#core-workflow-edit--describe--commit)
- [Bookmarks (jj “branches”)](#bookmarks-jj-branches)
- [Syncing with upstream (jj’s “pull”)](#syncing-with-upstream-jjs-pull)
- [Publishing (push) workflows](#publishing-push-workflows)
- [Addressing review comments (add commits vs rewrite)](#addressing-review-comments-add-commits-vs-rewrite)
- [Rewrite power moves (squash / split / absorb)](#rewrite-power-moves-squash--split--absorb)
- [Revsets (select commits)](#revsets-select-commits)
- [Filesets (select files)](#filesets-select-files)
- [Recovery: undo and operation log](#recovery-undo-and-operation-log)
- [Starter config + quality-of-life settings](#starter-config--quality-of-life-settings)
- [Common gotchas](#common-gotchas)

---

## The 60-second mental model

- `@` is your **working copy commit** (what you’re editing).
- `@-` is the **parent** of the working copy (often the last “real” commit you made).
- jj loves keeping the working copy **empty** and putting your actual work at `@-` (you’ll see this pattern in the GitHub workflow docs).  
  :contentReference[oaicite:0]{index=0}
- **Bookmarks** are jj’s branch-like names. They **don’t automatically move** when you create new commits; you move them explicitly.  
  :contentReference[oaicite:1]{index=1}

---

## Quick start: your first feature + push

> Replace `main` with your trunk bookmark (often `main` or `master`), and `origin` with your remote if needed.

```bash
# 1) Start a fresh change off trunk
jj new main

# 2) Edit files
$EDITOR .

# 3) Review + commit (this also creates a new empty working copy on top)
jj diff
jj commit -m "feat: add thing"

# 4) Name it (bookmark points at @- because @ is empty)
jj bookmark create my-feature -r @-

# 5) Track + push
jj bookmark track my-feature
jj git push
