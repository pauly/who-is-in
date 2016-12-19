# Who Is In?

Uses `arp-scan` to see who is on the network.
Outputs something like this to publish as a a webpage or whatever.
Got the idea from an article in The Magpi: https://www.raspberrypi.org/magpi/wifi-detector/
This is probably caning my network.

```
❌ 📺  TV since 08:16
❌ 💻  PC since 08:55
❌ ☎  Clare since 08:59
✓ 📺  HUMAX
✓ 💻  Macbook
✓ 🌡  Thermostat
✓ ☎  Paul
```
Don't make it public...

Creates a file for each MAC address it finds. If you want to rename the device save the name as `.alias.[the mac address].txt` in the same folder.

Requires `arp-scan` so `sudo apt-get install arp-scan`

Set up cron jobs to make it useful:
```
# every 5 minutes report on who is connected to the home network (so probably in)
*/5 7-19 * * * sudo /home/pi/who-is-in/scan > /tmp/scan.html && /bin/mv /tmp/scan.html /var/www/scan.html

# upload the results to a website
*/5 * * * * /usr/bin/scp /var/www/scan.html user@website.com:/var/www/private/scan.html

# on monday if paul is in in the day, play some music
*/10 9-17 * * 1 /home/pi/who-is-in/status paul && mpc play
```
