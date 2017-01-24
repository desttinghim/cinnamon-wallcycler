# Wall Cycler

I recently installed Debian with the Cinnamon desktop and wanted to set up a
a slideshow of wallpapers. Much to my chagrin, there was no option to do so
in the version of Cinnamon that had been installed! Instead of taking forever
to figure out how to install a newer version of Cinnamon, I wrote this script.

Run `haxe release.hxml` to build the end result, and then copy the `Main`
executable in the wallcycler to somewhere in your path. Rename it to 
`wallcycler` in the process. Use Cinnamon's `Startup Applications` settings
to execute it when you login.