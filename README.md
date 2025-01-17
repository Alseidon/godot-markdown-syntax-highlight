# Markdown syntax highlight for Godot
Work in progress; markdown syntax higlight for the Godot editor.

## How to use
1. Download and move `addons/md_syntax_highlight` to the `res://addons/` folder of
your project. (At some point I will maybe register this in the Godot asset library. Maybe.)

2. Enable the addon "Markdown Syntax Highlight" in `Project -> Project Settings -> Plugins`.

3. With any text file of your choice opened, change the syntax highlight
in `Edit -> Syntax Highlighter` to "Markdown".

## Currently supported
Currently, I can only change the colors (so no underline, strikethrough etc.).

- Headings 1 to 6 (three colors cycling)
- Lists (with `+`, `-`, `*`, or number+`.` or `)`)
- Quotes (with `>`)
- Emphasis and strong emphasis (with single or double `_` or `*`)
- Code (with ```)

## It works!
![Isn't this beautiful?](screenshots/it_works.png)

## ... not always
![Still a WiP after all.](screenshots/still_wip.png)
(this is handled by the way. But you get the meaning, plenty of bugs)
