Description
===========

Marcato is a playlist manager for use with `mplayer`.

Installation
============

    % gem install marcato

Usage
=====

First, set any options in your `.bashrc` or `.zshrc`:

    export MARCATO_MUSIC="/path/to/music"
    export MARCATO_FILE="/path/to/.marcato" # defaults to ~/.marcato
    export MARCATO_OPTS="--random"          # optional

Playlists can be made on the fly via searching:

    % marcato muse
    muse_super-massive-black-hole.mp3
    muse_starlight.mp3
    % mplayer -playlist <(marcato muse)

Playlists are just yaml, each line is a search term:

    % marcato --edit
    top-songs:
      - muse
      - beatles

    jazz:
      - coltrane
      - jazz-mafia

Access your playlist just like searching for a song.  Marcato accepts multiple
terms/playlists:

    % marcao jazz beatles

By default, the order of songs is alphabetical.  Use the `--random` flag to
shuffle:

    % marcato --random jazz

List out playlists with `--list`:

    % marcato --list
    jazz
    top-songs

License
=======

Copyright (c) Hugh Bien - http://hughbien.com.
Released under BSD License, see LICENSE.md for more info.
