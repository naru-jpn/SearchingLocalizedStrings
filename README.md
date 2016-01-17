SearchingLocalizedStrings
===

Ruby script to search localized string keys using in .m files.

## Description

This script searches localized string keys contained in .m file. (So still obj-c only...)

## Usage

```
ruby (path to searchingLocalizedStrings.rb)
```

In the directory containing your project codes. The script searches all .m files at current directory and sub directory.

## Output

Output file (default name is 'outputs.txt') is created if any localized string keys. Output file has below form.

```

"key1" = "comment of key1"

"key2" = "comment of key2"

"key3" = "comment of key3"

...
```

