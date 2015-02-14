android-misc
============
Android utility scripts that I use

checkpoint
----------

A script to a revert to a 'saved' list of installed apps.

1. `ruby checkpoint.rb --save`
2. Install a bunch of crappy apps you want to test out.
3. `ruby checkpoint.rb --restore` to restore back to previous saved state of installed apps.

phone2jar
---------

Quickly pull apks from your phone and convert to jars for reading

1. `ruby phone2jar.rb --search="foo"`
