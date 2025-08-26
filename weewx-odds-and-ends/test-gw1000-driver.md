
Quick note for how to interactively test the GW1000 (aka ecowitt) driver.  This shows how to set PYTHONPATH for interactive testing.

````

# for venv installations
source ~/weewx-venv/bin/activate
python3 ~/weewx-data/bin/user/gw1000.py --test-driver --ip-address=192.168.2.87

# for dpkg installations
PYTHONPATH=/etc/weewx/bin:/usr/share/weewx python3 -m user.gw1000 --test-driver --ip-address=192.168.2.87

````

