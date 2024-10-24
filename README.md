# tree
This is my implementation of the tree utility written in Bash. Made for educational purposes.

It displays the structure of the specified directory and its subdirectories as a tree.

**Usage:**

```
bash tree.sh [OPTIONS] <PATH>
```

or

```
chmod +x ./tree.sh
./tree.sh [OPTIONS] <PATH>
```

**Options:**

`-h`, `--help` - displays help.

`-t`, `--top` - displays only top-level files and directories, like `ls`. Don't go into subdirectories.

`-d <N>`, `--depth <N>` - specifies the maximum depth for recursion. Don't go into directories deeper than `N` levels from `PATH`.

`-l <N>`, `--limit <N>` - don't display files in directories with more than `N` entries. Displays `... (hidden files count)` instead.
