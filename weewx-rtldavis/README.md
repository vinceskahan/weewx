
## Scripted install of weewx using the rtldavis driver

FWIW, I found the rtldavis installation repos and instructions very difficult to follow,
and there are many pieces downloaded throughout the installation procedure from other
upstream repositories.  Furthermore, there are edits needed if you a a US user.

Usage - if you set the variables at the top of the script to '1' it will run that block.  Set to '0' or comment out to suppress running that block of code.  Hopefully it should be reasonably obvious.

Contents:
=========

* install-weewx-rtldavis.sh - script that installs everything
* src.tgz - sources for the pieces of the puzzle

Installation Notes:
===================

* Copy the two pieces to your ${HOME}
* then run 'bash install-weewx-rtldavis.sh'

Note - the script does call sudo for installing things into /usr/local/bin, so you will need sudo to remove the src tree(s) afterward

Other notes:
============

 - this requires that you run v5 via the 'pip' installation mechanism as user 'pi'
       with home directory /home/pi. I will not support alternate weewx installation types.

 - each set of steps has its individual INSTALL_XYZ variable at the top of the script
      so you can run them step-by-step.  I would highly recommend doing this rather than
      setting them all to '1' and running them all in one blast (and hoping).

       If you set everything = 1 and something in the middle blows up, it is entirely
       probable that following steps will fail too.  Simplest thing to do is to 'tee' your
       runs ala 'bash install-weewx-rtldavis.sh | tee /tmp/debug.txt 2>&1'

 - the default weewx.conf that this installs has 'very' (like 'VERY') verbose
       logging enabled for rtldavis.  You'll almost certainly want to dial that
       back after you get things working.  See the driver section in weewx.conf
       for details.   Everything is installed into /usr/local/bin now.

Python Version Notes:
=====================

 - I've patched Luc's rtldavis.py driver to remove python deprecation warnings that
      appear now in current python versions.  The original file is present in the
      source tree as rtldavis.py.dist just in case. Running the original version seems
      to work, although python complains with warnings.  This seems to have appeared
      in the debian 13 version of python.  Previous versions did not throw these warnings.


