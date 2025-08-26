
## overlaying current conditions on the pi

This is a little complicated because the weewx system is so old that I can't get all the ImageMagick prerequisites/corequisites onto it easily, so we do a little sleight of hand via multiple cron jobs to send files back+forth.  Ugly but it works.

* the vds-local skin has 'current.html.tmpl' which writes a simple string that will be overlaid
* a cron job on the weewx system copies this file up to the 'pi' raspi which has ImageMagick and the webcam
* the pi with the camera and ImageMagick runs a script via cron to overlay the conditions over the image
* another cron job on the weewx system scp's the modified image back to the weewx web docroot

### crontab on debian

```

# copy up the current temps to 'pi' so it can overlay data on the webcam image
* * * * * scp /home/weewx/public_html/current.html pi:/mnt/ramdisk/current.html

# periodically scp the image back from the webcam 'pi'
1,6,11,16,21,26,31,36,41,46,51,56 * * * * scp pi:/mnt/ramdisk/motion/image-overlaid.jpg /home/weewx/public_html/webcam.jpg

```

### crontab on pi

```
* * * * * /root/bin/overlay-image.sh
```

### current.html.tmpl on the weewx system
```
current=$current.outTemp.raw F   max/min = $day.outTemp.max.raw / $day.outTemp.min.raw   rain = $day.rain.sum.format("%.2f")
```

