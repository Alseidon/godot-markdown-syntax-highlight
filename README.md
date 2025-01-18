# Markdown syntax highlight for Godot
Work in progress; markdown syntax higlight for the Godot editor.

EDIT: this was a fun project, but basically overshadowed by
[this pull](https://github.com/godotengine/godot/pull/78312), which will add
most Markdown natively. Still a fun project, I will let the repo open for archiving purposes.

## How to use
1. Download and move `addons/md_syntax_highlight` to the `res://addons/` folder of
your project.
2. Enable the addon "Markdown Syntax Highlight" in `Project -> Project Settings -> Plugins`.

3. With any text file of your choice opened, change the syntax highlight
in `Edit -> Syntax Highlighter` to "Markdown".

## Currently supported
Currently, I can only change the colors (so no underline, strikethrough etc.).
- Headings 1 to 6 (three colors cycling)
- Lists (with `+`, `-`, `*`, or number+`.` or `)`)
- Quotes (with `>`)
- Emphasis and strong emphasis (with single or double `_` or `*`)
- Code (with `\``)
- Escapes : _here are \* and \_ in an emph_ (written \\\* and \\\_)
- Links (with [] and ())