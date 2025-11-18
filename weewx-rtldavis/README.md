
## Scripted install of weewx using the rtldavis driver

FWIW, I found the rtldavis installation repos and instructions very difficult to follow,
and there were also some errors for current raspi os debian-11 versions as well as edits
needed if you are a US user.   This script worked for me.

The key is pinning your go version to < 1.16 due to breaking changes from the go project
upstream.  Luc's instructions are written to the <= 1.15 versions of go.

Pointers to the reference documents and commentary for what I changed vs. those
instructions is in the code.

Usage - if you set the variables at the top of the script to '1' it will run that block. 
  Set to '0' or comment out to suppress running that block of code.  
  Hopefully it should be reasonably obvious.

Installation Notes:
===================

This 'really' assumes it is running in a pip installation in /home/pi on a Raspberry Pi
and will throw some errors during extension installation if you try to run as a different user.
In that case you should verify the [Rtldavis] section in weewx.conf and especially the 
'cmd' line at the top of that section.

I tried to fake it in a vagrant installation by symlinking /home/pi -> /home/vagrant
and that got everything installed, but the "cmd = " line in weewx.conf still needed
hand editing for me (vagrant debian13 using weewx 5.2.0)

I did not see this when running successfully on an actual raspberry pi with weewx 5.1.0
but I cannot recall anymore if that was a debian12 or debian13 based os at that time.


Notes:
======
 - this assumes you run v5 via the 'pip' installation mechanism.
       I'm not planning to support the dpkg variant with this repo.

 - the 'install weewx' variable calls a different standalone script that
       installs and configures nginx and integrates the two. Again this
       does the 'pip' installation method for weewx.

       If you have never run this, I'd strongly recommend that you run this
       script multiple times in steps, setting only one item = 1 in the variables
       at the top of the file.  Do it step-by-step one piece at a time.  It will help
       you in debugging.

       If you set everything = 1 and something in the middle blows up, it is entirely
       probable that following steps will fail too.

 - code assumes it is run as user 'pi' on a raspi of course, which is
       hardcoded throughout.  You can set variable WEEUSER in the script
       to set it to another user

 - since go1.15 is no longer available in debian12 default repos, this script
       now installs a 'local' copy of go under /home/${WEEUSER}/go/bin and also
       installs rtldavis there.

 - the default weewx.conf that this installs has 'very' (like 'VERY') verbose
       logging enabled for rtldavis.  You'll almost certainly want to dial that
       back after you get things working.  See the driver section in weewx.conf
       for details.

