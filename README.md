# Skylanders-Scripts
Scripts for a proxmark3 running [iceman](https://github.com/RfidResearchGroup/proxmark3) to easily dump and modify the contents of skylanders.

------

There are currently 2 scripts, of which you need both. The first, `skylanders.lua` does most of the work, and `skylanders_util.py` does some helpful bits on the side like generating the KEYAs for the toys, since lua can have a harder time dealing with the numbers.

There is currently only support for dumping the keyed binary of figures (binary that is ready to be loaded to a magic card). I somewhat plan on adding support for converting unkeyed binaries to keyed binaries, and modifying the data (such as gold or level) thats on a skylander at some point.

------

Couldn't find alot of resources for doing this with a proxmark[^1] so I started working on it myself. More features might be slowly added.

[^1]: All resources I could find seem to use an ACR122U. I think this originally came from [one of the most comprehensive docs](https://marijnkneppers.dev/posts/reverse-engineering-skylanders-toys-to-life-mechanics/) using the ACR122U, and as such there is literally no advantage for using it over a proxmark.
