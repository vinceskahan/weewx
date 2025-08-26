# https://stackoverflow.com/questions/40880237/how-to-add-bottom-box-and-text-to-a-picture-in-linux

MSG=`cat /mnt/ramdisk/current.html`
convert /mnt/ramdisk/motion/image.jpg -alpha on                                    \
  \( +clone -scale x5% -threshold 101% -channel A -fx "0.5" \) \
  -gravity north -composite                                     \
  -fill white -pointsize 18 -annotate 0,0 "${MSG}" /mnt/ramdisk/motion/image-overlaid.jpg
