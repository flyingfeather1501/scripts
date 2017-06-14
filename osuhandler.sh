#!/bin/bash
# pass all arguments to osu!.exe
export WINEPREFIX=$HOME/.local/share/wineprefixes/osu/
export OSUDIR=$HOME/.local/share/wineprefixes/osu/drive_c/users/flyin1501/Local\ Settings/Application\ Data/osu!/
wine $OSUDIR/osu\!.exe $@
