
=======================================================================
Snippets to add bme280 support to weewx, generally for something like
running rtldavis+bme280 rather than using a hard-connected datalogger.
=======================================================================

(these instructions are for a waveshare bme280 card)

Wire it up per the vendor instructions at:
  https://www.waveshare.com/wiki/BME280_Environmental_Sensor
or
  https://pypi.org/project/RPi.bme280

Follow the instructions on the pypi.org page until you run 
"i2cdetect -y 1" to verify your board is i2c which is 0x77 per
the pypi.org link above.

For a Waveshare BME280 the wiring setup for i2c is:
Green  = CS         = not connected
Orange = ADDR/MISO  = not connected
Yellow = SCL/SCK    = SCL   (pin 5)
Blue   = SDA/MOSI   = SDA   (pin 3)
Black  = GND        = GND   (pin 6)
Red    = VCC        = 3.3V  (pin 1)

On the pi5, even pins are outboard with pin2 furthest from the 
RJ45 connector so the connections are:

 -----------------------------------------------------
 |        3V3 =>                RED  x               |
 |        SDA =>               BLUE  x               |
 |        SCL =>             YELLOW  BLACK  <= GND   |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                x  x               |
 |                                                   |
 |                                                   |
 | (RJ45)           (USB)         (USB)              |
 -----------------------------------------------------


Then install simply install the upstream driver ala:
  weectl extension install -y \
       https://gitlab.com/wjcarpenter/bme280wx/-/archive/master/bme280wx-master.zip

Make sure your weewx.conf is set up to match the hex address of the card
which for i2c should be 0x77.  Note that the extension default differs,
so you'll need to edit one line in weewx.conf set the i2c_address correctly.

Your weewx venv pip list will include:

(weewx-venv) pi@pi5:~ $ pip3 list
Package    Version
---------- -----------
bme280     0.7          <==== I 'think' this gets autoinstalled
configobj  5.0.8
CT3        3.3.3.post1
ephem      4.1.5
pillow     10.2.0
pip        23.0.1
PyMySQL    1.1.0
pyserial   3.5
pytz       2024.1
pyusb      1.2.1
RPi.bme280 0.2.4        <==== rpi libs for bme280 installed per upstream docs
setuptools 66.1.1
six        1.16.0
smbus      1.1.post2
smbus2     0.4.3
weewx      5.0.2
wheel      0.43.0

And your weewx extension list will include:

(weewx-venv) pi@pi5:~ $ weectl extension list
Using configuration file /home/pi/weewx-data/weewx.conf
Extension Name    Version   Description
bme280wx          1.0       Add bme280 sensor readings to loop packet data

Note - the weewx.conf snippet assumes you 'have' an external sensor
that provides the must_have reading(s), which would be the case if you
are 'also' running the rtldavis driver successfully.  You might need to
tweak the must_have settings for your configuration if that's not the case.
Be sure to follow the instructions on the bme280wx web page for details.
If you set pressureKeys = pressure, then weewx will do the altitude correction
into its barometer data element most skins want.


Short description is take the defaults, fix i2c_address in weewx.conf,
and go for it.


------------------- for dpkg installations --------------------
For a weewx dpkg installation you might need to 'apt install python3-bme280'
and the resulting pip3 list will look something like the following.  This example below
is from a vagrant VM so your list might likely vary....

vagrant@bookworm:~$ pip3 list
Package             Version
------------------- -----------
certifi             2022.9.24
chardet             5.1.0
charset-normalizer  3.0.1
configobj           5.0.8
CT3                 3.3.1
dbus-python         1.3.2
distro-info         1.5+deb12u1
ephem               4.1.4
httplib2            0.20.4
idna                3.3
olefile             0.46
Pillow              9.4.0
pip                 23.0.1
pycurl              7.45.2
pyparsing           3.0.9
pyserial            3.5
PySimpleSOAP        1.16.2
python-apt          2.6.0
python-debian       0.1.49
python-debianbts    4.0.1
pytz                2022.7.1
pyusb               1.2.1.post2
reportbug           12.0.0
requests            2.28.1
RPi.bme280          0.2.4
setuptools          66.1.1
six                 1.16.0
smbus2              0.4.2
unattended-upgrades 0.1
urllib3             1.26.12
wheel               0.38.4
