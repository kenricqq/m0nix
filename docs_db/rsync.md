# Basic Usage

## Push Data to Remote Host

```sh
rsync file.txt lan-mac:
```

- ':' denotes remote, else refers local path
- add path after ':' to specify directory, else '~' by default
  - e.g. `rsync file.txt lan-mac:~/Downloads`

## Pull Data from Remote

```sh
rsync lan-mac:~/file.txt .
```

## Tips

```sh
rsync -av
```

- '-a' = archive (keeps permissions, timestamps)
- '-v' = verbose
- '-h' = output numbers in a human-readable format
- '-P' = same as --partial --progress
- '--delete-after' = explicit delete of files on backup server after transfer
  - by default, deleting on main machine keeps the copy on the backup server
    - i.e. accidental delete on main computer (running rsync won't auto delete it)
  - '--delete-after' allows interrupting transfer if you didn't mean to delete a file
- '--exclude=PATTERN' / '--exclude-from=FILE'
- '-u' = update (skip files that are newer on the receiver)
  - useful for multiple people on one machine (respects the newer changes, no overwrite)
- careful with '/', rsync follows bsd trailing slash convention, which will transfer file individually, so the directory isn't created

## Daily Backup with ssh

```sh
rsync -a --delete --quiet -e ssh /path/to/backup remoteuser@remotehost:/location/of/backup
```

- careful with "--delete"
