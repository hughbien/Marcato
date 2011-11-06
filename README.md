Description
===========

Marcato is a lightweight command line music player for iTunes playlists.

It's still alpha quality software.  Right now it's a thin wrapper around
`afplay`.

Installation
============

    % gem install marcato

Usage
=====

First, you'll need to sync marcato with your iTunes playlist.

    % marcato --sync

Play a song by giving a song or artist name.  If there's any ambiguity, marcato
will ask for clarification:

    % marcato "Muse"
    1. Muse - Super Massive Black Hole
    2. Muse - Starlight
    > 1

Leave it blank to play all matches.  This works with playlists too:

    % marcato "Top 25"

To pause and unpause:

    % marcato -p

To stop completely:

    % marcato --stop

Skip forwards/backwards along the playlist:

    % marcato --forward
    % marcato --backward

Repeat your favorites or randomize your lists:

    % marcato --random --repeat "Top 25"

License
=======

Copyright 2011 Hugh Bien - http://hughbien.com.
Released under MIT License, see LICENSE.md for more info.
